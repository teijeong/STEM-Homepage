<%
returnURL = request("returnURL")
%>
<!--#include virtual = "/inc/body.asp"-->
<% mNum=99 : sNum=2 %>
<!--#include virtual = "/inc/top.asp"-->
    <!-- container -->
    <div id="container">
        <ul>
        <li class="tit_s"><img src="/images/stit<%=mNum%>_<%=sNum%>.png" alt="" /></li>
        <li>

            <form name="login" method="post" action="login_ok.asp" onSubmit="mainLoginInputSendit(login);event.returnValue = false;" style='margin:0;'>
            <input type='hidden' name='guestCHK' value='<%=guestCHK%>'>
            <input type='hidden' name='returnURL' value='<%=returnURL%>'>

            <table width="650" height="290" cellpadding="0" cellspacing="0" class="login">
                <tr>
                    <td>

                        <table width="340" cellpadding="0" cellspacing="0" class="logbox">
                            <tr>
                                <td><input name="userid" maxlength='15' type=text class="memb" style="width:237px; height:27px;" tabindex="1" onkeydown="mainLoginInputSendit(login);"></td>
                                <th rowspan="2"><input type="button" title="" value="로그인" class="btn_aqu" tabindex="3" onclick='mainLoginSend(login);' style='cursor:pointer;'></th>
                            </tr>
                            <tr>
                                <td style="padding-top:5px;"><input name="passwd" maxlength='50' type="password" class="memb" style="width:237px; height:27px;" tabindex="2" onkeydown="mainLoginInputSendit(login);"></td>
                            </tr>
                            <tr>
                                <td colspan="2" style="padding:10px 0;"><input type="button" title="" value="아이디 찾기" class="btn_mid" onclick="javascript:go_menu('id_seek')"> <input type="button" title="" value="비밀번호 찾기" class="btn_mid" onclick="javascript:go_menu('pw_seek')"> <input type="button" title="" value="회원가입" class="btn_mid" onclick="javascript:go_menu('yak')"></td>
                            </tr>
                        </table>

                    </td>
                </tr>
            </table>
            </form>

        </li>
        </ul>
    </div>
    <!-- //container -->
<!--#include virtual = "/inc/footer.asp"-->