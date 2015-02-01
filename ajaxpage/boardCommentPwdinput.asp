<%@codepage="65001" language="VBScript"%>
<%
Session.CodePage = 65001
Response.CharSet = "utf-8"

Idx=Request("idx")
bbscode=Request("bbscode")
Page=Request("Page")
%>

<table width="280" border="0" cellspacing="0" cellpadding="0">
    <tr><td height="5" colspan="3" bgcolor="#494949"></td></tr>
    <tr>
        <td width="5" bgcolor="#494949"></td>
        <td align="center" valign="top" bgcolor="#FFFFFF">
            <table width="270" border="0" cellspacing="0" cellpadding="0">
                <tr height="40" bgcolor="#F0F0F0"><td align='center' style='color: #494949;font-size:12px;'><b>※비밀번호를 입력해주세요.</td></tr>
                <tr><td bgcolor="#E0E0E0" height='1'></td></tr>
                <tr>
                    <td>
                        <table cellpadding="3" cellspacing="0" class="graytext" align='center'>
                        <form name="boardcommentpwdchk" id="boardcommentpwdchk" method="post" onsubmit='boardcommentcheckpwd();event.returnValue= false;'>
                        <input type='hidden' name='idx' value='<%=IDX%>'>
                        <input type='hidden' name='bbscode' value='<%=bbscode%>'>
                        <input type='hidden' name='Page' value='<%=Page%>'>
                            <tr>
                                <td height='30'>
                                    <input type="password" name='pwd' size='20' maxlength='15' style='border:1px solid #D5D5D5'>
                                    <img src="../common/memberimg/bt_submit1.gif" border='0' align='absmiddle' style='cursor:pointer;' onclick='boardcommentcheckpwd()'>
                                </td>
                            </tr>
                        </form>
                        </table>
                    </td>
                </tr>
                <tr><td align="right" valign="top"><img style="CURSOR:pointer;" onclick="viewboardCommentPwdInput('','hidden')" src="/common/dpageimg/bt_close2.gif" /></td></tr>
            </table>
        </td>
        <td width="5" bgcolor="#494949"></td>
    </tr>
    <tr><td height="5" colspan="3" bgcolor="#494949"></td></tr>
</table>