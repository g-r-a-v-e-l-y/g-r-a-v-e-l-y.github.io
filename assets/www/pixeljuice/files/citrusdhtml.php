<style type="text/css">
<!--

a.dhtmlink:link {
 color : black;
 text-decoration : none;
 font-family : Verdana, Geneva, Arial, Helvetica, sans-serif;
 background-color : #fff6d3;
 font-size : 11px;
}

a.dhtmlink:visited {
 color : black;
 text-decoration : none;
 font-family : Verdana, Geneva, Arial, Helvetica, sans-serif;
 background-color : #fff6d3;
  font-size : 11px;
}
a.dhtmlink:active {
 color : orange;
 text-decoration : none;
 font-family : Verdana, Geneva, Arial, Helvetica, sans-serif;
 background-color : #fff6d3;
  font-size : 11px;
}

a.dhtmlink:hover {
 color : black;
 text-decoration : underline;
 font-family : Verdana, Geneva, Arial, Helvetica, sans-serif;
 background-color : #fff6d3;
  font-size : 11px;
}

    #navigationHeaderHide {
        display: none;
        position: relative;
	    float : right;
		z-index : 3;
		padding : 8px 6px 0 0;
    }
    #navigationHeaderShow {
        display : block;
        position: relative;
	    float : right;
		z-index : 3;
		padding : 8px 6px 0 0;
    }
#navigationWindow {
  position : relative;
  top : 0px;
  background-color : #fff6d3;
  color : #606060;
  font-family : Verdana, Geneva, Arial, Helvetica, sans-serif;
  font-size : 12px;
  line-height : normal;
  border-top: 2px dashed black;
  border-right : 2px dashed black;
  border-left : 2px dashed black;
  border-bottom : 1px solid black;
  padding : 0 0 0 0;
  width : 100%;
  display : block;
  overflow : hidden;
  height : 35px;
}
.citrusonly {
padding-top : 20px;
}
-->
</style>
<!--Porter Glendinning's sweet dhtml hider/shower -->
<script type="text/javascript">
<!--
    function ShowWindow(windowName) {

        var windowObj   = document.getElementById(windowName + "Window");
        var hideLinkObj = document.getElementById(windowName + "HeaderHide");
        var showLinkObj = document.getElementById(windowName + "HeaderShow");

        windowObj.style.height   = "auto";
        hideLinkObj.style.display = "block";
        showLinkObj.style.display = "none";

    }

    function HideWindow(windowName) {

        var windowObj   = document.getElementById(windowName + "Window");
        var hideLinkObj = document.getElementById(windowName + "HeaderHide");
        var showLinkObj = document.getElementById(windowName + "HeaderShow");

        windowObj.style.height   = "35px";
        showLinkObj.style.display = "block";
		hideLinkObj.style.display = "none";

    }
//-->
</script>
