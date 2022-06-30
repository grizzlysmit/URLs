module Session:ver<0.1.0>:auth<Francis Grizzly Smit (grizzlysmit@smit.id.au)>{

    use DBIish;
    use DBDish::Pg;
    use Digest::MD5;
    use MIME::Base64;

    class Serialize {
        method unserize ( Str:D $raw ) {
            my $data = MIME::Base64.decode-str($raw);
            use MONKEY-SEE-NO-EVAL;
            my $decoded = EVAL ($data);
            no MONKEY-SEE-NO-EVAL;
            return %$decoded;
        }
        method serialize ( $val  --> Str ) {
            my Str $data =  $val.raku;
            return MIME::Base64.encode-str($data, :eol("\x0D\x0A"));
        }
    }
    class Store {
        has $.db;
        has Str $.id;
        has Str $.a_session;
        submethod BUILD(:$!db, :$!id) {
            $!a_session = self.init( $!id );
        }
        method init ( Str:D: $id ) {
            my $sql    = "SELECT a_session FROM sessions WHERE id = ?;";
            dd $sql;
            my $query  = $!db.prepare($sql);
            dd $query;
            my $result = $query.execute($id);
            dd $query,  $result;
            if $result {
                my %val = $result.row(:hash);
                dd %val;
                if %val {
                    return %val«a_session»;
                }
            }
            return Serialize.new.serialize(Hash.new());
        }
        method get (--> Str ) {
            return $!a_session;
        }
    }
    class Postgres does Associative is export {
        subset StrOrArrayOfStr where Str | ( Array & {.all ~~ Str} );

        has %.data of StrOrArrayOfStr
                 handles <iterator list kv keys values>;
        has $!_store;
        has $.id;
        has %!args;
        has $!db;
        submethod BUILD ( :%data, :$_store, :$id, :%args, :$db ) {
            dd $id;
            %!data   = %data;
            $!_store = $_store;
            $!id     = $id;
            %!args   = %args;
            $!db     = $db;
        }
        multi method new ( $id, $_args where Hash = {} ) {
            "new positional".say;
            return self.new( :$id, :args(%$_args) );
        }
        multi method new ( :$id is copy = Nil, :%args = Hash.new() ) {
            "new names only".say;
            #%!args = %args;
            dd %args;
            ##`«««
            if $id ~~ Nil|Any {
                my $length = 32;
                my $d = Digest::MD5.new;
                $id = ($d.md5_hex($d.md5_hex(DateTime.now.posix() ~ Hash.new() ~ 1e5.rand ~ $*PID))).substr(0, $length);
            }#»»»
            dd $id;
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
            my $raw = $_store.get();
            my %data  = Serialize.new.unserize($raw);
            return self.bless(:%data, :$_store, :$id, :%args, :$db, |%_);
        }
        method EXISTS-KEY ($key) {
            return %!data{normalize-key $key}:exists;
        }
        method DELETE-KEY ($key) {
            return %!data{normalize-key $key}:delete;
        }
        method ASSIGN-KEY ($key, $new) {
            return %!data{$key} = $new;
        }
        method Str {
            return %!data.Str;
        }
        method AT-KEY ($key) is rw {
            return %!data{normalize-key $key};
        }
        method BIND-KEY ($key, \new) {
            return %!data{$key} = \new;
        }
        method push(*@_) {
            return %!data.push(|@_);
        }
        sub normalize-key ($key) {
            $key.subst(/\w+/, *.tc, :g) 
        }
        #`«««
        method postcircumfix<{ }> (:$k, :$v, :$kv, :$p, :$exists, :$delete, **@key) {
            if $exists {
                return self.exists(|@key);
            }
        };
        #»»»
    }
}
