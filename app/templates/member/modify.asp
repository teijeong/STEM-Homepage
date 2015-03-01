<!--#include virtual = common/dbcon.asp-->
<% HK_returnURL="/member/modify.asp" %>
<!--#include virtual = common/sessionchk.asp-->
<%
Dim Sql,MemberRec,i,strLocation
Dim id,name,icode,Zip,addr1,addr2,tel,email,phone,job,note,mailling

Sql="Select id,pwd,name,zipcode,addr1,addr2,tel,phone,email,filename,EmailYN,Memsort,smsYN,birthday,sex from members Where idx=?"
Set objCmd = Server.CreateObject("ADODB.Command")
With objCmd
    .ActiveConnection = DBcon
    .CommandType = adCmdText
    .CommandText = Sql
    
    .Parameters.Append .CreateParameter("@idx", adBigint, adParamInput, 8, Session("useridx"))
End With
Set Rs = objCmd.Execute()
Set objCmd = Nothing

id=ReplaceTextField(Rs("id")) : pwd=Rs("pwd")
name=ReplaceTextField(Rs("name"))
Zip=Split(Rs("zipcode"),"-") : addr1=ReplaceTextField(Rs("addr1"))
addr2=ReplaceTextField(Rs("addr2")) : tel=Split(Rs("tel"),"-")
phone=Split(Rs("phone"),"-") : email=ReplaceTextField(Rs("email"))
filename=Rs("filename")
EmailYN=Rs("EmailYN")
smsYN=Rs("smsYN")
Memsort=Rs("memsort")

birthday=Split(Rs("birthday"),"-")
sex=ReplaceTextField(Rs("sex"))

EmailStr = Split(email,"@")

Set MemberRec=Nothing
DBcon.Close
Set DBcon=Nothing
%>

<!--#include virtual = "/inc/body.asp"-->
<SCRIPT LANGUAGE="JavaScript">
<!--
// 한글 입력 검색
function hangul_chk(word) {
    var str = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz1234567890-";

    for (i=0; i< word.length; i++){
        idcheck = word.charAt(i);
        for ( j = 0 ;  j < str.length ; j++){
            if (idcheck == str.charAt(j)) break;
                 if (j+1 == str.length){
                   return false;
             }
         }
     }
    return true;
}

// 한글 입력 검색
function email_chk(word) {
    var str = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz1234567890-._@";

    for (i=0; i< word.length; i++)
    {
        idcheck = word.charAt(i);

        for ( j = 0 ;  j < str.length ; j++){

            if (idcheck == str.charAt(j)) break;

                 if (j+1 == str.length){
                   return false;
                 }
             }
         }
         return true;
}

function sendit(){
    var    Join=document.Join;

    if (Join.birthday[0].value==""){
        alert("생년월일을 입력하여 주십시요.");
        Join.birthday[0].focus();
        return;
    }
    if (Join.birthday[1].value==""){
        alert("생년월일을 입력하여 주십시요.");
        Join.birthday[1].focus();
        return;
    }
    if (Join.birthday[2].value==""){
        alert("생년월일을 입력하여 주십시요.");
        Join.birthday[2].focus();
        return;
    }
    if (Join.passwd.value==""){
        alert("비밀번호를 입력하여 주십시요.");
        Join.passwd.focus();
        return;
    }
    if (hangul_chk(Join.passwd.value) != true ){
        alert("비밀번호에 한글이나 여백은 사용할 수 없습니다.");
        Join.passwd.focus();
         return;
    }
    if (Join.passwd.value.length < 6 || Join.passwd.value.length > 15) {
        alert("비밀번호는 6~15자리입니다.");
        Join.passwd.focus();
        return;
    }
    if (Join.passwd_check.value==""){
        alert("비밀번호 확인을 입력하여 주십시요.");
        Join.passwd_check.focus();
        return;
    }
    if (Join.passwd.value!==Join.passwd_check.value){
        alert("비밀번호가 일치하지 않습니다. 다시 입력하여 주십시요.");
        Join.passwd.focus();
        return;
    }
    if(Join.email1.value==""){
        alert("이메일을 입력하세요");
        Join.email1.focus();
        return;
    }
    if(Join.email2.value==""){
        alert("이메일을 입력하세요");
        Join.email2.focus();
        return;
    }
    Join.email.value=Join.email1.value + "@" +Join.email2.value;

    if (email_chk(Join.email.value) != true ){
        alert("이메일 주소에 한글이나 여백은 사용할 수 없습니다.");
        Join.email1.focus();
         return;
    }
    if( (Join.tel[0].value + Join.tel[1].value + Join.tel[2].value).length !=0 ){
        if(Join.tel[0].value==""){
            alert("전화번호 국번을 선택하세요.");
            return;
        }
        if(Join.tel[1].value==""){
            alert("전화번호를 입력하세요.");
            Join.tel[1].focus();
            return;
        }
        if(Join.tel[2].value==""){
            alert("전화번호를 입력하세요.");
            Join.tel[2].focus();
            return;
        }
    }
    if(Join.phone[0].value==""){
        alert("휴대전화번호 국번을 선택하세요.");
        return;
    }
    if(Join.phone[1].value==""){
        alert("휴대전화번호를 입력하세요.");
        Join.phone[1].focus();
        return;
    }
    if(Join.phone[2].value==""){
        alert("휴대전화번호를 입력하세요.");
        Join.phone[2].focus();
        return;
    }
    Join.target="iframes";
    Join.submit();
}
function domain_chk()    {
    if (document.Join.email_domain.value!="") {
        document.Join.email2.value=document.Join.email_domain.value;
        document.Join.email2.readOnly=true;
    } else {
        document.Join.email2.value="";
        document.Join.email2.readOnly=false;
        document.Join.email2.focus();
    }
}
//-->
</SCRIPT>

