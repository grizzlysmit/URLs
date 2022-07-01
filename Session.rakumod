module Session:ver<0.1.0>:auth<Francis Grizzly Smit (grizzlysmit@smit.id.au)>{

    use DBIish;
    use DBDish::Pg;
    use Digest::MD5;
    use MIME::Base64;

    class Serialize {
        method unserize ( Str:D $raw ) {
            #dd $raw;
            my $data = MIME::Base64.decode-str($raw);
            #dd $data;
            use MONKEY-SEE-NO-EVAL;
            my $decoded = EVAL ($data);
            no MONKEY-SEE-NO-EVAL;
            #dd $decoded;
            return %$decoded;
        }
        method serialize ( $val  --> Str ) {
            #dd $val;
            my Str $data =  $val.raku;
            #dd $data;
            return MIME::Base64.encode-str($data, :eol("\x0D\x0A"));
        }
    }
    class Store {
        has $.db;
        has Str $.id;
        has Str $.a_session;
        has Bool $.dirty;
        submethod BUILD(:$db, :$id, :$a_session, :$dirty) {
            #dd $id;
            $!db        = $db;
            $!id        = $id;
            $!a_session = $a_session;
            $!dirty     = $dirty;
        }
        multi method new(:$db, Str:D :$id) {
            my Str $a_session;
            my Bool $dirty = False;
            my $sql    = "SELECT a_session FROM sessions WHERE id = ?;";
            #dd $sql;
            my $query  = $db.prepare($sql);
            #dd $query;
            my $result = $query.execute($id);
            #dd $query,  $result;
            if $result {
                my %val = $result.row(:hash);
                #dd %val;
                if %val {
                    $a_session = %val«a_session»;
                } else {
                    $dirty     = True;
                    $a_session = Serialize.new.serialize(Hash.new());
                }
            } else {
                $dirty     = True;
                $a_session = Serialize.new.serialize(Hash.new());
            }
            if $dirty {
                $sql  = "INSERT INTO sessions(id, a_session)VALUES(?, ?)\n";
                $sql ~= "    ON CONFLICT (id) DO UPDATE SET a_session = EXCLUDED.a_session;\n";
                #dd $sql;
                my $query = $db.prepare($sql);
                #dd $query;
                my $res = $query.execute($id, $a_session);
                #dd $res;
                if $res {
                    $dirty = False;
                }
            }
            return self.bless(:$db, :$id, :$a_session, :$dirty, |%_);
        }
        method get (--> List ) {
            return $!a_session, $!dirty;
        }
        method save (Str:D $data, $id) {
            my $sql  = "UPDATE sessions SET a_session = ?\n";
            $sql    ~= "WHERE id = ?\n";
            my $res = $!db.execute($sql, $data, $id);
            #dd $res;
            unless $res {
                die "UPDATE Failed: $sql";
            }
        }
    }
    class Postgres does Associative is export {
        subset StrOrArrayOfStr where Str | ( Array & {.all ~~ Str} );

        has %.data of StrOrArrayOfStr
                 handles <iterator list kv k keys p values>;
        has $!_store;
        has $.id;
        has %!args;
        has $!db;
        has Bool $!dirty;
        submethod BUILD ( :%data, :$_store, :$id, :%args, :$db, :$dirty) {
            #dd $id;
            %!data   = %data;
            $!_store = $_store;
            $!id     = $id;
            %!args   = %args;
            $!db     = $db;
            $!dirty  = $dirty;
        }
        multi method new ( $id, $_args where Hash = {} ) {
            #"new positional".say;
            return self.new( :$id, :args(%$_args) );
        }
        multi method new ( :$id is copy = Nil, :%args = Hash.new() ) {
            #"new names only".say;
            #%!args = %args;
            #dd %args;
            ##`«««
                #if $id == Nil || ($id ~~ Str && $id eq '')  {
                my $length = 32;
                my $d = Digest::MD5.new;
                $id = $id // ($d.md5_hex($d.md5_hex(DateTime.now.posix() ~ Hash.new() ~ 1e5.rand ~ $*PID))).substr(0, $length);
                #dd "Got here $?LINE", $id;
                #}#»»»
            #dd $id;
            my $db;
            if %args«Handle»:exists {
                $db   = %args«Handle»;
            } else {
                {
                    CATCH {
                        when X::DBDish::DBError::Pg {
                            .message.say; .message-detail.say; .message-hint.say; .resume;
                        }
                        default {
                            .resume;
                        }
                    }
                    my Str $dbserver = %args«dbserver»;
                    my Int $dbport   = %args«dbport»;
                    my Str $dbuser   = %args«dbuser»;
                    my Str $dbpasswd = %args«dbpasswd»;
                    my Str $dbname   = %args«dbname»;
                    $db = DBIish.connect('Pg', :host<<$dbserver>>, :port($dbport), :database<<$dbname>>, :user<<$dbuser>>, :password<<$dbpasswd>>);
                }
            }
            my $_store = Store.new( :$db, :$id );
            my ($raw, $dirty) = $_store.get();
            my %data  = Serialize.new.unserize($raw);
            return self.bless(:%data, :$_store, :$id, :%args, :$db, :$dirty, |%_);
        }
        method EXISTS-KEY ($key) {
            return %!data{$key}:exists;
        }
        method DELETE-KEY ($key) {
            my $result = %!data{$key}:delete;
            $!dirty    = True;
            return $result;
        }
        method ASSIGN-KEY ($key, $new) {
            my $result = %!data{$key} = $new;
            $!dirty    = True;
            return $result;
        }
        method Str {
            return %!data.Str;
        }
        method AT-KEY ($key) is rw {
            $!dirty = True;
            return %!data{$key};
        }
        method BIND-KEY ($key, \new) {
            my $result = %!data{$key} = \new;
            $!dirty    = True;
            return $result;
        }
        method push(*@_) {
            my $result = %!data.push(|@_);
            $!dirty    = True;
            return $result;
        }
        method save {
            #dd $!id;
            if $!dirty {
                my $raw = Serialize.new.serialize(%!data);
                $!_store.save($raw, $!id);
                $!dirty = False;
            }
        }
        submethod DESTROY {
            self.save;
        }
    }
}
