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
use GzzPrompt;

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

my $id = %ini«login_details»«id» if (%ini«login_details»:exists) && (%ini«login_details»«id»:exists); 

#my %session := Session::Postgres.new($id, { dbname => $database, dbserver => 'rakbat.local', dbuser => $dbuser, dbport => 5432, dbpasswd => get-password($dbuser), });
my %session := Session::Postgres.new($id, { Handle => $db, });

$id = $id // %session.id;

if !((%ini«login_details»:exists) && (%ini«login_details»«id»:exists)) {
    %ini«login_details»«id» = $id;
    Config::INI::Writer::dumpfile(%ini, "$config/settings.ini");
}

sub list-links(Str $prefix --> Bool) is export {
    my $sth = $dbh.execute('SELECT * FROM vlinks ORDER BY section, name;');
    my @values = $sth.allrows(:array-of-hash);
    my $last_section;
    my $section = '';
    for @values -> %row {
        $last_section = $section;
        $section = %row«section»;
        next unless $section.starts-with($prefix);
        if $section ne $last_section {
            "\n[$section]".say
        }
        my $name    = %row«name»;
        my $link    = %row«link»;
        printf("    %-10s = %s\n", $name, $link);
    }
    return True;
}

sub section-exists(Str $section --> Bool) is export {
    my $sth = $dbh.execute('SELECT COUNT(*) n FROM sections WHERE section = ?', $section);
    my %values = $sth.row(:hash);
    my $n = %values«n»;
    return False if $n == 0;
    return True;
}

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

sub list-aliases(Str $prefix --> Bool) is export {
    my $sth = $dbh.execute('SELECT a.name, a.section "target" FROM aliases a;');
    my @values = $sth.allrows(:array-of-hash);
    my $last_name;
    my $name = '';
    for @values -> %row {
        $last_name = $name;
        $name = %row«name»;
        next unless $name.starts-with($prefix);
        if $name ne $last_name {
            "\n[$name]".say
        }
        my $target    = %row«target»;
        printf("    %-10s = %s\n", 'alias', $target);
    }
    return True;
}

sub in-a-page(Str $section --> Bool) {
    my $sth = $dbh.execute('SELECT COUNT(*) n FROM page_view pv WHERE pv.section = ?;', $section);
    my %values = $sth.row(:hash);
    my $n = %values«n»;
    return False if $n == 0;
    return True;
}

sub list-pages(Str $page-name, Str $prefix --> Bool) is export {
    my $sth0 = $dbh.execute('SELECT * FROM page_link_view ORDER BY page_name, full_name, section, name, link;');
    my @values = $sth0.allrows(:array-of-hash);
    my $last_page_name = '';
    my $page_name      = '';
    my $last_section   = '';
    my $section        = '';
    for @values -> %row {
        $page_name = %row«page_name»;
        next unless $page_name.starts-with($page-name);
        $section      = %row«section»;
        next unless $section.starts-with($prefix);
        if $page_name ne $last_page_name {
            "\n«|$page_name|»".say;
            "    [$section]".say;
        }elsif $section ne $last_section {
            "\n    [$section]".say;
        }
        my $name    = %row«name»;
        my $link    = %row«link»;
        printf("        %-10s = %s\n", $name, $link);
        $last_section   = $section;
        $last_page_name = $page_name;
    }
    my $sql = "SELECT pp.name \"page_name\", ls.section, l.name, l.link, pp.status FROM pseudo_pages pp JOIN links_sections ls ON ls.section ~* pp.pattern JOIN links l ON l.section_id = ls.id\n";
    $sql   ~= "ORDER BY pp.name, ls.section, l.name, l.link";
    my $sth1 = $dbh.execute($sql);
    my @values1 = $sth1.allrows(:array-of-hash);
    $last_page_name = '';
    $page_name      = '';
    $last_section   = '';
    $section        = '';
    for @values1 -> %row {
        $page_name = %row«page_name»;
        my $status = %row«status»;
        next unless $page_name.starts-with($page-name);
        $section      = %row«section»;
        next unless $section.starts-with($prefix);
        return False if $status eq Status::invalid;
        next if $status eq Status::unassigned && in-a-page($section);
        next if $status eq Status::assigned   && !in-a-page($section);
        if $page_name ne $last_page_name {
            "\n«|$page_name|»".say;
            "    [$section]".say;
        }elsif $section ne $last_section {
            "\n    [$section]".say;
        }
        my $name    = %row«name»;
        my $link    = %row«link»;
        printf("    %-10s = %s\n", $name, $link);
        $last_section   = $section;
        $last_page_name = $page_name;
    }
    return True;
}

sub add-page(Str $page, Str $name, @links --> Bool) is  export {
    my $sth = $dbh.execute('SELECT COUNT(*) n FROM pages WHERE name = ?', $page);
    my %_values = $sth.row(:hash);
    my $n = %_values«n»;
    if $n == 0 {
        $dbh.execute('INSERT INTO pages(name, full_name) VALUES(?, ?)', $page, $name);
    }
    my $sth0 = $dbh.execute('SELECT id FROM pages WHERE name = ?', $page);
    my %values = $sth0.row(:hash);
    my $pages_id = %values«id»;
    my $sth3 = $dbh.prepare('INSERT INTO page_section(pages_id, links_section_id) VALUES (?, ?)');
    for @links -> $link {
        my $sth1 = $dbh.execute('SELECT id FROM links_sections WHERE section = ?', $link);
        my %val = $sth1.row(:hash);
        next unless %val;
        my $links_section_id = %val«id»;
        $sth3.execute($pages_id, $links_section_id);
    }
}

