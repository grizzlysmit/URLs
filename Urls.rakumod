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
#use Email::Valid:from<Perl5>;
use Email::Valid; # using the raku one #


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
#my $t = DBIish::Transaction.new(connection => {DBIish.connect('Pg', :$dbuser, :password => get-password($dbuser), :$database);}, :retry);
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
    die "link-section must have a value." if $link-section ~~ rx/^^ \s+ $$/;
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
    die "link-section must have a value." if $link-section ~~ rx/^^ \s+ $$/;
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
    die "link-section must have a value." if $page-name ~~ rx/^^ \s+ $$/;
    my $sth0 = $dbh.execute('SELECT id FROM pages WHERE name = ?', $page-name);
    my %val = $sth0.row(:hash);
    die "Error: page-name: $page-name does not exist" unless %val;
    my $pages_id = %val«id»;
    $dbh.execute("DELETE FROM page_section WHERE pages_id = ?;", $pages_id);
    $dbh.execute("DELETE FROM pages WHERE id = ?;", $pages_id);
    return True;
}

sub delete-pseudo-page(Str $page-name --> Bool) is export {
    die "link-section must have a value." if $page-name ~~ rx/^^ \s+ $$/;
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
    my $p5 = Inline::Perl5.new;
    $p5.use('Crypt::PBKDF2');
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
            }
       }

        $result = $pbkdf2.validate($hashed-password, $password) != 0;
    }
    return $result;
} # sub validate(Str:D $hashed-password, Str:D $password --> Bool) is export #

sub login(Str:D $username where { $username ~~ rx/^^ \w+ $$/}, Str:D $passwd --> Bool) is export {
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
    my $_admin            = %val«_admin»;
    my $display_name      = %val«display_name»;
    my $given             = %val«given»;
    my $family            = %val«_family»;
    my $email             = %val«_email»;
    my $phone_number      = %val«phone_number»;
    my $groupname         = %val«groupname»;
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
} # sub login(Str:D $username where { $username ~~ rx/^^ \w+ $$/}, Str:D $passwd --> Bool) is export #

subset GroupId of Int where 0 <= * <= 1_000_000_000;

sub create-or-find-group(Str:D $group --> GroupId) {
    my $sql    = qq{SELECT g.id FROM _group g WHERE g._name = ?;};
    my $sth;
    try {
        CATCH {
           when X::DBDish::DBError {
              say .message;
           }
        }

        $sth   = $dbh.execute($sql, $group);
    } # try #
    my %values = $sth.row(:hash);
    my $id     = %values«id»;
    return $id if so $id;
    $sql       = qq{INSERT INTO _group(_name) VALUES(?);\n};
    try {
        CATCH {
           when X::DBDish::DBError {
              say .message;
           }
        }

        $sth               = $dbh.execute($sql, $group);
    } # try #
    %values    = $sth.row(:hash);
    $id        = %values«id»;
    return $id;
} # sub create-or-find-group(Str:D $group --> GroupId) #

sub dots(Str $ind, Int:D $width --> Str) {
    my Str $result = "$ind). ";
    $result ~= '.' x ($width - $result.chars);
    return $result;
}

