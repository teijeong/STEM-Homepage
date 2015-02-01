<%@codepage="65001" language="VBScript"%>
<%
Session.CodePage = 65001
Response.CharSet = "utf-8"
%>
<!--#include virtual = Library/functions.asp-->
<%
Dim Sql,Dong,Rs,Allrec,Frm,Zip,Addr1,Addr2
Dong=Replaceensine(Request("dong"))
Frm=Request("frm")
Zip=Request("fzip")
Addr1=Request("faddr1")
Addr2=Request("faddr2")
callyn=Request("callyn")

DbServer    = "zipcode.forbiznet.kr"
DbName        = "zipcode"
DbUser        = "zipcode"
DbPwd        = "zipcode##098"

If Len(DONG) > 0 Then
    Set Comm = Server.CreateObject("ADODB.Command")
    StrConnectionString    =    "provider=SQLOLEDB;data source="&DbServer&";database="&DbName&";uid="&DbUser&";pwd="&DbPwd

    Comm.ActiveConnection =    StrConnectionString
    Comm.CommandText = "SELECT ZIPCODE, SIDO, SIGUNGU, DONG, BUNJI, BUILDING FROM ZIPCODE WHERE SIGUNGU +' '+ DONG like ? ORDER BY SIDO, SIGUNGU, DONG, BUNJI"
    Comm.CommandType = adCmdText
    Comm.Parameters.Append Comm.CreateParameter("@dong", adVarWChar, adParamInput, 100, "%" & DONG & "%")

    Set Rs = Server.CreateObject("ADODB.RecordSet")
    Rs.Open Comm

    If not(Rs.EOF or Rs.BOF) Then 
        Allrec = Rs.GetRows
    Else
        Allrec="검색결과가 없습니다. 다시 검색해주세요."
    End IF

    Rs.Close
    Set Rs = nothing
End if

Function PT_Zipcode()
    Dim i,Zip1,Zip2
    IF IsArray(Allrec) Then
        Zip1=Left(Allrec(0,i),3)
        Zip2=Right(Allrec(0,i),3)

        Response.Write "<tr><td>"&Vbcrlf
        Response.Write "<select name='zipcode' class='input' size='1' style='width:100%; font-size:11px;'>"&Vbcrlf
        For i=0 To Ubound(Allrec,2)
            BUNJI = Allrec(4,i)
            IF Len(BUNJI) > 0 Then BUNJI = " " & BUNJI & "번지"
            
            Response.write "<option value='"&Rtrim(Ltrim(left(Allrec(0,i),3) & "-" & right(Allrec(0,i),3)&"/"& Allrec(1,i) & " " & Allrec(2,i) & " " & Allrec(3,i) & " " & Allrec(5,i)))&"'>"&left(Allrec(0,i),3) & "-" & right(Allrec(0,i),3) & " " & Allrec(1,i) & " " & Allrec(2,i) & " " & Allrec(3,i) & BUNJI & " " & Allrec(5,i)&"</option>"&Vbcrlf
        Next
        Response.Write "</select>"&Vbcrlf
        Response.Write "</td></tr>"&Vbcrlf
        Response.Write "<tr><td height='1'></td></tr>"&Vbcrlf
        Response.Write "<tr><td>맞는 주소를 선택하신 후 하단 <b>확인버튼</b>을 클릭 해주세요.</td></tr>"&Vbcrlf
        Response.Write "<tr><td align='center' style='padding-top:5px;'><input type='button' value='확인' style='border:1px solid #6A6A6A; font-size:12px; width:100px; height:20px; cursor:pointer;' onclick='zip("""&Frm&""","""&Zip&""","""&Addr1&""","""&Addr2&""")'></td></tr>"&Vbcrlf
    Else
        Response.Write "<tr><td align='center' height='150'><b>"&Allrec&"</b></td></tr>"
    End IF
End Function

%>
<HTML>
<HEAD>
<meta http-equiv=Content-Type content="text/html; charset=utf-8">
<link href="../css/shopstyle.css" rel="stylesheet" type="text/css">
<TITLE> 우편번호 찾기 </TITLE>
<SCRIPT LANGUAGE="JavaScript">
<!--
function checkZip(){
    if(document.SearchZip.dong.value==false){
        alert("검색하실 동/면/읍 이름을 입력하세요.");
        return;
    }
    document.SearchZip.submit();
}

function zip(frm,fzip,faddr1,faddr2){
    var addr=document.SearchZip.zipcode.value.split("/");
    var zip=addr[0].split("-")

    eval("parent.window.opener.document."+frm+"."+fzip+"[0]").value=zip[0];
    eval("parent.window.opener.document."+frm+"."+fzip+"[1]").value=zip[1];
    eval("parent.window.opener.document."+frm+"."+faddr1).value=addr[1];
    window.close();
    eval("parent.window.opener.document."+frm+"."+faddr2).focus();

    if("<%=callyn%>"=="addtrans"){
        parent.window.opener.exPriceYNChk();
    }
}

//-->
</SCRIPT>
</HEAD>

<body topmargin='0' leftmargin='0'>
<table cellpadding='0' cellspacing='0' border='0' width="100%" class="graytext" height="310">
    <tr height="3"><td background="../common/memberimg/redlinebg.gif"></td></tr>
    <tr height="40" bgcolor="#F0F0F0"><td><img src='../common/memberimg/zipsearchtitle.gif'></td></tr>
    <tr><td bgcolor="#E0E0E0" height='1'></td></tr>
    <tr>
        <td valign='top' style="padding-top:10">
            <form name="SearchZip" method="post" action="zipsearch.asp" onsubmit='checkZip();event.returnValue= false;'>
            <input type='hidden' name='fzip' value='<%=zip%>'>
            <input type='hidden' name='faddr1' value='<%=addr1%>'>
            <input type='hidden' name='faddr2' value='<%=addr2%>'>
            <input type='hidden' name='frm' value='<%=frm%>'>
            <input type='hidden' name='callyn' value='<%=callyn%>'>
            <table cellpadding="3" cellspacing="0" class="graytext" align='center'>
                <tr><td>검색하시고자 하는 동/면/읍 을 입력하세요.(예 : 개포동,일산동...)</td></tr>
                <tr>
                    <td>
                        <input type="text" name='dong' class='input' size='30' maxlength='15'>
                        <a href="javascript:checkZip();"><img src="../common/memberimg/bt_submit1.gif" border='0' align='absmiddle'></a>
                    </td>
                </tr>
                <%=PT_Zipcode%>
            </table>
            </form>
        </td>
    </tr>
    <tr height="3"><td background="../common/memberimg/graylinebg.gif"></td></tr>
</table>
</body>
</HTML>