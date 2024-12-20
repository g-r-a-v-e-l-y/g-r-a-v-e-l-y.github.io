<?php $filelocation="/pixeljuice/index.php"; ?>
<form id="themedrop" name="theme" method="get">
<select name="theme" onChange="dojump_theme()">
  <option value="#">themes</option>
    <optgroup label="simple">
      <option value="<?php echo "$filelocation" ?>?theme=none">none</option>
      <option value="<?php echo "$filelocation" ?>?theme=default">default</option>
    </optgroup>
    <optgroup label="risky">
      <option value="<?php echo "$filelocation" ?>?theme=citrus">citrus</option>
      <option value="<?php echo "$filelocation" ?>?theme=thrashy">thrashy</option>
	    <option value="<?php echo "$filelocation" ?>?theme=yours">yours</option>
	    <option value="<?php echo "$filelocation" ?>?theme=hack">haxor</option>
	    <option value="<?php echo "$filelocation" ?>?theme=ab">ab.com</option>
<option value="<?php echo "$filelocation" ?>?theme=outerbody">outerbody</option>    </optgroup>
</select>
</form>
