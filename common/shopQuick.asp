<!--#include virtual = common/dbcon.asp-->
<%
Set Rs=Server.CreateObject("ADODB.RecordSet")
'=============================스카이배너 추천 진열상품 Get=========================='
Sql="SELECT Top 20 P.idx,listimg,catecode FROM product AS P INNER JOIN ViewProduct AS V ON P.idx = V.itemidx WHERE sessionid='"&Session.SessionID&"' "&HKitemSelModeStrWhere&" Order BY V.idx DESC"
Rs.Open Sql,DBcon,1

IF Not(Rs.Bof Or Rs.Eof) Then SkyPutColRec=Rs.GetRows()
Rs.Close
'==================================================================================='

Set Rs=NOthing
DBcon.Close
Set DBcon=Nothing

Function PT_SkyViewproduct()
	IF IsArray(SkyPutColRec) Then
		IF Ubound(SkyPutColRec,2)+1 > 5 Then
			View_Cnt=5
		Else
			View_Cnt=Ubound(SkyPutColRec,2)+1
		End IF
		Response.WRite " thumb = new Array();"&Vbcrlf
		Response.WRite " con_cnt = "&Ubound(SkyPutColRec,2)+1&";"&Vbcrlf
		Response.WRite " view_cnt = "&View_Cnt&";"&Vbcrlf
		Response.WRite " item_width = 45;"&Vbcrlf
		Response.WRite " item_height = 52;"&Vbcrlf
		Response.WRite " static_cnt = 0;"&Vbcrlf
		Response.WRite " str = ''"&Vbcrlf

		For i=0 To Ubound(SkyPutColRec,2)

			LinkTag="<a href='/shop/view.asp?idx="&SkyPutColRec(0,i)&"'>"

			IF SkyPutColRec(1,i)="" Then
				ImgTag="<img src='/images/noimg.gif' width='40' border='0'>"
			Else
				ImgTag="<img src='/upload/item/"&getImageThumbFilename(SkyPutColRec(1,i))&"' "&imgPerSize("item",40,40,getImageThumbFilename(SkyPutColRec(1,i)))&" border='0'>"
			End IF

			Response.WRite "thumb["&i&"] = ""<table width='40' height='40' border='1' cellpadding='0' cellspacing='0' bordercolor='#D9D9D9' style='border-collapse: collapse'><tr><td bgcolor='#ffffff'>"&LinkTag&""&ImgTag&"</a></td></tr></table>"";"&Vbcrlf
		Next

		Response.WRite "str = str + '<div align=center style=""position:relative;top:3px;left:1px;height:'+(item_height*view_cnt)+'px;width:'+(item_width)+'px;clip:rect(0 '+(item_height*view_cnt)+' '+(item_width)+' 0); "">';"&Vbcrlf
		Response.WRite "for(var a=0; a < view_cnt; a++){"&Vbcrlf
		Response.WRite "	str = str + '<div align=center id=""slider_'+a+'"" name=""slider_'+a+'"" style=""position:absolute;top:'+a*item_height+'px;height:'+item_height+'px;left:1;"">';"&Vbcrlf
		Response.WRite "	str = str + thumb[a];"&Vbcrlf
		Response.WRite "	str = str + '</div>';"&Vbcrlf
		Response.WRite "}"&Vbcrlf
		Response.WRite "str = str + '</div>';"&Vbcrlf
		Response.WRite "document.getElementById('itemcontests').innerHTML = str;"&Vbcrlf
	Else
		Response.WRite " con_cnt = 0;"&Vbcrlf
		Response.WRite " view_cnt = 0;"&Vbcrlf
	End IF
End Function
%>

<!--오늘본 상품 시작 -->
<table cellspacing="0" cellpadding="0" border="0" align="center">
<tr><td align='center'><img src="/images/quick_btn1.gif" alt="이전" onclick='go_prev();' style='cursor:pointer' /></td></tr>
<tr>
	<td align='center'>
		<table cellpadding='0' cellspacing='0'>
			<tr><td id='itemcontests' name='itemcontests' align='center'></td></tr>
		</table>
	</td>
</tr>
<tr><td align='center'><img src="/images/quick_btn2.gif" alt="다음" onclick='go_next();' style='cursor:pointer' /></td></tr>
</table>
<!--오늘 본 상품 끝 -->

<SCRIPT LANGUAGE="JavaScript" type='text/javascript'>
<%=PT_SkyViewproduct()%>
</SCRIPT>