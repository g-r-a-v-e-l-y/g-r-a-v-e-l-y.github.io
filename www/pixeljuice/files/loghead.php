<? include ("files/themeSwap.php"); ?>
<!doctype html public "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<head>
<title>pixeljuice logs</title>
<link rel="StyleSheet" href="<?=$stylesheet;?>" type="text/css" media="all">
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

<body>

  <div id="wrapper">
    <?PHP include("files/SiteNav.php")?>
    <div id="pagetitle">
       <b>pixeljuice</b>
    </div>
    <div id="main">