<div class="m_login">
    <% IF Session("useridx")="" Then %>
    <form name="login" method="post" action="/member/login_ok.asp" onSubmit="mainLoginInputSendit(login);event.returnValue = false;" style='margin:0;'>
    <input type='hidden' name='guestCHK' value='<%=guestCHK%>'>
    <input type='hidden' name='returnURL' value='<%=returnURL%>'>
    <dl>
        <dt>
            <input name="userid" maxlength='15' type=text class="input1" style="width:135px; height:13px;" tabindex="1" onkeydown="mainLoginInputSendit(login);"><br/>
            <input name="passwd" maxlength='50' type="password" class="input1" style="width:135px; height:13px;" tabindex="2" onkeydown="mainLoginInputSendit(login);">
        </dt>
        <dd><input type="button" value="LOGIN" class="m_login_btn" onclick='mainLoginSend(login);' style='cursor:pointer;' /></dd>
    </dl>
    </form>
    <p class="m_login_txt"><a href="javascript:go_menu('yak')">·회원가입</a><a href="javascript:go_menu('id_seek')">·아이디찾기</a><a href="javascript:go_menu('pw_seek')">·비밀번호찾기</a></p>
    <% Else %>
    <dl>
        <dt style='color: #ffffff;'><%=Session("username")%></b>님 환영합니다!</dt>
        <dd><input type="button" value="LOGOUT" class="m_login_btn" onclick="location.href='/member/login_ok.asp?logout=1'" /></dd>
    </dl>
    <p class="m_login_txt"></p>
    <% End IF %>
    <ul>
        <li>
        <a href="javascript:go_menu('modify')"><img src="/images/m_mypage.gif" /></a><a href="javascript:go_menu('favorite')"><img src="/images/m_bookmark.gif" /></a></li>
    </ul>
</div>