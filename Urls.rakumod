unit module Urls:ver<0.1.0>:auth<Francis Grizzly Smit (grizzlysmit@smit.id.au)>;

use Config::INI;
use Config::INI::Writer;
#use DBIish::Transaction;
#use DBIish::Savepoint;
use DBIish;
use Session;


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

my $database = 'urls';
my $user     = 'urluser';
#my $t = DBIish::Transaction.new(connection => {DBIish.connect('Pg', :$user, :password => get-password($user), :$database);}, :retry);
my $dbh = DBIish.connect('Pg', :host<rakbat.local>, :port(5432), :$database, :$user, password => get-password($user));


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
