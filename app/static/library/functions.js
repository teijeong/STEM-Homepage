function MainItemSearchGo(){
    if ( document.mainSearch.itemsearchStr.value.length==0 || document.mainSearch.itemsearchStr.value.length<1 ){
        alert("검색어를 입력해주세요.\n검색어는 1자이상 입력해주세요.");
        document.mainSearch.itemsearchStr.focus();
        return ;
    }
    document.mainSearch.submit();
}

function viewTempPopup(actDiv,temCode,idx){
    var params = "idx="+idx;

    if(temCode==1){
        pageName="/library/popskin/pop1.asp"
    }else if(temCode==2){
        pageName="/library/popskin/pop2.asp"
    }else if(temCode==3){
        pageName="/library/popskin/pop3.asp"
    }else if(temCode==4){
        pageName="/library/popskin/pop4.asp"
    }else if(temCode==5){
        pageName="/library/popskin/pop5.asp"
    }else if(temCode==6){
        pageName="/library/popskin/pop6.asp"
    }else if(temCode==7){
        pageName="/library/popskin/pop7.asp"
    }else if(temCode==8){
        pageName="/library/popskin/pop8.asp"
    }else if(temCode==9){
        pageName="/library/popskin/pop9.asp"
    }else if(temCode==10){
        pageName="/library/popskin/pop10.asp"
    }

    new Ajax.Updater(actDiv, pageName, { method:'post',evalScripts:true, encoding : 'utf-8', parameters:params });
}

function numOnMask(me){ 
    if (event.keyCode<48||event.keyCode>57){//숫자외금지 
        event.returnValue=false; 
    }
    var tmpH 
    if(me.charAt(0)=="-"){//음수가 들어왔을때 '-'를 빼고적용되게.. 
        tmpH=me.substring(0,1);
        me=me.substring(1,me.length); 
    } //me.indexOf('-') 
    if(me.length > 3){ 
        var c=0; 
        var myArray=new Array(); 
        for(var i=me.length;i>0;i=i-3){ 
            myArray[c++]=me.substring(i-3,i); 
        } 
        myArray.reverse(); 
        me=myArray.join(","); 
    } 
    if(tmpH){ 
        me=tmpH+me; 
    }
    return me;
} 
function numOffMask(me){ 
    var tmp=me.split(",");
    tmp=tmp.join("");

    return tmp;
}
function check_value(me){ 
    if(me.value!="-"){
        var myStr=numOffMask(me.value);

        if (isNaN(myStr)) {
            //alert("숫자만 입력할 수 있습니다.");
            me.value=''; 
        }else{
            me.value=numOnMask(myStr); 
        }
    }
    //me.focus();
}

function autotab(field){
     if (field.getAttribute&&field.value.length==field.getAttribute("maxlength")) {
        var i;
        for (i = 0; i < field.form.elements.length; i++)
            if (field == field.form.elements[i])
                break;
        i = (i + 1) % field.form.elements.length;
        field.form.elements[i].focus();
        return false;
    } 
    else
    return true;
}

function jumin_check(userNo1,userNo2){
    a = Array(6);
    b = Array(7);
    var f=document.pageForm;
    var num1, num2, total, tot;

    if(userNo1.length==6 && userNo2.length==7){
        num1=userNo1;
        num2=userNo2;

        for(var i=0; i<6; i++){
            a[i]=parseInt(num1.charAt(i));
        }

        for(var j=0; j<7; j++){
            b[j]=parseInt(num2.charAt(j));
        }

        total = (a[0]*2) + (a[1]*3) + (a[2]*4) + (a[3]*5) + (a[4]*6) + (a[5]*7) + (b[0]*8) + (b[1]*9) + (b[2]*2) + (b[3]*3) + (b[4]*4) + (b[5]*5);
        tot = 11 - (total % 11);
        if(tot==11){
            tot = 1;
        }else if(tot==10){
            tot = 0;
        }

        if(b[6]!=tot){
            alert("주민번호가 올바르지않습니다.");
            return(false);
        }return(true);
    }else{
        alert("주민등록번호를 올바로 입력하세요.");
        return(false);
    }
}

