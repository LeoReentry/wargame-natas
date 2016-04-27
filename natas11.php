#!/usr/bin/php
<?php
// Yeah, I know it's weird to solve this with php, but that way I could just
// lazily reuse the server functions
if (count($argv) < 2) {
  echo "Please provide a password\n";
  exit;
}
$password=$argv[1];
// if ($argv[1])
// Our new XOR encryption function
function xor_encrypt($in) {
  $defaultdata = json_encode(array( "showpassword"=>"no", "bgcolor"=>"#ffffff"));
  $text = $in;
  $outText = '';

  // Iterate through each character
  for($i=0;$i<strlen($defaultdata);$i++) {
    $outText .= $text[$i % strlen($text)] ^ $defaultdata[$i];
  }
  return $outText;
}
// The encrypted cookie we received
$data = 'ClVLIh4ASCsCBE8lAxMacFMZV2hdVVotEhhUJQNVAmhSEV4sFxFeaAw=';
// The key we decode out of it
$keychain = xor_encrypt(base64_decode($data));
// Now we have the key
// We will need to identify the repeating pattern in the key because our new
// array will be one character longer
// Let's match a repeating, non greedy pattern in the key
echo "The data was encrypted with the following pattern: ".$keychain."\n";
$pattern = '/(.+?)\1+/';
preg_match($pattern, $keychain, $matches);
$key = $matches[1];
// Let's test if it is correct
if ($data != base64_encode(xor_encrypt($key))) {
  echo "The key is incorrect, aborting...\n";
  exit();
}

echo "The XOR encryption key is ".$key."\n";
echo "Encrypting manipulated cookie\n";
$ourdata = json_encode(array( "showpassword"=>"yes", "bgcolor"=>"#ffffff"));
$cookie = '';
for($i=0;$i<strlen($ourdata);$i++) {
  $cookie .= $ourdata[$i] ^ $key[$i % strlen($key)];
}
$ourcookie = base64_encode($cookie);
echo "Our encoded cookie is ".$ourcookie."\n";

$comm = 'curl -s --user natas11:'.$password.' --cookie "data='.$ourcookie.'" "http://natas11.natas.labs.overthewire.org/" | grep -E -o "The password for natas12 is [[:alnum:]]{32}"';
echo passthru($comm);
?>
