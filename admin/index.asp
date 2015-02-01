<!-- #include virtual = common/ADdbcon.asp-->
<%
Dim ObjRs
Dim totalorder,todayorderlist,OrderRows,todayordercnt

Set ObjRs=Nothing
'*------------------------------------게시판 현황 Function -----------------------------------------------*
Function crmBoard(sort,types)
    Dim Sql,Rs,strWhere

    IF types="b" Then
        Sql = "select count(*), isnull(sum(scnt),0) from (select case when regdate>='"&Date()&"' then 1 else 0 end as scnt "
        Sql = Sql & "from bbslist Where boardidx="&Sort&") as t "
    ElseIF types="c" Then
        Sql = "select count(*), isnull(sum(scnt),0) from (select case when regdate>='"&Date()&"' then 1 else 0 end as scnt "
        Sql = Sql & "from consult) as t "
    ElseIF types="c1" Then
        Sql = "select count(*), isnull(sum(scnt),0) from (select case when regdate>='"&Date()&"' then 1 else 0 end as scnt "
        Sql = Sql & "from consult1) as t "
    ElseIF types="c2" Then
        Sql = "select count(*), isnull(sum(scnt),0) from (select case when regdate>='"&Date()&"' then 1 else 0 end as scnt "
        Sql = Sql & "from consult2) as t "
    ElseIF types="f" Then
        Sql = "select count(*), isnull(sum(scnt),0) from (select case when regdate>='"&Date()&"' then 1 else 0 end as scnt "
        Sql = Sql & "from faq) as t "
    ElseIF types="f1" Then
        Sql = "select count(*), isnull(sum(scnt),0) from (select case when regdate>='"&Date()&"' then 1 else 0 end as scnt "
        Sql = Sql & "from faq1) as t "
    ElseIF types="f2" Then
        Sql = "select count(*), isnull(sum(scnt),0) from (select case when regdate>='"&Date()&"' then 1 else 0 end as scnt "
        Sql = Sql & "from faq2) as t "
    ElseIF types="r" Then
        Sql = "select count(*), isnull(sum(scnt),0) from (select case when regdate>='"&Date()&"' then 1 else 0 end as scnt "
        Sql = Sql & "from Memo) as t "
    End IF
    Rs=DBcon.Execute(Sql)
    Response.Write "전체 등록수 : <font color='#525252'><b>"&Rs(0)&"</b></font> 건<br>"&Vbcrlf
    Response.Write "오늘 등록수 : <font color='#84C6E6'><b>"&Rs(1)&"</b></font> 건"&Vbcrlf
    Set Rs=Nothing
End Function
'*---------------------------------------------------------------------------------------------------------*

'*------------------------------------ 카운터관련 코드 ----------------------------------------------------*
Set Rs=Server.CreateObject("ADODB.RecordSet")
Sql="Select register From counter Where register > '"&DateAdd("d",-1,Date)&"'"
Rs.Open Sql,DBcon,1

IF Not(Rs.Bof Or Rs.Eof) Then Allrec=Rs.GetRows()
Rs.CLose

Dim yVisitCount,tVisitCount,totalVisitCount
yVisitCount=0 : tVisitCount=0
IF IsArray(Allrec) THen
    For i=0 To Ubound(Allrec,2)
        IF CDate(Allrec(0,i)) < Date() Then
            yVisitCount=yVisitCount+1
        Else
            tVisitCount=tVisitCount+1
        End IF
    Next
End IF

Sql="Select count(*) From counter"
Rs.Open Sql,DBcon,1
totalVisitCount=Rs(0)
'*---------------------------------------------------------------------------------------------------------*
'*------------------------------------ 회원 통계 관련 코드 ------------------------------------------------*
Set Rs=Server.CreateObject("ADODB.RecordSet")
Sql="Select Regdate From Members Where Regdate > '"&DateAdd("d",-1,Date)&"'"
Rs.Open Sql,DBcon,1

IF Not(Rs.Bof Or Rs.Eof) Then MemberRec=Rs.GetRows()
Rs.CLose

Dim yMemberCount,tMemberCount,totalMemberCount
yMemberCount=0 : tMemberCount=0
IF IsArray(MemberRec) THen
    For i=0 To Ubound(MemberRec,2)
        IF CDate(MemberRec(0,i)) > Date() Then
            tMemberCount=tMemberCount+1
            
        Else
            yMemberCount=yMemberCount+1
        End IF
    Next
End IF

Sql="Select count(*) From Members"
Rs.Open Sql,DBcon,1
totalMemberCount=Rs(0)
'*---------------------------------------------------------------------------------------------------------*

