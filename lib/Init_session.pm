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

use strict;
use warnings;
use v5.34.0;
use Apache::Session::Postgres;
use DBI;

sub call_tie_without_id {
    my ($args) = @_;
    return Apache::Session::Postgres->TIEHASH(undef(), $args);
} ## --- end sub call_tie_without_id


sub call_tie_with_id {
    my ($session_id, $args) = @_;
    return Apache::Session::Postgres->TIEHASH($session_id, $args);
} ## --- end sub call_tie_with_id

return 1;
