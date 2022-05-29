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
use Apache2::Const;
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
        my ($self, $section, $_session, $db) = @_;
        my %session = %{$_session};

        my $loggedin                  = $session{loggedin};
        my $loggedin_id               = $session{loggedin_id};
        my $loggedin_username         = $session{loggedin_username};
        my $loggedin_admin            = $session{loggedin_admin};
        my $loggedin_display_name     = $session{loggedin_display_name};
        my $loggedin_given            = $session{loggedin_given};
        my $loggedin_family           = $session{loggedin_family};
        my $loggedin_email            = $session{loggedin_email};
        my $loggedin_phone_number     = $session{loggedin_phone_number};
        my $loggedin_groupname        = $session{loggedin_groupname};
        my $loggedin_primary_group_id = $session{loggedin_groupnname_id};

        $self->log(Data::Dumper->Dump([$section, $db], [qw(section db)]));
        my $sql = "SELECT COUNT(*) n FROM page_view pv WHERE pv.section = ? AND\n";
        $sql   .= "     (? = 1 OR (pv.userid = ? AND (pv)._perms._user._read = true) OR\n";
        $sql   .= "     ((pv.groupid = ? OR pv.groupid IN (SELECT gs.group_id FROM groups gs WHERE gs.passwd_id = ?))\n";
        $sql   .= "           AND (pv)._perms._group._read = true) OR (pv)._perms._other._read = true)\n";
        my $query  = $db->prepare($sql);
        my $result = $query->execute($section, $loggedin_admin, $loggedin_id, $loggedin_primary_group_id, $loggedin_id);
        my $r      = $query->fetchrow_hashref();
        my $n      = $r->{n};
        $query->finish();
        $self->log(Data::Dumper->Dump([$query, $result, $r, $sql], [qw(query result r sql)]));
        return $n;
    } ## --- end sub in_a_page


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

        my $dont_showdebug  = !$cfg->val('general', 'showdebug');

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

        my $loggedin                  = $session{loggedin};
        my $loggedin_id               = $session{loggedin_id};
        my $loggedin_username         = $session{loggedin_username};
        my $loggedin_admin            = $session{loggedin_admin};
        my $loggedin_display_name     = $session{loggedin_display_name};
        my $loggedin_given            = $session{loggedin_given};
        my $loggedin_family           = $session{loggedin_family};
        my $loggedin_email            = $session{loggedin_email};
        my $loggedin_phone_number     = $session{loggedin_phone_number};
        my $loggedin_groupname        = $session{loggedin_groupname};
        my $loggedin_primary_group_id = $session{loggedin_groupnname_id};

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
        $sql               .= "WHERE (? = 1 OR (pl.userid = ? AND (pl)._perms._user._read = true)\n";
        $sql               .= "       OR ((pl.groupid = ? OR pl.groupid IN (SELECT gs.group_id FROM groups gs WHERE gs.passwd_id = ?))\n";
        $sql               .= "                             AND (pl)._perms._group._read = true) OR (pl)._perms._other._read = true)\n";
        $sql               .= "ORDER BY pl.name, pl.full_name\n";
        my $query           = $db->prepare($sql);
        my $result          = $query->execute($loggedin_admin, $loggedin_id, $loggedin_primary_group_id, $loggedin_id);
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
            $sql .= "WHERE a.name = ? AND (? = 1 OR (a.userid = ? AND (a)._perms._user._read = true)\n";
            $sql .= "     OR ((a.groupid = ? OR a.groupid IN (SELECT gs.group_id FROM groups gs WHERE gs.passwd_id = ?))\n";
            $sql .= "          AND (a)._perms._group._read = true) OR (a)._perms._other._read = true)\n";
            $query  = $db->prepare($sql);
            $result = $query->execute($1, $loggedin_admin, $loggedin_id, $loggedin_primary_group_id, $loggedin_id);
            $r      = $query->fetchrow_hashref();
            my $sec = $r->{section};
            $query->finish();
            $current_section = "links^$sec";
        }
        $self->log(Data::Dumper->Dump([$current_page, $current_section], [qw(current_page current_section)]));
        my @sections;
        $sql  = "SELECT al.type, al.section FROM alias_links al\n";
        $sql .= "WHERE (? = 1 OR (al.userid = ? AND (al)._perms._user._read = true) OR ((al.groupid = ?\n";
        $sql .= "         OR al.groupid IN (SELECT gs.group_id FROM groups gs WHERE gs.passwd_id = ?))\n";
        $sql .= "             AND (al)._perms._group._read = true) OR (al)._perms._other._read = true)\n";
        $sql .= "ORDER BY al.section\n";
        $query           = $db->prepare($sql);
        $result          = $query->execute($loggedin_admin, $loggedin_id, $loggedin_primary_group_id, $loggedin_id);
        $r               = $query->fetchrow_hashref();
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
                $sql   .= "WHERE pp.name = ? AND ls.section = ? AND (? = 1 OR (pp.userid = ? AND (pp)._perms._user._read = true)\n";
                $sql   .= "     OR ((pp.groupid = ? OR pp.groupid IN (SELECT gs.group_id FROM groups gs WHERE gs.passwd_id = ?))\n";
                $sql   .= "          AND (pp)._perms._group._read = true) OR (pp)._perms._other._read = true)\n";
                $sql   .= "ORDER BY pp.name, ls.section, l.name, l.link\n";
                $query  = $db->prepare($sql);
                $result = $query->execute($pp, $secn, $loggedin_admin, $loggedin_id, $loggedin_primary_group_id, $loggedin_id);
                $self->log(Data::Dumper->Dump([$current_page, $current_section, $query, $result, $sql, $pp, $secn], [qw(current_page current_section query result sql pp secn)]));
            }else{
                $sql    = "SELECT pp.name \"page_name\", pp.full_name, ls.section, l.name, l.link, pp.status FROM pseudo_pages pp JOIN links_sections ls ON ls.section ~* pp.pattern JOIN links l ON l.section_id = ls.id\n";
                $sql   .= "WHERE pp.name = ? AND (? = 1 OR (pp.userid = ? AND (pp)._perms._user._read = true)\n";
                $sql   .= "     OR ((pp.groupid = ? OR pp.groupid IN (SELECT gs.group_id FROM groups gs WHERE gs.passwd_id = ?))\n";
                $sql   .= "          AND (pp)._perms._group._read = true) OR (pp)._perms._other._read = true)\n";
                $sql   .= "ORDER BY pp.name, ls.section, l.name, l.link\n";
                $query  = $db->prepare($sql);
                $result = $query->execute($pp, $loggedin_admin, $loggedin_id, $loggedin_primary_group_id, $loggedin_id);
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
                next if $status eq 'unassigned' && $self->in_a_page($section, \%session, $db);
                next if $status eq 'assigned'   && !$self->in_a_page($section, \%session, $db);
                push @body, { page_name => $page_name, full_name => $full_name, section => $section, name => $name, link => $link, };
            }
        }elsif($current_page =~ m/^page\^(.*)$/){
            my $pp = $1;
            if($current_section =~ m/^links\^(.*)$/){
                my $secn = $1;
                $sql  = "SELECT lv.page_name, lv.full_name, lv.section, lv.name, lv.link FROM page_link_view lv\n";
                $sql .= "WHERE lv.page_name = ? AND lv.section = ? AND (? = 1\n";
                $sql .= "     OR (lv.userid = ? AND (lv)._perms._user._read = true)\n";
                $sql .= "          OR ((lv.groupid = ? OR lv.groupid IN (SELECT gs.group_id FROM groups gs WHERE gs.passwd_id = ?))\n";
                $sql .= "               AND (lv)._perms._group._read = true) OR (lv)._perms._other._read = true)\n";
                $sql .= "ORDER BY lv.page_name, lv.full_name, lv.section, lv.name, lv.link;\n";
                $query  = $db->prepare($sql);
                $result = $query->execute($pp, $secn, $loggedin_admin, $loggedin_id, $loggedin_primary_group_id, $loggedin_id);
            }else{
                $sql  = "SELECT lv.page_name, lv.full_name, lv.section, lv.name, lv.link FROM page_link_view lv\n";
                $sql .= "WHERE lv.page_name = ? AND (? = 1 OR (lv.userid = ? AND (lv)._perms._user._read = true)\n";
                $sql .= "     OR ((lv.groupid = ? OR lv.groupid IN (SELECT gs.group_id FROM groups gs WHERE gs.passwd_id = ?))\n";
                $sql .= "          AND (lv)._perms._group._read = true) OR (lv)._perms._other._read = true)\n";
                $sql .= "ORDER BY lv.page_name, lv.full_name, lv.section, lv.name, lv.link;\n";
                $query  = $db->prepare($sql);
                $result = $query->execute($pp, $loggedin_admin, $loggedin_id, $loggedin_primary_group_id, $loggedin_id);
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
            say "                    <td><div class=\"ext\" onclick=\"onclick_link($cnt)\">$section</div></td>";
            say "                    <td><div class=\"ext\" onclick=\"onclick_link($cnt)\">$name</div></td>";
            say "                    <td><a id=\"lnk[$cnt]\" href=\"$link\" target=\"_blank\"><div class=\"ext\">$link</div></a></td>";
            say "                </tr>";
            if($cnt % $page_length == 0){
                say "                <tr><th>section</th><th>name</th><th>link</th></tr>";
            }
        }
        my @buttons = ({tag => 'input', name => 'submit', type => 'submit', value => 'Apply Filter', }, );
        $self->bottom_buttons($debug, $dont_showdebug, undef, 16, @buttons);
        #say "                <tr>";
        #say "                    <td>";
        #if($debug){
        #    say "                        <label for=\"debug\"><div class=\"ex\"><input name=\"debug\" id=\"debug\" type=\"radio\" value=\"1\" checked> debug</div></label>";
        #    say "                    </td>";
        #    say "                    <td>";
        #    say "                        <label for=\"nodebug\"><div class=\"ex\"><input name=\"debug\" id=\"nodebug\" type=\"radio\" value=\"0\"> nodebug</div></label>";
        #}else{
        #    say "                        <label for=\"debug\"><div class=\"ex\"><input name=\"debug\" id=\"debug\" type=\"radio\" value=\"1\"> debug</div></label>";
        #    say "                    </td>";
        #    say "                    <td>";
        #    say "                        <label for=\"nodebug\"><div class=\"ex\"><input name=\"debug\" id=\"nodebug\" type=\"radio\" value=\"0\" checked> nodebug</div></label>";
        #}
        #say "                    </td>";
        #say "                    <td>";
        #say "                        <input name=\"submit\" type=\"submit\" value=\"Apply Filter\">";
        #say "                    </td>";
        #say "                </tr>";
        say "            </table>";
        say "            <script>";
        say "                function onclick_link(n){";
        say "                    var lnk = document.getElementById('lnk[' + n + ']');";
        say "                    lnk.click();";
        say "                }";
        say "            </script>";
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
                    say "                    <button id=\"$fun\" type=\"button\" disabled>$name: $loggedin_username</button>";
                }else{
                    say "                    <form action=\"$href\" method=\"post\" ><input name=\"$fun\" type=\"submit\" value=\"$name: $loggedin_username\" /></form>";
                }
            }elsif($fun eq 'logout' && $fun ne $Fun){
                my $from = $Fun;
                $from    =~ tr/_/-/;
                $from    = 'index' if $Fun eq 'main';
                say "                    <form action=\"$href\" method=\"post\" ><input type=\"hidden\" name=\"from\" value=\"$from.pl\"/><input name=\"$fun\" type=\"submit\" value=\"$name\" /></form>";
            }elsif($fun eq $Fun){
                say "                    <button id=\"$fun\" type=\"button\" disabled>$name</button>";
            }else{
                say "                    <form action=\"$href\" method=\"post\" ><input name=\"$fun\" type=\"submit\" value=\"$name\" /></form>";
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

        my $dont_showdebug  = !$cfg->val('general', 'showdebug');

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

        my $loggedin                  = $session{loggedin};
        my $loggedin_id               = $session{loggedin_id};
        my $loggedin_username         = $session{loggedin_username};
        my $loggedin_admin            = $session{loggedin_admin};
        my $loggedin_display_name     = $session{loggedin_display_name};
        my $loggedin_given            = $session{loggedin_given};
        my $loggedin_family           = $session{loggedin_family};
        my $loggedin_email            = $session{loggedin_email};
        my $loggedin_phone_number     = $session{loggedin_phone_number};
        my $loggedin_groupname        = $session{loggedin_groupname};
        my $loggedin_primary_group_id = $session{loggedin_groupnname_id};

        my $sql  = "SELECT a.name, a.section FROM aliases a\n";
        $sql    .= "WHERE (? = 1 OR (a.userid = ? AND (a)._perms._user._read = true)\n";
        $sql    .= "    OR ((a.groupid = ? OR a.groupid IN (SELECT gs.group_id FROM groups gs WHERE gs.passwd_id = ?))\n";
        $sql    .= "        AND (a)._perms._group._read = true) OR (a)._perms._other._read = true)\n";
        $sql    .= "ORDER BY a.name\n";
        my $query           = $db->prepare($sql);
        my $result          = $query->execute($loggedin_admin, $loggedin_id, $loggedin_primary_group_id, $loggedin_id);
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

        my $dont_showdebug  = !$cfg->val('general', 'showdebug');

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

        my $loggedin                  = $session{loggedin};
        my $loggedin_id               = $session{loggedin_id};
        my $loggedin_username         = $session{loggedin_username};
        my $loggedin_admin            = $session{loggedin_admin};
        my $loggedin_display_name     = $session{loggedin_display_name};
        my $loggedin_given            = $session{loggedin_given};
        my $loggedin_family           = $session{loggedin_family};
        my $loggedin_email            = $session{loggedin_email};
        my $loggedin_phone_number     = $session{loggedin_phone_number};
        my $loggedin_groupname        = $session{loggedin_groupname};
        my $loggedin_primary_group_id = $session{loggedin_groupnname_id};

        my $alias  = $req->param('alias');
        my $target = $req->param('target');
        my $set_page_length = $req->param('set_page_length');

        $self->log(Data::Dumper->Dump([$alias, $target], [qw(alias target)]));
        if(defined $set_page_length){
        }elsif(defined $alias && defined $target && $alias =~ m/^(?:\w|-|\.|\@)+$/ && $self->valid_section($target, $loggedin_admin, $loggedin_id, $loggedin_primary_group_id, $db)){
            my @msgs;
            my $return = 1;
            my $sql  = "INSERT INTO alias(name, target, userid, groupid)VALUES(?, ?, ?, ?);\n";
            my $query           = $db->prepare($sql);
            $self->log(Data::Dumper->Dump([$alias, $target, $sql], [qw(alias target sql)]));
            my $result;
            eval {
                $result          = $query->execute($alias, $target, $loggedin_id, $loggedin_primary_group_id);
            };
            if($@){
                push @msgs, "Error: $@";
                $return  = 0;
            }
            $self->log(Data::Dumper->Dump([$query, $result, $sql], [qw(query result sql)]));
            if($result){
                $sql  = "SELECT ls.section FROM links_sections ls\n";
                $sql .= "WHERE ls.id = ? AND (? = 1 OR (ls.userid = ? AND (ls)._perms._user._read = true)\n";
                $sql .= "    OR ((ls.groupid = ? OR ls.groupid IN (SELECT gs.group_id FROM groups gs WHERE gs.passwd_id = ?))\n";
                $sql .= "        AND (ls)._perms._group._read = true) OR (ls)._perms._other._read = true)\n";
                $query           = $db->prepare($sql);
                $result          = $query->execute($target, $loggedin_admin, $loggedin_id, $loggedin_primary_group_id, $loggedin_id);
                my $r            = $query->fetchrow_hashref();
                $self->log(Data::Dumper->Dump([$query, $result, $r], [qw(query result r)]));
                my $section      = $r->{section};
                push @msgs, "Alias  defined: $alias => $section";
            }else{
                $sql  = "SELECT ls.section FROM links_sections ls\n";
                $sql .= "WHERE ls.id = ? AND (? = 1 OR (ls.userid = ? AND (ls)._perms._user._read = true)\n";
                $sql .= "   OR ((ls.groupid = ? OR ls.groupid IN (SELECT gs.group_id FROM groups gs WHERE gs.passwd_id = ?))\n";
                $sql .= "      AND (ls)._perms._group._read = true) OR (ls)._perms._other._read = true)\n";
                $query           = $db->prepare($sql);
                $result          = $query->execute($target, $loggedin_admin, $loggedin_id, $loggedin_primary_group_id, $loggedin_id);
                my $r            = $query->fetchrow_hashref();
                $self->log(Data::Dumper->Dump([$query, $result, $r], [qw(query result r)]));
                my $section      = $r->{section};
                push @msgs, "Error: failed to define Alias: $alias => $section";
                $return = 0;
            }
            #my ($self,    $cfg, $debug, $_session, $db, $fun,        $button_msg,          $dont_do_form, @msgs) = @_;
            $self->message($cfg, $debug, \%session, $db, 'add_alias', 'Add an other Alias', undef,         @msgs);
            return $return;
        }

        my $sql             = "SELECT ls.id, ls.section FROM links_sections ls\n";
        $sql               .= "WHERE (? = 1 OR (ls.userid = ? AND (ls)._perms._user._read = true)\n";
        $sql               .= "     OR ((ls.groupid = ? OR ls.groupid IN (SELECT gs.group_id FROM groups gs WHERE gs.passwd_id = ?))\n";
        $sql               .= "          AND (ls)._perms._group._read = true) OR (ls)._perms._other._read = true)\n";
        $sql               .= "ORDER BY ls.section\n";
        my $query           = $db->prepare($sql);
        my $result          = $query->execute($loggedin_admin, $loggedin_id, $loggedin_primary_group_id, $loggedin_id);
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
        $sql    .= "WHERE (? = 1 OR (a.userid = ? AND (a)._perms._user._read = true)\n";
        $sql    .= "    OR ((a.groupid = ? OR a.groupid IN (SELECT gs.group_id FROM groups gs WHERE gs.passwd_id = ?))\n";
        $sql    .= "        AND (a)._perms._group._read = true) OR (a)._perms._other._read = true)\n";
        $sql    .= "ORDER BY a.name\n";
        $query           = $db->prepare($sql);
        $result          = $query->execute($loggedin_admin, $loggedin_id, $loggedin_primary_group_id, $loggedin_id);
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
        my @buttons = ({tag => 'input', name => 'submit', type => 'submit', value => 'Add', }, );
        $self->bottom_buttons($debug, $dont_showdebug, undef, 16, @buttons);
        #say "                <tr>";
        #say "                    <td>";
        #if($debug){
        #    say "                        <label for=\"debug\"><div class=\"ex\"><input name=\"debug\" id=\"debug\" type=\"radio\" value=\"1\" checked> debug</div></label>";
        #    say "                    </td>";
        #    say "                    <td>";
        #    say "                        <label for=\"nodebug\"><div class=\"ex\"><input name=\"debug\" id=\"nodebug\" type=\"radio\" value=\"0\"> nodebug</div></label>";
        #}else{
        #    say "                        <label for=\"debug\"><div class=\"ex\"><input name=\"debug\" id=\"debug\" type=\"radio\" value=\"1\"> debug</div></label>";
        #    say "                    </td>";
        #    say "                    <td>";
        #    say "                        <label for=\"nodebug\"><div class=\"ex\"><input name=\"debug\" id=\"nodebug\" type=\"radio\" value=\"0\" checked> nodebug</div></label>";
        #}
        #say "                    </td>";
        #say "                    <td>";
        #say "                        <input name=\"submit\" type=\"submit\" value=\"Add\">";
        #say "                    </td>";
        #say "                </tr>";
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
        my ($self, $target, $loggedin_admin, $loggedin_id, $loggedin_primary_group_id, $db) = @_;
        my $ident           = ident $self;
        $self->log("start valid_section");
        $self->log(Data::Dumper->Dump([$target, $db], [qw(target db)]));
        my $debug = $debug{$ident};
        return 0 if $target !~ m/^\d+$/;
        my $sql             = "SELECT COUNT(*) n FROM links_sections ls\n";
        $sql               .= "WHERE ls.id = ? AND (? = 1 OR (ls.userid = ? AND (ls)._perms._user._read = true)\n";
        $sql               .= "     OR ((ls.groupid = ? OR ls.groupid IN (SELECT gs.group_id FROM groups gs WHERE gs.passwd_id = ?))\n";
        $sql               .= "          AND (ls)._perms._group._read = true) OR (ls)._perms._other._read = true)\n";
        my $query           = $db->prepare($sql);
        my $result          = $query->execute($target, $loggedin_admin, $loggedin_id, $loggedin_primary_group_id, $loggedin_id);
        $self->log(Data::Dumper->Dump([$query, $result, $sql], [qw(query result sql)]));
        my $r               = $query->fetchrow_hashref();
        $self->log(Data::Dumper->Dump([$query, $result, $r], [qw(query result r)]));
        my $n               = $r->{n};
        $self->log("end valid_section");
        return $n;
    } ## --- end sub valid_section


    sub valid_page {
        my ($self, $target, $loggedin_admin, $loggedin_id, $loggedin_primary_group_id, $db) = @_;
        my $ident           = ident $self;
        $self->log("start valid_page");
        $self->log(Data::Dumper->Dump([$target, $db], [qw(target db)]));
        my $debug = $debug{$ident};
        return 0 if $target !~ m/^\d+$/;
        my $sql             = "SELECT COUNT(*) n FROM pages p\n";
        $sql               .= "WHERE p.id = ? AND (? = 1 OR (p.userid = ? AND (p)._perms._user._read = true)\n";
        $sql               .= "     OR ((p.groupid = ? OR p.groupid IN (SELECT gs.group_id FROM groups gs WHERE gs.passwd_id = ?))\n";
        $sql               .= "          AND (p)._perms._group._read = true) OR (p)._perms._other._read = true)\n";
        my $query           = $db->prepare($sql);
        my $result          = $query->execute($target, $loggedin_admin, $loggedin_id, $loggedin_primary_group_id, $loggedin_id);
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

        my $dont_showdebug  = !$cfg->val('general', 'showdebug');

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

        my $loggedin                  = $session{loggedin};
        my $loggedin_id               = $session{loggedin_id};
        my $loggedin_username         = $session{loggedin_username};
        my $loggedin_admin            = $session{loggedin_admin};
        my $loggedin_display_name     = $session{loggedin_display_name};
        my $loggedin_given            = $session{loggedin_given};
        my $loggedin_family           = $session{loggedin_family};
        my $loggedin_email            = $session{loggedin_email};
        my $loggedin_phone_number     = $session{loggedin_phone_number};
        my $loggedin_groupname        = $session{loggedin_groupname};
        my $loggedin_primary_group_id = $session{loggedin_groupnname_id};

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
            my $sql  = "INSERT INTO pages(name, full_name, userid, groupid) VALUES(?, ?, ?, ?) ON CONFLICT (name) DO UPDATE SET full_name = EXCLUDED.full_name\n";
            my $query           = $db->prepare($sql);
            my $result          = $query->execute($page, $full_name, $loggedin_id, $loggedin_primary_group_id);
            $self->log(Data::Dumper->Dump([$query, $result, $sql], [qw(query result sql)]));
            $query->finish();
            if($result){
                push @msgs, "Page $page added.";
                $sql  = "SELECT p.id FROM pages p\n";
                $sql .= "WHERE p.name = ? AND (? = 1 OR (p.userid = ? AND (p)._perms._user._read = true)\n";
                $sql .= "     OR ((p.groupid = ? OR p.groupid IN (SELECT gs.group_id FROM groups gs WHERE gs.passwd_id = ?))\n";
                $sql .= "          AND (p)._perms._group._read = true) OR (p)._perms._other._read = true)\n";
                $query           = $db->prepare($sql);
                $result          = $query->execute($page, $loggedin_admin, $loggedin_id, $loggedin_primary_group_id, $loggedin_id);
                $return = 0 if !$result;
                my $r            = $query->fetchrow_hashref();
                my $page_id      = $r->{id};
                $query->finish();
                $sql  = "INSERT INTO page_section(pages_id, links_section_id, userid, groupid)\n";
                $sql .= "VALUES(?, ?, ?, ?) ON CONFLICT (pages_id, links_section_id) DO NOTHING\n";
                $self->log(Data::Dumper->Dump([\@members], [qw(@members)]));
                $query           = $db->prepare($sql);
                my (@good, @bad, @skipped);
                for my $member (@members){
                    if(!$self->valid_section($member, $loggedin_admin, $loggedin_id, $loggedin_primary_group_id, $db)){
                        push @skipped, $member;
                        next;
                    }
                    eval {
                        $result      = $query->execute($page_id, $member, $loggedin_id, $loggedin_primary_group_id);
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
            $self->message($cfg, $debug, \%session, $db, 'add_page', 'Add an other Page', undef, @msgs);

            untie %session;
            $db->disconnect;
            return $return;
        }

        my @pages;
        my $return = 1;
        my @msgs;
        my $sql    ="SELECT p.name, p.full_name FROM pagelike p\n";
        $sql      .= "WHERE (? = 1 OR (p.userid = ? AND (p)._perms._user._read = true)\n";
        $sql      .= "     OR ((p.groupid = ? OR p.groupid IN (SELECT gs.group_id FROM groups gs WHERE gs.passwd_id = ?))\n";
        $sql      .= "          AND (p)._perms._group._read = true) OR (p)._perms._other._read = true)\n";
        $sql      .="ORDER BY p.name, p.full_name\n";
        my $query  = $db->prepare($sql);
        my $result;
        eval {
            $result    = $query->execute($loggedin_admin, $loggedin_id, $loggedin_primary_group_id, $loggedin_id);
        };
        if($@){
            $return = 0;
            push @msgs, "SELECT FROM pagelike Failed: $@";
        }
        if($result && $result != 0){
            my $r      = $query->fetchrow_hashref();
            while($r){
                push @pages, $r;
                $r     = $query->fetchrow_hashref();
            }
        }else{
            $return = 0;
            push @msgs, "SELECT FROM pagelike Failed: $sql";
        }
        $self->message($cfg, $debug, \%session, $db, 'add_link', 'Try again', !$return, @msgs) if @msgs;
        return $return if !$return;
        

        $sql                = "SELECT ls.id, ls.section FROM links_sections ls\n";
        $sql               .= "WHERE (? = 1 OR (ls.userid = ? AND (ls)._perms._user._read = true)\n";
        $sql               .= "   OR ((ls.groupid = ? OR ls.groupid IN (SELECT gs.group_id FROM groups gs WHERE gs.passwd_id = ?))\n";
        $sql               .= "         AND (ls)._perms._group._read = true) OR (ls)._perms._other._read = true)\n";
        $sql               .= "ORDER BY ls.section\n";
        $query              = $db->prepare($sql);
        $result             = $query->execute($loggedin_admin, $loggedin_id, $loggedin_primary_group_id, $loggedin_id);
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
        say "                    <td colspan=\"3\">";
        say "                        <script>";
        say "                            function onchange_page(){";
        say "                                var slt = document.getElementById(\"pages\");";
        say "                                var name = slt.value;";
        say "                                var pages = {";
        for my $page (@pages){
            my $name      = $page->{name};
            my $full_name = $page->{full_name};
            say "                                    \"$name\": \"$full_name\",";
        }
        say "                                    };";
        say "                                var full_name = pages[name];";
        say "                                var page = document.getElementById(\"page\");";
        say "                                page.value = name";
        say "                                var fname = document.getElementById(\"full_name\");";
        say "                                fname.value = full_name;";
        say "                            }";
        say "                        </script>";
        say "                        <select id=\"pages\" onchange=\"onchange_page()\">";
        for my $page (@pages){
            my $name      = $page->{name};
            my $full_name = $page->{full_name};
            say "                            <option value=\"$name\">$name => $full_name</option>";
        }
        say "                        </select>";
        say "                    </td>";
        say "                </tr>";
        say "                <tr>";
        say "                    <td>";
        say "                        <label for=\"page\"><div class=\"ex\">Page: </div></label>";
        say "                    </td>";
        say "                    <td>";
        say "                        <div class=\"ex\"><input type=\"text\" name=\"page\" id=\"page\" placeholder=\"page_name\" pattern=\"[a-zA-Z0-9\\x28\\x2E_-]+\" title=\"Only a-z, A-Z, 0-9, ., - and _ allowed\"/></div>";
        say "                    </td>";
        say "                    <td>";
        say "                        <div class=\"ex\"><input type=\"text\" name=\"full_name\" id=\"full_name\" placeholder=\"full name\" pattern=\"[a-zA-Z0-9\\x28\\x2E\\x20_-]+\" title=\"Only a-z, A-Z, 0-9, ., -, _ and spaces allowed\"/></div>";
        say "                    </td>";
        say "                </tr>";
        say "                <tr>";
        say "                    <td>";
        say "                        <label for=\"page_length\"><div class=\"ex\"><div class=\"ex\">Page Length:";
        say "                            <input type=\"number\" name=\"page_length\" id=\"page_length\" min=\"10\" max=\"180\" step=\"1\" value=\"$page_length\" size=\"3\"></div>";
        say "                        </label>";
        say "                    </td>";
        say "                    <td colspan=\"2\">";
        say "                        <div class=\"ex\"><input type=\"submit\" name=\"set_page_length\" id=\"set_page_length\" value=\"Set Page Length\" /></div>";
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
            say "                        <label for=\"$section\"><div class=\"ex\">$section</div></label>";
            say "                    </td>";
            say "                    <td>";
            say "                        <label for=\"$section\"><div class=\"ex\"><input type=\"checkbox\" name=\"members[$cnt]\" id=\"$section\" value=\"$links_section_id\" /></div></label>";
            say "                    </td>";
            say "                </tr>";
            if($cnt % $page_length == 0){
                say "                <tr>";
                say "                    <th colspan=\"2\">Link Section</th><th>Members</th>";
                say "                </tr>";
            }
        }
        my @buttons = ({tag => 'input', name => 'submit', type => 'submit', value => 'OK', }, );
        $self->bottom_buttons($debug, $dont_showdebug, undef, 16, @buttons);
        #say "                <tr>";
        #say "                    <td>";
        #if($debug){
        #    say "                        <label for=\"debug\"><div class=\"ex\"><input name=\"debug\" id=\"debug\" type=\"radio\" value=\"1\" checked> debug</div></label>";
        #    say "                    </td>";
        #    say "                    <td>";
        #    say "                        <label for=\"nodebug\"><div class=\"ex\"><input name=\"debug\" id=\"nodebug\" type=\"radio\" value=\"0\"> nodebug</div></label>";
        #}else{
        #    say "                        <label for=\"debug\"><div class=\"ex\"><input name=\"debug\" id=\"debug\" type=\"radio\" value=\"1\"> debug</div></label>";
        #    say "                    </td>";
        #    say "                    <td>";
        #    say "                        <label for=\"nodebug\"><div class=\"ex\"><input name=\"debug\" id=\"nodebug\" type=\"radio\" value=\"0\" checked> nodebug</div></label>";
        #}
        #say "                    </td>";
        #say "                    <td>";
        #say "                        <input name=\"submit\" type=\"submit\" value=\"OK\">";
        #say "                    </td>";
        #say "                </tr>";
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

        my $dont_showdebug  = !$cfg->val('general', 'showdebug');

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

        my $loggedin                  = $session{loggedin};
        my $loggedin_id               = $session{loggedin_id};
        my $loggedin_username         = $session{loggedin_username};
        my $loggedin_admin            = $session{loggedin_admin};
        my $loggedin_display_name     = $session{loggedin_display_name};
        my $loggedin_given            = $session{loggedin_given};
        my $loggedin_family           = $session{loggedin_family};
        my $loggedin_email            = $session{loggedin_email};
        my $loggedin_phone_number     = $session{loggedin_phone_number};
        my $loggedin_groupname        = $session{loggedin_groupname};
        my $loggedin_primary_group_id = $session{loggedin_groupnname_id};

        my $section  = $req->param('section');
        my $name     = $req->param('name');
        my $link     = $req->param('link');

        $self->log(Data::Dumper->Dump([$section, $name, $link], [qw(section name link)]));
        if(defined $section && defined $name && defined $link && $section =~ m/^(?:\w|-|\.|\+|\@)+$/ && $name =~ m/^(?:\w|-|\.|\+|\@)+$/ && is_uri($link)){
            my @msgs;
            my $return = 1;
            my $sql  = "INSERT INTO links_sections(section, userid, groupid) VALUES(?, ?, ?) ON CONFLICT (section) DO NOTHING;\n";
            my $query           = $db->prepare($sql);
            $self->log(Data::Dumper->Dump([$section, $name, $link, $sql], [qw(section name link sql)]));
            my $result;
            eval {
                $result          = $query->execute($section, $loggedin_id, $loggedin_primary_group_id);
            };
            if($@){
                push @msgs, "Error: $@";
                $query->finish();
                $return = 0;
            }
            $self->log(Data::Dumper->Dump([$query, $result, $sql], [qw(query result sql)]));
            if($result){
                $sql  = "SELECT ls.id FROM links_sections ls\n";
                $sql .= "WHERE ls.section = ? AND (? = 1 OR (ls.userid = ? AND (ls)._perms._user._read = true)\n";
                $sql .= "    OR ((ls.groupid = ? OR ls.groupid IN (SELECT gs.group_id FROM groups gs WHERE gs.passwd_id = ?))\n";
                $sql .= "        AND (ls)._perms._group._read = true) OR (ls)._perms._other._read = true)\n";
                $query           = $db->prepare($sql);
                $result          = $query->execute($section, $loggedin_admin, $loggedin_id, $loggedin_primary_group_id, $loggedin_id);
                if($result){
                    push @msgs, "Section defined: $section";
                    my $r            = $query->fetchrow_hashref();
                    $self->log(Data::Dumper->Dump([$query, $result, $r], [qw(query result r)]));
                    my $section_id   = $r->{id};
                    $sql  = 'INSERT INTO links(section_id, name, link, userid, groupid) VALUES (?, ?, ?, ?, ?) ON CONFLICT (section_id, name) DO NOTHING';
                    $query           = $db->prepare($sql);
                    $result          = $query->execute($section_id, $name, $link, $loggedin_id, $loggedin_primary_group_id);
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
            $self->message($cfg, $debug, \%session, $db, 'add_link', 'Add Another Link', undef, @msgs);

            untie %session;
            $db->disconnect;
            return $return;
        }

        my $sql    = "SELECT lsl.section, lsl.name, lsl.link FROM links_sections_join_links lsl\n";
        $sql      .= "WHERE (? = 1 OR (lsl.userid = ? AND (lsl)._perms._user._read = true)\n";
        $sql      .= "     OR ((lsl.groupid = ? OR lsl.groupid IN (SELECT gs.group_id FROM groups gs WHERE gs.passwd_id = ?))\n";
        $sql      .= "          AND (lsl)._perms._group._read = true) OR (lsl)._perms._other._read = true)\n";
        $sql      .= "ORDER BY lsl.section, lsl.name;\n";
        my $query  = $db->prepare($sql);
        my $result    = $query->execute($loggedin_admin, $loggedin_id, $loggedin_primary_group_id, $loggedin_id);
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
        say "                        <input type=\"text\" name=\"section\" id=\"section\" placeholder=\"section\" pattern=\"[a-zA-Z0-9+\\x28\\x2E_-]+\" title=\"Only a-z, A-Z, 0-9, ., +, - and _ allowed\"/>";
        say "                    </td>";
        say "                </tr>";
        say "                <tr>";
        say "                    <td>";
        say "                        <label for=\"name\">Name: </label>";
        say "                    </td>";
        say "                    <td colspan=\"2\">";
        say "                        <input type=\"text\" name=\"name\" id=\"name\" placeholder=\"name\" pattern=\"[a-zA-Z0-9+\\x28\\x2E_-]+\" title=\"Only a-z, A-Z, 0-9, ., +, - and _ allowed\"/>";
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
        my @buttons = ({tag => 'input', name => 'submit', type => 'submit', value => 'OK', }, );
        $self->bottom_buttons($debug, $dont_showdebug, undef, 16, @buttons);
        #say "                <tr>";
        #say "                    <td>";
        #if($debug){
        #    say "                        <label for=\"debug\"><div class=\"ex\"><input name=\"debug\" id=\"debug\" type=\"radio\" value=\"1\" checked> debug</div></label>";
        #    say "                    </td>";
        #    say "                    <td>";
        #    say "                        <label for=\"nodebug\"><div class=\"ex\"><input name=\"debug\" id=\"nodebug\" type=\"radio\" value=\"0\"> nodebug</div></label>";
        #}else{
        #    say "                        <label for=\"debug\"><div class=\"ex\"><input name=\"debug\" id=\"debug\" type=\"radio\" value=\"1\"> debug</div></label>";
        #    say "                    </td>";
        #    say "                    <td>";
        #    say "                        <label for=\"nodebug\"><div class=\"ex\"><input name=\"debug\" id=\"nodebug\" type=\"radio\" value=\"0\" checked> nodebug</div></label>";
        #}
        #say "                    </td>";
        #say "                    <td>";
        #say "                        <input name=\"submit\" type=\"submit\" value=\"OK\">";
        #say "                    </td>";
        #say "                </tr>";
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
            say "                    <td><div class=\"ext\" id=\"sct[$cnt]\" onclick=\"onclick_sect($cnt)\">$section</div></td>";
            say "                    <td><div class=\"ext\" onclick=\"onclick_link($cnt)\">$name</div></td>";
            say "                    <td><a id=\"lnk[$cnt]\" href=\"$link\" target=\"_blank\"><div class=\"ext\">$link</div></a></td>";
            say "                </tr>";
            if($cnt % $page_length == 0){
                say "                <tr><th>section</th><th>name</th><th>link</th></tr>";
            }
        }
        say "            </table>";
        say "            <script>";
        say "                function onclick_sect(n){";
        say "                    var sct = document.getElementById('sct[' + n + ']');";
        say "                    var section = sct.innerHTML;";
        say "                    var sect_input = document.getElementById('section');";
        say "                    sect_input.value = section;";
        say "                }";
        say "                function onclick_link(n){";
        say "                    var lnk = document.getElementById('lnk[' + n + ']');";
        say "                    lnk.click();";
        say "                }";
        say "            </script>";
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

        my $dont_showdebug  = !$cfg->val('general', 'showdebug');

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

        my $loggedin                  = $session{loggedin};
        my $loggedin_id               = $session{loggedin_id};
        my $loggedin_username         = $session{loggedin_username};
        my $loggedin_admin            = $session{loggedin_admin};
        my $loggedin_display_name     = $session{loggedin_display_name};
        my $loggedin_given            = $session{loggedin_given};
        my $loggedin_family           = $session{loggedin_family};
        my $loggedin_email            = $session{loggedin_email};
        my $loggedin_phone_number     = $session{loggedin_phone_number};
        my $loggedin_groupname        = $session{loggedin_groupname};
        my $loggedin_primary_group_id = $session{loggedin_groupnname_id};

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
            my $sql  = "INSERT INTO pseudo_pages(name, full_name, status, pattern, userid, groupid) VALUES(?, ?, ?, ?, ?, ?) ON CONFLICT (name) DO UPDATE SET full_name = EXCLUDED.full_name, status = EXCLUDED.status, pattern = EXCLUDED.pattern;\n";
            my $query           = $db->prepare($sql);
            $self->log(Data::Dumper->Dump([$name, $full_name, $status, $pattern, $sql], [qw(name full_name status pattern sql)]));
            my $result;
            eval {
                $result         = $query->execute($name, $full_name, $status, $pattern, $loggedin_id, $loggedin_primary_group_id);
            };
            if($@){
                my @msgs = ("Error: $@", "Pseudo page insert failed: ($name, $full_name, $status, $pattern)");
                $query->finish();
                $self->message($cfg, $debug, \%session, $db, 'add_pseudo_page', undef, undef, @msgs);

                untie %session;
                $db->disconnect;
                return 0;
            }
            $self->log(Data::Dumper->Dump([$query, $result, $sql], [qw(query result sql)]));
            if($result){
                $query->finish();
                $self->message($cfg, $debug, \%session, $db, 'add_pseudo_page', 'Add Another Pseudo-Page', undef, "Pseudo page defined: ($name, $full_name, $status, $pattern)");

                untie %session;
                $db->disconnect;
                return 1;
            }else{
                $query->finish();
                $self->message($cfg, $debug, \%session, $db, 'add_pseudo_page', undef, undef, "Pseudo page insert failed: ($name, $full_name, $status, $pattern)");

                untie %session;
                $db->disconnect;
                return 0;
            }
        }
        
        my $sql  = "SELECT pp.name, pp.full_name, pp.pattern, pp.status FROM pseudo_pages pp\n";
        $sql    .= "WHERE (? = 1 OR (pp.userid = ? AND (pp)._perms._user._read = true)\n";
        $sql    .= "    OR ((pp.groupid = ? OR pp.groupid IN (SELECT gs.group_id FROM groups gs WHERE gs.passwd_id = ?))\n";
        $sql    .= "        AND (pp)._perms._group._read = true) OR (pp)._perms._other._read = true)\n";
        $sql    .= "ORDER BY pp.name, pp.full_name\n";
        my $query           = $db->prepare($sql);
        $self->log(Data::Dumper->Dump([$name, $full_name, $status, $pattern, $sql], [qw(name full_name status pattern sql)]));
        my $result;
        eval {
            $result         = $query->execute($loggedin_admin, $loggedin_id, $loggedin_primary_group_id, $loggedin_id);
        };
        if($@){
            my @msgs = ("Error: $@", "Pseudo page list failed");
            $query->finish();
            $self->message($cfg, $debug, \%session, $db, 'add_pseudo_page', undef, @msgs);
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
            $self->message($cfg, $debug, \%session, $db, 'add_pseudo_page', undef, "Pseudo page list failed");
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
        my @buttons = ({tag => 'input', name => 'submit', type => 'submit', value => 'Add', }, );
        $self->bottom_buttons($debug, $dont_showdebug, undef, 16, @buttons);
        #say "                <tr>";
        #say "                    <td>";
        #if($debug){
        #    say "                        <label for=\"debug\"><div class=\"ex\"><input name=\"debug\" id=\"debug\" type=\"radio\" value=\"1\" checked> debug</div></label>";
        #    say "                    </td>";
        #    say "                    <td>";
        #    say "                        <label for=\"nodebug\"><div class=\"ex\"><input name=\"debug\" id=\"nodebug\" type=\"radio\" value=\"0\"> nodebug</div></label>";
        #}else{
        #    say "                        <label for=\"debug\"><div class=\"ex\"><input name=\"debug\" id=\"debug\" type=\"radio\" value=\"1\"> debug</div></label>";
        #    say "                    </td>";
        #    say "                    <td>";
        #    say "                        <label for=\"nodebug\"><div class=\"ex\"><input name=\"debug\" id=\"nodebug\" type=\"radio\" value=\"0\" checked> nodebug</div></label>";
        #}
        #say "                    </td>";
        #say "                    <td>";
        #say "                        <input name=\"submit\" type=\"submit\" value=\"OK\">";
        #say "                    </td>";
        #say "                </tr>";
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

        my $dont_showdebug  = !$cfg->val('general', 'showdebug');

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

        my $loggedin                  = $session{loggedin};
        my $loggedin_id               = $session{loggedin_id};
        my $loggedin_username         = $session{loggedin_username};
        my $loggedin_admin            = $session{loggedin_admin};
        my $loggedin_display_name     = $session{loggedin_display_name};
        my $loggedin_given            = $session{loggedin_given};
        my $loggedin_family           = $session{loggedin_family};
        my $loggedin_email            = $session{loggedin_email};
        my $loggedin_phone_number     = $session{loggedin_phone_number};
        my $loggedin_groupname        = $session{loggedin_groupname};
        my $loggedin_primary_group_id = $session{loggedin_groupnname_id};

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
                    my $sql  = "DELETE FROM links\n";
                    $sql    .= "WHERE id = ? AND (? = 1\n";
                    $sql    .= "    OR (userid = ? AND (_perms)._user._del = true)\n";
                    $sql    .= "        OR ((groupid = ? OR groupid IN (SELECT gs.group_id FROM groups gs WHERE gs.passwd_id = ?))\n";
                    $sql    .= "            AND (_perms)._group._del = true) OR (_perms)._other._del = true);\n";
                    my $query           = $db->prepare($sql);
                    my $result;
                    eval {
                        $result         = $query->execute($link_id, $loggedin_admin, $loggedin_id, $loggedin_primary_group_id, $loggedin_id);
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
                    $sql    .= "WHERE l.id = ? AND (? = 1 OR (l.userid = ? AND (l)._perms._user._read = true)\n";
                    $sql    .= "    OR ((l.groupid = ? OR l.groupid IN (SELECT gs.group_id FROM groups gs WHERE gs.passwd_id = ?))\n";
                    $sql    .= "        AND (l)._perms._group._read = true) OR (l)._perms._other._read = true);\n";
                    my $query           = $db->prepare($sql);
                    $self->log(Data::Dumper->Dump([$link_id, $query, $sql], [qw(link_id query sql)]));
                    my $result;
                    eval {
                        $result         = $query->execute($link_id, $loggedin_admin, $loggedin_id, $loggedin_primary_group_id, $loggedin_id);
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
                    $sql  = "DELETE FROM links WHERE id = ? AND (? = 1 OR (userid = ? AND (_perms)._user._del = true)\n";
                    $sql .= "        OR ((groupid = ? OR groupid IN (SELECT gs.group_id FROM groups gs WHERE gs.passwd_id = ?))\n";
                    $sql .= "                AND (_perms)._group._del = true) OR (_perms)._other._del = true);\n";
                    $query           = $db->prepare($sql);
                    eval {
                        $result         = $query->execute($link_id, $loggedin_admin, $loggedin_id, $loggedin_primary_group_id, $loggedin_id);
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
                    $sql    .= "WHERE l.section_id = ? AND (? = 1 OR (l.userid = ? AND (l)._perms._user._read = true)\nn";
                    $sql    .= "     OR ((l.groupid = ? OR l.groupid IN (SELECT gs.group_id FROM groups gs WHERE gs.passwd_id = ?))\nn";
                    $sql    .= "          AND (l)._perms._group._read = true) OR (l)._perms._other._read = true);\n";
                    my $query           = $db->prepare($sql);
                    my $result;
                    eval {
                        $result         = $query->execute($section_id, $loggedin_admin, $loggedin_id, $loggedin_primary_group_id, $loggedin_id);
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
                        $sql .= "WHERE id = ? AND (? = 1 OR (userid = ? AND (_perms)._user._del = true)\n";
                        $sql .= "     OR ((groupid = ? OR groupid IN (SELECT gs.group_id FROM groups gs WHERE gs.passwd_id = ?))\n";
                        $sql .= "          AND (_perms)._group._del = true) OR (_perms)._other._del = true)\n";
                        $query           = $db->prepare($sql);
                        eval {
                            $result         = $query->execute($section_id, $loggedin_admin, $loggedin_id, $loggedin_primary_group_id, $loggedin_id);
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
            $self->message($cfg, $debug, \%session, $db, 'delete_links', 'Delete some more links', undef, @msgs);

            untie %session;
            $db->disconnect;
            return $return;
        }

        my $sql  = "SELECT  l.id, l.section_id, (SELECT ls.section FROM links_sections ls WHERE ls.id = l.section_id) section, l.name, l.link FROM links l\n";
        $sql    .= "WHERE (? = 1 OR (l.userid = ? AND (l)._perms._user._read = true)\n";
        $sql    .= "     OR ((l.groupid = ? OR l.groupid IN (SELECT gs.group_id FROM groups gs WHERE gs.passwd_id = ?))\n";
        $sql    .= "          AND (l)._perms._group._read = true) OR (l)._perms._other._read = true)\n";
        $sql    .= "ORDER BY section, l.name\n";
        my $query           = $db->prepare($sql);
        my $result;
        eval {
            $result         = $query->execute($loggedin_admin, $loggedin_id, $loggedin_primary_group_id, $loggedin_id);
        };
        if($@){
            $self->message($cfg, $debug, \%session, $db, 'delete_links', undef, undef, "Error: $@");
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
        say "                        <label for=\"page_length\"><div class=\"ex\">Page Length:";
        say "                            <input type=\"number\" name=\"page_length\" id=\"page_length\" min=\"10\" max=\"180\" step=\"1\" value=\"$page_length\" size=\"3\"></div>";
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
            say "                        <label for=\"$link_id\"><div class=\"ex\">$section</div></label>";
            say "                    </td>";
            say "                    <td>";
            say "                        <label for=\"$link_id\"><div class=\"ex\">$name</div></label>";
            say "                    </td>";
            say "                    <td>";
            say "                        <label for=\"$link_id\"><div class=\"ex\">$link</div></label>";
            say "                    </td>";
            say "                    <td>";
            say "                        <label for=\"$link_id\"><div class=\"ex\"><input type=\"checkbox\" name=\"delete_set[$cnt]\" id=\"$link_id\" value=\"$link_id\"/></div></label>";
            say "                    </td>";
            say "                </tr>";
            if($cnt % $page_length == 0){
                say "                <tr><th>section</th><th>name</th><th>link</th><th>Select</th></tr>";
            }
        }
        my @buttons = ({tag => 'input', name => 'delete', type => 'submit', value => 'Delete Section', }, {tag => 'input', name => 'delete', type => 'submit', value => 'Delete Link', }, );
        $self->bottom_buttons($debug, $dont_showdebug, undef, 16, @buttons);
        #say "                <tr>";
        #say "                    <td>";
        #if($debug){
        #    say "                        <label for=\"debug\"><div class=\"ex\"><input name=\"debug\" id=\"debug\" type=\"radio\" value=\"1\" checked> debug</div></label>";
        #    say "                    </td>";
        #    say "                    <td>";
        #    say "                        <label for=\"nodebug\"><div class=\"ex\"><input name=\"debug\" id=\"nodebug\" type=\"radio\" value=\"0\"> nodebug</div></label>";
        #}else{
        #    say "                        <label for=\"debug\"><div class=\"ex\"><input name=\"debug\" id=\"debug\" type=\"radio\" value=\"1\"> debug</div></label>";
        #    say "                    </td>";
        #    say "                    <td>";
        #    say "                        <label for=\"nodebug\"><div class=\"ex\"><input name=\"debug\" id=\"nodebug\" type=\"radio\" value=\"0\" checked> nodebug</div></label>";
        #}
        #say "                    </td>";
        #say "                    <td>";
        #say "                        <input name=\"delete\" type=\"submit\" value=\"Delete Section\">";
        #say "                    </td>";
        #say "                    <td>";
        #say "                        <input name=\"delete\" type=\"submit\" value=\"Delete Link\">";
        #say "                    </td>";
        #say "                </tr>";
        say "            </table>";
        say "        </form>";

        return 1;
    } ## --- end sub delete_links


    sub message {
        my ($self, $cfg, $debug, $_session, $db, $fun, $button_msg, $dont_do_form, @msgs) = @_;
        my $ident           = ident $self;

        my $dont_showdebug  = !$cfg->val('general', 'showdebug');

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
            $button_msg = 'Try Again' unless defined $button_msg;
            my @buttons = ({tag => 'input', name => 'submit', type => 'submit', value => $button_msg, }, );
            $self->bottom_buttons($debug, $dont_showdebug, undef, 16, @buttons);
            #say "                <tr>";
            #say "                    <td>";
            #if($debug){
            #    say "                        <label for=\"debug\"><div class=\"ex\"><input name=\"debug\" id=\"debug\" type=\"radio\" value=\"1\" checked> debug</div></label>";
            #    say "                    </td>";
            #    say "                    <td>";
            #    say "                        <label for=\"nodebug\"><div class=\"ex\"><input name=\"debug\" id=\"nodebug\" type=\"radio\" value=\"0\"> nodebug</div></label>";
            #}else{
            #    say "                        <label for=\"debug\"><div class=\"ex\"><input name=\"debug\" id=\"debug\" type=\"radio\" value=\"1\"> debug</div></label>";
            #    say "                    </td>";
            #    say "                    <td>";
            #    say "                        <label for=\"nodebug\"><div class=\"ex\"><input name=\"debug\" id=\"nodebug\" type=\"radio\" value=\"0\" checked> nodebug</div></label>";
            #}
            #say "                    </td>";
            #if($button_msg){
            #    say "                    <td>";
            #    say "                        <input name=\"submit\" type=\"submit\" value=\"$button_msg\">";
            #    say "                    </td>";
            #}else{
            #    say "                    <td>";
            #    say "                        <input name=\"submit\" type=\"submit\" value=\"Try Again\">";
            #    say "                    </td>";
            #}
            #say "                </tr>";
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

        my $dont_showdebug  = !$cfg->val('general', 'showdebug');

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

        my $loggedin                  = $session{loggedin};
        my $loggedin_id               = $session{loggedin_id};
        my $loggedin_username         = $session{loggedin_username};
        my $loggedin_admin            = $session{loggedin_admin};
        my $loggedin_display_name     = $session{loggedin_display_name};
        my $loggedin_given            = $session{loggedin_given};
        my $loggedin_family           = $session{loggedin_family};
        my $loggedin_email            = $session{loggedin_email};
        my $loggedin_phone_number     = $session{loggedin_phone_number};
        my $loggedin_groupname        = $session{loggedin_groupname};
        my $loggedin_primary_group_id = $session{loggedin_groupnname_id};

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
                    my $sql  = "DELETE FROM page_section\n";
                    $sql    .= "WHERE pages_id = ? AND (? = 1 OR (userid = ? AND (_perms)._user._del = true)\n";
                    $sql    .= "      OR ((groupid = ? OR groupid IN (SELECT gs.group_id FROM groups gs WHERE gs.passwd_id = ?))\n";
                    $sql    .= "            AND (_perms)._group._del = true) OR (_perms)._other._del = true);\n";
                    my $query           = $db->prepare($sql);
                    my $result;
                    eval {
                        $result         = $query->execute($page_id, $loggedin_admin, $loggedin_id, $loggedin_primary_group_id, $loggedin_id);
                    };
                    if($@){
                        push @msgs,  "Error: Delete page_section failed: $@";
                        $return = 0;
                        $query->finish();
                        next;
                    }
                    if($result){
                        push @msgs,  "Delete page_section Success";
                        $sql  = "DELETE FROM pages\n";
                        $sql .= "WHERE id = ? AND (? = 1 OR (userid = ? AND (_perms)._user._del = true)\n";
                        $sql .= "     OR ((groupid = ? OR groupid IN (SELECT gs.group_id FROM groups gs WHERE gs.passwd_id = ?))\n";
                        $sql .= "          AND (_perms)._group._del = true) OR (_perms)._other._del = true);\n";
                        $query           = $db->prepare($sql);
                        eval {
                            $result         = $query->execute($page_id, $loggedin_admin, $loggedin_id, $loggedin_primary_group_id, $loggedin_id);
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
            $self->message($cfg, $debug, \%session, $db, 'delete_pages', 'Delete some more pages', undef, @msgs);

            untie %session;
            $db->disconnect;
            return $return;
        }

        my $sql  = "SELECT p.id, p.name, p.full_name FROM pages p\n";
        $sql    .= "WHERE  (? = 1 OR (p.userid = ? AND (p)._perms._user._read = true) OR ((p.groupid = ? OR p.groupid IN (SELECT gs.group_id FROM groups gs WHERE gs.passwd_id = ?)) AND (p)._perms._group._read = true) OR (p)._perms._other._read = true)\n";
        $sql    .= "ORDER BY p.name, p.full_name\n";
        my $query           = $db->prepare($sql);
        my $result;
        eval {
            $result         = $query->execute($loggedin_admin, $loggedin_id, $loggedin_primary_group_id, $loggedin_id);
        };
        if($@){
            $self->message($cfg, $debug, \%session, $db, 'delete_pages', undef, undef, "Error: $@");
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
        say "                        <label for=\"page_length\"><div class=\"ex\">Page Length:";
        say "                            <input type=\"number\" name=\"page_length\" id=\"page_length\" min=\"10\" max=\"180\" step=\"1\" value=\"$page_length\" size=\"3\"></div>";
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
            say "                        <label for=\"$page_id\"><div class=\"ex\">$name</div></label>";
            say "                    </td>";
            say "                    <td>";
            say "                        <label for=\"$page_id\"><div class=\"ex\">$full_name</div></label>";
            say "                    </td>";
            say "                    <td>";
            say "                        <label for=\"$page_id\"><div class=\"ex\"><input type=\"checkbox\" name=\"delete_set[$cnt]\" id=\"$page_id\" value=\"$page_id\"/></div></label>";
            say "                    </td>";
            say "                </tr>";
            if($cnt % $page_length == 0){
                say "                <tr><th>Name</th><th>Full Name</th><th>Select</th></tr>";
            }
        }
        my @buttons = ({tag => 'input', name => 'delete', type => 'submit', value => 'Delete Pages', }, );
        $self->bottom_buttons($debug, $dont_showdebug, undef, 16, @buttons);
        #say "                <tr>";
        #say "                    <td>";
        #if($debug){
        #    say "                        <label for=\"debug\"><div class=\"ex\"><input name=\"debug\" id=\"debug\" type=\"radio\" value=\"1\" checked> debug</div></label>";
        #    say "                    </td>";
        #    say "                    <td>";
        #    say "                        <label for=\"nodebug\"><div class=\"ex\"><input name=\"debug\" id=\"nodebug\" type=\"radio\" value=\"0\"> nodebug</div></label>";
        #}else{
        #    say "                        <label for=\"debug\"><div class=\"ex\"><input name=\"debug\" id=\"debug\" type=\"radio\" value=\"1\"> debug</div></label>";
        #    say "                    </td>";
        #    say "                    <td>";
        #    say "                        <label for=\"nodebug\"><div class=\"ex\"><input name=\"debug\" id=\"nodebug\" type=\"radio\" value=\"0\" checked> nodebug</div></label>";
        #}
        #say "                    </td>";
        #say "                    <td>";
        #say "                        <input name=\"delete\" type=\"submit\" value=\"Delete Pages\">";
        #say "                    </td>";
        #say "                </tr>";
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

        my $dont_showdebug  = !$cfg->val('general', 'showdebug');

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

        my $loggedin                  = $session{loggedin};
        my $loggedin_id               = $session{loggedin_id};
        my $loggedin_username         = $session{loggedin_username};
        my $loggedin_admin            = $session{loggedin_admin};
        my $loggedin_display_name     = $session{loggedin_display_name};
        my $loggedin_given            = $session{loggedin_given};
        my $loggedin_family           = $session{loggedin_family};
        my $loggedin_email            = $session{loggedin_email};
        my $loggedin_phone_number     = $session{loggedin_phone_number};
        my $loggedin_groupname        = $session{loggedin_groupname};
        my $loggedin_primary_group_id = $session{loggedin_groupnname_id};

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
                    my $sql  = "DELETE FROM pseudo_pages\n";
                    $sql    .= "WHERE id = ? AND (? = 1 OR (userid = ? AND (_perms)._user._del = true)\n";
                    $sql    .= "        OR ((groupid = ? OR groupid IN (SELECT gs.group_id FROM groups gs WHERE gs.passwd_id = ?))\n";
                    $sql    .= "                AND (_perms)._group._del = true) OR (_perms)._other._del = true);\n";
                    my $query           = $db->prepare($sql);
                    my $result;
                    eval {
                        $result         = $query->execute($page_id, $loggedin_admin, $loggedin_id, $loggedin_primary_group_id, $loggedin_id);
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
            $self->message($cfg, $debug, \%session, $db, 'delete_pseudo_page', 'Delete some more pseudo_pages', undef, @msgs);

            untie %session;
            $db->disconnect;
            return $return;
        }

        my $sql  = "SELECT pp.id, pp.name, pp.full_name, pp.pattern, pp.status FROM pseudo_pages pp\n";
        $sql    .= "WHERE (? = 1 OR (pp.userid = ? AND (pp)._perms._user._read = true)\n";
        $sql    .= "    OR ((pp.groupid = ? OR pp.groupid IN (SELECT gs.group_id FROM groups gs WHERE gs.passwd_id = ?))\n";
        $sql    .= "        AND (pp)._perms._group._read = true) OR (pp)._perms._other._read = true)\n";
        $sql    .= "ORDER BY pp.name, pp.full_name\n";
        my $query           = $db->prepare($sql);
        my $result;
        eval {
            $result         = $query->execute($loggedin_admin, $loggedin_id, $loggedin_primary_group_id, $loggedin_id);
        };
        if($@){
            $self->message($cfg, $debug, \%session, $db, 'delete_pseudo_page', undef, undef, "Error: $@", "Cannot read from pseudo_pages");
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
        say "                    <td colspan=\"5\">";
        say "                        <label for=\"page_length\"><div class=\"ex\">Page Length:";
        say "                            <input type=\"number\" name=\"page_length\" id=\"page_length\" min=\"10\" max=\"180\" step=\"1\" value=\"$page_length\" size=\"3\"></div>";
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
            say "                        <label for=\"$pseudo_page_id\"><div class=\"ex\">$name</div></label>";
            say "                    </td>";
            say "                    <td>";
            say "                        <label for=\"$pseudo_page_id\"><div class=\"ex\">$full_name</div></label>";
            say "                    </td>";
            say "                    <td>";
            say "                        <label for=\"$pseudo_page_id\"><div class=\"ex\">$pattern</div></label>";
            say "                    </td>";
            say "                    <td>";
            say "                        <label for=\"$pseudo_page_id\"><div class=\"ex\">$status</div></label>";
            say "                    </td>";
            say "                    <td>";
            say "                        <label for=\"$pseudo_page_id\"><div class=\"ex\"><input type=\"checkbox\" name=\"delete_set[$cnt]\" id=\"$pseudo_page_id\" value=\"$pseudo_page_id\"/></div></label>";
            say "                    </td>";
            say "                </tr>";
            if($cnt % $page_length == 0){
                say "                <tr><th>Name</th><th>Full Name</th><th>Pattern</th><th>Status</th><th>Select</th></tr>";
            }
        }
        my @buttons = ({tag => 'input', name => 'delete', type => 'submit', value => 'Delete Pseudo-Pages', colspan => 3, }, );
        $self->bottom_buttons($debug, $dont_showdebug, undef, 16, @buttons);
        #say "                <tr>";
        #say "                    <td>";
        #if($debug){
        #    say "                        <label for=\"debug\"><div class=\"ex\"><input name=\"debug\" id=\"debug\" type=\"radio\" value=\"1\" checked> debug</div></label>";
        #    say "                    </td>";
        #    say "                    <td>";
        #    say "                        <label for=\"nodebug\"><div class=\"ex\"><input name=\"debug\" id=\"nodebug\" type=\"radio\" value=\"0\"> nodebug</div></label>";
        #}else{
        #    say "                        <label for=\"debug\"><div class=\"ex\"><input name=\"debug\" id=\"debug\" type=\"radio\" value=\"1\"> debug</div></label>";
        #    say "                    </td>";
        #    say "                    <td>";
        #    say "                        <label for=\"nodebug\"><div class=\"ex\"><input name=\"debug\" id=\"nodebug\" type=\"radio\" value=\"0\" checked> nodebug</div></label>";
        #}
        #say "                    </td>";
        #say "                    <td colspan=\"3\">";
        #say "                        <input name=\"delete\" type=\"submit\" value=\"Delete Pseudo-Pages\">";
        #say "                    </td>";
        #say "                </tr>";
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

        my $dont_showdebug  = !$cfg->val('general', 'showdebug');

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

        my $loggedin                  = $session{loggedin};
        my $loggedin_id               = $session{loggedin_id};
        my $loggedin_username         = $session{loggedin_username};
        my $loggedin_admin            = $session{loggedin_admin};
        my $loggedin_display_name     = $session{loggedin_display_name};
        my $loggedin_given            = $session{loggedin_given};
        my $loggedin_family           = $session{loggedin_family};
        my $loggedin_email            = $session{loggedin_email};
        my $loggedin_phone_number     = $session{loggedin_phone_number};
        my $loggedin_groupname        = $session{loggedin_groupname};
        my $loggedin_primary_group_id = $session{loggedin_groupnname_id};

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
                    my $sql  = "DELETE FROM alias\n";
                    $sql    .= "WHERE id = ? AND (? = 1\n";
                    $sql    .= "        OR (userid = ? AND (_perms)._user._del = true)\n";
                    $sql    .= "                OR ((groupid = ? OR groupid IN (SELECT gs.group_id FROM groups gs WHERE gs.passwd_id = ?))\n";
                    $sql    .= "                        AND (_perms)._group._del = true) OR (_perms)._other._del = true);\n";
                    my $query           = $db->prepare($sql);
                    my $result;
                    eval {
                        $result         = $query->execute($page_id, $loggedin_admin, $loggedin_id, $loggedin_primary_group_id, $loggedin_id);
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
            $self->message($cfg, $debug, \%session, $db, 'delete_aliases', 'Delete some more Aliases', undef, @msgs);
            return $return;
        }

        my $sql  = "SELECT a.id, a.name, a.section FROM aliases a\n";
        $sql    .= "WHERE (? = 1 OR (a.userid = ? AND (a)._perms._user._read = true)\n";
        $sql    .= "     OR ((a.groupid = ? OR a.groupid IN (SELECT gs.group_id FROM groups gs WHERE gs.passwd_id = ?))\n";
        $sql    .= "          AND (a)._perms._group._read = true) OR (a)._perms._other._read = true)\n";
        $sql    .= "ORDER BY a.name, a.section\n";
        my $query           = $db->prepare($sql);
        my $result;
        eval {
            $result         = $query->execute($loggedin_admin, $loggedin_id, $loggedin_primary_group_id, $loggedin_id);
        };
        if($@){
            $self->message($cfg, $debug, \%session, $db, 'delete_aliases', undef, "Error: $@", "Cannnot Read aliases");
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
        say "                        <label for=\"page_length\"><div class=\"ex\">Page Length:";
        say "                            <input type=\"number\" name=\"page_length\" id=\"page_length\" min=\"10\" max=\"180\" step=\"1\" value=\"$page_length\" size=\"3\"></div>";
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
            say "                        <label for=\"$alias_id\"><div class=\"ex\">$name</div></label>";
            say "                    </td>";
            say "                    <td>";
            say "                        <label for=\"$alias_id\"><div class=\"ex\">$section</div></label>";
            say "                    </td>";
            say "                    <td>";
            say "                        <label for=\"$alias_id\"><div class=\"ex\"><input type=\"checkbox\" name=\"delete_set[$cnt]\" id=\"$alias_id\" value=\"$alias_id\"/></div></label>";
            say "                    </td>";
            say "                </tr>";
            if($cnt % $page_length == 0){
                say "                <tr><th>Name</th><th>Full Name</th><th>Select</th></tr>";
            }
        }
        my @buttons = ({tag => 'input', name => 'delete', type => 'submit', value => 'Delete Aliases', }, );
        $self->bottom_buttons($debug, $dont_showdebug, undef, 16, @buttons);
        #say "                <tr>";
        #say "                    <td>";
        #if($debug){
        #    say "                        <label for=\"debug\"><div class=\"ex\"><input name=\"debug\" id=\"debug\" type=\"radio\" value=\"1\" checked> debug</div></label>";
        #    say "                    </td>";
        #    say "                    <td>";
        #    say "                        <label for=\"nodebug\"><div class=\"ex\"><input name=\"debug\" id=\"nodebug\" type=\"radio\" value=\"0\"> nodebug</div></label>";
        #}else{
        #    say "                        <label for=\"debug\"><div class=\"ex\"><input name=\"debug\" id=\"debug\" type=\"radio\" value=\"1\"> debug</div></label>";
        #    say "                    </td>";
        #    say "                    <td>";
        #    say "                        <label for=\"nodebug\"><div class=\"ex\"><input name=\"debug\" id=\"nodebug\" type=\"radio\" value=\"0\" checked> nodebug</div></label>";
        #}
        #say "                    </td>";
        #say "                    <td>";
        #say "                        <input name=\"delete\" type=\"submit\" value=\"Delete Aliases\">";
        #say "                    </td>";
        #say "                </tr>";
        say "            </table>";
        say "        </form>";

        return 1;
    } ## --- end sub delete_aliases
    

    sub get_id {
        my ($self, $req, $cfg, $rec) = @_;
        my $ident = ident $self;
        my $debug = $debug{$ident};
        my $j     = Apache2::Cookie::Jar->new($rec);
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

        my $dont_showdebug  = !$cfg->val('general', 'showdebug');

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

        my $loggedin                  = $session{loggedin};
        my $loggedin_id               = $session{loggedin_id};
        my $loggedin_username         = $session{loggedin_username};
        my $loggedin_admin            = $session{loggedin_admin};
        my $loggedin_display_name     = $session{loggedin_display_name};
        my $loggedin_given            = $session{loggedin_given};
        my $loggedin_family           = $session{loggedin_family};
        my $loggedin_email            = $session{loggedin_email};
        my $loggedin_phone_number     = $session{loggedin_phone_number};
        my $loggedin_groupname        = $session{loggedin_groupname};
        my $loggedin_primary_group_id = $session{loggedin_groupnname_id};

        return 0 unless $loggedin_admin;

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
            $self->message($cfg, $debug, \%session, $db, ($return?'main':'user'), ($return ? 'user' : undef), !$return && @msgs, @msgs) if @msgs;

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
                $self->log(Data::Dumper->Dump([$debug, \%session, $submit], [qw(debug %session submit)]));
                for my $passwd_id (@selected){
                    if($passwd_id == 1){
                        push @msgs, "leave user id == 1 alone this is a reserved account";
                        next;
                    }
                    $self->log(Data::Dumper->Dump([$passwd_id, \@msgs, $submit], [qw(passwd_id @msgs submit)]));
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
                        $self->log(Data::Dumper->Dump([$r, $username, $passwd_details_id, $primary_group_id, $email_id, $sql], [qw(r username passwd_details_id primary_group_id email_id sql)]));
                        my ($return_addresses, @msgs_addresses) = $self->delete_addresses($passwd_id, \%session, $db);
                        push @msgs, @msgs_addresses;
                        $return = 0 unless $return_addresses;
                        my ($return_emails, @msgs_emails) = $self->delete_emails($passwd_id, \%session, $db);
                        push @msgs, @msgs_emails;
                        $return = 0 unless $return_emails;
                        my ($return_groups, @msgs_groups) = $self->delete_groups($passwd_id, \%session, $db);
                        push @msgs, @msgs_groups;
                        $return = 0 unless $return_groups;
                        my ($return_passwd, @msgs_passwd) = $self->delete_passwd($passwd_id, $primary_group_id, \%session, $db);
                        push @msgs, @msgs_passwd;
                        $return = 0 unless $return_passwd;
                        my ($return_passwd_details, @msgs_passwd_details) = $self->delete_passwd_details($passwd_details_id, $passwd_id, \%session, $db);
                        push @msgs, @msgs_passwd_details;
                        $return = 0 unless $return_passwd_details;
                        my ($return_email, @msgs_email) = $self->delete_email($email_id, $passwd_id, \%session, $db);
                        push @msgs, @msgs_email;
                        $return = 0 unless $return_email;
                        my ($return_group, @msgs_group) = $self->delete_group($primary_group_id, $passwd_id, \%session, $db);
                        push @msgs, @msgs_group;
                        $return = 0 unless $return_group;
                        $self->log(Data::Dumper->Dump([$return, \@msgs, $submit], [qw(return @msgs submit)]));
                    }
                }
                push @msgs, "Nothing to change" unless @selected;
            }
            $self->log(Data::Dumper->Dump([$return, \@msgs, $submit], [qw(return @msgs submit)]));
            $self->message($cfg, $debug, \%session, $db, ($return?'main':'user'), ($return ? 'continue' : undef), 1, @msgs) if @msgs;
        }

        my @user_details;
        my $sql  = "SELECT p.id, p.username, p.primary_group_id, p._admin, pd.display_name, pd.given, pd._family,\n";
        $sql    .= "e._email, ph._number phone_number, ph2._number secondary_phone, g._name groupname, g.id group_id, c._flag,\n";
        $sql    .= "ARRAY((SELECT g1._name FROM _group g1 JOIN groups gs ON g1.id = gs.group_id WHERE gs.passwd_id = p.id))  additional_groups\n";
        $sql    .= "FROM passwd p JOIN passwd_details pd ON p.passwd_details_id = pd.id JOIN email e ON p.email_id = e.id\n";
        $sql    .= "         LEFT JOIN phone  ph ON ph.id = pd.primary_phone_id LEFT JOIN phone ph2 ON ph2.id = pd.secondary_phone_id\n";
        $sql    .= "                 JOIN _group g ON p.primary_group_id = g.id LEFT JOIN countries c ON pd.countries_id = c.id\n";
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
            $self->message($cfg, $debug, \%session, $db, 'user', undef, undef, @msgs) if @msgs;
            return $return;
        }
        
        say "        <form action=\"user.pl\" method=\"post\" id=\"main_form\">";
        say "            <h1>Edit User Details</h1>";
        my $page_length = $req->param('page_length');
        $page_length = $session{page_length} if !defined $page_length && exists $session{page_length};
        $page_length    = 25 if !defined $page_length || $page_length < 10 || $page_length > 180;
        $session{page_length} = $page_length;

        untie %session;
        $db->disconnect;

        say "            <input type=\"hidden\" name=\"passwd_id\" id=\"passwd_id_hidden\" value=\"0\">";
        say "            <script>";
        say "                function doSubmit(self, hidden_val){";
        say "                    var h = document.getElementById(\"passwd_id_hidden\");";
        say "                    h.value = hidden_val;";
        say "                    var frm = document.getElementById(\"main_form\");";
        say "                    frm.action = 'user-details.pl';";
        say "                    var btn = document.getElementById(self);";
        say "                    //alert(\"h.value == \" + h.value + \"\\nfrm.action == \" + frm.action + \"\\nbtn.name == \" + btn.name + \"\\nbtn.value == \" + btn.value);";
        say "                }";
        say "            </script>";
        say "            <table>";
        say "                <tr>";
        say "                    <td colspan=\"5\">";
        say "                        <label for=\"page_length\">Page Length:";
        say "                            <input type=\"number\" name=\"page_length\" id=\"page_length\" min=\"10\" max=\"180\" step=\"1\" value=\"$page_length\" size=\"3\">";
        say "                        </label>";
        say "                    </td>";
        say "                    <td colspan=\"8\">";
        say "                    <input type=\"submit\" name=\"submit\" id=\"apply_page_length\" value=\"Apply Page Length\"/>";
        say "                    </td>";
        say "                </tr>";
        say "                <tr><th>id</th><th>username</th><th>given names</th><th>family name</th><th>email</th><th>mobile</th><th>land line</th><th>group</th><th>admin</th><th>additional groups</th><th>Flag</th><th>selected</th><th>Edit Button</th></tr>";
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
            my $secondary_phone   = $user->{secondary_phone};
            $secondary_phone      = '' unless defined $secondary_phone;
            my $groupname         = $user->{groupname};
            my $_flag             = $user->{_flag};
            my $additional_groups = $user->{additional_groups};
            $additional_groups    = join ', ', @{$additional_groups};
            my $_admin_checked;
            if($_admin){
                $_admin_checked = '&radic;';
            }else{
                $_admin_checked = '&otimes;';
            }
            say "                <tr>";
            say "                    <td>";
            say "                        <label for=\"selected_$passwd_id\"><div class=\"ex\">$passwd_id</div></label>";
            say "                    </td>";
            say "                    <td>";
            say "                        <label for=\"selected_$passwd_id\"><div class=\"ex\">$username</div></label>";
            say "                    </td>";
            say "                    <td>";
            say "                        <label for=\"selected_$passwd_id\"><div class=\"ex\">$given</div></label>";
            say "                    </td>";
            say "                    <td>";
            say "                        <label for=\"selected_$passwd_id\"><div class=\"ex\">$family</div></label>";
            say "                    </td>";
            say "                    <td>";
            say "                        <label for=\"selected_$passwd_id\"><div class=\"ex\">$email</div></label>";
            say "                    </td>";
            say "                    <td>";
            $phone_number = '&nbsp;' unless $phone_number;
            say "                        <label for=\"selected_$passwd_id\"><div class=\"ex\">$phone_number</div></label>";
            say "                    </td>";
            say "                    <td>";
            $secondary_phone = '&nbsp;' unless $secondary_phone;
            say "                        <label for=\"selected_$passwd_id\"><div class=\"ex\">$secondary_phone</div></label>";
            say "                    </td>";
            say "                    <td>";
            say "                        <label for=\"selected_$passwd_id\"><div class=\"ex\">$groupname</div></label>";
            say "                    </td>";
            say "                    <td>";
            say "                        <label for=\"selected_$passwd_id\"><div class=\"ex\">$_admin_checked</div></label>";
            say "                    </td>";
            say "                    <td>";
            say "                        <label for=\"selected_$passwd_id\"><div class=\"ex\">$additional_groups</div></label>";
            say "                    </td>";
            say "                    <td>";
            say "                        <label for=\"selected_$passwd_id\"><div class=\"ex\"><img src=\"$_flag\" alt=\"$display_name\"/></div></label>";
            say "                    </td>";
            say "                    <td>";
            if($passwd_id == 1){
                say "                        <label for=\"selected_$passwd_id\"><div class=\"ex\">&nbsp;</div></label>";
            }else{
                say "                        <label for=\"selected_$passwd_id\"><div class=\"ex\"><input type=\"checkbox\" name=\"selected_[$cnt]\" id=\"selected_$passwd_id\" value=\"$passwd_id\"/></div></label>";
            }
            say "                    </td>";
            say "                    <td>";
            say "                        <input type=\"submit\" name=\"submit\" id=\"user_details[$cnt]\" value=\"Edit user: $username\" onclick=\"doSubmit('user_details[$cnt]', '$passwd_id')\">";
            say "                    </td>";
            say "                </tr>";
            if($cnt % $page_length == 0){
                say "                <tr><th>id</th><th>username</th><th>given names</th><th>family name</th><th>email</th><th>mobiler</th><th>land line</th><th>group</th><th>admin</th><th>additional groups</th><th>Flag</th><th>selected</th><th>Edit Button</th></tr>";
            }
        }
        my @buttons = ({tag => 'input', name => 'submit', type => 'submit', value => 'Delete Users', colspan => 3, }, {tag => 'input', name => 'submit', type => 'submit', value => 'Toggle Admin Flag', colspan => 8, }, );
        $self->bottom_buttons($debug, $dont_showdebug, undef, 16, @buttons);
        #say "                <tr>";
        #say "                    <td>";
        #if($debug){
        #    say "                        <label for=\"debug\"><div class=\"ex\"><input name=\"debug\" id=\"debug\" type=\"radio\" value=\"1\" checked> debug</div></label>";
        #    say "                    </td>";
        #    say "                    <td>";
        #    say "                        <label for=\"nodebug\"><div class=\"ex\"><input name=\"debug\" id=\"nodebug\" type=\"radio\" value=\"0\"> nodebug</div></label>";
        #}else{
        #    say "                        <label for=\"debug\"><div class=\"ex\"><input name=\"debug\" id=\"debug\" type=\"radio\" value=\"1\"> debug</div></label>";
        #    say "                    </td>";
        #    say "                    <td>";
        #    say "                        <label for=\"nodebug\"><div class=\"ex\"><input name=\"debug\" id=\"nodebug\" type=\"radio\" value=\"0\" checked> nodebug</div></label>";
        #}
        #say "                    </td>";
        #say "                    <td colspan=\"3\">";
        #say "                        <input name=\"submit\" type=\"submit\" value=\"Delete Users\">";
        #say "                    </td>";
        #say "                    <td colspan=\"8\">";
        #say "                        <input name=\"submit\" type=\"submit\" value=\"Toggle Admin Flag\">";
        #say "                    </td>";
        #say "                </tr>";
        say "            </table>";
        say "        </form>";

        return 1;
    } ## --- end sub user

    
    sub normalise_mobile {
        my ($self, $mobile, $cc, $prefix, $_escape, $pattern, $_session, $db) = @_;
        my %session = %{$_session};

        my $loggedin                  = $session{loggedin};
        my $loggedin_id               = $session{loggedin_id};
        my $loggedin_username         = $session{loggedin_username};
        my $loggedin_admin            = $session{loggedin_admin};
        my $loggedin_display_name     = $session{loggedin_display_name};
        my $loggedin_given            = $session{loggedin_given};
        my $loggedin_family           = $session{loggedin_family};
        my $loggedin_email            = $session{loggedin_email};
        my $loggedin_phone_number     = $session{loggedin_phone_number};
        my $loggedin_groupname        = $session{loggedin_groupname};
        my $loggedin_primary_group_id = $session{loggedin_groupnname_id};
        if($mobile !~ m/^$pattern$/){
            die("$mobile does not match pattern: $pattern");
        }
        $mobile =~ s/[ ()-]//g;
        $mobile =~ s/^$_escape/$prefix/g if defined $_escape;
        return $mobile;
    } ## --- end sub normalise_mobile
    
    sub normalise_landline {
        my ($self, $phone, $cc, $prefix, $_escape, $pattern, $_session, $db) = @_;
        my %session = %{$_session};

        my $loggedin                  = $session{loggedin};
        my $loggedin_id               = $session{loggedin_id};
        my $loggedin_username         = $session{loggedin_username};
        my $loggedin_admin            = $session{loggedin_admin};
        my $loggedin_display_name     = $session{loggedin_display_name};
        my $loggedin_given            = $session{loggedin_given};
        my $loggedin_family           = $session{loggedin_family};
        my $loggedin_email            = $session{loggedin_email};
        my $loggedin_phone_number     = $session{loggedin_phone_number};
        my $loggedin_groupname        = $session{loggedin_groupname};
        my $loggedin_primary_group_id = $session{loggedin_groupnname_id};
        if($phone !~ m/^$pattern$/){
            die("$phone does not match pattern: $pattern");
        }
        $phone =~ s/[ ()-]//g;
        $phone =~ s/^$_escape/$prefix/g if defined $_escape;
        return $phone;
    } ## --- end sub normalise_landline


    sub getphonedetails {
        my ($self, $countries_id, $cc, $prefix, $db) = @_;
        my ($_escape, $mobile_pattern, $landline_pattern, $return, @msgs);
        $return = 1;
        my $sql  = "SELECT c.landline_pattern, c.mobile_pattern, c._escape FROM countries c\n";
        $sql    .= "WHERE c.id = ?;\n";
        my $query  = $db->prepare($sql);
        my $result;
        eval {
            $result = $query->execute($countries_id);
        };
        if($@){
            push @msgs, "SELECT FROM countries failed: $@";
            $return = 0;
        }
        $self->log(Data::Dumper->Dump([$query, $result, \@msgs, $sql], [qw(query result @msgs sql)]));
        my $r;
        if($return){
            $r      = $query->fetchrow_hashref();
            $_escape           = $r->{_escape};
            $mobile_pattern   = $r->{mobile_pattern};
            $landline_pattern = $r->{landline_pattern};
        }else{
            push @msgs, "SELECT FROM countries failed: $sql";
            $return = 0;
        }
        $query->finish();
        return ($_escape, $mobile_pattern, $landline_pattern, $return, @msgs);
    } ## --- end sub getphonedetails


    sub user_details {
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

        my $dont_showdebug  = !$cfg->val('general', 'showdebug');

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

        $self->links('user_details', \%session);

        my $loggedin                  = $session{loggedin};
        my $loggedin_id               = $session{loggedin_id};
        my $loggedin_username         = $session{loggedin_username};
        my $loggedin_admin            = $session{loggedin_admin};
        my $loggedin_display_name     = $session{loggedin_display_name};
        my $loggedin_given            = $session{loggedin_given};
        my $loggedin_family           = $session{loggedin_family};
        my $loggedin_email            = $session{loggedin_email};
        my $loggedin_phone_number     = $session{loggedin_phone_number};
        my $loggedin_groupname        = $session{loggedin_groupname};
        my $loggedin_primary_group_id = $session{loggedin_groupnname_id};

        my $submit             = $req->param('submit');
        my $user_id;
        my $username;
        my $email;
        my $password;
        my $repeat;
        my $mobile;
        my $phone;
        my $unit;
        my $street;
        my $city_suburb;
        my $postcode;
        my $region;
        my $country;
        my $postal_same;
        my $postal_unit;
        my $postal_street;
        my $postal_city_suburb;
        my $postal_postcode;
        my $postal_region;
        my $postal_country;
        my $given;
        my $family;
        my $display_name;
        my $admin;
        my $isadmin;
        my $cc;
        my $prefix;
        my $countries_id;
        my $group_id;
        my $email_id;
        my $residential_address_id;
        my $postal_address_id;
        my $primary_group_id;
        my $primary_phone_id;
        my $secondary_phone_id;
        my $passwd_details_id;
        my @additional_groups;
        my @group_id_add;
        my @group_id_delete;
        
        if($submit eq 'Save Changes'){
            $user_id                = $req->param('user_id');
            $username               = $req->param('username');
            $email                  = $req->param('email');
            $password               = $req->param('password');
            $repeat                 = $req->param('repeat');
            $mobile                 = $req->param('mobile');
            $phone                  = $req->param('phone');
            $unit                   = $req->param('unit');
            $street                 = $req->param('street');
            $city_suburb            = $req->param('city_suburb');
            $postcode               = $req->param('postcode');
            $region                 = $req->param('region');
            $country                = $req->param('country');
            $postal_same            = $req->param('postal_same');
            $postal_unit            = $req->param('postal_unit');
            $postal_street          = $req->param('postal_street');
            $postal_city_suburb     = $req->param('postal_city_suburb');
            $postal_postcode        = $req->param('postal_postcode');
            $postal_region          = $req->param('postal_region');
            $postal_country         = $req->param('postal_country');
            $given                  = $req->param('given');
            $family                 = $req->param('family');
            $display_name           = $req->param('display_name');
            $admin                  = $req->param('admin');
            $cc                     = $req->param('cc');
            $prefix                 = $req->param('prefix');
            $countries_id           = $req->param('countries_id');
            $group_id               = $req->param('group_id');
            $email_id               = $req->param('email_id');
            $residential_address_id = $req->param('residential_address_id');
            $postal_address_id      = $req->param('postal_address_id');
            $primary_group_id       = $req->param('primary_group_id');
            $primary_phone_id       = $req->param('primary_phone_id');
            $secondary_phone_id     = $req->param('secondary_phone_id');
            $passwd_details_id      = $req->param('passwd_details_id');
            my @params              = $req->param;
            for (@params){
                if(m/^group_id_add\[(\d+)\]$/){
                    my $_group_id = $req->param($_);
                    my ($group_name, $return_group, @msgs_group) = $self->getgroup_name($_group_id, $db);
                    unless($return_group){
                        $self->message($cfg, $debug, \%session, $db, ($return_group?'user':'user_details'), ($return_group ? 'login' : undef), !$return_group, @msgs_group);
                    }
                    push @additional_groups, {  _group_id => $_group_id, group_name => $group_name, };
                    push @group_id_add, $_group_id;
                }elsif(m/^group_id_delete\[(\d+)\]$/){
                    my $_group_id = $req->param($_);
                    push @group_id_delete, $_group_id;
                }
            }
        }else{
            my @msgs;
            my $return = 1;
            my $passwd_id       = $req->param('passwd_id');
            if(!defined $passwd_id || $passwd_id <= 0){
                my @msgs = ("Error: user_id does not exist.", "passwd_id: $passwd_id <= 0!!!");
                $self->message($cfg, $debug, \%session, $db, 'user', 'go back to users', undef, @msgs);
                return 0;
            }
            my $sql             = "SELECT p.id, p.username, p.primary_group_id, p._admin, pd.display_name, pd.given, pd._family,\n";
            $sql               .= "ra.unit, ra.street, ra.city_suburb, ra.postcode, ra.region, ra.country, pa.unit postal_unit, pa.street postal_street, \n";
            $sql               .= "pa.city_suburb postal_city_suburb, pa.postcode postal_postcode, pa.region postal_region, pa.country postal_country,\n";
            $sql               .= "e._email, m._number mobile, ph._number phone, g._name groupname, g.id group_id, p.email_id,\n";
            $sql               .= "p.passwd_details_id, pd.residential_address_id, pd.postal_address_id, pd.primary_phone_id, pd.secondary_phone_id, pd.countries_id,\n";
            $sql               .= "c.cc, c.prefix,\n";
            $sql               .= "ARRAY((SELECT g1._name FROM _group g1 JOIN groups gs ON g1.id = gs.group_id WHERE gs.passwd_id = p.id))  additional_groups\n";
            $sql               .= "FROM passwd p JOIN passwd_details pd ON p.passwd_details_id = pd.id JOIN email e ON p.email_id = e.id\n";
            $sql               .= "         LEFT JOIN phone  ph ON ph.id = pd.secondary_phone_id JOIN _group g ON p.primary_group_id = g.id\n";
            $sql               .= "         LEFT JOIN phone  m ON m.id = pd.primary_phone_id LEFT JOIN countries c ON pd.countries_id = c.id\n";
            $sql               .= "         JOIN address ra ON ra.id = pd.residential_address_id JOIN address pa ON pa.id = pd.postal_address_id\n";
            $sql               .= "WHERE p.id = ?\n";
            my $query  = $db->prepare($sql);
            my $result;
            eval {
                $result = $query->execute($passwd_id);
            };
            if($@){
                push @msgs, "SELECT passwd etc al failed: $@";
                $return = 0;
            }
            $self->log(Data::Dumper->Dump([$debug, \%session, $loggedin_username, $loggedin_id, $sql], [qw(debug %session loggedin_username loggedin_id sql)]));
            my $r;
            if($return){
                $r      = $query->fetchrow_hashref();
                $self->log(Data::Dumper->Dump([$debug, \%session, $r, $loggedin_username, $loggedin_id, $sql], [qw(debug %session r loggedin_username loggedin_id sql)]));
                if(!$r){
                    my @msgs = ("Error: user_id does not exist.", "passwd_id: $passwd_id not found in Database!!!");
                    $self->message($cfg, $debug, \%session, $db, 'user', 'go back to users', undef, @msgs);
                    return 0;
                }
                if($r->{username} eq $loggedin_username){
                    $isadmin = $r->{_admin};
                }
            }else{
                $return = 0;
                push @msgs, "SELECT passwd etc al failed";
            }
            unless($return){
                $self->message($cfg, $debug, \%session, $db, 'user', undef, undef, @msgs);
                return 0;
            }
            $user_id                = $r->{id};
            $username               = $r->{username};
            $email                  = $r->{_email};
            $password               = '';
            $repeat                 = '';
            $mobile                 = $r->{mobile};
            $phone                  = $r->{phone};
            $unit                   = $r->{unit};
            $street                 = $r->{street};
            $city_suburb            = $r->{city_suburb};
            $postcode               = $r->{postcode};
            $region                 = $r->{region};
            $country                = $r->{country};
            $postal_same            = ($r->{residential_address_id} == $r->{postal_address_id});
            $postal_unit            = $r->{postal_unit};
            $postal_street          = $r->{postal_street};
            $postal_city_suburb     = $r->{postal_city_suburb};
            $postal_postcode        = $r->{postal_postcode};
            $postal_region          = $r->{postal_region};
            $postal_country         = $r->{postal_country};
            $given                  = $r->{given};
            $family                 = $r->{_family};
            $display_name           = $r->{display_name};
            $cc                     = $r->{cc};
            $prefix                 = $r->{prefix};
            $countries_id           = $r->{countries_id};
            $admin                  = $r->{_admin};
            $group_id               = $r->{group_id};
            $email_id               = $r->{email_id};
            $residential_address_id = $r->{residential_address_id};
            $postal_address_id      = $r->{postal_address_id};
            $primary_group_id       = $r->{primary_group_id};
            $primary_phone_id       = $r->{primary_phone_id};
            $secondary_phone_id     = $r->{secondary_phone_id};
            $passwd_details_id      = $r->{passwd_details_id};
            my @_groups             = @{$r->{additional_groups}};
            for my $group_name (@_groups){
                my ($_group_id, $return_group, @msgs_group) = $self->getgroup_id($group_name, $db);
                unless($return_group){
                    $self->message($cfg, $debug, \%session, $db, ($return_group?'user':'user_details'), ($return_group ? 'login' : undef), !$return_group, @msgs_group);
                    next;
                }
                push @additional_groups, {  _group_id => $_group_id, group_name => $group_name, };
            }
        }

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
                push @msgs, "SELECT passwd failed: $@";
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
            $self->message($cfg, $debug, \%session, $db, ($return?'main':'register'), ($return ? 'register' : undef), !$return && @msgs, @msgs) if @msgs;

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
                    $unit, $street, $city_suburb, $postcode, $region, $country, $postal_unit,
                    $postal_street, $postal_city_suburb, $postal_postcode, $postal_region,
                    $postal_country, $postal_same, $loggedin, $loggedin_id, $loggedin_username, $isadmin, $admin],
                    [qw(username email password repeat given family display_name
                    mobile phone unit street city_suburb postcode region country postal_unit postal_street
                    postal_city_suburb postal_postcode postal_region postal_country postal_same loggedin
                    loggedin_id loggedin_username isadmin admin)]));

        $unit                = encode_entities($unit)               if defined $unit;
        $street              = encode_entities($street)             if defined $street;
        $city_suburb         = encode_entities($city_suburb)        if defined $city_suburb;
        $country             = encode_entities($country)            if defined $country;
        $given               = encode_entities($given)              if defined $given;
        $family              = encode_entities($family)             if defined $family;
        $display_name        = encode_entities($display_name)       if defined $display_name;
        $postal_unit         = encode_entities($postal_unit)        if defined $postal_unit;
        $postal_street       = encode_entities($postal_street)      if defined $postal_street;
        $postal_city_suburb  = encode_entities($postal_city_suburb) if defined $postal_city_suburb;
        $postal_country      = encode_entities($postal_country)     if defined $postal_country;

        if($submit eq 'Save Changes'){
            my $cond = defined $postal_street && defined $postal_country
                        && (!$postal_city_suburb || $postal_city_suburb =~ m/^[^\'\"]+$/)
                        && (!$postal_unit || $postal_unit =~ m/^[^\'\"]+$/) && $postal_street =~ m/^[^;\'\"]+$/
                        && $postal_city_suburb =~ m/^[^\'\"]+$/ && (!$postal_postcode || $postal_postcode =~ m/^[A-Z0-9 -]+$/)
                        && (!$postal_region || $postal_region =~ m/^[^\'\"]+$/) && $postal_country =~ m/^[^\'\"]+$/;

            my $line = __LINE__;
            $self->log(Data::Dumper->Dump([$cond, $postal_same, $line], [qw(cond postal_same line)]));
            my $_mobile_pattern = '(?:\+61|0)?\d{3}[ -]?\d{3}[ -]?\d{3}';
            my $_landline_pattern = '(?:(?:\+61[ -]?\d|0\d|\(0\d\)|0\d)[ -]?)?\d{4}[ -]?\d{4}';
            if(defined $countries_id){
                my @msgs;
                my $return = 1;
                my $_sql  = "SELECT landline_pattern, mobile_pattern FROM countries c\n";
                $_sql    .= "WHERE c.id = ?\n";
                my $_query  = $db->prepare($_sql);
                my $_result;
                eval {
                    $_result = $_query->execute($countries_id);
                };
                if($@){
                    push @msgs, "SELECT FROM countries failed: $@";
                    $return = 0;
                }
                my $line = __LINE__;
                $self->log(Data::Dumper->Dump([$return, $_sql, $_query, $_result, $line], [qw(return sql query result line)]));
                if($_result){
                    my $_r      = $_query->fetchrow_hashref();
                    $_mobile_pattern = $_r->{mobile_pattern};
                    $_landline_pattern = $_r->{landline_pattern};
                }else{
                    push @msgs, "SELECT FROM countries failed: $_sql";
                    $return = 0;
                }
                $_query->finish();
                $self->message($cfg, $debug, \%session, $db, undef, undef, 1, @msgs) if @msgs;
            }

            if($password && $repeat
                && ($password !~ m/^(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[^a-zA-Z0-9]).{10,100}$/
                        || $repeat !~ m/^(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[[:punct:]]).{10,100}$/)){
                my $line = __LINE__;
                $self->log(Data::Dumper->Dump([$given, $family, $display_name, $line], [qw(given family display_name line)]));
                my @msgs = ('password and/or repeat password did not match requirements 10 to 100 chars a at least 1 lowercase and at least 1 uppercase character, a digit 0-9 and a puctuation character!');
                $self->message($cfg, $debug, \%session, $db, 'register', undef, undef, 1, @msgs);
            }elsif(defined $username && defined $email && defined $street && defined $country
                && $username =~ m/^\w+$/ && $email =~ m/^(?:\w|-|\.|\+|\%)+\@[a-z0-9-]+(?:\.[a-z0-9-]+)+$/
                && (!$city_suburb || $city_suburb =~ m/^[^\'\"]+$/) 
                && (!$mobile || $mobile =~ m/^$_mobile_pattern$/) 
                && (!$phone || $phone =~ m/^$_landline_pattern$/)
                && (!$unit || $unit =~ m/^[^\'\"]+$/) && $street =~ m/^[^\'\"]+$/
                && (!$postcode || $postcode =~ m/^[A-Z0-9 -]+$/)
                && (!$region || $region =~ m/^[^\;\'\"]+$/) && $country =~ m/^[^\;\'\"]+$/
                && (!$password || $password =~ m/^(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[[:punct:]]).{10,100}$/)
                && (!$repeat || $repeat =~ m/^(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[[:punct:]]).{10,100}$/ )
                && ($postal_same?1:$cond)){
                $self->log(Data::Dumper->Dump([$given, $family, $display_name], [qw(given family display_name)]));
                $given = '' unless defined $given;
                $family = '' unless defined $family;
                $display_name = "$given $family" unless $display_name;
                $self->log(Data::Dumper->Dump([$given, $family, $display_name], [qw(given family display_name)]));
                my @msgs;
                my $return = 1;
                if($submit eq 'Save Changes'){
                    my $hashed_password;
                    if($password && $repeat && $password eq $repeat){
                        $hashed_password = $self->generate_hash($password);
                    }else{
                        push @msgs, "password and repeat password did nnot match ignoring";
                    }
                    my $line = __LINE__;
                    $self->log(Data::Dumper->Dump([$password, $hashed_password, $line], [qw(password hashed_password line)]));
                    if(!$hashed_password || $self->validate($hashed_password, $password)){
                        my $line = __LINE__;
                        $self->log(Data::Dumper->Dump([$password, $hashed_password, $line], [qw(password hashed_password line)]));
                        my $sql    = "UPDATE _group SET _name = ? WHERE id = ? RETURNING id;\n";
                        my $query  = $db->prepare($sql);
                        my $result;
                        if($group_id == 1){
                            $result = 1; # dont't change the group (group_id == 1) i.e. Admin #
                            $username = 'admin';
                        }else{
                            eval {
                                $result = $query->execute($username, $group_id);
                            };
                            if($@){
                                push @msgs, "UPDATE _group failed: $@";
                                $return = 0;
                            }
                        }
                        $line = __LINE__;
                        $self->log(Data::Dumper->Dump([$return, $sql, $query, $result, $username, $line], [qw(return sql query result username line)]));
                        if($result){
                            my ($r,  $primary_group_id);
                            unless($group_id == 1){
                                push @msgs, "Succeded in  UPDATING _group";
                                $r      = $query->fetchrow_hashref();
                                $primary_group_id = $r->{id};
                            }else{
                                $primary_group_id = 1;
                            }
                            $line = __LINE__;
                            $self->log(Data::Dumper->Dump([$return, $sql, $query, $result, $primary_group_id, $line], [qw(return sql query result primary_group_id line)]));
                            $query->finish();
                            my ($new_residential_address_id, $return_res, @msgs_res_address) = $self->update_address($unit, $street, $city_suburb, $postcode, $region, $country, undef, $residential_address_id, $db);
                            $return = $return_res unless $return_res;
                            push @msgs, @msgs_res_address;
                            my $new_postal_address_id;
                            if($postal_same){
                                if($residential_address_id != $postal_address_id){
                                    my ($return_post_address, @msgs_post_address) = $self->delete_address($postal_address_id, \%session, $db);
                                    $return = 0 unless $return_post_address;
                                    push @msgs, @msgs_post_address;
                                    $postal_address_id = $residential_address_id;
                                }
                            }else{
                                if($residential_address_id != $postal_address_id){
                                    ($new_postal_address_id, $return_res, @msgs_res_address) = $self->update_address($postal_unit, $postal_street, $postal_city_suburb, $postal_postcode, $postal_region, $postal_country, $new_residential_address_id, $postal_address_id, $db);
                                    $return = $return_res unless $return_res;
                                    push @msgs, @msgs_res_address;
                                }else{
                                    ($postal_address_id, $return_res, @msgs_res_address) = $self->create_address($postal_unit, $postal_street, $postal_city_suburb, $postal_postcode, $postal_region, $postal_country, $residential_address_id, $db);
                                    $return = $return_res unless $return_res;
                                    push @msgs, @msgs_res_address;
                                }
                            }
                            $line = __LINE__;
                            $self->log(Data::Dumper->Dump([$mobile, $phone, $line], [qw(mobile phone line)]));
                            my ($return_phone, @msgs_phone);
                            my ($_escape, $mobile_pattern, $landline_pattern, $return_phonedetails, @msgs_phonedetails) = $self->getphonedetails($countries_id, $cc, $prefix, $db);
                            $return = 0 unless $return_phonedetails;
                            push @msgs, @msgs_phonedetails;
                            if($mobile){
                                eval {
                                    $mobile = $self->normalise_mobile($mobile, $cc, $prefix, $_escape, $mobile_pattern, \%session, $db);
                                };
                                if($@){
                                    $return = 0;
                                    push @msgs, $@;
                                }
                                if($primary_phone_id){
                                    ($return_phone, @msgs_phone) = $self->update_phone($primary_phone_id, $mobile, $db);
                                    $return = $return_phone unless $return_phone;
                                    push @msgs, @msgs_phone;
                                }else{
                                    ($primary_phone_id, $return_phone, @msgs_phone) = $self->create_phone($mobile, $db);
                                    $return = $return_phone unless $return_phone;
                                    push @msgs, @msgs_phone;
                                }
                            }
                            if($phone){
                                eval {
                                    $phone = $self->normalise_landline($phone, $cc, $prefix, $_escape, $landline_pattern, \%session, $db);
                                };
                                if($@){
                                    $return = 0;
                                    push @msgs, $@;
                                }
                                if($secondary_phone_id){
                                    ($return_phone, @msgs_phone) = $self->update_phone($secondary_phone_id, $phone, $db);
                                    $return = $return_phone unless $return_phone;
                                    push @msgs, @msgs_phone;
                                }else{
                                    ($secondary_phone_id, $return_phone, @msgs_phone) = $self->create_phone($phone, $db);
                                    $return = $return_phone unless $return_phone;
                                    push @msgs, @msgs_phone;
                                }
                            }
                            my ($return_email, @msgs_email);
                            ($return_email, @msgs_email) = $self->update_email($email_id, $email, $db);
                            $return = $return_email unless $return_email;
                            push @msgs, @msgs_email;
                            if($return){
                                my ($return_details, @_msgs) = $self->update_passwd_details($display_name, $given, $family, $residential_address_id, $postal_address_id, $primary_phone_id, $secondary_phone_id, $countries_id, $passwd_details_id, $db);
                                $return = $return_details unless $return_details;
                                push @msgs, @_msgs;
                                if($return){
                                    my ($passwd_id, $return_passwd, @msgs_passwd);
                                    $passwd_id = $user_id;
                                    eval {
                                        ($return_passwd, @msgs_passwd)  = $self->update_passwd($username, $hashed_password, $email_id, $passwd_details_id, $primary_group_id, $admin, $passwd_id, $db);
                                        $return = $return_passwd unless $return_passwd;
                                        push @msgs, @msgs_passwd;
                                        for my $group_id (@group_id_add){
                                            $sql  = "INSERT INTO groups(group_id, passwd_id)\n";
                                            $sql .= "VALUES(?, ?)\n";
                                            $sql .= "ON CONFLICT DO NOTHING\n";
                                            $sql .= "RETURNING id;\n";
                                            $query  = $db->prepare($sql);
                                            eval {
                                                $result = $query->execute($group_id, $passwd_id);
                                            };
                                            if($@){
                                                push @msgs, "INSERT INTO groups failed: $@";
                                                $return = 0;
                                            }
                                            if($result){
                                                $r      = $query->fetchrow_hashref();
                                                my $groups_id = $r->{id};
                                            }else{
                                                push @msgs, "INSERT INTO groups failed: $sql";
                                                $return = 0;
                                            }
                                            $query->finish();
                                        }
                                        for my $group_id (@group_id_delete){
                                            $sql  = "DELETE FROM groups\n";
                                            $sql .= "WHERE group_id = ? AND passwd_id = ?\n";
                                            $sql .= "RETURNING id;\n";
                                            $query  = $db->prepare($sql);
                                            eval {
                                                $result = $query->execute($group_id, $passwd_id);
                                            };
                                            if($@){
                                                push @msgs, "DELETE FROM groups failed: $@";
                                                $return = 0;
                                            }
                                            if($result){
                                                $r      = $query->fetchrow_hashref();
                                                my $groups_id = $r->{id};
                                            }else{
                                                push @msgs, "DELETE FROM groups failed: $sql";
                                                $return = 0;
                                            }
                                            $query->finish();
                                        }
                                    };
                                    if($@){
                                        $return = 0;
                                        push @msgs, "Error: falied to DELETE user: $@";
                                    }
                                }
                            }else{
                                push @msgs, "one of the dependencies failed.", "see above.";
                            }
                        }else{
                            $query->finish();
                            $return = 0;
                            push @msgs, "Failed to insert primary _group.";
                        }
                    }else{
                        my $line = __LINE__;
                        $self->log(Data::Dumper->Dump([$password, $hashed_password, $line], [qw(password hashed_password line)]));
                        $return = 0;
                        push @msgs, "Error: could not validate hashed password.", "hashed_password == \`$hashed_password'";
                    }
                    $self->message($cfg, $debug, \%session, $db, ($return?'user':'user_details'), ($return ? 'back to users' : undef), !$return, @msgs);
                    return $return if $return;
                }
            }else{
                my $line = __LINE__;
                $self->log(Data::Dumper->Dump([$given, $family, $display_name, $line], [qw(given family display_name line)]));
            }
        }

        $username           = '' unless defined $username;
        $email              = '' unless defined $email;
        $password           = '' unless defined $password;
        $repeat             = '' unless defined $repeat;
        $mobile             = '' unless defined $mobile;
        $phone              = '' unless defined $phone;
        $unit               = '' unless defined $unit;
        $street             = '' unless defined $street;
        $city_suburb        = '' unless defined $city_suburb;
        $postcode           = '' unless defined $postcode;
        $region             = '' unless defined $region;
        $country            = '' unless defined $country;
        $postal_same        = 1  unless defined $postal_same;
        $postal_unit        = '' unless defined $postal_unit;
        $postal_street      = '' unless defined $postal_street;
        $postal_city_suburb = '' unless defined $postal_city_suburb;
        $postal_postcode    = '' unless defined $postal_postcode;
        $postal_region      = '' unless defined $postal_region;
        $postal_country     = '' unless defined $postal_country;
        $given              = '' unless defined $given;
        $family             = '' unless defined $family;
        $display_name       = '' unless defined $display_name;
        my $group_ids_joinned = "$group_id";
        my $sep               = ', ';
        my $line = __LINE__;
        $self->log(Data::Dumper->Dump([$group_ids_joinned, $sep, $line], [qw(group_ids_joinned sep line)]));
        for my $row (@additional_groups){
            my $_group_id = $row->{_group_id};
            $group_ids_joinned .= $sep . $_group_id;
            $sep = ', ';
        }
        $line = __LINE__;
        $self->log(Data::Dumper->Dump([$group_ids_joinned, $sep, $line], [qw(group_ids_joinned sep line)]));
        my @groups;
        my ($return, @msgs);
        $return = 1;
        my $sql  = "SELECT g.id, g._name FROM _group g\n";
        $sql    .= "WHERE g.id NOT IN ($group_ids_joinned);\n" if $group_ids_joinned;
        $line = __LINE__;
        $self->log(Data::Dumper->Dump([$group_ids_joinned, $sep, $sql, $line], [qw(group_ids_joinned sep sql line)]));
        my $query  = $db->prepare($sql);
        my $result;
        eval {
            $result = $query->execute();
        };
        if($@){
            push @msgs, "SELECT FROM _group failed: $@", "\$sql == $sql";
            $return = 0;
        }
        unless($result){
            push @msgs, "SELECT FROM _group failed: \$sql == $sql";
            return $return;
        }
        my $r      = $query->fetchrow_hashref();
        while($r){
            push @groups, $r;
            $r      = $query->fetchrow_hashref();
        }
        $query->finish();

        my @countries;

        $sql  = "SELECT\n";
        $sql .= "c.id, c.cc, c.prefix, c._name, _flag, c._escape, c.landline_pattern, c.mobile_pattern,\n";
        $sql .= "c.landline_title, c.mobile_title, c.landline_placeholder, c.mobile_placeholder\n";
        $sql .= "FROM countries c\n";
        $sql .= "ORDER BY c._name, c.cc\n";
        $query  = $db->prepare($sql);
        eval {
            $result = $query->execute();
        };
        if($@){
            push @msgs, "SELECT FROM countries failed: $@", "\$sql == $sql";
            $return = 0;
        }
        unless($result){
            push @msgs, "SELECT FROM countries failed: \$sql == $sql";
            return $return;
        }
        $r      = $query->fetchrow_hashref();
        while($r){
            push @countries, $r;
            $r      = $query->fetchrow_hashref();
        }
        $query->finish();
        unless($return){
            $self->message($cfg, $debug, \%session, $db, ($return?'user':'user_details'), ($return ? 'dummy' : undef), !$return, @msgs);
        }

        untie %session;
        $db->disconnect;

        my $title   = "only a-z, A-Z, 0-9 and _  allowed";
        my $pattern = '[a-zA-Z0-9_]+';
        say "        <form action=\"user-details.pl\" method=\"post\">";
        say "            <h1>Edit Account: $username</h1>";
        say "            <table>";
        say "                <tr>";
        say "                    <td>";
        say "                        <label for=\"username\">Username</label>";
        say "                    </td>";
        say "                    <td colspan=\"2\">";
        say "                        <input type=\"hidden\" name=\"old_username\" value=\"$username\"/>";
        say "                        <input type=\"hidden\" name=\"user_id\" value=\"$user_id\"/>";
        say "                        <input type=\"hidden\" name=\"group_id\" value=\"$group_id\"/>";
        say "                        <input type=\"hidden\" name=\"email_id\" value=\"$email_id\"/>";
        say "                        <input type=\"hidden\" name=\"residential_address_id\" value=\"$residential_address_id\"/>";
        say "                        <input type=\"hidden\" name=\"postal_address_id\" value=\"$postal_address_id\"/>";
        say "                        <input type=\"hidden\" name=\"primary_group_id\" value=\"$primary_group_id\"/>";
        say "                        <input type=\"hidden\" name=\"primary_phone_id\" value=\"$primary_phone_id\"/>" if $primary_phone_id;
        say "                        <input type=\"hidden\" name=\"passwd_details_id\" value=\"$passwd_details_id\"/>"; 
        say "                        <input type=\"hidden\" name=\"secondary_phone_id\" value=\"$secondary_phone_id\"/>" if $secondary_phone_id;
        if($user_id == 1){
            say "                        <input type=\"text\" name=\"username\" id=\"username\" placeholder=\"username\" pattern=\"$pattern\" title=\"$title\" value=\"$username\" readonly/>";
        }else{
            say "                        <input type=\"text\" name=\"username\" id=\"username\" placeholder=\"username\" pattern=\"$pattern\" title=\"$title\" value=\"$username\" autofocus required/>";
        }
        say "                    </td>";
        say "                </tr>";
        $title   = "only a-z 0-9 '.', '+', '-', and '_' followed by \@ a-z, 0-9 '.' and '-' allowed (no uppercase)";
        $pattern = '[a-z0-9.+%_-]+@[a-z0-9-]+(?:\.[a-z0-9-]+)+';
        say "                <tr>";
        say "                    <td>";
        say "                        <label for=\"email\">email</label>";
        say "                    </td>";
        say "                    <td colspan=\"3\">";
        if($user_id == 1){
            say "                        <input type=\"email\" name=\"email\" id=\"email\" placeholder=\"fred\@flintstone.com\" pattern=\"$pattern\" title=\"$title\" value=\"$email\" autofocus required/>";
        }else{
            say "                        <input type=\"email\" name=\"email\" id=\"email\" placeholder=\"fred\@flintstone.com\" pattern=\"$pattern\" title=\"$title\" value=\"$email\" required/>";
        }
        say "                    </td>";
        say "                </tr>";
        $title   = "Must supply between 10 and 100 character's the more the better.\nAlso must include a least one lowercase one uppercase a digit and a puntuation character.";
        $pattern = '(?:(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[^a-zA-Z0-9]).{10,100})?';
        say "                <script>";
        say "                    function togglepasswd(){";
        say "                        var pws = document.getElementsByClassName(\"passwd\");";
        say "                        var chk = document.getElementById(\"chkpasswd\");";
        say "                        for(let pw of pws){";
        say "                            if(chk.checked){;";
        say "                                pw.type = \"text\";";
        say "                            }else{";
        say "                                pw.type = \"password\";";
        say "                            }";
        say "                        }";
        say "                    }";
        say "                </script>";
        say "                <tr>";
        say "                    <td>";
        say "                        <label for=\"password\">password</label>";
        say "                    </td>";
        say "                    <td colspan=\"3\">";
        say "                        <input type=\"password\" name=\"password\" id=\"password\" class=\"passwd\" placeholder=\"password\" minlength=\"10\" pattern=\"$pattern\" title=\"$title\" value=\"$password\" />";
        say "                    </td>";
        say "                </tr>";
        say "                <tr>";
        say "                    <td>";
        say "                        <label for=\"repeat\">Repeat Password</label>";
        say "                    </td>";
        say "                    <td colspan=\"3\">";
        say "                        <input type=\"password\" name=\"repeat\" id=\"repeat\" class=\"passwd\" placeholder=\"repeat password\" minlength=\"10\" pattern=\"$pattern\" title=\"$title\" value=\"$repeat\"  />";
        say "                    </td>";
        say "                </tr>";
        say "                <tr>";
        say "                    <td>";
        say "                        <label for=\"chkpasswd\">Show Password</label>";
        say "                    </td>";
        say "                    <td colspan=\"2\">";
        say "                        <input type=\"checkbox\" id=\"chkpasswd\" onclick=\"togglepasswd()\"  />";
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
        say "                <tr>";
        say "                    <td>";
        say "                        <label for=\"cc_and_prefix\">CC and Prefix:</label>";
        say "                    </td>";
        say "                    <td colspan=\"3\">";
        say "                        <input type=\"hidden\" name=\"cc\" id=\"cc\" value=\"$cc\"/>";
        say "                        <input type=\"hidden\" name=\"prefix\" id=\"prefix\" value=\"$prefix\"/>";

        my $mobile_title;
        my $mobile_pattern;
        my $mobile_placeholder;
        my $landline_title;
        my $landline_pattern;
        my $landline_placeholder;
        my $flag;
        say "                        <select name=\"countries_id\" id=\"countries_id\" onchange=\"countries_onchange()\" is=\"ms-dropdown\">";
        for my $row (@countries){
            my $cc_id   = $row->{id};
            my $name    = $row->{_name};
            my $_cc     = $row->{cc};
            my $_flag   = $row->{_flag};
            my $_prefix = $row->{prefix};
            #$name       =~ s/\s/&nbsp;/g;
            if($cc_id == $countries_id){
                $flag   = $_flag;
                say "                                <option value=\"$cc_id\" data-image=\"$_flag\" selected=\"selected\">$name: $_cc ($_prefix)</option>";
            }else{
                say "                                <option value=\"$cc_id\" data-image=\"$_flag\">$name: $_cc ($_prefix)</option>";
            }
        }
        say "                        </select>";

        say "                        <script>";
        say "                            function countries_onchange() {";
        say "                                var countries = {";
        for my $row (@countries){
            my $cc_id            = $row->{id};
            my $_cc              = $row->{cc};
            my $name             = $row->{_name};
            my $_flag            = $row->{_flag};
            my $_prefix          = $row->{prefix};
            my $_escape          = $row->{_escape};
            my $lndl_pattern     = $row->{landline_pattern};
            my $mob_pattern      = $row->{mobile_pattern};
            my $lndl_title       = $row->{landline_title};
            my $mob_title        = $row->{mobile_title};
            my $lndl_placeholder = $row->{landline_placeholder};
            my $mob_placeholder  = $row->{mobile_placeholder};
            $_escape = '' unless defined $_escape;
            if($countries_id == $cc_id){
                $mobile_title         = $mob_title;
                $mobile_pattern       = $mob_pattern;
                $mobile_placeholder   = $mob_placeholder;
                $landline_title       = $lndl_title;
                $landline_pattern     = $lndl_pattern;
                $landline_placeholder = $lndl_placeholder;
            }
            $lndl_pattern             =~ s/\\/\\\\/g;
            $mob_pattern              =~ s/\\/\\\\/g;
            say "                                            \"$cc_id\": { \"_name\": \"$name\",";
            say "                                                          \"cc\": \"$_cc\",";
            say "                                                          \"prefix\": \"$_prefix\",";
            say "                                                          \"_flag\": \"$_flag\",";
            say "                                                          \"_escape\": \"$_escape\",";
            say "                                                          \"landline_pattern\": \"$lndl_pattern\",";
            say "                                                          \"mobile_pattern\": \"$mob_pattern\",";
            say "                                                          \"landline_title\": \"$lndl_title\",";
            say "                                                          \"mobile_title\": \"$mob_title\",";
            say "                                                          \"landline_placeholder\": \"$lndl_placeholder\",";
            say "                                                          \"mobile_placeholder\": \"$mob_placeholder\" },";
        }
        say "                                    };";
        say "                                var cc_id_elt = document.getElementById('countries_id');";
        say "                                var countries_id = cc_id_elt.value;";
        #say "                                alert(\"countries_id == \" + countries_id);";
        say "                                ";
        say "                                if(countries_id == 0) return; // should never happen //"; 
        say "                                // values to match countries_id //";
        say "                                var cc                     = countries[countries_id]['cc'];";
        say "                                var prefix                 = countries[countries_id]['prefix'];";
        say "                                var name                   = countries[countries_id]['_name'];";
        say "                                var _escape                = countries[countries_id]['_escape'];";
        say "                                var _flag                  = countries[countries_id]['_flag'];";
        say "                                var landline_pattern       = countries[countries_id]['landline_pattern'];";
        say "                                var mobile_pattern         = countries[countries_id]['mobile_pattern'];";
        say "                                var landline_title         = countries[countries_id]['landline_title'];";
        say "                                var mobile_title           = countries[countries_id]['mobile_title'];";
        say "                                var landline_placeholder   = countries[countries_id]['landline_placeholder'];";
        say "                                var mobile_placeholder     = countries[countries_id]['mobile_placeholder'];";
        say "                                // The objects to change //";
        say "                                var hdn_cc                 = document.getElementById(\"cc\");";
        say "                                hdn_cc.value               = cc;";
        say "                                var hdn_prefix             = document.getElementById(\"prefix\");";
        say "                                hdn_prefix.value           = prefix;";
        say "                                var input_mobile           = document.getElementById(\"mobile\");";
        say "                                input_mobile.placeholder   = mobile_placeholder;";
        #say "                                alert(\"mobile_pattern == \" + mobile_pattern);";
        say "                                input_mobile.setAttribute('pattern', mobile_pattern);";
        say "                                input_mobile.title         = mobile_title;";
        say "                                var input_phone            = document.getElementById(\"phone\");";
        say "                                input_phone.placeholder    = landline_placeholder;";
        #say "                                input_phone.pattern        = landline_pattern;";
        #say "                                alert(\"landline_pattern == \" + landline_pattern);";
        say "                                input_phone.setAttribute('pattern', landline_pattern);";
        say "                                input_phone.title          = landline_title;";
        say "                                var input_country          = document.getElementById(\"country\");";
        say "                                input_country.value        = name;";
        say "                                var input_postal_country   = document.getElementById(\"postal_country\");";
        say "                                input_postal_country.value = name;";
        #say "                                var img                    = document.getElementById(\"flag\");";
        #say "                                img.setAttribute(\"src\", _flag);";
        #say "                                img.setAttribute(\"alt\", _flag);";
        #say "                                img.src                    = _flag;";
        #say "                                img.alt                    = _flag;";
        #say "                                alert(\"_flag == \" + _flag);";
        say "                            }";
        say "                            ";
        say "                            ";
        say "                        </script>";
        say "                        <script src=\"https://cdn.jsdelivr.net/npm/ms-dropdown\@4.0.3/dist/js/dd.min.js\"></script>";
        say "                    </td>";
        say "                </tr>";
        $title   = $mobile_title;
        $pattern = $mobile_pattern;
        my $placeholder = $mobile_placeholder;
        say "                <tr>";
        say "                    <td>";
        say "                        <label for=\"mobile\">mobile</label>";
        say "                    </td>";
        say "                    <td colspan=\"2\">";
        say "                        <input type=\"tel\" name=\"mobile\" id=\"mobile\" placeholder=\"$placeholder\" pattern=\"$pattern\" title=\"$title\" value=\"$mobile\"/>";
        say "                    </td>";
        say "                </tr>";
        $title   = $landline_title;
        $pattern = $landline_pattern;
        $placeholder = $landline_placeholder;
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
        say "                        <label for=\"city_suburb\">City/Suberb</label>";
        say "                    </td>";
        say "                    <td colspan=\"2\">";
        say "                        <input type=\"text\" name=\"city_suburb\" id=\"city_suburb\" placeholder=\"city/suberb\" pattern=\"$pattern\" title=\"$title\" value=\"$city_suburb\" required/>";
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
        say "                        <label for=\"postal_city_suburb\">City/Suberb</label>";
        say "                    </td>";
        say "                    <td colspan=\"2\">";
        say "                        <input type=\"text\" name=\"postal_city_suburb\" id=\"postal_city_suburb\" placeholder=\"city/suberb\" pattern=\"$pattern\" title=\"$title\" value=\"$postal_city_suburb\" class=\"require\" $required/>";
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
        say "                <tr class=\"admin\">";
        say "                    <td colspan=\"3\">";
        say "                        <script>";
        my $size = @additional_groups;
        say "                            let cnt = $size;";
        say "                            let lower_limit = $size;";
        say "                            function groupOnclick(n){";
        say "                                var btn   = document.getElementById(\"btn[\" + n + ']');";
        say "                                var cross = document.getElementById(\"cross[\" + n + ']');";
        say "                                var hdd   = document.getElementById(\"hdd[\" + n + ']');";
        say "                                var td    = document.getElementById(\"td[\" + n + ']');";
        say "                                var val   = hdd.value;";
        say "                                var name  = btn.value;";
        say "                                //alert(\"val == \" + val + \"\\nname == \" + name);";
        say "                                td.remove();";
        say "                                if(n < lower_limit){";
        say "                                    var base = document.getElementById(\"base\");";
        say "                                    var deleter = document.createElement(\"INPUT\");";
        say "                                    deleter.setAttribute(\"type\", \"hidden\");";
        say "                                    deleter.setAttribute(\"value\", \"\" + val);";
        say "                                    deleter.name = \"group_id_delete[\" + val + ']';";
        say "                                    deleter.id   = \"hdd[\" + n + ']';";
        say "                                    base.appendChild(deleter);";
        say "                                }else{";
        say "                                    var groupSelect = document.getElementById(\"groupSelect\");";
        say "                                    var opt = document.createElement(\"OPTION\");";
        say "                                    opt.setAttribute(\"value\", \"\" + val);";
        say "                                    opt.setAttribute(\"id\", \"row_id[\" + val + \"]\");";
        say "                                    opt.innerHTML = name;";
        say "                                    groupSelect.appendChild(opt);";
        say "                                }";
        say "                            }";
        say "                            function group_selected() {";
        say "                                var groupSelect = document.getElementById(\"groupSelect\");";
        say "                                var val = groupSelect.value;";
        say "                                if(val == 0) return";
        say "                                var opt = document.getElementById(\"row_id[\" + val + \"]\");";
        say "                                var name = opt.innerHTML;";
        say "                                opt.remove();";
        say "                                var btn = document.createElement(\"INPUT\");";
        say "                                btn.setAttribute(\"type\", \"button\");";
        say "                                btn.setAttribute(\"value\", name);";
        say "                                btn.name = \"btn[\" + cnt + ']';";
        say "                                btn.id   = \"btn[\" + cnt + ']';";
        say "                                var cross = document.createElement(\"button\");";
        say "                                cross.setAttribute(\"type\", \"button\");";
        say "                                cross.setAttribute(\"value\", \"\" + cnt);";
        say "                                cross.setAttribute(\"class\", \"inner\");";
        #say "                                cross.setAttribute(\"src\", \"img_submit.gif\");";
        say "                                cross.setAttribute(\"onclick\", \"groupOnclick(\" + cnt + ')');";
        say "                                cross.innerHTML = \"&otimes;\";";
        say "                                cross.name = \"cross[\" + cnt + ']';";
        say "                                cross.id   = \"cross[\" + cnt + ']';";
        say "                                var hdn = document.createElement(\"INPUT\");";
        say "                                hdn.setAttribute(\"type\", \"hidden\");";
        say "                                hdn.setAttribute(\"value\", \"\" + val);";
        say "                                hdn.name = \"group_id_add[\" + val + ']';";
        say "                                hdn.id   = \"hdd[\" + cnt + ']';";
        say "                                var row = document.getElementById(\"row\");";
        say "                                var elt = document.createElement(\"TD\");";
        say "                                elt.setAttribute(\"id\", \"td[\" + cnt + ']');";
        say "                                elt.setAttribute(\"class\", \"elts\");";
        say "                                elt.appendChild(btn);";
        say "                                elt.appendChild(cross);";
        say "                                elt.appendChild(hdn);";
        say "                                row.appendChild(elt);";
        say "                                cnt++;";
        say "                            }";
        say "                        </script>";
        say "                        <table class=\"outter\">";
        say "                           <tr class=\"outter\">";
        say "                              <td class=\"outter\">";
        say "                                  <table id=\"tbl\" class=\"elts inner\">";
        say "                                      <tr id=\"row\" class=\"elts\">";
        say "                                          <td class=\"elts inner\" id=\"base\">";
        say "                                               Groups:";
        say "                                          </td>";
        my $cnt = 0;
        for my $row (@additional_groups){
            my $group_name = $row->{group_name};
            my $_group_id  = $row->{_group_id};
            say "                                          <td class=\"elts\" id=\"td[$cnt]\">";
            say "                                              <input type=\"button\" id=\"btn[$cnt]\" name=\"btn[$cnt]\" value=\"$group_name\">";
            say "                                              <input type=\"hidden\" id=\"hdd[$cnt]\" name=\"group_id_add[$_group_id]\" value=\"$_group_id\">";
            say "                                              <button type=\"button\" id=\"cross[$cnt]\" name=\"cross[$cnt]\" class=\"inner\" onclick=\"groupOnclick($cnt)\" value=\"$cnt\">&otimes;</button>";
            say "                                          </td>";
            $cnt++;
        }
        say "                                      </tr>";
        say "                                  </table>";
        say "                              </td>";
        say "                           </tr>";
        say "                        </table>";
        say "                    </td>";
        say "                </tr>";
        say "                <tr>";
        say "                    <td>";
        say "                        <select id=\"groupSelect\" onchange=\"group_selected()\">";
        say "                            <option id=\"row_id[0]\" value=\"0\" selected>-- nothinng selected --</option>";
        for my $row (@groups){
            my $available_group_id = $row->{id};
            my $_name = $row->{_name};
            say "                            <option id=\"row_id[$available_group_id]\" value=\"$available_group_id\">$_name</option>";
        }
        say "                        </select>";
        say "                    </td>";
        say "                </tr>";
        my @buttons = ({tag => 'input', name => 'submit', type => 'submit', value => 'Save Changes', colspan => 2, }, );
        $self->bottom_buttons($debug, $dont_showdebug, undef, 16, @buttons);
        #say "                <tr>";
        #say "                    <td>";
        #if($debug){
        #    say "                        <label for=\"debug\"><div class=\"ex\"><input name=\"debug\" id=\"debug\" type=\"radio\" value=\"1\" checked> debug</div></label>";
        #    say "                    </td>";
        #    say "                    <td>";
        #    say "                        <label for=\"nodebug\"><div class=\"ex\"><input name=\"debug\" id=\"nodebug\" type=\"radio\" value=\"0\"> nodebug</div></label>";
        #}else{
        #    say "                        <label for=\"debug\"><div class=\"ex\"><input name=\"debug\" id=\"debug\" type=\"radio\" value=\"1\"> debug</div></label>";
        #    say "                    </td>";
        #    say "                    <td>";
        #    say "                        <label for=\"nodebug\"><div class=\"ex\"><input name=\"debug\" id=\"nodebug\" type=\"radio\" value=\"0\" checked> nodebug</div></label>";
        #}
        #say "                    </td>";
        #say "                    <td colspan=\"2\">";
        #say "                        <input name=\"submit\" type=\"submit\" value=\"Save Changes\">";
        #say "                    </td>";
        #say "                </tr>";
        say "            </table>";
        say "        </form>";

        return 1;
    } ## --- end sub user_details


    sub getgroup_id {
        my ($self, $group_name, $db) = @_;
        my ($_group_id, $return, @msgs);
        $return = 1;
        my $sql  = "SELECT g.id FROM _group g WHERE g._name = ?;\n";
        my $query           = $db->prepare($sql);
        my $result;
        eval {
            $result         = $query->execute($group_name);
        };
        if($@){
            push @msgs,  "Error: SELECT $group_name FROM _group failed: $@";
            $return = 0;
            $query->finish();
            next;
        }
        if($result){
            my $r          = $query->fetchrow_hashref();
            $_group_id     = $r->{id};
            push @msgs,  "SELECT FROM _group Succeeded:";
            $query->finish();
        }else{
            $return = 0;
            push @msgs,  "Error: SELECT $group_name FROM _group failed";
            $query->finish();
        }
        return ($_group_id, $return, @msgs);
    } ## --- end sub getgroup_id

    sub getgroup_name {
        my ($self, $_group_id, $db) = @_;
        my ($group_name, $return, @msgs);
        $return = 1;
        my $sql  = "SELECT g._name FROM _group g WHERE g.id = ?;\n";
        my $query           = $db->prepare($sql);
        my $result;
        eval {
            $result         = $query->execute($_group_id);
        };
        if($@){
            push @msgs,  "Error: SELECT $_group_id FROM _group failed: $@";
            $return = 0;
            $query->finish();
            next;
        }
        if($result){
            my $r          = $query->fetchrow_hashref();
            $group_name     = $r->{_name};
            push @msgs,  "SELECT FROM _group Succeeded:";
            $query->finish();
        }else{
            $return = 0;
            push @msgs,  "Error: SELECT $_group_id FROM _group failed: $sql";
            $query->finish();
        }
        return ($group_name, $return, @msgs);
    } ## --- end sub getgroup_name


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

        my $dont_showdebug  = !$cfg->val('general', 'showdebug');

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

        my $loggedin                  = $session{loggedin};
        my $loggedin_id               = $session{loggedin_id};
        my $loggedin_username         = $session{loggedin_username};
        my $loggedin_admin            = $session{loggedin_admin};
        my $loggedin_display_name     = $session{loggedin_display_name};
        my $loggedin_given            = $session{loggedin_given};
        my $loggedin_family           = $session{loggedin_family};
        my $loggedin_email            = $session{loggedin_email};
        my $loggedin_phone_number     = $session{loggedin_phone_number};
        my $loggedin_groupname        = $session{loggedin_groupname};
        my $loggedin_primary_group_id = $session{loggedin_groupnname_id};

        $self->log(Data::Dumper->Dump([\@params, \@delete_set], [qw(@params @delete_set)]));

        if(@delete_set && join(',', @delete_set) =~ m/^\d+(?:,\d+)*$/){
            my @msgs;
            my $return = 1;
            if($delete eq 'Delete Orphans'){
                for my $links_section_id (@delete_set){
                    my $sql  = "DELETE FROM links_sections\n";
                    $sql    .= "WHERE id = ? AND (? = 1 OR (userid = ? AND (_perms)._user._del = true)\n";
                    $sql    .= "        OR ((groupid = ? OR groupid IN (SELECT gs.group_id FROM groups gs WHERE gs.passwd_id = ?))\n";
                    $sql    .= "                AND (_perms)._group._del = true) OR (_perms)._other._del = true);\n";
                    my $query           = $db->prepare($sql);
                    my $result;
                    eval {
                        $result         = $query->execute($links_section_id, $loggedin_admin, $loggedin_id, $loggedin_primary_group_id, $loggedin_id);
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
            $self->message($cfg, $debug, \%session, $db, 'delete_orphaned_links_sections', 'Delete some more links_sections', undef, @msgs);

            untie %session;
            $db->disconnect;
            return $return;
        }

        my $sql  = "SELECT ls.id, ls.section FROM links_sections ls\n";
        $sql    .= "WHERE (SELECT COUNT(*) n FROM links l WHERE l.section_id = ls.id) = 0\n";
        $sql    .= "AND (? = 1 OR (ls.userid = ? AND (ls)._perms._user._read = true)\n";
        $sql    .= "     OR ((ls.groupid = ? OR ls.groupid IN (SELECT gs.group_id FROM groups gs WHERE gs.passwd_id = ?))\n";
        $sql    .= "          AND (ls)._perms._group._read = true) OR (ls)._perms._other._read = true)\n";
        $sql    .= "ORDER BY ls.section\n";
        my $query       = $db->prepare($sql);
        my $result;
        eval {
            $result     = $query->execute($loggedin_admin, $loggedin_id, $loggedin_primary_group_id, $loggedin_id);
        };
        if($@){
            $self->message($cfg, $debug, \%session, $db, 'delete_orphaned_links_sections', undef, undef, "Error: $@", "Cannnot Read links_sections");
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
        say "                        <label for=\"page_length\"><div class=\"ex\">Page Length:";
        say "                            <input type=\"number\" name=\"page_length\" id=\"page_length\" min=\"10\" max=\"180\" step=\"1\" value=\"$page_length\" size=\"3\"></div>";
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
                say "                        <label for=\"$links_section_id\"><div class=\"ex\">$section</div></label>";
                say "                    </td>";
                say "                    <td>";
                say "                        <div class=\"ex\"><input type=\"checkbox\" name=\"delete_set[$cnt]\" id=\"$links_section_id\" value=\"$links_section_id\"/></div>";
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
            say "                        <div class=\"ex\">No Orphans Found!!!</div>";
            say "                    </td>";
            say "                </tr>";
        }
        my @buttons = ({tag => 'input', name => 'delete', type => 'submit', value => 'Delete Orphans', }, );
        $self->bottom_buttons($debug, $dont_showdebug, undef, 16, @buttons);
        #say "                <tr>";
        #say "                    <td>";
        #if($debug){
        #    say "                        <label for=\"debug\"><div class=\"ex\"><input name=\"debug\" id=\"debug\" type=\"radio\" value=\"1\" checked> debug</div></label>";
        #    say "                    </td>";
        #    say "                    <td>";
        #    say "                        <label for=\"nodebug\"><div class=\"ex\"><input name=\"debug\" id=\"nodebug\" type=\"radio\" value=\"0\"> nodebug</div></label>";
        #}else{
        #    say "                        <label for=\"debug\"><div class=\"ex\"><input name=\"debug\" id=\"debug\" type=\"radio\" value=\"1\"> debug</div></label>";
        #    say "                    </td>";
        #    say "                    <td>";
        #    say "                        <label for=\"nodebug\"><div class=\"ex\"><input name=\"debug\" id=\"nodebug\" type=\"radio\" value=\"0\" checked> nodebug</div></label>";
        #}
        #say "                    </td>";
        #say "                    <td>";
        #say "                        <input name=\"delete\" type=\"submit\" value=\"Delete Orphans\">";
        #say "                    </td>";
        #say "                </tr>";
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

        my $dont_showdebug  = !$cfg->val('general', 'showdebug');

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
            $self->log(Data::Dumper->Dump([$result, $query, $return, \@msgs, $sql], [qw(result query return @msgs sql)]));
            if($result && $result != 0){
                my $r      = $query->fetchrow_hashref();
                my $line = __LINE__;
                $self->log(Data::Dumper->Dump([$line, $result, $r], [qw(line result r)]));
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
                    return $self->redirect($rec, 'index.pl');
                    #$rec->headers_out->set( Location => "index.pl" );
                    #$rec->status(Apache2::Const::REDIRECT);
                    #return 0;
                    #push @msgs, "Loggedin";
                }else{
                    push @msgs, "Username and Password combination failed!!! Perhaps you miss typed";
                    $return = 0;
                }
            }elsif($result == 0){
                push @msgs, "Username and Password combination failed!!! Perhaps you miss typed";
                $return = 0;
            }else{
                push @msgs, "SELECT FROM passwd failed: $sql";
                $return = 0;
            }
            $query->finish();

            $self->message($cfg, $debug, \%session, $db, ($return?'main':'login'), ($return ? 'continue' : undef), undef, @msgs);

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
        say "                <script>";
        say "                    function togglepasswd(){";
        say "                        var pws = document.getElementsByClassName(\"passwd\");";
        say "                        var chk = document.getElementById(\"chkpasswd\");";
        say "                        for(let pw of pws){";
        say "                            if(chk.checked){;";
        say "                                pw.type = \"text\";";
        say "                            }else{";
        say "                                pw.type = \"password\";";
        say "                            }";
        say "                        }";
        say "                    }";
        say "                </script>";
        say "                <tr>";
        say "                    <td>";
        say "                        <label for=\"password\">password </label>";
        say "                    </td>";
        say "                    <td colspan=\"2\">";
        say "                        <input type=\"password\" name=\"password\" id=\"password\" class=\"passwd\" placeholder=\"password\" minlength=\"10\" pattern=\"$pattern\" title=\"$title\" value=\"$password\" required/>";
        say "                    </td>";
        say "                </tr>";
        say "                <tr>";
        say "                    <td>";
        say "                        <label for=\"chkpasswd\">Show Password</label>";
        say "                    </td>";
        say "                    <td colspan=\"2\">";
        say "                        <input type=\"checkbox\" id=\"chkpasswd\" onclick=\"togglepasswd()\"  />";
        say "                    </td>";
        say "                </tr>";
        my @buttons = ({tag => 'input', name => 'submit', type => 'submit', value => 'Login', }, );
        $self->bottom_buttons($debug, $dont_showdebug, undef, 16, @buttons);
        #say "                <tr>";
        #say "                    <td>";
        #if($debug){
        #    say "                        <label for=\"debug\"><div class=\"ex\"><input name=\"debug\" id=\"debug\" type=\"radio\" value=\"1\" checked> debug</div></label>";
        #    say "                    </td>";
        #    say "                    <td>";
        #    say "                        <label for=\"nodebug\"><div class=\"ex\"><input name=\"debug\" id=\"nodebug\" type=\"radio\" value=\"0\"> nodebug</div></label>";
        #}else{
        #    say "                        <label for=\"debug\"><div class=\"ex\"><input name=\"debug\" id=\"debug\" type=\"radio\" value=\"1\"> debug</div></label>";
        #    say "                    </td>";
        #    say "                    <td>";
        #    say "                        <label for=\"nodebug\"><div class=\"ex\"><input name=\"debug\" id=\"nodebug\" type=\"radio\" value=\"0\" checked> nodebug</div></label>";
        #}
        #say "                    </td>";
        #say "                    <td>";
        #say "                        <input name=\"submit\" type=\"submit\" value=\"Login\">";
        #say "                    </td>";
        #say "                </tr>";
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

        my $dont_showdebug  = !$cfg->val('general', 'showdebug');

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
        my $from    = $req->param('from');

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

            say "        <h1>Logout</h1>";
        }


        untie %session;
        $db->disconnect;

        say "            <table>";
        say "                <tr>";
        say "                    <td colspan=\"3\">";
        say "                        <form action=\"$from\" method=\"post\">";
        say "                            <input type=\"submit\" name=\"submit\" id=\"cancel\" value=\"Cancel\"/>";
        say "                        </form>";
        say "                    </td>";
        say "                </tr>";
        my @buttons = ({tag => 'input', name => 'submit', type => 'submit', value => 'Logout', }, );
        $self->bottom_buttons($debug, $dont_showdebug, 'logout.pl', 16, @buttons);
        #say "                <tr>";
        #say "                    <td>";
        #if($debug){
        #    say "                        <label for=\"debug\"><div class=\"ex\"><input name=\"debug\" id=\"debug\" type=\"radio\" value=\"1\" checked> debug</div></label>";
        #    say "                    </td>";
        #    say "                    <td>";
        #    say "                        <label for=\"nodebug\"><div class=\"ex\"><input name=\"debug\" id=\"nodebug\" type=\"radio\" value=\"0\"> nodebug</div></label>";
        #}else{
        #    say "                        <label for=\"debug\"><div class=\"ex\"><input name=\"debug\" id=\"debug\" type=\"radio\" value=\"1\"> debug</div></label>";
        #    say "                    </td>";
        #    say "                    <td>";
        #    say "                        <label for=\"nodebug\"><div class=\"ex\"><input name=\"debug\" id=\"nodebug\" type=\"radio\" value=\"0\" checked> nodebug</div></label>";
        #}
        #say "                    </td>";
        #say "                    <td>";
        #say "                        <input name=\"submit\" type=\"submit\" value=\"Logout\">";
        #say "                    </td>";
        #say "                </tr>";
        say "            </table>";

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

        my $dont_showdebug  = !$cfg->val('general', 'showdebug');

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

        my $loggedin                  = $session{loggedin};
        my $loggedin_id               = $session{loggedin_id};
        my $loggedin_username         = $session{loggedin_username};
        my $loggedin_admin            = $session{loggedin_admin};
        my $loggedin_display_name     = $session{loggedin_display_name};
        my $loggedin_given            = $session{loggedin_given};
        my $loggedin_family           = $session{loggedin_family};
        my $loggedin_email            = $session{loggedin_email};
        my $loggedin_phone_number     = $session{loggedin_phone_number};
        my $loggedin_groupname        = $session{loggedin_groupname};
        my $loggedin_primary_group_id = $session{loggedin_groupnname_id};

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
        my $cc                 = $req->param('cc');
        my $prefix             = $req->param('prefix');
        my $countries_id       = $req->param('countries_id');
        my $postal_same        = $req->param('postal_same');
        my $postal_unit        = $req->param('postal_unit');
        my $postal_street      = $req->param('postal_street');
        my $postal_city_suburb = $req->param('postal_city_suburb');
        my $postal_postcode    = $req->param('postal_postcode');
        my $postal_region      = $req->param('postal_region');
        my $postal_country     = $req->param('postal_country');
        my $given              = $req->param('given');
        my $family             = $req->param('family');
        my $display_name       = $req->param('display_name');
        my $admin              = $req->param('admin');
        my @params             = $req->param;
        my @group_id_add;
        for (@params){
            if(m/^group_id_add\[(\d+)\]$/){
                push @group_id_add, $req->param($_);
            }
        }

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
            $self->message($cfg, $debug, \%session, $db, ($return?'main':'register'), ($return ? 'register' : undef), !$return && @msgs, @msgs) if @msgs;

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
                    $postal_street, $postal_city_suburb, $postal_postcode, $postal_region,
                    $postal_country, $postal_same, $loggedin, $loggedin_id, $loggedin_username, $isadmin, $admin],
                    [qw(username email password repeat given family display_name
                    mobile phone unit street city_suberb postcode region country postal_unit postal_street
                    postal_city_suburb postal_postcode postal_region postal_country postal_same loggedin
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
        $postal_city_suburb  = encode_entities($postal_city_suburb) if defined $postal_city_suburb;
        $postal_country      = encode_entities($postal_country)     if defined $postal_country;
        my $_mobile_pattern = '(?:\+61|0)?\d{3}[ -]?\d{3}[ -]?\d{3}';
        my $_landline_pattern = '(?:(?:\+61[ -]?\d|0\d|\(0\d\)|0\d)[ -]?)?\d{4}[ -]?\d{4}';
        if(defined $countries_id){
            my @msgs;
            my $return = 1;
            my $_sql  = "SELECT landline_pattern, mobile_pattern FROM countries c\n";
            $_sql    .= "WHERE c.id = ?\n";
            my $_query  = $db->prepare($_sql);
            my $_result;
            eval {
                $_result = $_query->execute($countries_id);
            };
            if($@){
                push @msgs, "SELECT FROM countries failed: $@";
                $return = 0;
            }
            my $line = __LINE__;
            $self->log(Data::Dumper->Dump([$return, $_sql, $_query, $_result, $line], [qw(return sql query result line)]));
            if($_result){
                my $_r      = $_query->fetchrow_hashref();
                $_mobile_pattern = $_r->{mobile_pattern};
                $_landline_pattern = $_r->{landline_pattern};
            }else{
                push @msgs, "SELECT FROM countries failed: $_sql";
                $return = 0;
            }
            $_query->finish();
            $self->message($cfg, $debug, \%session, $db, undef, undef, 1, @msgs) if @msgs;
        }

        my $cond = defined $postal_street && defined $postal_country
                    && (!$postal_city_suburb || $postal_city_suburb =~ m/^[^\'\"]+$/)
                    && (!$postal_unit || $postal_unit =~ m/^[^\'\"]+$/) && $postal_street =~ m/^[^;\'\"]+$/
                    && $postal_city_suburb =~ m/^[^\'\"]+$/ && (!$postal_postcode || $postal_postcode =~ m/^[A-Z0-9 -]+$/)
                    && (!$postal_region || $postal_region =~ m/^[^\'\"]+$/) && $postal_country =~ m/^[^\'\"]+$/;

        my $line = __LINE__;
        $self->log(Data::Dumper->Dump([$cond, $postal_same, $line], [qw(cond postal_same line)]));

        if($password && $repeat
            && ($password !~ m/^(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[^a-zA-Z0-9]).{10,100}$/
                    || $repeat !~ m/^(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[[:punct:]]).{10,100}$/)){
            my $line = __LINE__;
            $self->log(Data::Dumper->Dump([$given, $family, $display_name, $line], [qw(given family display_name line)]));
            my @msgs = ('password and/or repeat password did not match requirements 10 to 100 chars a at least 1 lowercase and at least 1 uppercase character, a digit 0-9 and a puctuation character!');
            $self->message($cfg, $debug, \%session, $db, 'register', undef, undef, 1, @msgs);
        }elsif(($password || $repeat) && $password ne $repeat){
            my $line = __LINE__;
            $self->log(Data::Dumper->Dump([$given, $family, $display_name, $line], [qw(given family display_name line)]));
            my @msgs = ('password and repeat password did not match!');
            $self->message($cfg, $debug, \%session, $db, 'register', undef, 1, @msgs);
        }elsif(defined $username && defined $email && $password && $repeat
            && defined $street && defined $country
            && $username =~ m/^\w+$/ && $email =~ m/^(?:\w|-|\.|\+|\%)+\@[a-z0-9-]+(?:\.[a-z0-9-]+)+$/
            && (!$city_suberb || $city_suberb =~ m/^[^\'\"]+$/) 
            && (!$mobile || $mobile =~ m/^$_mobile_pattern$/) 
            && (!$phone || $phone =~ m/^$_landline_pattern$/)
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
                                ($postal_address_id, $return_res, @msgs_res_address) = $self->create_address($postal_unit, $postal_street, $postal_city_suburb, $postal_postcode, $postal_region, $postal_country, $residential_address_id, $db);
                                $return = $return_res unless $return_res;
                                push @msgs, @msgs_res_address;
                            }
                            $line = __LINE__;
                            $self->log(Data::Dumper->Dump([$mobile, $phone, $line], [qw(mobile phone line)]));
                            my ($mobile_id, $phone_id);
                            my ($return_phone, @msgs_phone);
                            my ($_escape, $mobile_pattern, $landline_pattern, $return_phonedetails, @msgs_phonedetails) = $self->getphonedetails($countries_id, $cc, $prefix, $db);
                            $return = 0 unless $return_phonedetails;
                            push @msgs, @msgs_phonedetails;
                            if($mobile){
                                eval {
                                    $mobile = $self->normalise_mobile($mobile, $cc, $prefix, $_escape, $mobile_pattern, \%session, $db);
                                };
                                if($@){
                                    $return = 0;
                                    push @msgs, $@;
                                }
                                ($mobile_id, $return_phone, @msgs_phone) = $self->create_phone($mobile, $db);
                                $return = $return_phone unless $return_phone;
                                push @msgs, @msgs_phone;
                            }
                            if($phone){
                                eval {
                                    $phone = $self->normalise_landline($phone, $cc, $prefix, $_escape, $landline_pattern, \%session, $db);
                                };
                                if($@){
                                    $return = 0;
                                    push @msgs, $@;
                                }
                                ($phone_id, $return_phone, @msgs_phone) = $self->create_phone($phone, $db);
                                $return = $return_phone unless $return_phone;
                                push @msgs, @msgs_phone;
                            }
                            my $primary_phone_id = $phone_id;
                            my $secondary_phone_id;
                            if($mobile_id){
                                $secondary_phone_id = $primary_phone_id;
                                $primary_phone_id = $mobile_id;
                            }
                            my ($return_email, $primary_email_id, @msgs_email);
                            ($primary_email_id, $return_email, @msgs_email) = $self->create_email($email, $db);
                            $return = $return_email unless $return_email;
                            push @msgs, @msgs_email;
                            $countries_id = 2 unless defined $countries_id;
                            if($return){
                                my ($passwd_details_id, $return_details, @_msgs) = $self->create_passwd_details($display_name, $given, $family, $residential_address_id, $postal_address_id, $primary_phone_id, $secondary_phone_id, $countries_id, $db);
                                $return = $return_details unless $return_details;
                                push @msgs, @_msgs;
                                if($return){
                                    my ($passwd_id, $return_passwd, @msgs_passwd);
                                    eval {
                                        ($passwd_id, $return_passwd, @msgs_passwd)  = $self->create_passwd($username, $hashed_password, $primary_email_id, $passwd_details_id, $primary_group_id, $admin, $db);
                                        $return = 0 unless $return_passwd;
                                        push @msgs, @msgs_passwd;
                                    };
                                    if($@){
                                        $return = 0;
                                        push @msgs, "Error: falied to create passwd: $@";
                                    }
                                    if($passwd_id && @group_id_add){
                                        for my $group_id (@group_id_add){
                                            $sql  = "INSERT INTO groups(group_id, passwd_id)\n";
                                            $sql .= "VALUES(?, ?)\n";
                                            $sql .= "RETURNING id\n";
                                            $query  = $db->prepare($sql);
                                            eval {
                                                $result = $query->execute($group_id, $passwd_id);
                                            };
                                            if($@){
                                                push @msgs, "Error: could not INSERT INTO groups please contact your webmaster: $@";
                                                $return = 0;
                                            }
                                            if($result){
                                                my $r      = $query->fetchrow_hashref();
                                                my $id     = $r->{id};
                                                push @msgs, "INSERTED INTO groups Success";
                                            }else{
                                                push @msgs, "Error: could not INSERT INTO groups please contact your webmaster";
                                                $return = 0;
                                            }
                                        }
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
                my $button_name = 'login';
                my $back_to     = 'login';
                if($isadmin){
                    $button_name = 'Back to Users';
                    $back_to     = 'user';
                }elsif($loggedin){
                    $button_name = 'Back to Home';
                    $back_to     = 'main';
                }
                $self->message($cfg, $debug, \%session, $db, ($return?$back_to:'register'), ($return ? $button_name : undef), !$return, @msgs);
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
        $postal_city_suburb = '' unless defined $postal_city_suburb;
        $postal_postcode    = '' unless defined $postal_postcode;
        $postal_region      = '' unless defined $postal_region;
        $postal_country     = '' unless defined $postal_country;
        $given              = '' unless defined $given;
        $family             = '' unless defined $family;
        $display_name       = '' unless defined $display_name;
        $line = __LINE__;
        $self->log(Data::Dumper->Dump([$line, $cc, $prefix, $countries_id], [qw(line cc prefix countries_id)]));
        $cc                 = 'AU' unless defined $cc;
        $prefix             = '+61' unless defined $prefix;
        $countries_id       = '2' unless defined $countries_id;
        $line = __LINE__;
        $self->log(Data::Dumper->Dump([$line, $cc, $prefix, $countries_id], [qw(line cc prefix countries_id)]));

        my $sql  = "SELECT g.id, g._name FROM _group g;\n";
        my $query       = $db->prepare($sql);
        my $result;
        eval {
            $result     = $query->execute();
        };
        if($@){
            $self->message($cfg, $debug, \%session, $db, 'register', undef, undef, "Error: $@", "Cannnot Read _group");
            $query->finish();
            return 0;
        }
        $self->log(Data::Dumper->Dump([$query, $result, $sql], [qw(query result sql)]));
        my @groups;
        my $r           = $query->fetchrow_hashref();
        while($r){
            push @groups, $r;
            $r          = $query->fetchrow_hashref();
        }
        $query->finish();

        my @msgs;
        my $return = 1;
        my @countries;

        $sql  = "SELECT\n";
        $sql .= "c.id, c.cc, c.prefix, c._name, _flag, c._escape, c.landline_pattern, c.mobile_pattern,\n";
        $sql .= "c.landline_title, c.mobile_title, c.landline_placeholder, c.mobile_placeholder\n";
        $sql .= "FROM countries c\n";
        $sql .= "ORDER BY c._name, c.cc\n";
        $query  = $db->prepare($sql);
        eval {
            $result = $query->execute();
        };
        if($@){
            push @msgs, "SELECT FROM countries failed: $@", "\$sql == $sql";
            $return = 0;
        }
        unless($result){
            push @msgs, "SELECT FROM countries failed: \$sql == $sql";
            return $return;
        }
        $r      = $query->fetchrow_hashref();
        while($r){
            push @countries, $r;
            $r      = $query->fetchrow_hashref();
        }
        $query->finish();
        unless($return){
            $self->message($cfg, $debug, \%session, $db, ($return?'user':'user_details'), ($return ? 'dummy' : undef), !$return, @msgs);
        }

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
        say "                <script>";
        say "                    function togglepasswd(){";
        say "                        var pws = document.getElementsByClassName(\"passwd\");";
        say "                        var chk = document.getElementById(\"chkpasswd\");";
        say "                        for(let pw of pws){";
        say "                            if(chk.checked){;";
        say "                                pw.type = \"text\";";
        say "                            }else{";
        say "                                pw.type = \"password\";";
        say "                            }";
        say "                        }";
        say "                    }";
        say "                </script>";
        say "                <tr>";
        say "                    <td>";
        say "                        <label for=\"password\">password</label>";
        say "                    </td>";
        say "                    <td colspan=\"2\">";
        say "                        <input type=\"password\" name=\"password\" id=\"password\" class=\"passwd\" placeholder=\"password\" minlength=\"10\" pattern=\"$pattern\" title=\"$title\" value=\"$password\" required/>";
        say "                    </td>";
        say "                </tr>";
        say "                <tr>";
        say "                    <td>";
        say "                        <label for=\"repeat\">Repeat Password</label>";
        say "                    </td>";
        say "                    <td colspan=\"2\">";
        say "                        <input type=\"password\" name=\"repeat\" id=\"repeat\" class=\"passwd\" placeholder=\"repeat password\" minlength=\"10\" pattern=\"$pattern\" title=\"$title\" value=\"$repeat\"  required/>";
        say "                    </td>";
        say "                </tr>";
        say "                <tr>";
        say "                    <td>";
        say "                        <label for=\"chkpasswd\">Show Password</label>";
        say "                    </td>";
        say "                    <td colspan=\"2\">";
        say "                        <input type=\"checkbox\" id=\"chkpasswd\" onclick=\"togglepasswd()\"  />";
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
        say "                <tr>";
        say "                    <td>";
        say "                        <label for=\"cc_and_prefix\">CC and Prefix:</label>";
        say "                    </td>";
        say "                    <td colspan=\"2\">";
        say "                        <input type=\"hidden\" name=\"cc\" id=\"cc\" value=\"$cc\"/>";
        say "                        <input type=\"hidden\" name=\"prefix\" id=\"prefix\" value=\"$prefix\"/>";

        my $mobile_title;
        my $mobile_pattern;
        my $mobile_placeholder;
        my $landline_title;
        my $landline_pattern;
        my $landline_placeholder;
        my $flag;
        say "                        <select name=\"countries_id\" id=\"countries_id\" onchange=\"countries_onchange()\" is=\"ms-dropdown\">";
        #say "                            <select name=\"countries_id\" is=\"ms-dropdown\">";
        for my $row (@countries){
            my $cc_id   = $row->{id};
            my $name    = $row->{_name};
            my $_cc     = $row->{cc};
            my $_flag   = $row->{_flag};
            my $_prefix = $row->{prefix};
            if($cc_id == $countries_id){
                $flag   = $_flag;
                say "                                <option value=\"$cc_id\" data-image=\"$_flag\" selected=\"selected\">$name: $_cc ($_prefix)</option>";
            }else{
                say "                                <option value=\"$cc_id\" data-image=\"$_flag\">$name: $_cc ($_prefix)</option>";
            }
        }
        say "                        </select>";

        say "                        <script>";
        say "                            function countries_onchange() {";
        say "                                var countries = {";
        for my $row (@countries){
            my $cc_id            = $row->{id};
            my $_cc              = $row->{cc};
            my $name             = $row->{_name};
            my $_flag            = $row->{_flag};
            my $_prefix          = $row->{prefix};
            my $_escape          = $row->{_escape};
            my $lndl_pattern     = $row->{landline_pattern};
            my $mob_pattern      = $row->{mobile_pattern};
            my $lndl_title       = $row->{landline_title};
            my $mob_title        = $row->{mobile_title};
            my $lndl_placeholder = $row->{landline_placeholder};
            my $mob_placeholder  = $row->{mobile_placeholder};
            $_escape = '' unless defined $_escape;
            if($countries_id == $cc_id){
                $mobile_title       = $mob_title;
                $mobile_pattern     = $mob_pattern;
                $mobile_placeholder = $mob_placeholder;
                $landline_title     = $lndl_title;
                $landline_pattern   = $lndl_pattern;
                $landline_placeholder = $lndl_placeholder;
            }
            $lndl_pattern        =~ s/\\/\\\\/g;
            $mob_pattern         =~ s/\\/\\\\/g;
            say "                                            \"$cc_id\": { \"_name\": \"$name\",";
            say "                                                          \"cc\": \"$_cc\",";
            say "                                                          \"prefix\": \"$_prefix\",";
            say "                                                          \"_flag\": \"$_flag\",";
            say "                                                          \"_escape\": \"$_escape\",";
            say "                                                          \"landline_pattern\": \"$lndl_pattern\",";
            say "                                                          \"mobile_pattern\": \"$mob_pattern\",";
            say "                                                          \"landline_title\": \"$lndl_title\",";
            say "                                                          \"mobile_title\": \"$mob_title\",";
            say "                                                          \"landline_placeholder\": \"$lndl_placeholder\",";
            say "                                                          \"mobile_placeholder\": \"$mob_placeholder\" },";
        }
        say "                                    };";
        say "                                var cc_id_elt = document.getElementById('countries_id');";
        say "                                var countries_id = cc_id_elt.value;";
        #say "                                alert(\"countries_id == \" + countries_id);";
        say "                                ";
        say "                                if(countries_id == 0) return; // should never happen //"; 
        say "                                // values to match countries_id //";
        say "                                var cc                     = countries[countries_id]['cc'];";
        say "                                var prefix                 = countries[countries_id]['prefix'];";
        say "                                var name                   = countries[countries_id]['_name'];";
        say "                                var _escape                = countries[countries_id]['_escape'];";
        say "                                var _flag                  = countries[countries_id]['_flag'];";
        say "                                var landline_pattern       = countries[countries_id]['landline_pattern'];";
        say "                                var mobile_pattern         = countries[countries_id]['mobile_pattern'];";
        say "                                var landline_title         = countries[countries_id]['landline_title'];";
        say "                                var mobile_title           = countries[countries_id]['mobile_title'];";
        say "                                var landline_placeholder   = countries[countries_id]['landline_placeholder'];";
        say "                                var mobile_placeholder     = countries[countries_id]['mobile_placeholder'];";
        say "                                // The objects to change //";
        say "                                var hdn_cc                 = document.getElementById(\"cc\");";
        say "                                hdn_cc.value               = cc;";
        say "                                var hdn_prefix             = document.getElementById(\"prefix\");";
        say "                                hdn_prefix.value           = prefix;";
        say "                                var input_mobile           = document.getElementById(\"mobile\");";
        say "                                input_mobile.placeholder   = mobile_placeholder;";
        #say "                                alert(\"mobile_pattern == \" + mobile_pattern);";
        say "                                input_mobile.setAttribute('pattern', mobile_pattern);";
        say "                                input_mobile.title         = mobile_title;";
        say "                                var input_phone            = document.getElementById(\"phone\");";
        say "                                input_phone.placeholder    = landline_placeholder;";
        #say "                                input_phone.pattern        = landline_pattern;";
        #say "                                alert(\"landline_pattern == \" + landline_pattern);";
        say "                                input_phone.setAttribute('pattern', landline_pattern);";
        say "                                input_phone.title          = landline_title;";
        say "                                var input_country          = document.getElementById(\"country\");";
        say "                                input_country.value        = name;";
        say "                                var input_postal_country   = document.getElementById(\"postal_country\");";
        say "                                input_postal_country.value = name;";
        say "                            }";
        say "                            ";
        say "                            ";
        say "                        </script>";
        say "                        <script src=\"https://cdn.jsdelivr.net/npm/ms-dropdown\@4.0.3/dist/js/dd.min.js\"></script>";
        say "                    </td>";
        say "                </tr>";
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
        say "                        <label for=\"postal_city_suburb\">City/Suberb</label>";
        say "                    </td>";
        say "                    <td colspan=\"2\">";
        say "                        <input type=\"text\" name=\"postal_city_suburb\" id=\"postal_city_suburb\" placeholder=\"city/suberb\" pattern=\"$pattern\" title=\"$title\" value=\"$postal_city_suburb\" class=\"require\" $required/>";
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
            say "                <tr class=\"admin\">";
            say "                    <td colspan=\"3\">";
            say "                        <script>";
            say "                            function groupOnclick(n){";
            say "                                var btn   = document.getElementById(\"btn[\" + n + ']');";
            say "                                var cross = document.getElementById(\"cross[\" + n + ']');";
            say "                                var hdd   = document.getElementById(\"hdd[\" + n + ']');";
            say "                                var td    = document.getElementById(\"td[\" + n + ']');";
            say "                                var val   = hdd.value;";
            say "                                var name  = btn.value;";
            say "                                alert(\"val == \" + val + \"\\nname == \" + name);";
            say "                                td.remove();";
            say "                                var groupSelect = document.getElementById(\"groupSelect\");";
            say "                                var opt = document.createElement(\"OPTION\");";
            say "                                opt.setAttribute(\"value\", \"\" + val);";
            say "                                opt.setAttribute(\"id\", \"row_id[\" + val + \"]\");";
            say "                                opt.innerHTML = name;";
            say "                                groupSelect.appendChild(opt);";
            say "                            }";
            say "                            let cnt = 0;";
            say "                            function group_selected() {";
            say "                                var groupSelect = document.getElementById(\"groupSelect\");";
            say "                                var val = groupSelect.value;";
            say "                                if(val == 0) return";
            say "                                var opt = document.getElementById(\"row_id[\" + val + \"]\");";
            say "                                var name = opt.innerHTML;";
            say "                                opt.remove();";
            say "                                var btn = document.createElement(\"INPUT\");";
            say "                                btn.setAttribute(\"type\", \"button\");";
            say "                                btn.setAttribute(\"value\", name);";
            say "                                btn.name = \"btn[\" + cnt + ']';";
            say "                                btn.id   = \"btn[\" + cnt + ']';";
            say "                                var cross = document.createElement(\"button\");";
            say "                                cross.setAttribute(\"type\", \"button\");";
            say "                                cross.setAttribute(\"value\", \"\" + cnt);";
            say "                                cross.setAttribute(\"class\", \"inner\");";
            #say "                                cross.setAttribute(\"src\", \"img_submit.gif\");";
            say "                                cross.setAttribute(\"onclick\", \"groupOnclick(\" + cnt + ')');";
            say "                                cross.innerHTML = \"&otimes;\";";
            say "                                cross.name = \"chk[\" + cnt + ']';";
            say "                                cross.id   = \"cross[\" + cnt + ']';";
            say "                                var hdn = document.createElement(\"INPUT\");";
            say "                                hdn.setAttribute(\"type\", \"hidden\");";
            say "                                hdn.setAttribute(\"value\", \"\" + val);";
            say "                                hdn.name = \"group_id_add[\" + val + ']';";
            say "                                hdn.id   = \"hdd[\" + cnt + ']';";
            say "                                var row = document.getElementById(\"row\");";
            say "                                var elt = document.createElement(\"TD\");";
            say "                                elt.setAttribute(\"id\", \"td[\" + cnt + ']');";
            say "                                elt.setAttribute(\"class\", \"elts\");";
            say "                                elt.appendChild(btn);";
            say "                                elt.appendChild(cross);";
            say "                                elt.appendChild(hdn);";
            say "                                row.appendChild(elt);";
            say "                                cnt++;";
            say "                            }";
            say "                        </script>";
            say "                        <table class=\"outter\">";
            say "                           <tr class=\"outter\">";
            say "                              <td class=\"outter\">";
            say "                                  <table id=\"tbl\" class=\"elts inner\">";
            say "                                      <tr id=\"row\" class=\"elts\">";
            say "                                          <td class=\"elts inner\">";
            say "                                               Groups:";
            say "                                          </td>";
            say "                                      </tr>";
            say "                                  </table>";
            say "                              </td>";
            say "                           </tr>";
            say "                        </table>";
            say "                    </td>";
            say "                </tr>";
            say "                <tr>";
            say "                    <td>";
            say "                        <select id=\"groupSelect\" onchange=\"group_selected()\">";
            say "                            <option id=\"row_id[0]\" value=\"0\" selected>-- nothinng selected --</option>";
            for my $row (@groups){
                my $available_group_id = $row->{id};
                my $_name = $row->{_name};
                say "                            <option id=\"row_id[$available_group_id]\" value=\"$available_group_id\">$_name</option>";
            }
            say "                        </select>";
            say "                    </td>";
            say "                </tr>";
        }else{
            say "                <tr hidden class=\"admin\">";
            say "                    <td colspan=\"3\">";
            say "                        <input type=\"hidden\" name=\"admin\" id=\"admin\" value=\"0\"/>";
            say "                    </td>";
            say "                </tr>";
        }
        my @buttons = ({tag => 'input', name => 'submit', type => 'submit', value => 'Register', }, );
        $self->bottom_buttons($debug, $dont_showdebug, undef, 16, @buttons);
        #say "                <tr>";
        #say "                    <td>";
        #if($debug){
        #    say "                        <label for=\"debug\"><div class=\"ex\"><input name=\"debug\" id=\"debug\" type=\"radio\" value=\"1\" checked> debug</div></label>";
        #    say "                    </td>";
        #    say "                    <td>";
        #    say "                        <label for=\"nodebug\"><div class=\"ex\"><input name=\"debug\" id=\"nodebug\" type=\"radio\" value=\"0\"> nodebug</div></label>";
        #}else{
        #    say "                        <label for=\"debug\"><div class=\"ex\"><input name=\"debug\" id=\"debug\" type=\"radio\" value=\"1\"> debug</div></label>";
        #    say "                    </td>";
        #    say "                    <td>";
        #    say "                        <label for=\"nodebug\"><div class=\"ex\"><input name=\"debug\" id=\"nodebug\" type=\"radio\" value=\"0\" checked> nodebug</div></label>";
        #}
        #say "                    </td>";
        #say "                    <td>";
        #say "                        <input name=\"submit\" type=\"submit\" value=\"Register\">";
        #say "                    </td>";
        #say "                </tr>";
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

        my $dont_showdebug  = !$cfg->val('general', 'showdebug');

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
        my @buttons = ({tag => 'input', name => 'submit', type => 'submit', value => 'Add', }, );
        $self->bottom_buttons($debug, $dont_showdebug, undef, 16, @buttons);
        #say "                <tr>";
        #say "                    <td>";
        #if($debug){
        #    say "                        <label for=\"debug\"><div class=\"ex\"><input name=\"debug\" id=\"debug\" type=\"radio\" value=\"1\" checked> debug</div></label>";
        #    say "                    </td>";
        #    say "                    <td>";
        #    say "                        <label for=\"nodebug\"><div class=\"ex\"><input name=\"debug\" id=\"nodebug\" type=\"radio\" value=\"0\"> nodebug</div></label>";
        #}else{
        #    say "                        <label for=\"debug\"><div class=\"ex\"><input name=\"debug\" id=\"debug\" type=\"radio\" value=\"1\"> debug</div></label>";
        #    say "                    </td>";
        #    say "                    <td>";
        #    say "                        <label for=\"nodebug\"><div class=\"ex\"><input name=\"debug\" id=\"nodebug\" type=\"radio\" value=\"0\" checked> nodebug</div></label>";
        #}
        #say "                    </td>";
        #say "                    <td>";
        #say "                        <input name=\"submit\" type=\"submit\" value=\"Add\">";
        #say "                    </td>";
        #say "                </tr>";
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

        my $dont_showdebug  = !$cfg->val('general', 'showdebug');

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

        my $loggedin                  = $session{loggedin};
        my $loggedin_id               = $session{loggedin_id};
        my $loggedin_username         = $session{loggedin_username};
        my $loggedin_admin            = $session{loggedin_admin};
        my $loggedin_display_name     = $session{loggedin_display_name};
        my $loggedin_given            = $session{loggedin_given};
        my $loggedin_family           = $session{loggedin_family};
        my $loggedin_email            = $session{loggedin_email};
        my $loggedin_phone_number     = $session{loggedin_phone_number};
        my $loggedin_groupname        = $session{loggedin_groupname};
        my $loggedin_primary_group_id = $session{loggedin_groupnname_id};

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
        say "                    <form action=\"insert-countries.pl\" method=\"post\"><input type=\"submit\" name=\"submit\" id=\"submit\" value=\"Insert Countries\"/></form>";
        say "                </td>";
        say "            </tr>";
        say "            <tr>";
        say "                <td>";
        say "                    <form action=\"update-countries.pl\" method=\"post\"><input type=\"submit\" name=\"submit\" id=\"submit\" value=\"Update Countries\"/></form>";
        say "                </td>";
        say "            </tr>";
        say "            <tr>";
        say "                <td>";
        say "                    <form action=\"countries-transfer.pl\" method=\"post\"><input type=\"submit\" name=\"submit\" id=\"submit\" value=\"Countries Transfer\"/></form>";
        say "                </td>";
        say "            </tr>";
        say "            <tr>";
        say "                <td>";
        say "                    <form action=\"admin.pl\" method=\"post\">";
        say "                        <table class=\"ex\">";
        my @buttons = ({tag => 'input', name => 'submit', type => 'submit', value => 'Apply', }, );
        $self->bottom_buttons($debug, $dont_showdebug, undef, 28, @buttons);
        #say "                            <td>";
        #if($debug){
        #    say "                        <label for=\"debug\"><div class=\"ex\"><input name=\"debug\" id=\"debug\" type=\"radio\" value=\"1\" checked> debug</div></label>";
        #    say "                    </td>";
        #    say "                    <td>";
        #    say "                        <label for=\"nodebug\"><div class=\"ex\"><input name=\"debug\" id=\"nodebug\" type=\"radio\" value=\"0\"> nodebug</div></label>";
        #}else{
        #    say "                        <label for=\"debug\"><div class=\"ex\"><input name=\"debug\" id=\"debug\" type=\"radio\" value=\"1\"> debug</div></label>";
        #    say "                    </td>";
        #    say "                    <td>";
        #    say "                        <label for=\"nodebug\"><div class=\"ex\"><input name=\"debug\" id=\"nodebug\" type=\"radio\" value=\"0\" checked> nodebug</div></label>";
        #}
        #say "                            </td>";
        #say "                            <td>";
        #say "                                <input name=\"submit\" type=\"submit\" value=\"Apply\">";
        #say "                            </td>";
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
        my ($self, $display_name, $given, $family, $residential_address_id, $postal_address_id, $primary_phone_id, $secondary_phone_id, $countries_id, $db) = @_;
        my $line = __LINE__;
        $self->log(Data::Dumper->Dump([$display_name, $given, $family, $residential_address_id, $postal_address_id, $primary_phone_id, $secondary_phone_id, $line],
                [qw(display_name given family residential_address_id postal_address_id primary_phone_id secondary_phone_id primary_email_id line)]));
        my ($passwd_details_id, $return, @msgs);
        $return = 1;
        my $sql    = "INSERT INTO passwd_details(display_name, given, _family, residential_address_id, postal_address_id, primary_phone_id, secondary_phone_id, countries_id)VALUES(?, ?, ?, ?, ?, ?, ?, ?)  RETURNING id;\n";
        my $query  = $db->prepare($sql);
        my $result;
        eval {
            $result = $query->execute($display_name, $given, $family, $residential_address_id, $postal_address_id, $primary_phone_id, $secondary_phone_id, $countries_id);
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
        $admin = 0 unless defined $admin;
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
        my ($self, $email_id, $passwd_id, $_session, $db) = @_;
        my %session = %{$_session};

        my $loggedin                  = $session{loggedin};
        my $loggedin_id               = $session{loggedin_id};
        my $loggedin_username         = $session{loggedin_username};
        my $loggedin_admin            = $session{loggedin_admin};
        my $loggedin_display_name     = $session{loggedin_display_name};
        my $loggedin_given            = $session{loggedin_given};
        my $loggedin_family           = $session{loggedin_family};
        my $loggedin_email            = $session{loggedin_email};
        my $loggedin_phone_number     = $session{loggedin_phone_number};
        my $loggedin_groupname        = $session{loggedin_groupname};
        my $loggedin_primary_group_id = $session{loggedin_groupnname_id};

        return (0, "Only an Admin may delete an email!") unless $loggedin_admin || $passwd_id == $loggedin_id;

        my $line = __LINE__;
        $self->log(Data::Dumper->Dump([$email_id, $line], [qw(email_id line)]));
        my ($return, @msgs);
        $return = 1;
        my $sql  = "DELETE FROM email\n";
        $sql    .= "WHERE id = ?\n";
        my $query  = $db->prepare($sql);
        my $result;
        eval {
            $result = $query->execute($email_id);
        };
        if($@){
            $return = 0;
            push @msgs, "Error: could not delete record from table email: $@";
        }
        $line = __LINE__;
        $self->log(Data::Dumper->Dump([$result, $return, \@msgs, $line], [qw(result return @msgs line)]));
        return ($return, @msgs);
    } ## --- end sub delete_email


    sub delete_group {
        my ($self, $group_id, $passwd_id, $_session, $db) = @_;
        my %session = %{$_session};

        my $loggedin                  = $session{loggedin};
        my $loggedin_id               = $session{loggedin_id};
        my $loggedin_username         = $session{loggedin_username};
        my $loggedin_admin            = $session{loggedin_admin};
        my $loggedin_display_name     = $session{loggedin_display_name};
        my $loggedin_given            = $session{loggedin_given};
        my $loggedin_family           = $session{loggedin_family};
        my $loggedin_email            = $session{loggedin_email};
        my $loggedin_phone_number     = $session{loggedin_phone_number};
        my $loggedin_groupname        = $session{loggedin_groupname};
        my $loggedin_primary_group_id = $session{loggedin_groupnname_id};

        return (0, "Only an Admin may delete a _group!") unless $loggedin_admin || $passwd_id == $loggedin_id;

        my $line = __LINE__;
        $self->log(Data::Dumper->Dump([$group_id, $line], [qw(group_id line)]));
        my ($return, @msgs);
        $return = 1;
        my $sql  = "SELECT COUNT(*) n FROM passwd\n";
        $sql    .= "WHERE primary_group_id = ?\n";
        my $query  = $db->prepare($sql);
        my $result;
        eval {
            $result = $query->execute($group_id);
        };
        if($@){
            $return = 0;
            push @msgs, "Error: could not read record from table passwd: $@";
        }
        if($result){
            my $r      = $query->fetchrow_hashref();
            my $n      = $r->{n};
            if($n >= 1){
                push @msgs, "group still in use";
                return ($return, @msgs);
            }
        }else{
            push @msgs, "Error: could not read record from table passwd";
            return ($return, @msgs);
        }
        $sql  = "DELETE FROM _group\n";
        $sql    .= "WHERE id = ? RETURNING id, _name;\n";
        $query  = $db->prepare($sql);
        eval {
            $result = $query->execute($group_id);
        };
        if($@){
            $return = 0;
            push @msgs, "Error: could not delete record from table email: $@";
        }
        if($result){
            my $r      = $query->fetchrow_hashref();
            my $ok = ($group_id == $r->{id});
            my $name = $r->{_name};
            if($ok){
                push @msgs, "_group $name deleted ";
            }else{
                $return = 0;
                push @msgs, "Error _group failed to delete record: $group_id";
            }
        }else{
            $return = 0;
            push @msgs, "Error: could not delete record from table email";
        }
        $line = __LINE__;
        $self->log(Data::Dumper->Dump([$result, $return, \@msgs, $line], [qw(result return @msgs line)]));
        # TODO: fishish the. #
        return ($return, @msgs);
    } ## --- end sub delete_group


    ##################################################################
    #                                                                #
    #         remove all seconndary groups for the user              #
    #                                                                #
    ##################################################################
    sub delete_groups {
        my ($self, $passwd_id, $_session, $db) = @_;
        my %session = %{$_session};

        my $loggedin                  = $session{loggedin};
        my $loggedin_id               = $session{loggedin_id};
        my $loggedin_username         = $session{loggedin_username};
        my $loggedin_admin            = $session{loggedin_admin};
        my $loggedin_display_name     = $session{loggedin_display_name};
        my $loggedin_given            = $session{loggedin_given};
        my $loggedin_family           = $session{loggedin_family};
        my $loggedin_email            = $session{loggedin_email};
        my $loggedin_phone_number     = $session{loggedin_phone_number};
        my $loggedin_passwdname        = $session{loggedin_passwdname};
        my $loggedin_primary_passwd_id = $session{loggedin_passwdnname_id};

        return (0, "Only an Admin may delete a groups record!") unless $loggedin_admin || $passwd_id == $loggedin_id;

        my $line = __LINE__;
        $self->log(Data::Dumper->Dump([$passwd_id, $line], [qw(passwd_id line)]));
        my ($return, @msgs);
        $return = 1;
        my $sql  = "DELETE FROM groups\n";
        $sql    .= "WHERE passwd_id = ? RETURNING group_id;\n";
        my $query  = $db->prepare($sql);
        my $result;
        eval {
            $result = $query->execute($passwd_id);
        };
        if($@){
            $return = 0;
            push @msgs, "Error: could not DELETE record from table groups: $@";
        }
        if($result){
            ####################################################################################
            #                                                                                  #
            #     collect all deleted groups to remove underlining _group if not required.     #
            #                                                                                  #
            ####################################################################################
            my $r      = $query->fetchrow_hashref();
            my @groups;
            while($r){
                my $group_id = $r->{group_id};
                push @groups, $group_id;
                $r      = $query->fetchrow_hashref();
            }
            $query->finish();
            ################################################################################
            #                                                                              #
            #             remove _group record's if they are nolonger in use.              #
            #                                                                              #
            ################################################################################
            for my $group_id (@groups){
                my ($n, $m) = (-1, -1);
                $sql  = "SELECT COUNT(*) n FROM groups gs\n";
                $sql .= "WHERE gs.group_id = ?\n";
                $query  = $db->prepare($sql);
                eval {
                    $result = $query->execute($group_id);
                };
                if($@){
                    $return = 0;
                    push @msgs, "Error: could not SELECT records from table groups $@";
                }
                if($result){
                    $r      = $query->fetchrow_hashref();
                    $n   = $r->{n};
                }else{
                    push @msgs, "check failed on groups";
                }
                $query->finish();
                $sql  = "SELECT COUNT(*) n FROM passwd p\n";
                $sql .= "WHERE p.primary_group_id = ?;\n";
                $query  = $db->prepare($sql);
                eval {
                    $result = $query->execute($group_id);
                };
                if($@){
                    $return = 0;
                    push @msgs, "Error: could not SELECT records from table passwd $@";
                }
                if($result){
                    $r      = $query->fetchrow_hashref();
                    $m   = $r->{n};
                }else{
                    push @msgs, "check failed on passwd";
                }
                $query->finish();
                if($n == 0 && $m == 0){
                    $sql  = "DELETE FROM _group\n";
                    $sql .= "WHERE id = ? RETURNING _name;\n";
                    $query  = $db->prepare($sql);
                    eval {
                        $result = $query->execute($group_id);
                    };
                    if($@){
                        $return = 0;
                        push @msgs, "Error: could not DELETE FROM table _group: $@";
                    }
                    if($result){
                        $r      = $query->fetchrow_hashref();
                        my $name        = $r->{_name};
                        $query->finish();
                        push @msgs, "Deleted _group: $name";
                    }else{
                        $return = 0;
                        push @msgs, "Error: could not DELETE FROM table groups";
                        $query->finish();
                    }
                }
            }
        }else{
            $query->finish();
            push @msgs, "Error: could not DELETE record from table groups";
        }
        $line = __LINE__;
        $self->log(Data::Dumper->Dump([$result, $return, \@msgs, $line], [qw(result return @msgs line)]));
        return ($return, @msgs);
    } ## --- end sub delete_groups


    ##################################################################
    #                                                                #
    #        remove all seconndary addresses for the user            #
    #                                                                #
    ##################################################################
    sub delete_addresses {
        my ($self, $passwd_id, $_session, $db) = @_;
        my %session = %{$_session};

        my $loggedin                  = $session{loggedin};
        my $loggedin_id               = $session{loggedin_id};
        my $loggedin_username         = $session{loggedin_username};
        my $loggedin_admin            = $session{loggedin_admin};
        my $loggedin_display_name     = $session{loggedin_display_name};
        my $loggedin_given            = $session{loggedin_given};
        my $loggedin_family           = $session{loggedin_family};
        my $loggedin_email            = $session{loggedin_email};
        my $loggedin_phone_number     = $session{loggedin_phone_number};
        my $loggedin_passwdname        = $session{loggedin_passwdname};
        my $loggedin_primary_passwd_id = $session{loggedin_passwdnname_id};

        return (0, "Only an Admin may delete a addresses record!") unless $loggedin_admin || $passwd_id == $loggedin_id;

        my $line = __LINE__;
        $self->log(Data::Dumper->Dump([$passwd_id, $line], [qw(passwd_id line)]));
        my ($return, @msgs);
        $return = 1;
        my $sql  = "DELETE FROM addresses\n";
        $sql    .= "WHERE passwd_id = ? RETURNING address_id;\n";
        my $query  = $db->prepare($sql);
        my $result;
        eval {
            $result = $query->execute($passwd_id);
        };
        if($@){
            $return = 0;
            push @msgs, "Error: could not DELETE record from table addresses: $@";
        }
        if($result){
            ####################################################################################
            #                                                                                  #
            #   collect all deleted addresses to remove underlining address if not required.   #
            #                                                                                  #
            ####################################################################################
            my $r      = $query->fetchrow_hashref();
            my @addresses;
            while($r){
                my $address_id = $r->{address_id};
                push @addresses, $address_id;
                $r      = $query->fetchrow_hashref();
            }
            $query->finish();
            ################################################################################
            #                                                                              #
            #            remove addresss record's if they are nolonger in use.             #
            #                                                                              #
            ################################################################################
            for my $address_id (@addresses){
                my ($n, $m) = (-1, -1);
                $sql  = "SELECT COUNT(*) n FROM addresses a\n";
                $sql .= "WHERE p.address_id = ?\n";
                $query  = $db->prepare($sql);
                eval {
                    $result = $query->execute($address_id);
                };
                if($@){
                    $return = 0;
                    push @msgs, "Error: could not SELECT records from table addresses $@";
                }
                if($result){
                    $r      = $query->fetchrow_hashref();
                    $n   = $r->{n};
                }else{
                    push @msgs, "check failed on emails";
                }
                $query->finish();
                $sql  = "SELECT COUNT(*) n FROM passwd_details pa\n";
                $sql .= "WHERE ? IN (pa.residential_address_id, pa.postal_address_id)\n";
                $query  = $db->prepare($sql);
                eval {
                    $result = $query->execute($address_id);
                };
                if($@){
                    $return = 0;
                    push @msgs, "Error: could not SELECT records from table passwd_details $@";
                }
                if($result){
                    $r      = $query->fetchrow_hashref();
                    $m   = $r->{n};
                }else{
                    push @msgs, "check failed on emails";
                }
                $query->finish();
                if($n == 0 && $m == 0){
                    $sql  = "DELETE FROM address\n";
                    $sql .= "WHERE id = ? RETURNING unit, street, city_suburb, postcode, region, country\n";
                    $query  = $db->prepare($sql);
                    eval {
                        $result = $query->execute($address_id);
                    };
                    if($@){
                        $return = 0;
                        push @msgs, "Error: could not DELETE FROM table address: $@";
                    }
                    if($result){
                        $r      = $query->fetchrow_hashref();
                        my $unit        = $r->{unit};
                        my $street      = $r->{street};
                        my $city_suburb = $r->{city_suburb};
                        my $postcode    = $r->{postcode};
                        my $region      = $r->{region};
                        my $country     = $r->{country};
                        $query->finish();
                        push @msgs, "Deleted address: $unit, $street, $city_suburb, $postcode, $region, $country";
                    }else{
                        $return = 0;
                        push @msgs, "Error: could not DELETE FROM table address";
                        $query->finish();
                    }
                }
            }
        }else{
            $query->finish();
            push @msgs, "Error: could not DELETE record from table addresses";
        }
        $line = __LINE__;
        $self->log(Data::Dumper->Dump([$result, $return, \@msgs, $line], [qw(result return @msgs line)]));
        return ($return, @msgs);
    } ## --- end sub delete_addresses


    ##################################################################
    #                                                                #
    #          remove all seconndary emails for the user             #
    #                                                                #
    ##################################################################
    sub delete_emails {
        my ($self, $passwd_id, $_session, $db) = @_;
        my %session = %{$_session};

        my $loggedin                   = $session{loggedin};
        my $loggedin_id                = $session{loggedin_id};
        my $loggedin_username          = $session{loggedin_username};
        my $loggedin_admin             = $session{loggedin_admin};
        my $loggedin_display_name      = $session{loggedin_display_name};
        my $loggedin_given             = $session{loggedin_given};
        my $loggedin_family            = $session{loggedin_family};
        my $loggedin_email             = $session{loggedin_email};
        my $loggedin_phone_number      = $session{loggedin_phone_number};
        my $loggedin_passwdname        = $session{loggedin_passwdname};
        my $loggedin_primary_passwd_id = $session{loggedin_passwdnname_id};

        return (0, "Only an Admin may delete a emails record! Unless it is your own") unless $loggedin_admin || $passwd_id == $loggedin_id;

        my $line = __LINE__;
        $self->log(Data::Dumper->Dump([$passwd_id, $line], [qw(passwd_id line)]));
        my ($return, @msgs);
        $return = 1;
        my $sql  = "DELETE FROM emails\n";
        $sql    .= "WHERE passwd_id = ? RETURNING email_id\n";
        my $query  = $db->prepare($sql);
        my $result;
        eval {
            $result = $query->execute($passwd_id);
        };
        if($@){
            $return = 0;
            push @msgs, "Error: could not DELETE record from table emails $@";
        }
        if($result){
            ################################################################################
            #                                                                              #
            #   collect all deleted emails to remove underlining email if not required.    #
            #                                                                              #
            ################################################################################
            my $r      = $query->fetchrow_hashref();
            my @emails;
            while($r){
                my $email_id = $r->{email_id};
                push @emails, $email_id;
                $r      = $query->fetchrow_hashref();
            }
            $query->finish();
            ################################################################################
            #                                                                              #
            #              remove email record's if they are nolonger in use.              #
            #                                                                              #
            ################################################################################
            for my $email_id (@emails){
                my ($n, $m) = (-1, -1);
                $sql  = "SELECT COUNT(*) n FROM emails e  WHERE e.email_id = ?\n";
                $query  = $db->prepare($sql);
                eval {
                    $result = $query->execute($passwd_id);
                };
                if($@){
                    $return = 0;
                    push @msgs, "Error: could not SELECT records from table emails $@";
                }
                if($result){
                    $r      = $query->fetchrow_hashref();
                    $n   = $r->{n};
                }else{
                    push @msgs, "check failed on emails";
                }
                $query->finish();
                $sql  = "SELECT COUNT(*) n FROM passwd p  WHERE p.email_id = ?\n";
                $query  = $db->prepare($sql);
                eval {
                    $result = $query->execute($passwd_id);
                };
                if($@){
                    $return = 0;
                    push @msgs, "Error: could not SELECT FROM table passwd $@";
                }
                if($result){
                    $r      = $query->fetchrow_hashref();
                    $m   = $r->{n};
                }else{
                    push @msgs, "check failed on passwd";
                }
                $query->finish();
                if($n == 0 && $m == 0){
                    $sql  = "DELETE FROM email\n";
                    $sql .= "WHERE id = ? RETURNING _email\n";
                    $query  = $db->prepare($sql);
                    eval {
                        $result = $query->execute($passwd_id);
                    };
                    if($@){
                        $return = 0;
                        push @msgs, "Error: could not DELETE FROM table email: $@";
                    }
                    if($result){
                        $r      = $query->fetchrow_hashref();
                        my $email = $r->{_email};
                        push @msgs, "Deleted email: $email";
                        $query->finish();
                    }else{
                        $return = 0;
                        push @msgs, "Error: could not DELETE FROM table email";
                        $query->finish();
                    }
                }
            } # for my $email_id (@emails) #
        }else{ # if($result) #
            $query->finish();
            $return = 0;
            push @msgs, "Error: could not DELETE record from table emails";
        }
        $line = __LINE__;
        $self->log(Data::Dumper->Dump([$result, $return, \@msgs, $line], [qw(result return @msgs line)]));
        return ($return, @msgs);
    } ## --- end sub delete_emails

    sub delete_passwd_details {
        my ($self, $passwd_details_id, $passwd_id, $_session, $db) = @_;
        my %session = %{$_session};

        my $loggedin                  = $session{loggedin};
        my $loggedin_id               = $session{loggedin_id};
        my $loggedin_username         = $session{loggedin_username};
        my $loggedin_admin            = $session{loggedin_admin};
        my $loggedin_display_name     = $session{loggedin_display_name};
        my $loggedin_given            = $session{loggedin_given};
        my $loggedin_family           = $session{loggedin_family};
        my $loggedin_email            = $session{loggedin_email};
        my $loggedin_phone_number     = $session{loggedin_phone_number};
        my $loggedin_groupname        = $session{loggedin_groupname};
        my $loggedin_primary_group_id = $session{loggedin_groupnname_id};

        return (0, "Cannot DELETE admin!") if $passwd_details_id == 1;

        return (0, "Only an Admin may delete a passwd_details record! unless it is your own") unless $loggedin_admin || $passwd_id == $loggedin_id;

        my $line = __LINE__;
        $self->log(Data::Dumper->Dump([$passwd_details_id, $line], [qw(passwd_details_id line)]));
        my ($return, @msgs);
        $return = 1;
        my $sql  = "SELECT pd.residential_address_id, pd.postal_address_id, pd.primary_phone_id, pd.secondary_phone_id FROM passwd_details pd\n";
        $sql    .= "WHERE pd.id = ?\n";
        my $query  = $db->prepare($sql);
        my $result;
        eval {
            $result = $query->execute($passwd_details_id);
        };
        if($@){
            $return = 0;
            push @msgs, "Error: could not SELECT record from table passwd_details $@";
        }
        $line = __LINE__;
        $self->log(Data::Dumper->Dump([$result, $return, $query, $line], [qw(result return query line)]));
        if($result){
            my $r      = $query->fetchrow_hashref();
            my $residential_address_id = $r->{residential_address_id};
            my $postal_address_id      = $r->{postal_address_id};
            my $primary_phone_id       = $r->{primary_phone_id};
            my $secondary_phone_id     = $r->{secondary_phone_id};
            $query->finish;
            $line = __LINE__;
            $self->log(Data::Dumper->Dump([$result, $return, $query, $line], [qw(result return query line)]));
            if($return){
                $sql  = "DELETE FROM passwd_details\n";
                $sql .= "WHERE id = ?\n";
                $sql .= "RETURNING display_name, given, _family;\n";
                $query  = $db->prepare($sql);
                eval {
                    $result = $query->execute($passwd_details_id);
                };
                if($@){
                    $return = 0;
                    push @msgs, "Error: could not DELETE record from table passwd_details $@";
                }
                if($result){
                    my $r            = $query->fetchrow_hashref();
                    my $display_name = $r->{display_name};
                    my $given        = $r->{given};
                    my $family       = $r->{_family};
                    $self->log(Data::Dumper->Dump([$result, $query, $sql, $return, \@msgs, $display_name, $given, $family, $line],
                            [qw(result query sql return @msgs display_name given family line)]));
                    push @msgs, "address: $display_name, $given, $family, ... deleted";
                }else{
                    $return = 0;
                    push @msgs, "Error: could not DELETE record from table passwd_details $@";
                }
                $self->log(Data::Dumper->Dump([$return, \@msgs, $result, $query, $sql, $line], [qw(return @msgs result query sql line)]));
                $query->finish;
                my ($return_res_address, @msgs_res_address) = $self->delete_address($residential_address_id, \%session, $db);
                $return = 0 unless $return_res_address;
                push @msgs, @msgs_res_address;
                $self->log(Data::Dumper->Dump([$result, $return, $return_res_address, \@msgs, $line], [qw(result return return_res_address @msgs line)]));
                if($residential_address_id != $postal_address_id){
                    my ($return_post_address, @msgs_post_address) = $self->delete_address($postal_address_id, \%session, $db);
                    $return = 0 unless $return_post_address;
                    push @msgs, @msgs_post_address;
                    $self->log(Data::Dumper->Dump([$result, $return, $return_post_address, \@msgs, $line], [qw(result return return_post_address @msgs line)]));
                }
                if($primary_phone_id){
                    my ($return_prim_phone, @msgs_prim_phone) = $self->delete_phone($primary_phone_id, \%session, $db);
                    $return = 0 unless $return_prim_phone;
                    push @msgs, @msgs_prim_phone;
                    $self->log(Data::Dumper->Dump([$result, $return, $return_prim_phone, \@msgs, $line], [qw(result return return_prim_phone @msgs line)]));
                }
                if($secondary_phone_id){
                    my ($return_sec_phone, @msgs_sec_phone) = $self->delete_phone($secondary_phone_id, \%session, $db);
                    $return = 0 unless $return_sec_phone;
                    push @msgs, @msgs_sec_phone;
                    $self->log(Data::Dumper->Dump([$result, $return, $return_sec_phone, \@msgs, $line], [qw(result return return_sec_phone @msgs line)]));
                }
            }
        }else{
            $query->finish;
            $return = 0;
            push @msgs, "Error: could not SELECT record from table passwd_details";
        }
        $line = __LINE__;
        $self->log(Data::Dumper->Dump([$result, $return, \@msgs, $line], [qw(result return @msgs line)]));
        return ($return, @msgs);
    } ## --- end sub delete_passwd_details


    sub delete_address {
        my ($self, $address_id, $_session, $db) = @_;
        my %session = %{$_session};

        my $loggedin                  = $session{loggedin};
        my $loggedin_id               = $session{loggedin_id};
        my $loggedin_username         = $session{loggedin_username};
        my $loggedin_admin            = $session{loggedin_admin};
        my $loggedin_display_name     = $session{loggedin_display_name};
        my $loggedin_given            = $session{loggedin_given};
        my $loggedin_family           = $session{loggedin_family};
        my $loggedin_email            = $session{loggedin_email};
        my $loggedin_phone_number     = $session{loggedin_phone_number};
        my $loggedin_groupname        = $session{loggedin_groupname};
        my $loggedin_primary_group_id = $session{loggedin_groupnname_id};

        return (0, "Only an Admin may delete a address record!") unless $loggedin_admin;

        my $line = __LINE__;
        $self->log(Data::Dumper->Dump([$address_id, $line], [qw(address_id line)]));
        my ($return, @msgs);
        $return = 1;
        my $sql  = "DELETE FROM address\n";
        $sql    .= "WHERE id = ?\n";
        $sql    .= "RETURNING unit, street, city_suburb, postcode, region, country;\n";
        my $query  = $db->prepare($sql);
        my $result;
        eval {
            $result = $query->execute($address_id);
        };
        if($@){
            $return = 0;
            push @msgs, "Error: could not DELETE record FROM table address: $@";
        }
        if($result){
            my $r           = $query->fetchrow_hashref();
            my $unit        = $r->{unit};
            my $street      = $r->{street};
            my $city_suburb = $r->{city_suburb};
            my $postcode    = $r->{postcode};
            my $region      = $r->{region};
            my $country     = $r->{country};
            push @msgs, "address: $unit, $street, $city_suburb, $postcode, $region, $country deleted";
        }else{
            $return = 0;
            push @msgs, "Error: could not DELETE record FROM table address";
        }
        $line = __LINE__;
        $self->log(Data::Dumper->Dump([$result, $return, \@msgs, $line], [qw(result return @msgs line)]));
        return ($return, @msgs);
    } ## --- end sub delete_address


    sub delete_phone {
        my ($self, $phone_id, $_session, $db) = @_;
        my %session = %{$_session};

        my $loggedin                  = $session{loggedin};
        my $loggedin_id               = $session{loggedin_id};
        my $loggedin_username         = $session{loggedin_username};
        my $loggedin_admin            = $session{loggedin_admin};
        my $loggedin_display_name     = $session{loggedin_display_name};
        my $loggedin_given            = $session{loggedin_given};
        my $loggedin_family           = $session{loggedin_family};
        my $loggedin_email            = $session{loggedin_email};
        my $loggedin_phone_number     = $session{loggedin_phone_number};
        my $loggedin_groupname        = $session{loggedin_groupname};
        my $loggedin_primary_group_id = $session{loggedin_groupnname_id};

        return (0, "Only an Admin may delete a phone record!") unless $loggedin_admin;

        my $line = __LINE__;
        $self->log(Data::Dumper->Dump([$phone_id, $line], [qw(phone_id line)]));
        my ($return, @msgs);
        $return = 1;
        my $sql  = "DELETE FROM phone\n";
        $sql    .= "WHERE id = ?\n";
        $sql    .= "RETURNING _number\n";
        my $query  = $db->prepare($sql);
        my $result;
        eval {
            $result = $query->execute($phone_id);
        };
        if($@){
            $return = 0;
            push @msgs, "Error: could not DELETE record from table passwd_details: $@";
        }
        if($result){
            my $r      = $query->fetchrow_hashref();
            my $number = $r->{_number};
            push @msgs, "phone_number: $number deleted";
        }else{
            $return = 0;
            push @msgs, "Error: could not DELETE record from table passwd_details";
        }
        $line = __LINE__;
        $self->log(Data::Dumper->Dump([$result, $return, \@msgs, $line], [qw(result return @msgs line)]));
        return ($return, @msgs);
    } ## --- end sub delete_phone


    sub delete_passwd {
        my ($self, $passwd_id, $group_id, $_session, $db) = @_;
        my %session = %{$_session};

        my $loggedin                  = $session{loggedin};
        my $loggedin_id               = $session{loggedin_id};
        my $loggedin_username         = $session{loggedin_username};
        my $loggedin_admin            = $session{loggedin_admin};
        my $loggedin_display_name     = $session{loggedin_display_name};
        my $loggedin_given            = $session{loggedin_given};
        my $loggedin_family           = $session{loggedin_family};
        my $loggedin_email            = $session{loggedin_email};
        my $loggedin_phone_number     = $session{loggedin_phone_number};
        my $loggedin_groupname        = $session{loggedin_groupname};
        my $loggedin_primary_group_id = $session{loggedin_groupnname_id};

        return (0, "Cannot DELETE admin!") if $passwd_id == 1;

        return (0, "you can only delete yourself, unless you are an Admin!") unless $loggedin_admin || $passwd_id == $loggedin_id;

        my $line = __LINE__;
        $self->log(Data::Dumper->Dump([$passwd_id, $line], [qw(passwd_id line)]));

        my ($return, @msgs);
        $return = 1;
        $self->move_ownnership_of_all_urls_etc($passwd_id, $group_id, $loggedin_id, $loggedin_primary_group_id, $db);

        my $sql  = "DELETE FROM passwd\n";
        $sql    .= "WHERE id = ?\n";
        my $query  = $db->prepare($sql);
        my $result;
        eval {
            $result = $query->execute($passwd_id);
        };
        if($@){
            $return = 0;
            push @msgs, "Error: could not delete record from table passwd: $@";
        }
        $query->finish;
        $line = __LINE__;
        $self->log(Data::Dumper->Dump([$return, \@msgs, $line], [qw(return @msgs line)]));
        return ($return, @msgs);
    } ## --- end sub delete_passwd


    sub move_ownnership_of_all_urls_etc {
        my ($self, $passwd_id, $group_id, $loggedin_id, $loggedin_primary_group_id, $db) = @_;
        my ($return, @msgs);
        my $sql  = "UPDATE secure SET userid = ?,  groupid = ?\n";
        $sql    .= "WHERE userid = ? OR groupid = ?\n";
        my $query  = $db->prepare($sql);
        my $result;
        eval {
            $result = $query->execute($loggedin_id, $loggedin_primary_group_id, $passwd_id, $group_id);
        };
        if($@){
            $return = 0;
            push @msgs, "Error: could not UPDATE record from table secure: $@";
        }
        #if(!$result){
        #    $return = 0;
        #    push @msgs, "Error: could not UPDATE record from table secure";
        #}
        $query->finish;
        my $line = __LINE__;
        $self->log(Data::Dumper->Dump([$result, $return, \@msgs, $line], [qw(result return @msgs line)]));
        return ($return, @msgs);
    } ## --- end sub move_ownnership_of_all_urls_etc

    sub update_address {
        my ($self, $unit, $street, $city_suberb, $postcode, $region, $country, $default_id, $address_id, $db) = @_;
        my $line = __LINE__;
        $self->log(Data::Dumper->Dump([$unit, $street, $city_suberb, $postcode, $region, $country, $line],
                [qw(unit street city_suberb postcode region country line)]));
        my ($returning_address_id, $return, @msgs);
        $returning_address_id = $default_id;
        $return = 1;
        my $sql    = "UPDATE address SET unit = ?, street = ?, city_suburb = ?, postcode = ?, region = ?, country = ?\n";
        $sql      .= "WHERE id = ?\n";
        $sql      .= "RETURNING id;\n";
        my $query  = $db->prepare($sql);
        my $result;
        eval {
            $result = $query->execute($unit, $street, $city_suberb, $postcode, $region, $country, $address_id);
        };
        if($@){
            push @msgs, "UPDATE address failed: $@";
            $return = 0;
        }
        if($result){
            my $r      = $query->fetchrow_hashref();
            $returning_address_id = $r->{id};
        }else{
            push @msgs, "UPDATE address failed";
            $return = 0;
        }
        $query->finish();
        return ($returning_address_id, $return, @msgs);
    } ## --- end sub update_address


    sub update_phone {
        my ($self, $phone_id, $phone, $db) = @_;
        my $line = __LINE__;
        $self->log(Data::Dumper->Dump([$phone, $line],
                [qw(phone line)]));
        my ($return, @msgs);
        $return = 1;
        my $sql    = "UPDATE phone SET _number = ?\n";
        $sql      .= "WHERE id = ?\n";
        $sql      .= "RETURNING id;\n";
        my $query  = $db->prepare($sql);
        my $result;
        eval {
            $result = $query->execute($phone, $phone_id);
        };
        if($@){
            push @msgs, "UPDATE phone failed: $@", "\$sql == $sql";
            $return = 0;
        }
        if($result){
            my $r      = $query->fetchrow_hashref();
            unless($phone_id == $r->{id}){
                push @msgs, "UPDATE phone failed: $sql";
                $return = 0;
            }
        }else{
            push @msgs, "UPDATE phone failed";
            $return = 0;
        }
        $query->finish();
        return ($return, @msgs);
    } ## --- end sub update_phone


    sub update_email {
        my ($self, $email_id, $email, $db) = @_;
        my $line = __LINE__;
        $self->log(Data::Dumper->Dump([$email_id, $email, $line],
                [qw(email_id email line)]));
        my ($return, @msgs);
        $return = 1;
        my $sql    = "UPDATE email SET _email = ?\n";
        $sql      .= "WHERE id = ?\n";
        $sql      .= "RETURNING id;\n";
        my $query  = $db->prepare($sql);
        my $result;
        eval {
            $result = $query->execute($email, $email_id);
        };
        if($@){
            push @msgs, "UPDATE email failed: $@";
            $return = 0;
        }
        if($result){
            my $r      = $query->fetchrow_hashref();
            unless($email_id == $r->{id}){
                push @msgs, "UPDATE email failed: $sql";
                $return = 0;
            }
        }else{
            push @msgs, "UPDATE email failed";
            $return = 0;
        }
        $query->finish();
        return ($return, @msgs);
    } ## --- end sub update_email


    sub update_passwd_details {
        my ($self, $display_name, $given, $family, $new_residential_address_id, $new_postal_address_id, $primary_phone_id, $secondary_phone_id, $countries_id, $passwd_details_id, $db) = @_;
        $primary_phone_id   = undef unless $primary_phone_id;
        $secondary_phone_id = undef unless $secondary_phone_id;
        my $line = __LINE__;
        $self->log(Data::Dumper->Dump([$display_name, $given, $family, $new_residential_address_id, $new_postal_address_id, $primary_phone_id, $secondary_phone_id, $countries_id, $passwd_details_id, $line],
                [qw(display_name given family new_residential_address_id new_postal_address_id primary_phone_id secondary_phone_id countries_id passwd_details_id line)]));
        my ($return, @msgs);
        $return = 1;
        my $sql    = "UPDATE passwd_details SET display_name = ?, given = ?, _family = ?,\n";
        $sql      .= "residential_address_id = ?, postal_address_id = ?, primary_phone_id = ?,\n";
        $sql      .= "secondary_phone_id = ?, countries_id = ?\n";
        $sql      .= "WHERE id = ?\n";
        $sql      .= "RETURNING id;\n";
        my $query  = $db->prepare($sql);
        my $result;
        eval {
            $result = $query->execute($display_name, $given, $family, $new_residential_address_id, $new_postal_address_id, $primary_phone_id, $secondary_phone_id, $countries_id, $passwd_details_id);
        };
        if($@){
            push @msgs, "UPDATE passwd_details failed: $@", "\$sql == $sql", Data::Dumper->Dump([$display_name, $given, $family, $new_residential_address_id, $new_postal_address_id, $primary_phone_id, $secondary_phone_id, $passwd_details_id, $line],
                [qw(display_name given family new_residential_address_id new_postal_address_id primary_phone_id secondary_phone_id passwd_details_id line)]);
            $return = 0;
        }
        if($result){
            my $r      = $query->fetchrow_hashref();
            unless($passwd_details_id == $r->{id}){
                push @msgs, "UPDATE passwd_details failed: $sql";
                $return = 0;
            }
        }else{
            push @msgs, "UPDATE passwd_details failed";
            $return = 0;
        }
        $query->finish();
        return ($return, @msgs);
    } ## --- end sub update_passwd_details


    sub update_passwd {
        my ($self, $username, $hashed_password, $email_id, $passwd_details_id, $primary_group_id, $admin, $passwd_id, $db) = @_;
        $admin = 0 unless $admin;
        my $line = __LINE__;
        $self->log(Data::Dumper->Dump([$username, $hashed_password, $email_id, $passwd_details_id, $primary_group_id, $admin, $passwd_id, $line],
                [qw(username hashed_password email_id passwd_details_id primary_group_id admin passwd_id line)]));
        my ($return, @msgs);
        $return = 1;
        my $sql    = "UPDATE passwd  SET username = ?, passwd_details_id = ?, primary_group_id = ?, _admin = ?, email_id = ?";
        if($hashed_password){
            $sql .= ", _password = ?\n";
        }else{
            $sql .= "\n";
        }
        $sql      .= "WHERE id = ?\n";
        $sql      .= "RETURNING id;\n";
        my $query  = $db->prepare($sql);
        my $result;
        eval {
            if($hashed_password){
                $result = $query->execute($username, $passwd_details_id, $primary_group_id, $admin, $email_id, $hashed_password, $passwd_id);
            }else{
                $result = $query->execute($username, $passwd_details_id, $primary_group_id, $admin, $email_id, $passwd_id);
            }
        };
        if($@){
            push @msgs, "\$sql == $sql", "UPDATE passwd failed: $@";
            $return = 0;
        }
        if($result){
            my $r      = $query->fetchrow_hashref();
            unless($passwd_id == $r->{id}){
                push @msgs, "UPDATE passwd failed: $sql";
                $return = 0;
            }
        }else{
            push @msgs, "UPDATE passwd failed";
            $return = 0;
        }
        $query->finish();
        return ($return, @msgs);
    } ## --- end sub update_passwd


    sub bottom_buttons {
        my ($self, $debug, $dont_showdebug, $form, $indent, @buttons) = @_;
        $indent = 0 unless defined $indent;
        my $form_indent;
        if($form){
            $form_indent = ' ' x $indent;
            say "$form_indent<form  action=\"$form\" method=\"post\">";
            $indent += 4;
        }
        $indent = ' ' x $indent;
        say "$indent<tr>";
        if($dont_showdebug){
            $buttons[0]->{colspan} = 1 unless defined $buttons[0]->{colspan};
            $buttons[0]->{colspan} += 2;
        }else{
            say "$indent    <td>";
            if($debug){
                say "$indent        <label for=\"debug\"><div class=\"ex\"><input name=\"debug\" id=\"debug\" type=\"radio\" value=\"1\" checked> debug</div></label>";
                say "$indent    </td>";
                say "$indent    <td>";
                say "$indent        <label for=\"nodebug\"><div class=\"ex\"><input name=\"debug\" id=\"nodebug\" type=\"radio\" value=\"0\"> nodebug</div></label>";
            }else{
                say "$indent        <label for=\"debug\"><div class=\"ex\"><input name=\"debug\" id=\"debug\" type=\"radio\" value=\"1\"> debug</div></label>";
                say "$indent    </td>";
                say "$indent    <td>";
                say "$indent        <label for=\"nodebug\"><div class=\"ex\"><input name=\"debug\" id=\"nodebug\" type=\"radio\" value=\"0\" checked> nodebug</div></label>";
            }
            say "$indent    </td>";
        }
        for my$button (@buttons){
            my $colspan = $button->{colspan};
            my $name    = $button->{name};
            my $type    = $button->{type};
            my $value   = $button->{value};
            my $class   = $button->{class};
            my $id      = $button->{id};
            my $tag     = $button->{tag};
            my $event   = $button->{event};
            my $handler = $button->{handler};
            my $html    = $button->{html};
            $colspan    = 1 unless defined $colspan;
            $tag        = 'input' unless defined $tag;
            if(defined $name){
                $name = qq(name="$name");
            }else{
                $name = '';
            }
            if(defined $type){
                $type = qq(type="$type");
            }elsif($tag eq 'input'){
                $type = qq(type="submit");
            }else{
                $type = '';
            }
            if(defined $value){
                $value = qq(value="$value");
            }else{
                $value = '';
            }
            if(defined $class){
                $class = qq(class="$class");
            }else{
                $class = '';
            }
            if(defined $id){
                $id = qq(class="$id");
            }else{
                $id = '';
            }
            $event  = 'onclick' unless defined $event;
            my $event_spec = '';
            $event_spec = qq($event="$handler") if defined $handler;
            say "$indent    <td colspan=\"$colspan\">";
            if(defined $html){
                say "$indent        <$tag $name $type $class $id $event_spec $value>$html</$tag>";
            }else{
                say "$indent        <$tag $name $type $class $id $event_spec $value/>";
            }
            say "$indent    </td>";
        }
        say "$indent</tr>";
        if($form){
            say "$form_indent</form>";
        }
    } ## --- end sub bottom_buttons


    sub redirect {
        my ($self, $rec, $url) = @_;
        $rec->headers_out->set( Location => $url );
        $rec->status(Apache2::Const::REDIRECT);
        return 1;
    } ## --- end sub redirect


    sub insert_countries {
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

        my $dont_showdebug  = !$cfg->val('general', 'showdebug');

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

        $self->links('insert_countries', \%session);

        my $loggedin                  = $session{loggedin};
        my $loggedin_id               = $session{loggedin_id};
        my $loggedin_username         = $session{loggedin_username};
        my $loggedin_admin            = $session{loggedin_admin};
        my $loggedin_display_name     = $session{loggedin_display_name};
        my $loggedin_given            = $session{loggedin_given};
        my $loggedin_family           = $session{loggedin_family};
        my $loggedin_email            = $session{loggedin_email};
        my $loggedin_phone_number     = $session{loggedin_phone_number};
        my $loggedin_groupname        = $session{loggedin_groupname};
        my $loggedin_primary_group_id = $session{loggedin_groupnname_id};

        my $submit               = $req->param('submit');
        my $name                 = $req->param('name');
        my $region               = $req->param('region');
        my $cc                   = $req->param('cc');
        my $country_prefix       = $req->param('country_prefix');
        my $landline_pattern     = $req->param('landline_pattern');
        my $mobile_pattern       = $req->param('mobile_pattern');
        my $landline_title       = $req->param('landline_title');
        my $mobile_title         = $req->param('mobile_title');
        my $landline_placeholder = $req->param('landline_placeholder');
        my $mobile_placeholder   = $req->param('mobile_placeholder');
        my $list                 = $req->param('list');
        $list                    =~ s/^\s+//;
        $list                    =~ s/\s+$//;
        my @prefixes;
        if($list eq ''){
            @prefixes = ('', );
        }else{
            @prefixes             = split m/\s*,\s*/, $list;
        }
        my $flag = qq(/flags/$cc.png);

        if($submit && $submit eq 'Insert'){
            my @msgs;
            my $return = 1;
            for my $prefix (@prefixes){
                my $landline_pattern_tmp     = $landline_pattern;
                my $mobile_pattern_tmp       = $mobile_pattern;
                my $landline_title_tmp       = $landline_title;
                my $mobile_title_tmp         = $mobile_title;
                my $landline_placeholder_tmp = $landline_placeholder;
                my $mobile_placeholder_tmp   = $mobile_placeholder;
                $landline_pattern_tmp     =~ s/\{country-prefix\}/$country_prefix/g;
                $landline_pattern_tmp     =~ s/\{prefix\}/$prefix/g;
                $mobile_pattern_tmp       =~ s/\{country-prefix\}/$country_prefix/g;
                $mobile_pattern_tmp       =~ s/\{prefix\}/$prefix/g;
                $landline_title_tmp       =~ s/\{country-prefix\}/$country_prefix/g;
                $landline_title_tmp       =~ s/\{prefix\}/$prefix/g;
                $mobile_title_tmp         =~ s/\{country-prefix\}/$country_prefix/g;
                $mobile_title_tmp         =~ s/\{prefix\}/$prefix/g;
                $landline_placeholder_tmp =~ s/\{country-prefix\}/$country_prefix/g;
                $landline_placeholder_tmp =~ s/\{prefix\}/$prefix/g;
                $mobile_placeholder_tmp   =~ s/\{country-prefix\}/$country_prefix/g;
                $mobile_placeholder_tmp   =~ s/\{prefix\}/$prefix/g;
                $region               = '' unless defined $region;
                $region               =~ s/^\s+//;
                $region               =~ s/\s+$//;
                my $name_region       = $name;
                $name_region         .= " => $region" if $region;
                my $rprefix           = "+$country_prefix$prefix";
                my $sql               = "INSERT INTO countries(cc, prefix, _name, _flag, landline_pattern, mobile_pattern, landline_title, mobile_title, landline_placeholder, mobile_placeholder)\n";
                $sql                 .= "VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?)\n"; 
                $sql                 .= "RETURNING id, cc, prefix, _name, _flag, landline_pattern, mobile_pattern, landline_title, mobile_title, landline_placeholder, mobile_placeholder;\n";
                my $query             = $db->prepare($sql);
                my $result;
                eval {
                    $result  = $query->execute($cc, $rprefix, $name_region, $flag, $landline_pattern_tmp, $mobile_pattern_tmp, $landline_title_tmp, $mobile_title_tmp, $landline_placeholder_tmp, $mobile_placeholder_tmp);
                };
                if($@){
                    push @msgs, "Error: INSERT INTO countries failed: $@";
                    $return  = 0;
                }
                if($result && $result != 0){
                    push @msgs, "INSERT INTO countries succeeded: $name_region, $cc, $rprefix";
                }else{
                    push @msgs, "Error: INSERT INTO countries failed: $sql";
                    $return = 0;
                }
            }
            #my ($self,    $cfg, $debug, $_session, $db, $fun,               $button_msg,                 $dont_do_form, @msgs) = @_;
            $self->message($cfg, $debug, \%session, $db, 'insert_countries', 'Insert some more countries', undef,        @msgs) if @msgs;
            return $return;
        }

        $name                 = 'Candda' unless defined $name;
        $region               = '' unless defined $region;
        $cc                   = 'CA' unless defined $cc;
        $country_prefix       = '1' unless defined $country_prefix;
        $landline_pattern     = '(?:\+?{country-prefix}[ -]?)?{prefix}[ -]?[2-9]\d{2}[ -]?\d{4}' unless defined $landline_pattern;
        $mobile_pattern       = '(?:\+?{country-prefix}[ -]?)?{prefix}[ -]?[2-9]\d{2}[ -]?\d{4}' unless defined $mobile_pattern;
        $landline_title       = 'Only +digits or local formats allowed i.e. +{country-prefix}{prefix}-234-1234 or {country-prefix}{prefix} 234 1234 or {prefix}-234-1234.' unless defined $landline_title;
        $mobile_title         = 'Only +digits or local formats allowed i.e. +{country-prefix}{prefix}-234-1234 or {country-prefix}{prefix} 234 1234 or {prefix}-234-1234.' unless defined $mobile_title;
        $landline_placeholder = '+{country-prefix}-{prefix}-234-1234|{country-prefix} {prefix} 234 1234|{prefix} 234 1234' unless defined $landline_placeholder;
        $mobile_placeholder   = '+{country-prefix}-{prefix}-234-1234|{country-prefix} {prefix} 234 1234|{prefix} 234 1234' unless defined $mobile_placeholder;
        $list                 = '' unless defined $list;

        $self->log(Data::Dumper->Dump([$cc, $country_prefix, $name, $flag, $landline_pattern, $mobile_pattern, $landline_title, $mobile_title, $landline_placeholder, $mobile_placeholder, $list],
                [qw(cc country_prefix name flag landline_pattern mobile_pattern landline_title mobile_title landline_placeholder mobile_placeholder cc)]));

        untie %session;
        $db->disconnect;

        say "        <form action=\"insert-countries.pl\" method=\"post\">";
        say "            <h1>Insert Countries</h1>";
        say "            <table>";
        say "                <tr>";
        say "                    <td>";
        say "                        <label for=\"name\">name: </label>";
        say "                    </td>";
        say "                    <td colspan=\"2\">";
        say "                        <input type=\"text\" name=\"name\" id=\"name\" placeholder=\"name\" value=\"$name\" size=\"120\"/>";
        say "                    </td>";
        say "                </tr>";
        say "                <tr>";
        say "                    <td>";
        say "                        <label for=\"region\">name: </label>";
        say "                    </td>";
        say "                    <td colspan=\"2\">";
        say "                        <input type=\"text\" name=\"region\" id=\"region\" placeholder=\"region\" value=\"$region\" size=\"120\"/>";
        say "                    </td>";
        say "                </tr>";
        say "                <tr>";
        say "                    <td>";
        say "                        <label for=\"cc\">Country Code: </label>";
        say "                    </td>";
        say "                    <td colspan=\"2\">";
        say "                        <input type=\"text\" name=\"cc\" id=\"cc\" placeholder=\"CC\" pattern=\"[A-Z]{2}\" title=\"only exactly 2 A-Z allowed\" value=\"$cc\" size=\"120\"/>";
        say "                    </td>";
        say "                </tr>";
        say "                <tr>";
        say "                    <td>";
        say "                        <label for=\"country_prefix\">Country Prefix: </label>";
        say "                    </td>";
        say "                    <td colspan=\"2\">";
        say "                        <input type=\"text\" name=\"country_prefix\" id=\"country_prefix\" placeholder=\"222\" pattern=\"[0-9]+\" title=\"only 0-9 allowed\" value=\"$country_prefix\"/>";
        say "                    </td>";
        say "                </tr>";
        say "                <tr>";
        say "                    <td>";
        say "                        <label for=\"landline_pattern\">Landline Pattern: </label>";
        say "                    </td>";
        say "                    <td colspan=\"2\">";
        say "                        <input type=\"text\" name=\"landline_pattern\" id=\"landline_pattern\" placeholder=\"landline_pattern\" value=\"$landline_pattern\"/>";
        say "                    </td>";
        say "                </tr>";
        say "                <tr>";
        say "                    <td>";
        say "                        <label for=\"mobile_pattern\">Mobile Pattern: </label>";
        say "                    </td>";
        say "                    <td colspan=\"2\">";
        say "                        <input type=\"text\" name=\"mobile_pattern\" id=\"mobile_pattern\" placeholder=\"mobile_pattern\" value=\"$mobile_pattern\"/>";
        say "                    </td>";
        say "                </tr>";
        say "                <tr>";
        say "                    <td>";
        say "                        <label for=\"landline_title\">landline_title: </label>";
        say "                    </td>";
        say "                    <td colspan=\"2\">";
        say "                        <input type=\"text\" name=\"landline_title\" id=\"landline_title\" placeholder=\"landline_title\" value=\"$landline_title\"/>";
        say "                    </td>";
        say "                </tr>";
        say "                <tr>";
        say "                    <td>";
        say "                        <label for=\"mobile_title\">Mobile Title: </label>";
        say "                    </td>";
        say "                    <td colspan=\"2\">";
        say "                        <input type=\"text\" name=\"mobile_title\" id=\"mobile_title\" placeholder=\"mobile_title\" value=\"$mobile_title\"/>";
        say "                    </td>";
        say "                </tr>";
        say "                <tr>";
        say "                    <td>";
        say "                        <label for=\"landline_placeholder\">Landline Placeholder: </label>";
        say "                    </td>";
        say "                    <td colspan=\"2\">";
        say "                        <input type=\"text\" name=\"landline_placeholder\" id=\"landline_placeholder\" placeholder=\"landline_placeholder\" value=\"$landline_placeholder\"/>";
        say "                    </td>";
        say "                </tr>";
        say "                <tr>";
        say "                    <td>";
        say "                        <label for=\"mobile_placeholder\">Mobile Placeholder: </label>";
        say "                    </td>";
        say "                    <td colspan=\"2\">";
        say "                        <input type=\"text\" name=\"mobile_placeholder\" id=\"mobile_placeholder\" placeholder=\"mobile_placeholder\" value=\"$mobile_placeholder\"/>";
        say "                    </td>";
        say "                </tr>";
        say "                <tr>";
        say "                    <td>";
        say "                        <label for=\"list\">Prefixes: </label>";
        say "                    </td>";
        say "                    <td colspan=\"2\">";
        say "                        <input type=\"text\" name=\"list\" id=\"list\" placeholder=\"num, num, ...\" value=\"$list\" pattern=\"\\s*\\d+(?:\\s*,\\s*\\d+)*\\s*\" title=\"num, num,  ...\"/>";
        say "                    </td>";
        say "                </tr>";
        my @buttons = ({tag => 'input', name => 'submit', type => 'submit', value => 'Insert', }, );
        $self->bottom_buttons($debug, $dont_showdebug, undef, 16, @buttons);
        #say "                <tr>";
        #say "                    <td>";
        #if($debug){
        #    say "                        <label for=\"debug\"><div class=\"ex\"><input name=\"debug\" id=\"debug\" type=\"radio\" value=\"1\" checked> debug</div></label>";
        #    say "                    </td>";
        #    say "                    <td>";
        #    say "                        <label for=\"nodebug\"><div class=\"ex\"><input name=\"debug\" id=\"nodebug\" type=\"radio\" value=\"0\"> nodebug</div></label>";
        #}else{
        #    say "                        <label for=\"debug\"><div class=\"ex\"><input name=\"debug\" id=\"debug\" type=\"radio\" value=\"1\"> debug</div></label>";
        #    say "                    </td>";
        #    say "                    <td>";
        #    say "                        <label for=\"nodebug\"><div class=\"ex\"><input name=\"debug\" id=\"nodebug\" type=\"radio\" value=\"0\" checked> nodebug</div></label>";
        #}
        #say "                    </td>";
        #say "                    <td>";
        #say "                        <input name=\"submit\" type=\"submit\" value=\"Add\">";
        #say "                    </td>";
        #say "                </tr>";
        say "            </table>";
        say "        </form>";

        return 1;
    } ## --- end sub insert_countries


    sub update_countries {
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

        my $dont_showdebug  = !$cfg->val('general', 'showdebug');

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

        $self->links('update_countries', \%session);

        my $loggedin                  = $session{loggedin};
        my $loggedin_id               = $session{loggedin_id};
        my $loggedin_username         = $session{loggedin_username};
        my $loggedin_admin            = $session{loggedin_admin};
        my $loggedin_display_name     = $session{loggedin_display_name};
        my $loggedin_given            = $session{loggedin_given};
        my $loggedin_family           = $session{loggedin_family};
        my $loggedin_email            = $session{loggedin_email};
        my $loggedin_phone_number     = $session{loggedin_phone_number};
        my $loggedin_groupname        = $session{loggedin_groupname};
        my $loggedin_primary_group_id = $session{loggedin_groupnname_id};

        my $submit               = $req->param('submit');
        my $cc_id                = $req->param('id');
        my $cc                   = $req->param('cc');
        my $prefix               = $req->param('prefix');
        my $name                 = $req->param('name');
        my $_flag                = $req->param('_flag');
        my $landline_pattern     = $req->param('landline_pattern');
        my $mobile_pattern       = $req->param('mobile_pattern');
        my $landline_title       = $req->param('landline_title');
        my $mobile_title         = $req->param('mobile_title');
        my $landline_placeholder = $req->param('landline_placeholder');
        my $mobile_placeholder   = $req->param('mobile_placeholder');

        my $page_length = $req->param('page_length');
        $page_length = $session{page_length} if !defined $page_length && exists $session{page_length};
        $page_length    = 25 if !defined $page_length || $page_length < 10 || $page_length > 180;
        $session{page_length} = $page_length;

        my @countries;
        my $sql                  = "SELECT\n";
        $sql                    .= "    c.id, c.cc, c.prefix, c._name, c._flag, c.landline_pattern, c.mobile_pattern,\n";
        $sql                    .= "    c.landline_title, c.mobile_title, c.landline_placeholder, c.mobile_placeholder\n";
        $sql                    .= "FROM countries c\n";
        $sql                    .= "ORDER BY c._name;\n";
        my $query                = $db->prepare($sql);
        my $result               = $query->execute();
        my $r                    = $query->fetchrow_hashref();
        while($r){
            push @countries, $r;
            $r                   = $query->fetchrow_hashref();
        }
        $query->finish();

        if($submit && $submit eq 'Update' && $cc_id){
            my @msgs;
            my $return = 1;
            my $sql                      = "UPDATE countries SET cc = ?, prefix = ?, _name =?, _flag = ?, landline_pattern = ?, mobile_pattern = ?, landline_title = ?, mobile_title = ?, landline_placeholder = ?, mobile_placeholder = ?\n";
            $sql                        .= "WHERE id = ?\n"; 
            $sql                        .= "RETURNING id, cc, prefix, _name, _flag, landline_pattern, mobile_pattern, landline_title, mobile_title, landline_placeholder, mobile_placeholder;\n";
            my $query                    = $db->prepare($sql);
            my $result;
            eval {
                $result                  = $query->execute($cc, $prefix, $name, $_flag, $landline_pattern, $mobile_pattern, $landline_title, $mobile_title, $landline_placeholder, $mobile_placeholder, $cc_id);
            };
            if($@){
                push @msgs, "Error: UPDATE countries failed: $@";
                $return  = 0;
            }
            if($result && $result != 0){
                $r                   = $query->fetchrow_hashref();
                push @msgs, "UPDATE countries: success:", Data::Dumper->Dump([$r], [qw(r)]);
            }else{
                push @msgs, "Error: UPDATE countries failed: $sql";
                $return = 0;
            }
            $query->finish();
            #my ($self,    $cfg, $debug, $_session, $db, $fun,               $button_msg,                  $dont_do_form, @msgs) = @_;
            $self->message($cfg, $debug, \%session, $db, 'update_countries', 'Update some more countries', $return,       @msgs) if @msgs;
            return $return unless $return;
        }

        $cc_id                = '' unless defined $id;
        $cc                   = '' unless defined $cc;
        $prefix               = '' unless defined $prefix;
        $name                 = '' unless defined $name;
        $_flag                = '/flags/AU.png' unless $_flag;
        $landline_pattern     = '' unless defined $landline_pattern;
        $mobile_pattern       = '' unless defined $mobile_pattern;
        $landline_title       = '' unless defined $landline_title;
        $mobile_title         = '' unless defined $mobile_title;
        $landline_placeholder = '' unless defined $landline_placeholder;
        $mobile_placeholder   = '' unless defined $mobile_placeholder;

        $self->log(Data::Dumper->Dump([\@countries, $cc_id, $cc, $prefix, $name, $_flag, $landline_pattern, $mobile_pattern, $landline_title, $mobile_title, $landline_placeholder, $mobile_placeholder],
                [qw(@countries cc_id cc prefix name _flag landline_pattern mobile_pattern landline_title mobile_title landline_placeholder mobile_placeholder)]));

        untie %session;
        $db->disconnect;

        say "        <form action=\"update-countries.pl\" method=\"post\" class=\"exh\">";
        say "            <h1>Update Countries</h1>";
        say "            <table>";
        say "                <tr>";
        say "                    <td>";
        say "                        <label for=\"page_length\">Page Length:";
        say "                            <input type=\"number\" name=\"page_length\" id=\"page_length\" min=\"10\" max=\"180\" step=\"1\" value=\"$page_length\" size=\"3\">";
        say "                        </label>";
        say "                    </td>";
        say "                    <td colspan=\"2\">";
        say "                        <input type=\"submit\" name=\"submit\" id=\"set_page_length\" value=\"Set Page Length\" />";
        say "                    </td>";
        say "                </tr>";
        say "                <tr>";
        say "                    <td>";
        say "                        <label for=\"id\">ID</label>";
        say "                    </td>";
        say "                    <td colspan=\"2\">";
        say "                        <input type=\"text\" name=\"id\" id=\"id\" value=\"$cc_id\" readonly=\"readonly\"/>";
        say "                    </td>";
        say "                </tr>";
        say "                <tr>";
        say "                    <td>";
        say "                        <label for=\"cc\">Country Code</label>";
        say "                    </td>";
        say "                    <td colspan=\"2\">";
        say "                        <input type=\"text\" name=\"cc\" id=\"cc\" value=\"$cc\"/>";
        say "                    </td>";
        say "                </tr>";
        say "                <tr>";
        say "                    <td>";
        say "                        <label for=\"prefix\">Prefix</label>";
        say "                    </td>";
        say "                    <td colspan=\"2\">";
        say "                        <input type=\"text\" name=\"prefix\" id=\"prefix\" value=\"$prefix\"/>";
        say "                    </td>";
        say "                </tr>";
        say "                <tr>";
        say "                    <td>";
        say "                        <label for=\"name\">Name</label>";
        say "                    </td>";
        say "                    <td colspan=\"2\">";
        say "                        <input type=\"text\" name=\"name\" id=\"name\" value=\"$name\"/>";
        say "                    </td>";
        say "                </tr>";
        say "                <tr>";
        say "                    <td>";
        say "                        <label for=\"_flag\">Flag: <img id=\"the_flag\" src=\"$_flag\" alt=\"$_flag\"/></label>";
        say "                    </td>";
        say "                    <td colspan=\"2\">";
        say "                        <input type=\"text\" name=\"_flag\" id=\"_flag\" value=\"$_flag\"/>";
        say "                    </td>";
        say "                </tr>";
        say "                <tr>";
        say "                    <td>";
        say "                        <label for=\"landline_pattern\">Landline Pattern</label>";
        say "                    </td>";
        say "                    <td colspan=\"2\">";
        say "                        <input type=\"text\" name=\"landline_pattern\" id=\"landline_pattern\" value=\"$landline_pattern\" size=\"120\"/>";
        say "                    </td>";
        say "                </tr>";
        say "                <tr>";
        say "                    <td>";
        say "                        <label for=\"mobile_pattern\">Mobile Pattern</label>";
        say "                    </td>";
        say "                    <td colspan=\"2\">";
        say "                        <input type=\"text\" name=\"mobile_pattern\" id=\"mobile_pattern\" value=\"$mobile_pattern\"/>";
        say "                    </td>";
        say "                </tr>";
        say "                <tr>";
        say "                    <td>";
        say "                        <label for=\"landline_title\">Landline Title</label>";
        say "                    </td>";
        say "                    <td colspan=\"2\">";
        say "                        <input type=\"text\" name=\"landline_title\" id=\"landline_title\" value=\"$landline_title\"/>";
        say "                    </td>";
        say "                </tr>";
        say "                <tr>";
        say "                    <td>";
        say "                        <label for=\"mobile_title\">Mobile Title</label>";
        say "                    </td>";
        say "                    <td colspan=\"2\">";
        say "                        <input type=\"text\" name=\"mobile_title\" id=\"mobile_title\" value=\"$mobile_title\"/>";
        say "                    </td>";
        say "                </tr>";
        say "                <tr>";
        say "                    <td>";
        say "                        <label for=\"landline_placeholder\">Landline Placeholder</label>";
        say "                    </td>";
        say "                    <td colspan=\"2\">";
        say "                        <input type=\"text\" name=\"landline_placeholder\" id=\"landline_placeholder\" value=\"$landline_placeholder\"/>";
        say "                    </td>";
        say "                </tr>";
        say "                <tr>";
        say "                    <td>";
        say "                        <label for=\"mobile_placeholder\">Mobile Placeholder</label>";
        say "                    </td>";
        say "                    <td colspan=\"2\">";
        say "                        <input type=\"text\" name=\"mobile_placeholder\" id=\"mobile_placeholder\" value=\"$mobile_placeholder\"/>";
        say "                    </td>";
        say "                </tr>";
        my @buttons = ({tag => 'input', name => 'submit', type => 'submit', value => 'Update', colspan => 1, }, );
        $self->bottom_buttons($debug, $dont_showdebug, undef, 16, @buttons);
        say "            </table>";
        say "            <table class=\"exh\">";
        say "                <tr><th>id</th><th>cc</th><th>prefix</th><th>name</th><th>flag</th><th>landline_pattern</th><th>mobile_pattern</th><th>landline_title</th><th>mobile_title</th><th>landline_placeholder</th><th>mobile_placeholder</th></tr>";
        my $cnt = 0;
        for my $region (@countries){
            $cnt++;
            my $id                       = $region->{id};
            my $cc                       = $region->{cc};
            my $prefix                   = $region->{prefix};
            my $name                     = $region->{_name};
            my $_flag                    = $region->{_flag};
            my $landline_pattern         = $region->{landline_pattern};
            my $mobile_pattern           = $region->{mobile_pattern};
            my $landline_title           = $region->{landline_title};
            my $mobile_title             = $region->{mobile_title};
            my $landline_placeholder     = $region->{landline_placeholder};
            my $mobile_placeholder       = $region->{mobile_placeholder};
            say "                <tr class=\"exh\">";
            say "                    <td class=\"exh\">";
            say "                        <button type=\"button\" class=\"ex exh\" onclick=\"on_country_click($id)\"><div class=\"exh\">$id</div></button>";
            say "                    </td>";
            say "                    <td class=\"exh\">";
            say "                        <button type=\"button\" class=\"ex exh\" onclick=\"on_country_click($id)\"><div class=\"exh\">$cc</div></button>";
            say "                    </td>";
            say "                    <td class=\"exh\">";
            say "                        <button type=\"button\" class=\"ex exh\" onclick=\"on_country_click($id)\"><div class=\"exh\">$prefix</div></button>";
            say "                    </td>";
            say "                    <td class=\"exh\">";
            say "                        <button type=\"button\" class=\"ex exh\" onclick=\"on_country_click($id)\"><div class=\"exh\">$name</div></button>";
            say "                    </td>";
            say "                    <td class=\"exh\">";
            say "                        <button type=\"button\" class=\"ex exh\" onclick=\"on_country_click($id)\"><div class=\"exh\"><img src=\"$_flag\" alt=\"$_flag\"/></div></button>";
            say "                    </td>";
            say "                    <td class=\"exh\">";
            say "                        <button type=\"button\" class=\"ex exh\" onclick=\"on_country_click($id)\"><div class=\"exh\">$landline_pattern</div></button>";
            say "                    </td>";
            say "                    <td class=\"exh\">";
            say "                        <button type=\"button\" class=\"ex exh\" onclick=\"on_country_click($id)\"><div class=\"exh\">$mobile_pattern</div></button>";
            say "                    </td>";
            say "                    <td class=\"exh\">";
            say "                        <button type=\"button\" class=\"ex exh\" onclick=\"on_country_click($id)\"><div class=\"exh\">$landline_title</div></button>";
            say "                    </td>";
            say "                    <td class=\"exh\">";
            say "                        <button type=\"button\" class=\"ex exh\" onclick=\"on_country_click($id)\"><div class=\"exh\">$mobile_title</div></button>";
            say "                    </td>";
            say "                    <td class=\"exh\">";
            say "                        <button type=\"button\" class=\"ex exh\" onclick=\"on_country_click($id)\"><div class=\"exh\">$landline_placeholder</div></button>";
            say "                    </td>";
            say "                    <td class=\"exh\">";
            say "                        <button type=\"button\" class=\"ex exh\" onclick=\"on_country_click($id)\"><div class=\"exh\">$mobile_placeholder</div></button>";
            say "                    </td>";
            say "                </tr>";
            if($cnt % $page_length == 0){
                say "            <tr><th>id</th><th>cc</th><th>prefix</th><th>name</th><th>flag</th><th>landline_pattern</th><th>mobile_pattern</th><th>landline_title</th><th>mobile_title</th><th>landline_placeholder</th><th>mobile_placeholder</th></tr>";
            }
        }
        say "            </table>";
        say "            <script>";
        say "                function on_country_click(id){";
        say "                    var countries = {";
        $cnt = 0;
        for my $region (@countries){
            $cnt++;
            my $id                       = $region->{id};
            my $cc                       = $region->{cc};
            my $prefix                   = $region->{prefix};
            my $name                     = $region->{_name};
            my $_flag                    = $region->{_flag};
            my $landline_pattern         = $region->{landline_pattern};
            $landline_pattern            =~ s/\\/\\\\/g;
            my $mobile_pattern           = $region->{mobile_pattern};
            $mobile_pattern              =~ s/\\/\\\\/g;
            my $landline_title           = $region->{landline_title};
            my $mobile_title             = $region->{mobile_title};
            my $landline_placeholder     = $region->{landline_placeholder};
            my $mobile_placeholder       = $region->{mobile_placeholder};
            say "                                        \"$id\": {";
            say "                                                    \"cc\": \"$cc\",";
            say "                                                    \"prefix\": \"$prefix\",";
            say "                                                    \"_name\": \"$name\",";
            say "                                                    \"_flag\": \"$_flag\",";
            say "                                                    \"landline_pattern\": \"$landline_pattern\",";
            say "                                                    \"mobile_pattern\": \"$mobile_pattern\",";
            say "                                                    \"landline_title\": \"$landline_title\",";
            say "                                                    \"mobile_title\": \"$mobile_title\",";
            say "                                                    \"landline_placeholder\": \"$landline_placeholder\",";
            say "                                                    \"mobile_placeholder\": \"$mobile_placeholder\",";
            say "                                                 },";
        }
        say "                                    };";
        say "                    var cc                           = countries['' + id]['cc'];";
        say "                    var prefix                       = countries['' + id]['prefix'];";
        say "                    var _name                        = countries['' + id]['_name'];";
        say "                    var _flag                        = countries['' + id]['_flag'];";
        say "                    var landline_pattern             = countries['' + id]['landline_pattern'];";
        say "                    var mobile_pattern               = countries['' + id]['mobile_pattern'];";
        say "                    var landline_title               = countries['' + id]['landline_title'];";
        say "                    var mobile_title                 = countries['' + id]['mobile_title'];";
        say "                    var landline_placeholder         = countries['' + id]['landline_placeholder'];";
        say "                    var mobile_placeholder           = countries['' + id]['mobile_placeholder'];";
        #say "                    alert('_name == ' + _name);";
        say "                    var input_id                     = document.getElementById('id');";
        say "                    var input_cc                     = document.getElementById('cc');";
        say "                    var input_prefix                 = document.getElementById('prefix');";
        say "                    var input_name                   = document.getElementById('name');";
        say "                    var input_the_flag               = document.getElementById('the_flag');";
        say "                    var input_flag                   = document.getElementById('_flag');";
        say "                    var input_landline_pattern       = document.getElementById('landline_pattern');";
        say "                    var input_mobile_pattern         = document.getElementById('mobile_pattern');";
        say "                    var input_landline_title         = document.getElementById('landline_title');";
        say "                    var input_mobile_title           = document.getElementById('mobile_title');";
        say "                    var input_landline_placeholder   = document.getElementById('landline_placeholder');";
        say "                    var input_mobile_placeholder     = document.getElementById('mobile_placeholder');";
        say "                    var page_length                  = document.getElementById('page_length');";
        #say "                    alert('_name == ' + _name);";
        say "                    input_id.value                   = id;";
        say "                    input_cc.value                   = cc;";
        say "                    input_prefix.value               = prefix;";
        say "                    input_name.value                 = _name;";
        say "                    input_the_flag.setAttribute(\"src\", _flag);";
        say "                    input_the_flag.setAttribute(\"alt\", _flag);";
        say "                    input_flag.value                 = _flag;";
        say "                    input_landline_pattern.value     = landline_pattern;";
        say "                    input_mobile_pattern.value       = mobile_pattern;";
        say "                    input_landline_title.value       = landline_title;";
        say "                    input_mobile_title.value         = mobile_title;";
        say "                    input_landline_placeholder.value = landline_placeholder;";
        say "                    input_mobile_placeholder.value   = mobile_placeholder;";
        #say "                    alert('_name == ' + _name);";
        say "                    page_length.focus();";
        say "                    var end = input_cc.value.length;";
        say "                    input_cc.setSelectionRange(end, end);";
        say "                    input_cc.focus();";
        #say "                    input_cc.select();";
        #say "                    return true;";
        say "                } // on_country_click(n) //";
        say "            </script>";
        say "        </form>";

        return 1;
    } ## --- end sub update_countries


    sub countries_transfer {
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

        my $dont_showdebug  = !$cfg->val('general', 'showdebug');

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

        $self->links('countries_transfer', \%session);

        my $loggedin                  = $session{loggedin};
        my $loggedin_id               = $session{loggedin_id};
        my $loggedin_username         = $session{loggedin_username};
        my $loggedin_admin            = $session{loggedin_admin};
        my $loggedin_display_name     = $session{loggedin_display_name};
        my $loggedin_given            = $session{loggedin_given};
        my $loggedin_family           = $session{loggedin_family};
        my $loggedin_email            = $session{loggedin_email};
        my $loggedin_phone_number     = $session{loggedin_phone_number};
        my $loggedin_groupname        = $session{loggedin_groupname};
        my $loggedin_primary_group_id = $session{loggedin_groupnname_id};

        my $submit               = $req->param('submit');
        my $cc                   = $req->param('cc');
        my $prefix               = $req->param('prefix');
        my $name                 = $req->param('name');
        my $_flag                = $req->param('_flag');
        my $_escape              = $req->param('_escape');
        my $landline_pattern     = $req->param('landline_pattern');
        my $mobile_pattern       = $req->param('mobile_pattern');
        my $landline_title       = $req->param('landline_title');
        my $mobile_title         = $req->param('mobile_title');
        my $landline_placeholder = $req->param('landline_placeholder');
        my $mobile_placeholder   = $req->param('mobile_placeholder');

        my $page_length = $req->param('page_length');
        $page_length = $session{page_length} if !defined $page_length && exists $session{page_length};
        $page_length    = 25 if !defined $page_length || $page_length < 10 || $page_length > 180;
        $session{page_length} = $page_length;

        my @country;
        my @msgs;
        my $return = 1;
        my $sql  = "SELECT c.cc, c._flag, SUBSTRING(c._name, 0, (CASE WHEN STRPOS(c._name, ' =>') = 0 THEN CHAR_LENGTH(c._name) + 1 ELSE STRPOS(c._name, ' =>') END)) c_name\n";
        $sql    .= "FROM countries c\n";
        $sql    .= "GROUP BY c.cc, c._flag, c_name\n";
        $sql    .= "ORDER BY c_name\n";
        my $query                    = $db->prepare($sql);
        my $result;
        eval {
            $result                  = $query->execute();
        };
        if($@){
            push @msgs, "Error: SELECT countries failed: $@";
            $return  = 0;
        }
        if($result && $result != 0){
            my $r                   = $query->fetchrow_hashref();
            $self->log(Data::Dumper->Dump([$query, $result, $r, $sql], [qw(query result r sql)]));
            while($r){
                push @country, $r;
                $r                  = $query->fetchrow_hashref();
            }
        }else{
            push @msgs, "Error: SELECT countries failed: $sql";
            $return = 0;
        }
        $query->finish();
        $self->log(Data::Dumper->Dump([\@country], [qw(@country)]));
        #my ($self,    $cfg, $debug, $_session, $db, $fun,                  $button_msg,                  $dont_do_form, @msgs) = @_;
        $self->message($cfg, $debug, \%session, $db, 'countries_transfer', 'Transfer some more countries', $return,       @msgs) if @msgs;
        return $return unless $return;
        $self->log(Data::Dumper->Dump([$submit, $cc], [qw(submit cc)]));
        if($submit && $submit eq 'Update' && $cc){
            my @msgs;
            my $return = 1;
            my %countries;
            my $sql  = "SELECT c.id, c.cc, c.prefix, c._name, _flag, _escape, landline_pattern, mobile_pattern, landline_title, mobile_title, landline_placeholder, mobile_placeholder\n";
            $sql    .= "FROM countries c\n";
            $sql    .= "WHERE c.prefix LIKE ?\n";
            my $query                    = $db->prepare($sql);
            my $result;
            eval {
                $result                  = $query->execute("+$prefix%");
            };
            if($@){
                push @msgs, "Error: UPDATE countries failed: $@";
                $return  = 0;
            }
            if($result && $result != 0){
                my $r                   = $query->fetchrow_hashref();
                while($r){
                    my $cc             = $r->{cc};
                    my $distinguishing = $r->{prefix};
                    $distinguishing    =~ s/^+$prefix//;
                    my $_name          = $r->{_name};
                    my $name;
                    my $region;
                    my $_flag          = $r->{_flag};
                    my $escape         = $r->{_escape};
                    $countries{$cc}    = { _flag => $_flag, _escape => $escape, country_regions => [ ], } unless exists $countries{$cc};
                    if($_name =~ m/^\s*([^=]+)\s*(?:=>\s*(.*)\s*)?$/){
                        $name   = $1;
                        $region = $2;
                        $name   =~ s/\s+$//;
                        $name   =~ s/^\s+//;
                        if(defined $region){
                            $region =~ s/\s+$//;
                            $region =~ s/^\s+//;
                        }
                        $countries{$cc}->{_name} = $name;
                        my $landline_pattern     = $r->{landline_pattern};
                        my $mobile_pattern       = $r->{mobile_pattern};
                        my $landline_title       = $r->{landline_title};
                        my $mobile_title         = $r->{mobile_title};
                        my $landline_placeholder = $r->{landline_placeholder};
                        my $mobile_placeholder   = $r->{mobile_placeholder};
                        push @{$countries{$cc}->{country_regions}}, {   distinguishing => $distinguishing,
                                                                        region => $region,
                                                                        landline_pattern => $landline_pattern,
                                                                        mobile_pattern => $mobile_pattern,
                                                                        landline_title => $landline_title,
                                                                        mobile_title => $mobile_title,
                                                                        landline_placeholder => $landline_placeholder,
                                                                        mobile_placeholder => $mobile_placeholder,
                                                                    };
                    }
                    $r                  = $query->fetchrow_hashref();
                }
                $query->finish();
                for my $cc (keys %countries){
                    my $name             = $countries{$cc}->{_name};
                    my $_flag            = $countries{$cc}->{_flag};
                    my $_escape          = $countries{$cc}->{_escape};
                    my $country_regions  = $countries{$cc}->{country_regions};
                    $sql  = "INSERT INTO country(cc, _name, _flag, _escape, prefix)\n";
                    $sql .= "VALUES(?, ?, ?, ?, ?)\n";
                    $sql .= "ON CONFLICT DO NOTHING\n";
                    $sql .= "RETURNING id\n";
                    eval {
                        $result              = $query->execute($cc, $name, $_flag, $_escape);
                    };
                    if($@){
                        push @msgs, "Error: INSERT INTO country failed: $@";
                        $return  = 0;
                    }
                    if($result && $result != 0){
                        $r                   = $query->fetchrow_hashref();
                        my $cc_id            = $r->{id};
                        $query->finish();
                        for my $row (@{$country_regions}){
                            my $distinguishing       = $row->{distinguishing};
                            my $landline_pattern     = $row->{landline_pattern};
                            my $mobile_pattern       = $row->{mobile_pattern};
                            my $landline_title       = $row->{landline_title};
                            my $mobile_title         = $row->{mobile_title};
                            my $landline_placeholder = $row->{landline_placeholder};
                            my $mobile_placeholder   = $row->{mobile_placeholder};
                            my $region               = $row->{region};
                            $sql .= "INSERT INTO country_regions(country_id, distinguishing, landline_pattern, mobile_pattern, landline_title, mobile_title, landline_placeholder, mobile_placeholder, region)\n";
                            $sql  = "VALUES(                       ?,              ?,               ?,               ?,                ?,             ?,             ?,                  ?,               ?)\n";
                            $sql  = "RETURNING id, country_id, distinguishing, landline_pattern, mobile_pattern, landline_title, mobile_title, landline_placeholder, mobile_placeholder, region;\n";
                            eval {
                                $result           = $query->execute($cc_id, $distinguishing, $landline_pattern, $mobile_pattern, $landline_title, $mobile_title, $landline_placeholder, $mobile_placeholder, $region);
                            };
                            if($@){
                                push @msgs, "Error: INSERT INTO country_regions failed: $@";
                                $return  = 0;
                            }
                            if($result && $result != 0){
                            }else{
                                push @msgs, "Error: INSERT INTO country_regions failed: $sql";
                                $return  = 0;
                            }
                        }
                    }else{
                        push @msgs, "Error: INSERT INTO country failed: $sql";
                        $return  = 0;
                    }
                }
            }else{
                push @msgs, "Error: UPDATE countries failed: $sql";
                $return = 0;
            }
            $query->finish();
            #my ($self,    $cfg, $debug, $_session, $db, $fun,               $button_msg,                  $dont_do_form, @msgs) = @_;
            $self->message($cfg, $debug, \%session, $db, 'update_countries', 'Update some more countries', $return,       @msgs) if @msgs;
            return $return unless $return;
        }

        untie %session;
        $db->disconnect;

        $cc                   = 'US' unless defined $cc;
        $prefix               = 1 unless defined $prefix;
        $name                 = 'United States' unless defined $name;
        $_flag                = '/flags/US.png' unless $_flag;
        $landline_pattern     = '(?:\+?{country-prefix}[ -]?)?{prefix}[ -]?[2-9]\d{2}[ -]?\d{4}' unless defined $landline_pattern;
        $mobile_pattern       = '(?:\+?{country-prefix}[ -]?)?{prefix}[ -]?[2-9]\d{2}[ -]?\d{4}' unless defined $mobile_pattern;
        $landline_title       = 'Only +digits or local formats allowed i.e. +{country-prefix}{prefix}-234-1234 or {country-prefix}{prefix} 234 1234 or {prefix}-234-1234.' unless defined $landline_title;
        $mobile_title         = 'Only +digits or local formats allowed i.e. +{country-prefix}{prefix}-234-1234 or {country-prefix}{prefix} 234 1234 or {prefix}-234-1234.' unless defined $mobile_title;
        $landline_placeholder = '+{country-prefix}-{prefix}-234-1234|{country-prefix} {prefix} 234 1234|{prefix} 234 1234' unless defined $landline_placeholder;
        $mobile_placeholder   = '+{country-prefix}-{prefix}-234-1234|{country-prefix} {prefix} 234 1234|{prefix} 234 1234' unless defined $mobile_placeholder;

        say "        <form action=\"countries-transfer.pl\" method=\"post\">";
        say "            <h1>Update Country</h1>";
        say "            <table>";
        say "                <tr>";
        say "                    <td>";
        say "                        <label for=\"page_length\">Page Length:";
        say "                            <input type=\"number\" name=\"page_length\" id=\"page_length\" min=\"10\" max=\"180\" step=\"1\" value=\"$page_length\" size=\"3\">";
        say "                        </label>";
        say "                    </td>";
        say "                    <td colspan=\"2\">";
        say "                        <input type=\"submit\" name=\"submit\" id=\"set_page_length\" value=\"Set Page Length\" />";
        say "                    </td>";
        say "                </tr>";
        say "                <tr>";
        say "                    <td>";
        say "                        <label for=\"cc\">Country Code</label>";
        say "                    </td>";
        say "                    <td colspan=\"2\">";
        say "                        <select name=\"cc\" id=\"cc\" onchange=\"country_onchange()\" is=\"ms-dropdown\">";
        for my $row (@country){
            my $_cc     = $row->{cc};
            my $_flag   = $row->{_flag};
            my $c_name  = $row->{c_name};
            if($_cc eq $cc){
                #$flag   = $_flag;
                say "                                <option value=\"$_cc\" data-image=\"$_flag\" selected=\"selected\">$c_name: $_cc</option>";
            }else{
                say "                                <option value=\"$_cc\" data-image=\"$_flag\">$c_name: $_cc</option>";
            }
        }
        say "                        </select>";
        say "                        <script>";
        say "                            function country_onchange() {";
        say "                                var country   = {";
        for my $row (@country){
            my $_cc     = $row->{cc};
            my $_flag   = $row->{_flag};
            my $c_name  = $row->{c_name};
            say "                                                    \"$_cc\": { \"_flag\": \"$_flag\", \"c_name\": \"$c_name\", },";
        }
        say "                                                }";
        say "                                var cc_id_elt = document.getElementById('cc');";
        say "                                var cc = cc_id_elt.value;";
        #say "                                alert(\"countries_id == \" + countries_id);";
        say "                                var flag = country[cc]['_flag'];";
        say "                                var name = country[cc]['c_name'];";
        say "                                var flag_elt = document.getElementById('_flag');";
        say "                                var flag_img_elt = document.getElementById('flag_img');";
        say "                                var name_elt     = document.getElementById('name');";
        say "                                flag_elt.value = flag;";
        say "                                flag_img_elt.setAttribute('src', flag);";
        say "                                flag_img_elt.setAttribute('alt', flag);";
        say "                                name_elt.value = name;";
        say "                            }";
        say "                        </script>";
        say "                        <script src=\"https://cdn.jsdelivr.net/npm/ms-dropdown\@4.0.3/dist/js/dd.min.js\"></script>";
        say "                    </td>";
        say "                </tr>";
        say "                <tr>";
        say "                    <td>";
        say "                        <label for=\"prefix\">Prefix</label>";
        say "                    </td>";
        say "                    <td colspan=\"2\">";
        say "                        <input type=\"text\" name=\"prefix\" id=\"prefix\" value=\"$prefix\"/>";
        say "                    </td>";
        say "                </tr>";
        say "                <tr>";
        say "                    <td>";
        say "                        <label for=\"name\">Name</label>";
        say "                    </td>";
        say "                    <td colspan=\"2\">";
        say "                        <input type=\"text\" name=\"name\" id=\"name\" value=\"$name\"/>";
        say "                    </td>";
        say "                </tr>";
        say "                <tr>";
        say "                    <td>";
        say "                        <label for=\"_flag\">Flag: <img src=\"$_flag\" alt=\"$_flag\" id=\"flag_img\"/></label>";
        say "                    </td>";
        say "                    <td colspan=\"2\">";
        say "                        <input type=\"text\" name=\"_flag\" id=\"_flag\" value=\"$_flag\"/>";
        say "                    </td>";
        say "                </tr>";
        say "                <tr>";
        my $val = "";
        if(defined $_escape){
            my $val = "value=\"$_escape\"";
        }
        say "                    <td>";
        say "                        <label for=\"_escape\">Escape:</label>";
        say "                    </td>";
        say "                    <td colspan=\"2\">";
        say "                        <input type=\"text\" name=\"_escape\" id=\"_escape\" size=\"120\" $val/>";
        say "                    </td>";
        say "                </tr>";
        say "                <tr>";
        say "                    <td>";
        say "                        <label for=\"landline_pattern\">Landline Pattern</label>";
        say "                    </td>";
        say "                    <td colspan=\"2\">";
        say "                        <input type=\"text\" name=\"landline_pattern\" id=\"landline_pattern\" size=\"120\" value=\"$landline_pattern\"/>";
        say "                    </td>";
        say "                </tr>";
        say "                <tr>";
        say "                    <td>";
        say "                        <label for=\"mobile_pattern\">Mobile Pattern</label>";
        say "                    </td>";
        say "                    <td colspan=\"2\">";
        say "                        <input type=\"text\" name=\"mobile_pattern\" id=\"mobile_pattern\" value=\"$mobile_pattern\"/>";
        say "                    </td>";
        say "                </tr>";
        say "                <tr>";
        say "                    <td>";
        say "                        <label for=\"landline_title\">Landline Title</label>";
        say "                    </td>";
        say "                    <td colspan=\"2\">";
        say "                        <input type=\"text\" name=\"landline_title\" id=\"landline_title\" value=\"$landline_title\"/>";
        say "                    </td>";
        say "                </tr>";
        say "                <tr>";
        say "                    <td>";
        say "                        <label for=\"mobile_title\">Mobile Title</label>";
        say "                    </td>";
        say "                    <td colspan=\"2\">";
        say "                        <input type=\"text\" name=\"mobile_title\" id=\"mobile_title\" value=\"$mobile_title\"/>";
        say "                    </td>";
        say "                </tr>";
        say "                <tr>";
        say "                    <td>";
        say "                        <label for=\"landline_placeholder\">Landline Placeholder</label>";
        say "                    </td>";
        say "                    <td colspan=\"2\">";
        say "                        <input type=\"text\" name=\"landline_placeholder\" id=\"landline_placeholder\" value=\"$landline_placeholder\"/>";
        say "                    </td>";
        say "                </tr>";
        say "                <tr>";
        say "                    <td>";
        say "                        <label for=\"mobile_placeholder\">Mobile Placeholder</label>";
        say "                    </td>";
        say "                    <td colspan=\"2\">";
        say "                        <input type=\"text\" name=\"mobile_placeholder\" id=\"mobile_placeholder\" value=\"$mobile_placeholder\"/>";
        say "                    </td>";
        say "                </tr>";
        my @buttons = ({tag => 'input', name => 'submit', type => 'submit', value => 'Update', colspan => 1, }, );
        $self->bottom_buttons($debug, $dont_showdebug, undef, 16, @buttons);
        say "            </table>";
        say "        </form>";

        return 1;
    } ## --- end sub countries_transfer

}

1;
