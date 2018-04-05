#!perl -T
use 5.006;
use strict;
use warnings;
use Test::More;

plan tests => 1;

BEGIN {
    use_ok( 'geoip' ) || print "Bail out!\n";
}

diag( "Testing geoip $geoip::VERSION, Perl $], $^X" );
