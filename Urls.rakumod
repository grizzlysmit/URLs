unit module Urls:ver<0.1.0>:auth<Francis Grizzly Smit (grizzlysmit@smit.id.au)>;

use Config::INI;
use Config::INI::Writer;
#use DBIish::Transaction;
#use DBIish::Savepoint;
use DBIish;
use Session;
use Inline::Perl5;
use DBI:from<Perl5>;
use Crypt::PBKDF2:from<Perl5>;
use Terminal::ANSI::OO :t;
use Term::termios;
use ECMA262Regex;
#use Email::Valid:from<Perl5>;
use Email::Valid; # using the raku one #
use IO::Prompt;
use Terminal::Getpass;
use Terminal::Width;
use Terminal::WCWidth;
use Gzz::Prompt;

my @signal;

enum Status is export ( invalid => 0, unassigned => 1, assigned => 2, both => 3 );

sub Str2Status(Str $name --> Status) is export {
    given $name {
        when 'invalid' { return Status::invalid; }
        when 'unassigned' { return Status::unassigned; }
        when 'assigned' { return Status::assigned; }
        when 'both' { return Status::both; }
        default {
            die "Error: $name is not a valid Status.";
        }
    }
}

# the home dir #
constant $home is export = %*ENV<HOME>.Str();

# config files
constant $config is export = "$home/.local/share/urls";

my %ini = Config::INI::parse_file("$config/settings.ini");

sub get-password(Str $user  --> Str) {
    return %ini{$user}.«password»;
}

my Str $dbserver = 'rakbat.local';
my Str $database = 'urls';
my Int $dbport = 5432;
my Str $dbuser = 'urluser';
my Str $dbpass = get-password($dbuser);
my $dbh = DBIish.connect('Pg', :host($dbserver), :port($dbport), :$database, :user($dbuser), :password($dbpass));

my $db = DBI.connect("dbi:Pg:database=$database;host=$dbserver;port=$dbport;", "$dbuser", "$dbpass", { AutoCommit => 1, RaiseError => 1});

my Str $id = %ini«login_details»«id» if (%ini«login_details»:exists) && (%ini«login_details»«id»:exists); 

#my %session := Session::Postgres.new($id, { dbname => $database, dbserver => 'rakbat.local', dbuser => $dbuser, dbport => 5432, dbpasswd => get-password($dbuser), });
my %session := Session::Postgres.new($id, { Handle => $db, });

$id = $id // %session.id;

if !((%ini«login_details»:exists) && (%ini«login_details»«id»:exists)) {
    %ini«login_details»«id» = $id;
    Config::INI::Writer::dumpfile(%ini, "$config/settings.ini");
}

sub list-links(Str $prefix is copy --> Bool) is export {
    my Bool:D $loggedin                  = so %session«loggedin»;
    my Int    $loggedin_id               =    ((%session«loggedin_id»               === Any) ?? Int   !! %session«loggedin_id» );
    my Str    $loggedin_username         =    ((%session«loggedin_username»         === Any) ?? Str   !! %session«loggedin_username» );
    my Bool:D $_admin                    = so %session«loggedin_admin»;
    my Str    $display_name              =    ((%session«loggedin_display_name»     === Any) ?? Str   !! %session«loggedin_display_name» );
    my Str    $given                     =    ((%session«loggedin_given»            === Any) ?? Str   !! %session«loggedin_given» );
    my Str    $family                    =    ((%session«loggedin_family»           === Any) ?? Str   !! %session«loggedin_family» );
    my Str    $loggedin_email            =    ((%session«loggedin_email»            === Any) ?? Str   !! %session«loggedin_email» );
    my Str    $phone_number              =    ((%session«loggedin_phone_number»     === Any) ?? Str   !! %session«loggedin_phone_number» );
    my Str    $groupname                 =    ((%session«loggedin_groupname»        === Any) ?? Str   !! %session«loggedin_groupname» );
    my Int    $primary_group_id          =    ((%session«loggedin_groupnname_id»    === Any) ?? Int   !! %session«loggedin_groupnname_id» );
    my Str    $loggedin_prefix           =    ((%session«loggedin_prefix»           === Any) ?? Str   !! %session«loggedin_prefix» );
    my Str    $loggedin_escape           =    ((%session«loggedin_escape»           === Any) ?? Str   !! %session«loggedin_escape» );
    my Str    $loggedin_punct            =    ((%session«loggedin_punct»            === Any) ?? Str   !! %session«loggedin_punct» );
    my Regex  $loggedin_landline_pattern =    ((%session«loggedin_landline_pattern» === Any) ?? Regex !! %session«loggedin_landline_pattern» );
    my Regex  $loggedin_mobile_pattern   =    ((%session«loggedin_mobile_pattern»   === Any) ?? Regex !! %session«loggedin_mobile_pattern» );
    unless $loggedin {
        say "You must be loggedin to use this function: {&*ROUTINE.name}";
        return False;
    }
    my $sth = $dbh.execute('SELECT * FROM vlinks ORDER BY LOWER(section), section, LOWER(name), name;');
    my @values = $sth.allrows(:array-of-hash);
    my $last_section;
    my $section = '';
    my Int $cnt = 0;
    my Int:D $w0 = 0;
    my Int:D $w1 = 0;
    my Int:D $w  = 0;
    my Int $width = terminal-width;
    my Bool:D $start = True;
    $prefix .=lc;
    for @values -> %row {
        $last_section = $section;
        $section = %row«section»;
        next unless $section.lc.starts-with($prefix);
        if $section ne $last_section {
            $w0 = max($w0, wcswidth("[$section]"));
        }
        my $name    = %row«name»;
        my $link    = %row«link»;
        $w0 = max($w0, wcswidth(sprintf("    %-10s", $name)));
        $w1 = max($w1, wcswidth($link));
    }
    $w   = max($w, $w0 + $w1 + 6);
    $w   = min($w,  $width);
    #$w0 -= 4;
    $w0 -= 2;
    $w1 += 2;
    # done in the query 
    #@values                  = |@values.sort: { my %u = %($^a); my %v = %($^b);  my $res = %u«section».lc.trim cmp %v«section».lc.trim; (($res == Same) ?? (%u«name».lc.trim cmp %v«name».lc.trim) !! $res ) };
    $last_section = '';
    $section = '';
    for @values -> %row {
        $last_section = $section;
        $section = %row«section»;
        next unless $section.lc.starts-with($prefix);
        if $section ne $last_section {
            unless $start { # don't print a blank line at the start,  but always between pages  #
                put (($cnt % 2 == 0) ?? t.bg-yellow !! t.bg-color(0,255,0)) ~ t.bold ~ t.bright-blue ~ sprintf(" %-*s", $w, '') ~ t.text-reset;
                $cnt++;
            }
            put (($cnt % 2 == 0) ?? t.bg-yellow !! t.bg-color(0,255,0)) ~ t.bold ~ t.bright-blue ~ sprintf("[%-*s", $w, $section ~ ']') ~ t.text-reset;
            $cnt++;
            $start = False;
        }
        my $name    = %row«name»;
        my $link    = %row«link»;
        put (($cnt % 2 == 0) ?? t.bg-yellow !! t.bg-color(0,255,0)) ~ t.bold ~ t.bright-blue ~ sprintf("    %-*s = %-*s", $w0, $name, $w1, $link) ~ t.text-reset;
        $cnt++;
    }
    put (($cnt % 2 == 0) ?? t.bg-yellow !! t.bg-color(0,255,0)) ~ t.bold ~ t.bright-blue ~ sprintf(" %-*s", $w, '') ~ t.text-reset; # add a blank line at the end #
    $cnt++;
    return True;
} # sub list-links(Str $prefix is copy --> Bool) is export #

sub section-exists(Str $section --> Bool) is export {
    my $sth = $dbh.execute('SELECT COUNT(*) n FROM sections WHERE section = ?', $section);
    my %values = $sth.row(:hash);
    my $n = %values«n»;
    return False if $n == 0;
    return True;
} # sub section-exists(Str $section --> Bool) is export #

sub alias-exists(Str $name --> Bool) is export {
    my $sth = $dbh.execute('SELECT COUNT(*) n FROM alias WHERE name = ?', $name);
    my %values = $sth.row(:hash);
    my $n = %values«n»;
    return False if $n == 0;
    return True;
}

sub link-exists(Str $section --> Bool) is export {
    my $sth = $dbh.execute('SELECT COUNT(*) n FROM links_sections WHERE section = ?', $section);
    my %values = $sth.row(:hash);
    my $n = %values«n»;
    return False if $n == 0;
    return True;
}

sub list-aliases(Str $prefix is copy --> Bool) is export {
    my Bool:D $loggedin                  = so %session«loggedin»;
    my Int    $loggedin_id               =    ((%session«loggedin_id»               === Any) ?? Int   !! %session«loggedin_id» );
    my Str    $loggedin_username         =    ((%session«loggedin_username»         === Any) ?? Str   !! %session«loggedin_username» );
    my Bool:D $_admin                    = so %session«loggedin_admin»;
    my Str    $display_name              =    ((%session«loggedin_display_name»     === Any) ?? Str   !! %session«loggedin_display_name» );
    my Str    $given                     =    ((%session«loggedin_given»            === Any) ?? Str   !! %session«loggedin_given» );
    my Str    $family                    =    ((%session«loggedin_family»           === Any) ?? Str   !! %session«loggedin_family» );
    my Str    $loggedin_email            =    ((%session«loggedin_email»            === Any) ?? Str   !! %session«loggedin_email» );
    my Str    $phone_number              =    ((%session«loggedin_phone_number»     === Any) ?? Str   !! %session«loggedin_phone_number» );
    my Str    $groupname                 =    ((%session«loggedin_groupname»        === Any) ?? Str   !! %session«loggedin_groupname» );
    my Int    $primary_group_id          =    ((%session«loggedin_groupnname_id»    === Any) ?? Int   !! %session«loggedin_groupnname_id» );
    my Str    $loggedin_prefix           =    ((%session«loggedin_prefix»           === Any) ?? Str   !! %session«loggedin_prefix» );
    my Str    $loggedin_escape           =    ((%session«loggedin_escape»           === Any) ?? Str   !! %session«loggedin_escape» );
    my Str    $loggedin_punct            =    ((%session«loggedin_punct»            === Any) ?? Str   !! %session«loggedin_punct» );
    my Regex  $loggedin_landline_pattern =    ((%session«loggedin_landline_pattern» === Any) ?? Regex !! %session«loggedin_landline_pattern» );
    my Regex  $loggedin_mobile_pattern   =    ((%session«loggedin_mobile_pattern»   === Any) ?? Regex !! %session«loggedin_mobile_pattern» );
    unless $loggedin {
        say "You must be loggedin to use this function: {&*ROUTINE.name}";
        return False;
    }
    $prefix .=lc;
    my Int:D $w0 = 0;
    my Int:D $w1 = 0;
    my Int:D $w  = 0;
    my Int $width = terminal-width;
    my Bool:D $start = True;
    my $last_name;
    my $name = '';
    my $sth = $dbh.execute('SELECT a.name, a.section "target" FROM aliases a ORDER BY LOWER(a.name), a.name, LOWER(a.section), a.section;');
    my @values = $sth.allrows(:array-of-hash);
    $w0 = max($w0, wcswidth("    alias"));
    for @values -> %row {
        $last_name = $name;
        $name = %row«name»;
        next unless $name.lc.starts-with($prefix);
        if $name ne $last_name {
            $w0 = max($w0, wcswidth("[$name]"));
        }
        my $target    = %row«target»;
        $w1 = max($w1, wcswidth($target));
    }
    $w   = max($w, $w0 + $w1 + 6);
    $w   = min($w,  $width);
    #$w0 -= 4;
    $w0 -= 2;
    $w1 += 2;
    my Int $cnt = 0;
    #@values                  = |@values.sort: { my %u = %($^a); my %v = %($^b);  my $res = %u«name».lc.trim cmp %v«name».lc.trim; (($res == Same) ?? (%u«target».lc.trim cmp %v«target».lc.trim) !! $res ) };
    $name = '';
    $last_name = '';
    for @values -> %row {
        $last_name = $name;
        $name = %row«name»;
        next unless $name.lc.starts-with($prefix);
        if $name ne $last_name {
            unless $start { # don't print a blank line at the start,  but always between pages  #
                put (($cnt % 2 == 0) ?? t.bg-yellow !! t.bg-color(0,255,0)) ~ t.bold ~ t.bright-blue ~ sprintf(" %-*s", $w, '') ~ t.text-reset;
                $cnt++;
            }
            put (($cnt % 2 == 0) ?? t.bg-yellow !! t.bg-color(0,255,0)) ~ t.bold ~ t.bright-blue ~ sprintf("[%-*s", $w, $name ~ ']') ~ t.text-reset;
            $cnt++;
            $start = False;
        }
        my $target    = %row«target»;
        put (($cnt % 2 == 0) ?? t.bg-yellow !! t.bg-color(0,255,0)) ~ t.bold ~ t.bright-blue ~ sprintf("    %-*s = %-*s", $w0, 'alias', $w1, $target) ~ t.text-reset;
        $cnt++;
    }
    put (($cnt % 2 == 0) ?? t.bg-yellow !! t.bg-color(0,255,0)) ~ t.bold ~ t.bright-blue ~ sprintf(" %-*s", $w, '') ~ t.text-reset; # add a blank line at the end #
    $cnt++;
    return True;
} # sub list-aliases(Str $prefix is copy --> Bool) is export #

sub in-a-page(Str $section --> Bool) {
    my $sth = $dbh.execute('SELECT COUNT(*) n FROM page_view pv WHERE pv.section = ?;', $section);
    my %values = $sth.row(:hash);
    my $n = %values«n»;
    return False if $n == 0;
    return True;
}

sub list-pages(Str $page-name is copy, Str $prefix is copy --> Bool) is export {
    my Bool:D $loggedin                  = so %session«loggedin»;
    my Int    $loggedin_id               =    ((%session«loggedin_id»               === Any) ?? Int   !! %session«loggedin_id» );
    my Str    $loggedin_username         =    ((%session«loggedin_username»         === Any) ?? Str   !! %session«loggedin_username» );
    my Bool:D $_admin                    = so %session«loggedin_admin»;
    my Str    $display_name              =    ((%session«loggedin_display_name»     === Any) ?? Str   !! %session«loggedin_display_name» );
    my Str    $given                     =    ((%session«loggedin_given»            === Any) ?? Str   !! %session«loggedin_given» );
    my Str    $family                    =    ((%session«loggedin_family»           === Any) ?? Str   !! %session«loggedin_family» );
    my Str    $loggedin_email            =    ((%session«loggedin_email»            === Any) ?? Str   !! %session«loggedin_email» );
    my Str    $phone_number              =    ((%session«loggedin_phone_number»     === Any) ?? Str   !! %session«loggedin_phone_number» );
    my Str    $groupname                 =    ((%session«loggedin_groupname»        === Any) ?? Str   !! %session«loggedin_groupname» );
    my Int    $primary_group_id          =    ((%session«loggedin_groupnname_id»    === Any) ?? Int   !! %session«loggedin_groupnname_id» );
    my Str    $loggedin_prefix           =    ((%session«loggedin_prefix»           === Any) ?? Str   !! %session«loggedin_prefix» );
    my Str    $loggedin_escape           =    ((%session«loggedin_escape»           === Any) ?? Str   !! %session«loggedin_escape» );
    my Str    $loggedin_punct            =    ((%session«loggedin_punct»            === Any) ?? Str   !! %session«loggedin_punct» );
    my Regex  $loggedin_landline_pattern =    ((%session«loggedin_landline_pattern» === Any) ?? Regex !! %session«loggedin_landline_pattern» );
    my Regex  $loggedin_mobile_pattern   =    ((%session«loggedin_mobile_pattern»   === Any) ?? Regex !! %session«loggedin_mobile_pattern» );
    unless $loggedin {
        say "You must be loggedin to use this function: {&*ROUTINE.name}";
        return False;
    }
    $prefix    .=lc;
    $page-name .=lc;
    my Int:D $w0 = 0;
    my Int:D $w1 = 0;
    my Int:D $w  = 0;
    my Int $width = terminal-width;
    my Bool:D $start = True;
    my $last_name;
    my $name = '';
    my Str:D $sql       = "SELECT * FROM page_pseudo_link_view pv\n";
    $sql               ~= "WHERE (? = true OR (pv.userid = ? AND (pv)._perms._user._read = true)\n";
    $sql               ~= "       OR ((pv.groupid = ? OR pv.groupid IN (SELECT gs.group_id FROM groups gs WHERE gs.passwd_id = ?))\n";
    $sql               ~= "                             AND (pv)._perms._group._read = true) OR (pv)._perms._other._read = true)\n";
    $sql               ~= "ORDER BY LOWER(pv.page_name), pv.page_name, LOWER(pv.full_name), pv.full_name, LOWER(pv.section), pv.section, LOWER(pv.name), pv.name;\n";
    my $sth0 = $dbh.execute($sql, $_admin, $loggedin_id, $primary_group_id, $loggedin_id);
    my @values = $sth0.allrows(:array-of-hash);
    my $last_page_name = '';
    my $page_name      = '';
    my $last_section   = '';
    my $section        = '';
    for @values -> %row {
        $page_name = %row«page_name»;
        next unless $page_name.lc.starts-with($page-name);
        $section      = %row«section»;
        next unless $section.lc.starts-with($prefix);
        if $page_name ne $last_page_name {
            $w0 = max($w0, wcswidth("|$page_name|"), wcswidth("    [$section]"));
        }elsif $section ne $last_section {
            $w0 = max($w0, wcswidth("    [$section]"));
        }
        my $name    = %row«name»;
        my $link    = %row«link»;
        $w0 = max($w0, wcswidth(sprintf("        %-10s", $name)));
        $w1 = max($w1, wcswidth($link));
        $last_section   = $section;
        $last_page_name = $page_name;
    }
    $w   = max($w, $w0 + $w1 + 10);
    $w   = min($w,  $width);
    #$w0 -= 4;
    $w0 -= 2;
    $w1 += 2;
    my Int $cnt = 0;
    # moved to SQL #
    #@values                  = |@values.sort: { my %u = %($^a); my %v = %($^b);  my $res = %u«page_name».lc.trim cmp %v«page_name».lc.trim; (($res == Same) ?? (%u«section».lc.trim cmp %v«section».lc.trim) !! $res ) };
    $last_page_name = '';
    $page_name      = '';
    $last_section   = '';
    $section        = '';
    for @values -> %row {
        $page_name = %row«page_name»;
        my $status = %row«status»;
        next unless $page_name.lc.starts-with($page-name);
        $section      = %row«section»;
        next unless $section.lc.starts-with($prefix);
        next if $status eq Status::unassigned && in-a-page($section);
        next if $status eq Status::assigned   && !in-a-page($section);
        if $page_name ne $last_page_name {
            unless $start { # don't print a blank line at the start,  but always between pages  #
                put (($cnt % 2 == 0) ?? t.bg-yellow !! t.bg-color(0,255,0)) ~ t.bold ~ t.bright-blue ~ sprintf(" %-*s", $w, '') ~ t.text-reset;
                $cnt++;
            }
            put (($cnt % 2 == 0) ?? t.bg-yellow !! t.bg-color(0,255,0)) ~ t.bold ~ t.bright-blue ~ sprintf("|%-*s", $w, $page_name ~ '|') ~ t.text-reset;
            $cnt++;
            put (($cnt % 2 == 0) ?? t.bg-yellow !! t.bg-color(0,255,0)) ~ t.bold ~ t.bright-blue ~ sprintf("    [%-*s", $w - 4, $section ~ ']') ~ t.text-reset;
            $cnt++;
            $start = False;
        }elsif $section ne $last_section {
            unless $start { # don't print a blank line at the start,  but always between pages  #
                put (($cnt % 2 == 0) ?? t.bg-yellow !! t.bg-color(0,255,0)) ~ t.bold ~ t.bright-blue ~ sprintf(" %-*s", $w, '') ~ t.text-reset;
                $cnt++;
            }
            put (($cnt % 2 == 0) ?? t.bg-yellow !! t.bg-color(0,255,0)) ~ t.bold ~ t.bright-blue ~ sprintf("    [%-*s", $w - 4, $section ~ ']') ~ t.text-reset;
            $cnt++;
            $start = False;
        }
        my $name    = %row«name»;
        my $link    = %row«link»;
        put (($cnt % 2 == 0) ?? t.bg-yellow !! t.bg-color(0,255,0)) ~ t.bold ~ t.bright-blue ~ sprintf("        %-*s = %-*s", $w0, $name, $w1, $link) ~ t.text-reset;
        $cnt++;
        $last_section   = $section;
        $last_page_name = $page_name;
    }
    put (($cnt % 2 == 0) ?? t.bg-yellow !! t.bg-color(0,255,0)) ~ t.bold ~ t.bright-blue ~ sprintf(" %-*s", $w, '') ~ t.text-reset; # add a blank line at the end #
    $cnt++;
    return True;
} # sub list-pages(Str $page-name is copy, Str $prefix is copy --> Bool) is export #

sub add-page(Str $page, Str $name, @links --> Bool) is  export {
    my Bool:D $loggedin                  = so %session«loggedin»;
    my Int    $loggedin_id               =    ((%session«loggedin_id»               === Any) ?? Int   !! %session«loggedin_id» );
    my Str    $loggedin_username         =    ((%session«loggedin_username»         === Any) ?? Str   !! %session«loggedin_username» );
    my Bool:D $_admin                    = so %session«loggedin_admin»;
    my Str    $display_name              =    ((%session«loggedin_display_name»     === Any) ?? Str   !! %session«loggedin_display_name» );
    my Str    $given                     =    ((%session«loggedin_given»            === Any) ?? Str   !! %session«loggedin_given» );
    my Str    $family                    =    ((%session«loggedin_family»           === Any) ?? Str   !! %session«loggedin_family» );
    my Str    $loggedin_email            =    ((%session«loggedin_email»            === Any) ?? Str   !! %session«loggedin_email» );
    my Str    $phone_number              =    ((%session«loggedin_phone_number»     === Any) ?? Str   !! %session«loggedin_phone_number» );
    my Str    $groupname                 =    ((%session«loggedin_groupname»        === Any) ?? Str   !! %session«loggedin_groupname» );
    my Int    $primary_group_id          =    ((%session«loggedin_groupnname_id»    === Any) ?? Int   !! %session«loggedin_groupnname_id» );
    my Str    $loggedin_prefix           =    ((%session«loggedin_prefix»           === Any) ?? Str   !! %session«loggedin_prefix» );
    my Str    $loggedin_escape           =    ((%session«loggedin_escape»           === Any) ?? Str   !! %session«loggedin_escape» );
    my Str    $loggedin_punct            =    ((%session«loggedin_punct»            === Any) ?? Str   !! %session«loggedin_punct» );
    my Regex  $loggedin_landline_pattern =    ((%session«loggedin_landline_pattern» === Any) ?? Regex !! %session«loggedin_landline_pattern» );
    my Regex  $loggedin_mobile_pattern   =    ((%session«loggedin_mobile_pattern»   === Any) ?? Regex !! %session«loggedin_mobile_pattern» );
    unless $loggedin {
        say "You must be loggedin to use this function: {&*ROUTINE.name}";
        return False;
    }
    my $sth = $dbh.execute('SELECT COUNT(*) n FROM pages WHERE name = ?', $page);
    my %_values = $sth.row(:hash);
    my $n = %_values«n»;
    if $n == 0 {
        $dbh.execute('INSERT INTO pages(name, full_name, userid, groupid) VALUES(?, ?, ?, ?)', $page, $name, $loggedin_id, $primary_group_id);
    }
    my $sth0 = $dbh.execute('SELECT id FROM pages WHERE name = ?', $page);
    my %values = $sth0.row(:hash);
    without %values«id» {
        note "something is wrong failed to insert page: $page";
        return False;
    }
    my $pages_id = %values«id»;
    my $sth3 = $dbh.prepare('INSERT INTO page_section(pages_id, links_section_id, userid, groupid) VALUES (?, ?, ?, ?)');
    for @links -> $link {
        my $sth1 = $dbh.execute('SELECT id FROM links_sections WHERE section = ?', $link);
        my %val = $sth1.row(:hash);
        next unless %val;
        my $links_section_id = %val«id»;
        $sth3.execute($pages_id, $links_section_id, $loggedin_id, $primary_group_id);
    }
} # sub add-page(Str $page, Str $name, @links --> Bool) is  export #

sub add-links(Str $link-section, %links --> Bool) is export {
    my Bool:D $loggedin                  = so %session«loggedin»;
    my Int    $loggedin_id               =    ((%session«loggedin_id»               === Any) ?? Int   !! %session«loggedin_id» );
    my Str    $loggedin_username         =    ((%session«loggedin_username»         === Any) ?? Str   !! %session«loggedin_username» );
    my Bool:D $_admin                    = so %session«loggedin_admin»;
    my Str    $display_name              =    ((%session«loggedin_display_name»     === Any) ?? Str   !! %session«loggedin_display_name» );
    my Str    $given                     =    ((%session«loggedin_given»            === Any) ?? Str   !! %session«loggedin_given» );
    my Str    $family                    =    ((%session«loggedin_family»           === Any) ?? Str   !! %session«loggedin_family» );
    my Str    $loggedin_email            =    ((%session«loggedin_email»            === Any) ?? Str   !! %session«loggedin_email» );
    my Str    $phone_number              =    ((%session«loggedin_phone_number»     === Any) ?? Str   !! %session«loggedin_phone_number» );
    my Str    $groupname                 =    ((%session«loggedin_groupname»        === Any) ?? Str   !! %session«loggedin_groupname» );
    my Int    $primary_group_id          =    ((%session«loggedin_groupnname_id»    === Any) ?? Int   !! %session«loggedin_groupnname_id» );
    my Str    $loggedin_prefix           =    ((%session«loggedin_prefix»           === Any) ?? Str   !! %session«loggedin_prefix» );
    my Str    $loggedin_escape           =    ((%session«loggedin_escape»           === Any) ?? Str   !! %session«loggedin_escape» );
    my Str    $loggedin_punct            =    ((%session«loggedin_punct»            === Any) ?? Str   !! %session«loggedin_punct» );
    my Regex  $loggedin_landline_pattern =    ((%session«loggedin_landline_pattern» === Any) ?? Regex !! %session«loggedin_landline_pattern» );
    my Regex  $loggedin_mobile_pattern   =    ((%session«loggedin_mobile_pattern»   === Any) ?? Regex !! %session«loggedin_mobile_pattern» );
    unless $loggedin {
        say "You must be loggedin to use this function: {&*ROUTINE.name}";
        return False;
    }
    die "link-section must have a value." if $link-section ~~ rx/^ \s+ $/;
    my $sth0 = $dbh.execute('SELECT count(*) n FROM links_sections WHERE section = ?', $link-section);
    my %val = $sth0.row(:hash);
    my $n = %val«n»;
    if $n == 0 {
        $dbh.execute('INSERT INTO links_sections(section, userid, groupid) VALUES(?, ?, ?)', $link-section, $loggedin_id, $primary_group_id);
    }
    my $sth1 = $dbh.execute('SELECT id FROM links_sections WHERE section = ?', $link-section);
    my %values = $sth1.row(:hash);
    my $id = %values«id»;
    my $sth = $dbh.prepare('INSERT INTO links(section_id, name, link, userid, groupid) VALUES (?, ?, ?, ?, ?)');
    for %links.kv -> $key, $val {
        $sth.execute($id, $key, $val, $loggedin_id, $primary_group_id);
    }
    return True;
} # sub add-links(Str $link-section, %links --> Bool) is export #

