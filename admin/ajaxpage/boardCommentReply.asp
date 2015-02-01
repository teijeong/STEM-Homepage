<%@codepage="65001" language="VBScript"%>
<%
Session.CodePage = 65001
Response.CharSet = "utf-8"

Idx=Request("idx")
Page=Request("Page")
BBSCode=Request("BBSCode")
%>

<div style='padding-top:5px;'>
<form id='commentReplyfrm_<%=Idx%>' method='post' style='margin:0'>
<input type='hidden' name='idx' value='<%=Idx%>'>
<input type='hidden' name='bbscode' value='<%=bbscode%>'>
<input type='hidden' name='Page' value='<%=Page%>'>
<table cellpadding='0' cellspacing='0' width='100%' align='center'>
<colgroup>
    <col width='*'></col>
    <col width='103'></col>
</colgroup>
    <tr>
        <td><textarea name='content' style='height:50px; width:99%;word-break:break-all;' class='input'></textarea></td>
        <td valign='bottom' style='padding-bottom:1px'><a href="javascript:boardcommentReply('commentReplyfrm_<%=Idx%>');"><img src="/common/memberimg/view_answerbutton.gif" border='0'></a></td>
    </tr>
</table>
</form>
</div>