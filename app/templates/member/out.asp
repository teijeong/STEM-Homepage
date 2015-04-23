<!--#include virtual = common/dbcon.asp-->
<% HK_returnURL="/member/out.asp" %>
<!--#include virtual = common/sessionchk.asp-->
<%
Dim Sql,MemberRec,i
Dim id,name,icode,Zip,addr1,addr2,tel,phone,email,sosok,classes,job,NList

Sql="Select name,id,icode,email,zipcode,addr1,addr2,tel from members Where idx=?"
Set objCmd = Server.CreateObject("ADODB.Command")
With objCmd
    .ActiveConnection = DBcon
    .CommandType = adCmdText
    .CommandText = Sql
    
    .Parameters.Append .CreateParameter("@idx", adBigint, adParamInput, 8, Session("useridx"))
End With
Set MemberRec = objCmd.Execute()
Set objCmd = Nothing

id=MemberRec("id") : name=MemberRec("name") : addr1=ReplaceTextField(MemberRec("addr1"))
addr2=ReplaceTextField(MemberRec("addr2")) : email=ReplaceTextField(MemberRec("email"))

Set MemberRec=Nothing
DBcon.Close
Set DBcon=Nothing
%>
<!--#include virtual = "/inc/body.asp"-->
<SCRIPT LANGUAGE="JavaScript">
<!--
function sendit(){
    if(exitmember.pwd.value==""){
        alert("비밀번호를 입력해주세요");
        exitmember.pwd.focus();
        return;
    }
    if(exitmember.content.value==""){
        alert("탈퇴사유를 입력해주세요");
        exitmember.content.focus();
        return;
    }
    exitmember.submit();
}
//-->
</SCRIPT>
<% mNum=6 : sNum=4 %>
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

<p style="padding:10px 5px; line-height:1.8em;">그 동안 불편하셨던 점이나 불만사항을 알려주시면 적극 반영하여 향후 더욱 좋은 서비스로 개선하도록 하겠습니다.<br>정확한 회원탈퇴를 위해서 로그인시 입력하셨던 비밀번호를 다시 한번 입력해주시기 바립니다.</p>
<form name='exitmember' method='post' action='outOK.asp'>
<table cellspacing="0" class="tbl_join" summary="회원탈퇴">
<caption>회원탈퇴</caption>
<colgroup>
    <col width="120">
    <col>
</colgroup>
    <thead>
    <tr>
        <th scope="row" height='20'>아이디</th>
        <td><%=ID%></td>
    </tr>
    <tr>
        <th scope="row" height='20'>이름</th>
        <td><%=Name%></td>
    </tr>
    <tr>
        <th scope="row">비밀번호</th>
        <td><input class="input" size="16" type="password" name="pwd" value=""></td>
    </tr>
    </thead>
    <tbody>
    <tr>
        <th scope="row">탈퇴사유</td>
        <td style="padding:5px 0 5px 10px"><input type="text" class="input" size="40" name='content' maxlength='30'>&nbsp;30자 이내로 간략히 작성해주세요.</td>
    </tr>
    </tbody>
</table>
</form>
<p style="padding:15px 0; text-align:center;">
    <input type="button" title="" value="회원탈퇴" class="button2" style='cursor:pointer;' onclick="sendit()">
    <input type="button" title="" value="취소" class="button1" style='cursor:pointer;' onclick="history.back()">
</p>

                    </li>
                </ul>
            </div>
        </div>
    </div>
    <!--//container-->
<!--#include virtual = "/inc/footer.asp"-->
                    
        