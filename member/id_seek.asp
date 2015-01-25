<!-- #include virtual = common/dbcon.asp -->
<!--#include virtual = library/sha256.asp-->
<%
UserName=Replaceensine(Request("name"))
email=Replaceensine(Request("email"))
ICode=sha256(Replaceensine(Replace(Request("Icode"),", ","-")))

IF Request("sort")<>"" Then
	Sql="SELECT TOP 1 id, regdate FROM members WHERE outmember<>1 And name=N'"&UserName&"' AND email='"&email&"'"
	Set Rs=DBcon.Execute(Sql)

	IF Rs.Bof Or Rs.Eof Then
		Response.Write ExecJavaAlert("입력하신 정보에 맞는 검색결과가 없습니다.\확인후 다시시도해주세요.",0)
		Response.End
	End IF

	Id = Rs("id")
	LeftId = Left(Id,(Len(Id)-2))&"**"
	Regdate = Rs("regdate")
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
function checkIdsearch(){
	if (idsearch.name.value==false){
		alert("이름을 입력해 주세요");
		idsearch.name.focus();
		return;
	}
	if (idsearch.email.value==false){
		alert("가입시 입력한 이메일 주소를 입력해 주세요");
		idsearch.email.focus();
		return;
	}
	idsearch.submit();
}
//-->
</SCRIPT>

<body id="seek">
<table width="90%" cellspacing="0" cellpadding="0" class="seek" height='215'>
	<tr>
		<td class="tit"><strong>아이디 찾기</strong></td>
	</tr>
	<% IF LeftId="" Then %>
	<tr><td class="condition">아래 사항을 입력해 주십시오.</td></tr>
	<% Else %>
	<tr><td class="condition"><font color='#8E9BF7'><b>※ 입력하신 정보에 맞는 아이디 입니다.</font></td></tr>
	<% End IF %>
	<tr>
		<td>

<form name="idsearch" method="post" action="?sort=ID">
<table width="330px" cellspacing="6" cellpadding="0" class="id_search">
<% IF LeftId="" Then %>
	<tr>
		<td><span class="cate">이름(회원명)</span><input type="text" class="input" style="width:210px" name='name' maxlength='10'></td>
	</tr>
	<tr>
		<td><span class="cate">이메일</span><input name="email" type="text" class="input" maxlength="50" style="width:210px" /></td>
	</tr>
<% Else %>
	<tr><td align='center'><b><%=leftId%>&nbsp;&nbsp;(<%=regdate%> 가입)</td></tr>
	<tr><td align='center'>개인정보 도용 방지를 위해 끝 2자리는 *로 표시됩니다.</td></tr>
<% End IF %>
</table>
</form>

		</td>
	</tr>
	<tr>
		<td class="id_btn">
			<% IF LeftId="" Then %>
			<input type="button" title="" value="검 색" class="button2" onclick="checkIdsearch()">
			<input type="button" title="" value="취 소" class="button1" onclick="window.close()">
			<% Else %>
			<input type="button" title="" value="확 인" class="button1" onclick="window.close()">
			<% End IF %>
		</td>
	</tr>
</table>
</body>
</html>