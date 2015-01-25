<!-- #include virtual = common/ADdbcon.asp -->
<%
Idx=Request("idx")
Page=Request("Page")
BBSCode=Request("BBSCode")

Sql="Select content From CommentAdmin Where idx="&Idx
Set Rs=DBcon.Execute(Sql)

IF Rs.Bof Or Rs.Eof Then
	Response.write "alert('게시물 정보를 찾을수 없습니다.\n다시시도해주세요.');"&Vbcrlf
Else
	content=Rs("content")
End IF

%>

<div style='padding-top:5px;'>
<form id='commentEditfrm_<%=Idx%>' method='post' style='margin:0'>
<input type='hidden' name='idx' value='<%=Idx%>'>
<input type='hidden' name='bbscode' value='<%=bbscode%>'>
<input type='hidden' name='Page' value='<%=Page%>'>
<table cellpadding='0' cellspacing='0' width='100%' align='center'>
<colgroup>
	<col width='*'></col>
	<col width='103'></col>
</colgroup>
	<tr>
		<td><textarea name='content' style='height:50px; width:99%;word-break:break-all;' class='input'><%=content%></textarea></td>
		<td valign='bottom' style='padding-bottom:1px'><a href="javascript:boardcommentEditGo('commentEditfrm_<%=Idx%>');"><img src="/common/memberimg/view_commentEdit.gif" border='0'></a></td>
	</tr>
</table>
</form>
</div>