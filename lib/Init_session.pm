package Init_session;
#
#===============================================================================
#
#         FILE: init_session.pm
#
#  DESCRIPTION: 
#
#        FILES: ---
#         BUGS: ---
#        NOTES: ---
#       AUTHOR: Francis Grizzly Smit (FGJS), grizzly@smit.id.au
# ORGANIZATION: 
#      VERSION: 1.0
#      CREATED: 2022-12-06 10:16:33
#     REVISION: ---
#===============================================================================

use parent 'Exporter';
use strict;
use warnings;
use v5.34.0;
use Apache::Session::Postgres;
use DBI;
#use Exporter;

#our @ISA = qw(Exporter);

our @EXPORT = qw(tiehash_without_id tiehash_with_id);
our @EXPORT_OK = qw(tiehash_without_id tiehash_with_id);

sub tiehash_without_id {
    my ($args) = @_;
    return Apache::Session::Postgres->TIEHASH(undef(), $args);
} ## --- end sub tiehash_without_id


sub tiehash_with_id {
    my ($session_id, $args) = @_;
    return Apache::Session::Postgres->TIEHASH($session_id, $args);
} ## --- end sub tiehash_with_id

return 1;