sub add-alias(Str $alias-name, Str $link-section is copy --> Bool) is export {
    my Bool:D $loggedin                  = so %session«loggedin»;
    my Int    $loggedin_id               =    ((%session«loggedin_id»               === Any) ?? Int   !! %session«loggedin_id» );
    my Str    $loggedin_username         =    ((%session«loggedin_username»         === Any) ?? Str   !! %session«loggedin_username» );
    my Bool:D $_admin                    = so %session«loggedin_admin»;
    my Str    $display_name              =    ((%session«loggedin_display_name»     === Any) ?? Str   !! %session«loggedin_display_name» );
    my Str    $given                     =    ((%session«loggedin_given»            === Any) ?? Str   !! %session«loggedin_given» );
    my Str    $family                    =    ((%session«loggedin_family»           === Any) ?? Str   !! %session«loggedin_family» );
    my Str    $loggedin_email            =    ((%session«loggedin_email»            === Any) ?? Str   !! %session«loggedin_email» );
    my Str    $phone_number              =    ((%session«loggedin_phone_number»     === Any) ?? Str   !! %session«loggedin_phone_number» );
    my Str    $groupname                 =    ((%session«loggedin_groupname»        === Any) ?? Str   !! %session«loggedin_groupname» );
    my Int    $primary_group_id          =    ((%session«loggedin_groupnname_id»    === Any) ?? Int   !! %session«loggedin_groupnname_id» );
    my Str    $loggedin_prefix           =    ((%session«loggedin_prefix»           === Any) ?? Str   !! %session«loggedin_prefix» );
    my Str    $loggedin_escape           =    ((%session«loggedin_escape»           === Any) ?? Str   !! %session«loggedin_escape» );
    my Str    $loggedin_punct            =    ((%session«loggedin_punct»            === Any) ?? Str   !! %session«loggedin_punct» );
    my Regex  $loggedin_landline_pattern =    ((%session«loggedin_landline_pattern» === Any) ?? Regex !! %session«loggedin_landline_pattern» );
    my Regex  $loggedin_mobile_pattern   =    ((%session«loggedin_mobile_pattern»   === Any) ?? Regex !! %session«loggedin_mobile_pattern» );
    unless $loggedin {
        say "You must be loggedin to use this function: {&*ROUTINE.name}";
        return False;
    }
    die "Error: alias-name: $alias-name already exists and is not a alias" if section-exists($alias-name) && !alias-exists($alias-name);
    die "Error: link-section: $link-section does not exist" unless link-exists($link-section) || alias-exists($link-section);
    my $sth0 = $dbh.execute('SELECT count(*) n FROM links_sections WHERE section = ?', $link-section);
    my %val = $sth0.row(:hash);
    my $n = %val«n»;
    my $target;
    if $n == 0 {
        my $sth1 = $dbh.execute('SELECT target FROM alias WHERE name = ?', $link-section);
        my %val = $sth1.row(:hash);
        $target = %val«target»;
    } else {
        my $sth2 = $dbh.execute('SELECT id FROM links_sections WHERE section = ?', $link-section);
        my %val = $sth2.row(:hash);
        $target = %val«id»;
    }
    $dbh.execute('INSERT INTO alias(name, target, userid, groupid) VALUES(?, ?, ?, ?)', $alias-name, $target, $loggedin_id, $primary_group_id);
    return True;
} # sub add-alias(Str $alias-name, Str $link-section is copy --> Bool) is export #

sub delete-links(Str $link-section, Bool $remove-section, @links --> Bool) is export {
    my Bool:D $loggedin                  = so %session«loggedin»;
    my Int    $loggedin_id               =    ((%session«loggedin_id»               === Any) ?? Int   !! %session«loggedin_id» );
    my Str    $loggedin_username         =    ((%session«loggedin_username»         === Any) ?? Str   !! %session«loggedin_username» );
    my Bool:D $_admin                    = so %session«loggedin_admin»;
    my Str    $display_name              =    ((%session«loggedin_display_name»     === Any) ?? Str   !! %session«loggedin_display_name» );
    my Str    $given                     =    ((%session«loggedin_given»            === Any) ?? Str   !! %session«loggedin_given» );
    my Str    $family                    =    ((%session«loggedin_family»           === Any) ?? Str   !! %session«loggedin_family» );
    my Str    $loggedin_email            =    ((%session«loggedin_email»            === Any) ?? Str   !! %session«loggedin_email» );
    my Str    $phone_number              =    ((%session«loggedin_phone_number»     === Any) ?? Str   !! %session«loggedin_phone_number» );
    my Str    $groupname                 =    ((%session«loggedin_groupname»        === Any) ?? Str   !! %session«loggedin_groupname» );
    my Int    $primary_group_id          =    ((%session«loggedin_groupnname_id»    === Any) ?? Int   !! %session«loggedin_groupnname_id» );
    my Str    $loggedin_prefix           =    ((%session«loggedin_prefix»           === Any) ?? Str   !! %session«loggedin_prefix» );
    my Str    $loggedin_escape           =    ((%session«loggedin_escape»           === Any) ?? Str   !! %session«loggedin_escape» );
    my Str    $loggedin_punct            =    ((%session«loggedin_punct»            === Any) ?? Str   !! %session«loggedin_punct» );
    my Regex  $loggedin_landline_pattern =    ((%session«loggedin_landline_pattern» === Any) ?? Regex !! %session«loggedin_landline_pattern» );
    my Regex  $loggedin_mobile_pattern   =    ((%session«loggedin_mobile_pattern»   === Any) ?? Regex !! %session«loggedin_mobile_pattern» );
    unless $loggedin {
        say "You must be loggedin to use this function: {&*ROUTINE.name}";
        return False;
    }
    die "link-section must have a value." if $link-section ~~ rx/^ \s+ $/;
    my $sth0 = $dbh.execute('SELECT id FROM links_sections WHERE section = ?', $link-section);
    my %val = $sth0.row(:hash);
    die "Error: links_sections: $link-section does not exist" unless %val;
    my $id = %val«id»;
    my Str:D $sql       = "DELETE FROM links WHERE section_id = ? AND name = ? AND\n";
    $sql               ~= "(? = true OR (userid = ? AND (_perms)._user._del = true)\n";
    $sql               ~= "       OR ((groupid = ? OR groupid IN (SELECT gs.group_id FROM groups gs WHERE gs.passwd_id = ?))\n";
    $sql               ~= "                             AND (_perms)._group._del = true) OR (_perms)._other._del = true);\n";
    my $sth = $dbh.prepare($sql);
    for @links -> $link {
        $sth.execute($id, $link, $_admin, $loggedin_id, $primary_group_id, $loggedin_id);
    }
    $sql                = "DELETE FROM links_sections WHERE id = ? AND\n";
    $sql               ~= "(? = true OR (userid = ? AND (_perms)._user._del = true)\n";
    $sql               ~= "       OR ((groupid = ? OR groupid IN (SELECT gs.group_id FROM groups gs WHERE gs.passwd_id = ?))\n";
    $sql               ~= "                             AND (_perms)._group._del = true) OR (_perms)._other._del = true);\n";
    my $sth2 = $dbh.prepare($sql);
    if $remove-section {
        my $sth1 = $dbh.execute('SELECT COUNT(*) n FROM links WHERE section_id = ?', $id);
        my %value = $sth1.row(:hash);
        my $n = %value«n»;
        if $n == 0 {
            $sth2.execute($id, $_admin, $loggedin_id, $primary_group_id, $loggedin_id);
        } else {
            "Warning: $link-section still contains links not deleting section.".say;
        }
    }
    return True;
} # sub delete-links(Str $link-section, Bool $remove-section, @links --> Bool) is export #

sub delete-page(Str $page-name --> Bool) is export {
    my Bool:D $loggedin                  = so %session«loggedin»;
    my Int    $loggedin_id               =    ((%session«loggedin_id»               === Any) ?? Int   !! %session«loggedin_id» );
    my Str    $loggedin_username         =    ((%session«loggedin_username»         === Any) ?? Str   !! %session«loggedin_username» );
    my Bool:D $_admin                    = so %session«loggedin_admin»;
    my Str    $display_name              =    ((%session«loggedin_display_name»     === Any) ?? Str   !! %session«loggedin_display_name» );
    my Str    $given                     =    ((%session«loggedin_given»            === Any) ?? Str   !! %session«loggedin_given» );
    my Str    $family                    =    ((%session«loggedin_family»           === Any) ?? Str   !! %session«loggedin_family» );
    my Str    $loggedin_email            =    ((%session«loggedin_email»            === Any) ?? Str   !! %session«loggedin_email» );
    my Str    $phone_number              =    ((%session«loggedin_phone_number»     === Any) ?? Str   !! %session«loggedin_phone_number» );
    my Str    $groupname                 =    ((%session«loggedin_groupname»        === Any) ?? Str   !! %session«loggedin_groupname» );
    my Int    $primary_group_id          =    ((%session«loggedin_groupnname_id»    === Any) ?? Int   !! %session«loggedin_groupnname_id» );
    my Str    $loggedin_prefix           =    ((%session«loggedin_prefix»           === Any) ?? Str   !! %session«loggedin_prefix» );
    my Str    $loggedin_escape           =    ((%session«loggedin_escape»           === Any) ?? Str   !! %session«loggedin_escape» );
    my Str    $loggedin_punct            =    ((%session«loggedin_punct»            === Any) ?? Str   !! %session«loggedin_punct» );
    my Regex  $loggedin_landline_pattern =    ((%session«loggedin_landline_pattern» === Any) ?? Regex !! %session«loggedin_landline_pattern» );
    my Regex  $loggedin_mobile_pattern   =    ((%session«loggedin_mobile_pattern»   === Any) ?? Regex !! %session«loggedin_mobile_pattern» );
    unless $loggedin {
        say "You must be loggedin to use this function: {&*ROUTINE.name}";
        return False;
    }
    die "link-section must have a value." if $page-name ~~ rx/^ \s+ $/;
    my $sth0 = $dbh.execute('SELECT id FROM pages WHERE name = ?', $page-name);
    my %val = $sth0.row(:hash);
    die "Error: page-name: $page-name does not exist" unless %val;
    my $pages_id = %val«id»;
    my Str:D $sql       = "DELETE FROM page_section\n";
    $sql               ~= "WHERE pages_id = ? AND (? = true OR (userid = ? AND (_perms)._user._del = true)\n";
    $sql               ~= "       OR ((groupid = ? OR groupid IN (SELECT gs.group_id FROM groups gs WHERE gs.passwd_id = ?))\n";
    $sql               ~= "                             AND (_perms)._group._del = true) OR (_perms)._other._del = true);\n";
    $dbh.execute($sql, $pages_id, $_admin, $loggedin_id, $primary_group_id, $loggedin_id);
    $sql                = "DELETE FROM pages\n";
    $sql               ~= "WHERE  id = ? AND (? = true OR (userid = ? AND (_perms)._user._del = true)\n";
    $sql               ~= "       OR ((groupid = ? OR groupid IN (SELECT gs.group_id FROM groups gs WHERE gs.passwd_id = ?))\n";
    $sql               ~= "                             AND (_perms)._group._del = true) OR (_perms)._other._del = true);\n";
    $dbh.execute($sql, $pages_id, $_admin, $loggedin_id, $primary_group_id, $loggedin_id);
    return True;
} # sub delete-page(Str $page-name --> Bool) is export #

sub delete-pseudo-page(Str $page-name --> Bool) is export {
    my Bool:D $loggedin                  = so %session«loggedin»;
    my Int    $loggedin_id               =    ((%session«loggedin_id»               === Any) ?? Int   !! %session«loggedin_id» );
    my Str    $loggedin_username         =    ((%session«loggedin_username»         === Any) ?? Str   !! %session«loggedin_username» );
    my Bool:D $_admin                    = so %session«loggedin_admin»;
    my Str    $display_name              =    ((%session«loggedin_display_name»     === Any) ?? Str   !! %session«loggedin_display_name» );
    my Str    $given                     =    ((%session«loggedin_given»            === Any) ?? Str   !! %session«loggedin_given» );
    my Str    $family                    =    ((%session«loggedin_family»           === Any) ?? Str   !! %session«loggedin_family» );
    my Str    $loggedin_email            =    ((%session«loggedin_email»            === Any) ?? Str   !! %session«loggedin_email» );
    my Str    $phone_number              =    ((%session«loggedin_phone_number»     === Any) ?? Str   !! %session«loggedin_phone_number» );
    my Str    $groupname                 =    ((%session«loggedin_groupname»        === Any) ?? Str   !! %session«loggedin_groupname» );
    my Int    $primary_group_id          =    ((%session«loggedin_groupnname_id»    === Any) ?? Int   !! %session«loggedin_groupnname_id» );
    my Str    $loggedin_prefix           =    ((%session«loggedin_prefix»           === Any) ?? Str   !! %session«loggedin_prefix» );
    my Str    $loggedin_escape           =    ((%session«loggedin_escape»           === Any) ?? Str   !! %session«loggedin_escape» );
    my Str    $loggedin_punct            =    ((%session«loggedin_punct»            === Any) ?? Str   !! %session«loggedin_punct» );
    my Regex  $loggedin_landline_pattern =    ((%session«loggedin_landline_pattern» === Any) ?? Regex !! %session«loggedin_landline_pattern» );
    my Regex  $loggedin_mobile_pattern   =    ((%session«loggedin_mobile_pattern»   === Any) ?? Regex !! %session«loggedin_mobile_pattern» );
    unless $loggedin {
        say "You must be loggedin to use this function: {&*ROUTINE.name}";
        return False;
    }
    die "link-section must have a value." if $page-name ~~ rx/^ \s+ $/;
    my Str:D $sql       = "DELETE FROM pseudo_pages\n";
    $sql               ~= "WHERE  name = ? AND (? = true OR (userid = ? AND (_perms)._user._del = true)\n";
    $sql               ~= "       OR ((groupid = ? OR groupid IN (SELECT gs.group_id FROM groups gs WHERE gs.passwd_id = ?))\n";
    $sql               ~= "                             AND (_perms)._group._del = true) OR (_perms)._other._del = true);\n";
    $dbh.execute($sql, $page-name, $_admin, $loggedin_id, $primary_group_id, $loggedin_id);
    return True;
} # sub delete-pseudo-page(Str $page-name --> Bool) is export #

sub add-pseudo-pages(Str $page, Status $status is copy, Str $full-name, Str $pattern --> Bool) is export {
    my Bool:D $loggedin                  = so %session«loggedin»;
    my Int    $loggedin_id               =    ((%session«loggedin_id»               === Any) ?? Int   !! %session«loggedin_id» );
    my Str    $loggedin_username         =    ((%session«loggedin_username»         === Any) ?? Str   !! %session«loggedin_username» );
    my Bool:D $_admin                    = so %session«loggedin_admin»;
    my Str    $display_name              =    ((%session«loggedin_display_name»     === Any) ?? Str   !! %session«loggedin_display_name» );
    my Str    $given                     =    ((%session«loggedin_given»            === Any) ?? Str   !! %session«loggedin_given» );
    my Str    $family                    =    ((%session«loggedin_family»           === Any) ?? Str   !! %session«loggedin_family» );
    my Str    $loggedin_email            =    ((%session«loggedin_email»            === Any) ?? Str   !! %session«loggedin_email» );
    my Str    $phone_number              =    ((%session«loggedin_phone_number»     === Any) ?? Str   !! %session«loggedin_phone_number» );
    my Str    $groupname                 =    ((%session«loggedin_groupname»        === Any) ?? Str   !! %session«loggedin_groupname» );
    my Int    $primary_group_id          =    ((%session«loggedin_groupnname_id»    === Any) ?? Int   !! %session«loggedin_groupnname_id» );
    my Str    $loggedin_prefix           =    ((%session«loggedin_prefix»           === Any) ?? Str   !! %session«loggedin_prefix» );
    my Str    $loggedin_escape           =    ((%session«loggedin_escape»           === Any) ?? Str   !! %session«loggedin_escape» );
    my Str    $loggedin_punct            =    ((%session«loggedin_punct»            === Any) ?? Str   !! %session«loggedin_punct» );
    my Regex  $loggedin_landline_pattern =    ((%session«loggedin_landline_pattern» === Any) ?? Regex !! %session«loggedin_landline_pattern» );
    my Regex  $loggedin_mobile_pattern   =    ((%session«loggedin_mobile_pattern»   === Any) ?? Regex !! %session«loggedin_mobile_pattern» );
    unless $loggedin {
        say "You must be loggedin to use this function: {&*ROUTINE.name}";
        return False;
    }
    die "Error: pages is an system section." if $page eq 'pages';
    my $sth0 = $dbh.execute('SELECT COUNT(*) n FROM pages WHERE name = ?', $page);
    my %val = $sth0.row(:hash);
    my $n = %val«n»;
    $status = Status::unassigned if $status == Status::invalid;
    if $n == 0 {
        $dbh.execute('INSERT INTO pseudo_pages(name, full_name, pattern, status, userid, groupid) VALUES(?, ?, ?, ?, ?, ?)', $page, $full-name, $pattern, $status, $loggedin_id, $primary_group_id);
    } else {
        my Str:D $sql       = "UPDATE pseudo_pages SET name = ?, full_name = ?, pattern = ?, status = ?\n";
        $sql               ~= "WHERE  name = ? AND (? = true OR (userid = ? AND (_perms)._user._del = true)\n";
        $sql               ~= "       OR ((groupid = ? OR groupid IN (SELECT gs.group_id FROM groups gs WHERE gs.passwd_id = ?))\n";
        $sql               ~= "                             AND (_perms)._group._del = true) OR (_perms)._other._del = true);\n";
        $dbh.execute($sql, $page, $full-name, $pattern, $status, $page, $_admin, $loggedin_id, $primary_group_id, $loggedin_id);
    }
    return True;
} # sub add-pseudo-pages(Str $page, Status $status is copy, Str $full-name, Str $pattern --> Bool) is export #

sub launch-link(Str $section, Str $link --> Bool) is export {
    my Bool:D $loggedin                  = so %session«loggedin»;
    my Int    $loggedin_id               =    ((%session«loggedin_id»               === Any) ?? Int   !! %session«loggedin_id» );
    my Str    $loggedin_username         =    ((%session«loggedin_username»         === Any) ?? Str   !! %session«loggedin_username» );
    my Bool:D $_admin                    = so %session«loggedin_admin»;
    my Str    $display_name              =    ((%session«loggedin_display_name»     === Any) ?? Str   !! %session«loggedin_display_name» );
    my Str    $given                     =    ((%session«loggedin_given»            === Any) ?? Str   !! %session«loggedin_given» );
    my Str    $family                    =    ((%session«loggedin_family»           === Any) ?? Str   !! %session«loggedin_family» );
    my Str    $loggedin_email            =    ((%session«loggedin_email»            === Any) ?? Str   !! %session«loggedin_email» );
    my Str    $phone_number              =    ((%session«loggedin_phone_number»     === Any) ?? Str   !! %session«loggedin_phone_number» );
    my Str    $groupname                 =    ((%session«loggedin_groupname»        === Any) ?? Str   !! %session«loggedin_groupname» );
    my Int    $primary_group_id          =    ((%session«loggedin_groupnname_id»    === Any) ?? Int   !! %session«loggedin_groupnname_id» );
    my Str    $loggedin_prefix           =    ((%session«loggedin_prefix»           === Any) ?? Str   !! %session«loggedin_prefix» );
    my Str    $loggedin_escape           =    ((%session«loggedin_escape»           === Any) ?? Str   !! %session«loggedin_escape» );
    my Str    $loggedin_punct            =    ((%session«loggedin_punct»            === Any) ?? Str   !! %session«loggedin_punct» );
    my Regex  $loggedin_landline_pattern =    ((%session«loggedin_landline_pattern» === Any) ?? Regex !! %session«loggedin_landline_pattern» );
    my Regex  $loggedin_mobile_pattern   =    ((%session«loggedin_mobile_pattern»   === Any) ?? Regex !! %session«loggedin_mobile_pattern» );
    unless $loggedin {
        say "You must be loggedin to use this function: {&*ROUTINE.name}";
        return False;
    }
    my Str:D $sql       = "SELECT link FROM alias_union_links aul\n";
    $sql               ~= "WHERE aul.alias_name = ? AND aul.name = ? AND (? = true OR (aul.userid = ? AND (aul)._perms._user._read = true)\n";
    $sql               ~= "       OR ((aul.groupid = ? OR aul.groupid IN (SELECT gs.group_id FROM groups gs WHERE gs.passwd_id = ?))\n";
    $sql               ~= "                             AND (aul)._perms._group._read = true) OR (aul)._perms._other._read = true);\n";
    my $sth = $dbh.execute($sql, $section, $link, $_admin, $loggedin_id, $primary_group_id, $loggedin_id);
    my @values = $sth.allrows(:array-of-hash);
    my @cmd = qqww{xdg-open};
    my @lnks;
    for @values -> %value {
        my $link = %value«link»;
        @lnks.append($link);
    }
    if @lnks {
        @cmd.append(@lnks);
        my Proc $res = run @cmd;
        my Bool $result = ($res.exitcode == 0);
        return $result;
    }else{
        "no such link found".say;
    }
} # sub launch-link(Str $section, Str $link --> Bool) is export #

sub generate-hash(Str:D $password --> Str) is export {
    my $pbkdf2 = Crypt::PBKDF2.new( 
            hash_class => 'HMACSHA2', 
            hash_args => {sha_size => 512},
            iterations => 32_768,
            output_len => 128,
            salt_len => 16,
            length_limit => 144
        );
    return $pbkdf2.generate($password);
} # sub generate-hash(Str:D $password --> Str) is export #

sub validate(Str:D $hashed-password, Str:D $password --> Bool) is export {
    my $pbkdf2 = Crypt::PBKDF2.new( 
            hash_class => 'HMACSHA2', 
            hash_args => {sha_size => 512},
            iterations => 32_768,
            output_len => 128,
            salt_len => 16,
            length_limit => 144
        );
    #`«««
    my $pbkdf2_old = Crypt::PBKDF2.new( 
            hash_class => 'HMACSHA2', 
            hash_args => {sha_size => 512},
            iterations => 2048,
            output_len => 64,
            salt_len => 16,
            length_limit => 144
        );
    # »»»
    my Bool:D $result = False;
    try {
        CATCH {
            default {
                say "Got here catching error";
                $result = False;
                .backtrace;
                .Str.say;
                .rethrow;
            }
        }

        $result = $pbkdf2.validate($hashed-password, $password) != 0;
    }
    return $result;
} # sub validate(Str:D $hashed-password, Str:D $password --> Bool) is export #

sub login(Str:D $username where { $username ~~ rx/^ \w+ $/}, Str:D $passwd is copy --> Bool) is export {
    my $sql                      = "SELECT p.id, p.username, p._password, p.primary_group_id, p._admin, c.prefix, c._escape, c.punct, pd.display_name, pd.given, pd._family,\n";
    $sql                        ~= "e._email, ph._number phone_number, g._name groupname, g.id group_id, cr.landline_pattern, cr.mobile_pattern\n";
    $sql                        ~= "FROM passwd p JOIN passwd_details pd ON p.passwd_details_id = pd.id JOIN email e ON p.email_id = e.id\n";
    $sql                        ~= "         LEFT JOIN phone  ph ON ph.id = pd.primary_phone_id JOIN _group g ON p.primary_group_id = g.id\n";
    $sql                        ~= "         LEFT JOIN country  c ON c.id = pd.country_id JOIN country_regions cr ON cr.country_id = c.id\n";
    $sql                        ~= "WHERE p.username = ?\n";
    my $sth                      = $dbh.execute($sql, $username);
    my %val                      = $sth.row(:hash);
    without %val«id» {
        "Failed to login for user: $username".say;
        return False;
    }
    my Int:D   $loggedin_id       = %val«id»;
    my Str:D   $loggedin_username = %val«username»;
    my Int:D   $primary_group_id  = %val«group_id»;
    my Str:D   $hashed-password   = %val«_password»;
    my Bool:D  $_admin            = so %val«_admin»;
    my Str:D   $display_name      = %val«display_name»;
    my Str:D   $given             = %val«given»;
    my Str:D   $family            = %val«_family»;
    my Str:D   $email             = %val«_email»;
    my Str:D   $phone_number      = %val«phone_number»;
    my Str:D   $groupname         = %val«groupname»;
    my Str:D   $prefix            = %val«prefix»;
    my Str:D   $escape            = %val«_escape»;
    my Str:D   $punct             = %val«punct»;
    my Str:D   $land_pattern      = %val«landline_pattern»;
    my Str:D   $mob_pattern       = %val«mobile_pattern»;
    #$land_pattern               ~~ s:g/ '[' (<-[\ \x5D\x5B]>*) ' ' (<-[\x5D\x5B]>*) ']' /[$0\\ $1]/; # fixup for error in  ECMA262Regex.compile() # redundant he fixed ECMA262Regex #
    #$mob_pattern                ~~ s:g/ '[' (<-[\ \x5D\x5B]>*) ' ' (<-[\x5D\x5B]>*) ']' /[$0\\ $1]/;
    my Regex:D $landline_pattern  = ECMA262Regex.compile("^$land_pattern\$");
    my Regex:D $mobile_pattern    = ECMA262Regex.compile("^$mob_pattern\$");
    my Int:D $cnt = 0;
    while !validate($hashed-password, $passwd) && $cnt < 4 {
        unless $cnt < 4 {
            say "too many retrys bailing";
            return False;
        }
        $passwd = getpass "password > ";
        $cnt++;
    }
    if validate($hashed-password, $passwd) {
        %session«loggedin»                  = $loggedin_id;
        %session«loggedin_id»               = $loggedin_id;
        %session«loggedin_username»         = $loggedin_username;
        %session«loggedin_admin»            = $_admin;
        %session«loggedin_display_name»     = $display_name;
        %session«loggedin_given»            = $given;
        %session«loggedin_family»           = $family;
        %session«loggedin_email»            = $email;
        %session«loggedin_phone_number»     = $phone_number;
        %session«loggedin_groupname»        = $groupname;
        %session«loggedin_groupnname_id»    = $primary_group_id;
        %session«loggedin_prefix»           = $prefix;
        %session«loggedin_escape»           = $escape;
        %session«loggedin_punct»            = $punct;
        %session«loggedin_landline_pattern» = $landline_pattern;
        %session«loggedin_mobile_pattern»   = $mobile_pattern;
        %session.save;
        return True;
    }
    say "Failed to login for user: $username";
    return False;
} # sub login(Str:D $username where { $username ~~ rx/^ \w+ $/}, Str:D $passwd --> Bool) is export #
 
sub change-passwd(Str:D $old-passwd is copy, Str:D $passwd is copy, Str:D $repeat-pwd is copy, Str:D $user, Bool:D $force --> Bool) is export {
    my Bool:D $result                    = False;
    my Bool:D $loggedin                  = so %session«loggedin»;
    my Int    $loggedin_id               =    ((%session«loggedin_id»               === Any) ?? Int   !! %session«loggedin_id» );
    my Str    $loggedin_username         =    ((%session«loggedin_username»         === Any) ?? Str   !! %session«loggedin_username» );
    my Bool:D $_admin                    = so %session«loggedin_admin»;
    my Str    $display_name              =    ((%session«loggedin_display_name»     === Any) ?? Str   !! %session«loggedin_display_name» );
    my Str    $given                     =    ((%session«loggedin_given»            === Any) ?? Str   !! %session«loggedin_given» );
    my Str    $family                    =    ((%session«loggedin_family»           === Any) ?? Str   !! %session«loggedin_family» );
    my Str    $loggedin_email            =    ((%session«loggedin_email»            === Any) ?? Str   !! %session«loggedin_email» );
    my Str    $phone_number              =    ((%session«loggedin_phone_number»     === Any) ?? Str   !! %session«loggedin_phone_number» );
    my Str    $groupname                 =    ((%session«loggedin_groupname»        === Any) ?? Str   !! %session«loggedin_groupname» );
    my Int    $primary_group_id          =    ((%session«loggedin_groupnname_id»    === Any) ?? Int   !! %session«loggedin_groupnname_id» );
    my Str    $loggedin_prefix           =    ((%session«loggedin_prefix»           === Any) ?? Str   !! %session«loggedin_prefix» );
    my Str    $loggedin_escape           =    ((%session«loggedin_escape»           === Any) ?? Str   !! %session«loggedin_escape» );
    my Str    $loggedin_punct            =    ((%session«loggedin_punct»            === Any) ?? Str   !! %session«loggedin_punct» );
    my Regex  $loggedin_landline_pattern =    ((%session«loggedin_landline_pattern» === Any) ?? Regex !! %session«loggedin_landline_pattern» );
    my Regex  $loggedin_mobile_pattern   =    ((%session«loggedin_mobile_pattern»   === Any) ?? Regex !! %session«loggedin_mobile_pattern» );
    unless $loggedin {
        say "You must be loggedin to use this function: {&*ROUTINE.name}";
        return False;
    }
    if $force && !$_admin {
        "option force not alloed for non admin user".say;
        return False;
    }
    without $loggedin_username {
        say "something is wrong with your login no defined username, logout and in again";
        return False;
    }
    unless $loggedin_username ~~ rx/^ \w+ $/ {
        say "something is wrong with your login bad username: $loggedin_username, logout and in again";
        return False;
    }
    my Str:D $username           = $loggedin_username;
    if $user ne $loggedin_username && $_admin {
        $username = $user;
    } elsif $user ne $loggedin_username {
        "only an admin can change some one elses password".say;
        return False;
    }
    my $sql                      = "SELECT p.id, p.username, p._password\n";
    $sql                        ~= "FROM passwd p\n";
    $sql                        ~= "WHERE p.username = ?\n";
    my $sth                      = $dbh.execute($sql, $username);
    my %val                      = $sth.row(:hash);
    my $id                       = %val«id»;
    my $old-hashed-password      = %val«_password»;
    without $id {
        "username not found in the db".say;
        return False;
    }
    unless $id == $loggedin_id || $_admin {
        say "something is wrong with your login id's dont match, logout and in again";
        return False;
    }
    my Int:D $retrys = 0;
    while !$force && ($old-passwd eq '' || !validate($old-hashed-password, $old-passwd)) {
        last if $retrys >= 4;
        say "wrong old password";
        $old-passwd = getpass "Old password: ";
        $retrys++;
    }
    unless $force || validate($old-hashed-password, $old-passwd) {
        say "too many retrys";
        return False;
    }
    $retrys = 0;
    while !valid-pwd($passwd, :nowhitespace) || $passwd ne $repeat-pwd {
        unless $retrys < 4 {
            "too many retrys".say;
            return False;
        }
        $passwd = getpass "password: ";
        $repeat-pwd = getpass "repeat-password: ";
        $retrys++;
    }
    my Str:D $hashed-passwd = generate-hash($passwd);
    my $len = $hashed-passwd.chars;
    if validate($hashed-passwd, $passwd) {
        CATCH {
            when X::DBDish::DBError {
                .message.say; .rethrow;
            }
            default {
                .say; .rethrow;
            }
        }
        $sql  = qq{UPDATE passwd SET _password = ? WHERE id = ?};
        my $sth2                 = $dbh.execute($sql, $hashed-passwd, $id);
        $result = True;
    } else {
        "Error: password validation failed.".say;
        $result = False;
    }
    return $result;
} # sub change-passwd(Str:D $old-password, Str:D $password, Str:D $repeat --> Bool) is export #

