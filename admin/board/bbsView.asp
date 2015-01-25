<!--#include virtual = common/ADdbcon.asp-->
<%
Dim Sql,Rs,Allrec,Idx,BBSCode,WIP,Page
Dim title,writer,regdate,content,Ref,ReLevel,TopYN,TopTag,Submit,SortName,filename1
Dim serboardsort,Search,SearchStr

Page=Request("page")
sersel1=Request("sersel1")
BBSCode=Request("BBscode")
serboardsort=Request("serboardsort")
Search=Request("Search")
SearchStr=Request("SearchStr")

Call HK_BBSSetup(Cint(BBsCode))
Idx=Request("idx")

Sql="Select title,writer,regdate,content,Ref,ReLevel,Wip,TopYn,submit,SortName,imgnames,email,startdate,enddate,vodUrl,note1,note2,status FROM BBSList AS B Left Outer Join BoardSort AS S ON BoardSort=S.idx Where b.idx="&Idx
Set Rs=DBcon.Execute(Sql)

IF Not(Rs.Bof Or Rs.Eof) Then
	title=Rs("title")
	writer=Rs("writer")
	regdate=Rs("regdate")
	content=Rs("content")
	Ref=Rs("ref")
	ReLevel=Rs("relevel")
	WIP=Rs("wip")
	TopYN=Rs("topyn")
	Submit=Rs("submit")
	SortName=Rs("SortName")
	ImgNames=Rs("ImgNames")
	email=Rs("email")
	vodUrl=Rs("vodUrl")
	startdate=Rs("startdate") : enddate=Rs("enddate")
	note1=Rs("note1") : note2=Rs("note2")
	status=Rs("status")
End IF
Rs.Close

IF submit="0" Then
	Sql="UPDATE BBSList SET Submit=1 Where idx="&Idx
	DBcon.Execute Sql
End IF

IF TopYn="True" Then TopTag="[공지]"

IF HK_PdsYN = "True" Then
	Set Rs=Server.CreateObject("ADODB.RecordSet")
	Sql="SELECT filenames FROM BBsData WHERE bidx="&idx
	Rs.Open Sql,DBcon,1
	If Not(Rs.Bof Or Rs.Eof) Then FileRec=Rs.GetRows()
	Rs.CLose()
End IF

Set Rs=Nothing
DBcon.Close
Set DBcon=Nothing

Function PT_FileArea()
	IF IsArray(FileRec) Then
	Response.Write "<div class=""attachedFile"">"&Vbcrlf
	Response.Write "	<dl>"&Vbcrlf
	Response.Write "		<dt><img src=""/common/memberimg/iconFiles.gif"" alt=""첨부"" /> <button type=""button"" class=""fileToggle"" onclick=""changeFileArea()"" style='color: #3383AE;'>첨부파일보기("&UBound(FileRec,2)+1&")</button></dt>"&Vbcrlf
	Response.Write "		<dd>"&Vbcrlf
	Response.Write "		<ul class=""files"" style='display:none;' id='fileArea' name='fileArea'>"&Vbcrlf
		For i=0 To UBound(FileRec,2)
			Response.Write "			<li>"&DownloadTag(FileRec(0,i),"board")&"</li>"&Vbcrlf
		Next
	Response.Write "		</ul>"&Vbcrlf
	Response.Write "		</dd>"&Vbcrlf
	Response.Write "	</dl>"&Vbcrlf
	Response.Write "</div>"&Vbcrlf
	End IF
End Function
%>

