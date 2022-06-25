module Session:ver<0.1.0>:auth<Francis Grizzly Smit (grizzlysmit@smit.id.au)>{

    use DBIish;

    class Postgres does Associative is export {
        subset StrOrArrayOfStr where Str | ( Array & {.all ~~ Str} );

        has %.data of StrOrArrayOfStr
                 handles <iterator list kv keys values>;
        submethod BUILD ( $id = Nil ) {
            my $raw = Store.get($id);
            %!data  = Serialize.unserize($raw);
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
    };
    class Store {
        method get ( Str:D: $id ) {
            my $query = $db
        };
    };
    class Serialize {
    };
}
