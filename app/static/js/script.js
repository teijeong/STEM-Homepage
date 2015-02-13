/********************************* 브라우저 타이틀 변경 ***************************/
top.document.title = ':: 우수학생센터 공우 ::'
/********************************* 브라우저 타이틀 변경 ***************************/

/********************************* 플래시 투명 ***************************/
function Flash( src,src2,width,height )
{
    var useragent = navigator.userAgent;
    var html = '';

    var isFlash = enabledFlash() ;
    if(isFlash ) {
        html += '    <object type="application/x-shockwave-flash" classid="clsid:d27cdb6e-ae6d-11cf-96b8-444553540000" codebase="http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=7,0,0,0" id="param" width="'+width+'" height="'+height+'">' ;
        html += '    <param name="movie" value="'+src+'">' ;
        html += '    <param name="quality" value="high">' ;
        html += '    <param name="bgcolor" value="#ffffff">';
        html  +='    <param name="wmode" value="transparent">';
        html += '    <param name="swliveconnect" value="true">';            
        html += '    </object>' ;
    }else{
        html += '    <object type="application/x-shockwave-flash" data="'+src+'" width="'+width+'" height="'+height+'" id="param">' ;
        html += '    <param name="wmode" value="transparent" />' ;    
        html += '    <img src="'+src2+'" alt="" />' ;
        html += '    </object>' ;        
    }
 
 document.write(html);
}


function enabledFlash(){
    if(navigator.appName=="Microsoft Internet Explorer" ) {
        return true ;
    }
    
    var uagent = navigator.userAgent.toLocaleLowerCase();

    if(uagent.indexOf("iphone") > -1  || uagent.indexOf("ipod") > -1 || uagent.indexOf("ipad") > -1){
        return false ;
    }
    if(uagent.indexOf("firefox") > -1){
        return false ;
    }

    if(uagent.indexOf("chrome") > -1){
        return false ;
    }
    
    if(uagent.indexOf("opera") > -1){
        return false ;
    }    
    return false;
}
/********************************* 플래시 투명 ***************************/


/********************************* 롤 오버 스크립트 ***************************/
function MM_swapImgRestore() { //v3.0
  var i,x,a=document.MM_sr; for(i=0;a&&i<a.length&&(x=a[i])&&x.oSrc;i++) x.src=x.oSrc;
}

function MM_preloadImages() { //v3.0
  var d=document; if(d.images){ if(!d.MM_p) d.MM_p=new Array();
    var i,j=d.MM_p.length,a=MM_preloadImages.arguments; for(i=0; i<a.length; i++)
    if (a[i].indexOf("#")!=0){ d.MM_p[j]=new Image; d.MM_p[j++].src=a[i];}}
}

function MM_findObj(n, d) { //v4.01
  var p,i,x;  if(!d) d=document; if((p=n.indexOf("?"))>0&&parent.frames.length) {
    d=parent.frames[n.substring(p+1)].document; n=n.substring(0,p);}
  if(!(x=d[n])&&d.all) x=d.all[n]; for (i=0;!x&&i<d.forms.length;i++) x=d.forms[i][n];
  for(i=0;!x&&d.layers&&i<d.layers.length;i++) x=MM_findObj(n,d.layers[i].document);
  if(!x && d.getElementById) x=d.getElementById(n); return x;
}

function MM_swapImage() { //v3.0
  var i,j=0,x,a=MM_swapImage.arguments; document.MM_sr=new Array; for(i=0;i<(a.length-2);i+=3)
   if ((x=MM_findObj(a[i]))!=null){document.MM_sr[j++]=x; if(!x.oSrc) x.oSrc=x.src; x.src=a[i+2];}
}
/********************************* 롤 오버 스크립트 ***************************/

//링크 클릭시 점선 없애는 소스
function bluring(){
  if(event.srcElement.tagName=="A"||event.srcElement.tagName=="IMG") document.body.focus();
  
}
document.onfocusin=bluring;

/********************************* 오픈브라우져 ***************************/
function MM_openBrWindow(theURL,winName,features) { //v2.0
  window.open(theURL,winName,features);
}
/********************************* 오픈브라우져 ***************************/

/**********************************************************************************
 PNG 파일 Explore6.0
***********************************************************************************/

    function setPng24(obj) {
        obj.width=obj.height=1;
        obj.className=obj.className.replace(/\bpng24\b/i,'');
        obj.style.filter =
        "progid:DXImageTransform.Microsoft.AlphaImageLoader(src='"+ obj.src +"',sizingMethod='image');"
        obj.src=''; 
        return '';
    }

