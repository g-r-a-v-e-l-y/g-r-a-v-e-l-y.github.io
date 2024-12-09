#!/usr/bin/perl

############################################
##                                        ##
##                 WebLog                 ##
##           by Darryl Burgdorf           ##
##                                        ##
##           Configuration File           ##
##                                        ##
############################################

require "weblog.pl";

$LogFile = "/var/log/httpd-access.log.*";
$IPLog = "";

$FileDir = "/usr/local/www/data/pb/private/";
$ReportFile = "../private/log.html";
$DetailsFile = "../private/logdetails.html";
$RefsFile = "../private/logrefs.html";
$KeywordsFile = "../private/logkeys.html";
$AgentsFile = "../private/logagents.html";

$EOMFile = "../private/logeom.html";

$SystemName = "plan:b";

$OrgName = "plan:b";
$OrgDomain = '(plan-b.n3.net)';

$GraphURL = "http://129.100.108.56/pb/private/";
$GraphBase = "visits";

# $IncludeOnlyRefsTo = '(includethis|andthis)';
# $ExcludeRefsTo = '(excludethis|andthis)';

# $IncludeOnlyDomain = '';
# $ExcludeDomain = '';

$IncludeQuery = 0;

$PrintFiles = 1;
$Print404 = 1;
$PrintDomains = 0;
$PrintUserIDs = 0;
$PrintTopNFiles = 10;
$TopFileListFilter = '(\.gif|\.jpg|\.jpeg|Code)';
$PrintTopNDomains = 0;

$LogOnlyNew = 1;

$NoSessions = 0;
$NoResolve = 0;

$HourOffset = 0;

$DetailsFilter = '(\.gif|\.jpg|\.jpeg)';
$DetailsDays = 7;

$refsexcludefrom = '(file:)';
$refsexcludeto = '(\.gif|\.jpg|\.jpeg)';

$RefsStripWWW = 1;
$RefsMinHits = 1;
$TopNRefDoms = 10;

$AgentsIgnore = '(\.gif|\.jpg|\.jpeg)';

$Verbose = 1;

$bodyspec = "BGCOLOR=\"#ffffff\" TEXT=\"#000000\"";

$headerfile = "/usr/local/www/data/pb/private/header.html";
$footerfile = "";

$TotalReset = 0;

&MainProg;