<% mNum=6 : sNum=3 %>
<!--#include virtual = "/inc/top.asp"-->
    <!--container-->
    <div id="container">
        <div class="contain">
            <div class="s_contents">
                <!--#include virtual = "/inc/right_login.asp"-->
                <!--#include virtual = "/inc/left.asp"-->
            </div>
            <div class="con">
                <ul>
                    <li class="stit"><img src="/images/stit<%=mNum%>_<%=sNum%>.gif" alt="" /></li>
                    <li class="con_img">

<p style="text-align:right;"><img src="/images/ico_arrow_orange.png" alt="" title="" /> 필수 입력 사항입니다.</p>
<form name='Join' method='post' action='/member/joinOk.asp?sort=2' enctype="multipart/form-data">
<input name="email" type="hidden" class="input" value='<%=email%>'>
<input name="name" type="hidden" class="input" value='<%=Name%>'>
<input name="userid" type='hidden' value="<%=Id%>">
<input name="memsort" type='hidden' value="<%=memsort%>">
<table cellspacing="0" class="tbl_join" summary="개인회원정보입력">
<caption>개인회원정보입력</caption>
<colgroup>
    <col width="110">
    <col>
</colgroup>
<thead>
    <tr>
        <th scope="row" height='20'>이름</th>
        <td style="padding:5px 0 5px 10px;"><%=Name%></td>
    </tr>
