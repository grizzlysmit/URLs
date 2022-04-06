#===============================================================================
#
#         FILE: profile.pl
#
#        USAGE: ./profile.pl  
#
#  DESCRIPTION: 
#
#      OPTIONS: ---
# REQUIREMENTS: ---
#         BUGS: ---
#        NOTES: ---
#       AUTHOR: Francis Grizzly Smit (FGJS), grizzly@smit.id.au
# ORGANIZATION: 
#      VERSION: 1.0
#      CREATED: 2022-04-06 16:12:05
#     REVISION: ---
#===============================================================================

use strict;
use warnings;
use utf8;
use v5.32.1;
use Apache2::Request;
use Data::Dumper;
use Config::IniFiles;
use FileHandle;
use lib '/usr/share/mod_perl';
use Urls;

my $r = shift;


my $req             = Apache2::Request->new($r);
my $debug           = $req->param('debug');

# make a inifile object to get the inifile data #
my $inipath = "/etc/urls/config.ini"; # TODO: define on server.
my $cfg = Config::IniFiles->new( -file => $inipath );

my $logpath = '/var/log/urls'; # TODO: define on server.

my $log;
if($debug){
    if(open($log, '>>', "$logpath/debug.log")){
        $log->autoflush(1);
    }else{
        die "could not open $logpath/debug.log $!";
    }
}

my $id = qx(id);
chomp $id;

my $urls = Urls->new($logpath, $cfg);

$urls->debug_init($debug, $log);


#print "Content-type:text/plain\r\n\r\n";
print "content-type:text/html; charset=utf-8\n\n";

say <<"END";
<!DOCTYPE html>
<html>
    <head>
        <title>Grizzly&apos;s links page</title>
        <link rel="icon" type="image/x-icon" href="/images/favicon.ico">
        <link rel="stylesheet" href="styles/styles.css">
    </head>
    <body>
END

$urls->user($req, $cfg, $r);


say <<"DONE";
    </body>
</html>
DONE


