<!--#include virtual = common/dbcon.asp -->
<%
Dim Idx,Rs,Sort,Title,Content,HtmlYn,LinkUrl,OutputImg
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
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title><%=Title%></title>
<script language="JavaScript">
<!--
function setCookie( name, value, expiredays ) { 
    var todayDate = new Date(); 
        todayDate.setDate( todayDate.getDate() + expiredays ); 
        document.cookie = name + "=" + escape( value ) + "; path=/; expires=" + todayDate.toGMTString() + ";" 
    } 

function closeWin(str) { 
    if ( str=="1" ){ 
        setCookie( "pop"+"<%=Idx%>", "done" , 1 ); 
    } 
    window.close()
}

function goPage(Url){
    opener.location.href=Url;
    self.close();
}
//-->  
</script>
</head>
<link href="/css/editorContent.css" rel=stylesheet type="text/css">
<body topmargin='0' leftmargin='0'>

<form name="chkform" style='margin:0px;'>
<table cellpadding='0' cellspacing='0' class='graytext' height='100%' style='word-break:break-all;'>
    <tr>
        <td valign='top' background='/images/sub/pop_bg.jpg' colspan='2'><%PT_PopContent%></td>
    </tr>
    <tr><td height='1' bgcolor='#D1D1D1' colspan='2'></td></tr>
    <tr bgcolor='#EEEEEE' height='20'>
    <td><img src="/common/memberimg/btn_pop_todayclose.gif" width="98" height="20" hspace="5" border='0'  style="cursor:hand;" onclick="closeWin(1);" /></td>
    <td align="right" style="padding-right:5px;"><img src="/common/memberimg/btn_pop_close.gif" width="47" height="20" border='0' onclick="closeWin(0);" style="cursor:hand;" /></td>
    </tr>
</table>
</form>
</body>
</html>
