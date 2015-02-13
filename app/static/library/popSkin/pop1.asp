<!--#include virtual = common/dbcon.asp -->
<%
Idx=Request("idx")

Rs=DBcon.Execute("FM_UP_PopupList(2,,"&Idx&")")
Sort=Rs(0) : Title=Rs(1) : Content=Rs(2) : HtmlYn=Rs(3)
LinkUrl=Rs(4) : OutputImg=Rs(5)

DBcon.Close
Set DBcon=Nothing

Function PT_PopContent
    IF Sort=0 Then
        Response.Write "<div id='HKeditorContent' name='HKeditorContent'>"&Content&"</div>"
    Else
        IF LinkUrl<>"" Then Response.Write "<a href=""javascript:goPage('"&LinkUrl&"')"">"&Vbcrlf
        Response.Write "<img src='/upload/popup/"&OutPutImg&"' border='0' align='absmiddle'></a>"&Vbcrlf
    End IF
End Function
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko" lang="ko">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
</head>
<div style="margin:0px; background:url('/library/popSkin/pop1.jpg') left top no-repeat; width:350px; height:400px;">
<div style="padding:70px 20px 0;">
    <div id='HKeditorContent' name='HKeditorContent' style="position:relative;  width:310px; height:305px; word-wrap:break-all; overflow:auto;"><%=Content%></div>
</div>
</div>
</html>