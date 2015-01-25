<%@codepage="65001" language="VBScript"%>
<%
Session.CodePage = 65001
Response.CharSet = "utf-8"

IF Request.cookies("acountcode") = "" Then
	Response.Write "<SCRIPT LANGUAGE='JavaScript'>"&Vbcrlf
	Response.Write "alert('로그인 정보가 불확실합니다.\n로그인페이지로 이동합니다.')"&Vbcrlf
	Response.Write "location.href='/admin/login.htm'"&Vbcrlf
	Response.Write "</SCRIPT>"&Vbcrlf
	Response.End
End IF
%>

<!-- #include virtual="/library/crmFunctions.asp " -->
<%
tp = Request("tp")
fd = Request("fd")
ed = Request("ed")
CurrentPage = Request("CurrentPage")

SetDefault tp, "1"

SetDefault CurrentPage, 1
SetDefault ConfigPageSize, 20
SetDefault ConfigPageBlock, 10
SetDefault URL_SEARCH, "index.asp?tp=" & tp & "&fd=" & fd & "&ed=" & ed

FDATE = fd
EDATE = ed
setDefault FDATE, formatdatetime(now, 2)
setDefault EDATE, formatdatetime(now, 2)
%>

<!--#include virtual = admin/common/adminHeader.asp-->
<link href="/css/admincounter.css" rel="stylesheet">
<link href="/admin/common/body.css" rel="stylesheet">
<script>
var SEARCH_TYPE_1 = 1;
var SEARCH_TYPE_2 = 2;
var SEARCH_TYPE_3 = 3;
var SEARCH_TYPE_4 = 4;
var SEARCH_TYPE_5 = 5;
var SEARCH_TYPE_6 = 6;
var SEARCH_TYPE_7 = 7;
var SEARCH_TYPE_8 = 8;
var SEARCH_TYPE_9 = 9;
function fnSearch(){
var obj = document.fo_search;
var tp = arguments[0];

	switch(tp) {
		case SEARCH_TYPE_1: obj.action = 'index.asp'; break;
		case SEARCH_TYPE_2: obj.action = 'count1.asp'; break;
		case SEARCH_TYPE_3: obj.action = 'count2.asp'; break;
		case SEARCH_TYPE_4: obj.action = 'count3.asp'; break;
		case SEARCH_TYPE_5: obj.action = 'count4.asp'; break;
		case SEARCH_TYPE_6: obj.action = 'count5.asp'; break;
		case SEARCH_TYPE_7: obj.action = 'count6.asp'; break;
		case SEARCH_TYPE_8: obj.action = 'count7.asp'; break;
		case SEARCH_TYPE_9: obj.action = 'count8.asp'; break;
	}
	
	obj.tp.value = tp;
	obj.submit();
}
</script>
<style>
input.eSelectButton{
	background-color:threedshadow;
}
</style>


<!--#include virtual = admin/common/topimg.htm-->
<table border="0" cellpadding="0" cellspacing="0" align="center" width='100%'>
	<tr>
		<td valign="top" style='padding-left:10px;'>
			<table cellpadding="2" cellspacing="0" width='1080'>
				<tr>
					<td>
						<table cellpadding="0" cellspacing="0" width="100%">
							<tr><td style='color: #39518C;' class='menu'><img src='/admin/image/titleArrow2.gif'><b>접속현황</td></tr>
						</table>
					</td>
				</tr>
				<tr>
					<td>






	<!--#include file = "counter_menu.asp" -->	
	<br>	
	<table cellpadding=5 cellspacing=1 border=0 width=100% align=center bgcolor=e6e6e6 style='word-break:break-all;'>
	<colgroup>
	<col width=90 align=left>
	<col align=center>
	<col width=60 align=center>
	<col width=100 align=center>
	<col width=150 align=center>
	</colgroup>
	<tr bgcolor=E2F1EB>
		<td align=center bgcolor="E2F1EB">방문IP</td>
		<td>방문경로</td>
		<td>브라우져</td>
		<td>운영체제</td>
		<td>일시</td>
	</tr>
