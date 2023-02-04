#!/usr/bin/env raku
use v6;

use Urls;
use Terminal::Getpass;
#use Email::Valid:from<Perl5>;
use Email::Valid; # using the raku one #
use ECMA262Regex;

my %*SUB-MAIN-OPTS;
%*SUB-MAIN-OPTS<named-anywhere> = True;
#%*SUB-MAIN-OPTS<bundling>       = True;

multi sub MAIN('list', 'links', Str $prefix = '') returns Int {
   if list-links($prefix) {
       exit 0;
   } else {
       exit 1;
   } 
}

multi sub MAIN('list', 'aliases', Str $prefix = '') returns Int {
   if list-aliases($prefix) {
       exit 0;
   } else {
       exit 1;
   } 
}

multi sub MAIN('list', 'pages', Str $page-name = '', Str $prefix = '') returns Int {
   if list-pages($page-name, $prefix) {
       exit 0;
   } else {
       exit 1;
   } 
}

multi sub MAIN('add', 'page', Str $page where { $page !~~ rx/^ \s+ $/ }, Str :$name = '', *@links) returns Int {
   if add-page($page, $name, @links) {
       exit 0;
   } else {
       exit 1;
   } 
}

multi sub MAIN('add', 'links', Str $link-section where { $link-section !~~ rx/^^ \s+ $$/ }, *%links where { %links }) returns Int {
   if add-links($link-section, %links) {
       exit 0;
   } else {
       exit 1;
   } 
}

multi sub MAIN('add', 'alias', Str $alias-name where { $alias-name !~~ rx/^^ \s* $$/ && (!section-exists($alias-name) && !alias-exists($alias-name)) }, Str $link-section where { $link-section !~~ rx/^^ \s* $$/ && (link-exists($link-section) || alias-exists($link-section))  }) returns Int {
   if add-alias($alias-name, $link-section) {
       exit 0;
   } else {
       exit 1;
   } 
}

multi sub MAIN('delete', 'links', Str $link-section where { $link-section !~~ rx/^^ \s+ $$/ },  Bool :r(:$remove-section) = False, *@links where { @links }) returns Int {
   if delete-links($link-section, $remove-section, @links) {
       exit 0;
   } else {
       exit 1;
   } 
}

multi sub MAIN('delete', 'page', Str $page-name where { $page-name !~~ rx/^^ \s+ $$/ }) returns Int {
   if delete-page($page-name) {
       exit 0;
   } else {
       exit 1;
   } 
}

multi sub MAIN('delete', 'pseudo-page', Str $page-name where { $page-name !~~ rx/^^ \s+ $$/ }) returns Int {
   if delete-pseudo-page($page-name) {
       exit 0;
   } else {
       exit 1;
   } 
}

multi sub MAIN('add', 'pseudo-page', Str $page where { $page !~~ rx/^^ \s+ $$/ }, Str $pattern = '',
               Str :$status where { $status ~~ rx/^^ ['invalid'|'unassigned'|'assigned'|'both'] $$/ } = 'invalid',
                                                                              Str :$full-name = $page) returns Int {
   if add-pseudo-pages($page, Str2Status($status), $full-name, $pattern) {
       exit 0;
   } else {
       exit 1;
   } 
}

multi sub MAIN('launch', 'link', Str $section where { $section !~~ rx/^^ \s+ $$/ }, Str $link) returns Int {
   if launch-link($section, $link) {
       exit 0;
   } else {
       exit 1;
   } 
}

multi sub MAIN('login', Str :u(:$username) is copy where { $username ~~ rx/^^ \w* $$/} = '', Str :p(:$passwd) is copy = '') returns Int {
    my Int:D $retrys = 0;
    while $username eq '' || $username !~~ rx/^ \w+ $/ {
        unless $retrys < 4 {
            "too many retrys".say;
            exit 1;
        }
        $username = prompt "username > ";
        $retrys++;
    }
    if $passwd eq '' {
        $passwd = getpass "password > ";
    }
    if login($username, $passwd) {
       exit 0;
    } else {
       exit 1;
    } 
}

