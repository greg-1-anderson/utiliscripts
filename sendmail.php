#!/usr/bin/php
<?php

// See: http://www.drupal4hu.com/node/55
// sendmail_path = /home/ga/local/utiliscripts/sendmail.php

$input = file_get_contents('php://stdin');
preg_match('|^To: (.*)|', $input, $matches);
$t = tempnam("/tmp/m", $matches[1]);
file_put_contents($t, $input);
