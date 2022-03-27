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
use Apache2::Request;
use Data::Dumper;
use FileHandle;
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

    
    sub new {
        my ($class, $logpath, $cfg) = @_;
        #
        # make the actual object a so called blessed scalar #
        # slightly quirky but it works :)                   #
        my $new_object = bless anon_scalar(), $class;

        # get the instances idnet for referencing it's data #
        my $ident = ident $new_object;

        $logpaths{$ident} = $logpath;

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
        my $query  = $db.prepare('SELECT COUNT(*) n FROM page_view pv WHERE pv.section = ?;');
        my $result = $query->execute($section);
        my $r      = $query->fetchrow_hashref();
        my $n      = $r->{n};
        return $n;
    }


    sub main {
        my ($self, $req, $cfg, $rec) = @_;
        my $ident           = ident $self;
        my $current_page    = $req->param('page');
        $current_page       = 'pseudo-page^all' if !defined $current_page || $current_page =~ m/^\s*$/;
        my $current_section = $req->param('section');
        my $dbserver        = $cfg->val('urls_db', 'dbserver');
        my $dbuser          = $cfg->val('urls_db', 'dbuser');
        my $dbpass          = $cfg->val('urls_db', 'dbpass');
        my $dbname          = $cfg->val('urls_db', 'dbname');
        my $dbport          = $cfg->val('urls_db', 'dbport');
        #my $db              = DBI->connect("dbi:Pg:database=$dbname;host=$dbserver;port=$dbport;", "$dbuser", "$dbpass", {'RaiseError' => 1});
        #return 0;
        my $db              = DBI->connect("dbi:Pg:database=$dbname;host=$dbserver;port=$dbport;", "$dbuser", "$dbpass", {'RaiseError' => 1});
        my $sql             = "SELECT * FROM pagelike pl";
        $sql               .= "ORDER BY pl.name, pl.full_name";
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
        my @sections;
        $sql  = "SELECT al.type, al.section FROM alias_links al";
        $sql .= "ORDER BY al.section";
        $query           = $db->prepare($sql);
        $result          = $query->execute();
        $r                  = $query->fetchrow_hashref();
        while($r){
            push @sections, $r;
            $r           = $query->fetchrow_hashref();
        }
        $query->finish();
        my @body;
        if($current_page =~ m/^pseudo-page\^(.*)/){
            $sql    = "SELECT pp.name \"page_name\", pp.full_name, ls.section, l.name, l.link, pp.status FROM pseudo_pages pp JOIN links_sections ls ON ls.section ~* pp.pattern JOIN links l ON l.section_id = ls.id";
            $sql   .= "WHERE pp.name = ?";
            $sql   .= "ORDER BY pp.name, ls.section, l.name, l.link";
            $query  = $db->prepare($sql);
            $result = $query->execute($1);
            $r      = $query->fetchrow_hashref();
            while($r){
                my $page_name = $r->{page_name};
                my $full_name = $r->{full_name};
                my $section   = $r->{section};
                my $name      = $r->{name};
                my $link      = $r->{link};
                my $status    = $r->{status};
                next if $status eq 'invalid';
                next if $status eq 'unassigned' && in_a_page($section);
                next if $status eq 'assigned'   && !in_a_page($section);
                push @body, { page_name => $page_name, full_name => $full_name, section => $section, name => $name, link => $link, };
                $r  = $query->fetchrow_hashref();
            }
            $query->finish();
        }elsif($current_page =~ m/^page\^(.*)$/){
            $sql  = "SELECT lv.page_name, lv.full_name, lv.section, lv.name, lv.link FROM page_link_view lv";
            $sql .= "WHERE lv.page_name = ?";
            $sql .= "ORDER BY lv.page_name, lv.full_name, lv.section, lv.name, lv.link;";
            $result = $query->execute($1);
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

        say "            <form action=\"/grizzly\" method=\"POST\">";
        say "                <h1>Urls</h1>";
        say "                <table>";
        say "                    <tr>";
        say "                        <td>";
        say "                            <select name=\"page\">";
        for my $page (@pages){
            my $type      = $page->{type};
            my $name      = $page->{name};
            my $full_name = $page->{full_name};
            if($current_page eq "$type^$name"){
                say "                                <option value=\"$type^$name\" selected>$full_name</option>";
            }else{
                say "                                <option value=\"$type^$name\">$full_name</option>";
            }
        }
        say "                            </select>";
        say "                        <td>";
        say "                        <td>";
        say "                            <select name=\"section\">";
        if($current_section){
            say "                                <option value=\"\">All Sections</option>";
        }else{
            say "                                <option value=\"\" selected>All Sections</option>";
        }
        for my $section (@sections){
            my $type      = $section->{type};
            my $name      = $section->{section};
            if($current_section eq "$type^$name"){
                say "                                <option value=\"$type^$name\" selected>$type $name</option>";
            }else{
                say "                                <option value=\"$type^$name\">$type $name</option>";
            }
        }
        say "                            </select>";
        say "                        </td>";
        say "                        <td>";
        say "                            <input name=\"submit\" type=\"submit\" value=\"OK\">";
        say "                        </td>";
        say "                    </tr>";
        for my $bod (@body){
            say "                    <tr>";
            my $section = $bod->{section};
            my $name    = $bod->{name};
            my $link    = $bod->{link};
            say "                        <td>$section</td>";
            say "                        <td>$name</td>";
            say "                        <td><a href=\"$link\" target=\"_blank\">$link</a></td>";
            say "                    </tr>";
        }
        say "                    <tr>";
        say "                        <td>";
        say "                            <input name=\"submit\" type=\"submit\" value=\"OK\">";
        say "                        </td>";
        say "                    </tr>";
        say "                </table>";
        say "            </form>";
        return 1;
    } ## --- end sub main

}

1;
