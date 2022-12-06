unit module Session:ver<0.1.0>:auth<Francis Grizzly Smit (grizzlysmit@smit.id.au)>;

use Inline::Perl5;
use DBI:from<Perl5>;
use Apache::Session::Postgres:from<Perl5>;
use Init_session:from<Perl5>;

class Postgres does Associative is export {
    subset StrOrArrayOfStr where Str | ( Array & {.all ~~ Str} );

    has $!apsesspg;
    has $.id;
    has %!args;
    has $!db;
    has Bool $!dirty;
    submethod BUILD (:$id, :%args, :$db, :$dirty) {
        if $id ~~ Str && $id ~~ rx/^^ \w+ $$/ {
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
    multi method new ( $_id, $_args where Hash = {} ) {
        #"new positional".say;
        return self.new( :$_id, :args(%$_args) );
    }
    multi method new ( :$_id is copy = Nil, :%args = Hash.new() ) {
        #"new names only".say;
        #dd %args;
        my $id;
        my Bool $dirty = False;
        if $_id ~~ Str && $_id.trim ne '' {
            $id = $_id;
        } else {
            $dirty = True;
        }
        #dd $id;
        my $db;
        if %args«Handle»:exists {
            $db   = %args«Handle»;
        } else {
            {
                CATCH {
                    when X::AdHoc {
                        say "Caught a Perl 5 exception: $_";
                    }                        
                    default {
                        #.resume;
                    }
                }
                my Str $dbserver = %args«dbserver»;
                my Int $dbport   = %args«dbport»;
                my Str $dbuser   = %args«dbuser»;
                my Str $dbpass   = %args«dbpasswd»;
                my Str $dbname   = %args«dbname»;
                dd $dbserver, $dbport, $dbpass, $dbname, $dbuser;
                $db = DBI.connect("dbi:Pg:database=$dbname;host=$dbserver;port=$dbport;", "$dbuser", "$dbpass", { AutoCommit => 1, RaiseError => 1});
            }
        }
        return self.bless(:$id, :%args, :$db, :$dirty, |%_);
    }
    method EXISTS-KEY ($key) {
        return $!apsesspg.EXISTS($key);
    }
    method DELETE-KEY ($key) {
        my $result = $!apsesspg.DELETE($key);
        $!dirty    = True;
        return $result;
    }
    method ASSIGN-KEY ($key, $new) {
        my $result = $!apsesspg.STORE($key, $new);
        $!dirty    = True;
        return $result;
    }
    method Str {
        my Str $result;
        return $!apsesspg.Str;
    }
    method AT-KEY ($key) is rw {
        $!dirty = True;
        return $!apsesspg.FETCH($key);
    }
    method BIND-KEY ($key, \new) {
        my $result = $!apsesspg.FETCH($key) = \new;
        $!dirty    = True;
        return $result;
    }
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
