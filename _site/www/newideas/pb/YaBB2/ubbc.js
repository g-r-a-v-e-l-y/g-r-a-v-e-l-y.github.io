function WhichClicked(ww) {
	window.document.postmodify.waction.value = ww;
}

function submitonce(theform) {
	// if IE 4+ or NS 6+
	if (document.all || document.getElementById) {
		// hunt down "submit" and "reset"
		for (i=0;i<theform.length;i++) {
			var tempobj=theform.elements[i];
			if(tempobj.type.toLowerCase()=="submit"||tempobj.type.toLowerCase()=="reset") {
				//disable it
				tempobj.disabled=true;
			}
		}
	}
}

function AddText(NewCode) {
	document.postmodify.message.value+=NewCode;
	document.postmodify.message.focus();
}

function teletype() {
	AddTxt="[tt][/tt]";
	AddText(AddTxt);
}

function right() {
	AddTxt="[right][/right]";
	AddText(AddTxt);
}

function left() {
	AddTxt="[left][/left]";
	AddText(AddTxt);
}

function superscript() {
	AddTxt="[sup][/sup]";
	AddText(AddTxt);
}

function subscript() {
	AddTxt="[sub][/sub]";
	AddText(AddTxt);
}

function image() {
	AddTxt="[img][/img]";
	AddText(AddTxt);
}

function ftp() {
	AddTxt="[ftp][/ftp]";
	AddText(AddTxt);
}

function move() {
	AddTxt="[move][/move]";
	AddText(AddTxt);
}

function shadow() {
	AddTxt="[shadow=color,direction,width][/shadow]";
	AddText(AddTxt);
}

function glow() {
	AddTxt="[glow=color,strength,width][/glow]";
	AddText(AddTxt);
}

function flash() {
	AddTxt="[flash=width,height][/flash]";
	AddText(AddTxt);
}

function pre() {
	AddTxt="[pre][/pre]";
	AddText(AddTxt);
}

function tcol() {
	AddTxt="[td][/td]";
	AddText(AddTxt);
}

function trow() {
	AddTxt="[tr][/tr]";
	AddText(AddTxt);
}

function table() {
	AddTxt="[table][tr][td][/td][/tr][/table]";
	AddText(AddTxt);
}

function strike() {
	AddTxt="[s][/s]";
	AddText(AddTxt);
}

function underline() {
	AddTxt="[u][/u]";
	AddText(AddTxt);
}

function emai1() {
	AddTxt="[email][/email]";
	AddText(AddTxt);
}

function bold() {
	AddTxt="[b][/b]";
	AddText(AddTxt);
}

function italicize() {
	AddTxt="[i][/i]";
	AddText(AddTxt);
}

function quote() {
	AddTxt="[quote][/quote]";
	AddText(AddTxt);
}

function center() {
	AddTxt="[center][/center]";
	AddText(AddTxt);
}

function hyperlink() {
	AddTxt="[url][/url]";
	AddText(AddTxt);
}

function showcode() {
	AddTxt="[code][/code]";
	AddText(AddTxt);
}

function list() {
	AddTxt="[list][*][*][*][/list]";
	AddText(AddTxt);
}

function showcolor(color) {
	AddTxt="[color="+color+"][/color]";
	AddText(AddTxt);
}

function smiley() {
	AddTxt=":)";
	AddText(AddTxt);
}

function wink() {
	AddTxt=";)";
	AddText(AddTxt);
}

function cheesy() {
	AddTxt=":D";
	AddText(AddTxt);
}

function grin() {
	AddTxt=";D";
	AddText(AddTxt);
}

function angry() {
	AddTxt=">:(";
	AddText(AddTxt);
}

function sad() {
	AddTxt=":(";
	AddText(AddTxt);
}

function shocked() {
	AddTxt=":o";
	AddText(AddTxt);
}

function cool() {
	AddTxt="8)";
	AddText(AddTxt);
}

function huh() {
	AddTxt="???";
	AddText(AddTxt);
}

function rolleyes() {
	AddTxt="::)";
	AddText(AddTxt);
}

function tongue() {
	AddTxt=":P";
	AddText(AddTxt);
}