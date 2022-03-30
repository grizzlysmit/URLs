package Urls;
#
#===============================================================================
#
#         FILE: Urls.pm
#
#  DESCRIPTION: 
#
#        FILES: ---
#         BUGS: ---
#        NOTES: ---
#       AUTHOR: Francis Grizzly Smit (FGJS), grizzly@smit.id.au
# ORGANIZATION: 
#      VERSION: 1.0
#      CREATED: 2022-03-20 22:57:02
#     REVISION: ---
#===============================================================================

use strict;
use warnings;
use v5.32.1;
use Scalar::Util qw(blessed dualvar isweak readonly refaddr reftype tainted
                        weaken isvstring looks_like_number set_prototype);
use Apache2::RequestRec;
use Apache2::Request;
use Digest::MD5;
use Apache2::Cookie;
use Data::Dumper;
use FileHandle;
use Apache::Session::Postgres;
use Config::IniFiles;
use Class::Std::Utils;
use JSON;
use JSON::XS;
use File::Basename;
use DBI;

{
    my %logpaths;
    my %db_handle;
    my %debug;
    my %logfiles;
    my %PAGES;

    
    sub new {
        my ($class, $logpath, $cfg) = @_;
        #
        # make the actual object a so called blessed scalar #
        # slightly quirky but it works :)                   #
        my $new_object = bless anon_scalar(), $class;

        # get the instances idnet for referencing it's data #
        my $ident = ident $new_object;

        $logpaths{$ident} = $logpath;

        $PAGES{$ident} = [
            { href => 'index.pl', name => 'home page', fun => 'main', }, 
            { href => 'list-aliases.pl', name => 'list aliases', fun => 'list_aliases', }, 
            { href => 'add-alias.pl', name => 'add alias', fun => 'add_alias', }, 
            { href => 'add-link.pl', name => 'add link', fun => 'add_link', }, 
            { href => 'add-page.pl', name => 'add page', fun => 'add_page', }, 
            { href => 'add-pseudo-page.pl', name => 'add pseudo-page', fun => 'add_pseudo_page', }, 
            { href => 'delete-links.pl', name => 'delete links', fun => 'delete_links', }, 
            { href => 'delete-pages.pl', name => 'delete pages', fun => 'delete_pages', }, 
            { href => 'delete-pseudo-page.pl', name => 'delete pseudo-page', fun => 'delete_pseudo_page', }, 
            { href => 'delete-aliases.pl', name => 'delete aliases', fun => 'delete_aliases', }, 
        ];


        return $new_object;
    } ## --- end sub new
    
    sub debug_init {
        my ($self, $_debug, $_log) = @_;
        my $ident = ident $self;

        $debug{$ident} = $_debug;

        $logfiles{$ident} = $_log;
    } # sub debug_init #

    sub log {
        my $self = shift;
        my $ident = ident $self;
        return unless $debug{$ident};
        my ($sec, $min, $hour, $mday, $mon, $year, $wday, $yday, $isdst) = localtime(time);
        $year += 1900;
        $mon++;
        my $timestamp = sprintf "%04d-%02d-%02dT%02d:%02d:%02d\t", $year, $mon, $mday, $hour, $min, $sec;
        say {$logfiles{$ident}} $timestamp, @_; 
    } ## --- end sub log

    sub in_a_page {
        my ($self, $section, $db) = @_;
        my $query  = $db->prepare('SELECT COUNT(*) n FROM page_view pv WHERE pv.section = ?');
        my $result = $query->execute($section);
        my $r      = $query->fetchrow_hashref();
        my $n      = $r->{n};
        return $n;
    }


    sub main {
        my ($self, $req, $cfg, $rec) = @_;
        my $ident           = ident $self;
        my $debug = $debug{$ident};

        my $dbserver        = $cfg->val('urls_db', 'dbserver');
        my $dbuser          = $cfg->val('urls_db', 'dbuser');
        my $dbpass          = $cfg->val('urls_db', 'dbpass');
        my $dbname          = $cfg->val('urls_db', 'dbname');
        my $dbport          = $cfg->val('urls_db', 'dbport');
        #my $db              = DBI->connect("dbi:Pg:database=$dbname;host=$dbserver;port=$dbport;", "$dbuser", "$dbpass", {'RaiseError' => 1});
        #return 0;
        my $db              = DBI->connect("dbi:Pg:database=$dbname;host=$dbserver;port=$dbport;", "$dbuser", "$dbpass", {AutoCommit => 1, 'RaiseError' => 1});

        my %session;

        my $id = $self->get_id($req, $cfg, $rec);
        if($id){
            $self->log('[', __LINE__, "] ", Data::Dumper->Dump([$id], [qw(id)]));
            tie %session, 'Apache::Session::Postgres', $id, {
                Handle => $db,
                TableName => 'sessions', 
                Commit     => 1
            };
        }else{
            tie %session, 'Apache::Session::Postgres', undef(), {
                Handle => $db,
                TableName => 'sessions', 
                Commit     => 1
            };
            $self->set_cookie("SESSION_ID=$session{_session_id}", $cfg, $rec);
        }

        my $current_page    = $req->param('page');
        $self->log(Data::Dumper->Dump([$current_page], [qw(current_page)]));
        $current_page       = $session{current_page} if (!defined $current_page || $current_page =~ m/^\s*$/) && exists $session{current_page};
        $self->log(Data::Dumper->Dump([$current_page], [qw(current_page)]));
        $current_page       = 'pseudo-page^all' if !defined $current_page || $current_page =~ m/^\s*$/;
        my $current_section = $req->param('section');
        $current_section    = $session{current_section} if !defined $current_section && exists $session{current_section};
        $current_section = 'all_sections' if !defined $current_section;
        $self->log(Data::Dumper->Dump([$current_page, $current_section], [qw(current_page current_section)]));
        $session{current_page}    = $current_page    if defined $current_page;
        $session{current_section} = $current_section if defined $current_section;
        my $sql             = "SELECT * FROM pagelike pl\n";
        $sql               .= "ORDER BY pl.name, pl.full_name\n";
        my $query           = $db->prepare($sql);
        my $result          = $query->execute();
        $self->log(Data::Dumper->Dump([$query, $result, $sql], [qw(query result sql)]));
        my @pages;
        my $r               = $query->fetchrow_hashref();
        $self->log(Data::Dumper->Dump([$query, $result, $r], [qw(query result r)]));
        while($r){
            push @pages, $r;
            $r           = $query->fetchrow_hashref();
            $self->log(Data::Dumper->Dump([$query, $result, $r], [qw(query result r)]));
        }
        $query->finish();
        my @body;
        $self->log(Data::Dumper->Dump([$current_page, $current_section], [qw(current_page current_section)]));
        if($current_section =~ m/^alias\^(.*)$/){
            $sql  = "SELECT a.section FROM aliases a\n";
            $sql .= "WHERE a.name = ?\n";
            $query  = $db->prepare($sql);
            $result = $query->execute($1);
            $r      = $query->fetchrow_hashref();
            my $sec = $r->{section};
            $query->finish();
            $current_section = "links^$sec";
        }
        $self->log(Data::Dumper->Dump([$current_page, $current_section], [qw(current_page current_section)]));
        my @sections;
        $sql  = "SELECT al.type, al.section FROM alias_links al\n";
        $sql .= "ORDER BY al.section\n";
        $query           = $db->prepare($sql);
        $result          = $query->execute();
        $r                  = $query->fetchrow_hashref();
        while($r){
            push @sections, $r;
            $r           = $query->fetchrow_hashref();
        }
        $query->finish();
        if($current_page =~ m/^pseudo-page\^(.*)/){
            my $pp = $1;
            if($current_section =~ m/^links\^(.*)$/){
                my $secn = $1;
                $sql    = "SELECT pp.name \"page_name\", pp.full_name, ls.section, l.name, l.link, pp.status FROM pseudo_pages pp JOIN links_sections ls ON ls.section ~* pp.pattern JOIN links l ON l.section_id = ls.id\n";
                $sql   .= "WHERE pp.name = ? AND ls.section = ?\n";
                $sql   .= "ORDER BY pp.name, ls.section, l.name, l.link\n";
                $query  = $db->prepare($sql);
                $result = $query->execute($pp, $secn);
            }else{
                $sql    = "SELECT pp.name \"page_name\", pp.full_name, ls.section, l.name, l.link, pp.status FROM pseudo_pages pp JOIN links_sections ls ON ls.section ~* pp.pattern JOIN links l ON l.section_id = ls.id\n";
                $sql   .= "WHERE pp.name = ?\n";
                $sql   .= "ORDER BY pp.name, ls.section, l.name, l.link\n";
                $query  = $db->prepare($sql);
                $result = $query->execute($pp);
            }
            $r      = $query->fetchrow_hashref();
            while($r){
                my $page_name = $r->{page_name};
                my $full_name = $r->{full_name};
                my $section   = $r->{section};
                my $name      = $r->{name};
                my $link      = $r->{link};
                my $status    = $r->{status};
                next if $status eq 'invalid';
                next if $status eq 'unassigned' && $self->in_a_page($section, $db);
                next if $status eq 'assigned'   && !$self->in_a_page($section, $db);
                push @body, { page_name => $page_name, full_name => $full_name, section => $section, name => $name, link => $link, };
                $r  = $query->fetchrow_hashref();
            }
            $query->finish();
        }elsif($current_page =~ m/^page\^(.*)$/){
            my $pp = $1;
            if($current_section =~ m/^links\^(.*)$/){
                my $secn = $1;
                $sql  = "SELECT lv.page_name, lv.full_name, lv.section, lv.name, lv.link FROM page_link_view lv\n";
                $sql .= "WHERE lv.page_name = ? AND lv.section = ?\n";
                $sql .= "ORDER BY lv.page_name, lv.full_name, lv.section, lv.name, lv.link;\n";
                $query  = $db->prepare($sql);
                $result = $query->execute($pp, $secn);
            }else{
                $sql  = "SELECT lv.page_name, lv.full_name, lv.section, lv.name, lv.link FROM page_link_view lv\n";
                $sql .= "WHERE lv.page_name = ?\n";
                $sql .= "ORDER BY lv.page_name, lv.full_name, lv.section, lv.name, lv.link;\n";
                $query  = $db->prepare($sql);
                $result = $query->execute($pp);
            }
            $r      = $query->fetchrow_hashref();
            while($r){
                my $page_name = $r->{page_name};
                my $full_name = $r->{full_name};
                my $section   = $r->{section};
                my $name      = $r->{name};
                my $link      = $r->{link};
                push @body, { page_name => $page_name, full_name => $full_name, section => $section, name => $name, link => $link, };
                $r  = $query->fetchrow_hashref();
            }
            $query->finish();
        }else{
            # error
        }

        $self->links('main');
        say "        <form action=\"index.pl\" method=\"post\">";
        say "            <h1>Urls</h1>";
        my $page_length = $req->param('page_length');
        $page_length = $session{page_length} if !defined $page_length && exists $session{page_length};
        $page_length    = 25 if !defined $page_length || $page_length < 10 || $page_length > 180;
        $session{page_length} = $page_length;
        
        untie %session;
        $db->disconnect;

        say "            <label for=\"page_length\">Page Length:";
        say "                <input type=\"number\" name=\"page_length\" id=\"page_length\" min=\"10\" max=\"180\" step=\"1\" value=\"$page_length\" size=\"3\">";
        say "            </label>";
        say "            <table>";
        say "                <tr>";
        say "                    <td>";
        say "                        <select name=\"page\">";
        for my $page (@pages){
            my $type      = $page->{type};
            my $name      = $page->{name};
            my $full_name = $page->{full_name};
            if($current_page eq "$type^$name"){
                say "                            <option value=\"$type^$name\" selected>$full_name</option>";
            }else{
                say "                            <option value=\"$type^$name\">$full_name</option>";
            }
        }
        say "                        </select>";
        say "                    </td>";
        say "                    <td>";
        say "                        <select name=\"section\">";
        if(defined $current_section && $current_section ne 'all_sections'){
            say "                            <option value=\"all_sections\">All Sections</option>";
        }else{
            say "                            <option value=\"all_sections\" selected>All Sections</option>";
        }
        for my $section (@sections){
            my $type      = $section->{type};
            my $name      = $section->{section};
            if($current_section eq "$type^$name"){
                say "                            <option value=\"$type^$name\" selected>$type $name</option>";
            }else{
                say "                            <option value=\"$type^$name\">$type $name</option>";
            }
        }
        say "                        </select>";
        say "                    </td>";
        say "                    <td>";
        say "                        <input name=\"submit\" type=\"submit\" value=\"Apply Filter\">";
        say "                    </td>";
        say "                </tr>";
        say "                <tr><th>page name</th><th>section</th><th>link</th></tr>";
        my $cnt = 0;
        for my $bod (@body){
            $cnt++;
            say "                <tr>";
            my $section = $bod->{section};
            my $name    = $bod->{name};
            my $link    = $bod->{link};
            say "                    <td>$section</td>";
            say "                    <td>$name</td>";
            say "                    <td><a href=\"$link\" target=\"_blank\">$link</a></td>";
            say "                </tr>";
            if($cnt % $page_length == 0){
                say "                <tr><th>page name</th><th>section</th><th>link</th></tr>";
            }
        }
        say "                <tr>";
        say "                    <td>";
        if($debug){
            say "                        <input name=\"debug\" id=\"debug\" type=\"radio\" value=\"1\" checked><label for=\"debug\"> debug</label>";
            say "                    </td>";
            say "                    <td>";
            say "                        <input name=\"debug\" id=\"nodebug\" type=\"radio\" value=\"0\"><label for=\"nodebug\"> nodebug</label>";
        }else{
            say "                        <input name=\"debug\" id=\"debug\" type=\"radio\" value=\"1\"><label for=\"debug\"> debug</label>";
            say "                    </td>";
            say "                    <td>";
            say "                        <input name=\"debug\" id=\"nodebug\" type=\"radio\" value=\"0\" checked><label for=\"nodebug\"> nodebug</label>";
        }
        say "                    </td>";
        say "                    <td>";
        say "                        <input name=\"submit\" type=\"submit\" value=\"Apply Filter\">";
        say "                    </td>";
        say "                </tr>";
        say "            </table>";
        say "        </form>";
        return 1;
    } ## --- end sub main

    
    sub links {
        my ($self, $Fun) = @_;
        my $ident           = ident $self;
        my $debug = $debug{$ident};
        my @pages = @{$PAGES{$ident}};
        say "        <table>";
        say "            <tr>";
        my $cnt = 0;
        for my $page (@pages){
            my $href = $page->{href};
            my $name = $page->{name};
            my $fun  = $page->{fun};
            next if $fun eq $Fun;
            $cnt++;
            say "                <td>";
            #say "                    <a href=\"$href\" >$name</a>\n";
            say "                    <form action=\"$href\" method=\"post\" ><input name=\"$fun\" type=\"submit\" value=\"$name\" /></form>\n";
            say "                </td>";
            if($cnt % 5 == 0){
                say "            </tr>";
                say "            <tr>";
            }
        }
        say "            </tr>";
        say "        </table>";
        return ;
    } ## --- end sub links


    sub list_aliases {
        my ($self, $req, $cfg, $rec) = @_;
        my $ident           = ident $self;
        my $debug = $debug{$ident};
        $self->links('list_aliases');
        my $dbserver        = $cfg->val('urls_db', 'dbserver');
        my $dbuser          = $cfg->val('urls_db', 'dbuser');
        my $dbpass          = $cfg->val('urls_db', 'dbpass');
        my $dbname          = $cfg->val('urls_db', 'dbname');
        my $dbport          = $cfg->val('urls_db', 'dbport');
        #my $db              = DBI->connect("dbi:Pg:database=$dbname;host=$dbserver;port=$dbport;", "$dbuser", "$dbpass", {'RaiseError' => 1});
        #return 0;
        my $db              = DBI->connect("dbi:Pg:database=$dbname;host=$dbserver;port=$dbport;", "$dbuser", "$dbpass", {'RaiseError' => 1});
        my $sql  = "SELECT a.name, a.section FROM aliases a\n";
        $sql    .= "ORDER BY a.name\n";
        my $query           = $db->prepare($sql);
        my $result          = $query->execute();
        $self->log(Data::Dumper->Dump([$query, $result, $sql], [qw(query result sql)]));
        my @aliases;
        my $r               = $query->fetchrow_hashref();
        $self->log(Data::Dumper->Dump([$query, $result, $r], [qw(query result r)]));
        while($r){
            push @aliases, $r;
            $r           = $query->fetchrow_hashref();
            $self->log(Data::Dumper->Dump([$query, $result, $r], [qw(query result r)]));
        }
        $query->finish();
        $db->disconnect;
        say "        <h1>Aliases</h1>";
        say "        <table>";
        say "            <tr><th>alias</th><th>target section</th></tr>";
        for my $alias (@aliases){
            my $name    = $alias->{name};
            my $section = $alias->{section};
            say "            <tr>";
            say "                    <td>$name</td><td>$section</td>";
            say "            </tr>";
        }
        say "        </table>";
        return 1;
    } ## --- end sub list_aliases


    sub add_alias {
        my ($self, $req, $cfg, $rec) = @_;
        my $ident           = ident $self;
        my $debug = $debug{$ident};
        $self->links('add_alias');

        my $dbserver        = $cfg->val('urls_db', 'dbserver');
        my $dbuser          = $cfg->val('urls_db', 'dbuser');
        my $dbpass          = $cfg->val('urls_db', 'dbpass');
        my $dbname          = $cfg->val('urls_db', 'dbname');
        my $dbport          = $cfg->val('urls_db', 'dbport');
        #my $db              = DBI->connect("dbi:Pg:database=$dbname;host=$dbserver;port=$dbport;", "$dbuser", "$dbpass", {'RaiseError' => 1});
        #return 0;
        my $db              = DBI->connect("dbi:Pg:database=$dbname;host=$dbserver;port=$dbport;", "$dbuser", "$dbpass", {AutoCommit => 1, 'RaiseError' => 1});

        my %session;

        my $id = $self->get_id($req, $cfg, $rec);
        if($id){
            tie %session, 'Apache::Session::Postgres', $id, {
                Handle => $db,
                TableName => 'sessions', 
                Commit     => 1
            };
        }else{
            tie %session, 'Apache::Session::Postgres', undef(), {
                Handle => $db,
                TableName => 'sessions', 
                Commit     => 1
            };
            $self->set_cookie("SESSION_ID=$session{_session_id}", $cfg, $rec);
        }
        my $alias  = $req->param('alias');
        my $target = $req->param('target');

        $self->log(Data::Dumper->Dump([$alias, $target], [qw(alias target)]));
        if(defined $alias && defined $target && $alias =~ m/^(?:\w|-|\.|\@)+$/ && $self->valid_section($target, $db)){
            my $sql  = "INSERT INTO alias(name, target)VALUES(?, ?);\n";
            my $query           = $db->prepare($sql);
            $self->log(Data::Dumper->Dump([$alias, $target, $sql], [qw(alias target sql)]));
            my $result;
            eval {
                $result          = $query->execute($alias, $target);
            };
            if($@){
                say "Error: $@";
                return 0;
            }
            $self->log(Data::Dumper->Dump([$query, $result, $sql], [qw(query result sql)]));
            if($result){
                $sql  = "SELECT ls.section FROM links_sections ls\n";
                $sql .= "WHERE ls.id = ?\n";
                $query           = $db->prepare($sql);
                $result          = $query->execute($target);
                my $r               = $query->fetchrow_hashref();
                $self->log(Data::Dumper->Dump([$query, $result, $r], [qw(query result r)]));
                my $section      = $r->{section};
                say "Alias  defined: $alias => $section";
            }
            return 1;
        }

        my $sql             = "SELECT ls.id, ls.section FROM links_sections ls\n";
        $sql               .= "ORDER BY ls.section\n";
        my $query           = $db->prepare($sql);
        my $result          = $query->execute();
        $self->log(Data::Dumper->Dump([$query, $result, $sql], [qw(query result sql)]));
        my @sections;
        my $r               = $query->fetchrow_hashref();
        $self->log(Data::Dumper->Dump([$query, $result, $r], [qw(query result r)]));
        while($r){
            push @sections, $r;
            $r           = $query->fetchrow_hashref();
            $self->log(Data::Dumper->Dump([$query, $result, $r], [qw(query result r)]));
        }
        $query->finish();

        say "        <form action=\"add-alias.pl\" method=\"post\">";
        say "            <table>";
        say "                <tr>";
        say "                    <td>";
        say "                        <label for=\"alias\">Alias: </label>";
        say "                    </td>";
        say "                    <td colspan=\"2\">";
        say "                        <input type=\"text\" name=\"alias\" id=\"alias\"/>";
        say "                    </td>";
        say "                </tr>";
        say "                <tr>";
        say "                    <td>";
        say "                        <label for=\"target\">Target: </label>";
        say "                    </td>";
        say "                    <td colspan=\"2\">";
        say "                        <select name=\"target\" id=\"target\">";
        for (@sections){
            my $section = $_->{section};
            my $target  = $_->{id};
            say "                            <option value=\"$target\">$section</option>";
        }
        say "                        </select>";
        say "                    </td>";
        say "                </tr>";
        say "                <tr>";
        say "                    <td>";
        if($debug){
            say "                        <input name=\"debug\" id=\"debug\" type=\"radio\" value=\"1\" checked><label for=\"debug\"> debug</label>";
            say "                    </td>";
            say "                    <td>";
            say "                        <input name=\"debug\" id=\"nodebug\" type=\"radio\" value=\"0\"><label for=\"nodebug\"> nodebug</label>";
        }else{
            say "                        <input name=\"debug\" id=\"debug\" type=\"radio\" value=\"1\"><label for=\"debug\"> debug</label>";
            say "                    </td>";
            say "                    <td>";
            say "                        <input name=\"debug\" id=\"nodebug\" type=\"radio\" value=\"0\" checked><label for=\"nodebug\"> nodebug</label>";
        }
        say "                    </td>";
        say "                    <td>";
        say "                        <input name=\"submit\" type=\"submit\" value=\"OK\">";
        say "                    </td>";
        say "                </tr>";
        say "            </table>";
        say "        </form>";

        untie %session;
        $db->disconnect;

        return 1;
    } ## --- end sub add_alias


    sub valid_section {
        my ($self, $target, $db) = @_;
        my $ident           = ident $self;
        $self->log("start valid_section");
        $self->log(Data::Dumper->Dump([$target, $db], [qw(target db)]));
        my $debug = $debug{$ident};
        return 0 if $target !~ m/^\d+$/;
        my $sql             = "SELECT COUNT(*) n FROM links_sections ls\n";
        $sql               .= "WHERE ls.id = ?\n";
        my $query           = $db->prepare($sql);
        my $result          = $query->execute($target);
        $self->log(Data::Dumper->Dump([$query, $result, $sql], [qw(query result sql)]));
        my $r               = $query->fetchrow_hashref();
        $self->log(Data::Dumper->Dump([$query, $result, $r], [qw(query result r)]));
        my $n               = $r->{n};
        $self->log("end valid_section");
        return $n;
    } ## --- end sub valid_section


    sub add_page {
        my ($self, $req, $cfg, $rec) = @_;
        my $ident           = ident $self;
        my $debug = $debug{$ident};
        $self->links('add_page');

        my $dbserver        = $cfg->val('urls_db', 'dbserver');
        my $dbuser          = $cfg->val('urls_db', 'dbuser');
        my $dbpass          = $cfg->val('urls_db', 'dbpass');
        my $dbname          = $cfg->val('urls_db', 'dbname');
        my $dbport          = $cfg->val('urls_db', 'dbport');
        #my $db              = DBI->connect("dbi:Pg:database=$dbname;host=$dbserver;port=$dbport;", "$dbuser", "$dbpass", {'RaiseError' => 1});
        #return 0;
        my $db              = DBI->connect("dbi:Pg:database=$dbname;host=$dbserver;port=$dbport;", "$dbuser", "$dbpass", {AutoCommit => 1, 'RaiseError' => 1});

        my %session;

        my $id = $self->get_id($req, $cfg, $rec);
        if($id){
            tie %session, 'Apache::Session::Postgres', $id, {
                Handle => $db,
                TableName => 'sessions', 
                Commit     => 1
            };
        }else{
            tie %session, 'Apache::Session::Postgres', undef(), {
                Handle => $db,
                TableName => 'sessions', 
                Commit     => 1
            };
            $self->set_cookie("SESSION_ID=$session{_session_id}", $cfg, $rec);
        }

        untie %session;
        $db->disconnect;

        return 1;
    } ## --- end sub add_page


    sub add_link {
        my ($self, $req, $cfg, $rec) = @_;
        my $ident           = ident $self;
        my $debug = $debug{$ident};
        $self->links('add_link');

        my $dbserver        = $cfg->val('urls_db', 'dbserver');
        my $dbuser          = $cfg->val('urls_db', 'dbuser');
        my $dbpass          = $cfg->val('urls_db', 'dbpass');
        my $dbname          = $cfg->val('urls_db', 'dbname');
        my $dbport          = $cfg->val('urls_db', 'dbport');
        #my $db              = DBI->connect("dbi:Pg:database=$dbname;host=$dbserver;port=$dbport;", "$dbuser", "$dbpass", {'RaiseError' => 1});
        #return 0;
        my $db              = DBI->connect("dbi:Pg:database=$dbname;host=$dbserver;port=$dbport;", "$dbuser", "$dbpass", {AutoCommit => 1, 'RaiseError' => 1});

        my %session;

        my $id = $self->get_id($req, $cfg, $rec);
        if($id){
            tie %session, 'Apache::Session::Postgres', $id, {
                Handle => $db,
                TableName => 'sessions', 
                Commit     => 1
            };
        }else{
            tie %session, 'Apache::Session::Postgres', undef(), {
                Handle => $db,
                TableName => 'sessions', 
                Commit     => 1
            };
            $self->set_cookie("SESSION_ID=$session{_session_id}", $cfg, $rec);
        }

        untie %session;
        $db->disconnect;

        return 1;
    } ## --- end sub add_link


    sub add_pseudo_page {
        my ($self, $req, $cfg, $rec) = @_;
        my $ident           = ident $self;
        my $debug = $debug{$ident};
        $self->links('add_pseudo_page');

        my $dbserver        = $cfg->val('urls_db', 'dbserver');
        my $dbuser          = $cfg->val('urls_db', 'dbuser');
        my $dbpass          = $cfg->val('urls_db', 'dbpass');
        my $dbname          = $cfg->val('urls_db', 'dbname');
        my $dbport          = $cfg->val('urls_db', 'dbport');
        #my $db              = DBI->connect("dbi:Pg:database=$dbname;host=$dbserver;port=$dbport;", "$dbuser", "$dbpass", {'RaiseError' => 1});
        #return 0;
        my $db              = DBI->connect("dbi:Pg:database=$dbname;host=$dbserver;port=$dbport;", "$dbuser", "$dbpass", {AutoCommit => 1, 'RaiseError' => 1});

        my %session;

        my $id = $self->get_id($req, $cfg, $rec);
        if($id){
            tie %session, 'Apache::Session::Postgres', $id, {
                Handle => $db,
                TableName => 'sessions', 
                Commit     => 1
            };
        }else{
            tie %session, 'Apache::Session::Postgres', undef(), {
                Handle => $db,
                TableName => 'sessions', 
                Commit     => 1
            };
            $self->set_cookie("SESSION_ID=$session{_session_id}", $cfg, $rec);
        }

        untie %session;
        $db->disconnect;

        return 1;
    } ## --- end sub add_pseudo_page


    sub delete_links {
        my ($self, $req, $cfg, $rec) = @_;
        my $ident           = ident $self;
        my $debug = $debug{$ident};
        $self->links('delete_links');

        my $dbserver        = $cfg->val('urls_db', 'dbserver');
        my $dbuser          = $cfg->val('urls_db', 'dbuser');
        my $dbpass          = $cfg->val('urls_db', 'dbpass');
        my $dbname          = $cfg->val('urls_db', 'dbname');
        my $dbport          = $cfg->val('urls_db', 'dbport');
        #my $db              = DBI->connect("dbi:Pg:database=$dbname;host=$dbserver;port=$dbport;", "$dbuser", "$dbpass", {'RaiseError' => 1});
        #return 0;
        my $db              = DBI->connect("dbi:Pg:database=$dbname;host=$dbserver;port=$dbport;", "$dbuser", "$dbpass", {AutoCommit => 1, 'RaiseError' => 1});

        my %session;

        my $id = $self->get_id($req, $cfg, $rec);
        if($id){
            tie %session, 'Apache::Session::Postgres', $id, {
                Handle => $db,
                TableName => 'sessions', 
                Commit     => 1
            };
        }else{
            tie %session, 'Apache::Session::Postgres', undef(), {
                Handle => $db,
                TableName => 'sessions', 
                Commit     => 1
            };
            $self->set_cookie("SESSION_ID=$session{_session_id}", $cfg, $rec);
        }

        untie %session;
        $db->disconnect;

        return 1;
    } ## --- end sub delete_links


    sub delete_pages {
        my ($self, $req, $cfg, $rec) = @_;
        my $ident           = ident $self;
        my $debug = $debug{$ident};
        $self->links('delete_pages');

        my $dbserver        = $cfg->val('urls_db', 'dbserver');
        my $dbuser          = $cfg->val('urls_db', 'dbuser');
        my $dbpass          = $cfg->val('urls_db', 'dbpass');
        my $dbname          = $cfg->val('urls_db', 'dbname');
        my $dbport          = $cfg->val('urls_db', 'dbport');
        #my $db              = DBI->connect("dbi:Pg:database=$dbname;host=$dbserver;port=$dbport;", "$dbuser", "$dbpass", {'RaiseError' => 1});
        #return 0;
        my $db              = DBI->connect("dbi:Pg:database=$dbname;host=$dbserver;port=$dbport;", "$dbuser", "$dbpass", {AutoCommit => 1, 'RaiseError' => 1});

        my %session;

        my $id = $self->get_id($req, $cfg, $rec);
        if($id){
            tie %session, 'Apache::Session::Postgres', $id, {
                Handle => $db,
                TableName => 'sessions', 
                Commit     => 1
            };
        }else{
            tie %session, 'Apache::Session::Postgres', undef(), {
                Handle => $db,
                TableName => 'sessions', 
                Commit     => 1
            };
            $self->set_cookie("SESSION_ID=$session{_session_id}", $cfg, $rec);
        }

        untie %session;
        $db->disconnect;

        return 1;
    } ## --- end sub delete_pages


    sub delete_pseudo_page {
        my ($self, $req, $cfg, $rec) = @_;
        my $ident           = ident $self;
        my $debug = $debug{$ident};
        $self->links('delete_pseudo_page');

        my $dbserver        = $cfg->val('urls_db', 'dbserver');
        my $dbuser          = $cfg->val('urls_db', 'dbuser');
        my $dbpass          = $cfg->val('urls_db', 'dbpass');
        my $dbname          = $cfg->val('urls_db', 'dbname');
        my $dbport          = $cfg->val('urls_db', 'dbport');
        #my $db              = DBI->connect("dbi:Pg:database=$dbname;host=$dbserver;port=$dbport;", "$dbuser", "$dbpass", {'RaiseError' => 1});
        #return 0;
        my $db              = DBI->connect("dbi:Pg:database=$dbname;host=$dbserver;port=$dbport;", "$dbuser", "$dbpass", {AutoCommit => 1, 'RaiseError' => 1});

        my %session;

        my $id = $self->get_id($req, $cfg, $rec);
        if($id){
            tie %session, 'Apache::Session::Postgres', $id, {
                Handle => $db,
                TableName => 'sessions', 
                Commit     => 1
            };
        }else{
            tie %session, 'Apache::Session::Postgres', undef(), {
                Handle => $db,
                TableName => 'sessions', 
                Commit     => 1
            };
            $self->set_cookie("SESSION_ID=$session{_session_id}", $cfg, $rec);
        }

        untie %session;
        $db->disconnect;

        return 1;
    } ## --- end sub delete_pseudo_page


    sub delete_aliases {
        my ($self, $req, $cfg, $rec) = @_;
        my $ident           = ident $self;
        my $debug = $debug{$ident};
        $self->links('delete_aliases');

        my $dbserver        = $cfg->val('urls_db', 'dbserver');
        my $dbuser          = $cfg->val('urls_db', 'dbuser');
        my $dbpass          = $cfg->val('urls_db', 'dbpass');
        my $dbname          = $cfg->val('urls_db', 'dbname');
        my $dbport          = $cfg->val('urls_db', 'dbport');
        #my $db              = DBI->connect("dbi:Pg:database=$dbname;host=$dbserver;port=$dbport;", "$dbuser", "$dbpass", {'RaiseError' => 1});
        #return 0;
        my $db              = DBI->connect("dbi:Pg:database=$dbname;host=$dbserver;port=$dbport;", "$dbuser", "$dbpass", {AutoCommit => 1, 'RaiseError' => 1});

        my %session;

        my $id = $self->get_id($req, $cfg, $rec);
        if($id){
            tie %session, 'Apache::Session::Postgres', $id, {
                Handle => $db,
                TableName => 'sessions', 
                Commit     => 1
            };
        }else{
            tie %session, 'Apache::Session::Postgres', undef(), {
                Handle => $db,
                TableName => 'sessions', 
                Commit     => 1
            };
            $self->set_cookie("SESSION_ID=$session{_session_id}", $cfg, $rec);
        }

        untie %session;
        $db->disconnect;

        return 1;
    } ## --- end sub delete_aliases
    

    sub get_id {
        my ($self, $req, $cfg, $rec) = @_;
        my $ident           = ident $self;
        my $debug = $debug{$ident};
        my $j = Apache2::Cookie::Jar->new($rec);
        my $cookie;
        eval {
            my @names = $j->cookies();         # get all the cookies from request headers
            for my $name (@names){
                if($name eq "grizzly"){
                    $cookie = $j->cookies("grizzly");         # get cookie from request headers
                }
            }
        };
        if($@){
            $cookie = undef;
        }
         
        my $id;
        if($cookie){
            $id = $cookie->value;
            $id =~ s/SESSION_ID=(\w*)/$1/;
        }else{
            $id = undef();
        }
        $self->log(Data::Dumper->Dump([$id], [qw(id)]));
 
        return $id;
    } ## --- end sub get_id


    sub set_cookie {
        my ($self, $session_id, $cfg, $rec) = @_;
        my $ident           = ident $self;
        my $debug = $debug{$ident};
        $self->log(Data::Dumper->Dump([$session_id], [qw(session_id)]));
        my $domain = $cfg->val('general',  'domain');

        my $session_cookie = Apache2::Cookie->new($rec,
                  -name  => "grizzly",
                  -value  => $session_id,
                  #-path  => "/",
                  -domain => $domain, 
                  -expires => "+10d"
                  );          
        $session_cookie->bake($rec);
        return $session_cookie;
    } ## --- end sub set_cookie

}

1;