Set Rs=NOthing
%>

<!--#include virtual = admin/common/adminHeader.asp-->
<!--#include virtual = admin/common/topimg.htm-->

<table border="0" cellpadding="0" cellspacing="0" align="center" width='100%' style='table-layout:fixed;'>
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
                        <table cellpadding="0" cellspacing="0" width="100%" class='menu'>
                            <tr>
                                <td style='color: #39518C; font-family:굴림' width='50%'><img src='/admin/image/titleArrow1.gif'><b>접속현황</td>
                                <td width='1%'></td>
                                <td style='color: #39518C; font-family:굴림' width='50%'><img src='/admin/image/titleArrow1.gif'><b>회원가입현황</td>
                            </tr>
                            <tr>
                                <td style='padding-top:5px;'>
<table width="100%" border="1" cellpadding="0" cellspacing="0" bordercolor='#BDBEBD' class="menu" style='border-collapse: collapse'>
    <tr height="25" align="center" bgcolor="#F6F6F6">
        <td width="33%">오늘방문자수</td>
        <td width="33%">어제방문자수</td>
        <td width="33%">전체방문자수</td>
    </tr>
    <tr height="25" align="center">
        <td width="33%"><%=tVisitCount%>명</td>
        <td width="33%"><%=yVisitCount%>명</td>
        <td width="33%"><%=totalVisitCount%>명</td>
    </tr>
</table>
                                </td>
                                <td width='10'></td>
                                <td style='padding-top:5px;'>
<table width="100%" border="1" cellpadding="0" cellspacing="0" bordercolor='#BDBEBD' class="menu" style='border-collapse: collapse'>
    <tr height="25" align="center" bgcolor="#F6F6F6">
        <td width="33%">오늘회원가입수</td>
        <td width="33%">어제회원가입수</td>
        <td width="33%">전체회원가입수</td>
    </tr>
    <tr height="25" align="center">
        <td width="33%"><%=tMemberCount%>명</td>
        <td width="33%"><%=yMemberCount%>명</td>
        <td width="33%"><%=totalMemberCount%>명</td>
    </tr>
</table>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>

                <tr>
                    <td style="padding-top:10">
                        <table cellpadding="0" cellspacing="0" width='100%' class='menu'>
                            <tr>
                                <td style='color: #39518C;'><img src='/admin/image/titleArrow1.gif'><b>게시물 현황</td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td>
                        <table width='100%' border="1" cellpadding="0" cellspacing="0" bordercolor='#BDBEBD' class="menu" style='border-collapse: collapse;'>
                            <tr height="25" align="center" bgcolor="#F6F6F6">
                                <td width='50%'><a href='/admin/board/bbslist.asp?bbscode=1'>NOTICE</a></td>
                                <td width='50%'><a href='/admin/board/bbslist.asp?bbscode=2'>QnA</a></td>
                            </tr>
                            <tr height='60' align='center'>
                                <td><% crmBoard 1,"b" %></td>
                                <td><% crmBoard 2,"b" %></td>
                            </tr>
                        </table>
                    </td>
                </tr>

                <!-- <tr>
                    <td style="padding-top:10">
                        <table cellpadding="0" cellspacing="0" width='100%' class='menu'>
                            <tr>
                                <td style='color: #39518C;'><img src='/admin/image/titleArrow1.gif'><b>ACTIVITIES 현황</td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td>
                        <table width='100%' border="1" cellpadding="0" cellspacing="0" bordercolor='#BDBEBD' class="menu" style='border-collapse: collapse;'>
                            <tr height="25" align="center" bgcolor="#F6F6F6">
                                <td width='25%'><a href='/admin/board/bbslist.asp?bbscode=3'>Scholarship</a></td>
                                <td width='25%'><a href='/admin/board/bbslist.asp?bbscode=4'>Service</a></td>
                                <td width='25%'><a href='/admin/board/bbslist.asp?bbscode=5'>Exchange</a></td>
                                <td width='25%'><a href='/admin/board/bbslist.asp?bbscode=6'>Leadership</a></td>
                            </tr>
                            <tr height='60' align='center'>
                                <td><% crmBoard 3,"b" %></td>
                                <td><% crmBoard 4,"b" %></td>
                                <td><% crmBoard 5,"b" %></td>
                                <td><% crmBoard 6,"b" %></td>
                            </tr>
                        </table>
                    </td>
                </tr> -->
            </table>
        </td>
    </tr>
</table>

<!--#include virtual = admin/common/bottom.html-->
<%
DBcon.Close
Set DBcon=Nothing
%>
