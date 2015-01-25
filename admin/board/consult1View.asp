<!--#include virtual = common/ADdbcon.asp-->
<%
Page=Request("page")
Search=Request("Search")
SearchStr=Request("SearchStr")

Idx=Request("idx")

Sql="Select Writer,email,tel,submit,regdate,wip,filenames,zip,addr1,addr2,icode,phone,sosok,note1,note2,note3,note4,note5,note6,note7,note8,note9,note10,note11,note12,note13,note5Ex,note11Ex,note12Ex FROM consult1 Where idx="&Idx
Set Rs=DBcon.Execute(Sql)

IF Rs.Bof Or Rs.Eof Then
	Response.Write ExecJavaAlert("잘못된 접근입니다.\n이전페이지로 이동합니다.",0)
	Response.End
Else

	Writer=Rs("Writer")
	email=Rs("email")
	tel=Rs("tel")
	submit=Rs("submit") : regdate=Rs("regdate") : wip=Rs("wip")
	filenames=Rs("filenames")
	zip=Rs("zip")
	addr1=Rs("addr1")
	addr2=Rs("addr2")

	icode=Rs("icode")
	phone=Rs("phone")
	sosok=Rs("sosok")
	note1=Rs("note1")
	note2=Rs("note2")
	note3=Rs("note3")
	note4=Rs("note4")
	note5=Rs("note5")
	note6=Rs("note6")
	note7=Rs("note7")
	note8=Rs("note8")
	note9=Rs("note9")
	note10=Rs("note10")
	note11=Rs("note11")
	note12=Rs("note12")
	note13=Rs("note13")
	note5Ex=Rs("note5Ex")
	note11Ex=Rs("note11Ex")
	note12Ex=Rs("note12Ex")
End IF

FilDownTag=DownloadTag(filenames,"board")

IF submit="0" Or Submit=False Then
	Sql="UPDATE consult1 SET Submit=1 Where idx="&Idx
	DBcon.Execute Sql
End IF

Rs.Close
Set Rs=Nothing
DBcon.Close
Set DBcon=Nothing
%>

