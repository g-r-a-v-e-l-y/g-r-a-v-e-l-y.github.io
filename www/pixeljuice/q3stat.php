<?php
	// q3statPHP - v0.2
	// by dan@d-an.net
require("includes/class.FastTemplate.php3");

// Location of qstat
$qstat = '/usr/local/bin/qstat';

// File containing servers to stat
$serverFile = 'qservers.txt';

// Default server type, Quake3
if (!isset($servtype)) $servtype = "q3s";

$serverinfo = "";
$players = "";

function statServer() {
	global $server, $servtype, $qstat, $serverinfo, $players;
	
	$server = escapeshellcmd($server);
	
	$i = 0;
	$y = 0;
        $x = 0;
	
	// Run program
	$info = `$qstat -sort F -raw , -P -$servtype $server`;
	// Replace new-lines with commas
	$info = ereg_replace("\n", ",", $info);
	// Make $a an array
	$info = explode(",", $info);

	// Check to see if server is running
	if (($info[2] == 'ERROR') || ($info[2] == 'DOWN')) {
		$serverinfo = "<td>Server down or not responding: ".$info[2]."</td>\n";
		$players = "<tr>\n<td class=\"box\">ERROR</td>\n</tr>\n";
		return;
	}
	
	// Parse server info
	for($i = 1; $i <= 7; $i++) {
		$serverinfo .= "<td>".htmlspecialchars($info[$i])."</td>\n";
	}

	// Parse player info
	for($i = 8; $i <= count($info);) {
		$players .= "<tr>\n";
		for($y = 0; $y <= 2; $y++) {
		        if ($x % 2) {
				$players .= "<td class=\"other\"> ".htmlspecialchars($info[$i])." </td>\n";
			} else {
				$players .= "<td> ".htmlspecialchars($info[$i])." </td>\n";
			}
			$i++;
		}
		$players .= "</tr>\n";
		$x++;
	}
	return;
}
function checkFile() {
	global $serverFile, $PHP_SELF;
	// Check if file exists
	if (is_readable($serverFile)) {
		// Put file into array
		$slist = file($serverFile);
		for($i = 0; $i < count($slist); $i++) {
			$slist[$i] = ereg_replace("\n", "", $slist[$i]);
			$serverlist .= "<a href=\"".$PHP_SELF."?server=".$slist[$i]."\">".$slist[$i]."</a><br>\n";
		}
	}
	return $serverlist;
}

$tpl = new FastTemplate("./templates");
$tpl->define(array(main => "q3stat.tpl",
		   slist => "q3statl.tpl"
		   ));

if(isset($server)) {
	statServer();
	
	$tpl->assign(array(
		TITLE => "Q3Stat / ".$server,
		SERVERINFO => $serverinfo,
		PLAYERS => $players
	));
	$tpl->parse(MAIN, "main");
} else {
	$serverlist = checkFile();
	$tpl->assign(array(
		TITLE => "Q3Stat",
		SERVERLIST => $serverlist
	));
	$tpl->parse(SLIST, "slist");
}	
$tpl->FastPrint();

exit();

?>
