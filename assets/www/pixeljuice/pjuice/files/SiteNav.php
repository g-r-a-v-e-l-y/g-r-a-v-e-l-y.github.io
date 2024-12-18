<?php $filelocation=$PHP_SELF; ?>
<p class="ahem">
  <big>I used to have a big paragraph here inviting netscape users to upgrade, but if you are for some reason stuck using nn4 still, I'm not going to rub it in. Those of you using w3m or lynx, disregard this message :)</big>
</p>
<a href="/index.php">
  <img class="logo" src="/images/pjuice.gif" alt="Pixeljuice.dhs.org" <?php if ( $theme == "ab") {print "width=304 height=304"; }?>></a>
  <?php if ($theme == "meaw" ) {print "<div id=kru>All meaw all the time</div>"; } ?>

<div id="<?php if ($theme == "citrus" ) {print "navigationWindow";} else {print "navigation";} ?>">
<?php if ($theme == "citrus" ) {print " <div id=\"navigationHeaderShow\"><a class=\"dhtmlink\" href=\"javascript:;ShowWindow('navigation');\">show navigation</a></div>
<div id=\"navigationHeaderHide\"><a class=\"dhtmlink\" href=\"javascript:;HideWindow('navigation');\">hide navigation</a></div>"; } ?>
  <p class="navpadding">

     <?php if (( $theme == "none" ) or ( $theme == "default" ) or ( $theme == "ab" )) { print "<br>"; } ?>
<?php if ( $theme == "ab") {print "Pixeljuice navigation:";} ?>
     <?php if (( $theme == "none" ) or ( $theme == "default" ) or ( $theme == "ab" )) { print "<br>"; } ?>
        
 <a class="nav"
      onmouseover="window.status='Contact the webmaster...'; return true;"
      onMouseOut="window.status=''; return true;" title="Contact the webmaster..."
      href="/contact.php">contact</a>
<?php if ( $theme == "citrus" ) {echo " <b>,</b> "; } ?>
    <?php if ( $theme == thrashy ) {echo " <b class=navb>|</b> "; } ?>
<?php if ( $theme =="roman" ) {echo "  /  "; } ?>
      <?php if (( $theme == "none" )  or ( $theme == "default" ) or ( $theme == "ab" )) { print "<br>"; } ?>

	<a class="nav" onmouseover="window.status='spy on grant - see whats up lately...'; return true;"
			onmouseOut="window.status=''; return true;" title="spy on grant - see what's up lately..."
			href="/spy.php">spy</a>
	<?php if (( $theme == "non" ) or ( $theme == "default") or ( $theme == "ab" ) or ( $theme == "meaw" )) { print "<br>"; } ?>
	<?php if ( $theme == "citrus" ) {echo " <b>,</b>"; } ?>
	<?php if ($theme =="roman" ) { echo " / "; } ?>
	<?php if ($theme =="thrashy" ) {echo " <b class=navb>|</b> "; } ?>


        <a class="nav"
          onmouseover="window.status='Skins & themes'; return true;"
          onMouseOut="window.status=''; return true;" title="Skins &amp; themes"
        href="/files.php">files</a>
    <?php if (( $theme == "none" ) or ( $theme == "default" ) or ( $theme == "ab" )  or( $theme == "meaw" )) { print "<br>"; } ?>
    <?php if ( $theme == "citrus" ) {echo " <b>,</b> "; } ?>
    <?php if ( $theme =="roman" ) {echo "  /  "; } ?>

    <?php if ( $theme == thrashy ) {echo " <b class=navb>|</b> "; } ?>
       <a class="nav"
                  onmouseover="window.status='Some of my past work'; return true;"
                  onMouseOut="window.status=''; return true;" title="Some of my past work"
       href="/beginnings.php">past work</a>

<?php if ( $theme == "ab" ) { echo "<br><br>css stolen from:<br><a class=nav href=http://aaronbarnett.com/ target=_blank>aaronbarnett.com</a><br>"; } ?>
    <?php if (( $theme == "none" ) or ( $theme == "default" ) or ( $theme == "ab" )  or( $theme == "meaw" )) { print "<br>"; } ?>
<?php if ( $theme =="roman" ) {echo "  /  "; } ?>
<a class="copyright" href=#
                  onmouseover="window.status='Copyright &copy; 1999-2001, pixeljuice. All rights reserved'; return true;"
                  onMouseOut="window.status=''; return true;" title="Copyright &copy; 1999-2001, pixeljuice. All rights reserved">&copy;</a></p>

 </div>
<?php include("files/themeDrop.php")?>