<!--#include virtual = admin/common/adminHeader.asp-->
<script type="text/javascript" src="/library/adminboardControl.js"></script>
<SCRIPT LANGUAGE="JavaScript">
<!--
function boardDel(idx){
	var value=confirm("해당 게시물을 삭제하시겠습니까?");
	if(value){
		location.href='consult1Del.asp?page=<%=Page%>&search=<%=Search%>&searchstr=<%=SearchStr%>&idx='+idx;
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
			<table cellpadding="2" cellspacing="0" width="880">
				<tr>
					<td>
						<table cellpadding="0" cellspacing="0" class="menu" width="100%">
							<tr>
								<td style='color:#39518C;;'><img src='/admin/image/titleArrow1.gif'><b>후원신청서</td>
							</tr>
						</table>
					</td>
				</tr>
				<tr>
					<td>
						<form name="boardform" action="" method="post">
						<table width="100%" border="1" cellpadding="3" cellspacing="0" bordercolor='#BDBEBD' class="menu" style='border-collapse: collapse; word-break:break-all'>
							<tr bgcolor="#F6F6F6">
								<td align='right' colspan='2'>
									작성일 : <%=Regdate%> <b>(작성IP : <%=WIP%>)</b>
								</td>
							</tr>
							<tr>
								<td width='15%' bgcolor="#F6F6F6" align='center'>이름</td>
								<td width=''><%=Writer%></td>
							</tr>
							<tr>
								<td width='15%' bgcolor="#F6F6F6" align='center'>주민번호</td>
								<td width=''><%=icode%></td>
							</tr>
							<tr>
								<td width='15%' bgcolor="#F6F6F6" align='center'>연락처</td>
								<td width=''><%=tel%></td>
							</tr>
							<tr>
								<td width='15%' bgcolor="#F6F6F6" align='center'>휴대폰</td>
								<td width=''><%=Phone%></td>
							</tr>
							<tr>
								<td width='15%' bgcolor="#F6F6F6" align='center'>E-mail</td>
								<td width=''><%=email%></td>
							</tr>
							<tr>
								<td width='15%' bgcolor="#F6F6F6" align='center'>주소</td>
								<td width=''>[<%=zip%>]<%=addr1%>&nbsp;<%=addr2%></td>
							</tr>
							<tr>
								<td width='15%' bgcolor="#F6F6F6" align='center'>소속</td>
								<td width=''><%=sosok%></td>
							</tr>
							<% IF FileNames<>"" Then %>
							<tr>
								<td bgcolor="#F6F6F6" align='center'>첨부파일</td>
								<td width=''><%=FilDownTag%></td>
							</tr>
							<% End IF %>
						</table>


						<table cellpadding="0" cellspacing="0" class="menu" width="100%">
							<tr>
								<td style='color:#39518C;padding-top:15px;'><img src='/admin/image/titleArrow1.gif'><b>세부내용</td>
							</tr>
						</table>

						<table cellspacing="0" border="1" summary="글 내용을 작성" class="tbl_write" width="100%">
						<caption>세부내용</caption>
						<colgroup>
						<col width="150"><col width="70"><col >
						</colgroup>
						<tbody>
						<tr>
							<th scope="row" rowspan="3">후원기간</th>
							<td class="period" rowspan="2">정기</td>
							<td>
								20<%=ChangeValueBasicStr(note1)%>년 
								<%=ChangeValueBasicStr(note2)%>월 ~ 
								20<%=ChangeValueBasicStr(note3)%>년 
								<%=ChangeValueBasicStr(note4)%>월
							</td>
						</tr>
						<tr>
							<td>
								<%=ChangeValueBasicStr(note5)%>
								<% IF note5Ex<>"" Then %> (<%=note5Ex%>)<% End IF %>
							</td>
						</tr>
						<tr>
							<td class="period">비정기</td>
							<td>
								20<%=ChangeValueBasicStr(note6)%>년 
								<%=ChangeValueBasicStr(note7)%>월 ~ 
								20<%=ChangeValueBasicStr(note8)%>년 
								<%=ChangeValueBasicStr(note9)%>월
							</td>
						</tr>
						<tr>
							<th scope="row">후원방법</th>
							<td colspan="2">
								<%=ChangeValueBasicStr(note10)%>
							</td>
						</tr>
						<tr>
							<th scope="row" rowspan="3">후원성경 및 내용</th>
							<td class="period"><strong>결연후원</strong></td>
							<td>
								‣ 저소득층 어르신과의 1:1 후원<p>
								<%=ChangeValueBasicStr(note11)%>
								<% IF note11Ex<>"" Then %> (<%=note11Ex%>)<% End IF %>
							</td>
						</tr>
						<tr>
							<td class="period"><strong>일반후원</strong></td>
							<td>
								‣ 어르신행사(무의탁어르신 생산잔치 등) 및 긴급구조지원비<p>
								<%=ChangeValueBasicStr(note12)%>
								<% IF note12Ex<>"" Then %> (<%=note12Ex%>)<% End IF %>
							</td>
						</tr>
						<tr>
							<td class="period"><strong>일반후원</strong></td>
							<td>
								‣ 어르신께 필요한 생활용품, 쌀, 약품 및 의료기, 식부자재 등<p>
								<%=ChangeValueBasicStr(note13)%>
							</td>
						</tr>
						</tbody>
						</table>
						</form>

					</td>
				</tr>
				<tr>
					<td align='right'>
						<a href="javascript:boardDel(<%=Idx%>);"><img src='/admin/image/icon/board_del.gif' border='0'></a>
						<a href='consult1.asp?page=<%=Page%>&search=<%=Search%>&searchstr=<%=SearchStr%>'><img src='/admin/image/icon/bt_list.gif' border='0'></a>
					</td>
				</tr>
			</table>
		</td>
	</tr>
</table>

<!--#include virtual = admin/common/bottom.html-->