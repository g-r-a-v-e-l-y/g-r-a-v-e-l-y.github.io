// Core functions for Web Hotspots media maps
// Copyright (c) 1997-1999 1Automata  www.1automata.com
//
// Last updated December 28, 1998
//
// Licensees of the Web Hotspots software programs are granted
// rights to modify and publish this code on Web sites.
// Redistribution or resale of this code seperately from the
// Web Hotspots software is not allowed without permission of
// the copyright holder.
//
// THIS SOFTWARE IS PROVIDED "AS IS" WITHOUT ANY WARRANTY OF ANY
// KIND, EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO
// THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A
// PARTICULAR PURPOSE.  NEITHER THE PUBLISHER NOR ITS DEALERS OR
// DISTRIBUTORS ASSUMES ANY LIABILITY FOR ANY ALLEGED OR ACTUAL
// DAMAGES ARISING FROM THE USE OF OR INABILITY TO USE THIS
// SOFTWARE.



//class hsAction
//{
//      int      nDelay;
//      int      nType;
//}
//
//class hsActionFrame : hsAction
//{
//      Image    Frame;
//}
//
//class hsActionLink : hsAction
//{
//      string   sURL;
//}
//
//class hsActionRun : hsAction
//{
//      string   sCode;
//}
//
//class hsActionAudio : hsAction
//{
//      string   sAudioClip;
//}
//
//class hsActionMsg : hsAction
//{
//      string   sMsg;
//}
//
//class hsActionPlay : hsAction
//{
//      string   sPlayName;
//}
//
//class hsPlay
//{
//      string   sPlayName;
//      hsAction Actions[];
//      int      nActionCount;
//      string   sParentPlayName;
//}
//
//class hsMap
//{
//      hsPlay   Play;
//      int      nCurArea;
//      int      nCurEvent;
//}
		

// ------------------
//  hsAction classes
// ------------------

function hsactDoNothing( Img )
{
}

function hsAction( nDelay, nType )
{
	this.nDelay = nDelay;
	this.nType = nType;
	this.Do = hsactDoNothing;
}

function hsactframeDo( Img )
{
	Img.src = this.Frame.src;
}

function hsActionFrame( nDelay, sBase, sExt )
{
	this.Action = new hsAction( nDelay, 0 );
	this.Frame = new Image();
	this.Frame.src = sBase + sExt;
	this.Do = hsactframeDo;
}

function hsActionImg( nDelay, sImg )
{
	this.Action = new hsAction( nDelay, 0 );
	this.Frame = new Image();
	this.Frame.src = sImg;
	this.Do = hsactframeDo;
}

function hsactlinkDo( Img )
{
	window.location = this.sURL;
}

function hsActionLink( nDelay, sURL )
{
	this.Action = new hsAction( nDelay, 1 );
	this.sURL = sURL;
	this.Do = hsactlinkDo;
}

function hsactrunDo( Img )
{
        eval( this.sCode );
}

function hsActionRun( nDelay, sCode )
{
	this.Action = new hsAction( nDelay, 2 );
	this.sCode = sCode;
	this.Do = hsactrunDo;
}

function hsactaudioDo( Img )
{
        if //( (navigator.javaEnabled != null) &&
             (navigator.javaEnabled()) //)
		document.hsAudio.playSoundtrack( this.sAudioURL );
}

function hsActionAudio( nDelay, sURL )
{
	this.Action = new hsAction( nDelay, 3 );
	this.sAudioURL = sURL;
	this.Do = hsactaudioDo;
}

function hsactmsgDo( Img )
{
	window.status = this.sMsg; 
}

function hsActionMsg( nDelay, sMsg )
{
	this.Action = new hsAction( nDelay, 4 );
	this.sMsg = sMsg;
	this.Do = hsactmsgDo;
}

function hsactplayDo( Img )
{
        eval( this.sCode );
}

function hsActionPlay( nDelay, sCode )
{
	this.Action = new hsAction( nDelay, 5 );
	this.sCode = sCode;
	this.Do = hsactplayDo;
}


// --------------
//  hsPlay class
// --------------

function hsplayNext( Img )
{
	if (this.nCurAction >= this.nActionCount)
		return false;
	nAct = this.nCurAction;
	this.Actions[nAct].Do( Img );
	this.nCurAction++;
	if (this.nCurAction >= this.nActionCount)
		if (this.fLoop)
			this.nCurAction = 0;
	return true; //caller must schedule next action
}

function hsplayInit()
{
	this.nCurAction = 0;
}

function hsplayStart( Img )
{
	this.Init();
	if (this.GetDelay() > 0)
		return true; //caller must schedule 1st action
	return this.Next( Img );
}

function hsplayGetDelay()
{
	nDelay = 0;
	if (this.nCurAction < this.nActionCount)
		nDelay = this.Actions[this.nCurAction].Action.nDelay;
	return nDelay;
}

function hsplayIsLoop()
{
	return this.fLoop;
}

//Constructor for hsPlay class
function hsPlay( ActionList, nActionCount, fLoop )
{
	this.Actions = ActionList;
	this.nActionCount = nActionCount;
	this.nCurAction = 0;
	this.fLoop = fLoop;
	//Setup member functions
	this.Start = hsplayStart;
	this.Next = hsplayNext;
	this.GetDelay = hsplayGetDelay;
	this.IsLoop = hsplayIsLoop;
	this.Init = hsplayInit;
}


