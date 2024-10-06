#module-starter --module=geoip --author="Daniel Torres" --email=daniel.torres@owasp.org
# Aug 27 2012
package geoip;
our $VERSION = '1.1';
use Moose;
use Data::Dumper;
use LWP::UserAgent;
use URI;
use HTML::TreeBuilder;
use HTTP::Cookies;
use HTML::Entities;
use HTML::TokeParser;
use Encode;
use URI::Escape;


{
has proxy_host      => ( isa => 'Str', is => 'rw', default => '' );
has proxy_port      => ( isa => 'Str', is => 'rw', default => '' );
has proxy_user      => ( isa => 'Str', is => 'rw', default => '' );
has proxy_pass      => ( isa => 'Str', is => 'rw', default => '' );
has browser  => ( isa => 'Object', is => 'rw', lazy => 1, builder => '_build_browser' );


sub get_data  {
	my $self = shift;
	my %options = @_;
	
	my $ip = $options{ ip };
	my $proxy_host = $self->proxy_host;
	my $tries=0;
	my @results;                            
	my $url = "http://ip-api.com/json/$ip?fields=status,message,org,country,regionName,hosting";
	
	my $response = $self->dispatch(url => $url ,method => 'GET');
	my $status = $response->status_line;			
	my $json_response = $response->decoded_content;          
	
return $json_response;
}    




sub _build_browser {    

#print "building browser \n";
my $self = shift;

my $proxy_host = $self->proxy_host;
my $proxy_port = $self->proxy_port;
my $proxy_user = $self->proxy_user;
my $proxy_pass = $self->proxy_pass;


my $browser = LWP::UserAgent->new;
$browser->timeout(10);
$browser->show_progress(0);
$browser->default_header('User-Agent' => 'Mozilla/5.0 (X11; Ubuntu; Linux i686; rv:11.0) Gecko/20100101 Firefox/11.0'); 
$browser->default_header('Accept' => 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8'); 
$browser->default_header('Accept-Language' => 'en-US,en;q=0.5'); 
$browser->default_header('Connection' => 'keep-alive'); 

$browser->cookie_jar(HTTP::Cookies->new(file => "cookies.txt", autosave => 1));



if ($proxy_host eq 'tor')
{
 print "Using tor \n";
 $browser->proxy([qw/ http https /] => 'socks://localhost:9050');
}
elsif ($proxy_host eq 'incloak')
{}
else
{
  if (($proxy_user ne "") && ($proxy_host ne ""))
  {
   print "Using private proxy \n ";
   $browser->proxy(['http', 'https'], 'http://'.$proxy_user.':'.$proxy_pass.'@'.$proxy_host.':'.$proxy_port); # Using a private proxy
  }
  elsif ($proxy_host ne "")
    {   print "Using public proxy \n ";
	    $browser->proxy(['http', 'https'], 'http://'.$proxy_host.':'.$proxy_port);} # Using a public proxy    
}
return $browser;     
}


sub dispatch {    
my $self = shift;
my %options = @_;

my $url = $options{ url };
my $method = $options{ method };

my $response = '';
if ($method eq 'GET')
  { $response = $self->browser->get($url);}
  
if ($method eq 'POST')
  {     
   my $post_data = $options{ post_data };        
   $response = $self->browser->post($url,$post_data);
  }  
      
  
return $response;
}

}
1; 