multi sub MAIN('register', Str:D $username is copy where { $username ~~ rx/^ \w+ $/ }, Str:D :p(:password(:$passwd)) is copy = '',
               Str:D :g(:$group) is copy = $username, Str:D :G(:$Groups) = '',
               Str:D :f(:$given-names) = '', Str:D :s(:$surname) = '', Str:D :d(:$display-name) = '', 
               Str:D :u(:$unit) = '', Str:D :S(:$street) = '', Str:D :c(:$city-suberb) = '', Str:D :P(:$postcode) = '',
               Str:D :R(:$region) = '', Str:D :C(:$country) = '', Bool:D :N(:$not-the-same-as-residential) = False,
               Str:D :e(:$email) is copy = '', Str:D :m(:$mobile) = '', :l(:$landline) = '', Bool:D :a(:$admin) = False) returns Int {
    my Str:D $repeat-pwd = '';
    $repeat-pwd       = $passwd if valid-pwd($passwd, :nowhitespace);
    while $username !~~ rx/^^ \w ** 2..32 $$/ {
        $username = prompt "username must be between 2 and 32 characters in [a-zA-Z0-9_] > ";
    }
    while !valid-pwd($passwd, :nowhitespace) || $passwd ne $repeat-pwd {
        $passwd = getpass "password: ";
        $repeat-pwd = getpass "repeat-password: ";
    }
    while $group eq '' || $group !~~ rx/^^ \w ** 2..32 $$/ {
        $group = prompt "main group: [$username] > ";
        $group = $username if $group eq '';
        #dd $group;
    }
    my @Groups = $Groups.split(',', :skip-empty);
    ##`«««
    #my $valid = Email::Valid.new('-mxcheck' => 1, '-tldcheck' => 1, '-allow_ip' => 1); # Perl5 version
    #my $valid = Email::Valid.new(:!simple, :allow-ip, :mx_check);
    my $valid = Email::Valid.new(:simple(True), :allow-ip);
    while $email.trim eq '' || !$valid.validate($email) {
        $email = prompt "must supply a valid email > ";
    }
    # »»»
    my Bool $same-as-residential = !$not-the-same-as-residential;
    if register-new-user($username, $passwd, $repeat-pwd, $group, @Groups, $given-names, $surname, $display-name,
                           $unit, $street, $city-suberb, $postcode, $region, $country, $same-as-residential, $email, $mobile, $landline, $admin) {
       exit 0;
    } else {
       exit 1;
    } 
}

multi sub MAIN('who', 'am', 'i' ) returns Int {
   if whoami() {
       exit 0;
   } else {
       exit 1;
   } 
}

multi sub MAIN('whoami' ) returns Int {
   if whoami() {
       exit 0;
   } else {
       exit 1;
   } 
}

multi sub MAIN('logout', Bool:D :s(:$sure) = False) returns Int {
   if logout($sure) {
       exit 0;
   } else {
       exit 1;
   } 
}

multi sub MAIN('change', 'passwd', Str:D :u(:$username) where { $username ~~ rx/^ \w* $/ } = '', Bool:D :f(:$force) = False )  returns Int {
    my Str:D $old-passwd  = $force ?? '' !! getpass "old password: ";
    my Str:D $passwd = getpass "new password: ";
    my Str:D $repeat-pwd = getpass "repeat new password: ";
    if change-passwd($old-passwd, $passwd, $repeat-pwd, $username, $force) {
        exit 0;
    } else {
        exit 1;
    } 
} # multi sub MAIN('change', 'passwd' )  returns Int #

multi sub MAIN('chmod', 'pages', Bool:D :r(:$recursive) = False, Str :u(:$user) = Str, Bool:D :v(:$verbose) = False,
                                Str :g(:$group) = Str, Str :o(:$other) = Str,
                                        Int :p(:$perms) where { perms-good($perms, $user, $group, $other) } = Int,
                                                        *@page-names where { $_ ~~ rx/ ^ \w+ [ '-' \w+ ]* $/ }) returns Int {
    my %the-perms;
    with $perms { %the-perms«perms» = $perms; }
    orwith $user // $group // $other {
        with $user  { %the-perms«user»  = $user;  }
        with $group { %the-perms«group» = $group; }
        with $other { %the-perms«other» = $other; }
    }
    if chmod-pages($recursive, $verbose, %the-perms, @page-names) {
        exit 0;
    } else {
        exit 1;
    }
}

multi sub MAIN('chown', 'pages', Bool:D :r(:$recursive) = False, Bool:D :v(:$verbose) = False,
                        Str :U(:$user) = Str, IdType :u(:$userid) = IdType, Str :G(:$group) = Str, IdType :g(:$groupid) = IdType,
                                                        *@page-names where { $_ ~~ rx/ ^ \w+ [ [ '-' || '.' || '@' || '#' || '%' || '+' || '=' ] \w+ ]* $/ }) returns Int {
    without $user // $userid // $group // $groupid {
        "Error: You didn't supply any of --user,  --userid,  --group,  --groupid".say;
        exit 2;
    }
    if $user !=== Str && $userid !=== IdType {
        "Error: you supplied both --user and --userid supply only one or the other!".say;
        exit 3;
    }
    if $group !=== Str && $groupid !=== IdType {
        "Error: you supplied both --group and --groupid supply only one or the other!".say;
        exit 4;
    }
    if chown-page($recursive, $verbose, $user, $userid, $group, $groupid, @page-names) {
        exit 0;
    } else {
        exit 1;
    }
}

