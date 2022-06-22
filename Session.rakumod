module Session:ver<0.1.0>:auth<Francis Grizzly Smit (grizzlysmit@smit.id.au)>{

    class Postgres is export {
        has %.data;
        submethod BUILD ( $id = Nil ) {
            my $raw = Store.get($id);
            %!data  = Serialize.unserize($raw);
        };
        method exists (**@key) {
            return self{|key}:exists;
        };
        method postcircumfix<{ }> (**@key, :$k, :$v, :$kv, :$p, :$exists, :$delete) {
            if $exists {
                return self.exists(|@key);
            }
        };
    };
    class Store {
    };
    class Serialize {
    };
}
