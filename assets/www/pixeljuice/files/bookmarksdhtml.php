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
    
    #folderHeaderHide {
        display: none;
        position: relative;
	    float : right;
		z-index : 3;
		padding : 8px 6px 0 0;
    }
    #folderHeaderShow {
        display : block;
        position: relative;
	    float : right;
		z-index : 3;
		padding : 8px 6px 0 0;				
    }
#folderWindow {
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
<script language="JavaScript" type="text/javascript">
<!--
    function Showfolder(folderName) {
    
        var folderObj   = document.getElementById(folderName + "Folder");
        var hideDirObj = document.getElementById(folderName + "DirHide");
        var showdirObj = document.getElementById(folderName + "DirShow");
        
        olderObj.style.display   = "block";
        hideDirObj.style.display = "block";
        showDirObj.style.display = "none";

    }
    
    function Hidefolder(folderName) {
    
        var folderObj   = document.getElementById(folderName + "Folder");
        var hideDirObj = document.getElementById(folderName + "DirHide");
        var showdirObj = document.getElementById(folderName + "DirShow");
        
        folderObj.style.display   = "none";
        hideDirObj.style.display = "block";
        showDirObj.style.display = "none";
        
    }
//-->
</script>