function closeLayer(obj){
    obj.style.visibility='hidden';
}
function closetoLayer(obj){
    setCookie( obj, "done" , 1 );
    document.all[obj].style.visibility = "hidden";
}
function setCookie( name, value, expiredays ) { 
    var todayDate = new Date(); 
    todayDate.setDate( todayDate.getDate() + expiredays ); 
    document.cookie = name + "=" + escape( value ) + "; path=/; expires=" + todayDate.toGMTString() + ";" 
}
function getCookie( name ){ 
 var nameOfCookie = name + "=";
 var x = 0; 
 while ( x <= document.cookie.length ) { 
  var y = (x+nameOfCookie.length);
  if ( document.cookie.substring( x, y ) == nameOfCookie ) {
   if ( (endOfCookie=document.cookie.indexOf( ";", y )) == -1 ) endOfCookie = document.cookie.length; 
   return unescape( document.cookie.substring( y, endOfCookie ) );
  } 
  x = document.cookie.indexOf( " ", x ) + 1;
  if ( x == 0 ) break; 
 } 
 return "";
}

function getFileExtension( filePath ){
    var extension = "";
    var lastIndex = -1;
        lastIndex = filePath.lastIndexOf('.');

    if ( lastIndex != -1 ){
        extension = filePath.substring( lastIndex+1, filePath.len );
    } else{
        extension = "";
    }
        return extension;
}

function uploadImg_check( value,msg,sort ){
    var src = getFileExtension(value);

    if(sort==1 && value==""){return true;}
    if ( src == ""){
        alert(msg);
        return false;
    } else if ( !((src.toLowerCase() == "gif") || (src.toLowerCase() == "jpg") || (src.toLowerCase() == "jpeg")) ) {
        alert('gif 와 jpg 파일만 업로드 하실 수 있습니다.');
        return false;
    }else{return true;}
}

function uploadFlvImg_check( value,msg,sort ){
    var src = getFileExtension(value);

    if(sort==1 && value==""){return true;}
    if ( src == ""){
        alert(msg);
        return false;
    } else if ( !((src.toLowerCase() == "flv")) ) {
        alert('플래쉬동영상 파일만 업로드 하실 수 있습니다.');
        return false;
    }else{return true;}
}

function popOpen(Width,Height,idx,sTop,sLeft) {
    if( getCookie( "pop"+idx ) != "done" ){ 
        var Option="left="+sLeft+",top="+sTop+",toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=no,width="+Width+", height="+parseInt(Height+21);
        window.open("/popup.asp?idx="+idx,"pop"+idx,Option);
    }
}
function engpopOpen(Width,Height,idx,sTop,sLeft) {
    if( getCookie( "engpop"+idx ) != "done" ){ 
        var Option="left="+sLeft+",top="+sTop+",toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=no,width="+Width+", height="+parseInt(Height+21);
        window.open("/eng/popup.asp?idx="+idx,"engpop"+idx,Option);
    }
}

function mainLoginSend(form) {
    if(form.userid.value=="") {
        alert("아이디를 입력해 주십시오.");
        form.userid.focus();
        return;
    }
    if(form.userid.value.length < 4 || form.userid.value.length > 64) {
        alert("회원 아이디는 6~15자로 입력 주세요.");
        form.userid.focus();
        return;
    }
    if(form.password.value=="") {
        alert("패스워드를 입력해 주십시오.");
        form.password.focus();
        return;
    }
    form.submit();
}

function mainLoginInputSendit(form) {
    if(event.keyCode==13) { 
        mainLoginSend(form);
    }
}

function zipcodeck(myname,w,h,scroll,frm,zip,addr1,addr2){
    var urlstr="/common/zipsearch.asp?frm="+frm+"&fzip="+zip+"&faddr1="+addr1+"&faddr2="+addr2;
    var winl=(screen.width - w)/2;
    var wint=(screen.height - h)/2;
    winprops='height='+h+',width='+w+',top='+wint+',left='+winl+',scrollbars='+scroll
    window.open(urlstr,myname,winprops)
}

function itemsearch(){
    if(document.itemshform.searchstr.value==""){
        alert("검색하실 제품 단어를 입력하세요.");
        document.itemshform.searchstr.focus();
        return;
    }document.itemshform.submit();
}

function openModal(width,height,fileUrl,scroll){
    var OpenFile=fileUrl;
    var ReturnValue=window.showModalDialog(OpenFile,'','scroll:'+scroll+'; help:no; center:yes; status:no; dialogWidth:'+width+'px; dialogHeight:'+height+'px');
    if(ReturnValue==1){
        return true;
    }
}


