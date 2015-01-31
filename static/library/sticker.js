<style type="text/css">
/** 뉴스티커가 보여질 창에 대한 설정입니다 **/
#memoryticker{
background-color: 295587; /**배경색상**/
width: 560px; /**가로크기**/
font:  12px '굴림'; /**글꼴**/
border: 0px solid black; /**테두리**/
padding: 0px; /**안쪽여백**/
filter: progid:DXImageTransform.Microsoft.GradientWipe(GradientSize=1.0 Duration=1)
}
</style>

<script type="text/javascript">
var tickercontents=new Array()

var sticker="<%=sticker_tag%>";
sticker=sticker.split("||")

for(i=0;i<sticker.length;i++){
tickercontents[i]=sticker[i];
}

var persistlastviewedmsg=1
var persistmsgbehavior="onload"

var tickdelay=3000

var divonclick=(persistlastviewedmsg && persistmsgbehavior=="onclick")? 'onClick="savelastmsg()" ' : ''
var currentmessage=0

function changetickercontent(){
if (crosstick.filters && crosstick.filters.length>0)
crosstick.filters[0].Apply()
crosstick.innerHTML=tickercontents[currentmessage]
if (crosstick.filters && crosstick.filters.length>0)
crosstick.filters[0].Play()
currentmessage=(currentmessage==tickercontents.length-1)? currentmessage=0 : currentmessage+1
var filterduration=(crosstick.filters&&crosstick.filters.length>0)? crosstick.filters[0].duration*1000 : 0
setTimeout("changetickercontent()",tickdelay+filterduration)
}

function beginticker(){
if (persistlastviewedmsg && get_cookie("lastmsgnum")!="")
revivelastmsg()
crosstick=document.getElementById? document.getElementById("memoryticker") : document.all.memoryticker
changetickercontent()
}

function get_cookie(Name) {
var search = Name + "="
var returnvalue = ""
if (document.cookie.length > 0) {
offset = document.cookie.indexOf(search)
if (offset != -1) {
offset += search.length
end = document.cookie.indexOf(";", offset)
if (end == -1)
end = document.cookie.length;
returnvalue=unescape(document.cookie.substring(offset, end))
}
}
return returnvalue;
}

function savelastmsg(){
document.cookie="lastmsgnum="+currentmessage
}

function revivelastmsg(){
currentmessage=parseInt(get_cookie("lastmsgnum"))
currentmessage=(currentmessage==0)? tickercontents.length-1 : currentmessage-1
}

if (persistlastviewedmsg && persistmsgbehavior=="onload")
window.onunload=savelastmsg

if (document.all||document.getElementById)
document.write('<div id="memoryticker" '+divonclick+'></div>')
if (window.addEventListener)
window.addEventListener("load", beginticker, false)
else if (window.attachEvent)
window.attachEvent("onload", beginticker)
else if (document.all || document.getElementById)
window.onload=beginticker
</script>	