sub logout(Bool:D $sure is copy --> Bool) is export {
    my Bool:D $tmp = False;
    if !$sure {
        $sure = ask 'are you sure you realy want to logout y/N > ', 'N', :type(Bool);
    }
    if $sure {
        %session«loggedin»                  = False;
        %session«loggedin_id»               = 0;
        %session«loggedin_username»         = Nil;
        %session«loggedin_admin»            = False;
        %session«loggedin_display_name»     = Nil;
        %session«loggedin_given»            = Nil;
        %session«loggedin_family»           = Nil;
        %session«loggedin_email»            = Nil;
        %session«loggedin_phone_number»     = Nil;
        %session«loggedin_groupname»        = Nil;
        %session«loggedin_groupnname_id»    = 0;
        %session«loggedin_prefix»           = Nil;
        %session«loggedin_escape»           = Nil;
        %session«loggedin_punct»            = Nil;
        %session«loggedin_landline_pattern» = Nil;
        %session«loggedin_mobile_pattern»   = Nil;
        %session.save;
        return True;
    }
    return False;
} # sub logout(Bool:D $sure is copy --> Bool) is export #

sub whoami( --> Bool) is export {
    my Bool:D $loggedin                  = so %session«loggedin»;
    my Int    $loggedin_id               =    ((%session«loggedin_id»               === Any) ?? Int   !! %session«loggedin_id» );
    my Str    $loggedin_username         =    ((%session«loggedin_username»         === Any) ?? 'Str' !! %session«loggedin_username» );
    my Bool:D $_admin                    = so %session«loggedin_admin»;
    my Str    $display_name              =    ((%session«loggedin_display_name»     === Any) ?? 'Str' !! %session«loggedin_display_name» );
    my Str    $given                     =    ((%session«loggedin_given»            === Any) ?? 'Str' !! %session«loggedin_given» );
    my Str    $family                    =    ((%session«loggedin_family»           === Any) ?? 'Str' !! %session«loggedin_family» );
    my Str    $loggedin_email            =    ((%session«loggedin_email»            === Any) ?? 'Str' !! %session«loggedin_email» );
    my Str    $phone_number              =    ((%session«loggedin_phone_number»     === Any) ?? 'Str' !! %session«loggedin_phone_number» );
    my Str    $groupname                 =    ((%session«loggedin_groupname»        === Any) ?? 'Str' !! %session«loggedin_groupname» );
    my Int    $primary_group_id          =    ((%session«loggedin_groupnname_id»    === Any) ?? Int   !! %session«loggedin_groupnname_id» );
    my Str    $loggedin_prefix           =    ((%session«loggedin_prefix»           === Any) ?? 'Str' !! %session«loggedin_prefix» );
    my Str    $loggedin_escape           =    ((%session«loggedin_escape»           === Any) ?? 'Str' !! %session«loggedin_escape» );
    my Str    $loggedin_punct            =    ((%session«loggedin_punct»            === Any) ?? 'Str' !! %session«loggedin_punct» );
    my Regex  $loggedin_landline_pattern =    ((%session«loggedin_landline_pattern» === Any) ?? Regex !! %session«loggedin_landline_pattern» );
    my Regex  $loggedin_mobile_pattern   =    ((%session«loggedin_mobile_pattern»   === Any) ?? Regex !! %session«loggedin_mobile_pattern» );
    my Str    $punct             =    $loggedin_punct;
    $punct                      ~~    s/ \x20 /\\x20/;
    my Int $width = terminal-width;
    my Int $m = max(("$loggedin", "$loggedin_id", $loggedin_username, "$_admin", $display_name, $given, $loggedin_email, $phone_number, $groupname,
                         "$primary_group_id", $loggedin_prefix, $loggedin_escape, $loggedin_punct, $loggedin_landline_pattern.raku, $loggedin_mobile_pattern.raku,
                                                       "'$loggedin_punct' ==> '$punct'", ).map: { .chars });
    my Int $w = min($width - 28 - 2, $m + 2);
    my Int $cnt = 0;
    put (($cnt % 2 == 0) ?? t.bg-yellow !! t.bg-color(0,255,0)) ~ t.bold ~ t.bright-blue ~ sprintf("%-28s: %-*s", trailing-dots('loggedin',                  28), $w, $loggedin) ~ t.text-reset;
    $cnt++;
    put (($cnt % 2 == 0) ?? t.bg-yellow !! t.bg-color(0,255,0)) ~ t.bold ~ t.bright-blue ~ sprintf("%-28s: %-*s", trailing-dots('loggedin_id',               28), $w, (($loggedin_id === Int) ?? 'Int' !! $loggedin_id)) ~ t.text-reset;
    $cnt++;
    put (($cnt % 2 == 0) ?? t.bg-yellow !! t.bg-color(0,255,0)) ~ t.bold ~ t.bright-blue ~ sprintf("%-28s: %-*s", trailing-dots('loggedin_username',         28), $w, $loggedin_username) ~ t.text-reset;
    $cnt++;
    put (($cnt % 2 == 0) ?? t.bg-yellow !! t.bg-color(0,255,0)) ~ t.bold ~ t.bright-blue ~ sprintf("%-28s: %-*s", trailing-dots('_admin',                    28), $w, $_admin) ~ t.text-reset;
    $cnt++;
    put (($cnt % 2 == 0) ?? t.bg-yellow !! t.bg-color(0,255,0)) ~ t.bold ~ t.bright-blue ~ sprintf("%-28s: %-*s", trailing-dots('display_name',              28), $w, $display_name) ~ t.text-reset;
    $cnt++;
    put (($cnt % 2 == 0) ?? t.bg-yellow !! t.bg-color(0,255,0)) ~ t.bold ~ t.bright-blue ~ sprintf("%-28s: %-*s", trailing-dots('given',                     28), $w, $given) ~ t.text-reset;
    $cnt++;
    put (($cnt % 2 == 0) ?? t.bg-yellow !! t.bg-color(0,255,0)) ~ t.bold ~ t.bright-blue ~ sprintf("%-28s: %-*s", trailing-dots('family',                    28), $w, $family) ~ t.text-reset;
    $cnt++;
    put (($cnt % 2 == 0) ?? t.bg-yellow !! t.bg-color(0,255,0)) ~ t.bold ~ t.bright-blue ~ sprintf("%-28s: %-*s", trailing-dots('loggedin_email',            28), $w, $loggedin_email) ~ t.text-reset;
    $cnt++;
    put (($cnt % 2 == 0) ?? t.bg-yellow !! t.bg-color(0,255,0)) ~ t.bold ~ t.bright-blue ~ sprintf("%-28s: %-*s", trailing-dots('phone_number',              28), $w, $phone_number) ~ t.text-reset;
    $cnt++;
    put (($cnt % 2 == 0) ?? t.bg-yellow !! t.bg-color(0,255,0)) ~ t.bold ~ t.bright-blue ~ sprintf("%-28s: %-*s", trailing-dots('groupname',                 28), $w, $groupname) ~ t.text-reset;
    $cnt++;
    put (($cnt % 2 == 0) ?? t.bg-yellow !! t.bg-color(0,255,0)) ~ t.bold ~ t.bright-blue ~ sprintf("%-28s: %-*s", trailing-dots('primary_group_id',          28), $w, (($primary_group_id === Int) ?? 'Int' !! $primary_group_id)) ~ t.text-reset;
    $cnt++;
    put (($cnt % 2 == 0) ?? t.bg-yellow !! t.bg-color(0,255,0)) ~ t.bold ~ t.bright-blue ~ sprintf("%-28s: %-*s", trailing-dots('loggedin_prefix',           28), $w, $loggedin_prefix) ~ t.text-reset;
    $cnt++;
    put (($cnt % 2 == 0) ?? t.bg-yellow !! t.bg-color(0,255,0)) ~ t.bold ~ t.bright-blue ~ sprintf("%-28s: %-*s", trailing-dots('loggedin_escape',           28), $w, $loggedin_escape) ~ t.text-reset;
    $cnt++;
    put (($cnt % 2 == 0) ?? t.bg-yellow !! t.bg-color(0,255,0)) ~ t.bold ~ t.bright-blue ~ sprintf("%-28s: %-*s", trailing-dots('loggedin_punct',            28), $w, "'$loggedin_punct' ==> '$punct'") ~ t.text-reset;
    $cnt++;
    put (($cnt % 2 == 0) ?? t.bg-yellow !! t.bg-color(0,255,0)) ~ t.bold ~ t.bright-blue ~ sprintf("%-28s: %-*s", trailing-dots('loggedin_landline_pattern', 28), $w, $loggedin_landline_pattern.raku) ~ t.text-reset;
    $cnt++;
    put (($cnt % 2 == 0) ?? t.bg-yellow !! t.bg-color(0,255,0)) ~ t.bold ~ t.bright-blue ~ sprintf("%-28s: %-*s", trailing-dots('loggedin_mobile_pattern',   28), $w, $loggedin_mobile_pattern.raku) ~ t.text-reset;
    $cnt++;
    return True;
} # sub whoami( --> Bool) is export #

subset IdType is export of Int where 0 <= * <= 9_223_372_036_854_775_807;

sub centre(Str:D $text, Int:D $width is copy, Str:D $fill = ' ' --> Str) {
    my Str $result = $text;
    $width -= wcswidth($result);
    $width = $width div wcswidth($fill);
    my Int:D $w  = $width div 2;
    $result = $fill x $w ~ $result ~ $fill x ($width - $w);
    return $result;
}

sub lead-dots(Str:D $text, Int:D $width is copy, Str:D $fill = '.' --> Str) {
    my Str $result = " $text";
    $width -= wcswidth($result);
    $width = $width div wcswidth($fill);
    $result = $fill x $width ~ $result;
    return $result;
} # sub lead-dots(Str $text, Int:D $width --> Str) #

sub trailing-dots(Str:D $text, Int:D $width is copy, Str:D $fill = '.' --> Str) {
    my Str $result = $text;
    $width -= wcswidth($result);
    $width = $width div wcswidth($fill);
    $result ~= $fill x $width;
    return $result;
} # sub trailing-dots(Str $text, Int:D $width --> Str) #

sub dots(Str:D $ind, Int:D $width is copy, Str:D $fill = '.' --> Str) {
    my Str $result = $ind;
    $width -= wcswidth($result);
    $width = $width div wcswidth($fill);
    $result ~= $fill x $width;
    return $result;
} # sub dots(Str $ind, Int:D $width --> Str) #

sub get-countries(--> Hash) {
    my %countries;
    my @_country;
    try {
        CATCH {
            default {
                .backtrace;
                .Str.say; .rethrow 
            }
        }

        my $result;
        my Str:D $sql = '';
        $sql  = "SELECT\n";
        $sql ~= "c.id, c.cc, c.prefix, c._name, _flag, c._escape, c.punct\n";
        $sql ~= "FROM country c\n";
        $sql ~= "ORDER BY c._name, c.cc\n";
        my $query  = $dbh.prepare($sql);
        try {
            CATCH {
                default {
                    say "SELECT FROM country failed: $_", "\$sql == $sql";
                    .backtrace;
                    .Str.say; .rethrow 
                }
            }            
            $result = $query.execute();
        }
        unless $result {
            die "SELECT FROM country failed: \$sql == $sql";
        }
        @_country = $result.allrows(:array-of-hash);
        for @_country -> %val {
            my $cc_id  = %val«id»;
            my $cc     = %val«cc»;
            my $prefix = %val«prefix»;
            %val«country_regions» = [];
            %countries{$cc_id} = %val;
        }
        $result.dispose;
        #$query.dispose;
        $sql  = "SELECT\n";
        $sql ~= "    cr.id cr_id, cr.region, cr.distinguishing, cr.country_id, cr.landline_pattern, cr.mobile_pattern,\n";
        $sql ~= "    cr.landline_title, cr.mobile_title, cr.landline_placeholder, cr.mobile_placeholder\n";
        $sql ~= "FROM country_regions cr\n";
        $query  = $dbh.prepare($sql);
        try {
            CATCH {
                default {
                    say "SELECT FROM country_regions failed: $_", "\$sql == $sql";
                    .backtrace;
                    .Str.say; .rethrow 
                }
            }
            $result = $query.execute();
        }
        unless $result {
            die "SELECT FROM country_regions failed: \$sql == $sql";
        }
        my @values = $result.allrows(:array-of-hash);
        for @values -> %val {
            my $country_id = %val«country_id»;
            %countries{$country_id}«country_regions».push: %val;
        }
    }
    return { countries => %countries, _country => @_country, };
} # sub get-countries(--> List) #

sub valid-country-cc-id(Int:D $val, %countries --> Bool ) {
    return %countries{$val}:exists;
} # sub valid-country-cc-id(Int:D $val, %countries --> Bool ) #

sub valid-country-region-id(Int:D $val, Int:D $cc_id, %countries --> Bool) {
    if %countries{$cc_id}:exists {
        my %row             = %countries{$cc_id};
        my @country_regions = |@(%row«country_regions»);
        for @country_regions -> %row {
            return True if %row«cr_id» == $val;
        }
    }
    return False;
} # sub valid-country-region-id(Int:D $tmp, Int:D $cc_id, %countries --> Bool) #

sub normalise_top(Int:D $top is copy, Int:D $pos, Int:D $window-height, Int:D $length --> Int:D) {
    $top = $pos - $window-height div 2 if $pos < $top;
    $top = $pos - $window-height div 2 if $pos >= $top + $window-height;
    $top = $length - $window-height if $top + $window-height >= $length;
    $top = 0 if $top < 0;
    return $top;
} # sub normalise_top(Int:D $top is copy, Int:D $pos, Int:D $window-height, Int:D $length --> Int:D) #

###############################################################################################################
#                                                                                                             #
#       Emulates dropdown/list behaviour as best you can on a terminal. not a real dropdown always down!!!    #
#                                                                                                             #
###############################################################################################################
sub dropdown(Int:D $id, Int:D $window-height, Str:D $id-name, &setup-option-str:(Int:D $c, @a --> Str:D),
                &get-result:(Int:D $res, Int:D $p, Int:D $l, @a --> Int:D), @array --> Int) {
    my Int $result = $id;
    try {
        my Int $pos    = -1;
        my Int $top    = -1;
        my $bgcolour;
        my $fgcolour;
        my Int $length         = @array.elems;
        for @array.kv -> $idx, %r {
            if %r{$id-name} == $result {
                $pos = $idx;
                last; # found so don't waste resources #
            }
        }
        $top = normalise_top($top, $pos, $window-height, $length);
        my Str $key;
        my $original-flags := Term::termios.new(:fd($*IN.native-descriptor)).getattr;
        @signal.push: {
            $original-flags.setattr(:NOW);
        };
        my $flags := Term::termios.new(:fd($*IN.native-descriptor)).getattr;
        $flags.unset_lflags('ICANON');
        $flags.unset_lflags('ECHO');
        $flags.setattr(:NOW);
        my Int $width = terminal-width;
        $width = 80 if $width === Int;
        my Int:D $m = 0;
        loop (my Int $i = 0; $i < $length; $i++) {
            $m = max($m, wcswidth(&setup-option-str($i, @array)));
        } # loop (my Int $i = 0; $i < $length; $i++) #
        $m = max($m, wcswidth('use up and down arrows or page up and down : and enter to select'));
        my Int:D $w = min($width - 10 - 24 - 2 - 42, $m + 2);
        loop {
            put t.clear-screen;
            loop (my Int $cnt = $top; $cnt < $top + $window-height && $cnt < $length; $cnt++) {
                if $cnt == $pos {
                    $bgcolour = t.bg-color(0,0,255);
                    $fgcolour = t.bright-yellow;
                } elsif $cnt % 2 == 0 {
                    $bgcolour = t.bg-yellow;
                    $fgcolour = t.bright-blue;
                } else {
                    $bgcolour = t.bg-color(0,255,0);
                    $fgcolour = t.bright-blue;
                }
                put $bgcolour ~ t.bold ~ $fgcolour ~ sprintf("%-*s", $w, &setup-option-str($cnt, @array)) ~ t.text-reset;
            } # loop (my Int $cnt = $top; $cnt <= $top + $window-height; $cnt++) #
            $cnt = $top + $window-height;
            my Int:D $wdth = $w div 2;
            put t.bg-green ~ t.bold ~ t.bright-blue ~ sprintf("%-*s: %-*s", $wdth, trailing-dots('use up and down arrows or page up and down', 42), $w - $wdth, 'and enter to select') ~ t.text-reset;
            $cnt++;
            $key = $*IN.read(10).decode;
            given $key {
                when 'k'          { $pos--; $pos = 0 if $pos < 0; $top-- if $pos < $top; $top = normalise_top($top, $pos, $window-height, $length); } # up #
                when 'j'          { $pos++; $pos = ($length - 1) if $pos >= $length; $top++ if $pos >= $top + $window-height; $top = normalise_top($top, $pos, $window-height, $length); } # down #
                when "\x[1B][A"   { $pos--; $pos = 0 if $pos < 0; $top-- if $pos < $top; $top = normalise_top($top, $pos, $window-height, $length); } # up #
                when "\x[1B][B"   { $pos++; $pos = ($length - 1) if $pos >= $length; $top++ if $pos >= $top + $window-height; $top = normalise_top($top, $pos, $window-height, $length); } # down #
                when "\x[1B][5~"  { $pos -= ($window-height - 1); $pos = 0 if $pos < 0; $top -= ($window-height - 1) if $pos < $top; $top = normalise_top($top, $pos, $window-height, $length); } # page up #
                when "\x[1B][6~"  { $pos += ($window-height - 1); $pos = ($length - 1) if $pos >= $length; $top = normalise_top($top, $pos, $window-height, $length); } # page down #
                when "\x[1B][H"   { $pos = 0; $top = 0; $top = normalise_top($top, $pos, $window-height, $length); } # home #
                when "\x[1B][F"   { $pos = ($length - 1); $top = $length - $window-height; $top = normalise_top($top, $pos, $window-height, $length); } # end #
                when "\x[1B]"     { last; } # esc #
                when "\n"         {   # enter #
                                      #`«««
                                      if $pos ~~ 0..^$length {
                                          my %row = |%(@array[$pos]);
                                          $result = %row{$id-name} if %row{$id-name}:exists;
                                      }
                                      # »»»
                                      $result = &get-result($result, $pos, $length, @array);
                                      last;
                                  }
                when "q"         { last; } # quit #
                when "Q"         { last; } # quit #
            }
        } # loop #
        $original-flags.setattr(:NOW);
        @signal.pop if @signal;
        CATCH {
            default {
                $original-flags.setattr(:NOW);
                @signal.pop if @signal;
                .backtrace;
                .Str.say; .rethrow 
            }
        }
    } # try #
    return $result;
} #  sub dropdown(Int:D $id, Int:D $window-height, Str:D $id-name, &setup-option-str, &get-result, @array --> Int) #

sub gzzreadline_call(Str:D $prompt, Str:D $prefill, Gzz_readline:D $gzzreadline --> Str ) {
    my Str $result;
    try {
        my $original-flags := Term::termios.new(:fd($*IN.native-descriptor)).getattr;
        @signal.push: {
            $original-flags.setattr(:NOW);
        }; # insure that we call the reset command if it dies on a signal #
        $result = $gzzreadline.gzzreadline($prompt, $prefill);
        $original-flags.setattr(:NOW);
        @signal.pop if @signal; # done without signal so remove our handler #
        CATCH {
            default {
                $original-flags.setattr(:NOW);
                @signal.pop if @signal;
                .backtrace;
                .Str.say; .rethrow 
            }
        }
    } # try #
    return $result;
} # sub gzzreadline_call(Str:D $prompt, Str:D $prefill, Gzz_readline:D $gzzreadline --> Str ) #

