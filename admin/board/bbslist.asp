<!--#include virtual = common/ADdbcon.asp-->
<%
Dim Rs,Sql,Allrec,BBSCode
Dim serboardsort,Search,SearchStr
Dim Record_Cnt,TotalPage,PageSize,Page,Count

BBSCode=Request("BBscode")
sersel1=Request("sersel1")
serboardsort=Request("serboardsort")
Search=Replaceensine(ReplaceNoHtml(Request("Search")))
SearchStr=Replaceensine(ReplaceNoHtml(Request("SearchStr")))

Call HK_BBSSetup(BBsCode)
BBsSelectField=GetBoardSortSh(BBsCode,serboardsort)

IF BBsCode="" Or BBsCode=false Then BBsCode=1
IF serboardsort<>"" Then strWhere = strWhere & " AND boardsort="&serboardsort&" "
IF Search<>"" Then strWhere = strWhere & " And "&Search&" LIKE N'%"&SearchStr&"%' "

IF BBscode=100 Then
	IF sersel1<>"" Then strWhere = strWhere & " AND status="&sersel1&" "
End IF

Page=GetPage()
PageSize=20

Set Rs=Server.CreateObject("ADODB.RecordSet")
Sql="select top "&PageSize&" idx,title,regdate,writer,relevel,DelYN,topyn,publicYN,readnum,(select Count(*) From CommentAdmin Where boardidx=b.idx) AS CommentCnt,submit,status from bbsList b WHERE boardidx="&BBsCode & strWhere&" AND idx NOT IN (select top "&(Page-1)*PageSize&" idx from bbsList Where boardidx="&BBsCode & strWhere&" order by Topyn DESC, Ref desc, ReLevel ASC, Idx DESC) order by Topyn DESC, Ref desc, ReLevel ASC, Idx DESC"
Rs.Open Sql,DBcon,1

IF Not(Rs.Bof Or Rs.Eof) Then
	Record_Cnt=Dbcon.Execute("select count(idx) from bbsList Where boardidx="&BBsCode & strWhere)
	TotalPage=Int((CInt(Record_Cnt(0))-1)/CInt(PageSize)) +1
	Allrec=Rs.GetRows
	Count=Record_Cnt(0)
Else
	Count=0
End If
Rs.Close

Sql="SELECT idx,boardname FROM BoardAdmin WHERE idx<>"&BBscode&" ORder by listNum ASC, idx ASC"
Rs.Open Sql,DBcon,1
IF Not(Rs.Bof Or Rs.Eof) Then BoardListRec=Rs.GetRows
Rs.Close

Set Rs=Nothing
DBcon.Close
Set DBcon=Nothing

Function PT_BoardSelBox()
	IF IsArray(BoardListRec) Then
		Response.Write "<select name='targetMoveBoardidx'>"&Vbcrlf
		Response.Write "<option value=''>이동할게시판선택</option>"&Vbcrlf
		For i=0 To Ubound(BoardListRec,2)
			Response.Write "<option value='"&BoardListRec(0,i)&"'>"&BoardListRec(1,i)&"</option>"&Vbcrlf
		Next
		Response.Write "</select>"&Vbcrlf
		Response.Write "<input type='button' value='선택게시물이동' class='btn' style='cursor:pointer; width:100px' onclick='changeBoard()'>"&Vbcrlf
	End IF
End Function

