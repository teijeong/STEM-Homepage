<!-- #include virtual = common/dbcon.asp -->
<%
Idx=Request("idx")
Page=Request("Page")
BBSCode=Request("BBSCode")

Sql="Select content,pwd,IsNull(useridx,'') As useridx,boardidx,cadwrite From CommentAdmin Where idx="&Idx
Set Rs=DBcon.Execute(Sql)

IF Rs.Bof Or Rs.Eof Then
    Response.write ExecJavaAlert("게시물 정보를 찾을수 없습니다.\n다시시도해주세요.",3)
    Response.End
Else
    content=Rs("content")
    inputPwd=Rs("pwd")
    inputuseridx=Rs("useridx")
    boardidx=Rs("boardidx")
    cadwrite=Rs("cadwrite")
End IF

IF cadwrite=True Then
    Response.write ExecJavaAlert("작성자 본인만 수정가능합니다.",3)
    Response.End
ElseIF inputPwd="" Then
    IF CStr(inputuseridx)<>CStr(Session("useridx")) Then
        Response.write ExecJavaAlert("작성자 본인만 수정가능합니다.",3)
        Response.End
    End IF
End IF

DBcon.Close
Set DBcon=Nothing
%>

<div style='padding-top:5px;'>
<form id='commentEditfrm_<%=Idx%>' method='post' style='margin:0'>
<input type='hidden' name='idx' value='<%=Idx%>'>
<input type='hidden' name='bbscode' value='<%=bbscode%>'>
<input type='hidden' name='Page' value='<%=Page%>'>
<table cellpadding='0' cellspacing='0' width='100%' align='center'>
<colgroup>
    <col width='*'></col>
    <col width='108'></col>
</colgroup>
    <% IF inputPwd<>"" Then %>
    <tr>
        <td align='left' style='padding:0 0 3px 0;font-size:12px;'>
            비밀번호 : <input type='password' name='pwd' class='input' size='10' maxlength='10'>
        </td>
    </tr>
    <% End IF %>
    <tr>
        <td><textarea name='content' style='width: 99%;height:45px;' class='input'><%=content%></textarea></td>
        <td width='108' align='right' style=''><a href="javascript:boardcommentEdit('commentEditfrm_<%=Idx%>')"><img src="/common/memberimg/view_commentEdit.gif" border='0'></a></td>
    </tr>
</table>
</form>
</div>