sub ask-for-all-user-values(Str:D $username is rw, Str:D $group is rw, $Groups is rw, Str:D $given-names is rw,
                            Str:D $surname is rw, Str:D $display-name is rw,
                            Str:D $residential-unit is rw, Str:D $residential-street is rw, Str:D $residential-city_suberb is rw,
                            Str:D $residential-postcode is rw, Str:D $residential-region is rw, Str:D $residential-country is rw,
                            Bool:D $same-as-residential is rw,
                            Str:D $postal-unit is rw, Str:D $postal-street is rw, Str:D $postal-city_suberb is rw,
                            Str:D $postal-postcode is rw, Str:D $postal-region is rw, Str:D $postal-country is rw,
                            Str:D $email is rw, Str:D $mobile is rw, Str:D $landline is rw --> Bool) {
    put t.save-screen;
    my Str $choice        = '';
    my Bool $display-auto = True;
    my Bool $return       = True;
    my $valid = Email::Valid.new(:simple(True), :allow-ip);
    loop {
        put t.clear-screen;
        my Int $cnt = 0;
        put (($cnt % 2 == 0) ?? t.bg-color(255,0,0) !! t.bg-color(0,255,0)) ~ t.bold ~ t.bright-blue ~ sprintf("%-10s\t%22s: \t%-34s", dots("$cnt", 22), 'username',     $username) ~ t.text-reset;
        $cnt++;
        put (($cnt % 2 == 0) ?? t.bg-color(255,0,0) !! t.bg-color(0,255,0)) ~ t.bold ~ t.bright-blue ~ sprintf("%-10s\t%22s: \t%-34s", dots("$cnt", 22), 'group',        $group) ~ t.text-reset;
        $cnt++;
        put (($cnt % 2 == 0) ?? t.bg-color(255,0,0) !! t.bg-color(0,255,0)) ~ t.bold ~ t.bright-blue ~ sprintf("%-10s\t%22s: \t%-34s", dots("$cnt", 22), 'Groups',       $Groups) ~ t.text-reset;
        $cnt++;
        put (($cnt % 2 == 0) ?? t.bg-color(255,0,0) !! t.bg-color(0,255,0)) ~ t.bold ~ t.bright-blue ~ sprintf("%-10s\t%22s: \t%-34s", dots("$cnt", 22), 'given names',  $given-names) ~ t.text-reset;
        $cnt++;
        put (($cnt % 2 == 0) ?? t.bg-color(255,0,0) !! t.bg-color(0,255,0)) ~ t.bold ~ t.bright-blue ~ sprintf("%-10s\t%22s: \t%-34s", dots("$cnt", 22), 'surname',      $surname) ~ t.text-reset;
        $cnt++;
        put (($cnt % 2 == 0) ?? t.bg-color(255,0,0) !! t.bg-color(0,255,0)) ~ t.bold ~ t.bright-blue ~ sprintf("%-10s\t%22s: \t%-34s", dots("$cnt", 22), 'display-name', $display-name) ~ t.text-reset;
        $cnt++;
        put (($cnt % 2 == 0) ?? t.bg-color(255,0,0) !! t.bg-color(0,255,0)) ~ t.bold ~ t.bright-blue ~ sprintf("%-10s\t%22s: \t%-34s", dots("$cnt", 22), 'email',       $email) ~ t.text-reset;
        $cnt++;
        put (($cnt % 2 == 0) ?? t.bg-color(255,0,0) !! t.bg-color(0,255,0)) ~ t.bold ~ t.bright-blue ~ sprintf("%-10s\t%22s: \t%-34s", dots("$cnt", 22), 'mobile',       $mobile) ~ t.text-reset;
        $cnt++;
        put (($cnt % 2 == 0) ?? t.bg-color(255,0,0) !! t.bg-color(0,255,0)) ~ t.bold ~ t.bright-blue ~ sprintf("%-10s\t%22s: \t%-34s", dots("$cnt", 22), 'landline',     $landline) ~ t.text-reset;
        $cnt++;
        put (($cnt % 2 == 0) ?? t.bg-color(255,0,0) !! t.bg-color(0,255,0)) ~ t.bold ~ t.bright-blue ~ sprintf("%-10s\t%22s: \t%-34s", dots("$cnt", 22), 'residential unit',     $residential-unit) ~ t.text-reset;
        $cnt++;
        put (($cnt % 2 == 0) ?? t.bg-color(255,0,0) !! t.bg-color(0,255,0)) ~ t.bold ~ t.bright-blue ~ sprintf("%-10s\t%22s: \t%-34s", dots("$cnt", 22), 'residential street',       $residential-street) ~ t.text-reset;
        $cnt++;
        put (($cnt % 2 == 0) ?? t.bg-color(255,0,0) !! t.bg-color(0,255,0)) ~ t.bold ~ t.bright-blue ~ sprintf("%-10s\t%22s: \t%-34s", dots("$cnt", 22), 'residential city_suberb',       $residential-city_suberb) ~ t.text-reset;
        $cnt++;
        put (($cnt % 2 == 0) ?? t.bg-color(255,0,0) !! t.bg-color(0,255,0)) ~ t.bold ~ t.bright-blue ~ sprintf("%-10s\t%22s: \t%-34s", dots("$cnt", 22), 'residential postcode',       $residential-postcode) ~ t.text-reset;
        $cnt++;
        put (($cnt % 2 == 0) ?? t.bg-color(255,0,0) !! t.bg-color(0,255,0)) ~ t.bold ~ t.bright-blue ~ sprintf("%-10s\t%22s: \t%-34s", dots("$cnt", 22), 'residential region',       $residential-region) ~ t.text-reset;
        $cnt++;
        put (($cnt % 2 == 0) ?? t.bg-color(255,0,0) !! t.bg-color(0,255,0)) ~ t.bold ~ t.bright-blue ~ sprintf("%-10s\t%22s: \t%-34s", dots("$cnt", 22), 'residential country',       $residential-country) ~ t.text-reset;
        $cnt++;
        put (($cnt % 2 == 0) ?? t.bg-color(255,0,0) !! t.bg-color(0,255,0)) ~ t.bold ~ t.bright-blue ~ sprintf("%-10s\t%22s: \t%-34s", dots("$cnt", 22), 'same-as-residential', $same-as-residential) ~ t.text-reset;
        $cnt++;
        if !$same-as-residential {
            put (($cnt % 2 == 0) ?? t.bg-color(255,0,0) !! t.bg-color(0,255,0)) ~ t.bold ~ t.bright-blue ~ sprintf("%-10s\t%22s: \t%-34s", dots("$cnt", 22), 'postal-unit',       $postal-unit) ~ t.text-reset;
            $cnt++;
            put (($cnt % 2 == 0) ?? t.bg-color(255,0,0) !! t.bg-color(0,255,0)) ~ t.bold ~ t.bright-blue ~ sprintf("%-10s\t%22s: \t%-34s", dots("$cnt", 22), 'postal-street',       $postal-street) ~ t.text-reset;
            $cnt++;
            put (($cnt % 2 == 0) ?? t.bg-color(255,0,0) !! t.bg-color(0,255,0)) ~ t.bold ~ t.bright-blue ~ sprintf("%-10s\t%22s: \t%-34s", dots("$cnt", 22), 'postal-city_suberb',       $postal-city_suberb) ~ t.text-reset;
            $cnt++;
            put (($cnt % 2 == 0) ?? t.bg-color(255,0,0) !! t.bg-color(0,255,0)) ~ t.bold ~ t.bright-blue ~ sprintf("%-10s\t%22s: \t%-34s", dots("$cnt", 22), 'postal-postcode',       $postal-postcode) ~ t.text-reset;
            $cnt++;
            put (($cnt % 2 == 0) ?? t.bg-color(255,0,0) !! t.bg-color(0,255,0)) ~ t.bold ~ t.bright-blue ~ sprintf("%-10s\t%22s: \t%-34s", dots("$cnt", 22), 'postal-region',       $postal-region) ~ t.text-reset;
            $cnt++;
            put (($cnt % 2 == 0) ?? t.bg-color(255,0,0) !! t.bg-color(0,255,0)) ~ t.bold ~ t.bright-blue ~ sprintf("%-10s\t%22s: \t%-34s", dots("$cnt", 22), 'postal-country',       $postal-country) ~ t.text-reset;
            $cnt++;
        } # if !$same-as-residential #
        put (($cnt % 2 == 0) ?? t.bg-color(255,0,0) !! t.bg-color(0,255,0)) ~ t.bold ~ t.bright-blue ~ sprintf("%-10s\t%22s: \t%-34s", dots("$cnt", 22), 'continue', 'enter') ~ t.text-reset;
        $cnt++;
        put (($cnt % 2 == 0) ?? t.bg-color(255,0,0) !! t.bg-color(0,255,0)) ~ t.bold ~ t.bright-blue ~ sprintf("%-10s\t%22s: \t%-34s", dots("22..99", 22), 'exit', 'bye') ~ t.text-reset;
        $choice = prompt 'choice > ';
        given $choice {
            when '' {   # have to explicitly match here otherwise it will match with 0 #
                        $return = True;
                        last;
                    }
            when 0  { $username                = prompt 'username > '; }
            when 1  { $group                   = prompt 'group > '; }
            when 2  { $Groups                  = prompt 'Groups > '; }
            when 3  {
                        $given-names           = prompt 'given names > ';
                        $display-name          = "$given-names $surname" if $display-auto;
                    }
            when 4  {
                        $surname               = prompt 'surname > ';
                        $display-name          = "$given-names $surname" if $display-auto;
                    }
            when 5  {
                        $display-name          = prompt 'display name > ';
                        $display-auto          = False;
                    }
            when 6  {
                        my $email1             = prompt 'email > ';
                        $email = $email1 if $email1.trim ne '' && $valid.validate($email1);
                    }
            when 7  { $mobile                  = prompt 'mobile > '; }
            when 8  { $landline                = prompt 'landline > '; }
            when 9  { $residential-unit        = prompt "residential unit > "; }
            when 10 { $residential-street      = prompt "residential street > "; }
            when 11 { $residential-city_suberb = prompt "residential city_suberb > "; }
            when 12 { $residential-postcode    = prompt "residential postcode > "; }
            when 13 { $residential-region      = prompt "residential region > "; }
            when 14 { $residential-country     = prompt "residential country > "; }
            when 15 { $same-as-residential     = !$same-as-residential; }
            when 16..* {
                if !$same-as-residential {
                    given $choice {
                        when 16 { $postal-unit             = prompt "postal unit > "; }
                        when 17 { $postal-street           = prompt "postal street > "; }
                        when 18 { $postal-city_suberb      = prompt "postal city_suberb > "; }
                        when 19 { $postal-postcode         = prompt "postal postcode > "; }
                        when 20 { $postal-region           = prompt "postal region > "; }
                        when 21 { $postal-country          = prompt "postal country > "; }
                        when 22 {
                                    $return    = True;
                                    last;
                                }
                        when 23..* {
                                       $return = False;
                                       last;
                                    }
                    }
                } else {
                    given $choice {
                        when 16 {
                                    $return    = True;
                                    last;
                                }
                        when 17..* {
                                       $return = False;
                                       last;
                                    }
                    }
                }
            }
            when rx:i/^^ ['continue'|'enter'] $$/ { # match explict enter (i.e '') above as otherwise it matches with 0 #
                        $return = True;
                        last;
                    }
            when rx:i/^^ ['exit'|'bye'|'bye' \s* 'bye'] $$/ {
                        $return = False;
                        last;
                    }
            default {
                       $choice = prompt 'do you want to exit y/N > ';
                       last if $choice.lc.trim eq 'y';
                    }
        } # given $prompt #
    } # loop #
    put t.restore-screen;
    return $return;
}

