<%@codepage="65001" language="VBScript"%>
<%
Session.CodePage = 65001
Response.CharSet = "utf-8"

IF Request.cookies("acountcode") = "" Then
    Response.Write "<SCRIPT LANGUAGE='JavaScript'>"&Vbcrlf
    Response.Write "alert('로그인 정보가 불확실합니다.\n로그인페이지로 이동합니다.')"&Vbcrlf
    Response.Write "location.href='/admin/login.htm'"&Vbcrlf
    Response.Write "</SCRIPT>"&Vbcrlf
    Response.End
End IF
%>

<!-- #include virtual="/library/crmFunctions.asp " -->
<%
tp = Request("tp")
fd = Request("fd")
ed = Request("ed")
CurrentPage = Request("CurrentPage")

SetDefault tp, "1"

SetDefault CurrentPage, 1
SetDefault ConfigPageSize, 20
SetDefault ConfigPageBlock, 10
SetDefault URL_SEARCH, "index.asp?x="

FDATE = fd
EDATE = ed
setDefault FDATE, formatdatetime(now, 2)
setDefault EDATE, formatdatetime(now, 2)
%>

<!--#include virtual = admin/common/adminHeader.asp-->
<link href="/css/admincounter.css" rel="stylesheet">
<link href="/admin/common/body.css" rel="stylesheet">
<script>
var SEARCH_TYPE_1 = 1;
var SEARCH_TYPE_2 = 2;
var SEARCH_TYPE_3 = 3;
var SEARCH_TYPE_4 = 4;
var SEARCH_TYPE_5 = 5;
var SEARCH_TYPE_6 = 6;
var SEARCH_TYPE_7 = 7;
var SEARCH_TYPE_8 = 8;
var SEARCH_TYPE_9 = 9;
function fnSearch(){
var obj = document.fo_search;
var tp = arguments[0];

    switch(tp) {
        case SEARCH_TYPE_1: obj.action = 'index.asp'; break;
        case SEARCH_TYPE_2: obj.action = 'count1.asp'; break;
        case SEARCH_TYPE_3: obj.action = 'count2.asp'; break;
        case SEARCH_TYPE_4: obj.action = 'count3.asp'; break;
        case SEARCH_TYPE_5: obj.action = 'count4.asp'; break;
        case SEARCH_TYPE_6: obj.action = 'count5.asp'; break;
        case SEARCH_TYPE_7: obj.action = 'count6.asp'; break;
        case SEARCH_TYPE_8: obj.action = 'count7.asp'; break;
        case SEARCH_TYPE_9: obj.action = 'count8.asp'; break;
    }
    
    obj.tp.value = tp;
    obj.submit();
}
</script>
<style>
input.eSelectButton{
    background-color:threedshadow;
}
</style>


<!--#include virtual = admin/common/topimg.htm-->
<table border="0" cellpadding="0" cellspacing="0" align="center" width='100%'>
    <tr>
        <td valign="top" style='padding-left:10px;'>
            <table cellpadding="2" cellspacing="0" width='1080'>
                <tr>
                    <td>
                        <table cellpadding="0" cellspacing="0" width="100%">
                            <tr><td style='color: #39518C;' class='menu'><img src='/admin/image/titleArrow2.gif'><b>접속현황</td></tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td>






    <!--#include file = "counter_menu.asp" -->
<br>
        <table cellpadding=4 cellspacing=1 border=0 width=100% align=center bgcolor=e6e6e6>
    <colgroup>
    <col width=20% align=center>
    <col width=10% align=center>
    <col width=60% align=left>
    <col width=10% align=center>
    </colgroup>
    <tr bgcolor=E2F1EB>
        <td align=center>시 간</td>
        <td>방문자수</td>
        <td>그래프</td>
        <td>백분율</td>
    </tr>
<%
opendb

tmpDB = "select YY, MM, DD from ViewCounter where Register >= Convert(DateTime, '" & FDATE & " 00:00:00') and Register <= Convert(DateTime, '" & EDATE & " 23:59:59')"

sql = "select count(*) from (" & tmpDB & ") tmpDB"
GetRs Rs, Sql

TotalCnt = Rs(0)

if TotalCnt <= 0 then 
    TotalCnt = 1 
end if

FreeAndNil(Rs)

'For C = 0 to DateDiff("y", FDATE, EDATE)
'    NDATE = DateAdd("d", C, FDATE)
    sql = "select YY, MM, DD, Count(*) AS TotalVisit from (" & tmpDB & ") tmpDB Group By YY, MM, DD"
    GetRs Rs, sql
    Do While Not Rs.eof
        NDATE = rs("YY") & "년 " & rs("MM") & "월 " & rs("DD") & "일"
        TotalVisit = Rs("TotalVisit")
        
        if TotalVisit > 0 then
            if CLng(TotalCnt) = 0 then
                Percent = "0%"
                PercentSize = 0
            else
                Percent = formatpercent(TotalVisit/TotalCnt,0)
                PercentSize = replace(Percent,"%","")*3
            end if
%>
    <tr bgcolor=#ffffff onmouseover="this.style.backgroundColor='#F2F9F7'" onmouseout="this.style.backgroundColor='#FFFFFF'">
        <td><%=NDATE%></td>
        <td><%=TotalVisit%></td>
        <td align=left><div style="width:<%=Percent%>;" class=graphfade>&nbsp;</div><!-- <hr width="<%=PercentSize%>" size="8" class=linefade color="steelblue" noshade> --></td>
        <td><%=Percent%></td>
    </tr>
<%
        end if
        Rs.MoveNext
    Loop
    freeandnil(rs)
'Next
freeandnil(con)
%>
    </table>






                    </td>
                </tr>
            </table>
        </td>
    </tr>
</table>

<!--#include virtual = admin/common/bottom.html-->