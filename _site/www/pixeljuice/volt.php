<?php include ("files/themeSwap.php") ?>
<!doctype html public "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html>
<head>
<link rel="StyleSheet" href="<?PHP echo $stylesheet; ?>" type="text/css" media="all">
<?php if ($current == citrus) include("files/citrusDhtml.php"); ?>
<meta http-equiv="expires" content="-1">
<script type="text/javascript">
<!--
function dojump_theme()
{
	if (document.forms["theme"].theme.options[document.forms["theme"].theme.selectedIndex].value != "none")
	{
		self.location = document.forms["theme"].theme.options[document.forms["theme"].theme.selectedIndex].value;
	}
}
//-->
</script>
</head>
<body>
  <div id="wrapper">
    <?PHP include("files/SiteNav.php")?>
    <div id="pagetitle">
    <b>Volt Poster</b><br><br>
    </div>
    <div id="main"><br><br>
	<a href="images/volt_med.jpg"><img border="0" src="images/volt_sm.jpg" alt="click for the next size up"></a>
    </div>
  </div>
</body>
</html>

