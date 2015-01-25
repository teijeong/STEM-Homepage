<!--#include virtual = "/inc/body.asp"-->
<SCRIPT LANGUAGE="JavaScript">
<!--
function ID_chk() {
	var ID = eval(Join.userid);

	if (hangul_chk(Join.userid.value) != true ){
		document.getElementById("idMsg").innerHTML="<span style='color:red;'>ID에 한글이나 여백은 사용할 수 없습니다.</span>"
		return;
	}
	if (Join.userid.value.length < 6 || Join.userid.value.length > 15) {
		document.getElementById("idMsg").innerHTML="<span style='color:red;'>6~15자로 입력해주세요.</span>"
		return;
	}else{
		strID=ID.value;
		new Ajax.Updater('actDiv','/common/idcheck.asp', {
			method:'post',
			evalScripts:true,
			parameters: {id: strID},
			encoding : 'utf-8',
			onComplete: function(request){
				json=request.responseText

				if(json=="useY"){
					document.getElementById("idMsg").innerHTML="<span style='color:blue;'>사용가능한 ID입니다.</span>"
					f.email_check.value="true";
				}else if(json=="useN"){
					document.getElementById("idMsg").innerHTML="<span style='color:red;'>이미 사용중인 ID입니다.</span>"
					f.email_check.value="";
				}
			}
		});
	}
}