Function PT_BBsList
	Dim i,Num,LevelView,Depth,j,TitleView,TopTag,TrBg,PublicIcon,CommentCnt
	Num=1

	IF IsArray(Allrec) Then
		Num=GetTextNumDesc(Page,Pagesize,Count)
		For i=0 To Ubound(Allrec,2)
			PublicIcon="" : CommentCnt="" : NewIcon="" : TopTag=Num : TrBg="" : StatusStr=""

			IF BBscode=100 And Allrec(4,i)="A" Then
				StatusStr="<div>["&Changebbs_status(Allrec(11,i))&"]</div>"
			End IF

			IF Allrec(9,i)<>0 Then CommentCnt=" <img src='/common/memberimg/CommentCnt.gif'><span style='font-size:11px;'>["&Allrec(9,i)&"]</span>"
			IF Len(Allrec(4,i))<>1 Then
				LevelView="<span style='padding-left:"&(Len(Allrec(4,i))-1)*10&"'><img src='/common/memberimg/icon_re.gif' border='0'></span>"
			Else
				LevelView=""
			End IF

			IF Allrec(7,i)="True" AND Len(Allrec(4,i))=1 Then PublicIcon="<img src='/common/memberimg/public.gif' align='absmiddle' border='0'>"

			IF Allrec(6,i)="True" Then TopTag="<img src='/common/memberimg/icon_notice.gif'>" : TrBg="bgcolor='#F6F6F6'"
			IF Allrec(5,i)="True" Then
				TitleView="삭제된 게시물입니다."
			Else
				TitleView="<a href='bbsView.asp?page="& page &"&BBsCode="& BBsCode &"&idx="& Allrec(0,i) &"&sersel1="& sersel1 &"&serboardsort="& serboardsort &"&search="& Search &"&searchstr="& SearchStr &"'>"&LevelView&PublicIcon&Allrec(1,i)&"</a>"
			End IF

			IF CDate(Allrec(2,i))>=Date() Then NewIcon="&nbsp;<img src='/common/memberimg/ico_new.gif' align='absmiddle' border='0'>"

			Response.Write "<tr align='center' "&TrBg&">"&Vbcrlf
			Response.Write "<td><input type='checkbox' name='chkidx' value='"&Allrec(0,i)&"'></td>"&Vbcrlf
			Response.Write "<td>"&TopTag&"</td>"&Vbcrlf
			Response.Write "<td>"&Allrec(3,i)&"</td>"&Vbcrlf
			Response.Write "<td align='left' style='padding:5px 5px 5px 5px;'>"&StatusStr& TitleView &CommentCnt&NewIcon&"</td>"&Vbcrlf
			Response.Write "<td>"&Allrec(8,i)&"</td>"&Vbcrlf
			Response.Write "<td align='center'>"&ChangeSubmitYN(Allrec(10,i))&"</td>"&Vbcrlf
			Response.Write "<td>"&Left(Allrec(2,i),10)&"</td>"&Vbcrlf
			Response.Write "<td><a href=javascript:boardDel("&Allrec(0,i)&");><img src='/admin/image/icon/bt_del1.gif' border='0'></a></td>"&Vbcrlf
			Response.Write "</tr>"&Vbcrlf
			Num=Num-1
		Next
	Else
		Response.Write "<tr><td colspan='8' align='center' height='100'>등록된 글이 없습니다.</td></tr>"&Vbcrlf
	End IF
End Function
%>

