<!--#include virtual = common/ADdbcon.asp-->
<%
Dim Sql,Rs,Allrec,Page,PageSize,Record_Cnt,TotalPage,Count

Page=Request("page")
PageSize=20

seroutmember = Request("seroutmember")
serMemsort = Request("serMemsort")
serOrderbyStr=Request("serOrderbyStr")
serOrderbyDec=Request("serOrderbyDec")
searchitem=Request("searchitem")
searchstr=ReplaceENSINE(Request("searchstr"))

IF Page="" Then	Page=1
IF serOrderbyStr="" Then serOrderbyStr="idx"
IF serOrderbyDec="" Then serOrderbyDec="DESC"
IF searchstr<>"" Then strWhere = strWhere & " AND "&SearchItem&" LIKE N'%"&searchstr&"%' "
IF serMemsort<>"" Then strWhere = strWhere & " AND Memsort = "&serMemsort&" "
IF seroutmember<>"" Then strWhere = strWhere & " AND outmember = "&seroutmember&" "

Set Rs=Server.CreateObject("ADODB.RecordSet")
Sql="Select top "&PageSize&" idx,name,id,memsort,email,tel,regdate,lastLogin,loginCnt,phone,emailYN,outmember,outDate from members where 1=1 "&strWhere&" And idx not in (select top "&(Page-1)*Pagesize&" idx from members where 1=1 "&strWhere&" order by "&serOrderbyStr&" "&serOrderbyDec&") order by "&serOrderbyStr&" "&serOrderbyDec
Rs.Open Sql,dbcon,1

IF Not(Rs.Bof Or Rs.Eof) Then
	Record_Cnt=Dbcon.Execute("select count(*) from members where 1=1 "&strWhere)
	Count=Record_Cnt(0)
	TotalPage=Int((CInt(Count)-1)/CInt(PageSize)) +1 
	Allrec=Rs.GetRows
Else
	TotalPage=1
End IF

Rs.Close
Set Rs=Nothing
DBcon.Close
Set DBcon=Nothing

Function PT_Mlist
	Dim i,No
	IF Page=1 Then
		No=Count
	Else
		No=Count-(Page-1)*Pagesize
	End IF
	IF IsArray(Allrec) Then
		For i=0 To Ubound(Allrec,2)
			TrBG="" : TrRowSpan=""
			IF Allrec(10,i)=0 Then
				MailYNStr="<span style='color:red'>이메일수신을 받지않습니다.</span>"
			Else
				MailYNStr="<span style='color:blue'>이메일수신을 허용합니다.</span>"
			End IF

			IF Allrec(11,i)=1 Then
				TrBG=" style='background-color: #FFE8E9' "
				TrRowSpan=" rowspan='2' "
			End IF
			LinkTag="addmember.asp?idx="& Allrec(0,i) &"&seroutmember="& seroutmember &"&serMemsort="& serMemsort &"&serOrderbyStr="& serOrderbyStr &"&serOrderbyDec="& serOrderbyDec &"&searchitem="& searchitem &"&searchstr="& searchstr

			Response.Write "<tr align='center' "&TrBG&">"&Vbcrlf
			Response.Write "<td "&TrRowSpan&"><input type='checkbox' name='chkidx' value='"&Allrec(0,i)&"'></td>"&Vbcrlf
			Response.Write "<td height='25' "&TrRowSpan&">"&No&"</td>"&Vbcrlf
			Response.Write "<td "&TrRowSpan&"><a href='"&LinkTag&"'>"&ChangeMemSort(Allrec(3,i))&"</a></td>"&Vbcrlf
			Response.Write "<td "&TrRowSpan&"><a href='"&LinkTag&"'>"&Allrec(1,i)&"<br>"&Allrec(2,i)&"</a></td>"&Vbcrlf
			Response.Write "<td><a href='"&LinkTag&"'>"&Allrec(5,i)&"<br>"&Allrec(9,i)&"</a></td>"&Vbcrlf
			Response.Write "<td><a href='"&LinkTag&"'>"&Allrec(4,i)&"<br>"&MailYNStr&"</a></td>"&Vbcrlf
			Response.Write "<td><a href='"&LinkTag&"'>"&Left(Allrec(6,i),10)&"<br>"&MID(Allrec(6,i),11)&"</a></td>"&Vbcrlf
			Response.Write "<td><a href='"&LinkTag&"'>"&Left(Allrec(7,i),10)&"<br>"&MID(Allrec(7,i),11)&"</a></td>"&Vbcrlf
			Response.Write "<td><a href='"&LinkTag&"'>"&Allrec(8,i)&"</a></td>"&Vbcrlf
			Response.Write "</tr>"&Vbcrlf
			IF Allrec(11,i)=1 Then
				Response.Write "<tr "&TrBG&"><td height='25' colspan='5' style='color: #A60000;' align='right'>"&Vbcrlf
				Response.Write "본 회원은 <b>"&Allrec(12,i)&"</b> 탈퇴처리 된 회원입니다."&Vbcrlf
				Response.Write "<input type='button' value='영구삭제' class='input' style='cursor:pointer' onclick='memDel("&Allrec(0,i)&",2)'>"&Vbcrlf
				Response.Write "<input type='button' value='복 구' class='input' style='cursor:pointer' onclick='memDel("&Allrec(0,i)&",3)'>"&Vbcrlf
				Response.Write "</td></tr>"&Vbcrlf
			End IF

			No=No-1
		Next
	Else
		Response.Write "<tr><td colspan='9' align='center' height='150'>검색된 회원이 없습니다.</td></tr>"&Vbcrlf
	End IF