function openWindow(Width,Height,Url,winname,scroll) {
    var winPosLeft = (screen.width - Width) / 2; // 새창 Y 좌표
    var winPosTop = (screen.height - Height) / 2; // 새창 X 좌표

    var Option="top="+winPosTop+",left="+winPosLeft+", toolbar=no, location=no, directories=no, status=no, menubar=no, scrollbars="+scroll+", resizable=no,width="+Width+", height="+Height;
    obj = window.open(Url,winname,Option);
    obj.focus();
}

function login(){
    alert("로그인이 필요한 페이지입니다.\n로그인 처리를 해주세요.");
    return;
}

function downChk(){
    alert("다운로드 권한이 없습니다.\n확인후 다시시도해주세요.");
    return;
}

function inputSendit(thisform) {
    if(event.keyCode==13) {
        thisform.submit();
    }
}

function formatNumber(v1,v2){
    var str=new Array(); //콤마스트링을 조합할 배열
    v1=String(v1); //숫자를 스트링으로 변환
    for(var i=1;i<=v1.length;i++){ //숫자의 길이만큼 반복
        if(i%v2) str[v1.length-i]=v1.charAt(v1.length-i); //자리수가 아니면 숫자만삽입
        else  str[v1.length-i]=','+v1.charAt(v1.length-i); //자리수 이면 콤마까지 삽입
    }
    return str.join('').replace(/^,/,''); //스트링을 조합하여 반환
}



function regularExp(Str,Patten){
    var chk
    if(Patten=="hangle"){chk=/[^ ㄱ-힣]/;}        // 한글,공백 허용
    else if(Patten=="charcode"){chk=/[^ \wㄱ-힣]/}    // 한영문자,숫자,공백,_ 허용
    else if(Patten=="intcode"){chk=/[^\d-]/;}    // 숫자,- 허용
    else{chk=Patten}
    return chk.test(Str);
}


function onlyNumber(){
    if((event.keyCode==190) || (event.keyCode>=96 && event.keyCode<=105) || (event.keyCode==110) || (event.keyCode>47 && event.keyCode<58) || event.keyCode==8 || event.keyCode==16 || event.keyCode==116 || event.keyCode==18 || event.keyCode==9 ||(event.keyCode>=37 && event.keyCode<=40) || event.keyCode==46 );
    else event.returnValue=false;
}

function OpenWin_Upload() {
    window.open("../TextEditor/fileupload.asp","FileUpload","scrollbars=yes,height=470,width=720,top=20,left=50");
}

function setCookie( name, value, expiredays ){
  var endDate = new Date();
  endDate.setDate( endDate.getDate()+ expiredays );
  document.cookie = name + "=" + escape( value ) + "; path=/; expires=" + endDate.toGMTString() + ";"
}

function get_Cookie( name ){
    var nameOfCookie = name + "=";
    var x = 0;
    while ( x <= document.cookie.length ){
        var y = (x+nameOfCookie.length);
        if ( document.cookie.substring( x, y ) == nameOfCookie ){
            if ( (endOfCookie=document.cookie.indexOf( ";", y )) == -1 )
                endOfCookie = document.cookie.length;
            return unescape( document.cookie.substring( y, endOfCookie ) );
        }
        x = document.cookie.indexOf( " ", x ) + 1;
        if ( x == 0 ) break;
    }
    return "";
}

function changeMenu(index){
    if(index==0){
        document.all.MenuTable1.style.display='block';
        document.all.MenuTable2.style.display='none';
        setCookie( "menuSort", 0 , 1);
    }else{
        document.all.MenuTable1.style.display='none';
        document.all.MenuTable2.style.display='block';
        setCookie( "menuSort", 1 , 1);
    }
}

function vodView(title,url){
    var Option="top=0, left=0, toolbar=no, location=no, directories=no, status=no, menubar=no, scrollbars="+scroll+", resizable=no,width=400, height=300";
    window.open('/player/player.asp?title='+title+'&ViewFileUrl='+url,'player',Option);
}

function addRow(){
    oCel = new Array();
    oRow = document.createElement('<tr>');
    for(i=0;i<1;i++){
        oCel[i] = document.createElement('<td style="padding:1px 0; border:0px solid #ffffff">');
        oRow.appendChild(oCel[i]);
    }//document.all.inRow.rows.length
    oCel[0].innerHTML="<input name='files' type='file' class='input' style='width:350px;height:20px;'><input type='hidden' name='filedel_idx' value='0'>";
    document.getElementById("inRow").children(0).appendChild(oRow);
}
function changeFilech(cnt,val){
    var delchk = document.getElementsByName('delchk');
    var filedel_idx = document.getElementsByName('filedel_idx');

    if(delchk[cnt].checked){filedel_idx[cnt].value=val}
    else{filedel_idx[cnt].value=""}
}

