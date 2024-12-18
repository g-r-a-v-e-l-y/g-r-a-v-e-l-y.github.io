var sRepeat=null
function doMarquee(dir, src, amount) {
 if (window.document.readyState=="loading") 
   alert("Please wait until the page is finished loading.")
 // Amount is optional - default to 10 if not specified
 if (amount==null) amount=10
 // For each direction, increment and check if to start over
 switch (dir) {
  case "up":
    document.all[src].style.pixelTop-=amount
    if (-document.all[src].style.pixelTop>=document.all[src].offsetHeight)
     document.all[src].style.pixelTop=document.all[src].offsetParent.offsetHeight
    break;
  case "down":
    document.all[src].style.pixelTop+=amount
    if (document.all[src].style.pixelTop>document.all[src].offsetParent.offsetHeight)
     document.all[src].style.pixelTop = -document.all[src].offsetHeight
    break;
  case "left":
    document.all[src].style.pixelLeft-=amount
    if (-document.all[src].style.pixelLeft>=document.all[src].offsetWidth)
     document.all[src].style.pixelLeft=document.all[src].offsetParent.offsetWidth
    break;
  case "right":
    document.all[src].style.pixelLeft+=amount
    if (document.all[src].style.pixelLeft>document.all[src].offsetParent.offsetWidth)
      document.all[src].style.pixelLeft = -document.all[src].offsetWidth
    break;
 }
}