// -----------------
// Utility functions
// -----------------

function hsutilContainsProp( obj, propName ) 
//determine if obj has this property
{
        for( var i in obj )
                if (i == propName)
                        return true;
        return false;
}


// -------------
//  hsMap class
// -------------

var hsmapList = null;         //static
var hsmapListGranularity = 5; //constant static
var hsmapCount = 0;           //static
var hsmapMaxCount = 0;        //static
function hsmapResetAll()      //static
{
        for( i=0; i<hsmapCount; i++ )
                hsmapList[i].Reset();
}

function hsmapRegister( map ) //static
{
        if (hsmapCount == hsmapMaxCount)
        {
                list2 = new Array( hsmapListGranularity+hsmapMaxCount );
                if (list2 == null)
                        return;
                hsmapMaxCount = hsmapListGranularity+hsmapMaxCount;
                for( i=0; i<hsmapCount; i++ )
                        list2[i] = hsmapList[i];
                hsmapList = null;
                hsmapList = list2;
        }
        hsmapList[hsmapCount] = map;
        hsmapCount++;
}

function hsmapSetupBetterMouseOutBehaviour()  //static
{
        //find all AREA's created by HS
        //and reset thier onmouseout handlers
        n = 0;
        for( i=0; i<document.links.length; i++ )
        {
                if (hsutilContainsProp( document.links[i], 'onmouseover' ))
                {
                        s = new String( document.links[i].onmouseover );
                        if ( (s.indexOf( 'hsmap' ) >= 0) &&
                             (s.indexOf( '.Start' ) >= 0) )
                        {
                                document.links[i].onmouseout = hsmapResetAll;
                                n++;
                        }
                        s = null;
                }
        }
        return n;
}

function hsmapGetDelay()
{
	nDelay = this.Play.GetDelay();
	if (nDelay < 10)
		return 10;
	return nDelay;
}

function hsmapNext()
{
	if (this.Img == null)
		return;
        this.fTimeoutPending = false;
        if (this.Play.Next( this.Img ))
		this.ScheduleTimeout();
}

function hsmapCancelTimeout()
{
	if (this.fTimeoutPending)
		clearTimeout( this.timeoutID );
        this.fTimeoutPending = false;
        this.timeoutID = null;
}

function hsmapScheduleTimeout()
{
        this.CancelTimeout();
	this.fTimeoutPending = true;
	this.timeoutID = setTimeout( this.sCode, this.GetDelay() );
}

function hsOnLoadCatch()
{
        //(in a previous version, onLoad event of img was used
	//to schedule actions.  This functionality is disabled
        //by this stub)
}

function hsmap1stOnLoad()
{
        //(this function is called on the image's first onload event)
	if (this.Img == null)
                return 500; //(should never happen)
	this.Img.hsMap = this;
        this.Img.onload = hsOnLoadCatch; //catch further onload's
	this.GetDelay = hsmapGetDelay;
        hsmapSetupBetterMouseOutBehaviour(); //reset each areas's onmouseout
	return this.GetDelay();
}

function hsmapTriggerPlay( P )
{
        this.CancelTimeout();
        this.nCurArea = -100;
        this.nCurEvent = -100;
	this.Play = P;
	if (P.Start( this.Img ))
		this.ScheduleTimeout();
	return true;
}

function hsmapStart( P, nArea, nEvent )
{
	if (this.Img == null)
		return true;
	if ( (this.nCurArea == nArea) && 
         (this.nCurEvent == nEvent) &&
         (this.Play != null) &&
         (this.Play.IsLoop()) )
		return true;
        this.CancelTimeout();
	this.nCurArea = nArea;
	this.nCurEvent = nEvent;
	this.Play = P;
	if (P.Start( this.Img ))
		this.ScheduleTimeout();
	return true;
}

function hsmapReset()
{
        if ( (this.nCurArea == -1) && 
             (this.nCurEvent == 0) )
                return;
        this.CancelTimeout();
        this.nCurArea = -1;
        this.nCurEvent = 0;
        this.Play = this.LoadPlay;
	this.fTimeoutPending = true;
        this.Play.Init();
        nTime = 100;
        if (nTime < this.GetDelay())
                nTime = this.GetDelay();
        this.timeoutID = setTimeout( this.sCode, nTime );
}

//Constructor for hsMap class
function hsMap( LoadPlay, sCode )
{
        this.LoadPlay = LoadPlay;
	this.Play = LoadPlay;
	this.nCurArea = -1;
	this.nCurEvent = 0;
	this.sCode = sCode;
	this.Img = null;
	this.timeoutID = null;
	this.fTimeoutPending = false;
	//Setup member functions
	this.Start = hsmapStart;
	this.Next = hsmapNext;
	this.GetDelay = hsmap1stOnLoad;
	this.ScheduleTimeout = hsmapScheduleTimeout;
        this.CancelTimeout = hsmapCancelTimeout;
        this.Reset = hsmapReset;
        this.TriggerPlay = hsmapTriggerPlay;
        //
        hsmapRegister( this );
}
////////////////////


function hsOnLoad( img, code, map )
{
	map.Img = img;
	setTimeout( code, map.GetDelay() );
}