function changeFileArea(){
    if(document.getElementById("fileArea").style.display=="none"){
        document.getElementById("fileArea").style.display="inline";
    }else{
        document.getElementById("fileArea").style.display="none";
    }
}


//에디터 관련 스크립트======================================================================================
function alditor_PlayNow(obj, w, h, url){
    try    {
        if (url){
            var el = obj;
            var sURL = url;
            var sID = url;
        } else {
            var el = obj.previousSibling;
            while (el.tagName!="A")
            el = el.previousSibling;
            var sURL = el.href;
            var sID = el.href;
        }
        var sExt = sID.substring(sID.lastIndexOf("."));
        var sComp = sExt.toUpperCase();

        if (document.getElementById(sID)==null){
            var embedHolder = document.createElement("div");
            var embed = document.createElement("EMBED");
            if (w) { embed.width = w;    }
            if (h)     { embed.height = h;    }
            if (sComp==".SWF"){
                embed.quality = "high";
                embed.wmode = "transparent";
            } else {
                embed.autostart = true;
            }
            embed.id = sID;
            embed.src = sURL;
            embedHolder.appendChild(embed);
            el.parentNode.insertBefore(embedHolder,el);
        } else {
            document.getElementById(sID).parentNode.parentNode.removeChild(document.getElementById(sID).parentNode);
        }
    }
    catch(e){}
}

function alditor_ShowHide(obj){
    try{
        var targetDiv = document.getElementById(obj.id + 'sh');
        if (targetDiv.className == 'showhideDiv') {
            obj.title = obj.innerHTML;
        }
        obj.innerHTML = (targetDiv.className == 'showhideDiv')? '가리기' : obj.title ;
        targetDiv.className = (targetDiv.className == 'showhideDiv')? 'showhideDivShow' : 'showhideDiv' ;
    }
    catch(e) {}
}
//==========================================================================================================

var Drag={
    "obj":null,

    "init":function(a, aRoot, ee){
            if (!ee) {
                a.onmousedown=Drag.start;
            }
            a.root = aRoot;
            if(isNaN(parseInt(a.root.style.left))) { a.root.style.left="0px"; }
            if(isNaN(parseInt(a.root.style.top))) { a.root.style.top="0px"; }
            a.root.onDragStart = new Function();
            a.root.onDragEnd = new Function();
            a.root.onDrag = new Function();

            if (!!ee) {
                var b = Drag.obj = a;
                ee = Drag.fixE(ee);
                var c = parseInt(b.root.style.top);
                var d = parseInt(b.root.style.left);
                b.root.onDragStart(d,c,ee.clientX,ee.clientY);
                b.lastMouseX = ee.clientX;
                b.lastMouseY = ee.clientY;
                document.onmousemove    = Drag.Drag;
                document.onmouseup      = Drag.end;
            }

        },

    "start":function(a){
            
            var b=Drag.obj=this;
            a=Drag.fixE(a);

            var c = parseInt(b.root.style.top);
            var d = parseInt(b.root.style.left);

            b.root.onDragStart(d,c,a.clientX,a.clientY);

            b.lastMouseX = a.clientX;
            b.lastMouseY = a.clientY;

            document.onmousemove    = Drag.Drag;
            document.onmouseup      = Drag.end;
            return false;
        },


    "Drag":function(a){
            a = Drag.fixE(a);
            var b = Drag.obj;
            var c = a.clientY;
            var d = a.clientX;
            var e = parseInt(b.root.style.top);
            var f = parseInt(b.root.style.left);
            var h,g;
            h = f + d - b.lastMouseX;
            g = e + c - b.lastMouseY;
            b.root.style.left   = h + "px";
            b.root.style.top    = g + "px";
            b.lastMouseX        = d;
            b.lastMouseY        = c;
            b.root.onDrag(h, g, a.clientX, a.clientY);          
            return false;
        },


    "end":function(){
            document.onmousemove    = null;
            document.onmouseup      = null;
            Drag.obj.root.onDragEnd(parseInt(Drag.obj.root.style.left),parseInt(Drag.obj.root.style.top));          
            Drag.obj = null;
        },


    "fixE":function(a){
            if(typeof a == "undefined") { a=window.event; }
            if(typeof a.layerX == "undefined") { a.layerX=a.offsetX; }
            if(typeof a.layerY == "undefined") { a.layerY=a.offsetY; }
            return a;
        }
};