End Function
%>

<!--#include virtual = admin/common/adminheader.asp-->
<SCRIPT LANGUAGE="JavaScript">
<!--
var checkCnt=0;
function allCheck(str){
	var chkidx = document.getElementsByName(str);
	if (checkCnt==0){
		checkedStr="true";
		checkCnt=1;
	}else{
		checkedStr="";
		checkCnt=0;
	}
	for(i=0;i<chkidx.length;i++){
		chkidx[i].checked=checkedStr;
	}
}
function MemberDel(){
	var chkidx = document.getElementsByName('chkidx');
	var cnt=0;

	for(i=0;i<chkidx.length;i++){
		if(chkidx[i].checked){
			cnt++;
		}
	}
	if(cnt==0){
		alert("삭제하실 회원을 선택해주세요.");
		return;
	}
	memform.action='MemberDel.asp?sort=1';
	memform.submit();
}
function ExcelDown(){
	var chkidx = document.getElementsByName('chkidx');
	var cnt=0;

	for(i=0;i<chkidx.length;i++){
		if(chkidx[i].checked){
			cnt++;
		}
	}
	if(cnt==0){
		alert("엑셀다운로드 받을 회원을 선택해주세요.");
		return;
	}
	memform.action='ExcelDown.asp';
	memform.submit();
}
function memDel(idx,sort){
	if(sort==2){
		var value=confirm("회원을 삭제하면 관련 데이터 모두 삭제됩니다.\n정말로 삭제하시겠습니까?");
	}else{
		var value=confirm("해당 회원을 복구하시겠습니까?");
	}
	if(value){
		document.memform.action='memberDel.asp?sort='+sort+'&idx='+idx;
		document.memform.submit();
	}
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
						<table width="100%" border="0" cellspacing="0" cellpadding="0" class="menu">
							<tr>
								<td style='color: #39518C;'><img src='/admin/image/titleArrow2.gif'><b>회원리스트</td>
							</tr>
						</table>
					</td>
				</tr>
				<tr>
					<td>
<table width='100%' border='1' cellspacing='0' cellpadding='3' bordercolor='#BDBEBD' class='menu' style='border-collapse: collapse'>
<form name='searchfrm' method='get' action='memberlist.asp'>
	<tr><td bgcolor='#DFDFDF' align='center'><b>검색항목</b></td></tr>
	<tr>
		<td align='right' bgcolor='#DFDFDF'>
			<table width='100%' border='0' cellspacing='0' cellpadding='2' class='menu'>
			<tr>
				<td width='15%'>
					<select name='seroutmember' style='width:100%;'>
						<option value=''>탈퇴여부전체</option>
						<option value='0' <%=SelCheck("0",seroutmember)%>>사용중회원</option>
						<option value='1' <%=SelCheck("1",seroutmember)%>>탈퇴회원</option>
					</select>
				</td>
				<td width='15%'>
					<select name='serMemsort' style='width:100%;'>
						<option value=''>회원등급전체</option>
						<option value='0' <%=SelCheck("0",serMemsort)%>>일반회원</option>
						<option value='1' <%=SelCheck("1",serMemsort)%>>전문가회원</option>
					</select>
				</td>
				<td width='15%'>
					<select name='serOrderbyStr' style='width:100%;'>
						<option value='name' <%=SelCheck("name",serOrderbyStr)%>>정렬항목:이름</option>
						<option value='idx' <%=SelCheck("idx",serOrderbyStr)%>>정렬항목:등록일</option>
						<option value='lastLogin' <%=SelCheck("lastLogin",serOrderbyStr)%>>정렬항목:최종접속</option>
						<option value='loginCnt' <%=SelCheck("loginCnt",serOrderbyStr)%>>정렬항목:접속횟수</option>
					</select>
				</td>
				<td width='15%'>
					<select name='serOrderbyDec' style='width:100%;'>
						<option value='ASC' <%=SelCheck("ASC",serOrderbyDec)%>>정렬방식:오름차순</option>
						<option value='DESC' <%=SelCheck("DESC",serOrderbyDec)%>>정렬방식:내림차순</option>
					</select>
				</td>
				<td width='*'>
					<select name='searchitem' style='width:100%;'>
						<option value='name' <%=SelCheck("name",searchitem)%>>이름</option>
						<option value='id' <%=SelCheck("id",searchitem)%>>아이디</option>
						<option value='email' <%=SelCheck("email",searchitem)%>>이메일</option>
					</select>
				</td>
				<td width='100'>
					<input type='text' name='searchstr' style='width:100%;' class='input' value='<%=SearchStr%>'>
				</td>
				<td width='70'>
					<input type='button' value='검색하기' style='cursor:pointer; width:100%; color: blue;' onclick='searchfrm.submit();' class='btn'>
				</td>
			</tr>
			</table>
		</td>
	</tr>
</form>
</table>
					</td>
				</tr>
				<tr>
					<td>
						<table width="100%" border="0" cellspacing="0" cellpadding="0">
							<tr>
								<td align='right' style='padding-top:5px;'>
									<a href='addmember.asp'><img src='/admin/image/icon/bt_addMember.gif' border='0' align='absmiddle'></a>
									<img src='/admin/image/icon/bt_selMemDel.gif' border='0' align='absmiddle' style='cursor:pointer;' onclick='MemberDel();'>
									<img src='/admin/image/icon/bt_selMemExcel.gif' border='0' align='absmiddle' style='cursor:pointer;' onclick='ExcelDown();'>
								</td>
							</tr>
						</table>
					</td>
				</tr>
				<tr>
					<td>
						<table width='100%' border='1' cellspacing='0' cellpadding='3' bordercolor='#BDBEBD' class='menu' style='border-collapse: collapse'>
							<form name='memform' method='post' action=''>
							<input type='hidden' name='memsort' value='<%=serMemsort%>'>
							<input type='hidden' name='Page' value='<%=Page%>'>
							<input type='hidden' name='serOrderbyStr' value='<%=serOrderbyStr%>'>
							<input type='hidden' name='serOrderbyDec' value='<%=serOrderbyDec%>'>
							<input type='hidden' name='searchitem' value='<%=searchitem%>'>
							<input type='hidden' name='searchstr' value='<%=searchstr%>'>
							<input type='hidden' name='seroutmember' value='<%=seroutmember%>'>
							<tr align='center' bgcolor='#E4E4E4'>
								<td width='30'><a href='javascript:allCheck("chkidx")'>선택</a></td>
								<td width='35' height='25'>No</td>
								<td width='80'>회원분류</td>
								<td width=''>이름/아이디</td>
								<td width='90'>연락처/휴대폰</td>
								<td width=''>이메일</td>
								<td width='80'>등록일</td>
								<td width='80'>최종접속</td>
								<td width='40'>접속수</td>
							</tr>
							<%PT_Mlist%>
							</form>
						</table>
					</td>
				</tr>
				<tr>
					<td>
						<table width="100%" border="0" cellspacing="0" cellpadding="0">
							<tr>
								<td align='center'><%=PT_PageLink("memberlist.asp","seroutmember="&seroutmember&"&serMemsort="&serMemsort&"&serOrderbyStr="&serOrderbyStr&"&serOrderbyDec="&serOrderbyDec&"&searchitem="&searchitem&"&searchstr="&searchstr&"")%></td>
							</tr>
						</table>
					</td>
				</tr>
				<tr>
					<td>
<fieldset class='menu'><legend align="left"><b>☞회원관리 메모☜</b></legend>
<table class='menu' align='center' width='100%'>
	<tr>
		<td>
			회원삭제시 <b>삭제한 회원은 붉은색으로 표시</b>되며 로그인이 불가능한 상태로 변경됩니다.<br>
			<span style='background-color:#FFE8E9;'>삭제된 회원정보에는 <b>영구삭제,복구메뉴가 표시</b>되며</span> 영구삭제시 해당 회원의 정보가 최종삭제됩니다.<br>
		</td>
	</tr>
	<tr><td height='5'></td></tr>
	</table>
</fieldset>

					</td>
				</tr>
			</table>
		</td>
	</tr>
</table>

<!--#include virtual = admin/common/bottom.html-->