multi sub MAIN('chmod', 'pseudo', 'pages', Bool:D :v(:$verbose) = False, Str :u(:$user) = Str,
                                Str :g(:$group) = Str, Str :o(:$other) = Str,
                                        Int :p(:$perms) where { perms-good($perms, $user, $group, $other) } = Int,
                                                        *@page-names where { $_ ~~ rx/ ^ \w+ [ [ '-' || '.' || '@' || '#' || '%' || '+' || '=' ] \w+ ]* $/ }) returns Int {
    my %the-perms;
    with $perms { %the-perms«perms» = $perms; }
    orwith $user // $group // $other {
        with $user  { %the-perms«user»  = $user;  }
        with $group { %the-perms«group» = $group; }
        with $other { %the-perms«other» = $other; }
    }
    if chmod-pseudo-page($verbose, %the-perms, @page-names) {
        exit 0;
    } else {
        exit 1;
    }
} #`««« multi sub MAIN('chmod', 'pseudo', 'pages', Bool:D :v(:$verbose) = False, Str :u(:$user) = Str,
                                Str :g(:$group) = Str, Str :o(:$other) = Str,
                                        Int :p(:$perms) where { perms-good($perms, $user, $group, $other) } = Int,
                                        *@page-names where { $_ ~~ rx/ ^ \w+ [ '-' \w+ ]* $/ }) returns Int »»»

multi sub MAIN('chown', 'pseudo', 'pages', Bool:D :v(:$verbose) = False,
                        Str :U(:$user) = Str, IdType :u(:$userid) = IdType, Str :G(:$group) = Str, IdType :g(:$groupid) = IdType,
                                                        *@page-names where { $_ ~~ rx/ ^ \w+ [ '-' \w+ ]* $/ }) returns Int {
    without $user // $userid // $group // $groupid {
        "Error: You didn't supply any of --user,  --userid,  --group,  --groupid".say;
        exit 2;
    }
    if $user !=== Str && $userid !=== IdType {
        "Error: you supplied both --user and --userid supply only one or the other!".say;
        exit 3;
    }
    if $group !=== Str && $groupid !=== IdType {
        "Error: you supplied both --group and --groupid supply only one or the other!".say;
        exit 4;
    }
    if chown-pseudo-page($verbose, $user, $userid, $group, $groupid, @page-names) {
        exit 0;
    } else {
        exit 1;
    }
}

multi sub MAIN('page', 'perms', Bool:D :r(:$recursive) = False, Bool:D :i(:$show-id) = False, Bool:D :f(:$full) = False, Str :p(:$pattern) = Str, Str :e(:$ecma-pattern) = Str) returns Int {
    my Regex $_pattern;
    with $pattern {
        $_pattern = rx:i/ <$pattern> /;
    } orwith $ecma-pattern {
        $_pattern = ECMA262Regex.compile("^$ecma-pattern\$");
    } else {
        $_pattern = rx:i/^ .* $/;
    }
    if list-page-perms($recursive, $show-id, $full, $_pattern) {
        exit 0;
    } else {
        exit 1;
    }
} # multi sub MAIN('page', 'perms', Bool:D :r(:$recursive) = False, Bool:D :i(:$show-id) = False, Bool:D :f(:$full) = False, Str :p(:$pattern) = Str, Str :e(:$ecma-pattern) = Str) returns Int #

multi sub MAIN('ls', 'pages', Bool:D :r(:$recursive) = False, Bool:D :i(:$show-id) = False, Bool:D :f(:$full) = False, Str :p(:$pattern) = Str, Str :e(:$ecma-pattern) = Str) returns Int {
    my Regex $_pattern;
    with $pattern {
        $_pattern = rx:i/ <$pattern> /;
    } orwith $ecma-pattern {
        $_pattern = ECMA262Regex.compile("^$ecma-pattern\$");
    } else {
        $_pattern = rx:i/^ .* $/;
    }
    if list-page-perms($recursive, $show-id, $full, $_pattern) {
        exit 0;
    } else {
        exit 1;
    }
} # multi sub MAIN('ls', 'pages', Bool:D :r(:$recursive) = False, Bool:D :i(:$show-id) = False, Bool:D :f(:$full) = False, Str :p(:$pattern) = Str, Str :e(:$ecma-pattern) = Str) returns Int #

multi sub MAIN('pseudo', 'page', 'perms', Bool:D :i(:$show-id) = False, Bool:D :f(:$full) = False, Str :p(:$pattern) = Str, Str :e(:$ecma-pattern) = Str) returns Int {
    my Regex $_pattern;
    with $pattern {
        $_pattern = rx:i/ <$pattern> /;
    } orwith $ecma-pattern {
        $_pattern = ECMA262Regex.compile("^$ecma-pattern\$");
    } else {
        $_pattern = rx:i/^ .* $/;
    }
    if list-pseudo-page-perms($show-id, $full, $_pattern) {
        exit 0;
    } else {
        exit 1;
    }
}

multi sub MAIN('ls', 'pseudo', 'pages', Bool:D :i(:$show-id) = False, Bool:D :f(:$full) = False, Str :p(:$pattern) = Str, Str :e(:$ecma-pattern) = Str) returns Int {
    my Regex $_pattern;
    with $pattern {
        $_pattern = rx:i/ <$pattern> /;
    } orwith $ecma-pattern {
        $_pattern = ECMA262Regex.compile("^$ecma-pattern\$");
    } else {
        $_pattern = rx:i/^ .* $/;
    }
    if list-pseudo-page-perms($show-id, $full, $_pattern) {
        exit 0;
    } else {
        exit 1;
    }
}
