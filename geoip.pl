#!/usr/bin/perl
use geoip;
use JSON qw( decode_json ); 
use Data::Dumper;

my $geo_ip = geoip->new();

my $ip = $ARGV[0];
$json_response = $geo_ip->get_data(ip => $ip);

my $decoded_json = decode_json($json_response);
#print Dumper $decoded_json;
my $isp = $decoded_json->{'isp'};
my $regionName = $decoded_json->{'regionName'};
    
print "$regionName;$isp \n";

