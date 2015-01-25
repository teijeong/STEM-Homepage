<!--#include virtual = common/ADdbcon.asp-->
<%
Idx=Request("idx")

Sql="select title,Bansort,content from historyAdmin WHERE idx = "&Idx
Set Rs=Server.CreateObject("ADODB.RecordSet")
Set Rs=DBcon.Execute(Sql)

IF Not(Rs.Bof Or Rs.Eof) Then
	title=ReplaceTextField(Rs("title"))
	Bansort=Rs("Bansort")
	content=Rs("content")
Else
	strLocation="self.close();"
	Response.Write ExecJavaAlert("잘못된 접근입니다.\n현재창을 닫습니다.",3)
End If

Rs.Close
Set Rs=Nothing
DBcon.Close
Set DBcon=Nothing
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko" lang="ko">
<HEAD>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<TITLE> 게시물수정 </TITLE>
<META NAME="Generator" CONTENT="EditPlus">
<META NAME="Author" CONTENT="">
<META NAME="Keywords" CONTENT="">
<META NAME="Description" CONTENT="">
<link href="/css/shopstyle.css" rel="stylesheet" type="text/css">
<SCRIPT language=JavaScript src="/ckeditor/ckeditor.js" type='text/javascript'></SCRIPT>
<script language='javascript' src='/library/functions.js'></script>
<SCRIPT LANGUAGE="JavaScript">
<!--
function goAdd(){
	f=document.historyform;
	if(f.title.value==""){
		alert("일시를 입력하세요");
		f.title.focus();
		return;
	}
	document.historyform.submit();
}
//-->
</SCRIPT>
</HEAD>

<body>

<center style='padding: 15px 0;'>
<form name='historyform' method='post' action='historyOk.asp'>
<input type='hidden' name='sort' value='edit'>
<input type='hidden' name='idx' value='<%=Idx%>'>
<input type='hidden' name='Bansort' value='<%=Bansort%>'>
<table width="880" border="1" cellpadding="0" cellspacing="0" bordercolor='#BDBEBD' class="menu" style='border-collapse: collapse'>
	<tr><td height='30' colspan='2' bgcolor='#EFEFEF' align='center'><b>게시물 수정</b></td></tr>
	<tr height="25" align="center">
		<td width='100' height="25" align="center" bgcolor="#F6F6F6">일시</td>
		<td align='left'>
			&nbsp;<input type='text' name='title' size='100' class='input' maxlength='50' value='<%=Title%>'>
		</td>
	</tr>
	<tr align="center">
		<td width='150' align="center" bgcolor="#F6F6F6">활동내용</td>
		<td align='left' style='padding: 5px;'>
			<textarea name='content' style='width:100%; height:70px;' class='ckeditor'><%=Content%></textarea>
		</td>
	</tr>
	<tr><td colspan='2' align='center' height='25'><input type='button' value='게시물 수정하기' class='btn' style='width:99%;cursor:pointer;' onclick='goAdd()'></td></tr>
</table>
</form>
</center>

</BODY>
</HTML>