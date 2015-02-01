<!--#include virtual = common/ADdbcon.asp-->
<%
Page=Request("page")
seroutmember=Request("seroutmember")
serMemsort = Request("serMemsort")
serOrderbyStr=Request("serOrderbyStr")
serOrderbyDec=Request("serOrderbyDec")
searchitem=Request("searchitem")
searchstr=Request("searchstr")
IDX=Request("IDX")

IF Idx<>"" Then
    Sql="Select id,pwd,name,zipcode,addr1,addr2,tel,phone,email,filename,EmailYN,Memsort,smsYN,birthday,sex From Members Where idx="&Idx
    Set Rs=DBcon.Execute(Sql)

    IF Not(Rs.Bof Or Rs.Eof) THen
        id=ReplaceTextField(Rs("id")) : pwd=Rs("pwd")
        name=ReplaceTextField(Rs("name"))
        Zip=Split(Rs("zipcode"),"-") : addr1=ReplaceTextField(Rs("addr1"))
        addr2=ReplaceTextField(Rs("addr2")) : tel=Split(Rs("tel"),"-")
        phone=Split(Rs("phone"),"-") : email=ReplaceTextField(Rs("email"))
        filename=Rs("filename")
        EmailYN=Rs("EmailYN")
        smsYN=Rs("smsYN")
        Memsort=Rs("memsort")
        EmailStr = Split(email,"@")
        birthday=Split(Rs("birthday"),"-")
        sex=ReplaceTextField(Rs("sex"))
    End IF
    RealOnlyYN="readonly"
Else
    Dim Tel(2),Phone(2),Fax(2),icode(1),EmailStr(1),birthday(2),Zip(1)
    RealOnlyYN=""
End IF

SEt Rs=Nothing
DBcon.Close
Set DBcon=Nothing
%>

<!--#include virtual = admin/common/adminheader.asp-->
<script type='text/javascript' src='/common/calendar.js'></script>
<SCRIPT LANGUAGE="JavaScript">
<!--
// 중복 아이디 체크
function ID_chk() {
    var ID = eval(Join.userid);
        if (hangul_chk(Join.userid.value) != true ){
            alert("ID에 한글이나 여백은 사용할 수 없습니다.");
            Join.userid.focus();
            return;
        }
        if (Join.userid.value.length < 2 || Join.userid.value.length > 15) {
            alert("ID는 2~15자리입니다.");
            Join.userid.focus();
            return;
        }
        if(!Join.userid.value) {
            alert('아이디(ID)를 입력하신 후에 확인하세요!');
            Join.userid.focus();
            return;
        } else {
            var window_left = (screen.width-640)/2;
            var window_top = (screen.height-480)/2;
            window.open('idcheck.asp?userid='+Join.userid.value,"IDcheck",'width=400,height=150,status=no,top=' + window_top + ',left=' + window_left + '');
        }
}