<!--#include virtual = admin/common/adminHeader.asp-->
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
function boardDel(idx){
	var value=confirm("답변글이 있는경우 답변글도 모두 삭제됩니다.\n선택하신 글을 삭제하시겠습니까?");
	if(value){
		boardform.action='bbsdel.asp?idx='+idx;
		boardform.submit();
	}
}
function searchGo(){
	var f=document.search;
	f.submit();
}
function changeBoard(){
	var chkidx = document.getElementsByName('chkidx');
	var cnt=0;

	for(i=0;i<chkidx.length;i++){
		if(chkidx[i].checked){
			cnt++;
		}
	}
	if(cnt==0){
		alert("이동하실 게시물을 선택해주세요.");
		return;
	}
	if(document.all.targetMoveBoardidx.selectedIndex==0){
		alert("게시물을 이동할 게시판을 선택하세요.");
		return;
	}
	boardform.action='BBsMove.asp?targetMoveBoardidx='+document.all.targetMoveBoardidx.value;
	boardform.submit();
}
function boardGroupDel(){
	var chkidx = document.getElementsByName('chkidx');
	var cnt=0;

	for(i=0;i<chkidx.length;i++){
		if(chkidx[i].checked){
			cnt++;
		}
	}
	if(cnt==0){
		alert("삭제하실 게시물을 선택해주세요.");
		return;
	}
	boardform.action='BBsDel.asp?delsort=group';
	boardform.submit();
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
								<td style='color:#39518C;;'><img src='/admin/image/titleArrow1.gif'><b><%=ChangeAdminBoardTitle(bbscode)%></td>
								<td align='right'>

<table border="0" cellpadding="0" cellspacing="3">
<form name='search' method='get' action='bbsList.asp' onsubmit="searchGo();event.returnValue= false;">
<input type='hidden' name='bbscode' value='<%=bbscode%>'>
	<tr>
	  <td>
		<%=BBsSelectField%>
		<% IF BBscode=100 Then %>
		<select align="absMiddle" name="serSel1">
			<option value="">게시상태전체</option>
			<option value="0" <%=selCheck(serSel1,"0")%>>접수중</option>
			<option value="1" <%=selCheck(serSel1,"1")%>>진행중</option>
			<option value="2" <%=selCheck(serSel1,"2")%>>완료</option>
		</select>
		<% End IF %>
		<select align="absMiddle" name="search">
			<option value="title" selected="selected">제 목</option>
			<option value="writer">글쓴이</option>
			<option value="content">글내용</option>
		</select>
	  </td>
	  <td><input class="input" align="absmiddle" name="searchstr"></td>
	  <td><input type='button' value='검색' class='btn' onclick='searchGo();' style='width:80px;'></td>
	</tr>
</form>
</table>
									
								</td>
							</tr>
						</table>
					</td>
				</tr>
				<tr>
					<td>
						<table width="100%" border="1" cellspacing="0" cellpadding="0" class="menu" bordercolor='#BDBEBD' style='border-collapse: collapse'>
							<tr>
								<td height='30' bgcolor='#F6F6F6' align='right'>
									<table width="100%" border="0" cellspacing="0" cellpadding="0" class="menu" bordercolor='#BDBEBD'>
										<tr>
											<td align='left' style='padding-left:5px; color: #59ACFF;'>
												<b>검색게시물 : <%=Count%>건</b>
											</td>
											<td align='right' style='padding-right:5px'>
												<b>일괄처리 옵션 : </b>
												<%PT_BoardSelBox()%>
												<input type='button' value='선택게시물삭제' class='btn' style='cursor:pointer; width:100px; color:red;' onclick='boardGroupDel()'>
											</td>
										</tr>
									</table>
								</td>
							</tr>
						</table>
					</td>
				</tr>
				<tr>
					<td>
						<table width="100%" border="1" cellpadding="0" cellspacing="0" bordercolor='#BDBEBD' class="menu" style='border-collapse: collapse; word-break:break-all; table-layout:fixed;'>
						<form name="boardform" method="post">
						<input type='hidden' name='BBscode' value='<%=BBscode%>'>
						<input type='hidden' name='page' value='<%=page%>'>
						<input type='hidden' name='sersel1' value='<%=sersel1%>'>
						<input type='hidden' name='serboardsort' value='<%=serboardsort%>'>
						<input type='hidden' name='search' value='<%=search%>'>
						<input type='hidden' name='searchstr' value='<%=searchstr%>'>
							<tr height="25" align="center" bgcolor="#F6F6F6">
								<td width='25'><img src='/common/memberimg/list_select.gif' border='0' style='cursor:pointer;' onclick='allCheck("chkidx")'></td>
								<td width="50">순번</td>
								<td width="100">작성자</td>
								<td width='*'>제목</td>
								<td width="50">조회</td>
								<td width="50">확인</td>
								<td width="90">등록일</td>
								<td width="50">관리</td>
							</tr>
							<%PT_BBsList%>
						</form>
						</table>
					</td>
				</tr>
				<tr>
					<td>
						<table cellpadding='0' cellspacing='0' width='100%'>
							<tr>
								<td align='center' width='90%'><%=PT_PageLink("bbslist.asp","BBscode="&BBscode&"&sersel1="&sersel1&"&serboardsort="&serboardsort&"&search="&Search&"&searchstr="&SearchStr)%></td>
								<td align='right' width='10%'><a href='bbswrite.asp?BBsCode=<%=BBsCode%>&serboardsort=<%=serboardsort%>'><img src='/admin/image/icon/bt_write.gif' border='0'></a></td>
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