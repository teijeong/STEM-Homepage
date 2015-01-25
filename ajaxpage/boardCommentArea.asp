<!--#include virtual = common/dbcon.asp-->
<%
Dim Page
Idx=Request("idx")
bbscode=Request("bbscode")
Page=GetPage()
PageSize=20

Call HK_BBSSetup(BBsCode)
IF HK_ComYN=False Then Response.End

Set Rs=Server.CreateObject("ADODB.RecordSet")
'===========================================코멘트 리스트 Get========================================
Sql="Select Top "&PageSize&" name,content,regdate,idx,pwd,co_relevel,co_delYN FROM commentAdmin WHERE boardidx="&Idx&" AND idx NOT IN (select top "&(Page-1)*PageSize&" idx from commentAdmin where boardidx="&Idx&" Order By co_Ref desc, co_ReLevel ASC, Idx DESC) Order By co_Ref desc, co_ReLevel ASC, Idx DESC"
Rs.Open Sql,DBcon,1

IF Not(Rs.Bof Or Rs.Eof) Then
	Record_Cnt=Dbcon.Execute("select count(*) from commentAdmin where boardidx="&Idx)
	TotalPage=Int((CInt(Record_Cnt(0))-1)/CInt(PageSize)) +1
	CommentAllrec=Rs.GetRows
	Count=Record_Cnt(0)
Else
	Count=0
	TotalPage=1
End If
Rs.Close
'====================================================================================================

Set Rs=Nothing
DBcon.Close
Set DBcon=Nothing

Function PT_CommentList()
	Dim i
	IF IsArray(CommentAllrec) Then
		For i=0 To Ubound(CommentAllrec,2)

			IF Len(CommentAllrec(5,i))<>1 Then
				LevelView="<td style='width:"&(Len(CommentAllrec(5,i))-1)*18&"px; padding: 0 3px 0 0;' align='right' valign='top'><img src='/common/memberimg/co_reply.gif' border='0' align='absmiddle'></td>"
			Else
				LevelView=""
			End IF

			Response.Write "<tr><td style='padding: 10px 0 10px 0;'><table cellpadding='0' cellspacing='0' width='100%' border='0'><tr>"&Vbcrlf
			Response.Write "	"&LevelView&"<td style='line-height:1.3;font-size:12px;padding:0;'><span style='color: #9C9A9C;font-weight:bold;'>"&CommentAllrec(0,i)&"</span> <span style='color: #BDBABD;font-size:11px;'>"&CommentAllrec(2,i)&"</span>"
			IF CommentAllrec(6,i)="True" Then
				Response.Write "	<div style='color: #B71700;'>삭제된 게시물 입니다.</div>"&Vbcrlf
			Else
				Response.Write "		<img src='/common/memberimg/icon_edit.gif' style='cursor:pointer' onclick=""boardcommentEditView('CommentReply_Area"&i&"',"&CommentAllrec(3,i)&",'"&bbscode&"','"&page&"')"">"&vbcrlf
				IF CommentAllrec(4,i)="" Then
					Response.Write "		<img src='/common/memberimg/icon_del.gif' style='cursor:pointer' onclick=""viewboardCommentPwdInput('yes','visible',"&CommentAllrec(3,i)&",'"&bbscode&"','"&page&"',event)"">"&Vbcrlf
				Else
					Response.Write "		<img src='/common/memberimg/icon_del.gif' style='cursor:pointer' onclick=""viewboardCommentPwdInput('','visible',"&CommentAllrec(3,i)&",'"&bbscode&"','"&page&"',event)"">"&Vbcrlf
				End IF
				Response.Write "		<img src='/common/memberimg/icon_reply.gif' style='cursor:pointer' alt='reply' onclick=""viewboardCommentReply('CommentReply_Area"&i&"',"&CommentAllrec(3,i)&",'"&bbscode&"','"&page&"')"">"&Vbcrlf
				Response.Write "	<br>"&Vbcrlf
				Response.Write "	<div style='color: #636563; word-break:break-all; line-height:1.2; padding: 2px 0 0 0;'>"&ReplaceBr(CommentAllrec(1,i))&"</div>"&Vbcrlf
			End IF
			Response.Write "</td></tr></table><div id='CommentReply_Area"&i&"' name='CommentReply_Area"&i&"'></div></td></tr>"&Vbcrlf
			Response.Write "<tr><td height='1' background='/common/dpageimg/line_b.gif' style='padding:0;'></td></tr>"&Vbcrlf

		Next
	End IF
End Function
%>

<div id="boardactDiv" name="boardactDiv" style="position:absolute; visibility:hidden;"></div>

<form name='commentfrm' id='commentfrm' method='post' style='margin:0px;'>
<input type='hidden' name='idx' value='<%=Idx%>'>
<input type='hidden' name='bbscode' value='<%=bbscode%>'>
<table cellpadding='0' cellspacing='0' width='100%' align='center'>
	<% IF HK_ComMode="" AND Session("useridx")="" Then %>
	<tr>
		<td align='left' style='padding:0 0 3px 0; font-size:12px;'>
			작성자 : <input type='text' name='name' class='input' size='10' maxlength='10'>
			비밀번호 : <input type='password' name='pwd' class='input' size='10' maxlength='10'>
		</td>
	</tr>
	<% End IF %>
	<tr>
		<td style='padding:0;'><textarea name='content' style='width: 99%;height:45px;' class='input'></textarea></td>
		<td width='108' align='right' style='padding:0;'><a href="<%=WriteModeChk(HK_ComMode,"javascript:boardcommentGo()","")%>"><img src="/common/memberimg/view_answerbutton.gif" border='0'></a></td>
	</tr>
</table>
</form>

<table width='100%' align='center' border="0" cellspacing="0" cellpadding="0" style='table-layout:fixed;word-break:break-all;'>
	<%=PT_CommentList()%>
</table>

<% IF Count=0 Then %>
<br>
<% Else %>
<table width="100%" align="center">
	<tr>
		<td height="30" align="center" style="color:#cdcdcd;padding:0;"><%=PT_SpPageLink("viewBoardCommentArea","'"&idx&"','"&bbscode&"'","yes")%></td>
	</tr>
</table>
<% End IF %>