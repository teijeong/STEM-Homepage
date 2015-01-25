<!--#include virtual = common/ADdbcon.asp-->

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko" lang="ko">
<HEAD>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>비밀번호 변경</title>
<meta http-equiv="Cache-Control" content="no-store, no-cache, must-revalidate">
<meta http-equiv="Pragma" content="No-Cache">
<meta http-equiv="Expires" content="Mon, 06 Jan 1990 00:00:01 GMT">
<link rel="stylesheet" type="text/css" href="/css/shopstyle.css">
<script language='javascript' src='/library/functions.js'></script>
<SCRIPT LANGUAGE="JavaScript">
<!--
window.name='modalwin';

// 한글 입력 검색
function email_chk(word) {
	var str = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz1234567890-._@";
	
	for (i=0; i< word.length; i++)
	{
		idcheck = word.charAt(i);
		
		for ( j = 0 ;  j < str.length ; j++){
		
			if (idcheck == str.charAt(j)) break;
				
     			if (j+1 == str.length){
   				return false;
     			}
     		}
     	}
     	return true;
}

function sendit(){
	var form=document.theform;
	if(form.m_uid.value=="") {
		alert("아이디를 입력해주세요.");
		form.m_uid.focus();
		return;
	}
	if(form.m_pwd.value=="") {
		alert("패스워드를 입력해주세요.");
		form.m_pwd.value="";
		form.m_pwd.focus();
		return;
	}if(form.new_pwd.value.length<6) {
		alert("새 패스워드를 올바로 입력해주세요.\n패스워드는 6~15자입니다.");
		form.new_pwd.value="";
		form.new_pwd.focus();
		return;
	}if(form.new_pwd.value != form.new_pwdre.value){
		alert("새 패스워드와 새 패스워드확인이 일치하지 않습니다.\n다시입력해주세요.");
		form.new_pwd.value="";
		form.new_pwdre.value="";
		form.new_pwd.focus();
		return;
	}
	form.submit();
}
//-->
</SCRIPT>
</head>
<body>

<center style='padding: 15px 0;'>
<table cellpadding='0' cellspacing='0' width='95%' align='center' bgcolor='#6C6C6C'>
	<tr>
		<td align='left'>
			<table cellpadding='1' cellspacing='1' width='100%' align='center' class='menu'>
				<form name='theform' method='post' action='pwdEdit_Ok.asp' target='modalwin'>
				<tr><td bgcolor='#E6E6E6' class='menu' height='30' colspan='2' align='center'><b>비밀번호변경</td></tr>
				<tr height='25'>
					<td width='150' bgcolor='#EFEFEF'>&nbsp;아이디</td>
					<td bgcolor='#FFFFFF'>&nbsp;
						<input type='text' name='m_uid' size='15' maxlength='15' class='input' value='<%=Request.cookies("acountcode")%>'>
					</td>
				</tr>
				<tr height='25'>
					<td bgcolor='#EFEFEF'>&nbsp;패스워드</td>
					<td bgcolor='#FFFFFF'>&nbsp;
						<input type='password' name='m_pwd' size='15' maxlength='15' class='input'>
					</td>
				</tr>
				<tr height='25'>
					<td bgcolor='#EFEFEF'>&nbsp;새패스워드</td>
					<td bgcolor='#FFFFFF'>&nbsp;
						<input type='password' name='new_pwd' size='15' maxlength='15' class='input'>
						&nbsp;(* 6~15자 내로 입력하세요.)
					</td>
				</tr>
				<tr height='25'>
					<td bgcolor='#EFEFEF'>&nbsp;새패스워드확인</td>
					<td bgcolor='#FFFFFF'>&nbsp;
						<input type='password' name='new_pwdre' size='15' maxlength='15' class='input'>
					</td>
				</tr>
				</form>
			</table>
		</td>
	</tr>
	<tr>
		<td>
			<table cellpadding='0' cellspacing='0' width='100%' align='center' bgcolor='#FFFFFF'>
				<tr><td height='5'></td></tr>
				<tr>
					<td align='center'>
						<input type='button' value='등 록' class='btn' onfocus="this.blur();" onclick='sendit();' style='width:80px;'>
						<input type='button' value='취 소' class='btn' onfocus="this.blur();" onclick='window.close();' style='width:80px;'>
					</td>
				</tr>
			</table>
		</td>
	</tr>
</table>
</center>

</body>
</html>