<?php require ("spyGrabber.php") ?>
<?php include ("files/themeSwap.php") ?>
<!doctype html public "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<head>
<title>
P-JUICE - Spy Beta Stuff
</title>
<link rel="StyleSheet" href="<?php echo $stylesheet; ?>" type="text/css" media="all">
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
    <?php include ("files/SiteNav.php")?>
      <div id="pagetitle">
        <b>Spy on Grant (beta)</b>
      </div>
      <div id="main">
        <p>
        Work on the new automated spy script.. totally beta and likely to have php errors all over the place :)
        </p>
        <p>Here's the snagged spy thumbnail, which should link to the full deal:</p><p align=center><?php echo $spyTime ?></p>
<div align="center"><a href="/spy/spy.jpg"><img src="/spy/thumbs/spy.jpg" border="0"></a></div>

        <p>The actual code looks like this:</p>
        <?php show_source ("spyGrabber.php") ?>
        </p>and this pages source looks like this:</p>
        <?php show_source ("spy.php") ?>
</div>
</div>
</body>
</html>

