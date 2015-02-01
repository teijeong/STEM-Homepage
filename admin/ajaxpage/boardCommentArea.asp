<!--#include virtual = common/dbcon.asp-->
<%
Dim Page
Idx=Request("idx")
bbscode=Request("bbscode")
Page=GetPage()
PageSize=20

Set Rs=Server.CreateObject("ADODB.RecordSet")
'===========================================코멘트 리스트 Get========================================
Sql="Select Top "&PageSize&" name,content,regdate,idx,pwd,co_relevel,co_delYN,WriteID FROM VIEW_bComment_writer WHERE boardidx="&Idx&" AND idx NOT IN (select top "&(Page-1)*PageSize&" idx from commentAdmin where boardidx="&Idx&" order by co_Ref desc, co_ReLevel ASC, Idx DESC) Order By co_Ref desc, co_ReLevel ASC, Idx DESC"
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
                LevelView="<div style='padding:0 5px 0 "&(Len(CommentAllrec(5,i))-1)*15&"px; float:left;'><img src='/common/memberimg/co_reply.gif' border='0'></div>"
            Else
                LevelView=""
            End IF

            Response.Write "<tr><td style='padding: 10px 0 10px 0;'><div style='width:100%;'>"&Vbcrlf
            Response.Write "    "&LevelView&"<div style='float:left;'><span style='color: #9C9A9C;font-weight:bold;'>"&CommentAllrec(0,i)&"</span> "&CommentAllrec(7,i)&" <span style='color: #BDBABD;font-size:11px;'>"&CommentAllrec(2,i)&"</span>"
            IF CommentAllrec(6,i)="True" Then
                Response.Write "    <div style='color: #B71700;'>삭제된 게시물 입니다.</div>"&Vbcrlf
            Else
                Response.Write "        <img src='/common/memberimg/icon_edit.gif' style='cursor:pointer' onclick=""boardcommentEditView('CommentReply_Area"&i&"',"&CommentAllrec(3,i)&",'"&bbscode&"','"&page&"')"">"&vbcrlf
                Response.Write "        <img src='/common/memberimg/icon_del.gif' style='cursor:pointer' onclick=""viewboardCommentPwdInput('yes','visible',"&CommentAllrec(3,i)&",'"&bbscode&"','"&page&"')"">"&Vbcrlf
                Response.Write "        <img src='/common/memberimg/icon_reply.gif' style='cursor:pointer' alt='reply' onclick=""viewboardCommentReply('CommentReply_Area"&i&"',"&CommentAllrec(3,i)&",'"&bbscode&"','"&page&"')"">"&Vbcrlf
                Response.Write "    <br>"&Vbcrlf
                Response.Write "    <div style='color: #636563; word-break:break-all; line-height:1.2; padding: 2px 0 0 0;'>"&ReplaceBr(CommentAllrec(1,i))&"</div>"&Vbcrlf
            End IF
            Response.Write "</div></div><div id='CommentReply_Area"&i&"' name='CommentReply_Area"&i&"'></div></td></tr>"&Vbcrlf
            Response.Write "<tr><td height='1' bgcolor='#D5D5D5'></td></tr>"&Vbcrlf
        Next
    End IF
End Function
%>

<div id="boardcommentPwdINPUTDiv" name="boardcommentPwdINPUTDiv" style="position:absolute; visibility:hidden;"></div>
<div id="boardactDiv" name="boardactDiv" style="position:absolute; "></div>


<form name='commentfrm' id='commentfrm' method='post'>
<input type='hidden' name='idx' value='<%=Idx%>'>
<input type='hidden' name='bbscode' value='<%=bbscode%>'>
<table cellpadding='0' cellspacing='0' width='100%' align='center'>
<colgroup>
    <col width='*'></col>
    <col width='103'></col>
</colgroup>
    <tr>
        <td><textarea name='content' style='height:50px; width:99%;word-break:break-all;' class='input'></textarea></td>
        <td valign='bottom' style='padding-bottom:1px'><a href='javascript:boardcommentGo();'><img src="/common/memberimg/view_answerbutton.gif" border='0'></a></td>
    </tr>
</table>
</form>

<table width='100%' align='center' border="0" cellspacing="0" cellpadding="0" style='word-break:break-all;' class='menu'>
    <%=PT_CommentList()%>
</table>

<% IF Count=0 Then %>
<br>
<% Else %>
<table width="100%" align="center">
    <tr>
        <td height="30" align="center" style="color:#cdcdcd;"><%=PT_SpPageLink("viewBoardCommentArea","'"&idx&"','"&bbscode&"'","yes")%></td>
    </tr>
</table>
<% End IF %>