sub register-new-user(Str:D $username is copy where { $username ~~ rx/^^ \w+ $$/}, Str:D $passwd, Str:D $repeat-pwd,
                      Str:D $group is copy, @Groups, Str:D $given-names is copy, Str:D $surname is copy,
                      Str:D $display-name is copy, Str:D $residential-unit is copy, Str:D $residential-street is copy,
                      Str:D $residential-city_suberb is copy, Str:D $residential-postcode is copy, Str:D $residential-region is copy,
                      Str:D $residential-country is copy, Bool:D $same-as-residential is copy,
                      Str:D $email is copy, Str:D $mobile is copy, Str:D $landline is copy --> Bool) is export {
    return False unless $passwd eq $repeat-pwd;
    my Str:D $hashed-passwd = generate-hash($passwd);
    if !validate($hashed-passwd, $passwd) {
        "Error: password validation failed.".say;
        return False;
    }
    my $postal-unit = '';
    my $postal-street = '';
    my $postal-city_suberb = '';
    my $postal-postcode = '';
    my $postal-region = '';
    my $postal-country = '';
    my $Groups = @Groups.join(', ');
    ask-for-all-user-values($username, $group, $Groups, $given-names, $surname, $display-name,
                            $residential-unit, $residential-street, $residential-city_suberb,
                            $residential-postcode, $residential-region, $residential-country, $same-as-residential,
                            $postal-unit, $postal-street, $postal-city_suberb, $postal-postcode, $postal-region, $postal-country,
                            $email, $mobile, $landline);
    @Groups    = $Groups.split(rx/ \s* ',' \s* /, :skip-empty);
    dd $username, $group, $Groups, $given-names, $surname, $display-name,
                            $residential-unit, $residential-street, $residential-city_suberb,
                            $residential-postcode, $residential-region, $residential-country, $same-as-residential,
                            $postal-unit, $postal-street, $postal-city_suberb, $postal-postcode, $postal-region, $postal-country,
                            $email, $mobile, $landline;
    return True;
} # sub login(Str:D $username where { $username ~~ rx/^^ \w+ $$/}, Str:D $passwd, Str:D $verifypwd --> Bool) is export #

END {
    %session.save;
    $db.disconnect;
    $dbh.dispose;
}
