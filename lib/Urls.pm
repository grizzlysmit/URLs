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
use Data::Validate::URI qw(is_uri);
use DBI;
use Crypt::PBKDF2;
use Crypt::URandom;
use HTML::Entities;

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
            { href => 'index.pl', name => 'home page', fun => 'main', visability => 'loggedin', }, 
            { href => 'add-alias.pl', name => 'add alias', fun => 'add_alias', visability => 'loggedin', }, 
            { href => 'add-link.pl', name => 'add link', fun => 'add_link', visability => 'loggedin', }, 
            { href => 'add-page.pl', name => 'add page', fun => 'add_page', visability => 'loggedin', }, 
            { href => 'add-pseudo-page.pl', name => 'add pseudo-page', fun => 'add_pseudo_page', visability => 'loggedin', }, 
            { href => 'list-aliases.pl', name => 'list aliases', fun => 'list_aliases', visability => 'loggedin', }, 
            { href => 'profile.pl', name => "profile", fun => 'profile', visability => 'loggedin', }, 
            { href => 'delete-orphaned-links-sections.pl', name => "delete orphaned links_sections", fun => 'delete_orphaned_links_sections', visability => 'loggedin', }, 
            { href => 'delete-aliases.pl', name => 'delete aliases', fun => 'delete_aliases', visability => 'loggedin', }, 
            { href => 'delete-links.pl', name => 'delete links', fun => 'delete_links', visability => 'loggedin', }, 
            { href => 'delete-pages.pl', name => 'delete pages', fun => 'delete_pages', visability => 'loggedin', }, 
            { href => 'delete-pseudo-page.pl', name => 'delete pseudo-pages', fun => 'delete_pseudo_page', visability => 'loggedin', }, 
            { href => 'login.pl', name => "login", fun => 'login', visability => 'loggedout', }, 
            { href => 'logout.pl', name => "logout", fun => 'logout', visability => 'loggedin', }, 
            { href => 'admin.pl', name => "Admin", fun => 'admin', visability => 'admin', }, 
            { href => 'register.pl', name => "Register", fun => 'register', visability => 'loggedout', }, 
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
        $self->log(Data::Dumper->Dump([$section, $db], [qw(section db)]));
        my $sql = 'SELECT COUNT(*) n FROM page_view pv WHERE pv.section = ?';
        my $query  = $db->prepare($sql);
        my $result = $query->execute($section);
        my $r      = $query->fetchrow_hashref();
        my $n      = $r->{n};
        $query->finish();
        $self->log(Data::Dumper->Dump([$query, $result, $r, $sql], [qw(query result r sql)]));
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
                #Commit     => 1
            };
        }else{
            tie %session, 'Apache::Session::Postgres', undef(), {
                Handle => $db,
                TableName => 'sessions', 
                #Commit     => 1
            };
            $self->set_cookie("SESSION_ID=$session{_session_id}", $cfg, $rec);
        }

        $debug    = $session{debug} if !defined $debug && exists $session{debug};
        if(!defined $logfiles{$ident}){
            my $log;
            my $logpath = $logpaths{$ident};
            if($debug){
                if(open($log, '>>', "$logpath/debug.log")){
                    $log->autoflush(1);
                }else{
                    die "could not open $logpath/debug.log $!";
                }
            }
            $self->debug_init($debug, $log);
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
                $self->log(Data::Dumper->Dump([$current_page, $current_section, $query, $result, $sql, $pp, $secn], [qw(current_page current_section query result sql pp secn)]));
            }else{
                $sql    = "SELECT pp.name \"page_name\", pp.full_name, ls.section, l.name, l.link, pp.status FROM pseudo_pages pp JOIN links_sections ls ON ls.section ~* pp.pattern JOIN links l ON l.section_id = ls.id\n";
                $sql   .= "WHERE pp.name = ?\n";
                $sql   .= "ORDER BY pp.name, ls.section, l.name, l.link\n";
                $query  = $db->prepare($sql);
                $result = $query->execute($pp);
                $self->log(Data::Dumper->Dump([$current_page, $current_section, $query, $result, $sql, $pp], [qw(current_page current_section query result sql pp)]));
            }
            $r      = $query->fetchrow_hashref();
            my @_body;
            while($r){
                my $page_name = $r->{page_name};
                my $full_name = $r->{full_name};
                my $section   = $r->{section};
                my $name      = $r->{name};
                my $link      = $r->{link};
                my $status    = $r->{status};
                push @_body, { page_name => $page_name, full_name => $full_name, section => $section, name => $name, link => $link, status => $status, };
                $r  = $query->fetchrow_hashref();
            }
            $query->finish();
            for my $row (@_body){
                my $page_name = $row->{page_name};
                my $full_name = $row->{full_name};
                my $section   = $row->{section};
                my $name      = $row->{name};
                my $link      = $row->{link};
                my $status    = $row->{status};
                next if $status eq 'invalid';
                next if $status eq 'unassigned' && $self->in_a_page($section, $db);
                next if $status eq 'assigned'   && !$self->in_a_page($section, $db);
                push @body, { page_name => $page_name, full_name => $full_name, section => $section, name => $name, link => $link, };
            }
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

        $self->links('main', \%session);
        say "        <form action=\"index.pl\" method=\"post\">";
        say "            <h1>Urls</h1>";
        my $page_length = $req->param('page_length');
        $page_length = $session{page_length} if !defined $page_length && exists $session{page_length};
        $page_length    = 25 if !defined $page_length || $page_length < 10 || $page_length > 180;
        $session{page_length} = $page_length;
        $session{debug} = $debug if defined $debug;
        
        untie %session;
        $db->disconnect;

        say "            <table>";
        say "                <tr>";
        say "                    <td colspan=\"3\">";
        say "                        <label for=\"page_length\">Page Length:";
        say "                            <input type=\"number\" name=\"page_length\" id=\"page_length\" min=\"10\" max=\"180\" step=\"1\" value=\"$page_length\" size=\"3\">";
        say "                        </label>";
        say "                    </td>";
        say "                </tr>";
        say "                <tr><th>page</th><th>section</th><th>&nbsp;</th></tr>";
        say "                <tr>";
        say "                    <td>";
        say "                        <select name=\"page\">";
        for my $page (@pages){
            my $type      = $page->{type};
            my $name      = $page->{name};
            my $full_name = $page->{full_name};
            if($current_page eq "$type^$name"){
                say "                            <option value=\"$type^$name\" selected>$name => $full_name</option>";
            }else{
                say "                            <option value=\"$type^$name\">$name => $full_name</option>";
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
        say "                <tr><th>section</th><th>name</th><th>link</th></tr>";
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
                say "                <tr><th>section</th><th>name</th><th>link</th></tr>";
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
        my ($self, $Fun, $sess) = @_;
        my $ident           = ident $self;
        my $debug = $debug{$ident};
        my %session = %{$sess};
        $self->log(Data::Dumper->Dump([$sess, \%session], [qw(sess %session)]));
        my $loggedin               = $session{loggedin};
        my $loggedin_id            = $session{loggedin_id};
        my $loggedin_username      = $session{loggedin_username};
        my $loggedin_admin         = $session{loggedin_admin};
        my $loggedin_display_name  = $session{loggedin_display_name};
        my $loggedin_given         = $session{loggedin_given};
        my $loggedin_family        = $session{loggedin_family};
        my $loggedin_email         = $session{loggedin_email};
        my $loggedin_phone_nnumber = $session{loggedin_phone_nnumber};
        my $loggedin_groupname     = $session{loggedin_groupname};
        my $loggedin_groupnname_id = $session{loggedin_groupnname_id};
        my @pages = @{$PAGES{$ident}};
        say "        <table>";
        say "            <tr>";
        my $cnt = 0;
        for my $page (@pages){
            my $href       = $page->{href};
            my $name       = $page->{name};
            my $fun        = $page->{fun};
            my $visability = $page->{visability};
            $self->log(Data::Dumper->Dump([$visability, $loggedin, $loggedin_admin], [qw(visability loggedin loggedin_admin)]));
            next if(!$loggedin && $visability eq 'loggedin');
            next if($loggedin && $visability eq 'loggedout');
            next if(!$loggedin_admin && $visability eq 'admin');
            #next if $fun eq $Fun;
            $cnt++;
            say "                <td>";
            #say "                    <a href=\"$href\" >$name</a>\n";
            if($fun eq 'profile'){
                if($fun eq $Fun){
                    say "                    <button id=\"$fun\" type=\"button\" disabled>$name: $loggedin_username</button>\n";
                }else{
                    say "                    <form action=\"$href\" method=\"post\" ><input name=\"$fun\" type=\"submit\" value=\"$name: $loggedin_username\" /></form>\n";
                }
            }elsif($fun eq $Fun){
                say "                    <button id=\"$fun\" type=\"button\" disabled>$name</button>\n";
            }else{
                say "                    <form action=\"$href\" method=\"post\" ><input name=\"$fun\" type=\"submit\" value=\"$name\" /></form>\n";
            }
            say "                </td>";
            if($cnt % 7 == 0){
                say "            </tr>";
                say "            <tr>";
            }
        }
        say "            </tr>";
        say "        </table>";
        return 1;
    } ## --- end sub links


    sub list_aliases {
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
            tie %session, 'Apache::Session::Postgres', $id, {
                Handle => $db,
                TableName => 'sessions', 
                #Commit     => 1
            };
        }else{
            tie %session, 'Apache::Session::Postgres', undef(), {
                Handle => $db,
                TableName => 'sessions', 
                #Commit     => 1
            };
            $self->set_cookie("SESSION_ID=$session{_session_id}", $cfg, $rec);
        }

        $debug    = $session{debug} if !defined $debug && exists $session{debug};
        $debug{$ident} = $debug;
        $session{debug} = $debug if defined $debug;
        if(!defined $logfiles{$ident}){
            my $log;
            my $logpath = $logpaths{$ident};
            if($debug){
                if(open($log, '>>', "$logpath/debug.log")){
                    $log->autoflush(1);
                }else{
                    die "could not open $logpath/debug.log $!";
                }
            }
            $self->debug_init($debug, $log);
        }

        $self->links('list_aliases', \%session);

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

        untie %session;
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
                #Commit     => 1
            };
        }else{
            tie %session, 'Apache::Session::Postgres', undef(), {
                Handle => $db,
                TableName => 'sessions', 
                #Commit     => 1
            };
            $self->set_cookie("SESSION_ID=$session{_session_id}", $cfg, $rec);
        }

        $debug    = $session{debug} if !defined $debug && exists $session{debug};
        $debug{$ident} = $debug;
        $session{debug} = $debug if defined $debug;
        if(!defined $logfiles{$ident}){
            my $log;
            my $logpath = $logpaths{$ident};
            if($debug){
                if(open($log, '>>', "$logpath/debug.log")){
                    $log->autoflush(1);
                }else{
                    die "could not open $logpath/debug.log $!";
                }
            }
            $self->debug_init($debug, $log);
        }

        $self->links('add_alias', \%session);

        my $alias  = $req->param('alias');
        my $target = $req->param('target');
        my $set_page_length = $req->param('set_page_length');

        $self->log(Data::Dumper->Dump([$alias, $target], [qw(alias target)]));
        if(defined $set_page_length){
        }elsif(defined $alias && defined $target && $alias =~ m/^(?:\w|-|\.|\@)+$/ && $self->valid_section($target, $db)){
            my @msgs;
            my $return = 1;
            my $sql  = "INSERT INTO alias(name, target)VALUES(?, ?);\n";
            my $query           = $db->prepare($sql);
            $self->log(Data::Dumper->Dump([$alias, $target, $sql], [qw(alias target sql)]));
            my $result;
            eval {
                $result          = $query->execute($alias, $target);
            };
            if($@){
                push @msgs, "Error: $@";
                $return  = 0;
            }
            $self->log(Data::Dumper->Dump([$query, $result, $sql], [qw(query result sql)]));
            if($result){
                $sql  = "SELECT ls.section FROM links_sections ls\n";
                $sql .= "WHERE ls.id = ?\n";
                $query           = $db->prepare($sql);
                $result          = $query->execute($target);
                my $r            = $query->fetchrow_hashref();
                $self->log(Data::Dumper->Dump([$query, $result, $r], [qw(query result r)]));
                my $section      = $r->{section};
                push @msgs, "Alias  defined: $alias => $section";
            }else{
                $sql  = "SELECT ls.section FROM links_sections ls\n";
                $sql .= "WHERE ls.id = ?\n";
                $query           = $db->prepare($sql);
                $result          = $query->execute($target);
                my $r            = $query->fetchrow_hashref();
                $self->log(Data::Dumper->Dump([$query, $result, $r], [qw(query result r)]));
                my $section      = $r->{section};
                push @msgs, "Error: failed to define Alias: $alias => $section";
                $return = 0;
            }
            $self->message($debug, \%session, $db, 'add_alias', 'Add an other Alias', undef, undef, @msgs);
            return $return;
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
        my $page_length = $req->param('page_length');
        $page_length = $session{page_length} if !defined $page_length && exists $session{page_length};
        $page_length    = 25 if !defined $page_length || $page_length < 10 || $page_length > 180;
        $session{page_length} = $page_length;
        $session{debug} = $debug if defined $debug;

        $sql  = "SELECT a.name, a.section FROM aliases a\n";
        $sql    .= "ORDER BY a.name\n";
        $query           = $db->prepare($sql);
        $result          = $query->execute();
        $self->log(Data::Dumper->Dump([$query, $result, $sql], [qw(query result sql)]));
        my @aliases;
        $r               = $query->fetchrow_hashref();
        $self->log(Data::Dumper->Dump([$query, $result, $r], [qw(query result r)]));
        while($r){
            push @aliases, $r;
            $r           = $query->fetchrow_hashref();
            $self->log(Data::Dumper->Dump([$query, $result, $r], [qw(query result r)]));
        }
        $query->finish();

        untie %session;
        $db->disconnect;

        say "        <form action=\"add-alias.pl\" method=\"post\">";
        say "            <h1>Add Alias</h1>";
        say "            <table>";
        say "                <tr>";
        say "                    <td>";
        say "                        <label for=\"page_length\">Page Length:";
        say "                            <input type=\"number\" name=\"page_length\" id=\"page_length\" min=\"10\" max=\"180\" step=\"1\" value=\"$page_length\" size=\"3\">";
        say "                        </label>";
        say "                    </td>";
        say "                    <td colspan=\"2\">";
        say "                        <input type=\"submit\" name=\"set_page_length\" id=\"set_page_length\" value=\"Set Page Length\" />";
        say "                    </td>";
        say "                </tr>";
        say "                <tr>";
        say "                    <td>";
        say "                        <label for=\"alias\">Alias: </label>";
        say "                    </td>";
        say "                    <td colspan=\"2\">";
        say "                        <input type=\"text\" name=\"alias\" id=\"alias\" placeholder=\"alias\" pattern=\"[a-zA-Z0-9\\x28\\x2E_-]+\" title=\"only a-z, A-Z, 0-9, -, _ and . allowed\"/>";
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
        say "                        <input name=\"submit\" type=\"submit\" value=\"Add\">";
        say "                    </td>";
        say "                </tr>";
        say "            </table>";
        say "        </form>";

        say "        <h1>Current Aliases</h1>";
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


    sub valid_page {
        my ($self, $target, $db) = @_;
        my $ident           = ident $self;
        $self->log("start valid_page");
        $self->log(Data::Dumper->Dump([$target, $db], [qw(target db)]));
        my $debug = $debug{$ident};
        return 0 if $target !~ m/^\d+$/;
        my $sql             = "SELECT COUNT(*) n FROM pages p\n";
        $sql               .= "WHERE p.id = ?\n";
        my $query           = $db->prepare($sql);
        my $result          = $query->execute($target);
        $self->log(Data::Dumper->Dump([$query, $result, $sql], [qw(query result sql)]));
        my $r               = $query->fetchrow_hashref();
        $self->log(Data::Dumper->Dump([$query, $result, $r], [qw(query result r)]));
        my $n               = $r->{n};
        $self->log("end valid_page");
        return $n;
    } ## --- end sub valid_page


    sub add_page {
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
            tie %session, 'Apache::Session::Postgres', $id, {
                Handle => $db,
                TableName => 'sessions', 
                #Commit     => 1
            };
        }else{
            tie %session, 'Apache::Session::Postgres', undef(), {
                Handle => $db,
                TableName => 'sessions', 
                #Commit     => 1
            };
            $self->set_cookie("SESSION_ID=$session{_session_id}", $cfg, $rec);
        }

        $debug    = $session{debug} if !defined $debug && exists $session{debug};
        $debug{$ident} = $debug;
        $session{debug} = $debug if defined $debug;
        if(!defined $logfiles{$ident}){
            my $log;
            my $logpath = $logpaths{$ident};
            if($debug){
                if(open($log, '>>', "$logpath/debug.log")){
                    $log->autoflush(1);
                }else{
                    die "could not open $logpath/debug.log $!";
                }
            }
            $self->debug_init($debug, $log);
        }

        $self->links('add_page', \%session);

        my $page_length = $req->param('page_length');
        $page_length = $session{page_length} if !defined $page_length && exists $session{page_length};
        $page_length    = 25 if !defined $page_length || $page_length < 10 || $page_length > 180;
        $session{page_length} = $page_length;

        my $set_page_length = $req->param('set_page_length');
        my $page            = $req->param('page');
        my $full_name       = $req->param('full_name');
        my @params          = $req->param;
        my @members;
        for (@params){
            if(m/^members\[(\d+)\]$/){
                push @members, $req->param($_);
            }
        }
        $self->log(Data::Dumper->Dump([\@params, \@members], [qw(@params @members)]));
        if($set_page_length){
        }elsif(defined $page && @members && $page =~ m/^(?:\w|\.|\+|-)+$/ && join(',', @members) =~ m/^\d+(?:,\d+)*$/){
            my @msgs;
            my $return = 1;
            my $sql  = "INSERT INTO pages(name, full_name) VALUES(?, ?) ON CONFLICT (name) DO UPDATE SET full_name = EXCLUDED.full_name\n";
            my $query           = $db->prepare($sql);
            my $result          = $query->execute($page, $full_name);
            $self->log(Data::Dumper->Dump([$query, $result, $sql], [qw(query result sql)]));
            $query->finish();
            if($result){
                push @msgs, "Page $page added.";
                $sql  =  "SELECT p.id FROM pages p\n";
                $sql .=  "WHERE p.name = ?\n";
                $query           = $db->prepare($sql);
                $result          = $query->execute($page);
                $return = 0 if !$result;
                my $r            = $query->fetchrow_hashref();
                my $page_id      = $r->{id};
                $query->finish();
                $sql  = "INSERT INTO page_section(pages_id, links_section_id)\n";
                $sql .= "VALUES(?, ?) ON CONFLICT (pages_id, links_section_id) DO NOTHING\n";
                $self->log(Data::Dumper->Dump([\@members], [qw(@members)]));
                $query           = $db->prepare($sql);
                my (@good, @bad, @skipped);
                for my $member (@members){
                    if(!$self->valid_section($member, $db)){
                        push @skipped, $member;
                        next;
                    }
                    eval {
                        $result      = $query->execute($page_id, $member);
                    };
                    if($@){
                        push @bad, $member;
                        push @msgs, "Error: $@";
                        $return = 0;
                    }
                    if($result){
                        push @good, $member;
                    }else{
                        push @bad,  $member;
                        $return = 0;
                    }
                }
                $query->finish();
                my $g = scalar @good;
                my $b = scalar @bad;
                my $s = scalar @skipped;
                push @msgs, "$g link sections added", "$b link sections failed to add", "$s link sections bad link sections skipped";
            }else{
                push @msgs, "Error: Page insertion failed";
                $return = 0;
            }
            $self->message($debug, \%session, $db, 'add_page', 'Add an other Page', undef, @msgs);

            untie %session;
            $db->disconnect;
            return $return;
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

        say "        <form action=\"add-page.pl\" method=\"post\">";
        say "            <h1>Add Page</h1>";
        say "            <table>";
        say "                <tr>";
        say "                    <td>";
        say "                        <label for=\"page\">Page: </label>";
        say "                    </td>";
        say "                    <td>";
        say "                        <input type=\"text\" name=\"page\" id=\"page\" placeholder=\"page_name\" pattern=\"[a-zA-Z0-9\\x28\\x2E_-]+\" title=\"Only a-z, A-Z, 0-9, ., - and _ allowed\"/>";
        say "                    </td>";
        say "                    <td>";
        say "                        <input type=\"text\" name=\"full_name\" id=\"full_name\" placeholder=\"full name\" pattern=\"[a-zA-Z0-9\\x28\\x2E\\x20_-]+\" title=\"Only a-z, A-Z, 0-9, ., -, _ and spaces allowed\"/>";
        say "                    </td>";
        say "                </tr>";
        say "                <tr>";
        say "                    <td>";
        say "                        <label for=\"page_length\">Page Length:";
        say "                            <input type=\"number\" name=\"page_length\" id=\"page_length\" min=\"10\" max=\"180\" step=\"1\" value=\"$page_length\" size=\"3\">";
        say "                        </label>";
        say "                    </td>";
        say "                    <td colspan=\"2\">";
        say "                        <input type=\"submit\" name=\"set_page_length\" id=\"set_page_length\" value=\"Set Page Length\" />";
        say "                    </td>";
        say "                </tr>";
        say "                <tr>";
        say "                    <th colspan=\"2\">Link Section</th><th>Members</th>";
        say "                </tr>";
        my $cnt = 0;
        for (@sections){
            $cnt++;
            my $links_section_id = $_->{id};
            my $section          = $_->{section};
            say "                <tr>";
            say "                    <td colspan=\"2\">";
            say "                        <label for=\"$section\">$section</label>";
            say "                    </td>";
            say "                    <td>";
            say "                        <input type=\"checkbox\" name=\"members[$cnt]\" id=\"$section\" value=\"$links_section_id\" />";
            say "                    </td>";
            say "                </tr>";
            if($cnt % $page_length == 0){
                say "                <tr>";
                say "                    <th colspan=\"2\">Link Section</th><th>Members</th>";
                say "                </tr>";
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
        say "                        <input name=\"submit\" type=\"submit\" value=\"OK\">";
        say "                    </td>";
        say "                </tr>";
        say "            </table>";
        say "        </form>";

        untie %session;
        $db->disconnect;

        return 1;
    } ## --- end sub add_page


    sub add_link {
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
            tie %session, 'Apache::Session::Postgres', $id, {
                Handle => $db,
                TableName => 'sessions', 
                #Commit     => 1
            };
        }else{
            tie %session, 'Apache::Session::Postgres', undef(), {
                Handle => $db,
                TableName => 'sessions', 
                #Commit     => 1
            };
            $self->set_cookie("SESSION_ID=$session{_session_id}", $cfg, $rec);
        }

        $debug    = $session{debug} if !defined $debug && exists $session{debug};
        $debug{$ident} = $debug;
        $session{debug} = $debug if defined $debug;
        if(!defined $logfiles{$ident}){
            my $log;
            my $logpath = $logpaths{$ident};
            if($debug){
                if(open($log, '>>', "$logpath/debug.log")){
                    $log->autoflush(1);
                }else{
                    die "could not open $logpath/debug.log $!";
                }
            }
            $self->debug_init($debug, $log);
        }

        $self->links('add_link', \%session);

        my $section  = $req->param('section');
        my $name     = $req->param('name');
        my $link     = $req->param('link');

        $self->log(Data::Dumper->Dump([$section, $name, $link], [qw(section name link)]));
        if(defined $section && defined $name && defined $link && $section =~ m/^(?:\w|-|\.|\@)+$/ && $name =~ m/^(?:\w|-|\.|\@)+$/ && is_uri($link)){
            my @msgs;
            my $return = 1;
            my $sql  = "INSERT INTO links_sections(section) VALUES(?) ON CONFLICT (section) DO NOTHING;\n";
            my $query           = $db->prepare($sql);
            $self->log(Data::Dumper->Dump([$section, $name, $link, $sql], [qw(section name link sql)]));
            my $result;
            eval {
                $result          = $query->execute($section);
            };
            if($@){
                push @msgs, "Error: $@";
                $query->finish();
                $return = 0;
            }
            $self->log(Data::Dumper->Dump([$query, $result, $sql], [qw(query result sql)]));
            if($result){
                $sql  = "SELECT ls.id FROM links_sections ls\n";
                $sql .= "WHERE ls.section = ?\n";
                $query           = $db->prepare($sql);
                $result          = $query->execute($section);
                if($result){
                    push @msgs, "Section defined: $section";
                    my $r            = $query->fetchrow_hashref();
                    $self->log(Data::Dumper->Dump([$query, $result, $r], [qw(query result r)]));
                    my $section_id   = $r->{id};
                    $sql  = 'INSERT INTO links(section_id, name, link) VALUES (?, ?, ?) ON CONFLICT (section_id, name) DO NOTHING';
                    $query           = $db->prepare($sql);
                    $result          = $query->execute($section_id, $name, $link);
                    if($result){
                        push @msgs, "link defined: $section $name $link";
                        $query->finish();
                    }else{
                        push @msgs, "Section insert failed: $section";
                        $query->finish();
                        $return = 0;
                    }
                }else{
                    push @msgs, "Section insert failed: $section";
                    $query->finish();
                    $return = 0;
                }
            }else{
                push @msgs, "Section insert failed: $section";
                $query->finish();
                $return = 0;
            }
            $self->message($debug, \%session, $db, 'add_link', 'Add Another Link', undef, @msgs);

            untie %session;
            $db->disconnect;
            return $return;
        }

        my $sql    = "SELECT lsl.section, lsl.name, lsl.link FROM links_sections_join_links lsl\n";
        $sql      .= "ORDER BY lsl.section, lsl.name;\n";
        my $query  = $db->prepare($sql);
        my $result = $query->execute();
        my $r      = $query->fetchrow_hashref();
        my @body;
        while($r){
            my $section   = $r->{section};
            my $name      = $r->{name};
            my $link      = $r->{link};
            push @body, { section => $section, name => $name, link => $link, };
            $r  = $query->fetchrow_hashref();
        }
        $query->finish();

        my $page_length = $req->param('page_length');
        $page_length = $session{page_length} if !defined $page_length && exists $session{page_length};
        $page_length    = 25 if !defined $page_length || $page_length < 10 || $page_length > 180;
        $session{page_length} = $page_length;

        untie %session;
        $db->disconnect;

        say "        <form action=\"add-link.pl\" method=\"post\">";
        say "            <h1>Add Link</h1>";
        say "            <table>";
        say "                <tr>";
        say "                    <td>";
        say "                        <label for=\"section\">Section: </label>";
        say "                    </td>";
        say "                    <td colspan=\"2\">";
        say "                        <input type=\"text\" name=\"section\" id=\"section\" placeholder=\"section\" pattern=\"[a-zA-Z0-9\\x28\\x2E_-]+\" title=\"Only a-z, A-Z, 0-9, ., - and _ allowed\"/>";
        say "                    </td>";
        say "                </tr>";
        say "                <tr>";
        say "                    <td>";
        say "                        <label for=\"name\">Name: </label>";
        say "                    </td>";
        say "                    <td colspan=\"2\">";
        say "                        <input type=\"text\" name=\"name\" id=\"name\" placeholder=\"name\" pattern=\"[a-zA-Z0-9\\x28\\x2E_-]+\" title=\"Only a-z, A-Z, 0-9, ., - and _ allowed\"/>";
        say "                    </td>";
        say "                </tr>";
        say "                <tr>";
        say "                    <td>";
        say "                        <label for=\"link\">link </label>";
        say "                    </td>";
        say "                    <td colspan=\"2\">";
        say "                        <input type=\"url\" name=\"link\" id=\"link\" placeholder=\"https://example.com/\" pattern=\"https?://.+\" title=\"please supply either http:// or https://\"/>";
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
        #say "        </form>";

        #say "        <form action=\"add-link.pl\" method=\"post\">";
        say "            <h2>Existing Links</h2>";
        say "            <table>";
        say "                <tr><th>section</th><th>name</th><th>link</th></tr>";
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
                say "                <tr><th>section</th><th>name</th><th>link</th></tr>";
            }
        }
        say "            </table>";
        say "        </form>";

        return 1;
    } ## --- end sub add_link


    sub add_pseudo_page {
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
            tie %session, 'Apache::Session::Postgres', $id, {
                Handle => $db,
                TableName => 'sessions', 
                #Commit     => 1
            };
        }else{
            tie %session, 'Apache::Session::Postgres', undef(), {
                Handle => $db,
                TableName => 'sessions', 
                #Commit     => 1
            };
            $self->set_cookie("SESSION_ID=$session{_session_id}", $cfg, $rec);
        }

        $self->links('add_pseudo_page', \%session);

        $debug    = $session{debug} if !defined $debug && exists $session{debug};
        $debug{$ident} = $debug;
        $session{debug} = $debug if defined $debug;
        if(!defined $logfiles{$ident}){
            my $log;
            my $logpath = $logpaths{$ident};
            if($debug){
                if(open($log, '>>', "$logpath/debug.log")){
                    $log->autoflush(1);
                }else{
                    die "could not open $logpath/debug.log $!";
                }
            }
            $self->debug_init($debug, $log);
        }

        my $name       = $req->param('name');
        my $full_name  = $req->param('full_name');
        my $status     = $req->param('status');
        my $pattern    = $req->param('pattern');

        $self->log(Data::Dumper->Dump([$name, $full_name, $status, $pattern], [qw(name full_name status pattern)]));
        if(defined $name && defined $status && defined $pattern && $name =~ m/^(?:\w|-|\.|\@)+$/ && $status =~ m/^(?:invalid|unassigned|assigned|both)$/ && $pattern =~ m/^[^;\'\"]+$/){
            my $sql  = "INSERT INTO pseudo_pages(name, full_name, status, pattern) VALUES(?, ?, ?, ?) ON CONFLICT (name) DO UPDATE SET full_name = EXCLUDED.full_name, status = EXCLUDED.status, pattern = EXCLUDED.pattern;\n";
            my $query           = $db->prepare($sql);
            $self->log(Data::Dumper->Dump([$name, $full_name, $status, $pattern, $sql], [qw(name full_name status pattern sql)]));
            my $result;
            eval {
                $result         = $query->execute($name, $full_name, $status, $pattern);
            };
            if($@){
                my @msgs = ("Error: $@", "Pseudo page insert failed: ($name, $full_name, $status, $pattern)");
                $query->finish();
                $self->message($debug, \%session, $db, 'add_pseudo_page', undef, undef, @msgs);

                untie %session;
                $db->disconnect;
                return 0;
            }
            $self->log(Data::Dumper->Dump([$query, $result, $sql], [qw(query result sql)]));
            if($result){
                $query->finish();
                $self->message($debug, \%session, $db, 'add_pseudo_page', 'Add Another Pseudo-Page', undef, "Pseudo page defined: ($name, $full_name, $status, $pattern)");

                untie %session;
                $db->disconnect;
                return 1;
            }else{
                $query->finish();
                $self->message($debug, \%session, $db, 'add_pseudo_page', undef, undef, "Pseudo page insert failed: ($name, $full_name, $status, $pattern)");

                untie %session;
                $db->disconnect;
                return 0;
            }
        }
        
        my $sql  = "SELECT pp.name, pp.full_name, pp.pattern, pp.status FROM pseudo_pages pp\n";
        $sql    .= "ORDER BY pp.name, pp.full_name\n";
        my $query           = $db->prepare($sql);
        $self->log(Data::Dumper->Dump([$name, $full_name, $status, $pattern, $sql], [qw(name full_name status pattern sql)]));
        my $result;
        eval {
            $result         = $query->execute();
        };
        if($@){
            my @msgs = ("Error: $@", "Pseudo page list failed");
            $query->finish();
            $self->message($debug, \%session, $db, 'add_pseudo_page', undef, @msgs);
            return 0;
        }
        my @pseudo_pages;
        my $r = $query->fetchrow_hashref();
        if($result){
            while($r){
                push @pseudo_pages, $r;
                $r = $query->fetchrow_hashref();
            }
        }else{
            $query->finish();
            $self->message($debug, \%session, $db, 'add_pseudo_page', undef, "Pseudo page list failed");
            return 0;
        }
        $query->finish();

        untie %session;
        $db->disconnect;

        say "        <form action=\"add-pseudo-page.pl\" method=\"post\">";
        say "            <h1>Add Pseudo Page</h1>";
        say "            <table>";
        say "                <tr>";
        say "                    <td>";
        say "                        <label for=\"name\">Name: </label>";
        say "                    </td>";
        say "                    <td colspan=\"2\">";
        say "                        <input type=\"text\" name=\"name\" id=\"name\" placeholder=\"name\" pattern=\"[a-zA-Z0-9\\x28\\x2E_-]+\" title=\"Only a-z, A-Z, 0-9, ., - and _ allowed\"/>";
        say "                    </td>";
        say "                </tr>";
        say "                <tr>";
        say "                    <td>";
        say "                        <label for=\"full_name\">Full name: </label>";
        say "                    </td>";
        say "                    <td colspan=\"2\">";
        say "                        <input type=\"text\" name=\"full_name\" id=\"full_name\" placeholder=\"full name\" pattern=\"[a-zA-Z0-9_][a-zA-Z0-9\\x28\\x2E\\x20_-]*\" title=\"Only a-z, A-Z, 0-9, ., -, _ and spaces allowed\"/>";
        say "                    </td>";
        say "                </tr>";
        say "                <tr>";
        say "                    <td>";
        say "                        <label for=\"status\">Status: </label>";
        say "                    </td>";
        say "                    <td colspan=\"2\">";
        say "                        <select name=\"status\">";
        say "                            <option>invalid</option>";
        say "                            <option selected>unassigned</option>";
        say "                            <option>assigned</option>";
        say "                            <option>both</option>";
        say "                        </select>";
        say "                    </td>";
        say "                </tr>";
        say "                <tr>";
        say "                    <td>";
        say "                        <label for=\"pattern\">Pattern </label>";
        say "                    </td>";
        say "                    <td colspan=\"2\">";
        say "                        <input type=\"text\" name=\"pattern\" id=\"pattern\" placeholder=\"pattern\" pattern=\"[^;'\\x22]+\" title=\"; ' and \\x22 not allowed to prevent abuse\"/>";
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
        say "            <h1>Existing Pseudo-Pages</h1>";
        say "            <table>";
        for my $pp (@pseudo_pages){
            my $name      = $pp->{name};
            my $full_name = $pp->{full_name};
            my $pattern   = $pp->{pattern};
            my $status    = $pp->{status};
            say "                <tr>";
            say "                    <td>";
            say "                        $name";
            say "                    </td>";
            say "                    <td>";
            say "                        $full_name";
            say "                    </td>";
            say "                    <td>";
            say "                        $pattern";
            say "                    </td>";
            say "                    <td>";
            say "                        $status";
            say "                    </td>";
            say "                </tr>";
        }
        say "            </table>";
        say "        </form>";

        return 1;
    } ## --- end sub add_pseudo_page


    sub delete_links {
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
            tie %session, 'Apache::Session::Postgres', $id, {
                Handle => $db,
                TableName => 'sessions', 
                #Commit     => 1
            };
        }else{
            tie %session, 'Apache::Session::Postgres', undef(), {
                Handle => $db,
                TableName => 'sessions', 
                #Commit     => 1
            };
            $self->set_cookie("SESSION_ID=$session{_session_id}", $cfg, $rec);
        }

        $self->links('delete_links', \%session);

        $debug    = $session{debug} if !defined $debug && exists $session{debug};
        $debug{$ident} = $debug;
        $session{debug} = $debug if defined $debug;
        if(!defined $logfiles{$ident}){
            my $log;
            my $logpath = $logpaths{$ident};
            if($debug){
                if(open($log, '>>', "$logpath/debug.log")){
                    $log->autoflush(1);
                }else{
                    die "could not open $logpath/debug.log $!";
                }
            }
            $self->debug_init($debug, $log);
        }

        my $delete  = $req->param('delete');

        my @params          = $req->param;
        my @delete_set;
        for (@params){
            if(m/^delete_set\[\d+\]$/){
                push @delete_set, $req->param($_);
            }
        }
        $self->log(Data::Dumper->Dump([\@params, \@delete_set], [qw(@params @delete_set)]));

        if(@delete_set && join(',', @delete_set) =~ m/^\d+(?:,\d+)*$/){
            my @msgs;
            my $return = 1;
            if($delete eq 'Delete Link'){
                for my $link_id (@delete_set){
                    my $sql  = "DELETE FROM links WHERE id = ?;\n";
                    my $query           = $db->prepare($sql);
                    my $result;
                    eval {
                        $result         = $query->execute($link_id);
                    };
                    if($@){
                        say "                <tr><td></td></tr>";
                        push @msgs,  "Error: Delete links failed: $@";
                        $query->finish();
                        next;
                    }
                    $self->log(Data::Dumper->Dump([$link_id, $query, $result, $sql], [qw(link_id query result sql)]));
                    if($result){
                        push @msgs,  "Delete Succeded.";
                        $query->finish();
                        next;
                    }
                    push @msgs,  "Error: Delete links failed.";
                    $return = 0;
                    $query->finish();
                }
            }elsif($delete eq 'Delete Section'){
                my %sections_to_delete;
                for my $link_id (@delete_set){
                    my $sql  = "SELECT  l.section_id FROM links l\n";
                    $sql    .= "WHERE l.id = ?;\n";
                    my $query           = $db->prepare($sql);
                    $self->log(Data::Dumper->Dump([$link_id, $query, $sql], [qw(link_id query sql)]));
                    my $result;
                    eval {
                        $result         = $query->execute($link_id);
                    };
                    if($@){
                        push @msgs,  "Error: failed to get section_id: $@";
                        $return = 0;
                        $query->finish();
                        next;
                    }
                    $self->log(Data::Dumper->Dump([$link_id, $query, $result, $sql], [qw(link_id query result sql)]));
                    if($result){
                        my $r           = $query->fetchrow_hashref();
                        my $section_id = $r->{section_id};
                        $sections_to_delete{$section_id}++;
                    }else{
                        $return = 0;
                        push @msgs,  "Error: failed to get section_id";
                    }
                    $query->finish();
                    $sql  = "DELETE FROM links WHERE id = ?;\n";
                    $query           = $db->prepare($sql);
                    eval {
                        $result         = $query->execute($link_id);
                    };
                    if($@){
                        push @msgs,  "Error: Delete links failed: $@";
                        $query->finish();
                        $return = 0;
                        next;
                    }
                    $self->log(Data::Dumper->Dump([$link_id, $query, $result, $sql], [qw(link_id query result sql)]));
                    if($result){
                        push @msgs,  "Delete Succeded.";
                        $query->finish();
                        next;
                    }
                    push @msgs,  "Error: Delete links failed.";
                    $query->finish();
                }
                for my $section_id (keys %sections_to_delete){
                    my $sql  = "SELECT COUNT(*) n FROM links l\n";
                    $sql    .= "WHERE l.section_id = ?;\n";
                    my $query           = $db->prepare($sql);
                    my $result;
                    eval {
                        $result         = $query->execute($section_id);
                    };
                    if($@){
                        push @msgs,  "Error: Delete links_sections failed: $@";
                        $query->finish();
                        next;
                    }
                    if($result){
                        my $r           = $query->fetchrow_hashref();
                        my $n = $r->{n};
                        $query->finish();
                        if($n){
                            push @msgs,  "Cannot delete links_sections section not empty.";
                            next;
                        }
                        $sql  = "DELETE FROM links_sections\n";
                        $sql .= "WHERE id = ?\n";
                        $query           = $db->prepare($sql);
                        eval {
                            $result         = $query->execute($section_id);
                        };
                        if($@){
                            push @msgs,  "Error: Delete links_sections failed: $@";
                            $return = 0;
                            $query->finish();
                            next;
                        }
                        if($result){
                            push @msgs,  "Delete links_sections succeeded!";
                            $query->finish();
                            next;
                        }
                        push @msgs,  "Error: Delete links_sections failed";
                        $return = 0;
                        $query->finish();
                    }
                    $query->finish();
                }
            }
            $self->message($debug, \%session, $db, 'delete_links', 'Delete some more links', undef, @msgs);

            untie %session;
            $db->disconnect;
            return $return;
        }

        my $sql  = "SELECT  l.id, l.section_id, (SELECT ls.section FROM links_sections ls WHERE ls.id = l.section_id) section, l.name, l.link FROM links l\n";
        $sql    .= "ORDER BY section, l.name\n";
        my $query           = $db->prepare($sql);
        my $result;
        eval {
            $result         = $query->execute();
        };
        if($@){
            $self->message($debug, \%session, $db, 'delete_links', undef, undef, "Error: $@");
            $query->finish();
            return 0;
        }
        $self->log(Data::Dumper->Dump([$query, $result, $sql], [qw(query result sql)]));
        my @links;
        my $r           = $query->fetchrow_hashref();
        while($r){
            push @links, $r;
            $r       = $query->fetchrow_hashref();
        }
        $query->finish();
        
        say "        <form action=\"delete-links.pl\" method=\"post\">";
        say "            <h1>Delete Links</h1>";
        my $page_length = $req->param('page_length');
        $page_length = $session{page_length} if !defined $page_length && exists $session{page_length};
        $page_length    = 25 if !defined $page_length || $page_length < 10 || $page_length > 180;
        $session{page_length} = $page_length;
        $session{debug} = $debug if defined $debug;
        
        untie %session;
        $db->disconnect;

        say "            <table>";
        say "                <tr>";
        say "                    <td colspan=\"3\">";
        say "                        <label for=\"page_length\">Page Length:";
        say "                            <input type=\"number\" name=\"page_length\" id=\"page_length\" min=\"10\" max=\"180\" step=\"1\" value=\"$page_length\" size=\"3\">";
        say "                        </label>";
        say "                    </td>";
        say "                </tr>";
        say "                <tr><th>section</th><th>name</th><th>link</th><th>Select</th></tr>";
        my $cnt = 0;
        for my $row (@links){
            $cnt++;
            my $link_id    = $row->{id};
            my $section_id = $row->{section_id};
            my $section    = $row->{section};
            my $name       = $row->{name};
            my $link       = $row->{link};
            say "                <tr>";
            say "                    <td>";
            say "                        <label for=\"$link_id\">$section</label>";
            say "                    </td>";
            say "                    <td>";
            say "                        <label for=\"$link_id\">$name</label>";
            say "                    </td>";
            say "                    <td>";
            say "                        <label for=\"$link_id\">$link</label>";
            say "                    </td>";
            say "                    <td>";
            say "                        <input type=\"checkbox\" name=\"delete_set[$cnt]\" id=\"$link_id\" value=\"$link_id\"/>";
            say "                    </td>";
            say "                </tr>";
            if($cnt % $page_length == 0){
                say "                <tr><th>section</th><th>name</th><th>link</th><th>Select</th></tr>";
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
        say "                        <input name=\"delete\" type=\"submit\" value=\"Delete Section\">";
        say "                    </td>";
        say "                    <td>";
        say "                        <input name=\"delete\" type=\"submit\" value=\"Delete Link\">";
        say "                    </td>";
        say "                </tr>";
        say "            </table>";
        say "        </form>";

        return 1;
    } ## --- end sub delete_links


    sub message {
        my ($self, $debug, $_session, $db, $fun, $button_msg, $dont_do_form, @msgs) = @_;
        my $ident           = ident $self;

        my %session = %{$_session};
        $fun = 'index' if $fun eq 'main';

        $fun =~ tr/_/-/;


        #untie %session;
        #$db->disconnect;

        if($dont_do_form){
            say "        <table>";
            if($button_msg){
                say "            <tr><th>Message</th></tr>";
            }else{
                say "            <tr><th>Error: Message</th></tr>";
            }
            for my $msg (@msgs){
                say "            <tr>";
                say "                <td>";
                say "                    $msg";
                say "                </td>";
                say "            </tr>";
            }
            say "        </table>";
        }else{
            say "        <form action=\"$fun.pl\" method=\"post\">";
            say "            <table>";
            if($button_msg){
                say "                <tr><th colspan=\"3\">Message</th></tr>";
            }else{
                say "                <tr><th colspan=\"3\">Error: Message</th></tr>";
            }
            for my $msg (@msgs){
                say "                <tr>";
                say "                    <td colspan=\"3\">";
                say "                        $msg";
                say "                    </td>";
                say "                </tr>";
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
            if($button_msg){
                say "                    <td>";
                say "                        <input name=\"delete\" type=\"submit\" value=\"$button_msg\">";
                say "                    </td>";
            }else{
                say "                    <td>";
                say "                        <input name=\"submit\" type=\"submit\" value=\"Try Again\">";
                say "                    </td>";
            }
            say "                </tr>";
            say "            </table>";
            say "        </form>";
        }

    } ## --- end sub message


    sub delete_pages {
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
            tie %session, 'Apache::Session::Postgres', $id, {
                Handle => $db,
                TableName => 'sessions', 
                #Commit     => 1
            };
        }else{
            tie %session, 'Apache::Session::Postgres', undef(), {
                Handle => $db,
                TableName => 'sessions', 
                #Commit     => 1
            };
            $self->set_cookie("SESSION_ID=$session{_session_id}", $cfg, $rec);
        }

        $self->links('delete_pages', \%session);

        $debug    = $session{debug} if !defined $debug && exists $session{debug};
        $debug{$ident} = $debug;
        $session{debug} = $debug if defined $debug;
        if(!defined $logfiles{$ident}){
            my $log;
            my $logpath = $logpaths{$ident};
            if($debug){
                if(open($log, '>>', "$logpath/debug.log")){
                    $log->autoflush(1);
                }else{
                    die "could not open $logpath/debug.log $!";
                }
            }
            $self->debug_init($debug, $log);
        }

        my $delete  = $req->param('delete');

        my @params          = $req->param;
        my @delete_set;
        for (@params){
            if(m/^delete_set\[\d+\]$/){
                push @delete_set, $req->param($_);
            }
        }
        $self->log(Data::Dumper->Dump([\@params, \@delete_set], [qw(@params @delete_set)]));

        if(@delete_set && join(',', @delete_set) =~ m/^\d+(?:,\d+)*$/){
            my @msgs;
            my $return = 1;
            if($delete eq 'Delete Pages'){
                for my $page_id (@delete_set){
                    my $sql  = "DELETE FROM page_section WHERE pages_id = ?;\n";
                    my $query           = $db->prepare($sql);
                    my $result;
                    eval {
                        $result         = $query->execute($page_id);
                    };
                    if($@){
                        push @msgs,  "Error: Delete page_section failed: $@";
                        $return = 0;
                        $query->finish();
                        next;
                    }
                    if($result){
                        push @msgs,  "Delete page_section Success";
                        $sql  = "DELETE FROM pages WHERE id = ?;\n";
                        $query           = $db->prepare($sql);
                        eval {
                            $result         = $query->execute($page_id);
                        };
                        if($@){
                            push @msgs,  "Error: Delete Pages failed: $@";
                            $return = 0;
                            $query->finish();
                            next;
                        }
                        if($return){
                            push @msgs,  "Delete Pages Succeeded: $result";
                        }else{
                            $return = 0;
                            push @msgs,  "Error: Delete Pages failed";
                        }
                        $query->finish();
                    }
                }
            }
            $self->message($debug, \%session, $db, 'delete_pages', 'Delete some more pages', undef, @msgs);

            untie %session;
            $db->disconnect;
            return $return;
        }

        my $sql  = "SELECT p.id, p.name, p.full_name FROM pages p\n";
        $sql    .= "ORDER BY p.name, p.full_name\n";
        my $query           = $db->prepare($sql);
        my $result;
        eval {
            $result         = $query->execute();
        };
        if($@){
            $self->message($debug, \%session, $db, 'delete_pages', undef, undef, "Error: $@");
            $query->finish();
            return 0;
        }
        $self->log(Data::Dumper->Dump([$query, $result, $sql], [qw(query result sql)]));
        my @pages;
        my $r           = $query->fetchrow_hashref();
        while($r){
            push @pages, $r;
            $r       = $query->fetchrow_hashref();
        }
        $query->finish();
        
        say "        <form action=\"delete-pages.pl\" method=\"post\">";
        say "            <h1>Delete Pages</h1>";
        my $page_length = $req->param('page_length');
        $page_length = $session{page_length} if !defined $page_length && exists $session{page_length};
        $page_length    = 25 if !defined $page_length || $page_length < 10 || $page_length > 180;
        $session{page_length} = $page_length;
        $session{debug} = $debug if defined $debug;

        untie %session;
        $db->disconnect;

        say "            <table>";
        say "                <tr>";
        say "                    <td colspan=\"3\">";
        say "                        <label for=\"page_length\">Page Length:";
        say "                            <input type=\"number\" name=\"page_length\" id=\"page_length\" min=\"10\" max=\"180\" step=\"1\" value=\"$page_length\" size=\"3\">";
        say "                        </label>";
        say "                    </td>";
        say "                </tr>";
        say "                <tr><th>Name</th><th>Full Name</th><th>Select</th></tr>";
        my $cnt = 0;
        for my $row (@pages){
            $cnt++;
            my $page_id    = $row->{id};
            my $name       = $row->{name};
            my $full_name  = $row->{full_name};
            say "                <tr>";
            say "                    <td>";
            say "                        <label for=\"$page_id\">$name</label>";
            say "                    </td>";
            say "                    <td>";
            say "                        <label for=\"$page_id\">$full_name</label>";
            say "                    </td>";
            say "                    <td>";
            say "                        <input type=\"checkbox\" name=\"delete_set[$cnt]\" id=\"$page_id\" value=\"$page_id\"/>";
            say "                    </td>";
            say "                </tr>";
            if($cnt % $page_length == 0){
                say "                <tr><th>Name</th><th>Full Name</th><th>Select</th></tr>";
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
        say "                        <input name=\"delete\" type=\"submit\" value=\"Delete Pages\">";
        say "                    </td>";
        say "                </tr>";
        say "            </table>";
        say "        </form>";

        return 1;
    } ## --- end sub delete_pages


    sub delete_pseudo_page {
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
            tie %session, 'Apache::Session::Postgres', $id, {
                Handle => $db,
                TableName => 'sessions', 
                #Commit     => 1
            };
        }else{
            tie %session, 'Apache::Session::Postgres', undef(), {
                Handle => $db,
                TableName => 'sessions', 
                #Commit     => 1
            };
            $self->set_cookie("SESSION_ID=$session{_session_id}", $cfg, $rec);
        }

        $self->links('delete_pseudo_page', \%session);

        $debug    = $session{debug} if !defined $debug && exists $session{debug};
        $debug{$ident} = $debug;
        $session{debug} = $debug if defined $debug;
        if(!defined $logfiles{$ident}){
            my $log;
            my $logpath = $logpaths{$ident};
            if($debug){
                if(open($log, '>>', "$logpath/debug.log")){
                    $log->autoflush(1);
                }else{
                    die "could not open $logpath/debug.log $!";
                }
            }
            $self->debug_init($debug, $log);
        }

        my $delete  = $req->param('delete');

        my @params  = $req->param;
        my @delete_set;
        for (@params){
            if(m/^delete_set\[\d+\]$/){
                push @delete_set, $req->param($_);
            }
        }
        $self->log(Data::Dumper->Dump([\@params, \@delete_set], [qw(@params @delete_set)]));

        if(@delete_set && join(',', @delete_set) =~ m/^\d+(?:,\d+)*$/){
            my @msgs;
            my $return = 1;
            if($delete eq 'Delete Pseudo-Pages'){
                for my $page_id (@delete_set){
                    my $sql  = "DELETE FROM pseudo_pages WHERE id = ?;\n";
                    my $query           = $db->prepare($sql);
                    my $result;
                    eval {
                        $result         = $query->execute($page_id);
                    };
                    if($@){
                        push @msgs,  "Error: Delete from pseudo_pages failed: $@";
                        $return = 0;
                        $query->finish();
                        next;
                    }
                    if($result){
                        push @msgs,  "Delete pseudo_pages Success";
                        $query->finish();
                    }else{
                        push @msgs,  "Delete pseudo_pages failed";
                        $query->finish();
                    }
                }
            }
            $self->message($debug, \%session, $db, 'delete_pseudo_page', 'Delete some more pseudo_pages', undef, @msgs);

            untie %session;
            $db->disconnect;
            return $return;
        }

        my $sql  = "SELECT pp.id, pp.name, pp.full_name, pp.pattern, pp.status FROM pseudo_pages pp\n";
        $sql    .= "ORDER BY pp.name, pp.full_name\n";
        my $query           = $db->prepare($sql);
        my $result;
        eval {
            $result         = $query->execute();
        };
        if($@){
            $self->message($debug, \%session, $db, 'delete_pseudo_page', undef, undef, "Error: $@", "Cannot read from pseudo_pages");
            $query->finish();
            return 0;
        }
        $self->log(Data::Dumper->Dump([$query, $result, $sql], [qw(query result sql)]));
        my @pseudo_pages;
        my $r           = $query->fetchrow_hashref();
        while($r){
            push @pseudo_pages, $r;
            $r       = $query->fetchrow_hashref();
        }
        $query->finish();
        
        say "        <form action=\"delete-pseudo-page.pl\" method=\"post\">";
        say "            <h1>Delete Pseudo-Pages</h1>";
        my $page_length = $req->param('page_length');
        $page_length = $session{page_length} if !defined $page_length && exists $session{page_length};
        $page_length    = 25 if !defined $page_length || $page_length < 10 || $page_length > 180;
        $session{page_length} = $page_length;
        $session{debug} = $debug if defined $debug;

        untie %session;
        $db->disconnect;

        say "            <table>";
        say "                <tr>";
        say "                    <td colspan=\"3\">";
        say "                        <label for=\"page_length\">Page Length:";
        say "                            <input type=\"number\" name=\"page_length\" id=\"page_length\" min=\"10\" max=\"180\" step=\"1\" value=\"$page_length\" size=\"3\">";
        say "                        </label>";
        say "                    </td>";
        say "                </tr>";
        say "                <tr><th>Name</th><th>Full Name</th><th>Pattern</th><th>Status</th><th>Select</th></tr>";
        my $cnt = 0;
        for my $pp (@pseudo_pages){
            $cnt++;
            my $pseudo_page_id = $pp->{id};
            my $name           = $pp->{name};
            my $full_name      = $pp->{full_name};
            my $pattern        = $pp->{pattern};
            my $status         = $pp->{status};
            say "                <tr>";
            say "                    <td>";
            say "                        <label for=\"$pseudo_page_id\">$name</label>";
            say "                    </td>";
            say "                    <td>";
            say "                        <label for=\"$pseudo_page_id\">$full_name</label>";
            say "                    </td>";
            say "                    <td>";
            say "                        <label for=\"$pseudo_page_id\">$pattern</label>";
            say "                    </td>";
            say "                    <td>";
            say "                        <label for=\"$pseudo_page_id\">$status</label>";
            say "                    </td>";
            say "                    <td>";
            say "                        <input type=\"checkbox\" name=\"delete_set[$cnt]\" id=\"$pseudo_page_id\" value=\"$pseudo_page_id\"/>";
            say "                    </td>";
            say "                </tr>";
            if($cnt % $page_length == 0){
                say "                <tr><th>Name</th><th>Full Name</th><th>Pattern</th><th>Status</th><th>Select</th></tr>";
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
        say "                    <td colspan=\"3\">";
        say "                        <input name=\"delete\" type=\"submit\" value=\"Delete Pseudo-Pages\">";
        say "                    </td>";
        say "                </tr>";
        say "            </table>";
        say "        </form>";

        return 1;
    } ## --- end sub delete_pseudo_page


    sub delete_aliases {
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
            tie %session, 'Apache::Session::Postgres', $id, {
                Handle => $db,
                TableName => 'sessions', 
                #Commit     => 1
            };
        }else{
            tie %session, 'Apache::Session::Postgres', undef(), {
                Handle => $db,
                TableName => 'sessions', 
                #Commit     => 1
            };
            $self->set_cookie("SESSION_ID=$session{_session_id}", $cfg, $rec);
        }

        $self->links('delete_aliases', \%session);

        my $delete  = $req->param('delete');

        my @params          = $req->param;
        my @delete_set;
        for (@params){
            if(m/^delete_set\[\d+\]$/){
                push @delete_set, $req->param($_);
            }
        }
        $self->log(Data::Dumper->Dump([\@params, \@delete_set], [qw(@params @delete_set)]));

        if(@delete_set && join(',', @delete_set) =~ m/^\d+(?:,\d+)*$/){
            my @msgs;
            my $return = 1;
            if($delete eq 'Delete Aliases'){
                for my $page_id (@delete_set){
                    my $sql  = "DELETE FROM alias WHERE id = ?;\n";
                    my $query           = $db->prepare($sql);
                    my $result;
                    eval {
                        $result         = $query->execute($page_id);
                    };
                    if($@){
                        push @msgs,  "Error: Delete Aliases failed: $@";
                        $return = 0;
                        $query->finish();
                        next;
                    }
                    if($result){
                        push @msgs,  "Delete Aliases Succeeded:";
                        $query->finish();
                    }else{
                        push @msgs,  "Delete Aliases Failed";
                        $query->finish();
                    }
                }
            }
            $self->message($debug, \%session, $db, 'delete_aliases', 'Delete some more Aliases', undef, @msgs);
            return $return;
        }

        my $sql  = "SELECT a.id, a.name, a.section FROM aliases a\n";
        $sql    .= "ORDER BY a.name, a.section\n";
        my $query           = $db->prepare($sql);
        my $result;
        eval {
            $result         = $query->execute();
        };
        if($@){
            $self->message($debug, \%session, $db, 'delete_aliases', undef, "Error: $@", "Cannnot Read aliases");
            $query->finish();
            return 0;
        }
        $self->log(Data::Dumper->Dump([$query, $result, $sql], [qw(query result sql)]));
        my @aliases;
        my $r           = $query->fetchrow_hashref();
        while($r){
            push @aliases, $r;
            $r       = $query->fetchrow_hashref();
        }
        $query->finish();
        
        say "        <form action=\"delete-aliases.pl\" method=\"post\">";
        say "            <h1>Delete Aliases</h1>";
        my $page_length = $req->param('page_length');
        $page_length = $session{page_length} if !defined $page_length && exists $session{page_length};
        $page_length    = 25 if !defined $page_length || $page_length < 10 || $page_length > 180;
        $session{page_length} = $page_length;
        $session{debug} = $debug if defined $debug;

        $debug    = $session{debug} if !defined $debug && exists $session{debug};
        $debug{$ident} = $debug;
        $session{debug} = $debug if defined $debug;
        if(!defined $logfiles{$ident}){
            my $log;
            my $logpath = $logpaths{$ident};
            if($debug){
                if(open($log, '>>', "$logpath/debug.log")){
                    $log->autoflush(1);
                }else{
                    die "could not open $logpath/debug.log $!";
                }
            }
            $self->debug_init($debug, $log);
        }

        untie %session;
        $db->disconnect;

        say "            <table>";
        say "                <tr>";
        say "                    <td colspan=\"3\">";
        say "                        <label for=\"page_length\">Page Length:";
        say "                            <input type=\"number\" name=\"page_length\" id=\"page_length\" min=\"10\" max=\"180\" step=\"1\" value=\"$page_length\" size=\"3\">";
        say "                        </label>";
        say "                    </td>";
        say "                </tr>";
        say "                <tr><th>Name</th><th>Full Name</th><th>Select</th></tr>";
        my $cnt = 0;
        for my $row (@aliases){
            $cnt++;
            my $alias_id   = $row->{id};
            my $name       = $row->{name};
            my $section    = $row->{section};
            say "                <tr>";
            say "                    <td>";
            say "                        <label for=\"$alias_id\">$name</label>";
            say "                    </td>";
            say "                    <td>";
            say "                        <label for=\"$alias_id\">$section</label>";
            say "                    </td>";
            say "                    <td>";
            say "                        <input type=\"checkbox\" name=\"delete_set[$cnt]\" id=\"$alias_id\" value=\"$alias_id\"/>";
            say "                    </td>";
            say "                </tr>";
            if($cnt % $page_length == 0){
                say "                <tr><th>Name</th><th>Full Name</th><th>Select</th></tr>";
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
        say "                        <input name=\"delete\" type=\"submit\" value=\"Delete Aliases\">";
        say "                    </td>";
        say "                </tr>";
        say "            </table>";
        say "        </form>";

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


    sub user {
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
            tie %session, 'Apache::Session::Postgres', $id, {
                Handle => $db,
                TableName => 'sessions', 
                #Commit     => 1
            };
        }else{
            tie %session, 'Apache::Session::Postgres', undef(), {
                Handle => $db,
                TableName => 'sessions', 
                #Commit     => 1
            };
            $self->set_cookie("SESSION_ID=$session{_session_id}", $cfg, $rec);
        }

        $debug    = $session{debug} if !defined $debug && exists $session{debug};
        $debug{$ident} = $debug;
        $session{debug} = $debug if defined $debug;
        if(!defined $logfiles{$ident}){
            my $log;
            my $logpath = $logpaths{$ident};
            if($debug){
                if(open($log, '>>', "$logpath/debug.log")){
                    $log->autoflush(1);
                }else{
                    die "could not open $logpath/debug.log $!";
                }
            }
            $self->debug_init($debug, $log);
        }

        $self->links('user', \%session);

        my $loggedin           = $session{loggedin};
        my $loggedin_id        = $session{loggedin_id};
        my $loggedin_username  = $session{loggedin_username};
        my $loggedin_admin     = $session{loggedin_admin};
        my $isadmin;
        if($loggedin && $loggedin_id && $loggedin_username){
            my @msgs;
            my $return = 1;
            my $sql  = "SELECT p._admin, p.username FROM passwd p\n";
            $sql    .= "WHERE p.id = ?\n";
            my $query  = $db->prepare($sql);
            my $result;
            eval {
                $result = $query->execute($loggedin_id);
            };
            if($@){
                push @msgs, "Insert into _group failed: $@";
                $return = 0;
            }
                $self->log(Data::Dumper->Dump([$debug, \%session, $loggedin_username, $loggedin_id, $sql], [qw(debug %session loggedin_username loggedin_id sql)]));
            if($return){
                my $r      = $query->fetchrow_hashref();
                $self->log(Data::Dumper->Dump([$debug, \%session, $r, $loggedin_username, $loggedin_id, $sql], [qw(debug %session r loggedin_username loggedin_id sql)]));
                if($r->{username} eq $loggedin_username){
                    $isadmin = $r->{_admin};
                }
            }else{
                $return = 0;
                push @msgs, "could not find your record somethinnng is wrong with your login";
            }
            $query->finish();
            if($loggedin_admin != $isadmin){
                $return = 0;
                push @msgs, "session admin rights did nnot match db something is wrong!!!!";
            }
            $self->message($debug, \%session, $db, ($return?'main':'user'), ($return ? 'user' : undef), !$return && @msgs, @msgs) if @msgs;

            unless($return){
                untie %session;
                $db->disconnect;
                return 0;
            }
        }

        my $submit  = $req->param('submit');

        my @params  = $req->param;
        my @selected;
        for (@params){
            if(m/^selected_\[\d+\]$/){
                push @selected, $req->param($_);
            }        }
        if($submit){
            my @msgs;
            my $return = 1;
            if($submit eq 'Toggle Admin Flag'){
                for my $passwd_id (@selected){
                    if($passwd_id == 1){
                        push @msgs, "leave user id == 1 alone this is a reserved account";
                        next;
                    }
                    my $sql  = "UPDATE passwd SET _admin = NOT _admin WHERE id = ?;\n";
                    my $query  = $db->prepare($sql);
                    my $result;
                    eval {
                        $result = $query->execute($passwd_id);
                    };
                    if($@){
                        push @msgs, "UPDATE passwd passwd_id = $passwd_id failed: $@";
                        $return = 0;
                    }
                    if($result){
                    }
                }
                push @msgs, "Nothing to change" unless @selected;
            }elsif($submit eq 'Delete Users'){
                for my $passwd_id (@selected){
                    if($passwd_id == 1){
                        push @msgs, "leave user id == 1 alone this is a reserved account";
                        next;
                    }
                    my $sql  = "SELECT p.username, p.passwd_details_id, p.primary_group_id, p.email_id FROM passwd p\n";
                    $sql    .= "WHERE p.id = ?\n";
                    my $query  = $db->prepare($sql);
                    my $result;
                    eval {
                        $result = $query->execute($passwd_id);
                    };
                    if($@){
                        push @msgs, "SELECT passwd passwd_id = $passwd_id failed: $@";
                        $return = 0;
                    }
                    if($result){
                        my $r                 = $query->fetchrow_hashref();
                        my $username          = $r->{username};
                        my $passwd_details_id = $r->{passwd_details_id};
                        my $primary_group_id  = $r->{primary_group_id};
                        my $email_id          = $r->{email_id};
                        my ($return_email, @msgs_email) = $self->delete_email($email_id, $db);
                        push @msgs, @msgs_email;
                        $return = 0 unless $return_email;
                        my ($return_group, @msgs_group) = $self->delete_group($primary_group_id, $db);
                        push @msgs, @msgs_group;
                        $return = 0 unless $return_group;
                        my ($return_passwd_details, @msgs_passwd_details) = $self->delete_passwd_details($passwd_details_id, $db);
                        push @msgs, @msgs_passwd_details;
                        $return = 0 unless $return_passwd_details;
                        $sql     = "DELETE FROM passwd\n";
                        $sql    .= "WHERE id = ?\n";
                    }
                }
                push @msgs, "Nothing to change" unless @selected;
            }
            $self->message($debug, \%session, $db, ($return?'main':'user'), ($return ? 'continue' : undef), 1, @msgs) if @msgs;
        }

        my @user_details;
        my $sql  = "SELECT p.id, p.username, p.primary_group_id, p._admin, pd.display_name, pd.given, pd._family,\n";
        $sql    .= "e._email, ph._number phone_number, g._name groupname, g.id group_id\n";
        $sql    .= "FROM passwd p JOIN passwd_details pd ON p.passwd_details_id = pd.id JOIN email e ON p.email_id = e.id\n";
        $sql    .= "         LEFT JOIN phone  ph ON ph.id = pd.primary_phone_id JOIN _group g ON p.primary_group_id = g.id\n";
        $sql    .= "ORDER BY p.username, pd.given, pd._family\n";
        my $query  = $db->prepare($sql);
        my $result;
        my @msgs;
        my $return = 1;
        eval {
            $result = $query->execute();
        };
        if($@){
            push @msgs, "SELECT FROM passwd failed: $@";
            $return = 0;
        }
        if($result){
            my $r      = $query->fetchrow_hashref();
            while($r){
                push @user_details, $r;
                $r      = $query->fetchrow_hashref();
            }
        }else{
            push @msgs, "SELECT FROM passwd failed";
            $return = 0;
        }
        unless($return){
            $self->message($debug, \%session, $db, 'user', undef, undef, @msgs) if @msgs;
            return $return;
        }
        
        say "        <form action=\"user.pl\" method=\"post\">";
        say "            <h1>Edit User Details</h1>";
        my $page_length = $req->param('page_length');
        $page_length = $session{page_length} if !defined $page_length && exists $session{page_length};
        $page_length    = 25 if !defined $page_length || $page_length < 10 || $page_length > 180;
        $session{page_length} = $page_length;

        untie %session;
        $db->disconnect;

        say "            <table>";
        say "                <tr>";
        say "                    <td colspan=\"5\">";
        say "                        <label for=\"page_length\">Page Length:";
        say "                            <input type=\"number\" name=\"page_length\" id=\"page_length\" min=\"10\" max=\"180\" step=\"1\" value=\"$page_length\" size=\"3\">";
        say "                        </label>";
        say "                    </td>";
        say "                    <td colspan=\"4\">";
        say "                    <input type=\"submit\" name=\"submit\" id=\"apply_page_length\" value=\"Apply Page Length\"/>";
        say "                    </td>";
        say "                </tr>";
        say "                <tr><th>id</th><th>username</th><th>given names</th><th>family name</th><th>email</th><th>phone_number</th><th>group</th><th>admin</th><th>selected</th></tr>";
        my $cnt = 0;
        for my $user (@user_details){
            $cnt++;
            my $passwd_id         = $user->{id};
            my $username          = $user->{username};
            my $primary_group_id  = $user->{group_id};
            my $_admin            = $user->{_admin};
            my $display_name      = $user->{display_name};
            my $given             = $user->{given};
            my $family            = $user->{_family};
            my $email             = $user->{_email};
            my $phone_number      = $user->{phone_number};
            $phone_number         = '' unless defined $phone_number;
            my $groupname         = $user->{groupname};
            my $_admin_checked;
            if($_admin){
                $_admin_checked = '&radic;';
            }else{
                $_admin_checked = '&otimes;';
            }
            say "                <tr>";
            say "                    <td>";
            say "                        <div><label for=\"selected_$passwd_id\">$passwd_id</label></div>";
            say "                    </td>";
            say "                    <td>";
            say "                        <div><label for=\"selected_$passwd_id\">$username</label></div>";
            say "                    </td>";
            say "                    <td>";
            say "                        <div><label for=\"selected_$passwd_id\">$given</label></div>";
            say "                    </td>";
            say "                    <td>";
            say "                        <div><label for=\"selected_$passwd_id\">$family</label></div>";
            say "                    </td>";
            say "                    <td>";
            say "                        <div><label for=\"selected_$passwd_id\">$email</label></div>";
            say "                    </td>";
            say "                    <td>";
            say "                        <div><label for=\"selected_$passwd_id\">$phone_number</label></div>";
            say "                    </td>";
            say "                    <td>";
            say "                        <div><label for=\"selected_$passwd_id\">$groupname</label></div>";
            say "                    </td>";
            say "                    <td>";
            say "                        <div><label for=\"selected_$passwd_id\">$_admin_checked</label></div>";
            say "                    </td>";
            say "                    <td>";
            say "                        <div><label for=\"selected_$passwd_id\"><input type=\"checkbox\" name=\"selected_[$cnt]\" id=\"selected_$passwd_id\" value=\"$passwd_id\"/></label></div>";
            say "                    </td>";
            say "                </tr>";
            if($cnt % $page_length == 0){
                say "                <tr><th>id</th><th>username</th><th>given names</th><th>family name</th><th>email</th><th>phone_number</th><th>group</th><th>admin</th><th>selected</th></tr>";
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
        say "                    <td colspan=\"3\">";
        say "                        <input name=\"submit\" type=\"submit\" value=\"Delete Users\">";
        say "                    </td>";
        say "                    <td colspan=\"4\">";
        say "                        <input name=\"submit\" type=\"submit\" value=\"Toggle Admin Flag\">";
        say "                    </td>";
        say "                </tr>";
        say "            </table>";
        say "        </form>";

        return 1;
    } ## --- end sub user


    sub delete_orphaned_links_sections {
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
            tie %session, 'Apache::Session::Postgres', $id, {
                Handle => $db,
                TableName => 'sessions', 
                #Commit     => 1
            };
        }else{
            tie %session, 'Apache::Session::Postgres', undef(), {
                Handle => $db,
                TableName => 'sessions', 
                #Commit     => 1
            };
            $self->set_cookie("SESSION_ID=$session{_session_id}", $cfg, $rec);
        }

        my $delete  = $req->param('delete');

        my @params          = $req->param;
        my @delete_set;
        for (@params){
            if(m/^delete_set\[\d+\]$/){
                push @delete_set, $req->param($_);
            }
        }

        $self->links('delete_orphaned_links_sections', \%session);

        $self->log(Data::Dumper->Dump([\@params, \@delete_set], [qw(@params @delete_set)]));

        if(@delete_set && join(',', @delete_set) =~ m/^\d+(?:,\d+)*$/){
            my @msgs;
            my $return = 1;
            if($delete eq 'Delete Orphans'){
                for my $links_section_id (@delete_set){
                    my $sql  = "DELETE FROM links_sections WHERE id = ?;\n";
                    my $query           = $db->prepare($sql);
                    my $result;
                    eval {
                        $result         = $query->execute($links_section_id);
                    };
                    if($@){
                        push @msgs,  "Error: Delete links_sections failed: $@";
                        $return = 0;
                        $query->finish();
                        next;
                    }
                    if($result){
                        push @msgs,  "Delete links_sections Succeeded:";
                        $query->finish();
                    }else{
                        push @msgs,  "Delete links_sections Failed";
                        $query->finish();
                    }
                }
            }
            $self->message($debug, \%session, $db, 'delete_orphaned_links_sections', 'Delete some more links_sections', undef, @msgs);

            untie %session;
            $db->disconnect;
            return $return;
        }

        my $sql  = "SELECT ls.id, ls.section FROM links_sections ls\n";
        $sql    .= "WHERE (SELECT COUNT(*) n FROM links l WHERE l.section_id = ls.id) = 0\n";
        $sql    .= "ORDER BY ls.section\n";
        my $query       = $db->prepare($sql);
        my $result;
        eval {
            $result     = $query->execute();
        };
        if($@){
            $self->message($debug, \%session, $db, 'delete_orphaned_links_sections', undef, undef, "Error: $@", "Cannnot Read links_sections");
            $query->finish();
            return 0;
        }
        $self->log(Data::Dumper->Dump([$query, $result, $sql], [qw(query result sql)]));
        my @links_sections;
        my $r           = $query->fetchrow_hashref();
        while($r){
            push @links_sections, $r;
            $r          = $query->fetchrow_hashref();
        }
        $query->finish();
        
        say "        <form action=\"delete-orphaned-links-sections.pl\" method=\"post\">";
        say "            <h1>Delete Orphaned links_sections</h1>";
        my $page_length = $req->param('page_length');
        $page_length = $session{page_length} if !defined $page_length && exists $session{page_length};
        $page_length    = 25 if !defined $page_length || $page_length < 10 || $page_length > 180;
        $session{page_length} = $page_length;
        $session{debug} = $debug if defined $debug;

        $debug    = $session{debug} if !defined $debug && exists $session{debug};
        $debug{$ident} = $debug;
        $session{debug} = $debug if defined $debug;
        if(!defined $logfiles{$ident}){
            my $log;
            my $logpath = $logpaths{$ident};
            if($debug){
                if(open($log, '>>', "$logpath/debug.log")){
                    $log->autoflush(1);
                }else{
                    die "could not open $logpath/debug.log $!";
                }
            }
            $self->debug_init($debug, $log);
        }

        untie %session;
        $db->disconnect;

        say "            <table>";
        say "                <tr>";
        say "                    <td colspan=\"3\">";
        say "                        <label for=\"page_length\">Page Length:";
        say "                            <input type=\"number\" name=\"page_length\" id=\"page_length\" min=\"10\" max=\"180\" step=\"1\" value=\"$page_length\" size=\"3\">";
        say "                        </label>";
        say "                    </td>";
        say "                </tr>";
        if(@links_sections){
            say "                <tr><th colspan=\"2\">Name</th><th>Select</th></tr>";
            my $cnt = 0;
            for my $row (@links_sections){
                $cnt++;
                my $links_section_id = $row->{id};
                my $section          = $row->{section};
                say "                <tr>";
                say "                    <td colspan=\"2\">";
                say "                        <label for=\"$links_section_id\">$section</label>";
                say "                    </td>";
                say "                    <td>";
                say "                        <input type=\"checkbox\" name=\"delete_set[$cnt]\" id=\"$links_section_id\" value=\"$links_section_id\"/>";
                say "                    </td>";
                say "                </tr>";
                if($cnt % $page_length == 0){
                    say "                <tr><th colspan=\"2\">Name</th><th>Select</th></tr>";
                }
            }
        }else{
            say "                <tr><th colspan=\"3\">Message</th></tr>";
            say "                <tr>";
            say "                    <td colspan=\"3\">";
            say "                        No Orphans Found!!!";
            say "                    </td>";
            say "                </tr>";
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
        say "                        <input name=\"delete\" type=\"submit\" value=\"Delete Orphans\">";
        say "                    </td>";
        say "                </tr>";
        say "            </table>";
        say "        </form>";

        return 1;
    } ## --- end sub delete_orphaned_links_sections


    sub generate_hash {
        my ($self, $password) = @_;
        my $ident           = ident $self;
        my $debug = $debug{$ident};
        my $pbkdf2 = Crypt::PBKDF2->new(
            hash_class => 'HMACSHA2',
            #hash_class => 'HMACSHA1',
            hash_args => {sha_size => 512}, 
            iterations => 2048,
            output_len => 64,
            salt_len => 16,
            length_limit => 144, 
        );
                
        return $pbkdf2->generate($password);
    } ## --- end sub generate_hash


    sub validate {
        my ($self, $hashed_password, $password) = @_;
        my $ident           = ident $self;
        my $debug = $debug{$ident};
        my $pbkdf2 = Crypt::PBKDF2->new(
            hash_class => 'HMACSHA2',
            #hash_class => 'HMACSHA1',
            hash_args => {sha_size => 512}, 
            iterations => 2048,
            output_len => 64,
            salt_len => 16,
            length_limit => 144,
        );
        # {X-PBKDF2}HMACSHA2+512:AAAIAA:qtOZmwbsxBbP/sfUMwz2Kg==:25GQkZE/+11PpHQ6EZKHre68P7yocSelwc7m/GgZhALXcVUbnBRXTAm0Wd+H8sVtjvwCf7klz5SC/GlznXrFLA==
                
        return $pbkdf2->validate($hashed_password, $password);
    } ## --- end sub validate


    sub login {
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
            tie %session, 'Apache::Session::Postgres', $id, {
                Handle => $db,
                TableName => 'sessions', 
                #Commit     => 1
            };
        }else{
            tie %session, 'Apache::Session::Postgres', undef(), {
                Handle => $db,
                TableName => 'sessions', 
                #Commit     => 1
            };
            $self->set_cookie("SESSION_ID=$session{_session_id}", $cfg, $rec);
        }

        $debug    = $session{debug} if !defined $debug && exists $session{debug};
        $debug{$ident} = $debug;
        $session{debug} = $debug if defined $debug;
        if(!defined $logfiles{$ident}){
            my $log;
            my $logpath = $logpaths{$ident};
            if($debug){
                if(open($log, '>>', "$logpath/debug.log")){
                    $log->autoflush(1);
                }else{
                    die "could not open $logpath/debug.log $!";
                }
            }
            $self->debug_init($debug, $log);
        }

        $self->links('login', \%session);

        my $submit    = $req->param('submit');
        my $username  = $req->param('username');
        my $password  = $req->param('password');
        $username   = '' unless defined $username;
        $password   = '' unless defined $password;

        if(defined $username && defined $password && $username =~ m/^\w+$/){
            my @msgs;
            my $return = 1;
            my $sql  = "SELECT p.id, p.username, p._password, p.primary_group_id, p._admin, pd.display_name, pd.given, pd._family,\n";
            $sql    .= "e._email, ph._number phone_number, g._name groupname, g.id group_id\n";
            $sql    .= "FROM passwd p JOIN passwd_details pd ON p.passwd_details_id = pd.id JOIN email e ON p.email_id = e.id\n";
            $sql    .= "         LEFT JOIN phone  ph ON ph.id = pd.primary_phone_id JOIN _group g ON p.primary_group_id = g.id\n";
            $sql    .= "WHERE p.username = ?\n";
            my $query  = $db->prepare($sql);
            my $result;
            eval {
                $result = $query->execute($username);
            };
            if($@){
                push @msgs, "SELECT FROM passwd failed: $@";
                $return = 0;
            }
            if($result){
                my $r      = $query->fetchrow_hashref();
                my $loggedin_id       = $r->{id};
                my $loggedin_username = $r->{username};
                my $primary_group_id  = $r->{group_id};
                my $hashed_password   = $r->{_password};
                my $_admin            = $r->{_admin};
                my $display_name      = $r->{display_name};
                my $given             = $r->{given};
                my $family            = $r->{_family};
                my $email             = $r->{_email};
                my $phone_number      = $r->{phone_number};
                my $groupname        = $r->{groupname};
                $self->log(Data::Dumper->Dump([$loggedin_id, $r], [qw(loggedin_id r)]));
                $self->log(Data::Dumper->Dump([$sql, $loggedin_username, $primary_group_id, $hashed_password, $_admin,
                            $display_name, $given, $family, $email, $phone_number, $groupname],
                        [qw(sql loggedin_username primary_group_id hashed_password _admin display_name given family email phone_number roupname)]));

                $self->log(Data::Dumper->Dump([$result, $username, $password, $hashed_password], [qw(result username password hashed_password)]));
                if($self->validate($hashed_password, $password)){
                    $session{loggedin}               = $loggedin_id;
                    $session{loggedin_id}            = $loggedin_id;
                    $session{loggedin_username}      = $loggedin_username;
                    $session{loggedin_admin}         = $_admin;
                    $session{loggedin_display_name}  = $display_name;
                    $session{loggedin_given}         = $given;
                    $session{loggedin_family}        = $family;
                    $session{loggedin_email}         = $email;
                    $session{loggedin_phone_number}  = $phone_number;
                    $session{loggedin_groupname}     = $groupname;
                    $session{loggedin_groupnname_id} = $primary_group_id;
                    $self->log(Data::Dumper->Dump([$r, \%session], [qw(r %session)]));
                    push @msgs, "Loggedin";
                }
            }
            $query->finish();

            $self->message($debug, \%session, $db, ($return?'main':'login'), ($return ? 'continue' : undef), !$return, @msgs);

            $self->log(Data::Dumper->Dump([\%session], [qw(%session)]));

            untie %session;
            $db->disconnect;
            return $return;
        }


        untie %session;
        $db->disconnect;

        my $title   = "only a-z, A-Z, 0-9 and _  allowed";
        my $pattern = '[a-zA-Z0-9_]+';
        say "        <form action=\"login.pl\" method=\"post\">";
        say "            <h1>Login</h1>";
        say "            <table>";
        say "                <tr>";
        say "                    <td>";
        say "                        <label for=\"username\">Username: </label>";
        say "                    </td>";
        say "                    <td colspan=\"2\">";
        say "                        <input type=\"text\" name=\"username\" id=\"username\" placeholder=\"username\" pattern=\"$pattern\" title=\"$title\" value=\"$username\" autofocus required/>";
        say "                    </td>";
        say "                </tr>";
        $title   = "Passwords on this system are,  between 10 and 100 character's the more the better.\nAlso must include a least one lowercase one uppercase a digit and a puntuation character.";
        $pattern = '(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[^a-zA-Z0-9]).{10,100}';
        say "                <tr>";
        say "                    <td>";
        say "                        <label for=\"password\">password </label>";
        say "                    </td>";
        say "                    <td>";
        say "                        <input type=\"password\" name=\"password\" id=\"password\" placeholder=\"password\" minlength=\"10\" pattern=\"$pattern\" title=\"$title\" value=\"$password\" required/>";
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
        say "                        <input name=\"submit\" type=\"submit\" value=\"Login\">";
        say "                    </td>";
        say "                </tr>";
        say "            </table>";
        say "        </form>";

        return 1;
    } ## --- end sub login


    sub logout {
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
            tie %session, 'Apache::Session::Postgres', $id, {
                Handle => $db,
                TableName => 'sessions', 
                #Commit     => 1
            };
        }else{
            tie %session, 'Apache::Session::Postgres', undef(), {
                Handle => $db,
                TableName => 'sessions', 
                #Commit     => 1
            };
            $self->set_cookie("SESSION_ID=$session{_session_id}", $cfg, $rec);
        }

        $debug    = $session{debug} if !defined $debug && exists $session{debug};
        $debug{$ident} = $debug;
        $session{debug} = $debug if defined $debug;
        if(!defined $logfiles{$ident}){
            my $log;
            my $logpath = $logpaths{$ident};
            if($debug){
                if(open($log, '>>', "$logpath/debug.log")){
                    $log->autoflush(1);
                }else{
                    die "could not open $logpath/debug.log $!";
                }
            }
            $self->debug_init($debug, $log);
        }

        my $submit  = $req->param('submit');

        $submit     = '' unless defined $submit;

        if($submit eq 'Logout'){
            $session{loggedin}               = 0;
            $session{loggedin_id}            = 0;
            $session{loggedin_username}      = 0;
            $session{loggedin_admin}         = 0;
            $session{loggedin_display_name}  = 0;
            $session{loggedin_given}         = 0;
            $session{loggedin_family}        = 0;
            $session{loggedin_email}         = 0;
            $session{loggedin_phone_number}  = 0;
            $session{loggedin_groupname}     = 0;
            $session{loggedin_groupnname_id} = 0;

            $self->links('logout', \%session);

            untie %session;
            $db->disconnect;

            return 1;
        }elsif($submit eq 'Cancel'){
            $self->links('logout', \%session);

            untie %session;
            $db->disconnect;

            return 1;
        }else{
            $self->links('logout', \%session);

            say "        <form action=\"logout.pl\" method=\"post\">";
            say "            <h1>Logout</h1>";
        }


        untie %session;
        $db->disconnect;

        say "            <table>";
        say "                <tr>";
        say "                    <td colspan=\"3\">";
        say "                        <input type=\"submit\" name=\"submit\" id=\"cancel\" value=\"Cancel\"/>";
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
        say "                        <input name=\"submit\" type=\"submit\" value=\"Logout\">";
        say "                    </td>";
        say "                </tr>";
        say "            </table>";
        say "        </form>";

        return 1;
    } ## --- end sub logout


    sub register {
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
            tie %session, 'Apache::Session::Postgres', $id, {
                Handle => $db,
                TableName => 'sessions', 
                #Commit     => 1
            };
        }else{
            tie %session, 'Apache::Session::Postgres', undef(), {
                Handle => $db,
                TableName => 'sessions', 
                #Commit     => 1
            };
            $self->set_cookie("SESSION_ID=$session{_session_id}", $cfg, $rec);
        }

        $debug    = $session{debug} if !defined $debug && exists $session{debug};
        $debug{$ident} = $debug;
        $session{debug} = $debug if defined $debug;
        if(!defined $logfiles{$ident}){
            my $log;
            my $logpath = $logpaths{$ident};
            if($debug){
                if(open($log, '>>', "$logpath/debug.log")){
                    $log->autoflush(1);
                }else{
                    die "could not open $logpath/debug.log $!";
                }
            }
            $self->debug_init($debug, $log);
        }

        $self->links('register', \%session);

        my $submit             = $req->param('submit');
        my $username           = $req->param('username');
        my $email              = $req->param('email');
        my $password           = $req->param('password');
        my $repeat             = $req->param('repeat');
        my $mobile             = $req->param('mobile');
        my $phone              = $req->param('phone');
        my $unit               = $req->param('unit');
        my $street             = $req->param('street');
        my $city_suberb        = $req->param('city_suberb');
        my $postcode           = $req->param('postcode');
        my $region             = $req->param('region');
        my $country            = $req->param('country');
        my $postal_same        = $req->param('postal_same');
        my $postal_unit        = $req->param('postal_unit');
        my $postal_street      = $req->param('postal_street');
        my $postal_city_suberb = $req->param('postal_city_suberb');
        my $postal_postcode    = $req->param('postal_postcode');
        my $postal_region      = $req->param('postal_region');
        my $postal_country     = $req->param('postal_country');
        my $given              = $req->param('given');
        my $family             = $req->param('family');
        my $display_name       = $req->param('display_name');
        my $admin              = $req->param('admin');

        my $loggedin           = $session{loggedin};
        my $loggedin_id        = $session{loggedin_id};
        my $loggedin_username  = $session{loggedin_username};
        my $isadmin;
        if($loggedin && $loggedin_id && $loggedin_username){
            my @msgs;
            my $return = 1;
            my $sql  = "SELECT p._admin, p.username FROM passwd p\n";
            $sql    .= "WHERE p.id = ?\n";
            my $query  = $db->prepare($sql);
            my $result;
            eval {
                $result = $query->execute($loggedin_id);
            };
            if($@){
                push @msgs, "Insert into _group failed: $@";
                $return = 0;
            }
                $self->log(Data::Dumper->Dump([$debug, \%session, $loggedin_username, $loggedin_id, $sql], [qw(debug %session loggedin_username loggedin_id sql)]));
            if($return){
                my $r      = $query->fetchrow_hashref();
                $self->log(Data::Dumper->Dump([$debug, \%session, $r, $loggedin_username, $loggedin_id, $sql], [qw(debug %session r loggedin_username loggedin_id sql)]));
                if($r->{username} eq $loggedin_username){
                    $isadmin = $r->{_admin};
                }
            }else{
                $return = 0;
                push @msgs, "could not find your record somethinnng is wrong with your login";
            }
            $query->finish();
            $self->message($debug, \%session, $db, ($return?'main':'register'), ($return ? 'register' : undef), !$return && @msgs, @msgs) if @msgs;

            unless($return){
                untie %session;
                $db->disconnect;
                return 0;
            }
        }

        $admin = 0 unless $isadmin; # admins can only be made by admins. #


        if($loggedin && !$isadmin){
            untie %session;
            $db->disconnect;
            return 0; # Only admins and nnew users should be usinng this page. #
        }

        $self->log(Data::Dumper->Dump([$username, $email, $password, $repeat, $given, $family, $display_name, $mobile, $phone,
                    $unit, $street, $city_suberb, $postcode, $region, $country, $postal_unit,
                    $postal_street, $postal_city_suberb, $postal_postcode, $postal_region,
                    $postal_country, $postal_same, $loggedin, $loggedin_id, $loggedin_username, $isadmin, $admin],
                    [qw(username email password repeat given family display_name
                    mobile phone unit street city_suberb postcode region country postal_unit postal_street
                    postal_city_suberb postal_postcode postal_region postal_country postal_same loggedin
                    loggedin_id loggedin_username isadmin admin)]));

        $unit                = encode_entities($unit)               if defined $unit;
        $street              = encode_entities($street)             if defined $street;
        $city_suberb         = encode_entities($city_suberb)        if defined $city_suberb;
        $country             = encode_entities($country)            if defined $country;
        $given               = encode_entities($given)              if defined $given;
        $family              = encode_entities($family)             if defined $family;
        $display_name        = encode_entities($display_name)       if defined $display_name;
        $postal_unit         = encode_entities($postal_unit)        if defined $postal_unit;
        $postal_street       = encode_entities($postal_street)      if defined $postal_street;
        $postal_city_suberb  = encode_entities($postal_city_suberb) if defined $postal_city_suberb;
        $postal_country      = encode_entities($postal_country)     if defined $postal_country;

        my $cond = defined $postal_street && defined $postal_country
                    && (!$postal_city_suberb || $postal_city_suberb =~ m/^[^\'\"]+$/)
                    && (!$postal_unit || $postal_unit =~ m/^[^\'\"]+$/) && $postal_street =~ m/^[^;\'\"]+$/
                    && $postal_city_suberb =~ m/^[^\'\"]+$/ && (!$postal_postcode || $postal_postcode =~ m/^[A-Z0-9 -]+$/)
                    && (!$postal_region || $postal_region =~ m/^[^\'\"]+$/) && $postal_country =~ m/^[^\'\"]+$/;

        my $line = __LINE__;
        $self->log(Data::Dumper->Dump([$cond, $postal_same, $line], [qw(cond postal_same line)]));

        if($password && $repeat
            && ($password !~ m/^(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[^a-zA-Z0-9]).{10,100}$/
                    || $repeat !~ m/^(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[[:punct:]]).{10,100}$/)){
            my $line = __LINE__;
            $self->log(Data::Dumper->Dump([$given, $family, $display_name, $line], [qw(given family display_name line)]));
            my @msgs = ('password and/or repeat password did not match requirements 10 to 100 chars a at least 1 lowercase and at least 1 uppercase character, a digit 0-9 and a puctuation character!');
            $self->message($debug, \%session, $db, 'register', undef, undef, 1, @msgs);
        }elsif(($password || $repeat) && $password ne $repeat){
            my $line = __LINE__;
            $self->log(Data::Dumper->Dump([$given, $family, $display_name, $line], [qw(given family display_name line)]));
            my @msgs = ('password and repeat password did not match!');
            $self->message($debug, \%session, $db, 'register', undef, 1, @msgs);
        }elsif(defined $username && defined $email && $password && $repeat
            && defined $street && defined $country
            && $username =~ m/^\w+$/ && $email =~ m/^(?:\w|-|\.|\+|\%)+\@[a-z0-9-]+(?:\.[a-z0-9-]+)+$/
            && (!$city_suberb || $city_suberb =~ m/^[^\'\"]+$/) 
            && (!$mobile || $mobile =~ m/^(?:\+61|0)?\d{3}[ -]?\d{3}[ -]?\d{3}$/) 
            && (!$phone || $phone =~ m/^(?:(?:\+61[ -]?\d|0\d|\(0\d\)|0\d)[ -]?)?\d{4}[ -]?\d{4}$/)
            && (!$unit || $unit =~ m/^[^\'\"]+$/) && $street =~ m/^[^\'\"]+$/
            && (!$postcode || $postcode =~ m/^[A-Z0-9 -]+$/)
            && (!$region || $region =~ m/^[^\;\'\"]+$/) && $country =~ m/^[^\;\'\"]+$/
            && $password =~ m/^(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[[:punct:]]).{10,100}$/
            && $repeat =~ m/^(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[[:punct:]]).{10,100}$/
            && ($postal_same?1:$cond)){
            $self->log(Data::Dumper->Dump([$given, $family, $display_name], [qw(given family display_name)]));
            $given = '' unless defined $given;
            $family = '' unless defined $family;
            $display_name = "$given $family" unless $display_name;
            $self->log(Data::Dumper->Dump([$given, $family, $display_name], [qw(given family display_name)]));
            my @msgs;
            my $return = 1;
            if($submit eq 'Register'){
                my $hashed_password = $self->generate_hash($password);
                my $line = __LINE__;
                $self->log(Data::Dumper->Dump([$password, $hashed_password, $line], [qw(password hashed_password line)]));
                if($self->validate($hashed_password, $password)){
                    my $line = __LINE__;
                    $self->log(Data::Dumper->Dump([$password, $hashed_password, $line], [qw(password hashed_password line)]));
                    my $sql    = "INSERT INTO _group(_name) VALUES(?);\n";
                    my $query  = $db->prepare($sql);
                    my $result;
                    eval {
                        $result = $query->execute($username);
                    };
                    if($@){
                        push @msgs, "Insert into _group failed: $@";
                        $return = 0;
                    }
                    $line = __LINE__;
                    $self->log(Data::Dumper->Dump([$return, $sql, $query, $result, $username, $line], [qw(return sql query result username line)]));
                    $query->finish();
                    if($result){
                        push @msgs, "Succeded in inserting primary group";
                        $sql       = "SELECT g.id FROM _group g\n";
                        $sql      .= "WHERE g._name = ?\n";
                        $query  = $db->prepare($sql);
                        eval {
                            $result = $query->execute($username);
                        };
                        if($@){
                            push @msgs, "Error: could not find the new _group please contact your webmaster";
                            $return = 0;
                        }
                        if($result){
                            my $r      = $query->fetchrow_hashref();
                            my $primary_group_id = $r->{id};
                            $line = __LINE__;
                            $self->log(Data::Dumper->Dump([$return, $sql, $query, $result, $primary_group_id, $line], [qw(return sql query result primary_group_id line)]));
                            $query->finish();
                            my ($residential_address_id, $return_res, @msgs_res_address) = $self->create_address($unit, $street, $city_suberb, $postcode, $region, $country, undef, $db);
                            $return = $return_res unless $return_res;
                            push @msgs, @msgs_res_address;
                            my $postal_address_id = $residential_address_id;
                            if(!$postal_same){
                                ($residential_address_id, $return_res, @msgs_res_address) = $self->create_address($postal_unit, $postal_street, $postal_city_suberb, $postal_postcode, $postal_region, $postal_country, $residential_address_id, $db);
                                $return = $return_res unless $return_res;
                                push @msgs, @msgs_res_address;
                            }
                            $line = __LINE__;
                            $self->log(Data::Dumper->Dump([$mobile, $phone, $line], [qw(mobile phone line)]));
                            my ($mobile_id, $phone_id);
                            my ($return_phone, @msgs_phone);
                            if($mobile){
                                ($mobile_id, $return_phone, @msgs_phone) = $self->create_phone($mobile, $db);
                                $return = $return_phone unless $return_phone;
                                push @msgs, @msgs_phone;
                            }
                            if($phone){
                                ($phone_id, $return_phone, @msgs_phone) = $self->create_phone($phone, $db);
                                $return = $return_phone unless $return_phone;
                                push @msgs, @msgs_phone;
                            }
                            my $primary_phone_id = $phone_id;
                            $primary_phone_id = $mobile_id if $mobile_id;
                            my ($return_email, $primary_email_id, @msgs_email);
                            ($primary_email_id, $return_email, @msgs_email) = $self->create_email($email, $db);
                            $return = $return_email unless $return_email;
                            push @msgs, @msgs_email;
                            if($return){
                                my ($passwd_details_id, $return_details, @_msgs) = $self->create_passwd_details($display_name, $given, $family, $residential_address_id, $postal_address_id, $primary_phone_id, $primary_email_id, $db);
                                $return = $return_details unless $return_details;
                                push @msgs, @_msgs;
                                if($return){
                                    my ($passwd_id, $return_passwd, @msgs_passwd);
                                    eval {
                                        ($passwd_id, $return_passwd, @msgs_passwd)  = $self->create_passwd($username, $hashed_password, $primary_email_id, $passwd_details_id, $primary_group_id, $admin, $db);
                                        $return = $return_passwd unless $return_passwd;
                                        push @msgs, @msgs_passwd;
                                    };
                                    if($@){
                                        $return = 0;
                                        push @msgs, "Error: falied to create passwd: $@";
                                    }
                                }
                            }else{
                                push @msgs, "one of the dependencies failed.", "see above.";
                            }
                        }else{
                            $query->finish();
                            $return = 0;
                            push @msgs, "failed to get primary _group id";
                        }
                    }else{
                        $return = 0;
                        push @msgs, "Failed to insert primary _group.";
                    }
                }else{
                    my $line = __LINE__;
                    $self->log(Data::Dumper->Dump([$password, $hashed_password, $line], [qw(password hashed_password line)]));
                    $return = 0;
                    push @msgs, "Error: could not validate hashed password.", "hashed_password == \`$hashed_password'";
                }
                $self->message($debug, \%session, $db, ($return?'login':'register'), ($return ? 'login' : undef), !$return, @msgs);
                return $return if $return;
            }
        }else{
            my $line = __LINE__;
            $self->log(Data::Dumper->Dump([$given, $family, $display_name, $line], [qw(given family display_name line)]));
        }

        $username           = '' unless defined $username;
        $email              = '' unless defined $email;
        $password           = '' unless defined $password;
        $repeat             = '' unless defined $repeat;
        $mobile             = '' unless defined $mobile;
        $phone              = '' unless defined $phone;
        $unit               = '' unless defined $unit;
        $street             = '' unless defined $street;
        $city_suberb        = '' unless defined $city_suberb;
        $postcode           = '' unless defined $postcode;
        $region             = '' unless defined $region;
        $country            = '' unless defined $country;
        $postal_same        = 1  unless defined $postal_same;
        $postal_unit        = '' unless defined $postal_unit;
        $postal_street      = '' unless defined $postal_street;
        $postal_city_suberb = '' unless defined $postal_city_suberb;
        $postal_postcode    = '' unless defined $postal_postcode;
        $postal_region      = '' unless defined $postal_region;
        $postal_country     = '' unless defined $postal_country;
        $given              = '' unless defined $given;
        $family             = '' unless defined $family;
        $display_name       = '' unless defined $display_name;

        untie %session;
        $db->disconnect;

        my $title   = "only a-z, A-Z, 0-9 and _  allowed";
        my $pattern = '[a-zA-Z0-9_]+';
        say "        <form action=\"register.pl\" method=\"post\">";
        say "            <h1>Register New Account</h1>";
        say "            <table>";
        say "                <tr>";
        say "                    <td>";
        say "                        <label for=\"username\">Username</label>";
        say "                    </td>";
        say "                    <td colspan=\"2\">";
        say "                        <input type=\"text\" name=\"username\" id=\"username\" placeholder=\"username\" pattern=\"$pattern\" title=\"$title\" value=\"$username\" autofocus required/>";
        say "                    </td>";
        say "                </tr>";
        $title   = "only a-z 0-9 '.', '+', '-', and '_' followed by \@ a-z, 0-9 '.' and '-' allowed (no uppercase)";
        $pattern = '[a-z0-9.+%_-]+@[a-z0-9-]+(?:\.[a-z0-9-]+)+';
        say "                <tr>";
        say "                    <td>";
        say "                        <label for=\"email\">email</label>";
        say "                    </td>";
        say "                    <td colspan=\"2\">";
        say "                        <input type=\"email\" name=\"email\" id=\"email\" placeholder=\"fred\@flintstone.com\" pattern=\"$pattern\" title=\"$title\" value=\"$email\" required/>";
        say "                    </td>";
        say "                </tr>";
        $title   = "Must supply between 10 and 100 character's the more the better.\nAlso must include a least one lowercase one uppercase a digit and a puntuation character.";
        $pattern = '(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[^a-zA-Z0-9]).{10,100}';
        say "                <tr>";
        say "                    <td>";
        say "                        <label for=\"password\">password</label>";
        say "                    </td>";
        say "                    <td colspan=\"2\">";
        say "                        <input type=\"password\" name=\"password\" id=\"password\" placeholder=\"password\" minlength=\"10\" pattern=\"$pattern\" title=\"$title\" value=\"$password\" required/>";
        say "                    </td>";
        say "                </tr>";
        say "                <tr>";
        say "                    <td>";
        say "                        <label for=\"repeat\">Repeat Password</label>";
        say "                    </td>";
        say "                    <td colspan=\"2\">";
        say "                        <input type=\"password\" name=\"repeat\" id=\"repeat\" placeholder=\"repeat password\" minlength=\"10\" pattern=\"$pattern\" title=\"$title\" value=\"$repeat\"  required/>";
        say "                    </td>";
        say "                </tr>";
        # given,  family annd dispaly name
        say "                <script>";
        say "                    function updatenames(){";
        say "                        var gvn = document.getElementById(\"given\");";
        say "                        var fam = document.getElementById(\"family\");";
        say "                        var disp = document.getElementById(\"display_name\");";
        say "                        disp.value = gvn.value + \" \" + fam.value;";
        say "                    }";
        say "                </script>";
        say "                <tr>";
        say "                    <td>";
        say "                        <label for=\"given\">given name</label>";
        say "                    </td>";
        say "                    <td colspan=\"2\">";
        say "                        <input type=\"text\" name=\"given\" id=\"given\" placeholder=\"given name\" value=\"$given\" oninput=\"updatenames()\" required/>";
        say "                    </td>";
        say "                </tr>";
        say "                <tr>";
        say "                    <td>";
        say "                        <label for=\"family\">family name</label>";
        say "                    </td>";
        say "                    <td colspan=\"2\">";
        say "                        <input type=\"text\" name=\"family\" id=\"family\" placeholder=\"family name\" value=\"$family\" oninput=\"updatenames()\" required/>";
        say "                    </td>";
        say "                </tr>";
        say "                <tr>";
        say "                    <td>";
        say "                        <label for=\"display_name\">display_name</label>";
        say "                    </td>";
        say "                    <td colspan=\"2\">";
        say "                        <input type=\"text\" name=\"display_name\" id=\"display_name\" placeholder=\"display_name\" value=\"$display_name\" required/>";
        say "                    </td>";
        say "                </tr>";
        # phones 
        $title   = 'Only +digits or local formats allowed. i.e. +61438-567-876 or 0438 567 876 or 0438567876';
        $pattern = '(?:\+61|0)?\d{3}[ -]?\d{3}[ -]?\d{3}';
        my $placeholder = '+61438-567-876|0438 567 876|0438567876';
        say "                <tr>";
        say "                    <td>";
        say "                        <label for=\"mobile\">mobile</label>";
        say "                    </td>";
        say "                    <td colspan=\"2\">";
        say "                        <input type=\"tel\" name=\"mobile\" id=\"mobile\" placeholder=\"$placeholder\" pattern=\"$pattern\" title=\"$title\" value=\"$mobile\"/>";
        say "                    </td>";
        say "                </tr>";
        $title   = 'Only +digits or local formats allowed i.e. +612-9567-2876 or (02) 9567 2876 or 0295672876.';
        $pattern = '(?:(?:\+61[ -]?\d|0\d|\(0\d\)|0\d)[ -]?)?\d{4}[ -]?\d{4}';
        $placeholder = '+612-9567-2876|(02) 9567 2876|0295672876';
        say "                <tr>";
        say "                    <td>";
        say "                        <label for=\"phone\">land line</label>";
        say "                    </td>";
        say "                    <td colspan=\"2\">";
        say "                        <input type=\"tel\" name=\"phone\" id=\"phone\" placeholder=\"$placeholder\" pattern=\"$pattern\" title=\"$title\" value=\"$phone\"/>";
        say "                    </td>";
        say "                </tr>";
        say "                <tr>";
        say "                    <th colspan=\"3\">";
        say "                        Residential Address";
        say "                    </th>";
        say "                </tr>";
        $title   = "\`;\`, \`'\` and \`&quot;\` not allowed";
        $pattern = "[^;'\\x22]+";
        say "                <tr>";
        say "                    <td>";
        say "                        <label for=\"unit\">unit</label>";
        say "                    </td>";
        say "                    <td colspan=\"2\">";
        say "                        <input type=\"text\" name=\"unit\" id=\"unit\" placeholder=\"unit number\" pattern=\"$pattern\" title=\"$title\" value=\"$unit\" />";
        say "                    </td>";
        say "                </tr>";
        $title   = "\`;\`, \`'\` and \`&quot;\` not allowed";
        $pattern = "[^;'\\x22]+";
        say "                <tr>";
        say "                    <td>";
        say "                        <label for=\"street\">street</label>";
        say "                    </td>";
        say "                    <td colspan=\"2\">";
        say "                        <input type=\"text\" name=\"street\" id=\"street\" placeholder=\"street\" pattern=\"$pattern\" title=\"$title\" value=\"$street\" required/>";
        say "                    </td>";
        say "                </tr>";
        $title   = "\`;\`, \`'\` and \`&quot;\` not allowed";
        $pattern = "[^;'\\x22]+";
        say "                <tr>";
        say "                    <td>";
        say "                        <label for=\"city_suberb\">City/Suberb</label>";
        say "                    </td>";
        say "                    <td colspan=\"2\">";
        say "                        <input type=\"text\" name=\"city_suberb\" id=\"city_suberb\" placeholder=\"city/suberb\" pattern=\"$pattern\" title=\"$title\" value=\"$city_suberb\" required/>";
        say "                    </td>";
        say "                </tr>";
        $title   = "\`;\`, \`'\` and \`&quot;\` not allowed";
        $pattern = "[A-Z0-9 -]+";
        say "                <tr>";
        say "                    <td>";
        say "                        <label for=\"postcode\">postcode</label>";
        say "                    </td>";
        say "                    <td colspan=\"2\">";
        say "                        <input type=\"text\" name=\"postcode\" id=\"postcode\" placeholder=\"postcode\" pattern=\"$pattern\" title=\"$title\" value=\"$postcode\"/>";
        say "                    </td>";
        say "                </tr>";
        $title   = "\`;\`, \`'\` and \`&quot;\` not allowed";
        $pattern = "[^;'\\x22]+";
        say "                <tr>";
        say "                    <td>";
        say "                        <label for=\"region\">Region/State/Province</label>";
        say "                    </td>";
        say "                    <td colspan=\"2\">";
        say "                        <input type=\"text\" name=\"region\" id=\"region\" placeholder=\"region/state/province\" pattern=\"$pattern\" title=\"$title\" value=\"$region\"/>";
        say "                    </td>";
        say "                </tr>";
        $title   = "\`;\`, \`'\` and \`&quot;\` not allowed";
        $pattern = "[^;'\\x22]+";
        say "                <tr>";
        say "                    <td>";
        say "                        <label for=\"country\">Country</label>";
        say "                    </td>";
        say "                    <td colspan=\"2\">";
        say "                        <input type=\"text\" name=\"country\" id=\"country\" placeholder=\"country\" pattern=\"$pattern\" title=\"$title\" value=\"$country\" required/>";
        say "                    </td>";
        say "                </tr>";
        say "                <script>";
        say "                    function togglePostal(){";
        say "                        var chbx = document.getElementById(\"togglep\");";
        say "                        var hiddenstuff = document.getElementsByClassName(\"postal\");";
        say "                        for(let h of hiddenstuff){";
        say "                            h.hidden = chbx.checked";
        say "                        }";
        say "                        var requiredstuff = document.getElementsByClassName(\"require\");";
        say "                        for(let r of requiredstuff){";
        say "                            r.required = !chbx.checked";
        say "                        }";
        say "                        var psame = document.getElementById(\"postal_same\");";
        say "                        psame.value = chbx.checked?1:0;";
        say "                    }";
        say "                </script>";
        say "                <tr>";
        say "                    <th colspan=\"3\">";
        say "                        Postal Address";
        say "                    </th>";
        say "                </tr>";
        say "                <tr>";
        say "                    <td colspan=\"2\">";
        say "                        <label for=\"togglep\" id=\"lbl\">Same as Residential address</label>";
        say "                    </td>";
        say "                    <td>";
        my $hidden;
        my $required;
        if($postal_same){
            $hidden = 'hidden';
            $required = '';
            say "                        <input type=\"hidden\" id=\"postal_same\" name=\"postal_same\" value=\"1\"/>";
            say "                        <input type=\"checkbox\" id=\"togglep\" onclick=\"togglePostal()\" checked/>";
        }else{
            $hidden = '';
            $required = 'required';
            say "                        <input type=\"hidden\" id=\"postal_same\" name=\"postal_same\" value=\"0\"/>";
            say "                        <input type=\"checkbox\" id=\"togglep\" onclick=\"togglePostal()\"/>";
        }
        say "                    </td>";
        say "                </tr>";
        $title   = "\`;\`, \`'\` and \`&quot;\` not allowed";
        $pattern = "[^;'\\x22]+";
        say "                <tr $hidden class=\"postal\">";
        say "                    <td>";
        say "                        <label for=\"postal_unit\" >unit</label>";
        say "                    </td>";
        say "                    <td colspan=\"2\">";
        say "                        <input type=\"text\" name=\"postal_unit\" id=\"postal_unit\" placeholder=\"unit number\" pattern=\"$pattern\" title=\"$title\" value=\"$postal_unit\"/>";
        say "                    </td>";
        say "                </tr>";
        $title   = "\`;\`, \`'\` and \`&quot;\` not allowed";
        $pattern = "[^;'\\x22]+";
        say "                <tr $hidden class=\"postal\">";
        say "                    <td>";
        say "                        <label for=\"postal_street\">street</label>";
        say "                    </td>";
        say "                    <td colspan=\"2\">";
        say "                        <input type=\"text\" name=\"postal_street\" id=\"postal_street\" placeholder=\"street\" pattern=\"$pattern\" title=\"$title\" value=\"$postal_street\" class=\"require\" $required/>";
        say "                    </td>";
        say "                </tr>";
        $title   = "\`;\`, \`'\` and \`&quot;\` not allowed";
        $pattern = "[^;'\\x22]+";
        say "                <tr $hidden class=\"postal\">";
        say "                    <td>";
        say "                        <label for=\"postal_city_suberb\">City/Suberb</label>";
        say "                    </td>";
        say "                    <td colspan=\"2\">";
        say "                        <input type=\"text\" name=\"postal_city_suberb\" id=\"postal_city_suberb\" placeholder=\"city/suberb\" pattern=\"$pattern\" title=\"$title\" value=\"$postal_city_suberb\" class=\"require\" $required/>";
        say "                    </td>";
        say "                </tr>";
        $title   = "\`;\`, \`'\` and \`&quot;\` not allowed";
        $pattern = "[A-Z0-9 -]+";
        say "                <tr $hidden class=\"postal\">";
        say "                    <td>";
        say "                        <label for=\"postal_postcode\">postcode</label>";
        say "                    </td>";
        say "                    <td colspan=\"2\">";
        say "                        <input type=\"text\" name=\"postal_postcode\" id=\"postal_postcode\" placeholder=\"postcode\" pattern=\"$pattern\" value=\"$postal_postcode\" title=\"$title\"/>";
        say "                    </td>";
        say "                </tr>";
        $title   = "\`;\`, \`'\` and \`&quot;\` not allowed";
        $pattern = "[^;'\\x22]+";
        say "                <tr hidden class=\"postal\">";
        say "                    <td>";
        say "                        <label for=\"postal_region\">Region/State/Province</label>";
        say "                    </td>";
        say "                    <td colspan=\"2\">";
        say "                        <input type=\"text\" name=\"postal_region\" id=\"postal_region\" placeholder=\"region/state/province\" pattern=\"$pattern\" title=\"$title\" value=\"$postal_region\"/>";
        say "                    </td>";
        say "                </tr>";
        $title   = "\`;\`, \`'\` and \`&quot;\` not allowed";
        $pattern = "[^;'\\x22]+";
        say "                <tr $hidden class=\"postal\">";
        say "                    <td>";
        say "                        <label for=\"postal_country\">Country</label>";
        say "                    </td>";
        say "                    <td colspan=\"2\">";
        say "                        <input type=\"text\" name=\"postal_country\" id=\"postal_country\" placeholder=\"country\" pattern=\"$pattern\" title=\"$title\" class=\"require\" value=\"$postal_country\" $required/>";
        say "                    </td>";
        say "                </tr>";
        # admin option
        if($loggedin && $isadmin){
            say "                <tr class=\"admin\">";
            say "                    <td colspan=\"2\">";
            say "                        <label for=\"admin\">admin</label>";
            say "                    </td>";
            say "                    <td>";
            if($admin){
                say "                        <input type=\"checkbox\" name=\"admin\" id=\"admin\" checked/>";
            }else{
                say "                        <input type=\"checkbox\" name=\"admin\" id=\"admin\"/>";
            }
            say "                    </td>";
            say "                </tr>";
        }else{
            say "                <tr hidden class=\"admin\">";
            say "                    <td colspan=\"3\">";
            say "                        <input type=\"hidden\" name=\"admin\" id=\"admin\" value=\"0\"/>";
            say "                    </td>";
            say "                </tr>";
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
        say "                        <input name=\"submit\" type=\"submit\" value=\"Register\">";
        say "                    </td>";
        say "                </tr>";
        say "            </table>";
        say "        </form>";

        return 1;
    } ## --- end sub register


    sub profile {
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
            tie %session, 'Apache::Session::Postgres', $id, {
                Handle => $db,
                TableName => 'sessions', 
                #Commit     => 1
            };
        }else{
            tie %session, 'Apache::Session::Postgres', undef(), {
                Handle => $db,
                TableName => 'sessions', 
                #Commit     => 1
            };
            $self->set_cookie("SESSION_ID=$session{_session_id}", $cfg, $rec);
        }

        $debug    = $session{debug} if !defined $debug && exists $session{debug};
        $debug{$ident} = $debug;
        $session{debug} = $debug if defined $debug;
        if(!defined $logfiles{$ident}){
            my $log;
            my $logpath = $logpaths{$ident};
            if($debug){
                if(open($log, '>>', "$logpath/debug.log")){
                    $log->autoflush(1);
                }else{
                    die "could not open $logpath/debug.log $!";
                }
            }
            $self->debug_init($debug, $log);
        }

        $self->links('profile', \%session);

        my $delete  = $req->param('delete');


        untie %session;
        $db->disconnect;

        say "        <form action=\"profile.pl\" method=\"post\">";
        say "            <h1>Add Alias</h1>";
        say "            <table>";
        say "                <tr>";
        say "                    <td>";
        say "                        <label for=\"alias\">Alias: </label>";
        say "                    </td>";
        say "                    <td colspan=\"2\">";
        say "                        <input type=\"text\" name=\"alias\" id=\"alias\" placeholder=\"alias\" pattern=\"[a-zA-Z0-9\\x28\\x2E_-]+\" title=\"only a-z, A-Z, 0-9, -, _ and . allowed\"/>";
        say "                    </td>";
        say "                </tr>";
        say "                <tr>";
        say "                    <td>";
        say "                        <label for=\"target\">Target: </label>";
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
        say "                        <input name=\"submit\" type=\"submit\" value=\"Add\">";
        say "                    </td>";
        say "                </tr>";
        say "            </table>";
        say "        </form>";

        return 1;
    } ## --- end sub profile



    sub admin {
        my ($self, $req, $cfg, $rec) = @_;
        my $ident           = ident $self;

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
                #Commit     => 1
            };
        }else{
            tie %session, 'Apache::Session::Postgres', undef(), {
                Handle => $db,
                TableName => 'sessions', 
                #Commit     => 1
            };
            $self->set_cookie("SESSION_ID=$session{_session_id}", $cfg, $rec);
        }

        my $submit  = $req->param('submit');
        $submit = '' unless defined $submit;
        my $debug;
        unless($submit eq 'Apply'){
            $debug   = $req->param('debug');
            $debug{$ident} = $debug;
        }else{
            $debug = $debug{$ident};
        }

        $self->log(Data::Dumper->Dump([$debug, \%session], [qw(debug \%session)]));

        $debug    = $session{debug} if !defined $debug && exists $session{debug};
        $debug{$ident} = $debug;
        $session{debug} = $debug if defined $debug;
        if(!defined $logfiles{$ident}){
            my $log;
            my $logpath = $logpaths{$ident};
            if($debug){
                if(open($log, '>>', "$logpath/debug.log")){
                    $log->autoflush(1);
                }else{
                    die "could not open $logpath/debug.log $!";
                }
            }
            $self->debug_init($debug, $log);
        }

        $self->log(Data::Dumper->Dump([$debug, \%session], [qw(debug \%session)]));

        $self->links('admin', \%session);

        #my $delete  = $req->param('delete');


        untie %session;
        $db->disconnect;

        say "        <h1>Admin</h1>";
        say "        <table>";
        say "            <tr>";
        say "                <td>";
        say "                    <form action=\"register.pl\" method=\"post\"><input type=\"submit\" name=\"submit\" id=\"submit\" value=\"Register a new user\"/></form>";
        say "                </td>";
        say "            </tr>";
        say "            <tr>";
        say "                <td>";
        say "                    <form action=\"user.pl\" method=\"post\"><input type=\"submit\" name=\"submit\" id=\"submit\" value=\"Edit Users\"/></form>";
        say "                </td>";
        say "            </tr>";
        say "            <tr>";
        say "                <td>";
        say "                    <form action=\"register.pl\" method=\"post\"><input type=\"submit\" name=\"submit\" id=\"submit\" value=\"Register a new user\"/></form>";
        say "                </td>";
        say "            </tr>";
        say "            <tr>";
        say "                <td>";
        say "                    <form action=\"register.pl\" method=\"post\"><input type=\"submit\" name=\"submit\" id=\"submit\" value=\"Register a new user\"/></form>";
        say "                </td>";
        say "            </tr>";
        say "            <tr>";
        say "                <td>";
        say "                    <form action=\"admin.pl\" method=\"post\">";
        say "                        <table>";
        say "                            <td>";
        if($debug){
            say "                                <input name=\"debug\" id=\"debug\" type=\"radio\" value=\"1\" checked><label for=\"debug\"> debug</label>";
            say "                            </td>";
            say "                            <td>";
            say "                                <input name=\"debug\" id=\"nodebug\" type=\"radio\" value=\"0\"><label for=\"nodebug\"> nodebug</label>";
        }else{
            say "                                <input name=\"debug\" id=\"debug\" type=\"radio\" value=\"1\"><label for=\"debug\"> debug</label>";
            say "                            </td>";
            say "                            <td>";
            say "                                <input name=\"debug\" id=\"nodebug\" type=\"radio\" value=\"0\" checked><label for=\"nodebug\"> nodebug</label>";
        }
        say "                            </td>";
        say "                            <td>";
        say "                                <input name=\"submit\" type=\"submit\" value=\"Apply\">";
        say "                            </td>";
        say "                        </table>";
        say "                    </form>";
        say "                </td>";
        say "            </tr>";
        say "        </table>";

        return 1;
    } ## --- end sub admin


    sub create_address {
        my ($self, $unit, $street, $city_suberb, $postcode, $region, $country, $default_id, $db) = @_;
        my $line = __LINE__;
        $self->log(Data::Dumper->Dump([$unit, $street, $city_suberb, $postcode, $region, $country, $line],
                [qw(unit street city_suberb postcode region country line)]));
        my ($address_id, $return, @msgs);
        $address_id = $default_id;
        $return = 1;
        my $sql    = "INSERT INTO address(unit, street, city_suburb, postcode, region, country)VALUES(?, ?, ?, ?, ?, ?) RETURNING id;\n";
        my $query  = $db->prepare($sql);
        my $result;
        eval {
            $result = $query->execute($unit, $street, $city_suberb, $postcode, $region, $country);
        };
        if($@){
            push @msgs, "Insert into address failed: $@";
            $return = 0;
        }
        if($result){
            my $r      = $query->fetchrow_hashref();
            $address_id = $r->{id};
        }else{
            push @msgs, "Insert into address failed";
            $return = 0;
        }
        $query->finish();
        return ($address_id, $return, @msgs);
    } ## --- end sub create_address


    sub create_phone {
        my ($self, $phone, $db) = @_;
        my $line = __LINE__;
        $self->log(Data::Dumper->Dump([$phone, $line], [qw(phone line)]));
        my ($phone_id, $return, @msgs);
        $return = 1;
        my $sql    = "INSERT INTO phone(_number)VALUES(?)  RETURNING id;\n";
        my $query  = $db->prepare($sql);
        my $result;
        eval {
            $result = $query->execute($phone);
        };
        if($@){
            push @msgs, "Insert into phone failed: $@";
            $return = 0;
        }
        if($result){
            my $r      = $query->fetchrow_hashref();
            $phone_id = $r->{id};
        }else{
            push @msgs, "Insert into phone failed";
            $return = 0;
        }
        $query->finish();
        return ($phone_id, $return, @msgs);
    } ## --- end sub create_phone


    sub create_email {
        my ($self, $email, $db) = @_;
        my $line = __LINE__;
        $self->log(Data::Dumper->Dump([$email, $line], [qw(email line)]));
        my ($email_id, $return, @msgs);
        $return = 1;
        my $sql    = "INSERT INTO email(_email)VALUES(?)  RETURNING id;\n";
        my $query  = $db->prepare($sql);
        my $result;
        eval {
            $result = $query->execute($email);
        };
        if($@){
            push @msgs, "Insert into email failed: $@";
            $return = 0;
        }
        if($result){
            my $r      = $query->fetchrow_hashref();
            $email_id = $r->{id};
        }else{
            push @msgs, "Insert into email failed";
            $return = 0;
        }
        $query->finish();
        return ($email_id, $return, @msgs);
    } ## --- end sub create_email


    sub create_passwd_details {
        my ($self, $display_name, $given, $family, $residential_address_id, $postal_address_id, $primary_phone_id, $primary_email_id, $db) = @_;
        my $line = __LINE__;
        $self->log(Data::Dumper->Dump([$display_name, $given, $family, $residential_address_id, $postal_address_id, $primary_phone_id, $primary_email_id, $line], [qw(display_name given family residential_address_id postal_address_id primary_phone_id primary_email_id line)]));
        my ($passwd_details_id, $return, @msgs);
        $return = 1;
        my $sql    = "INSERT INTO passwd_details(display_name, given, _family, residential_address_id, postal_address_id, primary_phone_id, primary_email_id)VALUES(?, ?, ?, ?, ?, ?, ?)  RETURNING id;\n";
        my $query  = $db->prepare($sql);
        my $result;
        eval {
            $result = $query->execute($display_name, $given, $family, $residential_address_id, $postal_address_id, $primary_phone_id, $primary_email_id);
        };
        if($@){
            push @msgs, "Insert into passwd_details failed: $@";
            $return = 0;
        }
        if($result){
            my $r      = $query->fetchrow_hashref();
            $passwd_details_id = $r->{id};
        }else{
            push @msgs, "Insert into passwd_details failed";
            $return = 0;
        }
        $query->finish();
        return ($passwd_details_id, $return, @msgs);
    } ## --- end sub create_passwd_details
    

    sub create_passwd {
        my ($self, $username, $hashed_password, $primary_email_id, $passwd_details_id, $primary_group_id, $admin, $db) = @_;
        my $line = __LINE__;
        $self->log(Data::Dumper->Dump([$username, $hashed_password, $primary_email_id, $passwd_details_id, $primary_group_id, $admin, $line], [qw(username hashed_password primary_email_id passwd_details_id primary_group_id admin line)]));
        my ($passwd_id, $return, @msgs);
        $return = 1;
        my $sql    = "INSERT INTO passwd(username, _password, email_id, passwd_details_id, primary_group_id, _admin)VALUES(?, ?, ?, ?, ?, ?)  RETURNING id;\n";
        my $query  = $db->prepare($sql);
        my $result;
        eval {
            $result = $query->execute($username, $hashed_password, $primary_email_id, $passwd_details_id, $primary_group_id, $admin);
        };
        if($@){
            push @msgs, "Insert into passwd failed: $@";
            $return = 0;
        }
        if($result){
            my $r      = $query->fetchrow_hashref();
            $passwd_id = $r->{id};
        }else{
            push @msgs, "Insert into passwd failed";
            $return = 0;
        }
        $query->finish();
        return ($passwd_id, $return, @msgs);
    } ## --- end sub create_passwd


    sub delete_email {
        my ($self, $email_id, $db) = @_;
        my $line = __LINE__;
        $self->log(Data::Dumper->Dump([$email_id, $line], [qw(email_id line)]));
        my ($return, @msgs);
        return ($return, @msgs);
    } ## --- end sub delete_email


    sub delete_group {
        my ($self, $group_id, $db) = @_;
        my $line = __LINE__;
        $self->log(Data::Dumper->Dump([$group_id, $line], [qw(group_id line)]));
        my ($return, @msgs);
        return ($return, @msgs);
    } ## --- end sub delete_group


    sub delete_passwd_details {
        my ($self, $passwd_details_id, $db) = @_;
        my $line = __LINE__;
        $self->log(Data::Dumper->Dump([$passwd_details_id, $line], [qw(passwd_details_id line)]));
        my ($return, @msgs);
        return ($return, @msgs);
    } ## --- end sub delete_passwd_details

}

1;
