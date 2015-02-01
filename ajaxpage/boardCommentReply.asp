<!-- #include virtual = common/dbcon.asp -->
<%
Idx=Request("idx")
Page=Request("Page")
BBSCode=Request("BBSCode")

Call HK_BBSSetup(BBsCode)
IF HK_ComYN=False Then Response.End

DBcon.CLose
SET DBcon=Nothing
%>

<div style='padding-top:5px;'>
<form id='commentReplyfrm_<%=Idx%>' method='post' style='margin:0'>
<input type='hidden' name='idx' value='<%=Idx%>'>
<input type='hidden' name='bbscode' value='<%=bbscode%>'>
<input type='hidden' name='Page' value='<%=Page%>'>
<table cellpadding='0' cellspacing='0' width='100%' align='center'>
<colgroup>
    <col width='*'></col>
    <col width='108'></col>
</colgroup>
    <% IF HK_ComMode="" AND Session("useridx")="" Then %>
    <tr>
        <td align='left' style='padding:0 0 3px 0;font-size:12px;'>
            작성자 : <input type='text' name='name' class='input' size='10' maxlength='10'>
            비밀번호 : <input type='password' name='pwd' class='input' size='10' maxlength='10'>
        </td>
    </tr>
    <% End IF %>
    <tr>
        <td><textarea name='content' style='width: 99%;height:45px;' class='input'></textarea></td>
        <td width='108' align='right' style=''><a href="<%=WriteModeChk(HK_ComMode,"javascript:boardcommentReply('commentReplyfrm_"&Idx&"')","")%>"><img src="/common/memberimg/view_answerbutton.gif" border='0'></a></td>
    </tr>
</table>
</form>
</div>