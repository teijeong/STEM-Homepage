<!--#include virtual = "/inc/body.asp"-->
<script language="javascript" id="resultProc"></script>
<SCRIPT LANGUAGE="JavaScript">
<!--
function sendit(){
    if (!document.getElementById("dongwi1").checked){
        alert("이용약관을 읽어보시고 동의 여부를 체크해주세요.");
        return;
    }
    if (!document.getElementById("dongwi2").checked){
        alert("개인정보취급방침을 읽어보시고 동의 여부를 체크해주세요.");
        return;
    }
    location.href='/member/join.asp'
}
//-->
</SCRIPT>
<% mNum=6 : sNum=1 %>
<!--#include virtual = "/inc/top.asp"-->
    <!--container-->
    <div id="container">
        <div class="contain">
            <div class="s_contents">
                <!--#include virtual = "/inc/right_login.asp"-->
                <!--#include virtual = "/inc/left.asp"-->
            </div>
            <div class="con">
                <ul class="nostyle">
                    <li class="nostyle stit"><img src="/images/stit<%=mNum%>_<%=sNum%>.gif" alt="" /></li>
                    <li class="nostyle con_img">
                        <p style="text-align:center;"><img src="/images/join_info.gif" /></p>
                        <p style="text-align:center; margin-bottom:30px;"><img src="/images/join_1_on.gif" />&nbsp;&nbsp;<img src="/images/btn_step.gif" />&nbsp;&nbsp;<img src="/images/join_2.gif" />&nbsp;&nbsp;<img src="/images/btn_step.gif" />&nbsp;&nbsp;<img src="/images/join_3.gif" /></p>
                        <!-- 이용약관,개인정보 취급방침 -->
                        <table width="100%" cellpadding="0" cellspacing="0" class="yak">
                            <tr>
                                <td>
                                <p class="yak_tit">이용약관</p>
                                <textarea name="" style="width:99%; height:250px" readonly="readonly">[약   관]</textarea>
                                <p class="right"><input type="checkbox" id="dongwi1" value=""> 이용약관에 동의합니다.</p>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                <p class="yak_tit">개인정보취금방침</p>
                                <textarea name="" style="width:99%; height:250px" readonly="readonly">개인정보의 수집· 이용 목적</textarea>
                                <p class="right"><input type="checkbox" id="dongwi2" value=""> 개인정보 취급 방침에 동의합니다.</p>
                                </td>
                            </tr>
                        </table>
                        <!-- //이용약관,개인정보 취급방침 -->
                        <div class="centerButtonBox">
                            <input type="button" title="" value="회원가입" class="button2" onclick='sendit()'>
                            <input type="button" title="" value="작성취소" class="button1" onclick="javascript:history.back()">
                        </div>
                        <!-- //join -->
                    </li>
                </ul>
            </div>
        </div>
    </div>
    <!--//container-->
<!--#include virtual = "/inc/footer.asp"-->
