#!/usr/bin/perl
use geoip;
use JSON qw( decode_json ); 
use Data::Dumper;
use Try::Tiny;

my $geo_ip = geoip->new();

my $ip = $ARGV[0];

if ($ip eq "")
{
	print "Uso: \n geoip.pl 1.2.3.4 \n ";
	die
}

$json_response = $geo_ip->get_data(ip => $ip);
my $decoded_json;
try {
	$decoded_json = decode_json($json_response);
	#print Dumper $decoded_json;
	
	my $isp = $decoded_json->{'org'};
	my $regionName = $decoded_json->{'regionName'};
	$regionName =~ s/,/ /g; 
	$isp =~ s/,/ /g; 
	my $country = $decoded_json->{'country'};
	my $hosting = $decoded_json->{'hosting'};

	if ($hosting == 1) {
		$hosting_type = "Hosting";
	} else {
		$hosting_type = "On-Premise";
	}

	if ($isp =~ /amazon/i || $isp =~ /microsoft/i || $isp =~ /google/i) {
		$hosting_type = "On-Premise";
	}

	print "$isp,$regionName ($country),$hosting_type \n";
} 
catch {   
	print "";
};