</thead>
<tbody>
    <tr>
        <th scope="row" class="import">아이디</th>
        <td style="padding:5px 0 5px 10px;"><%=id%></td>
    </tr>
    <tr>
        <th scope="row" class="import">생년월일</th>
        <td style="padding:5px 0 5px 10px;">
            <input name="birthday" value='<%=Birthday(0)%>' maxlength='4' type="text" class="input" onKeyPress='if( (event.keyCode<48) || (event.keyCode>57) ) event.returnValue=false;' style='IME-MODE:disabled;width:80px' />년
            <input name="birthday" value='<%=Birthday(1)%>' maxlength='2' type="text" class="input" onKeyPress='if( (event.keyCode<48) || (event.keyCode>57) ) event.returnValue=false;' style='IME-MODE:disabled;width:50px' />월
            <input name="birthday" value='<%=Birthday(2)%>' maxlength='2' type="text" class="input" onKeyPress='if( (event.keyCode<48) || (event.keyCode>57) ) event.returnValue=false;' style='IME-MODE:disabled;width:50px' />일
        </td>
    </tr>
    <tr>
        <th scope="row" class="import">성별</th>
        <td style="padding:5px 0 5px 10px;">
            <input type="radio" name="sex" value="남" <%=ChangeChecked("남",Sex)%>>남
            <input type="radio" name="sex" value="여" <%=ChangeChecked("여",Sex)%>>여
        </td>
    </tr>
    <tr>
        <th scope="row" class="import">비밀번호</th>
        <td style="padding:5px 0 5px 10px;"><input name="passwd" type="password" class="input" size="15" maxlength='15'> * 6~15자로 입력해주세요.</td>
    </tr>
    <tr>
        <th scope="row" class="import">비밀번호 확인</th>
        <td style="padding:5px 0 5px 10px;"><input name="passwd_check" type="password" class="input" size="15" maxlength='15'></td>
    </tr>
    <tr>
        <th scope="row" class="import">E-mail</th>
        <td style="padding:5px 0 5px 10px;">
            <input name="email1" size="20" maxlength="25" type="text" class="input" value="<%=EmailStr(0)%>">
            @
            <input name="email2" size="23" maxlength="25" type="text" class="input" readonly tabindex="-1" value='<%=EmailStr(1)%>'>
            <select name="email_domain" onChange="domain_chk();" class='input'>
                <option value="" selected >이메일선택</option>
                <option value="chol.com" <%=Selcheck("chol.com",EmailStr(1))%>>chol.com</option>
                <option value="dreamwiz.com" <%=Selcheck("dreamwiz.com",EmailStr(1))%>>dreamwiz.com</option>
                <option value="empas.com" <%=Selcheck("empas.com",EmailStr(1))%>>empas.com</option>
                <option value="freechal.com" <%=Selcheck("freechal.com",EmailStr(1))%>>freechal.com</option>
                <option value="hanafos.com" <%=Selcheck("hanafos.com",EmailStr(1))%>>hanafos.com</option>
                <option value="hanmail.net" <%=Selcheck("hanmail.net",EmailStr(1))%>>hanmail.net</option>
                <option value="hanmir.com" <%=Selcheck("hanmir.com",EmailStr(1))%>>hanmir.com</option>
                <option value="hitel.net" <%=Selcheck("hitel.net",EmailStr(1))%>>hitel.net</option>
                <option value="hotmail.com" <%=Selcheck("hotmail.com",EmailStr(1))%>>hotmail.com</option>
                <option value="korea.com" <%=Selcheck("korea.com",EmailStr(1))%>>korea.com</option>
                <option value="naver.com" <%=Selcheck("naver.com",EmailStr(1))%>>naver.com</option>
                <option value="nate.com" <%=Selcheck("nate.com",EmailStr(1))%>>nate.com</option>
                <option value="netian.com" <%=Selcheck("netian.com",EmailStr(1))%>>netian.com</option>
                <option value="yahoo.co.kr" <%=Selcheck("yahoo.co.kr",EmailStr(1))%>>yahoo.co.kr</option>
                <option value="">직접입력</option>
            </select>
             * 아이디/비번 분실시 필수.
        </td>
    </tr>
    <tr>
        <th scope="row" class="import">핸드폰번호</th>
        <td style="padding:5px 0 5px 10px;">
            <select name="phone" style='width:100px;' class='input'>
                <option value="" selected="selected">선택하세요</option>
                <option value="010" <%=SelCheck("010",phone(0))%>>010</option>
                <option value="011" <%=SelCheck("011",phone(0))%>>011</option>
                <option value="016" <%=SelCheck("016",phone(0))%>>016</option>
                <option value="017" <%=SelCheck("017",phone(0))%>>017</option>
                <option value="018" <%=SelCheck("018",phone(0))%>>018</option>
                <option value="019" <%=SelCheck("019",phone(0))%>>019</option>
            </select>
            -
            <input name="phone" type="text" class='input' size="4" maxlength='4' onKeyPress='if( (event.keyCode<48) || (event.keyCode>57) ) event.returnValue=false;' style='IME-MODE:disabled' value='<%=phone(1)%>'>
            -
            <input name="phone" type="text" class='input' size="4" maxlength='4' onKeyPress='if( (event.keyCode<48) || (event.keyCode>57) ) event.returnValue=false;' style='IME-MODE:disabled' value='<%=phone(2)%>'>
        </td>
    </tr>
    <tr>
        <th scope="row">전화번호</th>
        <td style="padding:5px 0 5px 10px;">
            <select name="tel" style='width:100px;' class='input'>
                <option value="" selected="selected">선택하세요</option>
                <option value="02" <%=SelCheck("02",Tel(0))%>>서울 (02)</option>
                <option value="031" <%=SelCheck("031",Tel(0))%>>경기 (031)</option>
                <option value="032" <%=SelCheck("032",Tel(0))%>>인천 (032)</option>
                <option value="033" <%=SelCheck("033",Tel(0))%>>강원 (033)</option>
                <option value="041" <%=SelCheck("041",Tel(0))%>>충남 (041)</option>
                <option value="042" <%=SelCheck("042",Tel(0))%>>대전 (042)</option>
                <option value="043" <%=SelCheck("043",Tel(0))%>>충북 (043)</option>
                <option value="0502" <%=SelCheck("0502",Tel(0))%>>Dacom(0502)</option>
                <option value="0505" <%=SelCheck("0505",Tel(0))%>>KT (0505)</option>
                <option value="051" <%=SelCheck("051",Tel(0))%>>부산 (051)</option>
                <option value="052" <%=SelCheck("052",Tel(0))%>>울산    (052)</option>
                <option value="053" <%=SelCheck("053",Tel(0))%>>대구 (053)</option>
                <option value="054" <%=SelCheck("054",Tel(0))%>>경북 (054)</option>
                <option value="055" <%=SelCheck("055",Tel(0))%>>경남 (055)</option>
                <option value="061" <%=SelCheck("061",Tel(0))%>>전남 (061)</option>
                <option value="062" <%=SelCheck("062",Tel(0))%>>광주 (062)</option>
                <option value="063" <%=SelCheck("063",Tel(0))%>>전북 (063)</option>
                <option value="064" <%=SelCheck("064",Tel(0))%>>제주 (064)</option>
                <option value="070" <%=SelCheck("070",Tel(0))%>>인터넷 (070)</option>
            </select>
            -
            <input name="tel" type="text" class="input" size="4"  maxlength='4' onKeyPress='if( (event.keyCode<48) || (event.keyCode>57) ) event.returnValue=false;' style='IME-MODE:disabled' value='<%=tel(1)%>'>
            -
            <input name="tel" type="text" class="input" size="4" maxlength='4' onKeyPress='if( (event.keyCode<48) || (event.keyCode>57) ) event.returnValue=false;' style='IME-MODE:disabled' value='<%=tel(2)%>'>
        </td>
    </tr>
    <tr>
        <th scope="row" class="import">주소</th>
        <td style="padding:5px 0 5px 10px;">
            <input name="zip" type="text" class="input" size="5" readonly value="<%=Zip(0)%>">
            -
            <input name="zip" type="text" class="input" size="6" readonly value="<%=Zip(1)%>">
            <input type="button" title="" value="우편번호 검색" class="button1" onClick="zipcodeck('name','430','310','scroll','Join','zip','addr1','addr2')">
            <p style="padding:4px 0 0 0;"><input name="addr1" type="text" class="input" size="50" readonly value="<%=Addr1%>"></p>
            <p style="padding:4px 0 0 0;"><input name="addr2" type="text" class="input" size="50" maxlength='50' value="<%=Addr2%>"> (상세주소입력)</p>
        </td>
    </tr>
    <tr>
        <th scope="row">알림 수신 설정</th>
        <td style="padding:5px 0 5px 10px;">
            <input name="smsYN" type="radio" value="1" <%=ChangeChecked(1,smsYN)%> style='border:0px;'>
            SMS 수신합니다.
            <input name="smsYN" type="radio" value="0" <%=ChangeChecked(0,smsYN)%> style='border:0px;'>
            SMS 수신하지 않습니다.<br>

            <input name="emailYN" type="radio" value="1" <%=ChangeChecked(1,emailYN)%> style='border:0px;'>
            이메일 정보를 받겠습니다.
            <input name="emailYN" type="radio" value="0" <%=ChangeChecked(0,emailYN)%> style='border:0px;'>
            이메일 정보를 받지 않겠습니다.
        </td>
    </tr>
</tbody>
</table>
</form>
<iframe name='iframes' frameborder='0' width='0' height='0'></iframe>
<p style="padding:15px 0; text-align:center;">
    <input type="button" title="" value="회원정보수정" class="button2" style='cursor:pointer;' onclick="sendit()">
    <input type="button" title="" value="취 소" class="button1" style='cursor:pointer;' onclick="history.back()">
</p>

                    </li>
                </ul>
            </div>
        </div>
    </div>
    <!--//container-->
<!--#include virtual = "/inc/footer.asp"-->