// 한글 입력 검색
function hangul_chk(word) {
    var str = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz1234567890-";

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

    if(Join.name.value==""){
        alert("이름을 입력하세요.");
        Join.name.focus();
        return;
    }
    if (Join.userid.value==""){
        alert("ID 를 입력하여 주십시요.");
        Join.userid.focus();
        return;
    }
    if (hangul_chk(Join.userid.value) != true ){
        alert("ID에 한글이나 여백은 사용할 수 없습니다.");
        Join.userid.focus();
         return;
    }
    if (Join.userid.value.length < 6 || Join.userid.value.length > 15) {
        alert("ID는 6~15자리입니다.");
        Join.userid.focus();
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
    if (Join.passwd.value.length < 2 || Join.passwd.value.length > 15) {
        alert("비밀번호는 2~15자리입니다.");
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
    if( (Join.phone[0].value + Join.phone[1].value + Join.phone[2].value).length !=0 ){
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

<!--#include virtual = admin/common/topimg.htm-->
<table border="0" cellpadding="0" cellspacing="0" align="center" width='100%'>
<colgroup>
<col width='200'></col>
<col width='*'></col>
</colgroup>
    <tr>
        <td valign="top"><!--#include virtual = admin/common/menubar.asp--></td>
        <td valign="top" style='padding-left:10px;'>
            <table cellpadding="2" cellspacing="0" width='880'>
                <tr>
                    <td>
                        <table width="100%" border="0" cellspacing="0" cellpadding="0" class="menu">
                            <tr>
                                <% IF Idx<>"" Then %>
                                <td style='color: #39518C;'><img src='/admin/image/titleArrow2.gif'><b>회원정보수정</td>
                                <% Else %>
                                <td style='color: #39518C;'><img src='/admin/image/titleArrow2.gif'><b>회원등록</td>
                                <% End IF %>
                            </tr>
                        </table>
                    </td>
                </tr>


                <tr>
                    <td>
                        <form action="join_ok.asp" method="post" name="Join" enctype="multipart/form-data">
                        <input name="email" type="hidden" class="input">
                        <input type='hidden' name='idx' value='<%=idx%>'>
                        <table width="100%" border="1" cellpadding="3" cellspacing="0" bordercolor='#BDBEBD' class="menu" style='border-collapse: collapse'>
                            <tr>
                                <td width='100' bgcolor="#F6F6F6">&nbsp;회원등급</td>
                                <td>
                                    <select name='Memsort'>
                                        <option value='0' <%=SelCheck("0",Memsort)%>>일반회원</option>
                                        <option value='1' <%=SelCheck("1",Memsort)%>>전문가회원</option>
                                    </select>
                                </td>
                            </tr>
                            <tr>
                                <td width='100' bgcolor="#F6F6F6">&nbsp;이름</td>
                                <td>
                                    <input name="name" type="text" size="15" maxlength='15' class='input' value='<%=name%>' <%=RealOnlyYN%>>
                                </td>
                            </tr>
                            <tr>
                                <td width='100' bgcolor="#F6F6F6">&nbsp;생년월일</td>
                                <td>
                                    <input name="birthday" value='<%=Birthday(0)%>' maxlength='4' type="text" class="input" onKeyPress='if( (event.keyCode<48) || (event.keyCode>57) ) event.returnValue=false;' style='IME-MODE:disabled;width:80px' />년
                                    <input name="birthday" value='<%=Birthday(1)%>' maxlength='2' type="text" class="input" onKeyPress='if( (event.keyCode<48) || (event.keyCode>57) ) event.returnValue=false;' style='IME-MODE:disabled;width:50px' />월
                                    <input name="birthday" value='<%=Birthday(2)%>' maxlength='2' type="text" class="input" onKeyPress='if( (event.keyCode<48) || (event.keyCode>57) ) event.returnValue=false;' style='IME-MODE:disabled;width:50px' />일
                                </td>
                            </tr>
                            <tr>
                                <td width='100' bgcolor="#F6F6F6">&nbsp;성별</td>
                                <td>
                                    <input type="radio" name="sex" value="남" <%=ChangeChecked("남",Sex)%>>남
                                    <input type="radio" name="sex" value="여" <%=ChangeChecked("여",Sex)%>>여
                                </td>
                            </tr>
                            <tr>
                                <td width='100' bgcolor="#F6F6F6">&nbsp;아이디</td>
                                <td>
                                    <input name="userid" type="text" class="input" size="15" maxlength='15' value='<%=ID%>' <%=RealOnlyYN%>>
                                </td>
                            </tr>
                            <tr>
                                <td width='100' bgcolor="#F6F6F6">&nbsp;패스워드</td>
                                <td>
                                    <input name="passwd" type="password" size="15" maxlength='15' class='input' value='<%=pwd%>'>
                                </td>
                            </tr>
                            <tr>
                                <td width='100' bgcolor="#F6F6F6">&nbsp;패스워드확인</td>
                                <td>
                                    <input name="passwd_check" type="password"  size="15" maxlength='15' class='input' value='<%=pwd%>'>
                                </td>
                            </tr>
                            <tr>
                                <td width='100' bgcolor="#F6F6F6">&nbsp;우편번호</td>
                                <td>
                                    <input name="zip" type="text" class="input" size="5" readonly value='<%=zip(0)%>'>
                                    -
                                    <input name="zip" type="text" class="input" size="5" readonly value='<%=zip(1)%>'>
                                    <img src="/admin/image/mem_addr.gif" style='cursor:pointer' onclick="zipcodeck('name','430','310','scroll','Join','zip','addr1','addr2')" align="absmiddle">
                                </td>
                            </tr>
                            <tr>
                                <td width='100' bgcolor="#F6F6F6">&nbsp;주소</td>
                                <td><input name="addr1" type="text" class="input" size="50" readonly value='<%=addr1%>'></td>
                            </tr>
                            <tr>
                                <td width='100' bgcolor="#F6F6F6">&nbsp;상세주소</td>
                                <td><input name="addr2" type="text" class="input" size="50" maxlength='50' value='<%=addr2%>'></td>
                            </tr>
                            <tr>
                                <td width='100' bgcolor="#F6F6F6">&nbsp;전화번호</td>
                                <td>
                                    <select name="tel" style='width:100px'>
                                        <option value="" selected="selected">선택하세요</option>
                                        <option value="02" <%=SelCheck("02",tel(0))%>>서울 (02)</option>
                                        <option value="031" <%=SelCheck("031",tel(0))%>>경기 (031)</option>
                                        <option value="032" <%=SelCheck("032",tel(0))%>>인천 (032)</option>
                                        <option value="033" <%=SelCheck("033",tel(0))%>>강원 (033)</option>
                                        <option value="041" <%=SelCheck("041",tel(0))%>>충남 (041)</option>
                                        <option value="042" <%=SelCheck("042",tel(0))%>>대전 (042)</option>
                                        <option value="043" <%=SelCheck("043",tel(0))%>>충북 (043)</option>
                                        <option value="0502" <%=SelCheck("0502",tel(0))%>>Dacom(0502)</option>
                                        <option value="0505" <%=SelCheck("0505",tel(0))%>>KT (0505)</option>
                                        <option value="051" <%=SelCheck("051",tel(0))%>>부산 (051)</option>
                                        <option value="052" <%=SelCheck("052",tel(0))%>>울산    (052)</option>
                                        <option value="053" <%=SelCheck("053",tel(0))%>>대구 (053)</option>
                                        <option value="054" <%=SelCheck("054",tel(0))%>>경북 (054)</option>
                                        <option value="055" <%=SelCheck("055",tel(0))%>>경남 (055)</option>
                                        <option value="061" <%=SelCheck("061",tel(0))%>>전남 (061)</option>
                                        <option value="062" <%=SelCheck("062",tel(0))%>>광주 (062)</option>
                                        <option value="063" <%=SelCheck("063",tel(0))%>>전북 (063)</option>
                                        <option value="064" <%=SelCheck("064",tel(0))%>>제주 (064)</option>
                                        <option value="070" <%=SelCheck("070",tel(0))%>>인터넷 (070)</option>
                                    </select>
                                    -
                                    <input name="tel" type="text" size="4"  maxlength='4' onKeyPress='if( (event.keyCode<48) || (event.keyCode>57) ) event.returnValue=false;' style='IME-MODE:disabled' class='input' value='<%=tel(1)%>'>
                                    -
                                    <input name="tel" type="text" size="4" maxlength='4' onKeyPress='if( (event.keyCode<48) || (event.keyCode>57) ) event.returnValue=false;' style='IME-MODE:disabled' class='input' value='<%=tel(2)%>'>
                                </td>
                            </tr>
                            <tr>
                                <td width='100' bgcolor="#F6F6F6">&nbsp;휴대폰번호</td>
                                <td>
                                    <select name="phone" style='width:100px'>
                                        <option value="" selected="selected">선택하세요</option>
                                        <option value="010" <%=SelCheck("010",Phone(0))%>>010</option>
                                        <option value="011" <%=SelCheck("011",Phone(0))%>>011</option>
                                        <option value="016" <%=SelCheck("016",Phone(0))%>>016</option>
                                        <option value="017" <%=SelCheck("017",Phone(0))%>>017</option>
                                        <option value="018" <%=SelCheck("018",Phone(0))%>>018</option>
                                        <option value="019" <%=SelCheck("019",Phone(0))%>>019</option>
                                    </select>
                                    -
                                    <input name="phone" type="text" size="4" maxlength='4' onKeyPress='if( (event.keyCode<48) || (event.keyCode>57) ) event.returnValue=false;' style='IME-MODE:disabled' class='input' value='<%=phone(1)%>'>
                                    -
                                    <input name="phone" type="text" size="4" maxlength='4' onKeyPress='if( (event.keyCode<48) || (event.keyCode>57) ) event.returnValue=false;' style='IME-MODE:disabled' class='input' value='<%=phone(2)%>'>
                                </td>
                            </tr>
                            <tr>
                                <td width='100' bgcolor="#F6F6F6">&nbsp;이메일</td>
                                <td>
                                    <input name="email1" size="25" maxlength="25" type="text" class="input" value="<%=EmailStr(0)%>">
                                    @
                                    <input name="email2" size="23" maxlength="25" type="text" class="input" readonly tabindex="-1" value='<%=EmailStr(1)%>'>
                                    <select name="email_domain" onChange="domain_chk();">
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
                                </td>
                            </tr>
                            <tr>
                                <td width='100' bgcolor="#F6F6F6">&nbsp;SMS수신여부</td>
                                <td>
                                    <input name="smsYN" type="radio" class="input" value="1" checked style='border:0px;'>
                                    SMS수신을 받습니다.
                                    <input name="smsYN" type="radio" class="input" value="0" <%=ChangeChecked(0,smsYN)%> style='border:0px;'>
                                    SMS수신을 받지않습니다.
                                </td>
                            </tr>
                            <tr>
                                <td width='100' bgcolor="#F6F6F6">&nbsp;메일수신여부</td>
                                <td>
                                    <input name="emailYN" type="radio" class="input" value="1" checked style='border:0px;'>
                                    메일수신을 받습니다.
                                    <input name="emailYN" type="radio" class="input" value="0" <%=ChangeChecked(0,emailYN)%> style='border:0px;'>
                                    메일수신을 받지않습니다.
                                </td>
                            </tr>
                        </table>
                        </form>
                    </td>
                </tr>
                <tr>
                    <td>
                        <table cellpadding='0' cellspacing='0' width='100%' class='menu'>
                            <tr>
                                <td align='right'>
                                    <a href='javascript:sendit();'><img src='/admin/image/icon/bwrite.gif' border='0'></a>
                                    <a href='memberlist.asp?Page=<%= Page %>&seroutmember=<%= seroutmember %>&serMemsort=<%= serMemsort %>&serOrderbyStr=<%= serOrderbyStr %>&serOrderbyDec=<%= serOrderbyDec %>&searchitem=<%= searchitem %>&searchstr=<%= searchstr %>'><img src='/admin/image/icon/bt_list.gif' border='0'></a>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
</table>

<!--#include virtual = admin/common/bottom.html-->
<iframe name='iframes' frameborder='0' width='100%' height='0'></iframe>