// 한글 입력 검색
function hangul_chk(word) {
	var str = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz1234567890-";

	for (i=0; i< word.length; i++){
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
	var	Join=document.Join;

	if(Join.name.value==""){
		alert("이름을 입력하세요.");
		Join.name.focus();
		return;
	}
	if (Join.birthday[0].value==""){
		alert("생년월일을 입력하여 주십시요.");
		Join.birthday[0].focus();
		return;
	}
	if (Join.birthday[1].value==""){
		alert("생년월일을 입력하여 주십시요.");
		Join.birthday[1].focus();
		return;
	}
	if (Join.birthday[2].value==""){
		alert("생년월일을 입력하여 주십시요.");
		Join.birthday[2].focus();
		return;
	}
	if (Join.userid.value==""){
		alert("ID 를 입력하여 주십시요.");
		Join.userid.focus();
		return;
	}
	if (hangul_chk(Join.userid.value) != true ){
		alert("ID에 한글이나 여백은 사용할 수 없습니다.");
		Join.userid.focus();
	 	return;
	}
	if (Join.userid.value.length < 6 || Join.userid.value.length > 15) {
		alert("ID는 6~15자리입니다.");
		Join.userid.focus();
		return;
	}
	if (Join.passwd.value==""){
		alert("비밀번호를 입력하여 주십시요.");
		Join.passwd.focus();
		return;
	}
	if (hangul_chk(Join.passwd.value) != true ){
		alert("비밀번호에 한글이나 여백은 사용할 수 없습니다.");
		Join.passwd.focus();
	 	return;
	}
	if (Join.passwd.value.length < 6 || Join.passwd.value.length > 15) {
		alert("비밀번호는 6~15자리입니다.");
		Join.passwd.focus();
		return;
	}
	if (Join.passwd_check.value==""){
		alert("비밀번호 확인을 입력하여 주십시요.");
		Join.passwd_check.focus();
		return;
	}
	if (Join.passwd.value!==Join.passwd_check.value){
		alert("비밀번호가 일치하지 않습니다. 다시 입력하여 주십시요.");
		Join.passwd.focus();
		return;
	}

	if(Join.email1.value==""){
		alert("이메일을 입력하세요");
		Join.email1.focus();
		return;
	}
	if(Join.email2.value==""){
		alert("이메일을 입력하세요");
		Join.email2.focus();
		return;
	}
	Join.email.value=Join.email1.value + "@" +Join.email2.value;

	if (email_chk(Join.email.value) != true ){
		alert("이메일 주소에 한글이나 여백은 사용할 수 없습니다.");
		Join.email1.focus();
	 	return;
	}
	if( (Join.tel[0].value + Join.tel[1].value + Join.tel[2].value).length !=0 ){
		if(Join.tel[0].value==""){
			alert("전화번호 국번을 선택하세요.");
			return;
		}
		if(Join.tel[1].value==""){
			alert("전화번호를 입력하세요.");
			Join.tel[1].focus();
			return;
		}
		if(Join.tel[2].value==""){
			alert("전화번호를 입력하세요.");
			Join.tel[2].focus();
			return;
		}
	}
	if(Join.phone[0].value==""){
		alert("휴대전화번호 국번을 선택하세요.");
		return;
	}
	if(Join.phone[1].value==""){
		alert("휴대전화번호를 입력하세요.");
		Join.phone[1].focus();
		return;
	}
	if(Join.phone[2].value==""){
		alert("휴대전화번호를 입력하세요.");
		Join.phone[2].focus();
		return;
	}
	if (Join.zip[0].value==""){
		alert("우편번호를 입력하여 주십시요.");
		Join.zip[0].focus();
		return;
	}
	if (Join.addr2.value==""){
		alert("세부주소를 입력하여 주십시요.");
		Join.addr2.focus();
		return;
	}

	Join.target="iframes";
	Join.submit();
}
function domain_chk()	{
	if (document.Join.email_domain.value!="") {
		document.Join.email2.value=document.Join.email_domain.value;
		document.Join.email2.readOnly=true;
	} else {
		document.Join.email2.value="";
		document.Join.email2.readOnly=false;
		document.Join.email2.focus();
	}
}
//-->
</SCRIPT>
<% mNum=6 : sNum=1 %>
<!--#include virtual = "/inc/top.asp"-->
	<!--container-->
	<div id="container">
		<div class="contain">
			<div class="s_contents">
				<!--#include virtual = "/inc/right_login.asp"-->
				<!--#include virtual = "/inc/left.asp"-->
			</div>
			<div class="con">
				<ul>
					<li class="stit"><img src="/images/stit<%=mNum%>_<%=sNum%>.gif" alt="" /></li>
					<li class="con_img">
<p style="text-align:center;"><img src="/images/join_info.gif" /></p>
<p style="text-align:center; margin-bottom:30px;"><img src="/images/join_1.gif" />&nbsp;&nbsp;<img src="/images/btn_step.gif" />&nbsp;&nbsp;<img src="/images/join_2_on.gif" />&nbsp;&nbsp;<img src="/images/btn_step.gif" />&nbsp;&nbsp;<img src="/images/join_3.gif" /></p>
<p style="text-align:right;"><img src="/images/ico_arrow_orange.png" alt="" title="" /> 필수 입력 사항입니다.</p>

<form action="joinok.asp" method="post" name="Join" enctype="multipart/form-data">
<input name="email" type="hidden" class="input">
<table cellspacing="0" class="tbl_join" summary="개인회원정보입력">
<caption>개인회원정보입력</caption>
<colgroup>
	<col width="110">
	<col>
</colgroup>
<thead>
	<tr>
		<th scope="row" height='20' class="import">이름</th>
		<td style="padding:5px 0 5px 10px;"><input name="name" maxlength='10' type="text" class="input" style="width:100px" /></td>
	</tr>
</thead>
<tbody>
	<tr>
		<th scope="row" class="import">생년월일</th>
		<td style="padding:5px 0 5px 10px;">
			<input name="birthday" maxlength='4' type="text" class="input" onKeyPress='if( (event.keyCode<48) || (event.keyCode>57) ) event.returnValue=false;' style='IME-MODE:disabled;width:60px' />년
			<input name="birthday" maxlength='2' type="text" class="input" onKeyPress='if( (event.keyCode<48) || (event.keyCode>57) ) event.returnValue=false;' style='IME-MODE:disabled;width:30px' />월
			<input name="birthday" maxlength='2' type="text" class="input" onKeyPress='if( (event.keyCode<48) || (event.keyCode>57) ) event.returnValue=false;' style='IME-MODE:disabled;width:30px' />일
		</td>
	</tr>
	<tr>
		<th scope="row" class="import">성별</th>
		<td style="padding:5px 0 5px 10px;">
			<input type="radio" name="sex" value="남" checked>남
			<input type="radio" name="sex" value="여">여
		</td>
	</tr>
	<tr>
		<th scope="row" class="import">아이디</th>
		<td style="padding:5px 0 5px 10px;">
			<input name="userid" type="text" class="input" size="15" maxlength='15' onBlur="ID_chk()">
			&nbsp;<span id='idMsg'><span style='color:red;'>6~15자로 입력해주세요.</span></span>
		</td>
	</tr>
	<tr>
		<th scope="row" class="import">비밀번호</th>
		<td style="padding:5px 0 5px 10px;"><input name="passwd" type="password" class="input" size="15" maxlength='15'></td>
	</tr>
	<tr>
		<th scope="row" class="import">비밀번호 확인</th>
		<td style="padding:5px 0 5px 10px;"><input name="passwd_check" type="password" class="input" size="15" maxlength='15'></td>
	</tr>
	<tr>
		<th scope="row" class="import">E-mail</th>
		<td style="padding:5px 0 5px 10px;">
			<input name="email1" size="23" maxlength="25" type="text" class="input" value="">
			@
			<input name="email2" size="23" maxlength="25" type="text" class="input" readonly tabindex="-1">
			<select name="email_domain" onChange="domain_chk();" class='input'>
				<option value="" selected >이메일선택</option>
				<option value="chol.com">chol.com</option>
				<option value="dreamwiz.com">dreamwiz.com</option>
				<option value="empas.com">empas.com</option>
				<option value="freechal.com">freechal.com</option>
				<option value="hanafos.com">hanafos.com</option>
				<option value="hanmail.net">hanmail.net</option>
				<option value="hanmir.com">hanmir.com</option>
				<option value="hitel.net">hitel.net</option>
				<option value="hotmail.com">hotmail.com</option>
				<option value="korea.com">korea.com</option>
				<option value="naver.com">naver.com</option>
				<option value="nate.com">nate.com</option>
				<option value="netian.com">netian.com</option>
				<option value="yahoo.co.kr">yahoo.co.kr</option>
				<option value="">직접입력</option>
			</select>
			 * 아이디/비번 분실시 필수.
		</td>
	</tr>
	<tr>
		<th scope="row" class="import">핸드폰번호</th>
		<td style="padding:5px 0 5px 10px;">
			<select name="phone" style='width:100px;' class='input'>
				<option value="" selected="selected">선택하세요</option>
				<option value="010">010</option>
				<option value="011">011</option>
				<option value="016">016</option>
				<option value="017">017</option>
				<option value="018">018</option>
				<option value="019">019</option>
			</select>
			-
			<input name="phone" type="text" class='input' size="4" maxlength='4' onKeyPress='if( (event.keyCode<48) || (event.keyCode>57) ) event.returnValue=false;' style='IME-MODE:disabled'>
			-
			<input name="phone" type="text" class='input' size="4" maxlength='4' onKeyPress='if( (event.keyCode<48) || (event.keyCode>57) ) event.returnValue=false;' style='IME-MODE:disabled'>
		</td>
		</td>
	</tr>
	<tr>
		<th scope="row">전화번호</th>
		<td style="padding:5px 0 5px 10px;">
			<select name="tel" style='width:100px;' class='input'>
				<option value="" selected="selected">선택하세요</option>
				<option value="02">서울 (02)</option>
				<option value="031">경기 (031)</option>
				<option value="032">인천 (032)</option>
				<option value="033">강원 (033)</option>
				<option value="041">충남 (041)</option>
				<option value="042">대전 (042)</option>
				<option value="043">충북 (043)</option>
				<option value="0502">Dacom(0502)</option>
				<option value="0505">KT (0505)</option>
				<option value="051">부산 (051)</option>
				<option value="052">울산	(052)</option>
				<option value="053">대구 (053)</option>
				<option value="054">경북 (054)</option>
				<option value="055">경남 (055)</option>
				<option value="061">전남 (061)</option>
				<option value="062">광주 (062)</option>
				<option value="063">전북 (063)</option>
				<option value="064">제주 (064)</option>
				<option value="070">인터넷 (070)</option>
			</select>
			-
			<input name="tel" type="text" class="input" size="4"  maxlength='4' onKeyPress='if( (event.keyCode<48) || (event.keyCode>57) ) event.returnValue=false;' style='IME-MODE:disabled'>
			-
			<input name="tel" type="text" class="input" size="4" maxlength='4' onKeyPress='if( (event.keyCode<48) || (event.keyCode>57) ) event.returnValue=false;' style='IME-MODE:disabled'>
		</td>
	</tr>
	<tr>
		<th scope="row" class="import">주소</th>
		<td style="padding:5px 0 5px 10px;">
			<input name="zip" type="text" class="input" size="5" readonly>
			-
			<input name="zip" type="text" class="input" size="6" readonly>
			<input type="button" title="" value="우편번호 검색" class="button1" style='cursor:pointer;' onClick="zipcodeck('name','430','310','scroll','Join','zip','addr1','addr2')">
			<p style="padding:4px 0 0 0;"><input name="addr1" type="text" class="input" size="50" readonly></p>
			<p style="padding:4px 0 0 0;"><input name="addr2" type="text" class="input" size="50" maxlength='50'>(상세주소입력)</p>
		</td>
	</tr>
	<tr>
		<th scope="row">알림 수신 설정</th>
		<td style="padding:5px 0 5px 10px;">
			<input name="smsYN" type="radio" class="input" value="1" checked style='border:0px;'>
			SMS 수신합니다.
			<input name="smsYN" type="radio" class="input" value="0" style='border:0px;'>
			SMS 수신하지 않습니다.<br>

			<input name="emailYN" type="radio" class="input" value="1" checked style='border:0px;'>
			이메일 정보를 받겠습니다.
			<input name="emailYN" type="radio" class="input" value="0" style='border:0px;'>
			이메일 정보를 받지 않겠습니다.
		</td>
	</tr>
</tbody>
</table>
</form>
<iframe name='iframes' frameborder='0' width='100%' height='0'></iframe>
<p style="padding:10px 0; text-align:center;">
	<input type="button" title="" value="확인" class="button2" style='cursor:pointer;' onClick="sendit()">
	<input type="button" title="" value="취소" class="button1" style='cursor:pointer;' onClick="history.back()">
</p>

					</li>
				</ul>
			</div>
		</div>
	</div>
	<!--//container-->
<!--#include virtual = "/inc/footer.asp"-->
