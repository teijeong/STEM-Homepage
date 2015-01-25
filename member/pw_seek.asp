<!-- #include virtual = common/dbcon.asp -->
<!--#include virtual = library/sha256.asp-->
<%
ICode=sha256(Replaceensine(Replace(Request("Icode"),", ","-")))
UserName=Replaceensine(Request("name"))
email=Replaceensine(Request("email"))
UserId=Request("userid")

IF Request("sort")<>"" Then
	Sql="SELECT TOP 1 pwd, regdate FROM members WHERE outmember<>1 And name=N'"&UserName&"' And id=N'"&UserId&"' AND email=N'"&Email&"'"
	Set Rs=DBcon.Execute(Sql)

	IF Rs.Bof Or Rs.Eof Then
		Response.Write ExecJavaAlert("입력하신 정보에 맞는 검색결과가 없습니다.\확인후 다시시도해주세요.",0)
		Response.End
	End IF

	'====랜덤 비밀번호 생성=================
	tmpPwdStr=""
	str="abcdefghijklmnopqrstuvwxyz0123456789"
	strlen=8
	Randomize

	For i=1 To strlen
		rstr=Int((36-1+1) * Rnd +1)
		tmpPwdStr=tmpPwdStr&Mid(str,rstr,1)
	Next
	'========================================
		
	Sql="UPDATE Members Set pwd='"&tmpPwdStr&"' WHERE outmember<>1 And name=N'"&UserName&"' And id=N'"&UserId&"' AND email=N'"&Email&"'"
	DBcon.Execute Sql
	Set Rs=Nothing
End IF

DBcon.Close
Set DBcon=Nothing
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko" lang="ko">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<meta http-equiv="imagetoolbar" content="no" />
<title>Untitled Document</title>
<script type="text/javascript" src="/js/ssong.js"></script>
<script type="text/javascript" src="/js/link.js"></script>
<link rel="shortcut icon" href="/favicon.ico" />
<link href="/css/default.css" rel="stylesheet" type="text/css" />
</head>

<SCRIPT LANGUAGE="JavaScript">
<!--
function checkPwdsearch(){
	if (pwdsearch.userid.value==false){
		alert("아이디를 입력해 주세요");
		pwdsearch.userid.focus();
		return;
	}
	if (pwdsearch.name.value==false){
		alert("이름을 입력해 주세요");
		pwdsearch.name.focus();
		return;
	}
	if (pwdsearch.email.value==false){
		alert("가입시 입력한 이메일 주소를 입력해 주세요");
		pwdsearch.email.focus();
		return;
	}
	pwdsearch.submit();
}
//-->
</SCRIPT>

<body id="seek">
<table width="90%" cellspacing="0" cellpadding="0" class="seek" height='235'>
	<tr>
		<td class="tit"><strong>비밀번호 찾기</strong></td>
	</tr>
	<% IF tmpPwdStr="" Then %>
	<tr><td class="condition">아래 사항을 입력해 주십시오.</td></tr>
	<% Else %>
	<tr><td class="condition"><font color='#8E9BF7'><b>※ 고객님의 비밀번호가 변경되었습니다.</font></td></tr>
	<% End IF %>
	<tr>
		<td>

<form name="pwdsearch" method="post" action="?sort=Pwd">
<table width="330px" cellspacing="6" cellpadding="0" class="pw_search">
<% IF tmpPwdStr="" Then %>
	<tr>
		<td><span class="cate">아이디</span><input type="text" class="input" style="width:210px" name='userid' maxlength='15'></td>
	</tr>
	<tr>
		<td><span class="cate">이름(회원명)</span><input type="text" class="input" style="width:210px" name='name' maxlength='15'></td>
	</tr>
	<tr>
		<td><span class="cate">이메일</span><input name="email" type="text" class="input" style="width:210px" maxlength='50'></td>
	</tr>
<% Else %>
	<tr><td align='center' style='padding-top:25px;'><b>변경된 비밀번호는 <b><%=tmpPwdStr%></b>입니다.</td></tr>
	<tr><td align='center' style='padding-bottom:25px;'>로그인 후 반드시 비밀번호를 변경해주시기 바랍니다.</td></tr>
<% End IF %>
</table>
</form>

		</td>
	</tr>
	<tr>
		<td class="id_btn">
			<% IF tmpPwdStr="" Then %>
			<input type="button" title="" value="검 색" class="button2" onclick="checkPwdsearch()">
			<input type="button" title="" value="취 소" class="button1" onclick="window.close()">
			<% Else %>
			<input type="button" title="" value="확 인" class="button1" onclick="window.close()">
			<% End IF %>
		</td>
	</tr>
</table>
</body>
</html>