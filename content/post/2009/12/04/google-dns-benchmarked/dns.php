<?php

require_once 'Net/DNS.php';

$domainlist = 'Quantcast-Top-Million.txt';

$logfile    = 'results.log';
$dnslogfile = 'dns.log';

function add_dns_server($addr) {
	$resolver = new Net_DNS_Resolver();
	$resolver->nameservers = array( $addr );
	return $resolver;
}

$servers = array(
//	add_dns_server('192.168.0.1'),    // My Router

	add_dns_server('8.8.8.8'),        // Google 1
	add_dns_server('8.8.4.4'),        // Google 2

	add_dns_server('208.67.222.222'), // OpenDNS 1
	add_dns_server('208.67.220.220'), // OpenDNS 2

	add_dns_server('90.207.238.97'), // Easynet 1 (5acfee61.bb.sky.com)
	add_dns_server('90.207.238.99'), // Easynet 2 (5acfee63.bb.sky.com)

	add_dns_server('212.159.11.150'), // Plus.net 1 (ns1.plus.net)
	add_dns_server('212.159.13.150'), // Plus.net 2 (ns2.plus.net)
);

function print_headers($servers) {
	$ret = "Domain\tIteration";
	foreach ($servers as $server)
		$ret .= "\t" . $server->nameservers[0];
	
	return $ret . "\n";
}

function microtime_used($before, $after) {
	list($ausec, $asec) = explode(' ', $after);
	list($busec, $bsec) = explode(' ', $before);

	// Drop the . on usec
	$ausec = (int)substr($ausec, 2, 6);
	$busec = (int)substr($busec, 2, 6);

	$secdiff  = $asec-$bsec;
	$usecdiff = $ausec-$busec;

	return $secdiff * 1000000 + $usecdiff;
}

$domainlist = @fopen($domainlist, 'r');
if (!$domainlist)
	exit('Unable to open domain list');

// Skip the headers
while (!feof($domainlist)) {
	$line = fgets($domainlist);

	if (strpos($line, "\t") !== false)
		break;
}

$logfile = @fopen($logfile, 'w');
if (!$logfile)
	exit('logfile to open log file');
	
$dnslogfile = @fopen($dnslogfile, 'w');
if (!$dnslogfile)
	exit('logfile to open dns log file');


fwrite($logfile, print_headers($servers) );

$count = 0;

while (!feof($domainlist)) {
	$line = trim(fgets($domainlist));
	list($index, $domain) = explode("\t", $line, 2);
	
	$count++;
	echo $domain . ' ' . $count . "\n";

	// Do each lookup 3 times
	for ($i = 0; $i < 3; $i++) {
		$result = $domain . "\t" . $i;

		foreach ($servers as $server) {
			// This is odd, if I don't call microtime() twice, the first time around the $i = 0 loop it takes a extra ~0.3sec
			$start = microtime();
			$start = microtime();
			$record = $server->rawQuery($domain, 'A', 'IN');
			$end = microtime();

			if ($record) {
				$time   = microtime_used($start, $end);
				$record = $record->string();
			} else {
				$time   = -1;
				$record =';; Error';
			}

			// Store a copy of the result
			fwrite($dnslogfile, ';; Timestamp ' . $start . "\n" . $record );

			$result .= "\t" . $time;
		}

		fwrite($logfile, $result . "\n");
	}
}

fclose($dnslogfile);
fclose($logfile);
fclose($domainlist);


?>