<?
if (empty($theme))
  {
  $theme = "default";
  }
setcookie ("theme", "$theme", time()+8640000);
$current = $theme;
include ("files/themes/$theme.theme.php");
?>