sub add-links(Str $link-section, %links --> Bool) is export {
    die "link-section must have a value." if $link-section ~~ rx/^ \s+ $/;
    my $sth0 = $dbh.execute('SELECT count(*) n FROM links_sections WHERE section = ?', $link-section);
    my %val = $sth0.row(:hash);
    my $n = %val«n»;
    if $n == 0 {
        $dbh.execute('INSERT INTO links_sections(section) VALUES(?)', $link-section);
    }
    my $sth1 = $dbh.execute('SELECT id FROM links_sections WHERE section = ?', $link-section);
    my %values = $sth1.row(:hash);
    my $id = %values«id»;
    my $sth = $dbh.prepare('INSERT INTO links(section_id, name, link) VALUES (?, ?, ?)');
    for %links.kv -> $key, $val {
        $sth.execute($id, $key, $val);
    }
    return True;
}

sub add-alias(Str $alias-name, Str $link-section is copy --> Bool) is export {
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
    $dbh.execute('INSERT INTO alias(name, target) VALUES(?, ?)', $alias-name, $target);
    return True;
}

sub delete-links(Str $link-section, Bool $remove-section, @links --> Bool) is export {
    die "link-section must have a value." if $link-section ~~ rx/^ \s+ $/;
    my $sth0 = $dbh.execute('SELECT id FROM links_sections WHERE section = ?', $link-section);
    my %val = $sth0.row(:hash);
    die "Error: links_sections: $link-section does not exist" unless %val;
    my $id = %val«id»;
    my $sth = $dbh.prepare("DELETE FROM links WHERE section_id = ? AND name = ?;");
    for @links -> $link {
        $sth.execute($id, $link);
    }
    if $remove-section {
        my $sth1 = $dbh.execute('SELECT COUNT(*) n FROM links WHERE section_id = ?', $id);
        my %value = $sth1.row(:hash);
        my $n = %value«n»;
        if $n == 0 {
            $dbh.execute("DELETE FROM links_sections WHERE id = ?;", $id);
        } else {
            "Warning: $link-section still contains links not deleting section.".say;
        }
    }
    return True;
}

sub delete-page(Str $page-name --> Bool) is export {
    die "link-section must have a value." if $page-name ~~ rx/^ \s+ $/;
    my $sth0 = $dbh.execute('SELECT id FROM pages WHERE name = ?', $page-name);
    my %val = $sth0.row(:hash);
    die "Error: page-name: $page-name does not exist" unless %val;
    my $pages_id = %val«id»;
    $dbh.execute("DELETE FROM page_section WHERE pages_id = ?;", $pages_id);
    $dbh.execute("DELETE FROM pages WHERE id = ?;", $pages_id);
    return True;
}

sub delete-pseudo-page(Str $page-name --> Bool) is export {
    die "link-section must have a value." if $page-name ~~ rx/^ \s+ $/;
    $dbh.execute("DELETE FROM pseudo_pages WHERE name = ?;", $page-name);
    return True;
}

sub add-pseudo-pages(Str $page, Status $status is copy, Str $full-name, Str $pattern --> Bool) is export {
    die "Error: pages is an system section." if $page eq 'pages';
    my $sth0 = $dbh.execute('SELECT COUNT(*) n FROM pages WHERE name = ?', $page);
    my %val = $sth0.row(:hash);
    my $n = %val«n»;
    $status = Status::unassigned if $status == Status::invalid;
    if $n == 0 {
        $dbh.execute('INSERT INTO pseudo_pages(name, full_name, pattern, status) VALUES(?, ?, ?, ?)', $page, $full-name, $pattern, $status);
    } else {
        $dbh.execute('UPDATE pseudo_pages SET name = ?, full_name = ?, pattern = ?, status = ? WHERE name = ?', $page, $full-name, $pattern, $status, $page);
    }
    return True;
}

sub launch-link(Str $section, Str $link --> Bool) is export {
    my $sth = $dbh.execute('SELECT link FROM alias_union_links WHERE alias_name = ? AND name = ?;', $section, $link);
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
}

sub generate-hash(Str:D $password --> Str) is export {
    my $pbkdf2 = Crypt::PBKDF2.new( 
            hash_class => 'HMACSHA2', 
            hash_args => {sha_size => 512},
            iterations => 2048,
            output_len => 64,
            salt_len => 16,
            length_limit => 144
        );
    return $pbkdf2.generate($password);
} # sub generate-hash(Str:D $password --> Str) is export #