<!--#include virtual = admin/common/adminHeader.asp-->
<script type="text/javascript" src="/library/prototype.js"></script>
<script type="text/javascript" src="/library/adminboardControl.js"></script>
<SCRIPT LANGUAGE="JavaScript">
<!--
function boardDel(idx){
	var value=confirm("관리자권한으로 해당 게시물의 답변목록도 모두 삭제됩니다.\n선택하신 글을 삭제하시겠습니까?");
	if(value){
		location.href='bbsDel.asp?page=<%=Page%>&sersel1=<%=sersel1%>&bbscode=<%=bbscode%>&serboardsort=<%=serboardsort%>&search=<%=Search%>&searchstr=<%=SearchStr%>&idx='+idx;
	}
}
function changeStatus(){
	var val=confirm("해당게시물의 처리상태를 변경하시겠습니까?");
	if(val){
		document.statusFrm.submit();
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
								<td style='color:#39518C;;'><img src='/admin/image/titleArrow1.gif'><b><%=ChangeAdminBoardTitle(bbscode)%></td>
								<% IF BBscode=100 AND ReLevel="A" Then %>
								<td align='right'>
									<form name='statusFrm' action='bbs_statusChange.asp' method='' target='statsActiframes'>
									<input type='hidden' name='idx' value='<%=idx%>'>
									<input type='hidden' name='bbscode' value='<%=bbscode%>'>
									해당게시물의 게시상태를
									<select name='status' style='background-color: #FFE8E8' onchange='changeStatus()'>
										<option value='0' <%=selCheck(status,"0")%>>접수중</option>
										<option value='1' <%=selCheck(status,"1")%>>진행중</option>
										<option value='2' <%=selCheck(status,"2")%>>완료</option>
									</select>
									으로 변경합니다.
									</form>
								</td>
								<% End IF %>
							</tr>
						</table>
					</td>
				</tr>
				<tr>
					<td>
						<table width="100%" border="1" cellpadding="3" cellspacing="0" bordercolor='#BDBEBD' class="menu" style='border-collapse: collapse; word-break:break-all'>
							<col width='120'></col>
							<col></col>
							<tr bgcolor="#F6F6F6">
								<td align='right' colspan='2'>
									작성일 : <%=Regdate%>
								</td>
							</tr>
						<% IF BBscode=100 Then %>
							<tr>
								<td bgcolor="#F6F6F6">&nbsp;공고상태</td>
								<td><%=Changebbs_status(status)%></td>
							</tr>
						<% End IF %>
						<% IF SortName<>"" Then %>
							<tr>
								<td width='100' bgcolor="#F6F6F6">&nbsp;글분류</td>
								<td><%=SortName%></td>
							</tr>
						<% End IF %>
							<tr>
								<td width='100' bgcolor="#F6F6F6">&nbsp;작성자</td>
								<td><%=Writer%> (<%=WIP%>)</td>
							</tr>
						<% IF Email<>"" Then %>
							<tr>
								<td width='100' bgcolor="#F6F6F6">&nbsp;이메일</td>
								<td><%=Email%></td>
							</tr>
						<% End IF %>

						<% IF BBscode=100 Then %>
							<tr>
								<td width='100' bgcolor="#F6F6F6">&nbsp;모집기간</td>
								<td>
									<%=Startdate%> ~ 
									<%=enddate%>
								</td>
							</tr>
						<% End IF %>

						<% IF HK_VodUrlYN<>"False" Then %>
							<tr>
								<td bgcolor="#F6F6F6">&nbsp;유투브URL</td>
								<td><%=VodUrl%></td>
							</tr>
						<% End IF %>
							<tr>
								<td width='100' bgcolor="#F6F6F6">&nbsp;글제목</td>
								<td><%=TopTag&Title%></td>
							</tr>
						<% IF BBscode=100 Then %>
							<tr>
								<td bgcolor="#F6F6F6">&nbsp;간략설명</td>
								<td><%=note1%></td>
							</tr>
						<% End IF %>
						<% IF ImgNames<>"" Then %>
							<tr>
							<td width='100' bgcolor="#F6F6F6">&nbsp;이미지업로드</td>
							<td><a href='javascript:openWindow(100,100,"/common/imgview.asp?path=board&imgname=<%=ImgNames%>","imgView","yes")'><%=ImgNames%></a></td>
							</tr>
						<% End IF %>
							<tr height='200'>
								<td bgcolor="#F6F6F6">&nbsp;내용</td>
								<td valign='top'>
									<%=PT_FileArea()%>
									<% 'IF ImgNames<>"" Then Response.write "<center><img src='/upload/board/"&ImgNames&"' width='"&ImgSize("board",550,ImgNames)&"'><p></center>" %>
									<%
										'For i=0 To Ubound(Filename)
										'	IF FileName(i)<>"" Then
										'		Exitsts=UCase(mid(filename(i),instrrev(filename(i),".")+1))
										'		IF Exitsts="JPG" Or Exitsts="JPEG" Or Exitsts="GIF" Then
										'			Response.write "<center><img src='/upload/board/"&filename(i)&"' width='"&ImgSize("board",550,filename(i))&"' onclick=""openWindow(0,0,'/common/imgview.asp?path=board&imgname="&filename(i)&"','imgview','no');"" style='cursor:pointer;'></center><br>"
										'		End IF
										'	End IF
										'Next
									%>
									<div id='HKeditorContent' name='HKeditorContent'><%=Content%></div>
								</td>
							</tr>
						</table>
					</td>
				</tr>

<% IF HK_comYn=True Then %>
<tr><td>
<div id="boardCommentDiv" name="boardCommentDiv" style='width:100%;'></div>
<SCRIPT LANGUAGE="JavaScript">viewBoardCommentArea('<%=idx%>','<%=BBscode%>','')</SCRIPT>
</td></tr>
<% End IF%>

				<tr>
					<td align='right'>
					<% IF TopYN="False" AND HK_imgYN="False" Then %>
						<a href='bbsReply.asp?page=<%=Page%>&bbscode=<%=BBsCode%>&sersel1=<%=sersel1%>&idx=<%=Idx%>&ref=<%=Ref%>&relevel=<%=ReLevel%>&serboardsort=<%=serboardsort%>&search=<%=Search%>&searchstr=<%=SearchStr%>'><img src='/admin/image/icon/board_reply.gif' border='0'></a>
					<% End IF %>
						<a href='bbswrite.asp?page=<%=Page%>&bbscode=<%=BBsCode%>&sersel1=<%=sersel1%>&idx=<%=Idx%>&serboardsort=<%=serboardsort%>&search=<%=Search%>&searchstr=<%=SearchStr%>'><img src='/admin/image/icon/board_edit.gif' border='0'></a>
						<a href="javascript:boardDel(<%=Idx%>);"><img src='/admin/image/icon/board_del.gif' border='0'></a>
						<a href='bbslist.asp?page=<%=Page%>&bbscode=<%=BBsCode%>&sersel1=<%=sersel1%>&serboardsort=<%=serboardsort%>&search=<%=Search%>&searchstr=<%=SearchStr%>'><img src='/admin/image/icon/bt_list.gif' border='0'></a>
					</td>
				</tr>
			</table>

		</td>
	</tr>
</table>

<!--#include virtual = admin/common/bottom.html-->
</body>
</html>