<%
opendb

sql = "select count(*) from counter where Register > convert(datetime, '" & FDATE & " 00:00:00') and Register < convert(datetime, '" & EDATE & " 23:59:59')"
GetRs Rs, Sql

TotalList = Rs(0)

if TotalList <= 0 then 
	TotalList = 1 
end if

FreeAndNil(Rs)

sql = "select * from counter where Register > convert(datetime, '" & FDATE & " 00:00:00') and Register < convert(datetime, '" & EDATE & " 23:59:59') order by register desc"
GetPage Rs, sql, ConfigPageSize
if rs.eof then
%>
	   <tr bgcolor="#FFFFFF">
	     <td colspan="5" height="30" align="center">등록된 접속자가 없습니다.</td>    
	   </tr>
<%
else
Rs.AbsolutePage = CurrentPage : L = 0
Do While Not Rs.Eof and L < Rs.PageSize
	Num = TotalList - ((CurrentPage - 1) * ConfigPageSize) - L
	Ip = rs("Ip")
	Referer = rs("Referer")
	Agent = rs("Agent")
	Register = rs("Register")
	Browser = rs("strBrowser")
	Window = rs("strWindow")
	
	setDefault Referer, "BOOKMARK"
	
	IF Not Referer = "BOOKMARK" then
		Referer = "<a href='" & Referer & "' target=_blank>" & Referer & "</a>"
	end if
%>
	<tr bgcolor=#ffffff onmouseover="this.style.backgroundColor='#F2F9F7'" onmouseout="this.style.backgroundColor='#FFFFFF'">
		<td><a href="http://whois.nic.or.kr/whois/webapisvc?VALUE=<%=IP%>" target=_blank><%=IP%></a></td>
		<td align=left><div style="width:100%;overflow:hidden"><%=Referer%></div></td>
		<td><%=Browser%></td>
		<td><%=Window%></td>
		<td><%=Register%></td>
	</tr>
<%
	rs.movenext : L = L + 1
loop
end if
freeandnil(rs)
freeandnil(con)
%>
	</table>
	 
	 
	 <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0" class='menu'>
	   <tr>
	     
    <td align="center" bgcolor="#FFFFFF"> 
      <%
		intTotalPage = -Int(-(TotalList) / ConfigPageSize)
		
		intTemp = Int((CurrentPage - 1) / ConfigPageBlock) * ConfigPageBlock + 1
		
		If intTemp = 1 Then
%>
      <img src='/admin/image/icon/bt_prev.gif'  border="0" align='absmiddle'> 
      <% Else %>
      <a href="<%=URL_SEARCH & "&CurrentPage=" & intTemp - ConfigPageBlock%>"><img src='/admin/image/icon/bt_prev.gif' border="0" align='absmiddle'></a> 
      <%
		End If
		
		intLoop = 1
		
		Do Until (intLoop > ConfigPageBlock) Or (intTemp > intTotalPage)
		
		If intTemp = CInt(CurrentPage) Then
		%>
      &nbsp;<font color="#FF6600"><b><%=intTemp%> </b></font>&nbsp; 
      <% Else %>
      <a href="<%=URL_SEARCH & "&CurrentPage=" & intTemp%>"><%=intTemp%></a> 
      <%
		End If
		
		intTemp = intTemp + 1
		intLoop = intLoop + 1
		
		Loop
		
		If intTemp > intTotalPage Then
		%>
      <img src='/admin/image/icon/bt_next.gif'  border="0" align='absmiddle'> 
      <% Else %>
      <a href="<%=URL_SEARCH & "&CurrentPage=" & intTemp%>"><img src='/admin/image/icon/bt_next.gif'  border="0" align='absmiddle'></a> 
      <% End If %>
      <%if BTN_WRITE and MODE = MODE_LIST then%>
      <%end if%>
    </td>
	   </tr>
	 </table>
	
	<br>
	<br>
	<br>
	
	</td>
</tr>
</table>





					</td>
				</tr>
			</table>
		</td>
	</tr>
</table>

<!--#include virtual = admin/common/bottom.html-->