sub validate(Str:D $hashed-password, Str:D $password --> Bool) is export {
    my $pbkdf2 = Crypt::PBKDF2.new( 
            hash_class => 'HMACSHA2', 
            hash_args => {sha_size => 512},
            iterations => 2048,
            output_len => 64,
            salt_len => 16,
            length_limit => 144
        );
    my Bool $result = False;
    try {
        CATCH {
            default {
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
    my $sql               = "SELECT p.id, p.username, p._password, p.primary_group_id, p._admin, pd.display_name, pd.given, pd._family,\n";
    $sql                 ~= "e._email, ph._number phone_number, g._name groupname, g.id group_id\n";
    $sql                 ~= "FROM passwd p JOIN passwd_details pd ON p.passwd_details_id = pd.id JOIN email e ON p.email_id = e.id\n";
    $sql                 ~= "         LEFT JOIN phone  ph ON ph.id = pd.primary_phone_id JOIN _group g ON p.primary_group_id = g.id\n";
    $sql                 ~= "WHERE p.username = ?\n";
    my $sth               = $dbh.execute($sql, $username);
    my %val               = $sth.row(:hash);
    my $loggedin_id       = %val«id»;
    my $loggedin_username = %val«username»;
    my $primary_group_id  = %val«group_id»;
    my $hashed-password   = %val«_password»;
    my $_admin            =  so %val«_admin»;
    my $display_name      = %val«display_name»;
    my $given             = %val«given»;
    my $family            = %val«_family»;
    my $email             = %val«_email»;
    my $phone_number      = %val«phone_number»;
    my $groupname         = %val«groupname»;
    my Int:D $cnt = 0;
    while !validate($hashed-password, $passwd) && $cnt < 4 {
        $passwd = getpass "password > ";
        $cnt++;
    }
    if $cnt >= 4 {
        say "too many retrys bailing";
        return False;
    }
    if validate($hashed-password, $passwd) {
        %session«loggedin»               = $loggedin_id;
        %session«loggedin_id»            = $loggedin_id;
        %session«loggedin_username»      = $loggedin_username;
        %session«loggedin_admin»         = $_admin;
        %session«loggedin_display_name»  = $display_name;
        %session«loggedin_given»         = $given;
        %session«loggedin_family»        = $family;
        %session«loggedin_email»         = $email;
        %session«loggedin_phone_number»  = $phone_number;
        %session«loggedin_groupname»     = $groupname;
        %session«loggedin_groupnname_id» = $primary_group_id;
        %session.save;
        return True;
    }
    return False;
} # sub login(Str:D $username where { $username ~~ rx/^ \w+ $/}, Str:D $passwd --> Bool) is export #

sub logout(Bool:D $sure is copy --> Bool) is export {
    my Bool:D $tmp = False;
    if !$sure {
        $sure = ask 'are you sure you realy want to logout y/N > ', 'N', :type(Bool);
    }
    if $sure {
        %session«loggedin»               = False;
        %session«loggedin_id»            = 0;
        %session«loggedin_username»      = Nil;
        %session«loggedin_admin»         = False;
        %session«loggedin_display_name»  = Nil;
        %session«loggedin_given»         = Nil;
        %session«loggedin_family»        = Nil;
        %session«loggedin_email»         = Nil;
        %session«loggedin_phone_number»  = Nil;
        %session«loggedin_groupname»     = Nil;
        %session«loggedin_groupnname_id» = 0;
        %session.save;
        return True;
    }
    return False;
} # sub logout(Bool:D $sure is copy --> Bool) is export #

sub whoami( --> Bool) is export {
    my Bool:D $loggedin          = so %session«loggedin»;
    my Int    $loggedin_id       =    ((%session«loggedin_id» === Any) ?? Int !! %session«loggedin_id» );
    my Str    $loggedin_username =    ((%session«loggedin_username» === Any) ?? Str !! %session«loggedin_username» );
    my Bool:D $_admin            = so %session«loggedin_admin»;
    my Str    $display_name      =    ((%session«loggedin_display_name» === Any) ?? Str !! %session«loggedin_display_name» );
    my Str    $given             =    ((%session«loggedin_given» === Any) ?? Str !! %session«loggedin_given» );
    my Str    $family            =    ((%session«loggedin_family» === Any) ?? Str !! %session«loggedin_family» );
    my Str    $loggedin_email    =    ((%session«loggedin_email» === Any) ?? Str !! %session«loggedin_email» );
    my Str    $phone_number      =    ((%session«loggedin_phone_number» === Any) ?? Str !! %session«loggedin_phone_number» );
    my Str    $groupname         =    ((%session«loggedin_groupname» === Any) ?? Str !! %session«loggedin_groupname» );
    my Int    $primary_group_id  =    ((%session«loggedin_groupnname_id» === Any) ?? Int !! %session«loggedin_groupnname_id» );
    my Int $cnt = 0;
    put (($cnt % 2 == 0) ?? t.bg-color(255,0,0) !! t.bg-color(0,255,0)) ~ t.bold ~ t.bright-blue ~ sprintf("%-40s: %-40s", trailing-dots('loggedin', 40),          $loggedin) ~ t.text-reset;
    $cnt++;
    put (($cnt % 2 == 0) ?? t.bg-color(255,0,0) !! t.bg-color(0,255,0)) ~ t.bold ~ t.bright-blue ~ sprintf("%-40s: %-40s", trailing-dots('loggedin_id', 40),       $loggedin_id) ~ t.text-reset;
    $cnt++;
    put (($cnt % 2 == 0) ?? t.bg-color(255,0,0) !! t.bg-color(0,255,0)) ~ t.bold ~ t.bright-blue ~ sprintf("%-40s: %-40s", trailing-dots('loggedin_username', 40), $loggedin_username) ~ t.text-reset;
    $cnt++;
    put (($cnt % 2 == 0) ?? t.bg-color(255,0,0) !! t.bg-color(0,255,0)) ~ t.bold ~ t.bright-blue ~ sprintf("%-40s: %-40s", trailing-dots('_admin', 40),            $_admin) ~ t.text-reset;
    $cnt++;
    put (($cnt % 2 == 0) ?? t.bg-color(255,0,0) !! t.bg-color(0,255,0)) ~ t.bold ~ t.bright-blue ~ sprintf("%-40s: %-40s", trailing-dots('display_name', 40),      $display_name) ~ t.text-reset;
    $cnt++;
    put (($cnt % 2 == 0) ?? t.bg-color(255,0,0) !! t.bg-color(0,255,0)) ~ t.bold ~ t.bright-blue ~ sprintf("%-40s: %-40s", trailing-dots('given', 40),             $given) ~ t.text-reset;
    $cnt++;
    put (($cnt % 2 == 0) ?? t.bg-color(255,0,0) !! t.bg-color(0,255,0)) ~ t.bold ~ t.bright-blue ~ sprintf("%-40s: %-40s", trailing-dots('family', 40),            $family) ~ t.text-reset;
    $cnt++;
    put (($cnt % 2 == 0) ?? t.bg-color(255,0,0) !! t.bg-color(0,255,0)) ~ t.bold ~ t.bright-blue ~ sprintf("%-40s: %-40s", trailing-dots('loggedin_email', 40),    $loggedin_email) ~ t.text-reset;
    $cnt++;
    put (($cnt % 2 == 0) ?? t.bg-color(255,0,0) !! t.bg-color(0,255,0)) ~ t.bold ~ t.bright-blue ~ sprintf("%-40s: %-40s", trailing-dots('phone_number', 40),      $phone_number) ~ t.text-reset;
    $cnt++;
    put (($cnt % 2 == 0) ?? t.bg-color(255,0,0) !! t.bg-color(0,255,0)) ~ t.bold ~ t.bright-blue ~ sprintf("%-40s: %-40s", trailing-dots('groupname', 40),         $groupname) ~ t.text-reset;
    $cnt++;
    put (($cnt % 2 == 0) ?? t.bg-color(255,0,0) !! t.bg-color(0,255,0)) ~ t.bold ~ t.bright-blue ~ sprintf("%-40s: %-40s", trailing-dots('primary_group_id', 40),  $primary_group_id) ~ t.text-reset;
    $cnt++;
    return True;
} # sub whoami( --> Bool) is export #

subset IdType of Int where 0 <= * <= 9_223_372_036_854_775_807;

sub lead-dots(Str $text, Int:D $width --> Str) {
    my Str $result = " $text";
    $result = '.' x ($width - $result.chars) ~ $result;
    return $result;
} # sub lead-dots(Str $text, Int:D $width --> Str) #

sub trailing-dots(Str $text, Int:D $width --> Str) {
    my Str $result = " $text";
    $result = $result ~ ('.' x ($width - $result.chars));
    return $result;
} # sub trailing-dots(Str $text, Int:D $width --> Str) #

sub dots(Str $ind, Int:D $width --> Str) {
    my Str $result = "$ind). ";
    $result ~= '.' x ($width - $result.chars);
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
        $sql ~= "c.id, c.cc, c.prefix, c._name, _flag, c._escape\n";
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
sub dropdown(Int:D $id, Int:D $window-height, Str:D $id-name, &setup-option-str, &get-result, @array --> Int) {
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
        loop {
            put t.clear-screen;
            loop (my Int $cnt = $top; $cnt < $top + $window-height && $cnt < $length; $cnt++) {
                if $cnt == $pos {
                    $bgcolour = t.bg-color(0,0,255);
                    $fgcolour = t.bright-yellow;
                } elsif $cnt % 2 == 0 {
                    $bgcolour = t.bg-color(255,0,0);
                    $fgcolour = t.bright-blue;
                } else {
                    $bgcolour = t.bg-color(0,255,0);
                    $fgcolour = t.bright-blue;
                }
                put $bgcolour ~ t.bold ~ $fgcolour ~ sprintf("%-80s", &setup-option-str($cnt, @array)) ~ t.text-reset;
            } # loop (my Int $cnt = $top; $cnt <= $top + $window-height; $cnt++) #
            $cnt = $top + $window-height;
            put t.bg-green ~ t.bold ~ t.bright-blue ~ sprintf("%-40s: %-40s", trailing-dots('use up and down arrows or page up and down', 40), 'and enter to select') ~ t.text-reset;
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
        }; # insure that we call thee reset command if it dies on a signal #
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
                            Str:D $email is rw, Int:D $cc_id is rw, Int:D $country_region_id is rw, Str:D $mobile is rw, Str:D $landline is rw,
                            Regex $mobile_pattern is rw, Regex $landline_pattern is rw, Str:D $escape is rw, Str:D $prefix is rw, Bool:D $admin is rw --> Bool) {

    my Bool $return       = True;
    my Bool:D $loggedin          = so %session«loggedin»;
    my Int    $loggedin_id       =    ((%session«loggedin_id» === Any) ?? Int !! %session«loggedin_id» );
    my Str    $loggedin_username =    ((%session«loggedin_username» === Any) ?? Str !! %session«loggedin_username» );
    my Bool:D $_admin            = so %session«loggedin_admin»;
    my Str    $display_name      =    ((%session«loggedin_display_name» === Any) ?? Str !! %session«loggedin_display_name» );
    my Str    $given             =    ((%session«loggedin_given» === Any) ?? Str !! %session«loggedin_given» );
    my Str    $family            =    ((%session«loggedin_family» === Any) ?? Str !! %session«loggedin_family» );
    my Str    $loggedin_email    =    ((%session«loggedin_email» === Any) ?? Str !! %session«loggedin_email» );
    my Str    $phone_number      =    ((%session«loggedin_phone_number» === Any) ?? Str !! %session«loggedin_phone_number» );
    my Str    $groupname         =    ((%session«loggedin_groupname» === Any) ?? Str !! %session«loggedin_groupname» );
    my Int    $primary_group_id  =    ((%session«loggedin_groupnname_id» === Any) ?? Int !! %session«loggedin_groupnname_id» );
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
        my $valid = Email::Valid.new(:simple(True), :allow-ip);
        my $gzzreadline        = Gzz_readline.new;
        my Int $cr-id          = 0;
        my Str $region         = '';
        my Str $distinguishing = '';
        $cc_id                 = 27 unless %countries{$cc_id}:exists;
        my %row                = %countries{$cc_id};
        my Str $name           = %row«_name»;
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
        $escape                = %row«_escape»;
        my @country_regions    = |@(%row«country_regions»);
        my Int $ind            = 0;
        @country_regions       = |@country_regions.sort: { my %u = %($^a); my %v = %($^b);  my $res = %u«region».lc.trim cmp %v«region».lc.trim; (($res == Same) ?? (%u«distinguishing».trim cmp %v«distinguishing».trim) !! $res ) };
        for @country_regions.kv -> $idx, %val {
            $ind = $idx if %val«region».lc.trim eq $region.lc.trim && %val«distinguishing».trim eq $distinguishing.trim;
        }
        my %value                = @country_regions[$ind];
        $cr-id                   = %value«cr_id»;
        $region                  = %value«region»;
        $distinguishing          = %value«distinguishing»;
        my $mob_pattern          = %value«mobile_pattern»;
        my $lndlne_pattern       = %value«landline_pattern»;
        $mobile_pattern          = ECMA262Regex.compile("^$mob_pattern\$");
        $landline_pattern        = ECMA262Regex.compile("^$lndlne_pattern\$");
        my $landline_placeholder = %value«landline_placeholder»;
        my $mobile_placeholder   = %value«mobile_placeholder»;
        loop {
            put t.clear-screen;
            my Int $cnt = 0;
            put (($cnt % 2 == 0) ?? t.bg-color(255,0,0) !! t.bg-color(0,255,0)) ~ t.bold ~ t.bright-blue ~ sprintf("%-10s%24s: %-42s", dots("$cnt", 10), lead-dots('username', 24),                $username) ~ t.text-reset;
            $cnt++;
            put (($cnt % 2 == 0) ?? t.bg-color(255,0,0) !! t.bg-color(0,255,0)) ~ t.bold ~ t.bright-blue ~ sprintf("%-10s%24s: %-42s", dots("$cnt", 10), lead-dots('group', 24),                   $group) ~ t.text-reset;
            $cnt++;
            put (($cnt % 2 == 0) ?? t.bg-color(255,0,0) !! t.bg-color(0,255,0)) ~ t.bold ~ t.bright-blue ~ sprintf("%-10s%24s: %-42s", dots("$cnt", 10), lead-dots('Groups', 24),                  $Groups) ~ t.text-reset;
            $cnt++;
            put (($cnt % 2 == 0) ?? t.bg-color(255,0,0) !! t.bg-color(0,255,0)) ~ t.bold ~ t.bright-blue ~ sprintf("%-10s%24s: %-42s", dots("$cnt", 10), lead-dots('given names', 24),             $given-names) ~ t.text-reset;
            $cnt++;
            put (($cnt % 2 == 0) ?? t.bg-color(255,0,0) !! t.bg-color(0,255,0)) ~ t.bold ~ t.bright-blue ~ sprintf("%-10s%24s: %-42s", dots("$cnt", 10), lead-dots('surname', 24),                 $surname) ~ t.text-reset;
            $cnt++;
            put (($cnt % 2 == 0) ?? t.bg-color(255,0,0) !! t.bg-color(0,255,0)) ~ t.bold ~ t.bright-blue ~ sprintf("%-10s%24s: %-42s", dots("$cnt", 10), lead-dots('display-name', 24),            $display-name) ~ t.text-reset;
            $cnt++;
            put (($cnt % 2 == 0) ?? t.bg-color(255,0,0) !! t.bg-color(0,255,0)) ~ t.bold ~ t.bright-blue ~ sprintf("%-10s%24s: %-42s", dots("$cnt", 10), lead-dots('email', 24),                   $email) ~ t.text-reset;
            $cnt++;
            put (($cnt % 2 == 0) ?? t.bg-color(255,0,0) !! t.bg-color(0,255,0)) ~ t.bold ~ t.bright-blue ~ sprintf("%-10s%24s: %-42s", dots("$cnt", 10), lead-dots('country and coutry code', 24), "$flag $name: $cc ($prefix)") ~ t.text-reset;
            $cnt++;
            put (($cnt % 2 == 0) ?? t.bg-color(255,0,0) !! t.bg-color(0,255,0)) ~ t.bold ~ t.bright-blue ~ sprintf("%-10s%24s: %-42s", dots("$cnt", 10), lead-dots('region', 24),                  "$region ($distinguishing)") ~ t.text-reset;
            $cnt++;
            put (($cnt % 2 == 0) ?? t.bg-color(255,0,0) !! t.bg-color(0,255,0)) ~ t.bold ~ t.bright-blue ~ sprintf("%-10s%24s: %-42s", dots("$cnt", 10), lead-dots('mobile', 24),                  $mobile) ~ t.text-reset;
            $cnt++;
            put (($cnt % 2 == 0) ?? t.bg-color(255,0,0) !! t.bg-color(0,255,0)) ~ t.bold ~ t.bright-blue ~ sprintf("%-10s%24s: %-42s", dots("$cnt", 10), lead-dots('landline', 24),                $landline) ~ t.text-reset;
            $cnt++;
            put (($cnt % 2 == 0) ?? t.bg-color(255,0,0) !! t.bg-color(0,255,0)) ~ t.bold ~ t.bright-blue ~ sprintf("%-10s%24s: %-42s", dots("$cnt", 10), lead-dots('residential unit', 24),        $residential-unit) ~ t.text-reset;
            $cnt++;
            put (($cnt % 2 == 0) ?? t.bg-color(255,0,0) !! t.bg-color(0,255,0)) ~ t.bold ~ t.bright-blue ~ sprintf("%-10s%24s: %-42s", dots("$cnt", 10), lead-dots('residential street', 24),      $residential-street) ~ t.text-reset;
            $cnt++;
            put (($cnt % 2 == 0) ?? t.bg-color(255,0,0) !! t.bg-color(0,255,0)) ~ t.bold ~ t.bright-blue ~ sprintf("%-10s%24s: %-42s", dots("$cnt", 10), lead-dots('residential city_suberb', 24), $residential-city_suberb) ~ t.text-reset;
            $cnt++;
            put (($cnt % 2 == 0) ?? t.bg-color(255,0,0) !! t.bg-color(0,255,0)) ~ t.bold ~ t.bright-blue ~ sprintf("%-10s%24s: %-42s", dots("$cnt", 10), lead-dots('residential postcode', 24),    $residential-postcode) ~ t.text-reset;
            $cnt++;
            put (($cnt % 2 == 0) ?? t.bg-color(255,0,0) !! t.bg-color(0,255,0)) ~ t.bold ~ t.bright-blue ~ sprintf("%-10s%24s: %-42s", dots("$cnt", 10), lead-dots('residential region', 24),       $residential-region) ~ t.text-reset;
            $cnt++;
            put (($cnt % 2 == 0) ?? t.bg-color(255,0,0) !! t.bg-color(0,255,0)) ~ t.bold ~ t.bright-blue ~ sprintf("%-10s%24s: %-42s", dots("$cnt", 10), lead-dots('residential country', 24),     $residential-country) ~ t.text-reset;
            $cnt++;
            if $_admin {
                put (($cnt % 2 == 0) ?? t.bg-color(255,0,0) !! t.bg-color(0,255,0)) ~ t.bold ~ t.bright-blue ~ sprintf("%-10s%24s: %-42s", dots("$cnt", 10), lead-dots('Admin', 24),                   $admin) ~ t.text-reset;
            } else {
                # Greyed out as it is disabled for a non admin user. This is a strong visual hint of the fact. #
                put t.bg-color(127,127,127) ~ t.bold ~ t.color(200,200,200) ~                                  sprintf("%-10s%24s: %-42s", dots("$cnt", 10), lead-dots('Admin', 24),                   $admin) ~ t.text-reset;
            }
            $cnt++;
            put (($cnt % 2 == 0) ?? t.bg-color(255,0,0) !! t.bg-color(0,255,0)) ~ t.bold ~ t.bright-blue ~ sprintf("%-10s%24s: %-42s", dots("$cnt", 10), lead-dots('same-as-residential', 24),     $same-as-residential) ~ t.text-reset;
            $cnt++;
            if !$same-as-residential {
                put (($cnt % 2 == 0) ?? t.bg-color(255,0,0) !! t.bg-color(0,255,0)) ~ t.bold ~ t.bright-blue ~ sprintf("%-10s%24s: %-42s", dots("$cnt", 10), lead-dots('postal-unit', 24),         $postal-unit) ~ t.text-reset;
                $cnt++;
                put (($cnt % 2 == 0) ?? t.bg-color(255,0,0) !! t.bg-color(0,255,0)) ~ t.bold ~ t.bright-blue ~ sprintf("%-10s%24s: %-42s", dots("$cnt", 10), lead-dots('postal-street', 24),       $postal-street) ~ t.text-reset;
                $cnt++;
                put (($cnt % 2 == 0) ?? t.bg-color(255,0,0) !! t.bg-color(0,255,0)) ~ t.bold ~ t.bright-blue ~ sprintf("%-10s%24s: %-42s", dots("$cnt", 10), lead-dots('postal-city_suberb', 24),  $postal-city_suberb) ~ t.text-reset;
                $cnt++;
                put (($cnt % 2 == 0) ?? t.bg-color(255,0,0) !! t.bg-color(0,255,0)) ~ t.bold ~ t.bright-blue ~ sprintf("%-10s%24s: %-42s", dots("$cnt", 10), lead-dots('postal-postcode', 24),     $postal-postcode) ~ t.text-reset;
                $cnt++;
                put (($cnt % 2 == 0) ?? t.bg-color(255,0,0) !! t.bg-color(0,255,0)) ~ t.bold ~ t.bright-blue ~ sprintf("%-10s%24s: %-42s", dots("$cnt", 10), lead-dots('postal-region', 24),       $postal-region) ~ t.text-reset;
                $cnt++;
                put (($cnt % 2 == 0) ?? t.bg-color(255,0,0) !! t.bg-color(0,255,0)) ~ t.bold ~ t.bright-blue ~ sprintf("%-10s%24s: %-42s", dots("$cnt", 10), lead-dots('postal-country', 24),      $postal-country) ~ t.text-reset;
                $cnt++;
            } # if !$same-as-residential #
            put (($cnt % 2 == 0) ?? t.bg-color(255,0,0) !! t.bg-color(0,255,0)) ~ t.bold ~ t.bright-blue ~ sprintf("%-10s%24s: %-42s", dots("$cnt", 10), lead-dots('continue', 24), 'enter') ~ t.text-reset;
            $cnt++;
            put (($cnt % 2 == 0) ?? t.bg-color(255,0,0) !! t.bg-color(0,255,0)) ~ t.bold ~ t.bright-blue ~ sprintf("%-10s%24s: %-42s", dots("$cnt..∞", 10), lead-dots('cancel', 24), 'quit') ~ t.text-reset;
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
                            while $given-names !~~ rx/^ \w+ [ \h+ \w+ ]* $/ {
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
                            while $given-names !~~ rx/^ \w+ [ \h+ \w+ ]* $/ {
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
                            while $given-names !~~ rx/^ \w+ [ \h+ \w+ ]* $/ {
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
                            while $tmp ne '' && $valid.validate($tmp) {
                                $tmp            = gzzreadline_call('email > ', $tmp, $gzzreadline);
                                $tmp .=trim;
                            }
                            $email = $tmp if $tmp ne '' && $valid.validate($tmp);
                        }
                when 7  {
                            my &setup-option-str = sub (Int:D $cnt, @array --> Str ) {
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
                            my &get-result = sub (Int:D $result, Int:D $pos, Int:D $length, @array --> Int ) {
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
                                $cc_id             = $cc-id;
                                my %_row           = %countries{$cc_id};
                                $name              = %_row«_name»;
                                $cc                = %_row«cc»;
                                $flag              = uniparse 'Australia';
                                $prefix            = %_row«prefix»;
                                $escape            = %_row«_escape»;
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
                                @country_regions    = |@(%_row«country_regions»);
                                @country_regions    = |@country_regions.sort: { my %u = %($^a); my %v = %($^b);
                                                                                my $res = %u«region».lc.trim cmp %v«region».lc.trim;
                                                    (($res == Same) ?? (%u«distinguishing».trim cmp %v«distinguishing».trim) !! $res ) };
                                my %_row_           = @country_regions[0];
                                $country_region_id  = %_row_«cr_id»;
                                $cr-id              = %_row_«cr_id»;
                                $region             = %_row_«region»;
                                $distinguishing     = %_row_«distinguishing»;
                            }
                        }
                when 8  {
                            my &setup-option-str = sub (Int:D $cnt, @array --> Str ) {
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
                            my &get-result = sub (Int:D $result, Int:D $pos, Int:D $length, @array --> Int ) {
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
                                $distinguishing       = %_value«distinguishing»;
                                $mob_pattern          = %_value«mobile_pattern»;
                                $mobile_pattern       = ECMA262Regex.compile("^$mob_pattern\$");
                                $lndlne_pattern       = %_value«landline_pattern»;
                                $landline_pattern     = ECMA262Regex.compile("^$lndlne_pattern\$");
                                $landline_placeholder = %value«landline_placeholder»;
                                $mobile_placeholder   = %value«mobile_placeholder»;
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
                            Str:D $email is rw, Int:D $cc_id is rw, Int:D $country_region_id is rw, Str:D $mobile is rw, Str:D $landline is rw,
                            Str:D $mobile_pattern is rw, Str:D $landline_pattern is rw, Str:D $escape is rw, Str:D $prefix is rw --> Bool) »»»

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
        $sql      ~= "ON CONFLICT (_email) DO UPDATE SET _email = EXCLUDED._email\n";
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
        $sql      ~= "ON CONFLICT (_number) DO UPDATE SET _number = EXCLUDED._number\n";
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
    my Regex $mobile_pattern;
    my Regex $landline_pattern;
    my Bool:D $result = True;
    my Bool:D $loggedin          = so %session«loggedin»;
    my Int    $loggedin_id       =    ((%session«loggedin_id» === Any) ?? Int !! %session«loggedin_id» );
    my Str    $loggedin_username =    ((%session«loggedin_username» === Any) ?? Str !! %session«loggedin_username» );
    my Bool:D $_admin            = so %session«loggedin_admin»;
    my Str    $display_name      =    ((%session«loggedin_display_name» === Any) ?? Str !! %session«loggedin_display_name» );
    my Str    $given             =    ((%session«loggedin_given» === Any) ?? Str !! %session«loggedin_given» );
    my Str    $family            =    ((%session«loggedin_family» === Any) ?? Str !! %session«loggedin_family» );
    my Str    $loggedin_email    =    ((%session«loggedin_email» === Any) ?? Str !! %session«loggedin_email» );
    my Str    $phone_number      =    ((%session«loggedin_phone_number» === Any) ?? Str !! %session«loggedin_phone_number» );
    my Str    $groupname         =    ((%session«loggedin_groupname» === Any) ?? Str !! %session«loggedin_groupname» );
    my Int    $primary_group_id  =    ((%session«loggedin_groupnname_id» === Any) ?? Int !! %session«loggedin_groupnname_id» );
    if !$loggedin {
        say "you must be logged in to use this function\t{$?MODULE.gist}\t{&?ROUTINE.name} in $?FILE";
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
                                $email, $cc_id, $country_region_id, $mobile, $landline, $mobile_pattern, $landline_pattern, $escape, $prefix, $admin);
        unless $result {
            return False;
        }
        $mobile   .=trim;
        if $mobile ne '' && $mobile !~~ $mobile_pattern {
            die "bad mobile value: $mobile";
        }
        $landline .=trim;
        if $landline ne '' && $landline !~~ $landline_pattern {
            die "bad landline value: $landline";
        }
        if $residential-street eq '' || $residential-city_suberb eq '' || $residential-postcode eq '' || $residential-region eq '' || $residential-country eq '' {
            die "bad address ($residential-unit, $residential-street, $residential-city_suberb, $residential-postcode, $residential-region, $residential-country)";
        }
        if !$same-as-residential && ($postal-street eq '' || $postal-city_suberb eq '' || $postal-postcode eq '' || $postal-region eq '' || $postal-country eq '') {
            die "bad address ($postal-unit, $postal-street, $postal-city_suberb, $postal-postcode, $postal-region, $postal-country)";
        }
        @Groups    = $Groups.split(rx/ \s* ',' \s* /, :skip-empty);
        my IdType:D $group-id = create-group($group);
        my IdType:D $email-id = create-email($email);
        my IdType $mobile-id = (($mobile eq '') ?? Int !! create-phone($mobile));
        my IdType $landline-id = (($landline eq '') ?? Int !! create-phone($landline));
        my IdType:D $residential-address-id = create-address($residential-unit, $residential-street, $residential-city_suberb, $residential-postcode, $residential-region, $residential-country);
        my IdType:D $postal-address-id = $residential-address-id;
        if !$same-as-residential {
            $postal-address-id = create-address($postal-unit, $postal-street, $postal-city_suberb, $postal-postcode, $postal-region, $postal-country);
        }
        dd $username, $group, @Groups, $given-names, $surname, $display-name,
                                $residential-unit, $residential-street, $residential-city_suberb,
                                $residential-postcode, $residential-region, $residential-country, $same-as-residential,
                                $postal-unit, $postal-street, $postal-city_suberb, $postal-postcode, $postal-region, $postal-country,
                                $email, $cc_id, $country_region_id, $mobile, $landline, $admin, $result, $group-id, $email-id, $residential-address-id,
                                $postal-address-id;
    }
    return $result;
} #`««« sub login(Str:D $username is copy where { $username ~~ rx/^ \w+ $/}, Str:D $passwd, Str:D $repeat-pwd,
                      Str:D $group is copy, @Groups, Str:D $given-names is copy, Str:D $surname is copy,
                      Str:D $display-name is copy, Str:D $residential-unit is copy, Str:D $residential-street is copy,
                      Str:D $residential-city_suberb is copy, Str:D $residential-postcode is copy, Str:D $residential-region is copy,
                      Str:D $residential-country is copy, Bool:D $same-as-residential is copy,
                      Str:D $email is copy, Str:D $mobile is copy, Str:D $landline is copy --> Bool) is export »»»

END {
    %session.save;
    $db.disconnect;
    $dbh.dispose;
}
