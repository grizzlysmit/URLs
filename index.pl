#===============================================================================
#
#         FILE: index.pl
#
#        USAGE: ./index.pl  
#
#  DESCRIPTION: 
#
#      OPTIONS: ---
# REQUIREMENTS: ---
#         BUGS: ---
#        NOTES: ---
#       AUTHOR: Francis Grizzly Smit (FGJS), grizzlysmi@smit.id.au
# ORGANIZATION: 
#      VERSION: 1.0
#      CREATED: 2022-02-08 16:23:06
#     REVISION: ---
#===============================================================================

use strict;
use warnings;
use utf8;
use v5.32.1;
use Apache2::Request;
use Data::Dumper;

my $r = shift;


my $req             = Apache2::Request->new($r);
my $key             = $req->param('key');
my $unique          = $req->param('unique');
my $from_address    = $req->param('from_address');
my $debug           = $req->param('debug');
my @argnames        = $req->param;

#print "Content-type:text/plain\r\n\r\n";
print "content-type:text/html; charset=utf-8\n\n";

say <<"END";
<!DOCTYPE html>
<html>
    <head>
        <title>Grizzly's links page</title>
        <link rel="icon" type="image/x-icon" href="/images/favicon.ico">
    </head>
    <body>
        <form>
END

say "            <h1>G&apos;Day Grizzly</h1>";

if(defined $key){
    say "            <p>\$key == $key</p>";
}else{
    say "            <p>parameter 'key' not found</p>";
}

if(defined $unique){
    say "            <p>\$unique == $unique</p>";
}else{
    say "            <p>parameter 'unique' not found</p>";
}

if(defined $from_address){
    say "            <p>\$from_address == $from_address</p>";
}else{
    say "            <p>parameter 'from_address' not found</p>";
}

if(defined $debug){
    say "            <p>\$debug == $debug</p>";
}else{
    say "            <p>parameter 'debug' not found</p>";
}

my %args;
for my $name (@argnames){
    next if $name eq 'key';
    next if $name eq 'unique';
    next if $name eq 'nodein';
    next if $name eq 'from_address';
    next if $name eq 'debug';
    #$args{$name} = $cgiquery->param($name); 
    $args{$name} = $req->param($name); 
}

say "            <p>[", __LINE__, "]</p>\n            <pre>\n", Data::Dumper->Dump([\@argnames, \%args], [qw(@argnames %args)]), "\n            </pre>\n";

say <<"DONE";
        </form>
    </body>
</html>
DONE