sub ask-for-all-user-values(Str:D $username is rw, Str:D $group is rw, Str:D $Groups is rw, Str:D $given-names is rw,
                            Str:D $surname is rw, Str:D $display-name is rw,
                            Str:D $residential-unit is rw, Str:D $residential-street is rw, Str:D $residential-city_suberb is rw,
                            Str:D $residential-postcode is rw, Str:D $residential-region is rw, Str:D $residential-country is rw,
                            Bool:D $same-as-residential is rw,
                            Str:D $postal-unit is rw, Str:D $postal-street is rw, Str:D $postal-city_suberb is rw,
                            Str:D $postal-postcode is rw, Str:D $postal-region is rw, Str:D $postal-country is rw,
                            Str:D $email is rw, Int:D $cc_id is rw, Int $country_region_id is rw, Str:D $mobile is rw, Str:D $landline is rw,
                            Regex $mobile_pattern is rw, Regex $landline_pattern is rw, Str:D $escape is rw, Str:D $prefix is rw, Str:D $punct is rw, Bool:D $admin is rw --> Bool) {

    my Bool $return                      = True;
    my Bool:D $loggedin                  = so %session«loggedin»;
    my Int    $loggedin_id               =    ((%session«loggedin_id»               === Any) ?? Int   !! %session«loggedin_id» );
    my Str    $loggedin_username         =    ((%session«loggedin_username»         === Any) ?? Str   !! %session«loggedin_username» );
    my Bool:D $_admin                    = so %session«loggedin_admin»;
    my Str    $display_name              =    ((%session«loggedin_display_name»     === Any) ?? Str   !! %session«loggedin_display_name» );
    my Str    $given                     =    ((%session«loggedin_given»            === Any) ?? Str   !! %session«loggedin_given» );
    my Str    $family                    =    ((%session«loggedin_family»           === Any) ?? Str   !! %session«loggedin_family» );
    my Str    $loggedin_email            =    ((%session«loggedin_email»            === Any) ?? Str   !! %session«loggedin_email» );
    my Str    $phone_number              =    ((%session«loggedin_phone_number»     === Any) ?? Str   !! %session«loggedin_phone_number» );
    my Str    $groupname                 =    ((%session«loggedin_groupname»        === Any) ?? Str   !! %session«loggedin_groupname» );
    my Int    $primary_group_id          =    ((%session«loggedin_groupnname_id»    === Any) ?? Int   !! %session«loggedin_groupnname_id» );
    my Str    $loggedin_prefix           =    ((%session«loggedin_prefix»           === Any) ?? Str   !! %session«loggedin_prefix» );
    my Str    $loggedin_escape           =    ((%session«loggedin_escape»           === Any) ?? Str   !! %session«loggedin_escape» );
    my Str    $loggedin_punct            =    ((%session«loggedin_punct»            === Any) ?? Str   !! %session«loggedin_punct» );
    my Regex  $loggedin_landline_pattern =    ((%session«loggedin_landline_pattern» === Any) ?? Regex !! %session«loggedin_landline_pattern» );
    my Regex  $loggedin_mobile_pattern   =    ((%session«loggedin_mobile_pattern»   === Any) ?? Regex !! %session«loggedin_mobile_pattern» );
    if !$loggedin {
        say "you must be logged in to use this function\t{$?MODULE.gist}\t{&?ROUTINE.name} in $?FILE";
        return False;
    }
    try {
        CATCH {
            # will definitely catch all the exception 
            default {
                        put t.restore-screen;
                        .backtrace;
                        .Str.say;
                        .rethrow;
                    }
        }
        my %res                    = get-countries;
        my %countries              = %res«countries»;
        my @_country               = |@(%res«_country»);
        @_country                  = |@_country.sort: { my %u = %($^a); my %v = %($^b);  my $res = %u«_name».lc.trim cmp %v«_name».lc.trim; (($res == Same) ?? (%u«prefix».trim cmp %v«prefix».trim) !! $res ) };
        put t.save-screen;
        # insure that the screen is reset on error #
        my &stack = sub ( --> Nil) {
            while @signal {
                my &elt = @signal.pop;
                &elt();
            }
        };
        signal(SIGINT, SIGHUP, SIGQUIT, SIGTERM, SIGQUIT).tap( { &stack(); put t.restore-screen; say "$_ Caught"; exit 0 } );
        my Str $choice         = '';
        my Bool $display-auto  = True;
        my $valid              = Email::Valid.new(:simple(True), :allow-ip);
        my $gzzreadline        = Gzz_readline.new;
        my Int $cr-id          = 0;
        my Str $region         = '';
        my Str $distinguishing = '';
        $cc_id                 = 27 unless %countries{$cc_id}:exists;
        my %row                = %countries{$cc_id};
        my Str $name           = %row«_name»;
        $residential-country   = $name;
        $postal-country        = $name;
        my Str $cc             = %row«cc»;
        my Str $flag           = uniparse 'Australia';
        try {
            CATCH {
                default {
                    my $Name = $name;
                    $Name ~~ s:g/ <wb> 'and' <wb> /\&/;
                    try {
                        CATCH {
                            default { $flag = uniparse 'PENGUIN'}
                        }
                        $flag = uniparse $Name;
                    }
                }
            }
            $flag   = uniparse $name;
        }
        $prefix                = %row«prefix»;
        $escape                = ((%row«_escape» === Str || %row«_escape» === Any) ?? '0'  !! %row«_escape»); #  guess a common value #
        $punct                 = ((%row«punct» === Str   || %row«punct» === Any  ) ?? '- ' !! %row«punct»  ); #  guess a common value #
        my @country_regions    = |@(%row«country_regions»);
        my Int $ind            = 0;
        @country_regions       = |@country_regions.sort: { my %u = %($^a); my %v = %($^b);  my $res = %u«region».lc.trim cmp %v«region».lc.trim; (($res == Same) ?? (%u«distinguishing».trim cmp %v«distinguishing».trim) !! $res ) };
        for @country_regions.kv -> $idx, %val {
            $ind = $idx if %val«region».lc.trim eq $region.lc.trim && %val«distinguishing».trim eq $distinguishing.trim;
        }
        my %value                = @country_regions[$ind];
        $cr-id                   = %value«cr_id»;
        $region                  = %value«region»;
        $residential-region      = $region;
        $postal-region           = $region;
        $distinguishing          = %value«distinguishing»;
        my $mob_pattern          = %value«mobile_pattern»;
        my $lndlne_pattern       = %value«landline_pattern»;
        #$lndlne_pattern         ~~ s:g/ '[' (<-[\ \x5D\x5B]>*) ' ' (<-[\x5D\x5B]>*) ']' /[$0\\ $1]/; # fixup for error in  ECMA262Regex.compile() # redundat he fixed ECMA262Regex #
        #$mob_pattern            ~~ s:g/ '[' (<-[\ \x5D\x5B]>*) ' ' (<-[\x5D\x5B]>*) ']' /[$0\\ $1]/;
        $mobile_pattern          = ECMA262Regex.compile("^$mob_pattern\$");
        $landline_pattern        = ECMA262Regex.compile("^$lndlne_pattern\$");
        my $landline_placeholder = %value«landline_placeholder»;
        my $mobile_placeholder   = %value«mobile_placeholder»;
        loop {
            my Int $width = terminal-width;
            $width = 80 if $width === Int;
            my Int:D $m = max(($username, $group, $Groups, $given-names,
                                $surname, $display-name,
                                $residential-unit, $residential-street, $residential-city_suberb,
                                $residential-postcode, $residential-region, $residential-country,
                                $same-as-residential,
                                $postal-unit, $postal-street, $postal-city_suberb,
                                $postal-postcode, $postal-region, $postal-country,
                                $email, $cc_id, $country_region_id, $mobile, $landline,
                                $escape, "$flag $name: $cc ($prefix)", $punct, $admin, "$region ($distinguishing)", 
                                sprintf(" %-20s", 'quit'), ).map: { wcswidth($_) });
            my Int:D $w = min($width - 10 - 24 - 2 - 42, $m + 2);
            put t.clear-screen;
            my Int $cnt = 0;
            put (($cnt % 2 == 0) ?? t.bg-yellow !! t.bg-color(0,255,0)) ~ t.bold ~ t.bright-blue ~ sprintf("%-10s%24s: %-*s", dots("$cnt). ", 10), lead-dots('username', 24), $w,                $username) ~ t.text-reset;
            $cnt++;
            put (($cnt % 2 == 0) ?? t.bg-yellow !! t.bg-color(0,255,0)) ~ t.bold ~ t.bright-blue ~ sprintf("%-10s%24s: %-*s", dots("$cnt). ", 10), lead-dots('group', 24), $w,                   $group) ~ t.text-reset;
            $cnt++;
            put (($cnt % 2 == 0) ?? t.bg-yellow !! t.bg-color(0,255,0)) ~ t.bold ~ t.bright-blue ~ sprintf("%-10s%24s: %-*s", dots("$cnt). ", 10), lead-dots('Groups', 24), $w,                  $Groups) ~ t.text-reset;
            $cnt++;
            put (($cnt % 2 == 0) ?? t.bg-yellow !! t.bg-color(0,255,0)) ~ t.bold ~ t.bright-blue ~ sprintf("%-10s%24s: %-*s", dots("$cnt). ", 10), lead-dots('given names', 24), $w,             $given-names) ~ t.text-reset;
            $cnt++;
            put (($cnt % 2 == 0) ?? t.bg-yellow !! t.bg-color(0,255,0)) ~ t.bold ~ t.bright-blue ~ sprintf("%-10s%24s: %-*s", dots("$cnt). ", 10), lead-dots('surname', 24), $w,                 $surname) ~ t.text-reset;
            $cnt++;
            put (($cnt % 2 == 0) ?? t.bg-yellow !! t.bg-color(0,255,0)) ~ t.bold ~ t.bright-blue ~ sprintf("%-10s%24s: %-*s", dots("$cnt). ", 10), lead-dots('display-name', 24), $w,            $display-name) ~ t.text-reset;
            $cnt++;
            put (($cnt % 2 == 0) ?? t.bg-yellow !! t.bg-color(0,255,0)) ~ t.bold ~ t.bright-blue ~ sprintf("%-10s%24s: %-*s", dots("$cnt). ", 10), lead-dots('email', 24), $w,                   $email) ~ t.text-reset;
            $cnt++;
            put (($cnt % 2 == 0) ?? t.bg-yellow !! t.bg-color(0,255,0)) ~ t.bold ~ t.bright-blue ~ sprintf("%-10s%24s: %-*s", dots("$cnt). ", 10), lead-dots('country and coutry code', 24), $w, "$flag $name: $cc ($prefix)") ~ t.text-reset;
            $cnt++;
            put (($cnt % 2 == 0) ?? t.bg-yellow !! t.bg-color(0,255,0)) ~ t.bold ~ t.bright-blue ~ sprintf("%-10s%24s: %-*s", dots("$cnt). ", 10), lead-dots('region', 24), $w,                  "$region ($distinguishing)") ~ t.text-reset;
            $cnt++;
            put (($cnt % 2 == 0) ?? t.bg-yellow !! t.bg-color(0,255,0)) ~ t.bold ~ t.bright-blue ~ sprintf("%-10s%24s: %-*s", dots("$cnt). ", 10), lead-dots('mobile', 24), $w,                  $mobile) ~ t.text-reset;
            $cnt++;
            put (($cnt % 2 == 0) ?? t.bg-yellow !! t.bg-color(0,255,0)) ~ t.bold ~ t.bright-blue ~ sprintf("%-10s%24s: %-*s", dots("$cnt). ", 10), lead-dots('landline', 24), $w,                $landline) ~ t.text-reset;
            $cnt++;
            put (($cnt % 2 == 0) ?? t.bg-yellow !! t.bg-color(0,255,0)) ~ t.bold ~ t.bright-blue ~ sprintf("%-10s%24s: %-*s", dots("$cnt). ", 10), lead-dots('residential unit', 24), $w,        $residential-unit) ~ t.text-reset;
            $cnt++;
            put (($cnt % 2 == 0) ?? t.bg-yellow !! t.bg-color(0,255,0)) ~ t.bold ~ t.bright-blue ~ sprintf("%-10s%24s: %-*s", dots("$cnt). ", 10), lead-dots('residential street', 24), $w,      $residential-street) ~ t.text-reset;
            $cnt++;
            put (($cnt % 2 == 0) ?? t.bg-yellow !! t.bg-color(0,255,0)) ~ t.bold ~ t.bright-blue ~ sprintf("%-10s%24s: %-*s", dots("$cnt). ", 10), lead-dots('residential city_suberb', 24), $w, $residential-city_suberb) ~ t.text-reset;
            $cnt++;
            put (($cnt % 2 == 0) ?? t.bg-yellow !! t.bg-color(0,255,0)) ~ t.bold ~ t.bright-blue ~ sprintf("%-10s%24s: %-*s", dots("$cnt). ", 10), lead-dots('residential postcode', 24), $w,    $residential-postcode) ~ t.text-reset;
            $cnt++;
            put (($cnt % 2 == 0) ?? t.bg-yellow !! t.bg-color(0,255,0)) ~ t.bold ~ t.bright-blue ~ sprintf("%-10s%24s: %-*s", dots("$cnt). ", 10), lead-dots('residential region', 24), $w,       $residential-region) ~ t.text-reset;
            $cnt++;
            put (($cnt % 2 == 0) ?? t.bg-yellow !! t.bg-color(0,255,0)) ~ t.bold ~ t.bright-blue ~ sprintf("%-10s%24s: %-*s", dots("$cnt). ", 10), lead-dots('residential country', 24), $w,     $residential-country) ~ t.text-reset;
            $cnt++;
            if $_admin {
                put (($cnt % 2 == 0) ?? t.bg-yellow !! t.bg-color(0,255,0)) ~ t.bold ~ t.bright-blue ~ sprintf("%-10s%24s: %-*s", dots("$cnt). ", 10), lead-dots('Admin', 24), $w,                   $admin) ~ t.text-reset;
            } else {
                # Greyed out as it is disabled for a non admin user. This is a strong visual hint of the fact. #
                put t.bg-color(127,127,127) ~ t.bold ~ t.color(200,200,200) ~                                  sprintf("%-10s%24s: %-*s", dots("$cnt). ", 10), lead-dots('Admin', 24), $w,                   $admin) ~ t.text-reset;
            }
            $cnt++;
            put (($cnt % 2 == 0) ?? t.bg-yellow !! t.bg-color(0,255,0)) ~ t.bold ~ t.bright-blue ~ sprintf("%-10s%24s: %-*s", dots("$cnt). ", 10), lead-dots('same-as-residential', 24), $w,     $same-as-residential) ~ t.text-reset;
            $cnt++;
            if !$same-as-residential {
                put (($cnt % 2 == 0) ?? t.bg-yellow !! t.bg-color(0,255,0)) ~ t.bold ~ t.bright-blue ~ sprintf("%-10s%24s: %-*s", dots("$cnt). ", 10), lead-dots('postal-unit', 24), $w,         $postal-unit) ~ t.text-reset;
                $cnt++;
                put (($cnt % 2 == 0) ?? t.bg-yellow !! t.bg-color(0,255,0)) ~ t.bold ~ t.bright-blue ~ sprintf("%-10s%24s: %-*s", dots("$cnt). ", 10), lead-dots('postal-street', 24), $w,       $postal-street) ~ t.text-reset;
                $cnt++;
                put (($cnt % 2 == 0) ?? t.bg-yellow !! t.bg-color(0,255,0)) ~ t.bold ~ t.bright-blue ~ sprintf("%-10s%24s: %-*s", dots("$cnt). ", 10), lead-dots('postal-city_suberb', 24), $w,  $postal-city_suberb) ~ t.text-reset;
                $cnt++;
                put (($cnt % 2 == 0) ?? t.bg-yellow !! t.bg-color(0,255,0)) ~ t.bold ~ t.bright-blue ~ sprintf("%-10s%24s: %-*s", dots("$cnt). ", 10), lead-dots('postal-postcode', 24), $w,     $postal-postcode) ~ t.text-reset;
                $cnt++;
                put (($cnt % 2 == 0) ?? t.bg-yellow !! t.bg-color(0,255,0)) ~ t.bold ~ t.bright-blue ~ sprintf("%-10s%24s: %-*s", dots("$cnt). ", 10), lead-dots('postal-region', 24), $w,       $postal-region) ~ t.text-reset;
                $cnt++;
                put (($cnt % 2 == 0) ?? t.bg-yellow !! t.bg-color(0,255,0)) ~ t.bold ~ t.bright-blue ~ sprintf("%-10s%24s: %-*s", dots("$cnt). ", 10), lead-dots('postal-country', 24), $w,      $postal-country) ~ t.text-reset;
                $cnt++;
            } # if !$same-as-residential #
            put (($cnt % 2 == 0) ?? t.bg-yellow !! t.bg-color(0,255,0)) ~ t.bold ~ t.bright-blue ~ sprintf("%-10s%24s: %-*s", dots("$cnt). ", 10), lead-dots('continue', 24), $w, 'enter') ~ t.text-reset;
            $cnt++;
            put (($cnt % 2 == 0) ?? t.bg-yellow !! t.bg-color(0,255,0)) ~ t.bold ~ t.bright-blue ~ sprintf("%-10s%24s: %-*s", dots("$cnt..∞). ", 10), lead-dots('cancel', 24), $w, 'quit') ~ t.text-reset;
            $choice = prompt 'choice > ';
            given $choice {
                when '' {   # have to explicitly match here otherwise it will match with 0 #
                            $country_region_id = $cr-id unless $cr-id == 0;
                            $return = True;
                            last;
                        }
                when 0  { 
                            my $tmp                = gzzreadline_call('username > ', $username, $gzzreadline);
                            $tmp .=trim;
                            while $tmp !~~ rx/^ \w+ $/ {
                                $tmp               = gzzreadline_call('username > ', $tmp, $gzzreadline);
                                $tmp .=trim;
                            }
                            $username              = $tmp if $tmp ~~ rx/^ \w+ $/;
                        }
                when 1  {
                            my $tmp                = gzzreadline_call('group > ', $group, $gzzreadline);
                            $tmp .=trim;
                            while $tmp !~~ rx/^ \w+ $/ {
                                $tmp               = gzzreadline_call('group > ', $tmp, $gzzreadline);
                                $tmp .=trim;
                            }
                            $group                 = $tmp if $tmp ~~ rx/^ \w+ $/;
                        }
                when 2  {
                            my $tmp                = gzzreadline_call("Groups (separate with ',' and as much space as you like) > ", $Groups, $gzzreadline);
                            $tmp .=trim;
                            while $tmp !~~ rx/^ \w+  [ \s* ',' \s* \w+ ]* $/ {
                                $tmp               = gzzreadline_call("Groups (separate with ',' and as much space as you like) > ", $tmp, $gzzreadline);
                                $tmp .=trim;
                            }
                            $Groups = $tmp if $tmp ~~ rx/^ \w+  [ \s* ',' \s* \w+ ]* $/;
                        }
                when 3  {
                            my $tmp                = gzzreadline_call('given names > ', $given-names, $gzzreadline);
                            $tmp .=trim;
                            while $tmp !~~ rx/^ \w+ [ \h+ \w+ ]* $/ {
                                $tmp               = gzzreadline_call('given names > ', $tmp, $gzzreadline);
                                $tmp .=trim;
                            }
                            $tmp ~~ s:g/ \h ** 2..* /\x20/; # normalise no doble spaces no tabs etc #
                            $given-names           = $tmp if $tmp ~~ rx/^ \w+ [ \h+ \w+ ]* $/;
                            $display-name          = "$given-names $surname" if $display-auto;
                        }
                when 4  {
                            my $tmp                = gzzreadline_call('surname > ', $surname, $gzzreadline);
                            $tmp .=trim;
                            while $tmp !~~ rx/^ \w+ [ \h+ \w+ ]* $/ {
                                $tmp               = gzzreadline_call('surname > ', $tmp, $gzzreadline);
                                $tmp .=trim;
                            }
                            $tmp ~~ s:g/ \h ** 2..* /\x20/; # normalise no doble spaces no tabs etc #
                            $surname               = $tmp if $tmp ~~ rx/^ \w+ [ \h+ \w+ ]* $/;
                            $display-name          = "$given-names $surname" if $display-auto;
                        }
                when 5  {
                            my $tmp                = gzzreadline_call('display name > ', $display-name, $gzzreadline);
                            $tmp .=trim;
                            while $tmp !~~ rx/^ \w+ [ \h+ \w+ ]* $/ {
                                $tmp               = gzzreadline_call('display name > ', $tmp, $gzzreadline);
                                $tmp .=trim;
                            }
                            $tmp ~~ s:g/ \h ** 2..* /\x20/; # normalise no doble spaces no tabs etc #
                            if $tmp ~~ rx/^ \w+ [ \h+ \w+ ]* $/ {
                                $display-name          = $tmp;
                                $display-auto          = False;
                            }
                        }
                when 6  {
                            my $tmp                = gzzreadline_call('email > ', $email, $gzzreadline);
                            $tmp .=trim;
                            while $tmp eq '' || !$valid.validate($tmp) {
                                $tmp            = gzzreadline_call('email > ', $tmp, $gzzreadline);
                                $tmp .=trim;
                            }
                            $email = $tmp if $tmp ne '' && $valid.validate($tmp);
                        }
                when 7  {
                            my &setup-option-str = sub (Int:D $cnt, @array --> Str:D ) {
                                my Str $name;
                                my Str $cc;
                                my Str $flag;
                                my Str $prefix;
                                if $cnt < 0 {
                                    $name   = "No country selected yet.";
                                    $cc     = "";
                                    $flag   = "";
                                    $prefix = "you must choose one";
                                } else {
                                    my %row = @array[$cnt];
                                    $name   = %row«_name»;
                                    $cc     = %row«cc»;
                                    try {
                                        CATCH {
                                            default {
                                                my $Name = $name;
                                                $Name ~~ s:g/ <wb> 'and' <wb> /\&/;
                                                try {
                                                    CATCH {
                                                        default { $flag = uniparse 'PENGUIN'}
                                                    }
                                                    $flag = uniparse $Name;
                                                }
                                            }
                                        }
                                        $flag   = uniparse $name;
                                    }
                                    $prefix = %row«prefix»;
                                }
                                return "$flag $name: $cc ($prefix)"
                            };
                            my &get-result = sub (Int:D $result, Int:D $pos, Int:D $length, @array --> Int:D ) {
                                my $res = $result;
                                if $pos ~~ 0..^$length {
                                  my %row = |%(@array[$pos]);
                                  $res = %row«id» if %row«id»:exists;
                                }
                                return $res
                            };
                            my $cc-id              = dropdown($cc_id, 20, 'id', &setup-option-str, &get-result, @_country);
                            while !valid-country-cc-id($cc-id, %countries) {
                                $cc-id             = dropdown($cc-id, 20, 'id', &setup-option-str, &get-result, @_country);
                            }
                            if valid-country-cc-id($cc-id, %countries) {
                                $cc_id               = $cc-id;
                                my %_row             = %countries{$cc_id};
                                $name                = %_row«_name»;
                                $cc                  = %_row«cc»;
                                $flag                = uniparse 'Australia';
                                $residential-country = $name;
                                $postal-country      = $name;
                                $prefix              = %_row«prefix»;
                                $escape              = ((%_row«_escape» === Str || %_row«_escape» === Any) ?? '0'  !! %_row«_escape»); #  guess a common value #
                                $punct               = ((%row«punct» === Str    || %row«punct» === Any   ) ?? '- ' !! %row«punct»   ); #  guess a common value #
                                try {
                                    CATCH {
                                        default {
                                            my $Name = $name;
                                            $Name ~~ s:g/ <wb> 'and' <wb> /\&/;
                                            try {
                                                CATCH {
                                                    default { $flag = uniparse 'PENGUIN'}
                                                }
                                                $flag = uniparse $Name;
                                            }
                                        }
                                    }
                                    $flag          = uniparse $name;
                                }
                                @country_regions      = |@(%_row«country_regions»);
                                @country_regions      = |@country_regions.sort: { my %u = %($^a); my %v = %($^b);
                                                                                my $res = %u«region».lc.trim cmp %v«region».lc.trim;
                                                    (($res == Same) ?? (%u«distinguishing».trim cmp %v«distinguishing».trim) !! $res ) };
                                my %_row_             = @country_regions[0];
                                $country_region_id    = %_row_«cr_id»;
                                $cr-id                = %_row_«cr_id»;
                                $region               = %_row_«region»;
                                $residential-region   = $region;
                                $postal-region        = $region;
                                $distinguishing       = %_row_«distinguishing»;
                                $mob_pattern          = %_row_«mobile_pattern»;
                                $lndlne_pattern       = %_row_«landline_pattern»;
                                #$lndlne_pattern      ~~ s:g/ '[' (<-[\ \x5D\x5B]>*) ' ' (<-[\x5D\x5B]>*) ']' /[$0\\ $1]/; # fixup for error in  ECMA262Regex.compile() # redundat he fixed ECMA262Regex #
                                #$mob_pattern         ~~ s:g/ '[' (<-[\ \x5D\x5B]>*) ' ' (<-[\x5D\x5B]>*) ']' /[$0\\ $1]/;
                                #$mobile_pattern       = ECMA262Regex.compile("^$mob_pattern\$");
                                #$landline_pattern     = ECMA262Regex.compile("^$lndlne_pattern\$");
                                $landline_placeholder = %_row_«landline_placeholder»;
                                $mobile_placeholder   = %_row_«mobile_placeholder»;
                            }
                        }
                when 8  {
                            my &setup-option-str = sub (Int:D $cnt, @array --> Str:D ) {
                                my Str $region;
                                my Str $distinguishing;
                                if $cnt == -1 {
                                    $region         = "No region selected yet.";
                                    $distinguishing = "you must choose one";
                                } else {
                                    my %value       = @country_regions[$cnt];
                                    $region         = %value«region»;
                                    $distinguishing = %value«distinguishing»;
                                }
                                return "$region ($distinguishing)";
                            };
                            my &get-result = sub (Int:D $result, Int:D $pos, Int:D $length, @array --> Int:D ) {
                                my $res = $result;
                                if $pos ~~ 0..^$length {
                                  my %row = |%(@country_regions[$pos]);
                                  $res = %row«cr_id» if %row«cr_id»:exists;
                                }
                                return $res
                            };
                            my $country-region-id  = dropdown($country_region_id, 20, 'cr_id', &setup-option-str, &get-result, @country_regions);
                            while !valid-country-region-id($country-region-id, $cc_id, %countries) {
                                $country-region-id = dropdown($country-region-id, 20, 'cr_id', &setup-option-str, &get-result, @country_regions);
                            }
                            if valid-country-region-id($country-region-id, $cc_id, %countries) {
                                $country_region_id     = $country-region-id;
                                for @country_regions.kv -> $idx, %val {
                                    if %val«cr_id»  == $country_region_id {
                                        $ind = $idx;
                                        last; # found no need to search further #
                                    }
                                }
                                my %_value            = @country_regions[$ind];
                                $cr-id                = %_value«cr_id»;
                                $region               = %_value«region»;
                                $residential-region   = $region;
                                $postal-region        = $region;
                                $distinguishing       = %_value«distinguishing»;
                                $mob_pattern          = %_value«mobile_pattern»;
                                $lndlne_pattern       = %_value«landline_pattern»;
                                #$lndlne_pattern      ~~ s:g/ '[' (<-[\ \x5D\x5B]>*) ' ' (<-[\x5D\x5B]>*) ']' /[$0\\ $1]/; # fixup for error in  ECMA262Regex.compile() # redundat he fixed ECMA262Regex #
                                #$mob_pattern         ~~ s:g/ '[' (<-[\ \x5D\x5B]>*) ' ' (<-[\x5D\x5B]>*) ']' /[$0\\ $1]/;
                                $mobile_pattern       = ECMA262Regex.compile("^$mob_pattern\$");
                                $landline_pattern     = ECMA262Regex.compile("^$lndlne_pattern\$");
                                $landline_placeholder = %_value«landline_placeholder»;
                                $mobile_placeholder   = %_value«mobile_placeholder»;
                            }
                        }
                when 9  {
                            my $tmp                = gzzreadline_call("mobile: [$mobile_placeholder] > ", $mobile, $gzzreadline);
                            $tmp .=trim;
                            while $tmp !~~ $mobile_pattern {
                                $tmp               = gzzreadline_call("mobile: [$mobile_placeholder] > ", $tmp, $gzzreadline);
                                $tmp .=trim;
                            }
                            $mobile                = $tmp if $tmp ~~ $mobile_pattern;
                        }
                when 10 {
                            my $tmp                = gzzreadline_call("landline: [$landline_placeholder] > ", $landline, $gzzreadline);
                            $tmp .=trim;
                            while $tmp !~~ $landline_pattern {
                                $tmp               = gzzreadline_call("landline: [$landline_placeholder] > ", $tmp, $gzzreadline);
                                $tmp .=trim;
                            }
                            $landline              = $tmp if $tmp ~~ $landline_pattern;
                        }
                when 11 {
                            my $tmp                = gzzreadline_call("residential unit > ", $residential-unit, $gzzreadline);
                            $tmp .=trim;
                            while $tmp !~~ rx/^ <-['";]>* $/ {
                                $tmp              ~~ s/ <['";]> //;  # strip the crap out  #
                                $tmp               = gzzreadline_call("residential unit > ", $tmp, $gzzreadline);
                                $tmp .=trim;
                            }
                            $residential-unit        = $tmp if $tmp ~~ rx/^ <-['";]>* $/;
                        }
                when 12 { $residential-street      = gzzreadline_call("residential street > ", $residential-street, $gzzreadline); $residential-street ~~ s:g/ <['";]>//; }
                when 13 { $residential-city_suberb = gzzreadline_call("residential city_suberb > ", $residential-city_suberb, $gzzreadline); $residential-city_suberb ~~ s:g/ <['";]>//; }
                when 14 { $residential-postcode    = gzzreadline_call("residential postcode > ", $residential-postcode, $gzzreadline); $residential-postcode ~~ s:g/ <['";]>//; }
                when 15 { $residential-region      = gzzreadline_call("residential region > ", $residential-region, $gzzreadline); $residential-region ~~ s:g/ <['";]>//; }
                when 16 { $residential-country     = gzzreadline_call("residential country > ", $residential-country, $gzzreadline); $residential-country ~~ s:g/ <['";]>//; }
                when 17 { $admin     = !$admin if $_admin; }
                when 18 { $same-as-residential     = !$same-as-residential; }
                when 19..∞ {
                    if !$same-as-residential {
                        given $choice {
                            when 19 { $postal-unit             = gzzreadline_call("postal unit > ", $postal-unit, $gzzreadline); $postal-unit ~~ s:g/ <['";]>//; }
                            when 20 { $postal-street           = gzzreadline_call("postal street > ", $postal-street, $gzzreadline); $postal-street ~~ s:g/ <['";]>//; }
                            when 21 { $postal-city_suberb      = gzzreadline_call("postal city_suberb > ", $postal-city_suberb, $gzzreadline); $postal-city_suberb ~~ s:g/ <['";]>//; }
                            when 22 { $postal-postcode         = gzzreadline_call("postal postcode > ", $postal-postcode, $gzzreadline); $postal-postcode ~~ s:g/ <['";]>//; }
                            when 23 { $postal-region           = gzzreadline_call("postal region > ", $postal-region, $gzzreadline); $postal-region ~~ s:g/ <['";]>//; }
                            when 24 { $postal-country          = gzzreadline_call("postal country > ", $postal-country, $gzzreadline); $postal-country ~~ s:g/ <['";]>//; }
                            when 25 {
                                        $return    = True;
                                        last;
                                    }
                            when 26..∞ {
                                           $return = False;
                                           last;
                                        }
                        }
                    } else {
                        given $choice {
                            when 19 {
                                        $return    = True;
                                        last;
                                    }
                            when 20..∞ {
                                           $return = False;
                                           last;
                                        }
                        }
                    }
                }
                when rx:i/^ ['continue'|'enter'] $/ { # match explict enter (i.e '') above as otherwise it matches with 0 #
                            $country_region_id = $cr-id unless $cr-id == 0;
                            $return = True;
                            last;
                        }
                when rx:i/^ ['cancel'|'quit'|'q'] $/ {
                            $return = False;
                            last;
                        }
                default {
                           my Bool:D $tmp = ask 'do you want to quit y/N > ', 'y', :type(Bool);
                           if $tmp {
                               $return = False;
                               last;
                           }
                        }
            } # given $prompt #
        } # loop #
        put t.restore-screen;
    } # try #
    return $return;
} #`««« sub ask-for-all-user-values(Str:D $username is rw, Str:D $group is rw, Str:D $Groups is rw, Str:D $given-names is rw,
                            Str:D $surname is rw, Str:D $display-name is rw,
                            Str:D $residential-unit is rw, Str:D $residential-street is rw, Str:D $residential-city_suberb is rw,
                            Str:D $residential-postcode is rw, Str:D $residential-region is rw, Str:D $residential-country is rw,
                            Bool:D $same-as-residential is rw,
                            Str:D $postal-unit is rw, Str:D $postal-street is rw, Str:D $postal-city_suberb is rw,
                            Str:D $postal-postcode is rw, Str:D $postal-region is rw, Str:D $postal-country is rw,
                            Str:D $email is rw, Int:D $cc_id is rw, Int $country_region_id is rw, Str:D $mobile is rw, Str:D $landline is rw,
                            Str:D $mobile_pattern is rw, Str:D $landline_pattern is rw, Str:D $escape is rw, Str:D $prefix is rw, Str:D $punct is rw, Bool:D $admin is rw --> Bool) »»»

sub valid-pwd(Str:D $passwd, Bool :$nowhitespace = False --> Bool) is export {
    return False if $nowhitespace && $passwd.match(rx/\s/);
    return False if $passwd.match(rx/\v/);
    return True  if $passwd.chars >= 10 && $passwd ~~ rx/ <punct> / && $passwd ~~ rx/ \d / && ($passwd ~~ rx/ <lower> / || $passwd ~~ rx/ <upper> /);
    return False;
} # sub valid-pwd(Str:D $passwd --> Bool) is export #

sub create-group(Str:D $group --> IdType) {
    my Int $return;
    try {
        CATCH {
            # will definitely catch all the exception 
            default {
                        .backtrace;
                        .Str.say;
                        .rethrow;
                    }
        }
        my $sql    = "INSERT INTO _group(_name) VALUES(?)\n";
        $sql      ~= "ON CONFLICT (_name) DO UPDATE SET _name = EXCLUDED._name\n";
        $sql      ~= "RETURNING id;\n";
        my $query  = $dbh.prepare($sql);
        my $result = $query.execute($group);
        die "could not add group $group query: $sql; failed" unless $result;
        my %val = $result.row(:hash);
        unless %val {
            die "could not add group $group query: $sql; failed";
        }
        say "Got here $?LINE";
        $return = %val«id»;
    }
    return $return;
} # sub create-group(Str:D $group --> IdType) #

sub  create-groups(IdType:D $group-id, IdType:D $passwd-id --> IdType) {
    my Int $return;
    try {
        CATCH {
            # will definitely catch all the exception 
            default {
                        .backtrace;
                        .Str.say;
                        .rethrow;
                    }
        }
        my $sql    = "INSERT INTO groups(group_id, passwd_id) VALUES(?, ?)\n";
        #$sql      ~= "ON CONFLICT (group_id, passwd_id) DO UPDATE SET group_id = EXCLUDED.group_id, EXCLUDED.passwd_id = passwd_id\n";
        $sql      ~= "RETURNING id;\n";
        say "Got here $?LINE";
        my $query  = $dbh.prepare($sql);
        my $result = $query.execute($group-id, $passwd-id);
        die "could not add group ($group-id, $passwd-id) query: $sql; failed" unless $result;
        my %val = $result.row(:hash);
        unless %val {
            die "could not add group ($group-id, $passwd-id) query: $sql; failed";
        }
        say "Got here $?LINE";
        $return = %val«id»;
    }
    return $return;
} # sub  create-groups(IdType:D $group-id, IdType:D $passwd-id --> IdType) #

sub create-email(Str:D $email --> IdType) {
    my Int $return;
    try {
        CATCH {
            # will definitely catch all the exception 
            default {
                        .backtrace;
                        .Str.say;
                        .rethrow;
                    }
        }
        my $sql    = "INSERT INTO email(_email) VALUES(?)\n";
        #$sql      ~= "ON CONFLICT (_email) DO UPDATE SET _email = EXCLUDED._email\n";
        $sql      ~= "RETURNING id;\n";
        my $query  = $dbh.prepare($sql);
        my $result = $query.execute($email);
        die "could not add email $email query: $sql; failed" unless $result;
        my %val = $result.row(:hash);
        unless %val {
            die "could not add email $email query: $sql; failed";
        }
        $return = %val«id»;
    }
    return $return;
} # sub create-email(Str:D $email --> IdType) #

sub create-phone(Str:D $phone --> IdType) {
    my Int $return;
    try {
        CATCH {
            # will definitely catch all the exception 
            default {
                        .backtrace;
                        .Str.say;
                        .rethrow;
                    }
        }
        my $sql    = "INSERT INTO phone(_number) VALUES(?)\n";
        #$sql      ~= "ON CONFLICT (_number) DO UPDATE SET _number = EXCLUDED._number\n";
        $sql      ~= "RETURNING id;\n";
        my $query  = $dbh.prepare($sql);
        my $result = $query.execute($phone);
        die "could not add phone $phone query: $sql; failed" unless $result;
        my %val = $result.row(:hash);
        unless %val {
            die "could not add phone $phone query: $sql; failed";
        }
        $return = %val«id»;
    }
    return $return;
} # sub create-phone(Str:D $phone --> IdType) #

sub create-address(Str:D $unit, Str:D $street, Str:D $city_suburb, Str:D $postcode, Str:D $region, Str:D $country --> IdType) {
    my Int $return;
    try {
        CATCH {
            # will definitely catch all the exception 
            default {
                        .backtrace;
                        .Str.say;
                        .rethrow;
                    }
        }
        my $sql    = "INSERT INTO address(unit, street, city_suburb, postcode, region, country)\n";
        $sql      ~= "VALUES(?, ?, ?, ?, ?, ?)\n";
        #$sql      ~= "ON CONFLICT (unit, street, city_suburb, postcode, region, country) DO UPDATE SET unit = EXCLUDED.unit, street = EXCLUDED.street\n";
        $sql      ~= "RETURNING id;\n";
        my $query  = $dbh.prepare($sql);
        my $result = $query.execute($unit, $street, $city_suburb, $postcode, $region, $country);
        die "could not add address ($unit, $street, $city_suburb, $postcode, $region, $country) query: $sql; failed" unless $result;
        my %val = $result.row(:hash);
        unless %val {
            die "could not add address ($unit, $street, $city_suburb, $postcode, $region, $country) query: $sql; failed";
        }
        $return = %val«id»;
    }
    return $return;
} # sub create-address(Str:D $unit, Str:D $street, Str:D $city_suburb, Str:D $postcode, Str:D $region, Str:D $country --> IdType) #

sub create-passwd-details(Str:D $display-name, Str:D $given, Str:D $surname, IdType:D $residential-address-id, IdType:D $postal-address-id, IdType $primary-phone-id, IdType $secondary-phone-id, IdType:D $country-id, IdType $country-region-id --> IdType) {
    my Int $return;
    try {
        CATCH {
            # will definitely catch all the exception 
            default {
                        .backtrace;
                        .Str.say;
                        .rethrow;
                    }
        }
        my Str:D $sql = qq{INSERT INTO passwd_details(display_name, given, _family, residential_address_id, postal_address_id, primary_phone_id, secondary_phone_id, country_id, country_region_id)\n
                           VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?)\n
                           RETURNING id;\n};
        my $query  = $dbh.prepare($sql);
        my $result = $query.execute($display-name, $given, $surname, $residential-address-id, $postal-address-id, $primary-phone-id, $secondary-phone-id, $country-id, $country-region-id);
        die "could not add passwd_details ($display-name, $given, $surname, $residential-address-id, $postal-address-id, $primary-phone-id, $secondary-phone-id, $country-id, $country-region-id) query: $sql; failed" unless $result;
        my %val = $result.row(:hash);
        unless %val {
            die "could not add passwd_details ($display-name, $given, $surname, $residential-address-id, $postal-address-id, $primary-phone-id, $secondary-phone-id, $country-id, $country-region-id) query: $sql; failed";
        }
        $return = %val«id»;
    }
    return $return;
} # sub create-passwd-details(Str:D $display-name, Str:D $given, Str:D $surname, IdType:D $residential-address-id, IdType:D $postal-address-id, IdType $primary-phone-id, IdType $secondary-phone-id, IdType:D $country-id, IdType $country-region-id --> IdType) #

sub create-passwd(Str:D $username, Str:D $hashed-passwd, Int:D $passwd-details-id, Int:D $primary-group-id, Bool:D $admin, Int:D $email-id --> IdType) {
    my Int $return;
    try {
        CATCH {
            # will definitely catch all the exception 
            default {
                        .backtrace;
                        .Str.say;
                        .rethrow;
                    }
        }
        my Str:D $obscured-passwd = '*' x 20;
        my Str:D $sql = qq{INSERT INTO passwd(username, _password, passwd_details_id, primary_group_id, _admin, email_id)\n
                           VALUES(?, ?, ?, ?, ?, ?)\n
                           RETURNING id;\n};
        my $query  = $dbh.prepare($sql);
        my $result = $query.execute($username, $hashed-passwd, $passwd-details-id, $primary-group-id, $admin, $email-id);
        die "could not add passwd_details ($username, $obscured-passwd, $passwd-details-id, $primary-group-id, $admin, $email-id) query: $sql; failed" unless $result;
        my %val = $result.row(:hash);
        unless %val {
            die "could not add passwd_details ($username, $obscured-passwd, $passwd-details-id, $primary-group-id, $admin, $email-id) query: $sql; failed";
        }
        $return = %val«id»;
    }
    return $return;
} # sub create-passwd(Str:D $username, Str:D $hashed-passwd, Int:D $passwd-details-id, Int:D $primary-group-id, Bool:D $admin, Int:D $email-id --> IdType) #

sub normalise-phone(Str:D $phone_number, Str:D $escape, Str:D $prefix, Regex:D $phone-pattern, Str:D $punct is copy --> Str) {
    my Str:D $result = $phone_number;
    try  {
        CATCH {
            # will definitely catch all the exception 
            default {
                        .backtrace;
                        .Str.say;
                        .rethrow;
                    }
        }
        $punct ~~ s:g/ \x20 /\\x20/;
        my Str:D $pg = "<[$punct]>";
        $result ~~ s:g/ <$pg> //; # remove punctuation. Note: \x20 is ord 32 or space #
        if $result.starts-with($escape) {
            $result ~~ s/^<$escape>/$prefix/;
        }
        if $result !~~ rx/^\+/ {
            if $result.starts-with($prefix.substr(1)) {
                $result = '+' ~ $result if $result ~~ $phone-pattern;
            }
            if $result ~~ rx/^ \+ / {
                $result = $prefix ~ $result;
            }
        }
        unless $result ~~ $phone-pattern {
            $*ERR.say: "could not normailse phone_number: '$phone_number' ==> '$result' does not , match pattern: $phone-pattern";
            return $phone_number; # bail something is wrong #
        }
    }
    return $result;
} # sub normalise-phone(Str:D $landline, Str:D $escape, Str:D $prefix, Regex:D $phone-pattern, Str:D $punct --> Str) #

sub register-new-user(Str:D $username is copy where { $username ~~ rx/^ \w+ $/}, Str:D $passwd, Str:D $repeat-pwd,
                      Str:D $group is copy, @Groups, Str:D $given-names is copy, Str:D $surname is copy,
                      Str:D $display-name is copy, Str:D $residential-unit is copy, Str:D $residential-street is copy,
                      Str:D $residential-city_suberb is copy, Str:D $residential-postcode is copy, Str:D $residential-region is copy,
                      Str:D $residential-country is copy, Bool:D $same-as-residential is copy,
                      Str:D $email is copy, Str:D $mobile is copy, Str:D $landline is copy, Bool:D $admin is copy --> Bool) is export {
    return False unless $passwd eq $repeat-pwd;
    my Str:D $hashed-passwd = generate-hash($passwd);
    if !validate($hashed-passwd, $passwd) {
        "Error: password validation failed.".say;
        return False;
    }
    #say "$?FILE {$?MODULE.gist} This is \&?ROUTINE.name: {&?ROUTINE.name}";
    my Str:D $postal-unit = '';
    my Str:D $postal-street = '';
    my Str:D $postal-city_suberb = '';
    my Str:D $postal-postcode = '';
    my Str:D $postal-region = '';
    my Str:D $postal-country = '';
    my Str:D $Groups = @Groups.join(', ');
    my Int $cc_id = 27;
    my Int $country_region_id = 490;
    my Str $prefix = '';
    my Str $escape = '';
    my Str $punct  = '';
    my Regex $mobile_pattern;
    my Regex $landline_pattern;
    my Bool:D $result                    = True;
    my Bool:D $loggedin                  = so %session«loggedin»;
    my Int    $loggedin_id               =    ((%session«loggedin_id»               === Any) ?? Int   !! %session«loggedin_id» );
    my Str    $loggedin_username         =    ((%session«loggedin_username»         === Any) ?? Str   !! %session«loggedin_username» );
    my Bool:D $_admin                    = so %session«loggedin_admin»;
    my Str    $display_name              =    ((%session«loggedin_display_name»     === Any) ?? Str   !! %session«loggedin_display_name» );
    my Str    $given                     =    ((%session«loggedin_given»            === Any) ?? Str   !! %session«loggedin_given» );
    my Str    $family                    =    ((%session«loggedin_family»           === Any) ?? Str   !! %session«loggedin_family» );
    my Str    $loggedin_email            =    ((%session«loggedin_email»            === Any) ?? Str   !! %session«loggedin_email» );
    my Str    $phone_number              =    ((%session«loggedin_phone_number»     === Any) ?? Str   !! %session«loggedin_phone_number» );
    my Str    $groupname                 =    ((%session«loggedin_groupname»        === Any) ?? Str   !! %session«loggedin_groupname» );
    my Int    $primary_group_id          =    ((%session«loggedin_groupnname_id»    === Any) ?? Int   !! %session«loggedin_groupnname_id» );
    my Str    $loggedin_prefix           =    ((%session«loggedin_prefix»           === Any) ?? Str   !! %session«loggedin_prefix» );
    my Str    $loggedin_escape           =    ((%session«loggedin_escape»           === Any) ?? Str   !! %session«loggedin_escape» );
    my Str    $loggedin_punct            =    ((%session«loggedin_punct»            === Any) ?? Str   !! %session«loggedin_punct» );
    my Regex  $loggedin_landline_pattern =    ((%session«loggedin_landline_pattern» === Any) ?? Regex !! %session«loggedin_landline_pattern» );
    my Regex  $loggedin_mobile_pattern   =    ((%session«loggedin_mobile_pattern»   === Any) ?? Regex !! %session«loggedin_mobile_pattern» );
    unless $loggedin {
        say "You must be loggedin to use this function: {&*ROUTINE.name}";
        return False;
    }
    if $admin && !$_admin {
        $admin = False;
        say "you are not an admin cannot request admin privaliges";
        sleep 2 * pi; # sleep 2 pi seconds for fun and to give you long enough to see the message. #
    }
    try {
        CATCH {
            # will definitely catch all the exception 
            default {
                        .backtrace;
                        .Str.say;
                        .rethrow;
                    }
        }
        $result = ask-for-all-user-values($username, $group, $Groups, $given-names, $surname, $display-name,
                                $residential-unit, $residential-street, $residential-city_suberb,
                                $residential-postcode, $residential-region, $residential-country, $same-as-residential,
                                $postal-unit, $postal-street, $postal-city_suberb, $postal-postcode, $postal-region, $postal-country,
                                $email, $cc_id, $country_region_id, $mobile, $landline, $mobile_pattern, $landline_pattern, $escape, $prefix, $punct, $admin);
        unless $result {
            return False;
        }
        $mobile   .=trim;
        if $mobile ne '' && $mobile !~~ $mobile_pattern {
            die "bad mobile value: $mobile";
        } elsif $mobile ~~ $mobile_pattern {
            $mobile = normalise-phone($mobile, $escape, $prefix, $mobile_pattern, $punct);
        }
        $landline .=trim;
        if $landline ne '' && $landline !~~ $landline_pattern {
            die "bad landline value: $landline";
        } elsif $landline ~~ $landline_pattern {
            $landline = normalise-phone($landline, $escape, $prefix, $landline_pattern, $punct);
        }
        if $residential-street eq '' || $residential-city_suberb eq '' || $residential-postcode eq '' || $residential-region eq '' || $residential-country eq '' {
            die "bad address ($residential-unit, $residential-street, $residential-city_suberb, $residential-postcode, $residential-region, $residential-country)";
        }
        if !$same-as-residential && ($postal-street eq '' || $postal-city_suberb eq '' || $postal-postcode eq '' || $postal-region eq '' || $postal-country eq '') {
            die "bad address ($postal-unit, $postal-street, $postal-city_suberb, $postal-postcode, $postal-region, $postal-country)";
        }
        if $display-name eq '' || $given-names eq '' || $surname eq '' || $country_region_id == 0 {
            die "bad values for passwd_details ($display-name, $given-names, $surname, ..., $country_region_id)";
        }
        @Groups    = $Groups.split(rx/ \s* ',' \s* /, :skip-empty);
        my IdType:D $group-id = create-group($group);
        my IdType:D $email-id = create-email($email);
        my IdType $mobile-id = (($mobile eq '') ?? Int !! create-phone($mobile));
        my IdType $landline-id = (($landline eq '') ?? Int !! create-phone($landline));
        my IdType:D $residential-address-id = create-address($residential-unit, $residential-street, $residential-city_suberb, $residential-postcode, $residential-region, $residential-country);
        my IdType:D $postal-address-id = $residential-address-id;
        my IdType   $primary-phone-id;
        my IdType   $secondary-phone-id;
        if $mobile-id !=== Int {
            $primary-phone-id   = $mobile-id;
            $secondary-phone-id = $landline-id;
        } elsif $landline-id !=== Int {
            $primary-phone-id   = $landline-id;
            $secondary-phone-id = $mobile-id;
        }
        if !$same-as-residential {
            $postal-address-id = create-address($postal-unit, $postal-street, $postal-city_suberb, $postal-postcode, $postal-region, $postal-country);
        }
        my IdType:D $passwd-details-id = create-passwd-details($display-name, $given-names, $surname, $residential-address-id, $postal-address-id, $primary-phone-id, $secondary-phone-id, $cc_id, $country_region_id);
        my IdType:D $passwd-id         = create-passwd($username, $hashed-passwd, $passwd-details-id, $group-id, $admin, $email-id);
        my @Group-ids;
        say "Got here $?LINE";
        for @Groups -> $name {
            if $name !~~ rx/^ \w+ $/ {
                say "bad group name: $name skipping.";
                next;
            }
            next if $name eq $groupname;
            my IdType:D $id = create-group($name);
            @Group-ids.push:  create-groups($id, $passwd-id);
        }
        #`«««
        dd $username, $group, @Groups, $given-names, $surname, $display-name,
                                $residential-unit, $residential-street, $residential-city_suberb,
                                $residential-postcode, $residential-region, $residential-country, $same-as-residential,
                                $postal-unit, $postal-street, $postal-city_suberb, $postal-postcode, $postal-region, $postal-country,
                                $email, $cc_id, $country_region_id, $mobile, $landline, $escape, $prefix, $punct, $admin, $result, $group-id, $email-id, $residential-address-id,
                                $postal-address-id;
        # »»»
    }
    return $result;
} #`««« sub login(Str:D $username is copy where { $username ~~ rx/^ \w+ $/}, Str:D $passwd, Str:D $repeat-pwd,
                      Str:D $group is copy, @Groups, Str:D $given-names is copy, Str:D $surname is copy,
                      Str:D $display-name is copy, Str:D $residential-unit is copy, Str:D $residential-street is copy,
                      Str:D $residential-city_suberb is copy, Str:D $residential-postcode is copy, Str:D $residential-region is copy,
                      Str:D $residential-country is copy, Bool:D $same-as-residential is copy,
                      Str:D $email is copy, Str:D $mobile is copy, Str:D $landline is copy --> Bool) is export »»»

sub perms-good(Int $perms, Str $user, Str $group, Str $other) is export {
    my $result = False;
    #dd $perms, $user, $group, $other, $result;
    if $perms !=== Int && (($user // $group // $other) === Str) {
        $result = True;
    } elsif $perms === Int && (($user // $group // $other) !=== Str) {
        $result = True;
    } elsif $perms === Int && (($user // $group // $other) === Str) {
        "you must specifiy some permissions!!! Either --perms or (--user|--group|--other)".say;
    } else {
        "You cannot specifiy permissions both by number and sybolically choose just one!!! Either --perms or (--user|--group|--other)".say;
    }
    return $result;
} # sub perms-good(Int $perms, Str $user, Str $group, Str $other) is export #

sub set-perms(Str:D $perm-spec, %old --> Str:D) {
    my Str:D $result = '';
    if $perm-spec.starts-with('=') {
        my Str:D $read  = ($perm-spec.substr(1).contains('r')) ?? 'true' !! 'false';
        my Str:D $write = ($perm-spec.substr(1).contains('w')) ?? 'true' !! 'false';
        my Str:D $del   = ($perm-spec.substr(1).contains('d')) ?? 'true' !! 'false';
        $result         = "($read,$write,$del)";
    } elsif $perm-spec.starts-with('+') {
        my Str:D $read  = ($perm-spec.substr(1).contains('r')) ?? 'true' !! (%old«read»  ?? 'true' !! 'false');
        my Str:D $write = ($perm-spec.substr(1).contains('w')) ?? 'true' !! (%old«write» ?? 'true' !! 'false');
        my Str:D $del   = ($perm-spec.substr(1).contains('d')) ?? 'true' !! (%old«del»   ?? 'true' !! 'false');
        $result         = "($read,$write,$del)";
    } elsif $perm-spec.starts-with('-') {
        my Str:D $read  = ($perm-spec.substr(1).contains('r')) ?? 'false' !! (%old«read»  ?? 'true' !! 'false');
        my Str:D $write = ($perm-spec.substr(1).contains('w')) ?? 'false' !! (%old«write» ?? 'true' !! 'false');
        my Str:D $del   = ($perm-spec.substr(1).contains('d')) ?? 'false' !! (%old«del»   ?? 'true' !! 'false');
        $result         = "($read,$write,$del)";
    } else { # no =, + or - so assume = #
        my Str:D $read  = ($perm-spec.substr(0).contains('r')) ?? 'true' !! 'false';
        my Str:D $write = ($perm-spec.substr(0).contains('w')) ?? 'true' !! 'false';
        my Str:D $del   = ($perm-spec.substr(0).contains('d')) ?? 'true' !! 'false';
        $result         = "($read,$write,$del)";
    }
    return $result;
} # sub set-perms(Str:D $perm-spec, %old --> Str:D) #

grammar GPerms {
    rule TOP            { '(' <perms> ')' }
    rule perms          {  <user> ',' <group> ',' <other>  }
    rule user           { '"' '(' <read> ',' <write> ',' <del> ')' '"' }
    rule group          { '"' '(' <read> ',' <write> ',' <del> ')' '"' }
    rule other          { '"' '(' <read> ',' <write> ',' <del> ')' '"' }
    token read          { <true_or_false> }
    token write         { <true_or_false> }
    token del           { <true_or_false> }
    token true_or_false { [ 't' | 'true' | 'f' | 'false' ] }
}

class Perms {
    method TOP ($/)   { make $/<perms>.made }
    method perms ($/) { make { user => $/<user>.made, group => $/<group>.made, other => $/<other>.made } }
    method user  ($/) { make { read => $/<read>.made, write => $/<write>.made, del => $/<del>.made } }
    method group ($/) { make { read => $/<read>.made, write => $/<write>.made, del => $/<del>.made } }
    method other ($/) { make { read => $/<read>.made, write => $/<write>.made, del => $/<del>.made } }
    method read  ($/) { make $/<true_or_false>.made }
    method write ($/) { make $/<true_or_false>.made }
    method del   ($/) { make $/<true_or_false>.made }
    method true_or_false ($/) { make(($/ eq 't') || ($/ eq 'true' )) }
}

sub chmod-pages(Bool:D $recursive, Bool:D $verbose, %perms, @page-names --> Bool:D) is export {
    my Bool:D $result = True;
    my Bool:D $loggedin                  = so %session«loggedin»;
    my Int    $loggedin_id               =    ((%session«loggedin_id»               === Any) ?? Int   !! %session«loggedin_id» );
    my Str    $loggedin_username         =    ((%session«loggedin_username»         === Any) ?? Str   !! %session«loggedin_username» );
    my Bool:D $_admin                    = so %session«loggedin_admin»;
    my Str    $display_name              =    ((%session«loggedin_display_name»     === Any) ?? Str   !! %session«loggedin_display_name» );
    my Str    $given                     =    ((%session«loggedin_given»            === Any) ?? Str   !! %session«loggedin_given» );
    my Str    $family                    =    ((%session«loggedin_family»           === Any) ?? Str   !! %session«loggedin_family» );
    my Str    $loggedin_email            =    ((%session«loggedin_email»            === Any) ?? Str   !! %session«loggedin_email» );
    my Str    $phone_number              =    ((%session«loggedin_phone_number»     === Any) ?? Str   !! %session«loggedin_phone_number» );
    my Str    $groupname                 =    ((%session«loggedin_groupname»        === Any) ?? Str   !! %session«loggedin_groupname» );
    my Int    $primary_group_id          =    ((%session«loggedin_groupnname_id»    === Any) ?? Int   !! %session«loggedin_groupnname_id» );
    my Str    $loggedin_prefix           =    ((%session«loggedin_prefix»           === Any) ?? Str   !! %session«loggedin_prefix» );
    my Str    $loggedin_escape           =    ((%session«loggedin_escape»           === Any) ?? Str   !! %session«loggedin_escape» );
    my Str    $loggedin_punct            =    ((%session«loggedin_punct»            === Any) ?? Str   !! %session«loggedin_punct» );
    my Regex  $loggedin_landline_pattern =    ((%session«loggedin_landline_pattern» === Any) ?? Regex !! %session«loggedin_landline_pattern» );
    my Regex  $loggedin_mobile_pattern   =    ((%session«loggedin_mobile_pattern»   === Any) ?? Regex !! %session«loggedin_mobile_pattern» );
    #######################################################
    #                                                     #
    #           Only loggedin users may do this           #
    #                                                     #
    #######################################################
    unless $loggedin {
        say "You must be loggedin to use this function: {&*ROUTINE.name}";
        return False;
    }
    constant $URead  = 0o400;
    constant $UWrite = 0o200;
    constant $UDel   = 0o100;
    constant $GRead  = 0o040;
    constant $GWrite = 0o020;
    constant $GDel   = 0o010;
    constant $ORead  = 0o004;
    constant $OWrite = 0o002;
    constant $ODel   = 0o001;
    my Str:D $theperms = '';
    my Str:D $user  = '';
    my Str:D $group = '';
    my Str:D $other = '';
    if %perms«perms»:exists {
        #####################################################
        #                                                   #
        #                                                   #
        #                                                   #
        #                                                   #
        #           proccess the numerical perms            #
        #           Note: you can only supply               #
        #           either numeric or symbolic              #
        #           specs,  sybolic is far more             #
        #           powerful and selective                  #
        #           numeric are converted to                #
        #           symbolic the '=' start forces           #
        #           the perm to exact values                #
        #                                                   #
        #                                                   #
        #                                                   #
        #                                                   #
        #####################################################
        my Int:D $p = %perms«perms»;
        $user  ~= '=';
        $group ~= '=';
        $other ~= '=';
        if $p +& $URead {
            $user ~= 'r';
        }
        if $p +& $UWrite {
            $user ~= 'w';
        }
        if $p +& $UDel {
            $user ~= 'd';
        }
        if $p +& $GRead {
            $group ~= 'r';
        }
        if $p +& $GWrite {
            $group ~= 'w';
        }
        if $p +& $GDel {
            $group ~= 'd';
        }
        if $p +& $ORead {
            $other ~= 'r';
        }
        if $p +& $OWrite {
            $other ~= 'w';
        }
        if $p +& $ODel {
            $other ~= 'd';
        }
    } else {
        $user  = %perms«user»  if %perms«user»:exists;
        $group = %perms«group» if %perms«group»:exists;
        $other = %perms«other» if %perms«other»:exists;
    }
    my Str:D $sql-select = qq!SELECT p.id, p._perms, p.userid, p.groupid, p.full_name FROM pages p WHERE p.name = ?!;
    my $select           = $dbh.prepare($sql-select);
    my Str:D $sql        = qq!UPDATE pages SET _perms = ? WHERE id = ?!;
    my $update           = $dbh.prepare($sql);
    my Str:D $sel-sect   = qq!SELECT ps.id, ps._perms, ps.userid, ps.groupid, ps.links_section_id FROM page_section ps WHERE ps.pages_id = ? AND (? = true OR ps.userid = ?)!;
    my $select-sect      = $dbh.prepare($sel-sect);
    my Str:D $sql-sect   = qq!UPDATE page_section SET _perms = ? WHERE id = ?!;
    my $update-sect      = $dbh.prepare($sql-sect);
    my Str:D $sel-ls     = qq!SELECT ls.id, ls._perms, ls.userid, ls.groupid, ls.section FROM links_sections ls WHERE ls.id = ? AND (? = true OR ls.userid = ?)!;
    my $select-ls        = $dbh.prepare($sel-ls);
    my Str:D $sql-ls     = qq!UPDATE links_sections SET _perms = ? WHERE id = ?!;
    my $update-ls        = $dbh.prepare($sql-ls);
    my Str:D $sel-links  = qq!SELECT l.id, l._perms, l.userid, l.groupid, l.name, l.link FROM links l WHERE l.section_id = ? AND (? = true OR l.userid = ?)!;
    my $select-links     = $dbh.prepare($sel-links);
    my Str:D $sql-links  = qq!UPDATE links SET _perms = ? WHERE id = ?!;
    my $update-links     = $dbh.prepare($sql-links);
    my Int $width = terminal-width;
    $width = $width // 80;
    my Int:D $w0 = 0;
    my Int:D $w1 = 0;
    my Int:D $w2 = 0;
    my Int:D $w3 = 0;
    my Int:D $w  = 0;
    if $verbose {
        ################################################################
        #                                                              #
        #           Only do these Calculations if we NEED TO           #
        #                                                              #
        ################################################################
        for @page-names -> $name {
            my $msg = "you lack the permissions to modify page: $name";
            $w0                   = max($w0,  wcswidth($msg));
            my $res               = $select.execute($name);
            my %values            = $res.row(:hash);
            my IdType $id         = %values«id»;
            my IdType $userid     = %values«userid»;
            my IdType $groupid    = %values«groupid»;
            my Str:D  $full-name  = %values«full_name»;
            $w0                   = max($w0,  wcswidth("|$name|"));
            $w1                   = max($w1,  wcswidth($full-name));
            unless $_admin || $userid == $loggedin_id {
                $w0 = max($w0,  wcswidth("you lack the permissions to modify page: $name"));
            }
            if $recursive {
                #############################################################
                #                                                           #
                #                   Recurse through it all                  #
                #                                                           #
                #############################################################
                my $res_               = $select-sect.execute($id, $_admin, $loggedin_id);
                my @page_sections      = $res_.allrows(:array-of-hash);
                for @page_sections -> %page_section {
                    my IdType $sect-id = %page_section«id»;
                    my IdType $ls-id   = %page_section«links_section_id»;
                    my Str:D  $msg     = qq[page_section: $sect-id perms changed];
                    my Str:D  $msg1    = "you lack the permissions to modify the page_section: $sect-id";
                    $w0                = max($w0,  wcswidth($msg), wcswidth($msg1));
                    my $_res           = $select-ls.execute($ls-id, $_admin, $loggedin_id);
                    my @links_sections = $_res.allrows(:array-of-hash);
                    for @links_sections -> %links_section {
                        my IdType $lns-id       = %links_section«id»;
                        my Str:D  $lns-section  = %links_section«section»;
                        my Str:D $msg  = "you lack the permissions to modify the section: $lns-section";
                        $w0            = max($w0,  wcswidth($msg));
                        $w2            = max($w2,  wcswidth("[$lns-section]"));
                    }
                    my $_res_          = $select-links.execute($ls-id, $_admin, $loggedin_id);
                    my @links          = $_res_.allrows(:array-of-hash);
                    for @links -> %link {
                        my IdType $link-id    = %link«id»;
                        my Str:D  $link-name  = %link«name»;
                        my Str:D $msg  = "you lack the permissions to modify the link: $link-name";
                        $w0            = max($w0,  wcswidth($msg));
                        $w3            = max($w3,  wcswidth($link-name));
                    } # for @links -> %link #
                } # for @page_sections -> %page_section #
            } # if $recursive #
        } # for @page-names -> $name #
        $w0 += 2; # padding #
        $w1 += 2;
        $w2 += 2;
        $w3 += 2;
        $w   = min($w0 + $w1 + $w2 + $w3,  $width);
    } # if $verbose #
    my Int:D $cnt = 0;
    ######################################################################
    #                                                                    #
    #                               Heading                              #
    #                                                                    #
    ######################################################################
    if $verbose {
        if $recursive {
            put (($cnt % 2 == 0) ?? t.bg-yellow !! t.bg-color(0,255,0)) ~ t.bold ~ t.bright-blue ~ sprintf("%-*s%-*s%-*s%-*s%18s%10s", $w0, 'page_name', $w1, 'full_name', $w2, 'section', $w3, 'link_name', centre('perms    ', 18, ' '), 'status') ~ t.text-reset;
            $cnt++;
            # put a horazontal line in #
            put (($cnt % 2 == 0) ?? t.bg-yellow !! t.bg-color(0,255,0)) ~ t.bold ~ t.bright-blue ~ ('=' x ($w0 + $w1 + $w2 + $w3 + 18 + 10)) ~ t.text-reset;
        } else {
            put (($cnt % 2 == 0) ?? t.bg-yellow !! t.bg-color(0,255,0)) ~ t.bold ~ t.bright-blue ~ sprintf("%-*s%-*s%18s%14s", $w0, 'page_name', $w1, 'full_name', centre('   perms', 18, ' '), 'status') ~ t.text-reset;
            $cnt++;
            # put a horazontal line in #
            put (($cnt % 2 == 0) ?? t.bg-yellow !! t.bg-color(0,255,0)) ~ t.bold ~ t.bright-blue ~ ('=' x ($w0 + $w1 + 18 + 14)) ~ t.text-reset;
        }
        $cnt++;
    }
    #####################################################################
    #                                                                   #
    #         Do the  actaul work ouputing progress if $verbose         #
    #                                                                   #
    #####################################################################
    for @page-names -> $name {
        my $res              = $select.execute($name);
        my %values           = $res.row(:hash);
        my IdType $id        = %values«id»;
        my IdType $userid    = %values«userid»;
        my IdType $groupid   = %values«groupid»;
        my Str:D $_old-perms = %values«_perms»;
        my Str:D  $full-name = %values«full_name»;
        my        %old-perms = GPerms.parse($_old-perms, actions => Perms.new).made;
        ####################################################################
        #                                                                  #
        #           insure you have the rights to do this at all           #
        #                                                                  #
        ####################################################################
        unless $_admin || $userid == $loggedin_id {
            my $msg = "you lack the permissions to modify page: $name";
            my Str:D $perms-str = perms-to-str(%old-perms);
            my Str:D $ok = 'Failed';
            put (($cnt % 2 == 0) ?? t.bg-yellow !! t.bg-color(0,255,0)) ~ t.bold ~ t.bright-blue ~ sprintf("%-*s%-*s%-*s%-*s%18s%10s", $w0, $msg, $w1, $full-name, $w2, '', $w3, '', centre($perms-str, 18, ' '), $ok) ~ t.text-reset;
            $cnt++;
            next;
        }
        my Str:D  $user_     = set-perms($user,  %old-perms«user»);
        my Str:D  $group_    = set-perms($group, %old-perms«group»);
        my Str:D  $other_    = set-perms($other, %old-perms«other»);
        my Str:D  $new-perms = qq[("$user_","$group_","$other_")];
        my Bool:D $r         = so $update.execute($new-perms, $id);
        if $verbose {
            my       %vals-perms = GPerms.parse($new-perms, actions => Perms.new).made;
            my Str:D $perms-str  = perms-to-str(%vals-perms);
            my Str:D $ok = ($r ?? 'OK' !! 'Failed');
            put (($cnt % 2 == 0) ?? t.bg-yellow !! t.bg-color(0,255,0)) ~ t.bold ~ t.bright-blue ~ sprintf("%-*s%-*s%-*s%-*s%18s%10s", $w0, "|$name|", $w1, $full-name, $w2, '', $w3, '', centre($perms-str, 18, ' '), $ok) ~ t.text-reset;
            $cnt++;
        }
        if $recursive {
            #############################################################
            #                                                           #
            #                   Recurse through it all                  #
            #                                                           #
            #############################################################
            my $res_           = $select-sect.execute($id, $_admin, $loggedin_id);
            my @page_sections  = $res_.allrows(:array-of-hash);
            for @page_sections -> %page_section {
                my IdType $sect-id      = %page_section«id»;
                my IdType $sect-userid  = %page_section«userid»;
                my IdType $sect-groupid = %page_section«groupid»;
                my Str:D  $sect-perms   = %page_section«_perms»;
                my IdType $ls-id        = %page_section«links_section_id»;
                my        %_sect-perms  = GPerms.parse($sect-perms, actions => Perms.new).made;
                ####################################################################
                #                                                                  #
                #              insure you have the rights to do this               #
                #                                                                  #
                ####################################################################
                unless $_admin || $sect-userid == $loggedin_id {
                    my Str:D $msg       = "you lack the permissions to modify the page_section: $sect-id";
                    my Str:D $perms-str = perms-to-str(%_sect-perms);
                    my Str:D $ok        = 'Failed';
                    put (($cnt % 2 == 0) ?? t.bg-yellow !! t.bg-color(0,255,0)) ~ t.bold ~ t.bright-blue ~ sprintf("%-*s%-*s%-*s%-*s%18s%10s", $w0, $msg, $w1, '', $w2, '', $w3, '', centre('', 18, ' '), $ok) ~ t.text-reset;
                    $cnt++;
                    next;
                }
                my Str:D  $sect-user      = set-perms($user,  %_sect-perms«user»);
                my Str:D  $sect-group     = set-perms($group, %_sect-perms«group»);
                my Str:D  $sect-other     = set-perms($other, %_sect-perms«other»);
                my Str:D  $sect-new-perms = qq[("$sect-user","$sect-group","$sect-other")];
                my Bool:D $ss             = so $update-sect.execute($sect-new-perms, $sect-id);
                if $verbose {
                    my       %vals-perms  = GPerms.parse($sect-new-perms, actions => Perms.new).made;
                    my Str:D $perms-str   = perms-to-str(%vals-perms);
                    my Str:D $ok          = ($ss ?? 'OK' !! 'Failed');
                    my Str:D $msg         = qq[page_section: $sect-id perms changed];
                    put (($cnt % 2 == 0) ?? t.bg-yellow !! t.bg-color(0,255,0)) ~ t.bold ~ t.bright-blue ~ sprintf("%-*s%-*s%-*s%-*s%18s%10s", $w0, $msg, $w1, '', $w2, '', $w3, '', centre($perms-str, 18, ' '), $ok) ~ t.text-reset;
                    $cnt++;
                }
                $result &&= $ss;
                my $_res           = $select-ls.execute($ls-id, $_admin, $loggedin_id);
                my @links_sections = $_res.allrows(:array-of-hash);
                for @links_sections -> %links_section {
                    my IdType $lns-id        = %links_section«id»;
                    my IdType $lns-userid    = %links_section«userid»;
                    my IdType $lns-groupid   = %links_section«groupid»;
                    my Str:D  $lns-perms     = %links_section«_perms»;
                    my Str:D  $lns-section   = %links_section«section»;
                    my        %_lns-perms    = GPerms.parse($sect-perms, actions => Perms.new).made;
                    ####################################################################
                    #                                                                  #
                    #              insure you have the rights to do this               #
                    #                                                                  #
                    ####################################################################
                    unless $_admin || $lns-userid == $loggedin_id {
                        my Str:D $msg       = "you lack the permissions to modify the section: $lns-section";
                        my Str:D $perms-str = perms-to-str(%_lns-perms);
                        my Str:D $ok        = 'Failed';
                        put (($cnt % 2 == 0) ?? t.bg-yellow !! t.bg-color(0,255,0)) ~ t.bold ~ t.bright-blue ~ sprintf("%-*s%-*s%-*s%-*s%18s%10s", $w0, $msg, $w1, '', $w2, '', $w3, '', centre('', 18, ' '), $ok) ~ t.text-reset;
                        $cnt++;
                        next;
                    }
                    my Str:D  $lns-user_     = set-perms($user,  %_lns-perms«user»);
                    my Str:D  $lns-group_    = set-perms($group, %_lns-perms«group»);
                    my Str:D  $lns-other_    = set-perms($other, %_lns-perms«other»);
                    my Str:D  $lns-new-perms = qq[("$lns-user_","$lns-group_","$lns-other_")];
                    my Bool:D $ls            = so $update-ls.execute($lns-new-perms, $lns-id);
                    if $verbose {
                        my %vals-perms       = GPerms.parse($new-perms, actions => Perms.new).made;
                        my Str:D $perms-str  = perms-to-str(%vals-perms);
                        my Str:D $ok         = ($ls ?? 'OK' !! 'Failed');
                        put (($cnt % 2 == 0) ?? t.bg-yellow !! t.bg-color(0,255,0)) ~ t.bold ~ t.bright-blue ~ sprintf("%-*s%-*s%-*s%-*s%18s%10s", $w0, '', $w1, '', $w2, "[$lns-section]", $w3, '', centre($perms-str, 18, ' '), $ok) ~ t.text-reset;
                        $cnt++;
                    }
                    $result &&= $ls;
                } # for @links_sections -> %links_section #
                my $_res_          = $select-links.execute($ls-id, $_admin, $loggedin_id);
                my @links          = $_res_.allrows(:array-of-hash);
                for @links -> %link {
                    my IdType $link-id        = %link«id»;
                    my IdType $link-userid    = %link«userid»;
                    my IdType $link-groupid   = %link«groupid»;
                    my Str:D  $link-name      = %link«name»;
                    my Str:D  $link-perms     = %link«_perms»;
                    my        %_link-perms    = GPerms.parse($link-perms, actions => Perms.new).made;
                    ####################################################################
                    #                                                                  #
                    #              insure you have the rights to do this               #
                    #                                                                  #
                    ####################################################################
                    unless $_admin || $link-userid == $loggedin_id {
                        my Str:D $msg       = "you lack the permissions to modify the link: $link-name";
                        my Str:D $perms-str = perms-to-str(%_link-perms);
                        my Str:D $ok        = 'Failed';
                        put (($cnt % 2 == 0) ?? t.bg-yellow !! t.bg-color(0,255,0)) ~ t.bold ~ t.bright-blue ~ sprintf("%-*s%-*s%-*s%-*s%18s%10s", $w0, $msg, $w1, '', $w2, '', $w3, '', centre('', 18, ' '), $ok) ~ t.text-reset;
                        $cnt++;
                        next;
                    }
                    my Str:D  $link-user_     = set-perms($user,  %_link-perms«user»);
                    my Str:D  $link-group_    = set-perms($group, %_link-perms«group»);
                    my Str:D  $link-other_    = set-perms($other, %_link-perms«other»);
                    my Str:D  $link-new-perms = qq[("$link-user_","$link-group_","$link-other_")];
                    my Bool:D $l              = so $update-links.execute($new-perms, $link-id);
                    if $verbose {
                        my %vals-perms        = GPerms.parse($new-perms, actions => Perms.new).made;
                        my Str:D $perms-str   = perms-to-str(%vals-perms);
                        my Str:D $ok = ($l ?? 'OK' !! 'Failed');
                        put (($cnt % 2 == 0) ?? t.bg-yellow !! t.bg-color(0,255,0)) ~ t.bold ~ t.bright-blue ~ sprintf("%-*s%-*s%-*s%-*s%18s%10s", $w0, '', $w1, '', $w2, '', $w3, $link-name, centre($perms-str, 18, ' '), $ok) ~ t.text-reset;
                        $cnt++;
                    }
                    $result &&= $l;
                } # for @links -> %link #
            } # for @vals -> %val #
        } # if $recursive #
        $result &&= $r;
    } # for @page-names -> $name #
    if $verbose {
        put (($cnt % 2 == 0) ?? t.bg-yellow !! t.bg-color(0,255,0)) ~ t.bold ~ t.bright-blue ~ sprintf("%-*s%18s%10s", $w, '', '', '') ~ t.text-reset;
        $cnt++;
    }
    return $result;
} # sub chmod-pages(Bool:D $recursive, Bool:D $verbose, %perms, @page-names --> Bool:D) is export #

sub perms-str(%perm-spec) {
    my Str:D $result = '';
    if %perm-spec«read» {
        $result ~= 'r';
    } else {
        $result ~= '-';
    }
    if %perm-spec«write» {
        $result ~= 'w';
    } else {
        $result ~= '-';
    }
    if %perm-spec«del» {
        $result ~= 'd';
    } else {
        $result ~= '-';
    }
    return $result;
} # sub perms-str(%perm-spec) #

sub perms-to-str(%perms) {
    return perms-str(%perms«user») ~ perms-str(%perms«group») ~ perms-str(%perms«other»);
} # sub perms-to-str(%perms) #

sub elipse(Str:D $s, Int:D $width --> Str:D) {
    my Int:D $w0 = wcswidth($s);
    my Int:D $w1 = $width div 3;
    return $s if wcswidth($s) < $width;
    my Str:D $result = $s.substr(0, $w1 * 2 - 4) ~ '... ' ~ $s.substr($w0 - $w1 + 1) ~ '  ';
    return $result;
}

sub list-page-perms(Bool:D $recursive, Bool:D $show-id, Bool:D $full is copy, Regex:D $pattern --> Bool:D) is export {
    my Bool:D $result = True;
    my Bool:D $loggedin                  = so %session«loggedin»;
    my Int    $loggedin_id               =    ((%session«loggedin_id»               === Any) ?? Int   !! %session«loggedin_id» );
    my Str    $loggedin_username         =    ((%session«loggedin_username»         === Any) ?? Str   !! %session«loggedin_username» );
    my Bool:D $_admin                    = so %session«loggedin_admin»;
    my Str    $display_name              =    ((%session«loggedin_display_name»     === Any) ?? Str   !! %session«loggedin_display_name» );
    my Str    $given                     =    ((%session«loggedin_given»            === Any) ?? Str   !! %session«loggedin_given» );
    my Str    $family                    =    ((%session«loggedin_family»           === Any) ?? Str   !! %session«loggedin_family» );
    my Str    $loggedin_email            =    ((%session«loggedin_email»            === Any) ?? Str   !! %session«loggedin_email» );
    my Str    $phone_number              =    ((%session«loggedin_phone_number»     === Any) ?? Str   !! %session«loggedin_phone_number» );
    my Str    $groupname                 =    ((%session«loggedin_groupname»        === Any) ?? Str   !! %session«loggedin_groupname» );
    my Int    $primary_group_id          =    ((%session«loggedin_groupnname_id»    === Any) ?? Int   !! %session«loggedin_groupnname_id» );
    my Str    $loggedin_prefix           =    ((%session«loggedin_prefix»           === Any) ?? Str   !! %session«loggedin_prefix» );
    my Str    $loggedin_escape           =    ((%session«loggedin_escape»           === Any) ?? Str   !! %session«loggedin_escape» );
    my Str    $loggedin_punct            =    ((%session«loggedin_punct»            === Any) ?? Str   !! %session«loggedin_punct» );
    my Regex  $loggedin_landline_pattern =    ((%session«loggedin_landline_pattern» === Any) ?? Regex !! %session«loggedin_landline_pattern» );
    my Regex  $loggedin_mobile_pattern   =    ((%session«loggedin_mobile_pattern»   === Any) ?? Regex !! %session«loggedin_mobile_pattern» );
    unless $loggedin {
        say "You must be loggedin to use this function: {&*ROUTINE.name}";
        return False;
    }
    my Int $width = terminal-width;
    $width = $width // 80;
    my Str:D $sql-select   = qq[SELECT p.id, p._perms, pd.username, g._name, p.name, p.full_name FROM pages p JOIN passwd pd ON pd.id = p.userid JOIN _group g ON g.id = p.groupid ORDER BY LOWER(p.name), p, name, LOWER(p.full_name), p.full_name];
    my $select             = $dbh.prepare($sql-select);
    my Str:D $sql-pg-sect  = qq[SELECT ps.id, ps.userid, ps.groupid, ps._perms, pd.username, g._name, ps.links_section_id FROM page_section ps JOIN passwd pd ON pd.id = ps.userid JOIN _group g ON g.id = ps.groupid WHERE ps.pages_id = ?];
    my $select-pg-sect     = $dbh.prepare($sql-pg-sect);
    my Str:D $sql-lnk-sect = qq[SELECT ls.id, ls.userid, ls.groupid, ls._perms, pd.username, g._name, ls.section FROM links_sections ls JOIN passwd pd ON pd.id = ls.userid JOIN _group g ON g.id = ls.groupid WHERE ls.id = ?];
    my $select-lnk-sect    = $dbh.prepare($sql-lnk-sect);
    my Str:D $sql-links    = qq[SELECT l.id, l.userid, l.groupid, l._perms, pd.username, g._name, l.name, l.link FROM links l JOIN passwd pd ON pd.id = l.userid JOIN _group g ON g.id = l.groupid WHERE l.section_id = ?];
    my $select-links       = $dbh.prepare($sql-links);
    my $res                = $select.execute();
    my @pages              = $res.allrows(:array-of-hash);
    my Int:D $w  = 0;
    my Int:D $w0 = wcswidth('username');
    my Int:D $w1 = wcswidth('group_name');
    my Int:D $w2 = wcswidth('page_name');
    my Int:D $w3 = wcswidth('full-name');
    my Int:D $w4 = 0;
    my Int:D $w5 = 0;
    my Int:D $w6 = 0;
    for @pages -> %values {
        my IdType $id        = %values«id»;
        my Str:D $name       = %values«name»;
        my Str:D $full-name  = %values«full_name»;
        next unless $name ~~ $pattern || $full-name ~~ $pattern;
        my Str:D $username   = %values«username»;
        my Str:D $group_name = %values«_name»;
        $w0 = max($w0, wcswidth($username));
        $w1 = max($w1, wcswidth($group_name));
        $w2 = max($w2, wcswidth($name));
        $w3 = max($w3, wcswidth($full-name));
        if $recursive {
            $w4               = max($w4, wcswidth('section'));
            $w5               = max($w5, wcswidth('name'));
            $w6               = max($w6, wcswidth('link'));
            my $_res          = $select-pg-sect.execute($id);
            my @page-sections = $_res.allrows(:array-of-hash);
            for @page-sections -> %page-section {
                my IdType:D $sect-id         = %page-section«id»;
                my IdType:D $sect-section-id = %page-section«links_section_id»;
                my Str:D    $sect-username   = %page-section«username»;
                my Str:D    $sect-group_name = %page-section«_name»;
                $w0 = max($w0, wcswidth($sect-username));
                $w1 = max($w1, wcswidth($sect-group_name));
                my $res_                     = $select-lnk-sect.execute($sect-section-id);
                my @link-sections            = $res_.allrows(:array-of-hash);
                for @link-sections -> %link-section {
                    my IdType:D $lns-id         = %link-section«id»;
                    my Str:D    $lns-username   = %link-section«username»;
                    my Str:D    $lns-group_name = %link-section«_name»;
                    my Str:D    $lns-section    = %link-section«section»;
                    $w0 = max($w0, wcswidth($lns-username));
                    $w1 = max($w1, wcswidth($lns-group_name));
                    $w4 = max($w4, wcswidth($lns-section));
                    my $_res_                   = $select-links.execute($lns-id);
                    my @links                   = $_res_.allrows(:array-of-hash);
                    for @links -> %link {
                        my IdType:D $lks-id         = %link«id»;
                        my Str:D    $lks-username   = %link«username»;
                        my Str:D    $lks-group_name = %link«_name»;
                        my Str:D    $lks-name       = %link«name»;
                        my Str:D    $lks-link       = %link«link»;
                        $w0 = max($w0, wcswidth($lks-username));
                        $w1 = max($w1, wcswidth($lks-group_name));
                        $w5 = max($w5, wcswidth($lks-name));
                        $w6 = max($w6, wcswidth($lks-link));
                    } # for @links -> %link #
                } # for @link-sections -> %link-section #
            } # for @page-sections -> %page-section #
        } # if $recursive #
    }
    $w0 += 2;
    $w1 += 2;
    $w2 += 2;
    $w3 += 2;
    if $recursive {
        $w4 += 2;
        $w5 += 2;
        $w6 += 2;
    }
    if $w0 + $w1 + $w2 + $w3 +$w4 + $w5 + $w6 + 32 >= $width {
        $w6 -= abs($width - ($w0 + $w1 + $w2 + $w3 +$w4 + $w5 + $w6 + 32));
        if $w6 < 10 {
            $w6 .=abs;
            $w3  = 10;
            $w4  = 10;
            $w6  = 10 if $w6 < 10;
        }
    } 
    $w   = min($w0 + $w1 + $w2 + $w3 +$w4 + $w5 + $w6 + 32, $width);
    my Int:D $num = $width div $w2;
    $num = 1 if $num < 1;
    my Int:D $cols = 0;
    my Str:D $line = '';
    my Int $cnt = 0;
    #@pages                  = |@pages.sort: { my %u = %($^a); my %v = %($^b);  my $res = %u«name».lc.trim cmp %v«name».lc.trim; (($res == Same) ?? (%u«full_name».lc.trim cmp %v«full_name».lc.trim) !! $res ) };
    if $recursive {
        $full = True;
        if $show-id && $full {
            put (($cnt % 2 == 0) ?? t.bg-yellow !! t.bg-color(0,255,0)) ~ t.bold ~ t.bright-blue ~ sprintf("%-10s%18s    %-*s%-*s%-*s%-*s%-*s%-*s%-*s", 'id', trailing-dots('    perms', 18, ' '), $w0, 'username', $w1, 'group_name', $w2, 'page-name', $w3, 'full-name', $w4, 'section', $w5, 'lks-name', $w6, 'lks-link') ~ t.text-reset;
            $cnt++;
            put (($cnt % 2 == 0) ?? t.bg-yellow !! t.bg-color(0,255,0)) ~ t.bold ~ t.bright-blue ~ ('=' x $w) ~ t.text-reset;
            $cnt++;
        } elsif $full {
            put (($cnt % 2 == 0) ?? t.bg-yellow !! t.bg-color(0,255,0)) ~ t.bold ~ t.bright-blue ~ sprintf("%-18s%-*s%-*s%-*s%-*s%-*s%-*s%-*s", trailing-dots('perms', 18, ' '), $w0, 'username', $w1, 'group_name', $w2, 'page-name', $w3, 'full-name', $w4, 'section', $w5, 'link-name', $w6, 'link') ~ t.text-reset;
            $cnt++;
            put (($cnt % 2 == 0) ?? t.bg-yellow !! t.bg-color(0,255,0)) ~ t.bold ~ t.bright-blue ~ ('=' x ($w - 14)) ~ t.text-reset;
            $cnt++;
        }
    } else { # if $recursive #
        if $show-id && $full {
            put (($cnt % 2 == 0) ?? t.bg-yellow !! t.bg-color(0,255,0)) ~ t.bold ~ t.bright-blue ~ sprintf("%-10s%18s    %-*s%-*s%-*s%-*s", 'id', trailing-dots('    perms', 18, ' '), $w0, 'username', $w1, 'group_name', $w2, 'name', $w3, 'full-name') ~ t.text-reset;
            $cnt++;
            put (($cnt % 2 == 0) ?? t.bg-yellow !! t.bg-color(0,255,0)) ~ t.bold ~ t.bright-blue ~ ('=' x $w) ~ t.text-reset;
            $cnt++;
        } elsif $full {
            put (($cnt % 2 == 0) ?? t.bg-yellow !! t.bg-color(0,255,0)) ~ t.bold ~ t.bright-blue ~ sprintf("%-18s%-*s%-*s%-*s%-*s", trailing-dots('perms', 18, ' '), $w0, 'username', $w1, 'group_name', $w2, 'name', $w3, 'full-name') ~ t.text-reset;
            $cnt++;
            put (($cnt % 2 == 0) ?? t.bg-yellow !! t.bg-color(0,255,0)) ~ t.bold ~ t.bright-blue ~ ('=' x ($w - 14)) ~ t.text-reset;
            $cnt++;
        }
    } # if $recursive else #
    for @pages -> %values {
        my IdType $id       = %values«id»;
        my Str:D $name      = %values«name»;
        my Str:D $full-name = %values«full_name»;
        next unless $name ~~ $pattern || $full-name ~~ $pattern;
        my Str:D $username   = %values«username»;
        my Str:D $group_name = %values«_name»;
        my Str:D $_perms    = %values«_perms»;
        my %perms = GPerms.parse($_perms, actions => Perms.new).made;
        my Str:D $perms = perms-to-str(%perms);
        if $recursive {
            $full = $recursive;
            if $show-id && $full {
                put (($cnt % 2 == 0) ?? t.bg-yellow !! t.bg-color(0,255,0)) ~ t.bold ~ t.bright-blue ~ sprintf("%-10d%18s    %-*s%-*s%-*s%-*s%-*s%-*s%-*s", $id, centre($perms, 18, ' '), $w0, $username, $w1, $group_name, $w2, $name, $w3, elipse($full-name, $w3), $w4, '', $w5, '', $w6, '') ~ t.text-reset;
                $cnt++;
            } elsif $full {
                put (($cnt % 2 == 0) ?? t.bg-yellow !! t.bg-color(0,255,0)) ~ t.bold ~ t.bright-blue ~ sprintf("%-18s%-*s%-*s%-*s%-*s%-*s%-*s%-*s", trailing-dots($perms, 18, ' '), $w0, $username, $w1, $group_name, $w2, $name, $w3, elipse($full-name, $w3), $w4, '', $w5, '', $w6, '') ~ t.text-reset;
                $cnt++;
            }
            my $_res          = $select-pg-sect.execute($id);
            my @page-sections = $_res.allrows(:array-of-hash);
            for @page-sections -> %page-section {
                my IdType:D $sect-id         = %page-section«id»;
                my IdType:D $sect-section-id = %page-section«links_section_id»;
                my Str:D    $sect-username   = %page-section«username»;
                my Str:D    $sect-group_name = %page-section«_name»;
                my Str:D    $sect-_perms     = %page-section«_perms»;
                my          %sect-perms      = GPerms.parse($sect-_perms, actions => Perms.new).made;
                my Str:D    $sect-perms      = perms-to-str(%sect-perms);
                if $show-id && $full {
                    put (($cnt % 2 == 0) ?? t.bg-yellow !! t.bg-color(0,255,0)) ~ t.bold ~ t.bright-blue ~ sprintf("%-10d%18s    %-*s%-*s%-*s%-*s%-*s%-*s%-*s", $id, centre($sect-perms, 18, ' '), $w0, $sect-username, $w1, $sect-group_name, $w2, '', $w3, '', $w4, '', $w5, '', $w6, '') ~ t.text-reset;
                    $cnt++;
                } elsif $full {
                    put (($cnt % 2 == 0) ?? t.bg-yellow !! t.bg-color(0,255,0)) ~ t.bold ~ t.bright-blue ~ sprintf("%-18s%-*s%-*s%-*s%-*s%-*s%-*s%-*s", trailing-dots($sect-perms, 18, ' '), $w0, $sect-username, $w1, $sect-group_name, $w2, '', $w3, '', $w4, '', $w5, '', $w6, '') ~ t.text-reset;
                    $cnt++;
                }
                my $res_                     = $select-lnk-sect.execute($sect-section-id);
                my @link-sections            = $res_.allrows(:array-of-hash);
                for @link-sections -> %link-section {
                    my IdType:D $lns-id         = %link-section«id»;
                    my Str:D    $lns-username   = %link-section«username»;
                    my Str:D    $lns-group_name = %link-section«_name»;
                    my Str:D    $lns-section    = %link-section«section»;
                    my Str:D    $lns-_perms     = %link-section«_perms»;
                    my          %lns-perms      = GPerms.parse($lns-_perms, actions => Perms.new).made;
                    my Str:D    $lns-perms      = perms-to-str(%lns-perms);
                    if $show-id && $full {
                        put (($cnt % 2 == 0) ?? t.bg-yellow !! t.bg-color(0,255,0)) ~ t.bold ~ t.bright-blue ~ sprintf("%-10d%18s    %-*s%-*s%-*s%-*s%-*s%-*s%-*s", $id, centre($lns-perms, 18, ' '), $w0, $lns-username, $w1, $lns-group_name, $w2, '', $w3, '', $w4, elipse($lns-section, $w4), $w5, '', $w6, '') ~ t.text-reset;
                        $cnt++;
                    } elsif $full {
                        put (($cnt % 2 == 0) ?? t.bg-yellow !! t.bg-color(0,255,0)) ~ t.bold ~ t.bright-blue ~ sprintf("%-18s%-*s%-*s%-*s%-*s%-*s%-*s%-*s", trailing-dots($lns-perms, 18, ' '), $w0, $lns-username, $w1, $lns-group_name, $w2, '', $w3, '', $w4, elipse($lns-section, $w4), $w5, '', $w6, '') ~ t.text-reset;
                        $cnt++;
                    }
                    my $_res_                   = $select-links.execute($lns-id);
                    my @links                   = $_res_.allrows(:array-of-hash);
                    for @links -> %link {
                        my IdType:D $lks-id         = %link«id»;
                        my Str:D    $lks-username   = %link«username»;
                        my Str:D    $lks-group_name = %link«_name»;
                        my Str:D    $lks-name       = %link«name»;
                        my Str:D    $lks-link       = %link«link»;
                        my Str:D    $lks-_perms     = %link«_perms»;
                        my          %lks-perms      = GPerms.parse($lks-_perms, actions => Perms.new).made;
                        my Str:D    $lks-perms      = perms-to-str(%lks-perms);
                        if $show-id && $full {
                            put (($cnt % 2 == 0) ?? t.bg-yellow !! t.bg-color(0,255,0)) ~ t.bold ~ t.bright-blue ~ sprintf("%-10d%18s    %-*s%-*s%-*s%-*s%-*s%-*s%-*s", $id, centre($lks-perms, 18, ' '), $w0, $lks-username, $w1, $lns-group_name, $w2, '', $w3, '', $w4, '', $w5, $lks-name, $w6, elipse($lks-link, $w6 - 1)) ~ t.text-reset;
                            $cnt++;
                        } elsif $full {
                            put (($cnt % 2 == 0) ?? t.bg-yellow !! t.bg-color(0,255,0)) ~ t.bold ~ t.bright-blue ~ sprintf("%-18s%-*s%-*s%-*s%-*s%-*s%-*s%-*s", trailing-dots($lks-perms, 18, ' '), $w0, $lks-username, $w1, $lns-group_name, $w2, '', $w3, '', $w4, '', $w5, $lks-name, $w6, elipse($lks-link, $w6 - 1)) ~ t.text-reset;
                            $cnt++;
                        }
                    } # for @links -> %link #
                } # for @link-sections -> %link-section #
            } # for @page-sections -> %page-section #
        } else { # if $recursive #
            if $show-id && $full {
                put (($cnt % 2 == 0) ?? t.bg-yellow !! t.bg-color(0,255,0)) ~ t.bold ~ t.bright-blue ~ sprintf("%-10d%18s    %-*s%-*s%-*s%-*s", $id, centre($perms, 18, ' '), $w0, $username, $w1, $group_name, $w2, $name, $w3, $full-name) ~ t.text-reset;
                $cnt++;
            } elsif $full {
                put (($cnt % 2 == 0) ?? t.bg-yellow !! t.bg-color(0,255,0)) ~ t.bold ~ t.bright-blue ~ sprintf("%-18s%-*s%-*s%-*s%-*s", trailing-dots($perms, 18, ' '), $w0, $username, $w1, $group_name, $w2, $name, $w3, $full-name) ~ t.text-reset;
                $cnt++;
            } elsif $cols >= $num {
                put (($cnt % 2 == 0) ?? t.bg-yellow !! t.bg-color(0,255,0)) ~ t.bold ~ t.bright-blue ~ $line ~ t.text-reset;
                $cnt++;
                $line = '';
                $cols = 0;
            } else {
                $line ~= sprintf "%-*s", $w2, $name;
                $cols++;
            }
        } # if $recursive else #
    } # for @pages -> %values #
    if $line ne '' {
        put (($cnt % 2 == 0) ?? t.bg-yellow !! t.bg-color(0,255,0)) ~ t.bold ~ t.bright-blue ~ $line ~ t.text-reset;
        $cnt++;
        $line = '';
        $cols = 0;
    }
    if $show-id && $full {
        put (($cnt % 2 == 0) ?? t.bg-yellow !! t.bg-color(0,255,0)) ~ t.bold ~ t.bright-blue ~ (' ' x $w) ~ t.text-reset;
        $cnt++;
    } elsif $full {
        put (($cnt % 2 == 0) ?? t.bg-yellow !! t.bg-color(0,255,0)) ~ t.bold ~ t.bright-blue ~ (' ' x ($w - 14)) ~ t.text-reset;
        $cnt++;
    }
    return $result;
} # sub list-page-perms(Bool:D $recursive, Bool:D $show-id, Bool:D $full, Regex:D $pattern --> Bool:D) is export #

sub get-user-group-and-ids(Str $user, IdType $userid, Str $group, IdType $groupid, IdType:D $old-userid, IdType:D $old-groupid  --> List) {
    my Str    $user-to;
    my IdType $userid-to;
    my Str    $group-to;
    my IdType $groupid-to;
    #############################################################
    #                                                           #
    #           get the user and group names and id'd           #
    #                                                           #
    #############################################################
    my Str:D $sel-userid  = qq!SELECT pw.id FROM passwd pw WHERE pw.username = ?!;
    my $select-userid     = $dbh.prepare($sel-userid);
    my Str:D $sel-user    = qq!SELECT pw.username FROM passwd pw WHERE pw.id = ?!;
    my $select-user       = $dbh.prepare($sel-user);
    my Str:D $sel-groupid = qq!SELECT g.id FROM _group g WHERE g._name = ?!;
    my $select-groupid    = $dbh.prepare($sel-groupid);
    my Str:D $sel-group   = qq!SELECT g._name FROM _group g WHERE g.id = ?!;
    my $select-group      = $dbh.prepare($sel-group);
    with $user {
        $user-to    = $user;
        my $res     = $select-userid.execute($user-to);
        my %val     = $res.row(:hash);
        $userid-to  = %val«id»;
    } orwith $userid {
        $userid-to  = $userid;
        my $res     = $select-user.execute($userid-to);
        my %val     = $res.row(:hash);
        $user-to    = %val«username»;
    } else {
        $userid-to  = $old-userid;
        my $res     = $select-user.execute($userid-to);
        my %val     = $res.row(:hash);
        $user-to    = %val«username»;
    }
    with $group {
        $group-to   = $group;
        my $res     = $select-groupid.execute($group-to);
        my %val     = $res.row(:hash);
        $groupid-to = %val«id»;
    } orwith $groupid {
        $groupid-to = $groupid;
        my $res     = $select-group.execute($groupid-to);
        my %val     = $res.row(:hash);
        $group-to   = %val«_name»;
    } else {
        $groupid-to = $old-groupid;
        my $res     = $select-group.execute($groupid-to);
        my %val     = $res.row(:hash);
        $group-to   = %val«_name»;
    }
    return $user-to, $userid-to, $group-to, $groupid-to;
} # sub get-user-group-and-ids(Str $user, IdType $userid, Str $group, IdType $groupid, IdType:D $old-userid, IdType:D $old-groupid  --> List) #

sub chown-page(Bool:D $recursive, Bool:D $verbose, Str $user, IdType $userid, Str $group, IdType $groupid, @page-names --> Bool:D) is export {
    my Bool:D $result = True;
    my Bool:D $loggedin                  = so %session«loggedin»;
    my Int    $loggedin_id               =    ((%session«loggedin_id»               === Any) ?? Int   !! %session«loggedin_id» );
    my Str    $loggedin_username         =    ((%session«loggedin_username»         === Any) ?? Str   !! %session«loggedin_username» );
    my Bool:D $_admin                    = so %session«loggedin_admin»;
    my Str    $display_name              =    ((%session«loggedin_display_name»     === Any) ?? Str   !! %session«loggedin_display_name» );
    my Str    $given                     =    ((%session«loggedin_given»            === Any) ?? Str   !! %session«loggedin_given» );
    my Str    $family                    =    ((%session«loggedin_family»           === Any) ?? Str   !! %session«loggedin_family» );
    my Str    $loggedin_email            =    ((%session«loggedin_email»            === Any) ?? Str   !! %session«loggedin_email» );
    my Str    $phone_number              =    ((%session«loggedin_phone_number»     === Any) ?? Str   !! %session«loggedin_phone_number» );
    my Str    $groupname                 =    ((%session«loggedin_groupname»        === Any) ?? Str   !! %session«loggedin_groupname» );
    my Int    $primary_group_id          =    ((%session«loggedin_groupnname_id»    === Any) ?? Int   !! %session«loggedin_groupnname_id» );
    my Str    $loggedin_prefix           =    ((%session«loggedin_prefix»           === Any) ?? Str   !! %session«loggedin_prefix» );
    my Str    $loggedin_escape           =    ((%session«loggedin_escape»           === Any) ?? Str   !! %session«loggedin_escape» );
    my Str    $loggedin_punct            =    ((%session«loggedin_punct»            === Any) ?? Str   !! %session«loggedin_punct» );
    my Regex  $loggedin_landline_pattern =    ((%session«loggedin_landline_pattern» === Any) ?? Regex !! %session«loggedin_landline_pattern» );
    my Regex  $loggedin_mobile_pattern   =    ((%session«loggedin_mobile_pattern»   === Any) ?? Regex !! %session«loggedin_mobile_pattern» );
    #######################################################
    #                                                     #
    #           Only loggedin users may do this           #
    #                                                     #
    #######################################################
    unless $loggedin {
        say "You must be loggedin to use this function: {&*ROUTINE.name}";
        return False;
    }
    ######################################################################
    #                                                                    #
    #           You must be an admin user to use this function           #
    #                                                                    #
    ######################################################################
    unless $_admin {
        say "You must be an admin to use this function: {&*ROUTINE.name}";
        return False;
    }
    my Str:D $sql-select  = qq!SELECT p.id, pd.username, p.userid, g._name, p.groupid, p.full_name FROM pages p JOIN passwd pd ON p.userid = pd.id JOIN _group g ON p.groupid = g.id WHERE p.name = ?!;
    my $select            = $dbh.prepare($sql-select);
    my Str:D $sql         = qq!UPDATE pages SET userid = ?, groupid = ? WHERE id = ?!;
    my $update            = $dbh.prepare($sql);
    my Str:D $sel-sect    = qq!SELECT ps.id, pd.username, ps.userid, g._name, ps.groupid, ps.links_section_id FROM page_section ps JOIN passwd pd ON ps.userid = pd.id JOIN _group g ON ps.groupid = g.id WHERE ps.pages_id = ? AND (? = true OR ps.userid = ?)!;
    my $select-sect       = $dbh.prepare($sel-sect);
    my Str:D $sql-sect    = qq!UPDATE page_section SET userid = ?, groupid = ? WHERE id = ?!;
    my $update-sect       = $dbh.prepare($sql-sect);
    my Str:D $sel-ls      = qq!SELECT ls.id, pd.username, ls.userid, g._name, ls.groupid, ls.section FROM links_sections ls JOIN passwd pd ON ls.userid = pd.id JOIN _group g ON ls.groupid = g.id WHERE ls.id = ? AND (? = true OR ls.userid = ?)!;
    my $select-ls         = $dbh.prepare($sel-ls);
    my Str:D $sql-ls      = qq!UPDATE links_sections SET userid = ?, groupid = ? WHERE id = ?!;
    my $update-ls         = $dbh.prepare($sql-ls);
    my Str:D $sel-links   = qq!SELECT l.id, pd.username, l.userid, g._name, l.groupid, l.name, l.link FROM links l JOIN passwd pd ON l.userid = pd.id JOIN _group g ON l.groupid = g.id WHERE l.section_id = ? AND (? = true OR l.userid = ?)!;
    my $select-links      = $dbh.prepare($sel-links);
    my Str:D $sql-links   = qq!UPDATE links SET userid = ?, groupid = ? WHERE id = ?!;
    my $update-links      = $dbh.prepare($sql-links);
    my Int $width         = terminal-width;
    $width = $width // 80;
    my Int:D $w  = 0;
    if $verbose {
        ################################################################
        #                                                              #
        #           Only do these Calculations if we NEED TO           #
        #                                                              #
        ################################################################
        my Str:D    $user-to    = '';
        my IdType:D $userid-to  = 0;
        my Str:D    $group-to   = '';
        my IdType:D $groupid-to = 0;
        for @page-names -> $name {
            my $res                  = $select.execute($name);
            my %values               = $res.row(:hash);
            my IdType:D $id          = %values«id»;
            my Str:D    $old-user    = %values«username»;
            my IdType:D $old-userid  = %values«userid»;
            my Str:D    $old-group   = %values«_name»;
            my IdType:D $old-groupid = %values«groupid»;
            my Str:D    $full-name   = %values«full_name»;
            ($user-to,  $userid-to, $group-to, $groupid-to) = get-user-group-and-ids($user, $userid, $group, $groupid, $old-userid, $old-groupid);
            my Str:D    $msg0         = qq[changed user of $name ($full-name) from $old-user to $user-to];
            my Str:D    $msg1         = qq[changed group of $name ($full-name) from $old-group to $group-to];
            my Str:D    $msg2         = qq[changed user and group of $name ($full-name) from $old-user:$old-group to $user-to:$group-to];
            my Str:D    $msg3         = qq[retained user and group of $name ($full-name) as $old-user:$old-group];
            my Str:D    $msg4         = qq[Error: could not change user and group of $name ($full-name) to $old-user:$old-group];
            $w                        = max($w,  wcswidth($msg0), wcswidth($msg1), wcswidth($msg2), wcswidth($msg3), wcswidth($msg4));
            if $recursive {
                #############################################################
                #                                                           #
                #                   Recurse through it all                  #
                #                                                           #
                #############################################################
                my $res_               = $select-sect.execute($id, $_admin, $loggedin_id);
                my @page_sections      = $res_.allrows(:array-of-hash);
                for @page_sections -> %page_section {
                    my IdType:D $sect-id      = %page_section«id»;
                    my Str:D    $sect-user    = %page_section«username»;
                    my IdType:D $sect-userid  = %page_section«userid»;
                    my Str:D    $sect-group   = %page_section«_name»;
                    my IdType:D $sect-groupid = %page_section«groupid»;
                    my IdType:D $ls-id        = %page_section«links_section_id»;
                    ($user-to,  $userid-to, $group-to, $groupid-to) = get-user-group-and-ids($user, $userid, $group, $groupid, $sect-userid, $sect-groupid);
                    my Str:D    $msg0         = qq[changed user of page_section from $sect-user to $user-to];
                    my Str:D    $msg1         = qq[changed group of page_section from $sect-group to $group-to];
                    my Str:D    $msg2         = qq[changed user and group of page_section from $sect-user:$sect-group to $user-to:$group-to];
                    my Str:D    $msg3         = qq[retained user and group of page_section as $sect-user:$sect-group];
                    my Str:D    $msg4         = qq[Error: could not change user and group of page_section to $sect-user:$sect-group];
                    $w                        = max($w,  wcswidth($msg0), wcswidth($msg1), wcswidth($msg2), wcswidth($msg3), wcswidth($msg4));
                    my $_res           = $select-ls.execute($ls-id, $_admin, $loggedin_id);
                    my @links_sections = $_res.allrows(:array-of-hash);
                    for @links_sections -> %links_section {
                        my IdType:D $lns-id       = %links_section«id»;
                        my Str:D    $lns-user     = %links_section«username»;
                        my IdType:D $lns-userid   = %links_section«userid»;
                        my Str:D    $lns-group    = %links_section«_name»;
                        my IdType:D $lns-groupid  = %links_section«groupid»;
                        my Str:D    $lns-section  = %links_section«section»;
                        ($user-to,  $userid-to, $group-to, $groupid-to) = get-user-group-and-ids($user, $userid, $group, $groupid, $lns-userid, $lns-groupid);
                        my Str:D    $msg0         = qq[changed user of $lns-section from $lns-user to $user-to];
                        my Str:D    $msg1         = qq[changed group of $lns-section from $lns-group to $group-to];
                        my Str:D    $msg2         = qq[changed user and group of $lns-section from $lns-user:$lns-group to $user-to:$group-to];
                        my Str:D    $msg3         = qq[retained user and group of $lns-section as $lns-user:$lns-group];
                        my Str:D    $msg4         = qq[Error: could not change user and group of $lns-section to $lns-user:$lns-group];
                        $w                        = max($w,  wcswidth($msg0), wcswidth($msg1), wcswidth($msg2), wcswidth($msg3), wcswidth($msg4));
                    }
                    my $_res_          = $select-links.execute($ls-id, $_admin, $loggedin_id);
                    my @links          = $_res_.allrows(:array-of-hash);
                    for @links -> %link {
                        my IdType:D $link-id      = %link«id»;
                        my Str:D    $link-user    = %link«username»;
                        my IdType:D $link-userid  = %link«userid»;
                        my Str:D    $link-group   = %link«_name»;
                        my IdType:D $link-groupid = %link«groupid»;
                        my Str:D    $link-name    = %link«name»;
                        ($user-to,  $userid-to, $group-to, $groupid-to) = get-user-group-and-ids($user, $userid, $group, $groupid, $link-userid, $link-groupid);
                        my Str:D    $msg0         = qq[changed user of $link-name from $link-user to $user-to];
                        my Str:D    $msg1         = qq[changed group of $link-name from $link-group to $group-to];
                        my Str:D    $msg2         = qq[changed user and group of $link-name from $link-user:$link-group to $user-to:$group-to];
                        my Str:D    $msg3         = qq[retained user and group of $link-name as $link-user:$link-group];
                        my Str:D    $msg4         = qq[Error: could not change user and group of $link-name to $link-user:$link-group];
                        $w                        = max($w,  wcswidth($msg0), wcswidth($msg1), wcswidth($msg2), wcswidth($msg3), wcswidth($msg4));
                    } # for @links -> %link #
                } # for @page_sections -> %page_section #
            } # if $recursive #
        } # for @page-names -> $name #
        $w  += 2;
        $w   = min($w,  $width);
    } # if $verbose #
    my Int:D $cnt = 0;
    #####################################################################
    #                                                                   #
    #         Do the  actaul work ouputing progress if $verbose         #
    #                                                                   #
    #####################################################################
    for @page-names -> $name {
        my Str:D    $user-to    = '';
        my IdType:D $userid-to  = 0;
        my Str:D    $group-to   = '';
        my IdType:D $groupid-to = 0;
        my $res                    = $select.execute($name);
        my %values                 = $res.row(:hash);
        my IdType:D $id            = %values«id»;
        my IdType:D $old-userid    = %values«userid»;
        my Str:D    $old-user      = %values«username»;
        my IdType:D $old-groupid   = %values«groupid»;
        my Str:D    $old-group     = %values«_name»;
        my Str:D    $full-name     = %values«full_name»;
        ($user-to,  $userid-to, $group-to, $groupid-to) = get-user-group-and-ids($user, $userid, $group, $groupid, $old-userid, $old-groupid);
        my Bool:D $r               = so $update.execute($userid-to, $groupid-to, $id);
        if $verbose {
            my Str:D $msg = '';
            if $r {
                if $old-user eq $user-to && $old-group ne $group-to {
                    $msg        = qq[changed group of $name ($full-name) from $old-group to $group-to];
                } elsif $old-user ne $user-to && $old-group eq $group-to {
                    $msg        = qq[changed user of $name ($full-name) from $old-user to $user-to];
                } elsif $old-user ne $user-to && $old-group ne $group-to {
                    $msg        = qq[changed user and group of $name ($full-name) from $old-user:$old-group to $user-to:$group-to];
                } else {
                    $msg        = qq[retained user and group of $name ($full-name) as $old-user:$old-group];
                }
            } else  {
                $msg            = qq[Error: could not change user and group of $name ($full-name) to $old-user:$old-group];
            }
            my Str:D $ok = ($r ?? 'OK' !! 'Failed');
            put (($cnt % 2 == 0) ?? t.bg-yellow !! t.bg-color(0,255,0)) ~ t.bold ~ t.bright-blue ~ sprintf("%-*s", $w, $msg) ~ t.text-reset;
            $cnt++;
        }
        if $recursive {
            #############################################################
            #                                                           #
            #                   Recurse through it all                  #
            #                                                           #
            #############################################################
            my $res_           = $select-sect.execute($id, $_admin, $loggedin_id);
            my @page_sections  = $res_.allrows(:array-of-hash);
            for @page_sections -> %page_section {
                my IdType:D $sect-id      = %page_section«id»;
                my Str:D    $sect-user    = %page_section«username»;
                my IdType:D $sect-userid  = %page_section«userid»;
                my Str:D    $sect-group   = %page_section«_name»;
                my IdType:D $sect-groupid = %page_section«groupid»;
                my IdType:D $ls-id        = %page_section«links_section_id»;
                ($user-to,  $userid-to, $group-to, $groupid-to) = get-user-group-and-ids($user, $userid, $group, $groupid, $sect-userid, $sect-groupid);
                my Bool:D $ss             = so $update-sect.execute($userid-to, $groupid-to, $sect-id);
                if $verbose {
                    my Str:D $msg = '';
                    if $ss {
                        if $sect-user eq $user-to && $sect-group ne $group-to {
                            $msg          = qq[changed user of page_section from $sect-user to $user-to];
                        } elsif $sect-user ne $user-to && $sect-group eq $group-to { 
                            $msg          = qq[changed group of page_section from $sect-group to $group-to];
                        } elsif $sect-user ne $user-to && $sect-group ne $group-to { 
                            $msg          = qq[changed user and group of page_section from $sect-user:$sect-group to $user-to:$group-to];
                        } else {
                            $msg          = qq[retained user and group of page_section as $sect-user:$sect-group];
                        }
                    } else {
                        $msg              = qq[Error: could not change user and group of page_section to $sect-user:$sect-group];
                    }
                    put (($cnt % 2 == 0) ?? t.bg-yellow !! t.bg-color(0,255,0)) ~ t.bold ~ t.bright-blue ~ sprintf("%-*s", $w, $msg) ~ t.text-reset;
                    $cnt++;
                }
                $result &&= $ss;
                my $_res           = $select-ls.execute($ls-id, $_admin, $loggedin_id);
                my @links_sections = $_res.allrows(:array-of-hash);
                for @links_sections -> %links_section {
                    my IdType:D $lns-id       = %links_section«id»;
                    my Str:D    $lns-user     = %links_section«username»;
                    my IdType:D $lns-userid   = %links_section«userid»;
                    my Str:D    $lns-group    = %links_section«_name»;
                    my IdType:D $lns-groupid  = %links_section«groupid»;
                    my Str:D    $lns-section  = %links_section«section»;
                    ($user-to,  $userid-to, $group-to, $groupid-to) = get-user-group-and-ids($user, $userid, $group, $groupid, $lns-userid, $lns-groupid);
                    my Bool:D $ls             = so $update-ls.execute($userid-to, $groupid-to, $lns-id);
                    if $verbose {
                        my Str:D $msg = '';
                        if $ls {
                            if $lns-user eq $user-to && $lns-group ne $group-to { 
                                $msg          = qq[changed user of $lns-section from $lns-user to $user-to];
                            } elsif $lns-user ne $user-to && $lns-group eq $group-to { 
                                $msg          = qq[changed group of $lns-section from $lns-group to $group-to];
                            } elsif $lns-user ne $user-to && $lns-group ne $group-to { 
                                $msg          = qq[changed user and group of $lns-section from $lns-user:$lns-group to $user-to:$group-to];
                            } else {
                                $msg          = qq[retained user and group of $lns-section as $lns-user:$lns-group];
                            }
                        } else {
                            $msg          = qq[Error: could not change user and group of $lns-section to $lns-user:$lns-group];
                        }
                        put (($cnt % 2 == 0) ?? t.bg-yellow !! t.bg-color(0,255,0)) ~ t.bold ~ t.bright-blue ~ sprintf("%-*s", $w, $msg) ~ t.text-reset;
                        $cnt++;
                    }
                    $result &&= $ls;
                } # for @links_sections -> %links_section #
                my $_res_          = $select-links.execute($ls-id, $_admin, $loggedin_id);
                my @links          = $_res_.allrows(:array-of-hash);
                for @links -> %link {
                    my IdType:D $link-id      = %link«id»;
                    my Str:D    $link-user    = %link«username»;
                    my IdType:D $link-userid  = %link«userid»;
                    my Str:D    $link-group   = %link«_name»;
                    my IdType:D $link-groupid = %link«groupid»;
                    my Str:D    $link-name    = %link«name»;
                    ($user-to,  $userid-to, $group-to, $groupid-to) = get-user-group-and-ids($user, $userid, $group, $groupid, $link-userid, $link-groupid);
                    my Bool:D $l              = so $update-links.execute($userid-to, $groupid-to, $link-id);
                    if $verbose {
                        my Str:D $msg = '';
                        if $l {
                            if $link-user eq $user-to && $link-group ne $group-to { 
                                $msg          = qq[changed user of $link-name from $link-user to $user-to];
                            } elsif $link-user ne $user-to && $link-group eq $group-to { 
                                $msg          = qq[changed group of $link-name from $link-group to $group-to];
                            } elsif $link-user ne $user-to && $link-group ne $group-to { 
                                $msg          = qq[changed user and group of $link-name from $link-user:$link-group to $user-to:$group-to];
                            } else {
                                $msg          = qq[retained user and group of $link-name as $link-user:$link-group];
                            }
                        } else {
                            $msg          = qq[Error: could not change user and group of $link-name to $link-user:$link-group];
                        }
                        put (($cnt % 2 == 0) ?? t.bg-yellow !! t.bg-color(0,255,0)) ~ t.bold ~ t.bright-blue ~ sprintf("%-*s", $w, $msg) ~ t.text-reset;
                        $cnt++;
                    }
                    $result &&= $l;
                } # for @links -> %link #
            } # for @vals -> %val #
        } # if $recursive #
        $result &&= $r;
    } # for @page-names -> $name #
    if $verbose {
        put (($cnt % 2 == 0) ?? t.bg-yellow !! t.bg-color(0,255,0)) ~ t.bold ~ t.bright-blue ~ sprintf("%-*s", $w, '') ~ t.text-reset;
        $cnt++;
    }
    return $result;
} # sub chown-page(Bool:D $recursive, Bool:D $verbose, Str $user, IdType $userid, Str $group, IdType $groupid, @page-names --> Bool:D) is export #

sub chmod-pseudo-page(Bool:D $verbose, %perms, @page-names --> Bool:D) is export {
    my Bool:D $result = True;
    my Bool:D $loggedin                  = so %session«loggedin»;
    my Int    $loggedin_id               =    ((%session«loggedin_id»               === Any) ?? Int   !! %session«loggedin_id» );
    my Str    $loggedin_username         =    ((%session«loggedin_username»         === Any) ?? Str   !! %session«loggedin_username» );
    my Bool:D $_admin                    = so %session«loggedin_admin»;
    my Str    $display_name              =    ((%session«loggedin_display_name»     === Any) ?? Str   !! %session«loggedin_display_name» );
    my Str    $given                     =    ((%session«loggedin_given»            === Any) ?? Str   !! %session«loggedin_given» );
    my Str    $family                    =    ((%session«loggedin_family»           === Any) ?? Str   !! %session«loggedin_family» );
    my Str    $loggedin_email            =    ((%session«loggedin_email»            === Any) ?? Str   !! %session«loggedin_email» );
    my Str    $phone_number              =    ((%session«loggedin_phone_number»     === Any) ?? Str   !! %session«loggedin_phone_number» );
    my Str    $groupname                 =    ((%session«loggedin_groupname»        === Any) ?? Str   !! %session«loggedin_groupname» );
    my Int    $primary_group_id          =    ((%session«loggedin_groupnname_id»    === Any) ?? Int   !! %session«loggedin_groupnname_id» );
    my Str    $loggedin_prefix           =    ((%session«loggedin_prefix»           === Any) ?? Str   !! %session«loggedin_prefix» );
    my Str    $loggedin_escape           =    ((%session«loggedin_escape»           === Any) ?? Str   !! %session«loggedin_escape» );
    my Str    $loggedin_punct            =    ((%session«loggedin_punct»            === Any) ?? Str   !! %session«loggedin_punct» );
    my Regex  $loggedin_landline_pattern =    ((%session«loggedin_landline_pattern» === Any) ?? Regex !! %session«loggedin_landline_pattern» );
    my Regex  $loggedin_mobile_pattern   =    ((%session«loggedin_mobile_pattern»   === Any) ?? Regex !! %session«loggedin_mobile_pattern» );
    #######################################################
    #                                                     #
    #           Only loggedin users may do this           #
    #                                                     #
    #######################################################
    unless $loggedin {
        say "You must be loggedin to use this function: {&*ROUTINE.name}";
        return False;
    }
    constant $URead  = 0o400;
    constant $UWrite = 0o200;
    constant $UDel   = 0o100;
    constant $GRead  = 0o040;
    constant $GWrite = 0o020;
    constant $GDel   = 0o010;
    constant $ORead  = 0o004;
    constant $OWrite = 0o002;
    constant $ODel   = 0o001;
    my Str:D $theperms = '';
    my Str:D $user  = '';
    my Str:D $group = '';
    my Str:D $other = '';
    if %perms«perms»:exists {
        #####################################################
        #                                                   #
        #                                                   #
        #                                                   #
        #                                                   #
        #           proccess the numerical perms            #
        #           Note: you can only supply               #
        #           either numeric or symbolic              #
        #           specs,  sybolic is far more             #
        #           powerful and selective                  #
        #           numeric are converted to                #
        #           symbolic the '=' start forces           #
        #           the perm to exact values                #
        #                                                   #
        #                                                   #
        #                                                   #
        #                                                   #
        #####################################################
        my Int:D $p = %perms«perms»;
        $user  ~= '=';
        $group ~= '=';
        $other ~= '=';
        if $p +& $URead {
            $user ~= 'r';
        }
        if $p +& $UWrite {
            $user ~= 'w';
        }
        if $p +& $UDel {
            $user ~= 'd';
        }
        if $p +& $GRead {
            $group ~= 'r';
        }
        if $p +& $GWrite {
            $group ~= 'w';
        }
        if $p +& $GDel {
            $group ~= 'd';
        }
        if $p +& $ORead {
            $other ~= 'r';
        }
        if $p +& $OWrite {
            $other ~= 'w';
        }
        if $p +& $ODel {
            $other ~= 'd';
        }
    } else {
        $user  = %perms«user»  if %perms«user»:exists;
        $group = %perms«group» if %perms«group»:exists;
        $other = %perms«other» if %perms«other»:exists;
    }
    my Str:D $sql-select = qq!SELECT pp.id, pp._perms, pd.username, g._name, pp.userid, pp.groupid, pp.full_name, pp.pattern, pp.status FROM pseudo_pages pp JOIN passwd pd ON pd.id = pp.userid JOIN _group g ON g.id = pp.groupid WHERE pp.name = ?!;
    my $select           = $dbh.prepare($sql-select);
    my Str:D $sql        = qq!UPDATE pseudo_pages SET _perms = ? WHERE id = ?!;
    my $update           = $dbh.prepare($sql);
    my Int $width = terminal-width;
    $width = $width // 80;
    my Int:D $w0 = 0;
    my Int:D $w1 = 0;
    my Int:D $w2 = wcswidth('username');
    my Int:D $w3 = wcswidth('group_name');
    my Int:D $w4 = wcswidth('pattern');
    my Int:D $w5 = wcswidth('status');
    my Int:D $w  = 0;
    if $verbose {
        ################################################################
        #                                                              #
        #           Only do these Calculations if we NEED TO           #
        #                                                              #
        ################################################################
        for @page-names -> $name {
            my $msg = "you lack the permissions to modify page: $name";
            $w0                   = max($w0,  wcswidth($msg));
            my $res               = $select.execute($name);
            my %values            = $res.row(:hash);
            my IdType $id         = %values«id»;
            my IdType $userid     = %values«userid»;
            my IdType $groupid    = %values«groupid»;
            my Str:D  $full-name  = %values«full_name»;
            my Str:D  $pattern    = %values«pattern»;
            my Str:D  $status     = %values«status»;
            my Str:D  $username   = %values«username»;
            my Str:D  $group_name = %values«_name»;
            $w0                   = max($w0,  wcswidth("|$name|"), wcswidth($msg));
            $w1                   = max($w1,  wcswidth($full-name));
            $w2                   = max($w2,  wcswidth($username));
            $w3                   = max($w3,  wcswidth($group_name));
            $w4                   = max($w4,  wcswidth($pattern));
            $w5                   = max($w5,  wcswidth($status));
        } # for @page-names -> $name #
        $w0 += 2; # padding #
        $w1 += 2;
        $w2 += 2;
        $w3 += 2;
        $w4 += 2;
        $w5 += 2;
        $w   = min($w0 + $w1 + $w2 + $w3 + $w4 + $w5 + 32,  $width);
    } # if $verbose #
    my Int:D $cnt = 0;
    ######################################################################
    #                                                                    #
    #                               Heading                              #
    #                                                                    #
    ######################################################################
    if $verbose {
        put (($cnt % 2 == 0) ?? t.bg-yellow !! t.bg-color(0,255,0)) ~ t.bold ~ t.bright-blue ~ sprintf("%-*s%-*s%-*s%-*s%-*s%-*s%18s%14s", $w0, 'page_name', $w1, 'full_name', $w2, 'username', $w3, 'group_name', $w4, 'pattern', $w5, 'status', trailing-dots('    perms', 18, ' '), 'status') ~ t.text-reset;
        $cnt++;
        # put a horazontal line in #
        put (($cnt % 2 == 0) ?? t.bg-yellow !! t.bg-color(0,255,0)) ~ t.bold ~ t.bright-blue ~ ('=' x $w) ~ t.text-reset;
        $cnt++;
    }
    #####################################################################
    #                                                                   #
    #         Do the  actaul work ouputing progress if $verbose         #
    #                                                                   #
    #####################################################################
    for @page-names -> $name {
        my $res               = $select.execute($name);
        my %values            = $res.row(:hash);
        my IdType $id         = %values«id»;
        my IdType $userid     = %values«userid»;
        my IdType $groupid    = %values«groupid»;
        my Str:D  $_old-perms = %values«_perms»;
        my Str:D  $full-name  = %values«full_name»;
        my Str:D  $username   = %values«username»;
        my Str:D  $group_name = %values«_name»;
        my Str:D  $pattern    = %values«pattern»;
        my Str:D  $status     = %values«status»;
        my        %old-perms  = GPerms.parse($_old-perms, actions => Perms.new).made;
        ####################################################################
        #                                                                  #
        #           insure you have the rights to do this at all           #
        #                                                                  #
        ####################################################################
        unless $_admin || $userid == $loggedin_id {
            my $msg = "you lack the permissions to modify pseudo page: $name";
            my Str:D $perms-str = perms-to-str(%old-perms);
            my Str:D $ok = 'Failed';
            put (($cnt % 2 == 0) ?? t.bg-yellow !! t.bg-color(0,255,0)) ~ t.bold ~ t.bright-blue ~ sprintf("%-*s%-*s%-*s%-*s%18s%10s", $w0, $msg, $w1, $full-name, $w2, $username, $w3, $group_name, $w4, $pattern, $w5,  $status, centre($perms-str, 18, ' '), lead-dots($ok, 14, ' ')) ~ t.text-reset;
            $cnt++;
            next;
        }
        my Str:D  $user_     = set-perms($user,  %old-perms«user»);
        my Str:D  $group_    = set-perms($group, %old-perms«group»);
        my Str:D  $other_    = set-perms($other, %old-perms«other»);
        my Str:D  $new-perms = qq[("$user_","$group_","$other_")];
        my Bool:D $r         = so $update.execute($new-perms, $id);
        if $verbose {
            my       %vals-perms = GPerms.parse($new-perms, actions => Perms.new).made;
            my Str:D $perms-str  = perms-to-str(%vals-perms);
            my Str:D $ok = ($r ?? 'OK' !! 'Failed');
            put (($cnt % 2 == 0) ?? t.bg-yellow !! t.bg-color(0,255,0)) ~ t.bold ~ t.bright-blue ~ sprintf("%-*s%-*s%-*s%-*s%-*s%-*s%18s%10s", $w0, $name, $w1, $full-name, $w2, $username, $w3, $group_name, $w4, $pattern, $w5,  $status, centre($perms-str, 18, ' '), lead-dots($ok, 14, ' ')) ~ t.text-reset;
            $cnt++;
        }
        $result &&= $r;
    } # for @page-names -> $name #
    if $verbose {
        put (($cnt % 2 == 0) ?? t.bg-yellow !! t.bg-color(0,255,0)) ~ t.bold ~ t.bright-blue ~ (' ' x $w) ~ t.text-reset;
        $cnt++;
    }
    return $result;
} # sub chmod-pseudo-page(Bool:D $verbose, %perms, @page-names --> Bool:D) is export #

sub list-pseudo-page-perms(Bool:D $show-id, Bool:D $full, Regex:D $pattern --> Bool:D) is export {
    my Bool:D $result = True;
    my Bool:D $loggedin                  = so %session«loggedin»;
    my Int    $loggedin_id               =    ((%session«loggedin_id»               === Any) ?? Int   !! %session«loggedin_id» );
    my Str    $loggedin_username         =    ((%session«loggedin_username»         === Any) ?? Str   !! %session«loggedin_username» );
    my Bool:D $_admin                    = so %session«loggedin_admin»;
    my Str    $display_name              =    ((%session«loggedin_display_name»     === Any) ?? Str   !! %session«loggedin_display_name» );
    my Str    $given                     =    ((%session«loggedin_given»            === Any) ?? Str   !! %session«loggedin_given» );
    my Str    $family                    =    ((%session«loggedin_family»           === Any) ?? Str   !! %session«loggedin_family» );
    my Str    $loggedin_email            =    ((%session«loggedin_email»            === Any) ?? Str   !! %session«loggedin_email» );
    my Str    $phone_number              =    ((%session«loggedin_phone_number»     === Any) ?? Str   !! %session«loggedin_phone_number» );
    my Str    $groupname                 =    ((%session«loggedin_groupname»        === Any) ?? Str   !! %session«loggedin_groupname» );
    my Int    $primary_group_id          =    ((%session«loggedin_groupnname_id»    === Any) ?? Int   !! %session«loggedin_groupnname_id» );
    my Str    $loggedin_prefix           =    ((%session«loggedin_prefix»           === Any) ?? Str   !! %session«loggedin_prefix» );
    my Str    $loggedin_escape           =    ((%session«loggedin_escape»           === Any) ?? Str   !! %session«loggedin_escape» );
    my Str    $loggedin_punct            =    ((%session«loggedin_punct»            === Any) ?? Str   !! %session«loggedin_punct» );
    my Regex  $loggedin_landline_pattern =    ((%session«loggedin_landline_pattern» === Any) ?? Regex !! %session«loggedin_landline_pattern» );
    my Regex  $loggedin_mobile_pattern   =    ((%session«loggedin_mobile_pattern»   === Any) ?? Regex !! %session«loggedin_mobile_pattern» );
    unless $loggedin {
        say "You must be loggedin to use this function: {&*ROUTINE.name}";
        return False;
    }
    my Int $width = terminal-width;
    $width = $width // 80;
    my Str:D $sql-select = qq{SELECT pp.id, pp._perms, pd.username, g._name, pp.name, pp.full_name, pp.pattern, pp.status FROM pseudo_pages pp JOIN passwd pd ON pd.id = pp.userid JOIN _group g ON g.id = pp.groupid ORDER BY LOWER(pp.name), pp, name, LOWER(pp.full_name), pp.full_name};
    my $select           = $dbh.prepare($sql-select);
    my $res   = $select.execute();
    my @pages = $res.allrows(:array-of-hash);
    my Int:D $w  = 0;
    my Int:D $w0 = wcswidth('username');
    my Int:D $w1 = wcswidth('group_name');
    my Int:D $w2 = 0;
    my Int:D $w3 = 0;
    my Int:D $w4 = wcswidth('pattern');
    my Int:D $w5 = wcswidth('status');
    for @pages -> %values {
        my IdType $id         = %values«id»;
        my Str:D  $name       = %values«name»;
        my Str:D  $full-name  = %values«full_name»;
        my Str:D  $username   = %values«username»;
        my Str:D  $group_name = %values«_name»;
        my Str:D  $pp_pattern = %values«pattern»;
        my Str:D  $status     = %values«status»;
        next unless $name ~~ $pattern || $full-name ~~ $pattern;
        my Str:D  $_perms     = %values«_perms»;
        my %perms = GPerms.parse($_perms, actions => Perms.new).made;
        my Str:D $perms = perms-to-str(%perms);
        $w0 = max($w0,  wcswidth($username));
        $w1 = max($w1,  wcswidth($group_name));
        $w2 = max($w2,  wcswidth($name));
        $w3 = max($w3, wcswidth($full-name));
        $w4 = max($w4, wcswidth($pp_pattern), );
        $w5 = max($w5, wcswidth($status), );
    }
    $w0 += 2;
    $w1 += 2;
    $w2 += 2;
    $w3 += 2;
    $w4 += 2;
    $w5 += 2;
    $w   = min($w0 + $w1 + $w2 + $w3 + $w4 + $w5 + 28, $width);
    my Int:D $num = $width div $w0;
    $num = 1 if $num < 1;
    my Int:D $cols = 0;
    my Str:D $line = '';
    my Int $cnt = 0;
    @pages                  = |@pages.sort: { my %u = %($^a); my %v = %($^b);  my $res = %u«name».lc.trim cmp %v«name».lc.trim; (($res == Same) ?? (%u«full_name».lc.trim cmp %v«full_name».lc.trim) !! $res ) };
    if $show-id && $full {
        put (($cnt % 2 == 0) ?? t.bg-yellow !! t.bg-color(0,255,0)) ~ t.bold ~ t.bright-blue ~ sprintf("%-10s%18s    %-*s%-*s%-*s%-*s%-*s%-*s", 'id', trailing-dots('    perms', 18, ' '), $w0, 'username', $w1, 'group_name', $w2, 'name', $w3, 'full-name', $w4, 'pattern', $w5, 'status') ~ t.text-reset;
        $cnt++;
        put (($cnt % 2 == 0) ?? t.bg-yellow !! t.bg-color(0,255,0)) ~ t.bold ~ t.bright-blue ~ ('=' x ($w + 4)) ~ t.text-reset;
        $cnt++;
    } elsif $full {
        put (($cnt % 2 == 0) ?? t.bg-yellow !! t.bg-color(0,255,0)) ~ t.bold ~ t.bright-blue ~ sprintf("%-18s%-*s%-*s%-*s%-*s%-*s%-*s", trailing-dots('perms', 18, ' '), $w0, 'username', $w1, 'group_name', $w2, 'name', $w3, 'full-name', $w4, 'pattern', $w5, 'status') ~ t.text-reset;
        $cnt++;
        put (($cnt % 2 == 0) ?? t.bg-yellow !! t.bg-color(0,255,0)) ~ t.bold ~ t.bright-blue ~ ('=' x ($w - 10)) ~ t.text-reset;
        $cnt++;
    }
    for @pages -> %values {
        my IdType $id       = %values«id»;
        my Str:D  $name      = %values«name»;
        my Str:D  $full-name = %values«full_name»;
        my Str:D  $username   = %values«username»;
        my Str:D  $group_name = %values«_name»;
        next unless $name ~~ $pattern || $full-name ~~ $pattern;
        my Str:D  $pp_pattern = %values«pattern»;
        my Str:D  $status     = %values«status»;
        my Str:D  $_perms    = %values«_perms»;
        my %perms = GPerms.parse($_perms, actions => Perms.new).made;
        my Str:D  $perms = perms-to-str(%perms);
        if $show-id && $full {
            put (($cnt % 2 == 0) ?? t.bg-yellow !! t.bg-color(0,255,0)) ~ t.bold ~ t.bright-blue ~ sprintf("%-10d%18s    %-*s%-*s%-*s%-*s%-*s%-*s", $id, centre($perms, 18, ' '), $w0, $username, $w1, $group_name, $w2, $name, $w3, $full-name, $w4, $pp_pattern, $w5, $status) ~ t.text-reset;
            $cnt++;
        } elsif $full {
            put (($cnt % 2 == 0) ?? t.bg-yellow !! t.bg-color(0,255,0)) ~ t.bold ~ t.bright-blue ~ sprintf("%-18s%-*s%-*s%-*s%-*s%-*s%-*s", trailing-dots($perms, 18, ' '), $w0, $username, $w1, $group_name, $w2, $name, $w3, $full-name, $w4, $pp_pattern, $w5, $status) ~ t.text-reset;
            $cnt++;
        } elsif $cols >= $num {
            put (($cnt % 2 == 0) ?? t.bg-yellow !! t.bg-color(0,255,0)) ~ t.bold ~ t.bright-blue ~ $line ~ t.text-reset;
            $cnt++;
            $line = '';
            $cols = 0;
        } else {
            $line ~= sprintf "%-*s", $w0, $name;
            $cols++;
        }
    }
    if $line ne '' {
        put (($cnt % 2 == 0) ?? t.bg-yellow !! t.bg-color(0,255,0)) ~ t.bold ~ t.bright-blue ~ $line ~ t.text-reset;
        $cnt++;
        $line = '';
        $cols = 0;
    }
    if $show-id && $full {
        put (($cnt % 2 == 0) ?? t.bg-yellow !! t.bg-color(0,255,0)) ~ t.bold ~ t.bright-blue ~ ' ' x ($w + 4) ~ t.text-reset;
    } elsif $full {
        put (($cnt % 2 == 0) ?? t.bg-yellow !! t.bg-color(0,255,0)) ~ t.bold ~ t.bright-blue ~ ' ' x ($w - 10) ~ t.text-reset;
    }
    $cnt++;
    return $result;
} # sub list-pseudo-page-perms(Bool:D $show-id, Bool:D $full, Regex:D $pattern --> Bool:D) is export #

sub chown-pseudo-page($verbose, $user, $userid, $group, $groupid, @page-names) is export {
    my Bool:D $result = True;
    my Bool:D $loggedin                  = so %session«loggedin»;
    my Int    $loggedin_id               =    ((%session«loggedin_id»               === Any) ?? Int   !! %session«loggedin_id» );
    my Str    $loggedin_username         =    ((%session«loggedin_username»         === Any) ?? Str   !! %session«loggedin_username» );
    my Bool:D $_admin                    = so %session«loggedin_admin»;
    my Str    $display_name              =    ((%session«loggedin_display_name»     === Any) ?? Str   !! %session«loggedin_display_name» );
    my Str    $given                     =    ((%session«loggedin_given»            === Any) ?? Str   !! %session«loggedin_given» );
    my Str    $family                    =    ((%session«loggedin_family»           === Any) ?? Str   !! %session«loggedin_family» );
    my Str    $loggedin_email            =    ((%session«loggedin_email»            === Any) ?? Str   !! %session«loggedin_email» );
    my Str    $phone_number              =    ((%session«loggedin_phone_number»     === Any) ?? Str   !! %session«loggedin_phone_number» );
    my Str    $groupname                 =    ((%session«loggedin_groupname»        === Any) ?? Str   !! %session«loggedin_groupname» );
    my Int    $primary_group_id          =    ((%session«loggedin_groupnname_id»    === Any) ?? Int   !! %session«loggedin_groupnname_id» );
    my Str    $loggedin_prefix           =    ((%session«loggedin_prefix»           === Any) ?? Str   !! %session«loggedin_prefix» );
    my Str    $loggedin_escape           =    ((%session«loggedin_escape»           === Any) ?? Str   !! %session«loggedin_escape» );
    my Str    $loggedin_punct            =    ((%session«loggedin_punct»            === Any) ?? Str   !! %session«loggedin_punct» );
    my Regex  $loggedin_landline_pattern =    ((%session«loggedin_landline_pattern» === Any) ?? Regex !! %session«loggedin_landline_pattern» );
    my Regex  $loggedin_mobile_pattern   =    ((%session«loggedin_mobile_pattern»   === Any) ?? Regex !! %session«loggedin_mobile_pattern» );
    #######################################################
    #                                                     #
    #           Only loggedin users may do this           #
    #                                                     #
    #######################################################
    unless $loggedin {
        say "You must be loggedin to use this function: {&*ROUTINE.name}";
        return False;
    }
    ######################################################################
    #                                                                    #
    #           You must be an admin user to use this function           #
    #                                                                    #
    ######################################################################
    unless $_admin {
        say "You must be an admin to use this function: {&*ROUTINE.name}";
        return False;
    }
    my Str:D $sql-select  = qq!SELECT pp.id, pd.username, pp.userid, g._name, pp.groupid, pp.full_name FROM pseudo_pages pp JOIN passwd pd ON pp.userid = pd.id JOIN _group g ON pp.groupid = g.id WHERE pp.name = ?!;
    my $select            = $dbh.prepare($sql-select);
    my Str:D $sql         = qq!UPDATE pseudo_pages SET userid = ?, groupid = ? WHERE id = ?!;
    my $update            = $dbh.prepare($sql);
    my Str:D $sel-sect    = qq!SELECT ps.id, pd.username, ps.userid, g._name, ps.groupid, ps.links_section_id FROM page_section ps JOIN passwd pd ON ps.userid = pd.id JOIN _group g ON ps.groupid = g.id WHERE ps.pages_id = ? AND (? = true OR ps.userid = ?)!;
    my $select-sect       = $dbh.prepare($sel-sect);
    my Str:D $sql-sect    = qq!UPDATE page_section SET userid = ?, groupid = ? WHERE id = ?!;
    my $update-sect       = $dbh.prepare($sql-sect);
    my Str:D $sel-ls      = qq!SELECT ls.id, pd.username, ls.userid, g._name, ls.groupid, ls.section FROM links_sections ls JOIN passwd pd ON ls.userid = pd.id JOIN _group g ON ls.groupid = g.id WHERE ls.id = ? AND (? = true OR ls.userid = ?)!;
    my $select-ls         = $dbh.prepare($sel-ls);
    my Str:D $sql-ls      = qq!UPDATE links_sections SET userid = ?, groupid = ? WHERE id = ?!;
    my $update-ls         = $dbh.prepare($sql-ls);
    my Str:D $sel-links   = qq!SELECT l.id, pd.username, l.userid, g._name, l.groupid, l.name, l.link FROM links l JOIN passwd pd ON l.userid = pd.id JOIN _group g ON l.groupid = g.id WHERE l.section_id = ? AND (? = true OR l.userid = ?)!;
    my $select-links      = $dbh.prepare($sel-links);
    my Str:D $sql-links   = qq!UPDATE links SET userid = ?, groupid = ? WHERE id = ?!;
    my $update-links      = $dbh.prepare($sql-links);
    my Int $width         = terminal-width;
    $width = $width // 80;
    my Int:D $w  = 0;
    if $verbose {
        ################################################################
        #                                                              #
        #           Only do these Calculations if we NEED TO           #
        #                                                              #
        ################################################################
        my Str:D    $user-to    = '';
        my IdType:D $userid-to  = 0;
        my Str:D    $group-to   = '';
        my IdType:D $groupid-to = 0;
        for @page-names -> $name {
            my $res                  = $select.execute($name);
            my %values               = $res.row(:hash);
            my IdType:D $id          = %values«id»;
            my Str:D    $old-user    = %values«username»;
            my IdType:D $old-userid  = %values«userid»;
            my Str:D    $old-group   = %values«_name»;
            my IdType:D $old-groupid = %values«groupid»;
            my Str:D    $full-name   = %values«full_name»;
            ($user-to,  $userid-to, $group-to, $groupid-to) = get-user-group-and-ids($user, $userid, $group, $groupid, $old-userid, $old-groupid);
            my Str:D    $msg0         = qq[changed user of $name ($full-name) from $old-user to $user-to];
            my Str:D    $msg1         = qq[changed group of $name ($full-name) from $old-group to $group-to];
            my Str:D    $msg2         = qq[changed user and group of $name ($full-name) from $old-user:$old-group to $user-to:$group-to];
            my Str:D    $msg3         = qq[retained user and group of $name ($full-name) as $old-user:$old-group];
            my Str:D    $msg4         = qq[Error: could not change user and group of $name ($full-name) to $old-user:$old-group];
            $w                        = max($w,  wcswidth($msg0), wcswidth($msg1), wcswidth($msg2), wcswidth($msg3), wcswidth($msg4));
        } # for @page-names -> $name #
        $w  += 2;
        $w   = min($w,  $width);
    } # if $verbose #
    my Int:D $cnt = 0;
    #####################################################################
    #                                                                   #
    #         Do the  actaul work ouputing progress if $verbose         #
    #                                                                   #
    #####################################################################
    for @page-names -> $name {
        my Str:D    $user-to    = '';
        my IdType:D $userid-to  = 0;
        my Str:D    $group-to   = '';
        my IdType:D $groupid-to = 0;
        my $res                    = $select.execute($name);
        my %values                 = $res.row(:hash);
        my IdType:D $id            = %values«id»;
        my IdType:D $old-userid    = %values«userid»;
        my Str:D    $old-user      = %values«username»;
        my IdType:D $old-groupid   = %values«groupid»;
        my Str:D    $old-group     = %values«_name»;
        my Str:D    $full-name     = %values«full_name»;
        ($user-to,  $userid-to, $group-to, $groupid-to) = get-user-group-and-ids($user, $userid, $group, $groupid, $old-userid, $old-groupid);
        my Bool:D $r               = so $update.execute($userid-to, $groupid-to, $id);
        if $verbose {
            my Str:D $msg = '';
            if $r {
                if $old-user eq $user-to && $old-group ne $group-to {
                    $msg        = qq[changed group of $name ($full-name) from $old-group to $group-to];
                } elsif $old-user ne $user-to && $old-group eq $group-to {
                    $msg        = qq[changed user of $name ($full-name) from $old-user to $user-to];
                } elsif $old-user ne $user-to && $old-group ne $group-to {
                    $msg        = qq[changed user and group of $name ($full-name) from $old-user:$old-group to $user-to:$group-to];
                } else {
                    $msg        = qq[retained user and group of $name ($full-name) as $old-user:$old-group];
                }
            } else  {
                $msg            = qq[Error: could not change user and group of $name ($full-name) to $old-user:$old-group];
            }
            my Str:D $ok = ($r ?? 'OK' !! 'Failed');
            put (($cnt % 2 == 0) ?? t.bg-yellow !! t.bg-color(0,255,0)) ~ t.bold ~ t.bright-blue ~ sprintf("%-*s", $w, $msg) ~ t.text-reset;
            $cnt++;
        }
        $result &&= $r;
    } # for @page-names -> $name #
    if $verbose {
        put (($cnt % 2 == 0) ?? t.bg-yellow !! t.bg-color(0,255,0)) ~ t.bold ~ t.bright-blue ~ sprintf("%-*s", $w, '') ~ t.text-reset;
        $cnt++;
    }
    return $result;
} # sub chown-pseudo-page($verbose, $user, $userid, $group, $groupid, @page-names) is export #

END {
    %session.save;
    $db.disconnect;
    $dbh.dispose;
}
