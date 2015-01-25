<!--#include virtual = common/ADdbcon.asp-->
<%
Idx=Request("idx")
Page=Request("page")
Search=Request("Search")
SearchStr=Request("SearchStr")

IF CSTR(idx)="0" Then
	Response.write Execjavaalert("접근할수 없는 사용자코드입니다.\n다시시도해주세요.",0)
	Response.end
End IF

IF Idx<>"" Then
	Sql="SELECT id,pwd,name,email,tel FROM admin WHERE idx="&idx
		
	Set Rs=DBcon.Execute(Sql)
	IF Not(Rs.Bof Or Rs.Eof) Then
		id=ReplaceTextField(Rs("id")) : pwd=ReplaceTextField(Rs("pwd"))
		name=ReplaceTextField(Rs("name")) : email=ReplaceTextField(Rs("email"))
		tel=ReplaceTextField(Rs("tel"))
	End IF
	Set Rs=Nothing

	TitleTag="수정"
	Sort=2
Else
	TitleTag="등록"
	Sort=1
End IF

Set Rs=Nothing
DBcon.Close
Set DBcon=Nothing
%>

<!--#include virtual = admin/common/adminHeader.asp-->
<SCRIPT LANGUAGE="JavaScript">
<!--
function sendit(){
	var f=document.boardform;
	if (f.id.value==""){
		alert("ID 를 입력하여 주십시요.");
		f.id.focus();
		return;
	}
	if (hangul_chk(f.id.value) != true ){
		alert("ID에 한글이나 여백은 사용할 수 없습니다.");
		f.userid.focus();
	 	return;
	}
	if (f.id.value.length < 4 || f.id.value.length > 15) {
		alert("ID는 4~15자리입니다.");
		f.id.focus();
		return;
	}
	if (f.pwd.value==""){
		alert("비밀번호를 입력하여 주십시요.");
		f.pwd.focus();
		return;
	}
	if (hangul_chk(f.pwd.value) != true ){
		alert("비밀번호에 한글이나 여백은 사용할 수 없습니다.");
		f.pwd.focus();
	 	return;
	}
	if (f.pwd.value.length < 6 || f.pwd.value.length > 15) {
		alert("비밀번호는 6~15자리입니다.");
		f.pwd.focus();
		return;
	}
	if(f.name.value==""){
		alert("이름을 입력하세요.");
		f.name.focus();
		return;
	}
	f.target="iframes";
	f.submit();
}
function hangul_chk(word) {
	var str = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz1234567890-";

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
//-->
</SCRIPT>

<!--#include virtual = admin/common/topimg.htm-->

<table border="0" cellpadding="0" cellspacing="0" align="center" width='100%'>
<colgroup>
<col width='200'></col>
<col width='*'></col>
</colgroup>
	<tr>
		<td valign="top"><!--#include virtual = admin/common/menubar.asp--></td>
		<td valign="top" style='padding-left:10px;'>
			<table cellpadding="2" cellspacing="0" width='880'>
				<tr>
					<td>
						<table cellpadding="0" cellspacing="0" class="menu" width="720">
							<tr>
								<td style='color:#39518C;'><img src='/admin/image/titleArrow2.gif'><b>관리자관리</td>
							</tr>
						</table>
					</td>
				</tr>
				<tr>
					<td>
						<table width="100%" border="1" cellpadding="3" cellspacing="0" bordercolor='#BDBEBD' class="menu" style='border-collapse: collapse'>
						<form name="boardform" action="adminaddOk.asp" method="post">
						<input type='hidden' name='sort' value='<%=Sort%>'>
						<input type='hidden' name='idx' value='<%=Idx%>'>
							<tr>
								<td width='15%' bgcolor="#F6F6F6">&nbsp;아이디</td>
								<td width='35%'><input name="id" type="text" class="input" size="40" maxlength='15' value='<%=id%>'></td>
								<td width='15%' bgcolor="#F6F6F6">&nbsp;비밀번호</td>
								<td width='35%'><input name="pwd" type="password" class="input" size="40" maxlength='15' value='<%=pwd%>'></td>
							</tr>
							<tr>
								<td bgcolor="#F6F6F6">&nbsp;성명</td>
								<td><input name='name' type='text' size='40' maxlength='10' class='input' Value='<%=name%>'></td>
								<td bgcolor="#F6F6F6">&nbsp;전화번호</td>
								<td><input name="tel" type="text" class="input" size="40" maxlength='15' value='<%=tel%>'></td>
							</tr>
							<tr>
								<td bgcolor="#F6F6F6">&nbsp;Email</td>
								<td colspan='3'><input name="email" type="text" class="input" size="101" maxlength='50' value='<%=email%>'></td>
							</tr>
						</form>
						<iframe name='iframes' frameborder='0' width='100%' height='0'></iframe>
						</table>
					</td>
				</tr>
				<tr>
					<td>
						<table cellpadding='0' cellspacing='0' width='100%' class='menu'>
							<tr>
								<td align='right'>
									<img src='/admin/image/icon/bwrite.gif' style='cursor:pointer;' onclick='sendit()'>
									<a href='adminlist.asp?page=<%=Page%>&search=<%=Search%>&searchStr=<%=searchStr%>'><img src='/admin/image/icon/bback.gif' border='0'></a>
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
</body>
</html>