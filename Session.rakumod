module Session:ver<0.1.0>:auth<Francis Grizzly Smit (grizzlysmit@smit.id.au)>{

    #use DBIish;
    #use DBDish::Pg;
    #use Digest::MD5;
    #use MIME::Base64;
    use Inline::Perl5;
    use DBI:from<Perl5>;
    use lib '/usr/share/mod_perl';
    use Apache::Session::Postgres:from<Perl5>;
    use Init_session:from<Perl5>;

    #`«««
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
    # »»»
    class Postgres does Associative is export {
        subset StrOrArrayOfStr where Str | ( Array & {.all ~~ Str} );

        #has $!p5;
        has $!apsesspg;
        #has %!data of StrOrArrayOfStr handles <iterator list kv k keys p values>;
        #has $!_store;
        has $.id;
        has %!args;
        has $!db;
        has Bool $!dirty;
        submethod BUILD ( #:$p5, 
                          #:%data,
                          #:$_store,
                          :$id,
                          :%args,
                          :$db,
                          :$dirty) {
            #`«««
            if $p5 ~~ Nil {
                $!p5 = $p5;
            } else {
                $!p5 = Inline::Perl5.new;
            }
            $!p5.use('Apache::Session::Postgres');
            $!apsesspg = $!p5.invoke('Apache::Session::Postgres', 'TIEHASH', $id, { Handle => $db, TableName => 'sessions', });
            # »»»
            if $id ~~ Str {
                #$!apsesspg = Apache::Session::Postgres.TIEHASH($id, { Handle => $db, TableName => 'sessions', });
                $!apsesspg = Init_session::call_tie_with_id($id, { Handle => $db, TableName => 'sessions', });
            } else {
                #$!apsesspg = Apache::Session::Postgres.TIEHASH((Any), { Handle => $db, TableName => 'sessions', });
                $!apsesspg = Init_session::call_tie_without_id({ Handle => $db, TableName => 'sessions', });
            }
            dd $id;
            #%!data   = %data;
            #$!_store = $_store;
            my $_id  = $!apsesspg.FETCH('id');
            $!id     = $id // $_id;
            dd $id, $_id, $!apsesspg;
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
            #%!args = %args;
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
            #my $p5 = Nil; 
            if %args«Handle»:exists {
                $db   = %args«Handle»;
            } else {
                {
                    CATCH {
                        #`«««
                        when X::DBDish::DBError::Pg {
                            .message.say; .message-detail.say; .message-hint.say; .resume;
                        } # »»»
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
                    #$p5 = Inline::Perl5.new;
                    #$p5.use('DBI');
                    #$db = $p5.invoke('DBI', 'connect', "dbi:Pg:database=$dbname;host=$dbserver;port=$dbport;", "$dbuser", "$dbpass", { AutoCommit => 1, RaiseError => 1});
                    #$db = $p5.invoke('DBI', 'connect', "dbi:Pg:database=$dbname;host=$dbserver;port=$dbport;", "$dbuser", "$dbpass", { AutoCommit => 1, RaiseError => 1});
                    $db = DBI.connect("dbi:Pg:database=$dbname;host=$dbserver;port=$dbport;", "$dbuser", "$dbpass", { AutoCommit => 1, RaiseError => 1});
                    #$db = DBIish.connect('Pg', :host<<$dbserver>>, :port($dbport), :database<<$dbname>>, :user<<$dbuser>>, :password<<$dbpass>>);
                }
            }
            #`«««
            my $_store = Store.new( :$db, :$id );
            my ($raw, $dirty) = $_store.get();
            my %data  = Serialize.new.unserize($raw);
            # »»»
            return self.bless(#:$p5, 
                              #:%data,
                              #:$_store,
                              :$id,
                              :%args,
                              :$db,
                              :$dirty,
                              |%_);
        }
        method EXISTS-KEY ($key) {
            return $!apsesspg.EXISTS($key);
            #return %!data{$key}:exists;
        }
        method DELETE-KEY ($key) {
            #my $result = %!data{$key}:delete;
            my $result = $!apsesspg.DELETE($key);
            $!dirty    = True;
            return $result;
        }
        method ASSIGN-KEY ($key, $new) {
            #my $result = %!data{$key} = $new;
            my $result = $!apsesspg.STORE($key, $new);
            $!dirty    = True;
            return $result;
        }
        method Str {
            #return %!data.Str;
            my Str $result;
            return $!apsesspg.Str;
        }
        method AT-KEY ($key) is rw {
            $!dirty = True;
            #return %!data{$key};
            return $!apsesspg.FETCH($key);
        }
        method BIND-KEY ($key, \new) {
            #my $result = %!data{$key} = \new;
            my $result = $!apsesspg.FETCH($key) = \new;
            $!dirty    = True;
            return $result;
        }
        #`«««
        method push(*@_) {
            #my $result = %!data.push(|@_);
            my $result = $!apsesspg.FIRSTKEY;
            $!dirty    = True;
            return $result;
        } #»»»
        method save {
            #dd $!id;
            if $!dirty {
                $!apsesspg.save;
                #`«««
                my $raw = Serialize.new.serialize(%!data);
                $!_store.save($raw, $!id);
                $!dirty = False;
                # »»»
            }
        }
        method restore {
            $!apsesspg.restore;
        }
        submethod DESTROY {
            self.save;
        }
    }
}
