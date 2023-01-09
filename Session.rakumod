unit module Session:ver<0.1.0>:auth<Francis Grizzly Smit (grizzlysmit@smit.id.au)>;

use Inline::Perl5;
use DBI:from<Perl5>;
use Apache::Session::Postgres:from<Perl5>;
use Init_session:from<Perl5>;

class X::Session::FailedToSupplyArg is Exception {
    has Str $.argname;
    method message() {
        "Failed to supply Argument $!argname!";
    }
}

class X::Session::InvailedArg is Exception {
    has Str $.argname;
    method message() {
        "Failed to supply vaild value for Argument $!argname!";
    }
}

class Postgres does Associative is export {
    subset StrOrArrayOfStr where Str | ( Array & {.all ~~ Str} );

    has $!apsesspg;
    has $.id;
    has %!args;
    has $!db;
    has Bool $!dirty;
    submethod BUILD (Str :$id, :%args, :$db, :$dirty) {
        if $id !=== Str && $id ~~ rx/^^ \w+ $$/ {
            $!apsesspg = tiehash_with_id($id, { Handle => $db, TableName => 'sessions', });
        } else {
            $!apsesspg = tiehash_without_id({ Handle => $db, TableName => 'sessions', });
        }
        #dd $id;
        my $_id  = $!apsesspg.FETCH('_session_id');
        $!id     = $id // $_id;
        #dd $id, $_id, $!apsesspg;
        %!args   = %args;
        $!db     = $db;
        $!dirty  = $dirty;
    }
    multi method new (Str $_id, $_args where Hash = {} ) {
        #"new positional".say;
        return self.new( :$_id, :args(%$_args) );
    }
    multi method new (Str :$_id is copy = Str, :%args = Hash.new() ) {
        #"new names only".say;
        #dd %args;
        my Str $id;
        my Bool $dirty = False;
        if $_id !=== Str && $_id.trim ne '' {
            $id = $_id;
        } else {
            $dirty = True;
        }
        #dd $id;
        my DBI::db $db;
        if %args«Handle»:exists {
            without %args«Handle» {
                say "Bad value for Handle supplied! should be Perl5 DBI!";
            }
            $db   = %args«Handle»;
        } else {
            {
                CATCH {
                    when X::AdHoc {
                        say "Caught a Perl 5 exception: $_";
                    }                        
                    when X::TypeCheck::Assignment {
                        say "you tried to assign a bad value or did not supply one!";
                        .rethrow;
                    }
                    default {
                        .say;
                        .rethrow;
                    }
                }
                unless %args«dbserver»:exists {
                    "you must supply hash elt \%args«dbserver» of type Str:D since you did not supply a Handle of perl5 type DBI!".say;
                    X::Session::FailedToSupplyArg.new(:argname("\%args«dbserver»")).die;
                }
                unless %args«dbport»:exists {
                    "you must supply hash elt \%args«dbport» of type Int:D since you did not supply a Handle of perl5 type DBI!".say;
                    X::Session::FailedToSupplyArg.new(:argname("\%args«dbport»")).die;
                }
                unless %args«dbuser»:exists {
                    "you must supply hash elt \%args«dbuser» of type Str:D since you did not supply a Handle of perl5 type DBI!".say;
                    X::Session::FailedToSupplyArg.new(:argname("\%args«dbuser»")).die;
                }
                unless %args«dbpasswd»:exists {
                    "you must supply hash elt \%args«dbpasswd» of type Str:D since you did not supply a Handle of perl5 type DBI!".say;
                    X::Session::FailedToSupplyArg.new(:argname("\%args«dbpasswd»")).die;
                }
                unless %args«dbname»:exists {
                    "you must supply hash elt \%args«dbname» of type Str:D since you did not supply a Handle of perl5 type DBI!".say;
                    X::Session::FailedToSupplyArg.new(:argname("\%args«dbname»")).die;
                }
                without %args«dbserver» {
                    "you must supply hash elt \%args«dbserver» of type Str:D since you did not supply a Handle of perl5 type DBI!".say;
                    X::Session::InvailedArg.new(:argname("\%args«dbserver»")).die;
                }
                without %args«dbport» {
                    "you must supply hash elt \%args«dbport» of type Int:D since you did not supply a Handle of perl5 type DBI!".say;
                    X::Session::InvailedArg.new(:argname("\%args«dbport»")).die;
                }
                without %args«dbuser» {
                    "you must supply hash elt \%args«dbuser» of type Str:D since you did not supply a Handle of perl5 type DBI!".say;
                    X::Session::InvailedArg.new(:argname("\%args«dbuser»")).die;
                }
                without %args«dbpasswd» {
                    "you must supply hash elt \%args«dbpasswd» of type Str:D since you did not supply a Handle of perl5 type DBI!".say;
                    X::Session::InvailedArg.new(:argname("\%args«dbpasswd»")).die;
                }
                without %args«dbname» {
                    "you must supply hash elt \%args«dbname» of type Str:D since you did not supply a Handle of perl5 type DBI!".say;
                    X::Session::InvailedArg.new(:argname("\%args«dbname»")).die;
                }
                if %args«dbserver».trim eq '' {
                    "you must supply hash elt \%args«dbserver» with a none empty string!".say;
                    X::Session::InvailedArg.new(:argname("\%args«dbserver»")).die;
                }
                unless %args«dbport» ~~ 1..65536 {
                    "Bad port number %args«dbport» you must supply a port number between 1 and 65536!".say;
                    X::Session::InvailedArg.new(:argname("\%args«dbport»")).die;
                }
                if %args«dbuser».trim eq '' {
                    "you must supply hash elt \%args«dbuser» with a none empty string!".say;
                    X::Session::InvailedArg.new(:argname("\%args«dbuser»")).die;
                }
                if %args«dbpasswd».trim eq '' {
                    "you must supply hash elt \%args«dbpasswd» with a none empty string!".say;
                    X::Session::InvailedArg.new(:argname("\%args«dbpasswd»")).die;
                }
                if %args«dbname».trim eq '' {
                    "you must supply hash elt \%args«dbname» with a none empty string!".say;
                    X::Session::InvailedArg.new(:argname("\%args«dbname»")).die;
                }
                my Str:D $dbserver = %args«dbserver»;
                my Int:D $dbport   = %args«dbport»;
                my Str:D $dbuser   = %args«dbuser»;
                my Str:D $dbpasswd = %args«dbpasswd»;
                my Str:D $dbname   = %args«dbname»;
                #dd $dbserver, $dbport, $dbpass, $dbname, $dbuser;
                $db = DBI.connect("dbi:Pg:database=$dbname;host=$dbserver;port=$dbport;", "$dbuser", "$dbpasswd", { AutoCommit => 1, RaiseError => 1});
            }
        }
        return self.bless(:$id, :%args, :$db, :$dirty, |%_);
    }
    method !unserialise($val) {
        use MONKEY-SEE-NO-EVAL;
        my $result = EVAL $val;
        no MONKEY-SEE-NO-EVAL;
        return $result;
    }    
    method EXISTS-KEY ($key) {
        return $!apsesspg.EXISTS($key);
    }
    method DELETE-KEY ($key) {
        $!apsesspg.DELETE($key);
        $!dirty    = True;
    }
    method ASSIGN-KEY ($key, $new is copy) {
        $new = $new.raku;
        my $result = $!apsesspg.STORE($key, $new);
        $!dirty    = True;
        return $result;
    }
    method Str {
        my Str $result;
        return $!apsesspg.Str;
    }
    method AT-KEY ($key) {
        $!dirty = True;
        return self!unserialise($!apsesspg.FETCH($key));
    }
    #`«««
    method BIND-KEY ($key, \new) {
        my $result = $!apsesspg.FETCH($key) = \new;
        $!dirty    = True;
        return $result;
    }
    # »»»
    method save {
        #dd $!id;
        if $!dirty {
            $!apsesspg.save;
        }
    }
    method restore {
        $!apsesspg.restore;
    }
    submethod DESTROY {
        self.save;
    }
}
