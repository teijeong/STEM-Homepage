<!--#include virtual = common/ADdbcon.asp-->
<%
Idx=Request("idx")

Sql="select title,filenames,linkurl,Bansort,note1,note2,note3,note4,note5,note6,note7,content1,content2,email from resultAdmin WHERE idx = "&Idx
Set Rs=Server.CreateObject("ADODB.RecordSet")
Set Rs=DBcon.Execute(Sql)

IF Not(Rs.Bof Or Rs.Eof) Then
	title=ReplaceTextField(Rs("title"))
	filenames=Rs("filenames")
	linkurl=ReplaceTextField(Rs("linkurl"))
	Bansort=Rs("Bansort")
	note1=ReplaceTextField(Rs("note1"))
	note2=ReplaceTextField(Rs("note2"))
	note3=ReplaceTextField(Rs("note3"))
	note4=ReplaceTextField(Rs("note4"))
	note5=ReplaceTextField(Rs("note5"))
	note6=ReplaceTextField(Rs("note6"))
	note7=ReplaceTextField(Rs("note7"))
	content1=Rs("content1")
	content2=Rs("content2")
	email=ReplaceTextField(Rs("email"))
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
<script language='javascript' src='/library/functions.js'></script>
<SCRIPT LANGUAGE="JavaScript">
<!--
function goAdd(){
	f=document.resultform;
	if(f.title.value==""){
		alert("이름을 입력하세요");
		f.title.focus();
		return;
	}
	if(f.note1.value==""){
		alert("학과를 입력하세요");
		f.note1.focus();
		return;
	}
	if(uploadImg_check(f.files.value,"이미지를 올바로 입력하세요.",1)==false){
		return;
	}
	document.resultform.submit();
}
//-->
</SCRIPT>
</HEAD>

<body>

<center style='padding: 15px 0;'>
<form name='resultform' method='post' ENCTYPE="multipart/form-data" action='resultOk.asp'>
<input type='hidden' name='sort' value='edit'>
<input type='hidden' name='idx' value='<%=Idx%>'>
<input type='hidden' name='Bansort' value='<%=Bansort%>'>
<table width="720" border="1" cellpadding="0" cellspacing="0" bordercolor='#BDBEBD' class="menu" style='border-collapse: collapse'>
	<tr><td height='30' colspan='2' bgcolor='#EFEFEF' align='center'><b>게시물 수정</b></td></tr>
	<tr height="25" align="center">
		<td width='100' height="25" align="center" bgcolor="#F6F6F6">이름</td>
		<td align='left'>
			&nbsp;<input type='text' name='title' size='100' class='input' maxlength='50' value='<%=Title%>'>
		</td>
	</tr>
	<tr align="center">
		<td width='100' align="center" bgcolor="#F6F6F6">학과</td>
		<td align='left' style='padding: 5px;'><input type='text' name='note1' style='width:100%;' class='input' maxlength='50' value='<%=note1%>'></td>
	</tr>
	<tr align="center">
		<td width='150' align="center" bgcolor="#F6F6F6">이메일</td>
		<td align='left' style='padding: 5px;'><input type='text' name='email' style='width:100%;' class='input' maxlength='50' value='<%=email%>'></td>
	</tr>
	<tr align="center">
		<td width='100' align="center" bgcolor="#F6F6F6">Department</td>
		<td align='left' style='padding: 5px;'><input type='text' name='note2' style='width:100%;' class='input' maxlength='50' value='<%=note2%>'></td>
	</tr>
	<tr align="center">
		<td width='100' align="center" bgcolor="#F6F6F6">Awards & career</td>
		<td align='left' style='padding: 5px;'>
			<textarea name='content1' style='width:100%; height:70px;' class='input'><%=content1%></textarea>
		</td>
	</tr>
	<tr align="center">
		<td width='100' align="center" bgcolor="#F6F6F6">Commenets</td>
		<td align='left' style='padding: 5px;'>
			<textarea name='content2' style='width:100%; height:70px;' class='input'><%=content2%></textarea>
		</td>
	</tr>
	<tr height="25" align="center">
		<td height="25" align="center" bgcolor="#F6F6F6">이미지업로드</td>
		<td align='left'>
			&nbsp;<input type='file' name='files' size='50' class='input'>
			<% IF filenames<>"" Then %>
				<img src='/admin/image/icon/bt_view.gif' border='0' align='absmiddle' style='cursor:pointer;' onclick='openWindow(100,100,"/common/imgview.asp?path=result&imgname=<%=filenames%>","imgView","yes")'>
			<% End IF %>
			<input type='checkbox' name='filedelchk' value='1'> 파일수정여부
			<input type='hidden' name='filename' value='<%=filenames%>'>
		</td>
	</tr>
	<tr><td colspan='2' align='center' height='25'><input type='button' value='게시물 수정하기' class='btn' style='width:99%;cursor:pointer;' onclick='goAdd()'></td></tr>
</table>
</form>
</center>

</BODY>
</HTML>