/********************************* 탭관련 ***************************/
function mtab(n) {
 document.getElementById('mtab'+n).style.display = "block";
    for(var i = 1; i < 6; i++) {
        obj = document.getElementById('mtab'+i);
      //  img = document.getElementById('mtab_button'+i);
        if ( n != i ) {
            obj.style.display = "none";   
          //  img.src = "mainimg/check_0"+i+"on.gif";            
        }
    }
}

/********************************* 탭관련 ***************************/

/* 레이어 새창 스크립트 */
function view_area(area){
        if ("popindi" == area) {
            //closeAll_MPop();
            document.getElementById("popindi").style.display="";
            document.getElementById("popyak").style.display="none";
        } else if ("popyak" == area) {
            document.getElementById("popyak").style.display="";
            document.getElementById("popindi").style.display="none";
        }
    }
    
    function closeAll_MPop(){
        document.getElementById("mpop3").style.display="none";
        document.getElementById("mpop4").style.display="none";
        document.getElementById("mpop5_1").style.display="none";
        document.getElementById("mpop5_2").style.display="";
        document.getElementById("mpop5_3").style.display="none";
        document.getElementById("mpop6_1").style.display="none";
        document.getElementById("mpop6_2").style.display="none";
        document.getElementById("mpop6_3").style.display="none";
        document.getElementById("mpop6_4").style.display="none";
        document.getElementById("mpop6_5").style.display="none";
        document.getElementById("mpop7").style.display="none";
    }

    function view_MPop(id){
        closeAll_MPop();
        document.getElementById(id).style.display="";
    }

    function close_area(area){
        document.getElementById(area).style.display="none";
    }

/* 인풋 bg */
function 
    clrImg(obj){
        obj.style.backgroundImage="";obj.onkeydown=obj.onmousedown=null;
    }

/********************************* 레이어 롤 오버 스크립트 ***************************/
function MM_reloadPage(init) {  //reloads the window if Nav4 resized
  if (init==true) with (navigator) {if ((appName=="Netscape")&&(parseInt(appVersion)==4)) {
    document.MM_pgW=innerWidth; document.MM_pgH=innerHeight; onresize=MM_reloadPage; }}
  else if (innerWidth!=document.MM_pgW || innerHeight!=document.MM_pgH) location.reload();
}
MM_reloadPage(true);
/********************************* 레이어 롤 오버 스크립트 ***************************/




/********************************* Left Menu Over *******************************/ 
function MM_nbGroup(event, grpName) { //v3.0
var i,img,nbArr,args=MM_nbGroup.arguments;
if (event == "init" && args.length > 2) {
if ((img = MM_findObj(args[2])) != null && !img.MM_init) {
img.MM_init = true; img.MM_up = args[3]; img.MM_dn = img.src;
if ((nbArr = document[grpName]) == null) nbArr = document[grpName] = new Array();
nbArr[nbArr.length] = img;
for (i=4; i < args.length-1; i+=2) if ((img = MM_findObj(args[i])) != null) {
if (!img.MM_up) img.MM_up = img.src;
img.src = img.MM_dn = args[i+1];
nbArr[nbArr.length] = img;
} }
} else if (event == "over") {
document.MM_nbOver = nbArr = new Array();
for (i=1; i < args.length-1; i+=3) if ((img = MM_findObj(args[i])) != null) {
if (!img.MM_up) img.MM_up = img.src;
img.src = (img.MM_dn && args[i+2]) ? args[i+2] : args[i+1];
nbArr[nbArr.length] = img;
}
} else if (event == "out" ) {
for (i=0; i < document.MM_nbOver.length; i++) {
img = document.MM_nbOver[i]; img.src = (img.MM_dn) ? img.MM_dn : img.MM_up; }
} else if (event == "down") {
if ((nbArr = document[grpName]) != null)
for (i=0; i < nbArr.length; i++) { img=nbArr[i]; img.src = img.MM_up; img.MM_dn = 0; }
document[grpName] = nbArr = new Array();
for (i=2; i < args.length-1; i+=2) if ((img = MM_findObj(args[i])) != null) {
if (!img.MM_up) img.MM_up = img.src;
img.src = img.MM_dn = args[i+1];
nbArr[nbArr.length] = img;
} }
}

function MM_showHideLayers() { //v6.0
  var i,p,v,obj,args=MM_showHideLayers.arguments;
  for (i=0; i<(args.length-2); i+=3) if ((obj=MM_findObj(args[i]))!=null) { v=args[i+2];
    if (obj.style) { obj=obj.style; v=(v=='show')?'visible':(v=='hide')?'hidden':v; }
    obj.visibility=v; }
}
/********************************* Left Menu Over *******************************/ 