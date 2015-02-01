<!--#include virtual = common/ADdbcon.asp-->
<%
Dim PageLink,PageStr,PageSize,Page,Cmd,Allrec,Record_Cnt,TotalPage
Dim Rs

PageLink="popup.asp"
PageStr=""
PageSize=20
Page=GetPage()

Set Cmd=CreateCommand(DBcon,"FM_AP_PopupList",adCmdStoredProc)
With Cmd
    .Parameters.Append CreateInputParameter("@Page",adInteger,4,Page)
    .Parameters.Append CreateInputParameter("@PageSize",adInteger,4,PageSize)
    .Parameters.Append CreateOutPutParameter("@Record_Cnt",adInteger,4)
    Set Rs=.Execute
End With

IF Not(Rs.Eof Or Rs.Bof) Then Allrec=Rs.GetRows
Rs.Close
Set Rs=Nothing

Record_Cnt=Cmd.Parameters(2).Value
TotalPage=Int((CInt(Record_Cnt)-1)/CInt(PageSize)) +1

Set Cmd=Nothing
DBcon.Close
Set DBcon=Nothing

Function PT_PopupList
    Dim i,Title,PopStatus,Sort,Num,ToDay

    Num=GetTextNumDesc(Page,PageSize,Record_Cnt)
    ToDay=Year(date)&AddZero(MonTh(date))&AddZero(Day(date))

    IF IsArray(Allrec) Then
        For i=0 To Ubound(Allrec,2)
            IF Allrec(1,i)=1 Then
                Sort="이미지"
            Else
                Sort="HTML"
            End IF
            Title=Allrec(2,i)

            IF ToDay>Allrec(4,i) Then
                PopStatus="종료"
            ElseIF ToDay<Allrec(3,i) Then
                PopStatus="<font color='blue'>팝업대기</font>"
            Else
                PopStatus="<font color='red'>실행중</font>"
            End IF

            Response.Write "<tr><td align='center'>"&Num&"</td>"&Vbcrlf
            Response.Write "<td align='center'>"&Sort&"</td>"&Vbcrlf
            Response.Write "<td align='left' style='padding : 5px 3px;'>"&Title&"</td>"&Vbcrlf
            Response.Write "<td align='center'>"&DateStr(Allrec(3,i))&"</td>"&Vbcrlf
            Response.Write "<td align='center'>"&DateStr(Allrec(4,i))&"</td>"&Vbcrlf
            Response.Write "<td align='center'>"&PopStatus&"</td>"&Vbcrlf
            Response.Write "<td align='center'>"&Vbcrlf
            Response.Write "<a href='javascript:popupEdit("&Allrec(0,i)&")'><img src='../image/icon/bt_edit.gif' alt='수정' align='absmiddle' border='0'></a>"&Vbcrlf
            Response.Write "<a href='javascript:popupDel("&Allrec(0,i)&")'><img src='../image/icon/bt_del1.gif' alt='삭제' align='absmiddle' border='0'></a></td></tr>"&Vbcrlf
            Num=Num-1
        Next
    Else
        Response.Write "<tr><td colspan='7' align='center' height='200'>등록된 팝업이 없습니다.</td></tr>"&Vbcrlf
    End IF
End Function
%>

<!--#include virtual = admin/common/adminHeader.asp-->
<script language="JavaScript">
<!--
// 카테고리 수정
function popupEdit( idx ) {
    location.href='popup_edit.asp?idx='+idx;
}

// 카테고리 삭제
function popupDel( idx ) {
    var choose = confirm( '삭제 하시겠습니까?');
    if(choose) {    location.href='popup_del_ok.asp?idx='+idx; }
    else { return; }
}
//-->
</script>

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
                    <table width='100%' border="0" cellspacing="0" cellpadding="0">
                        <tr>
                            <td style='color:#39518C;' class='menu'><img src='/admin/image/titleArrow2.gif'><b>팝업관리</td>
                        </tr>
                    </table>
                    </td>
                </tr>
                <tr>
                    <td>

                        <table width='100%' border="0" cellspacing="0" cellpadding="0">
                            <tr>
                                <td height="35" align="right"><a href="popup_add.asp"><img src="/admin/image/icon/bt_popup_add.gif" width="81" height="25" border="0"></a></td>
                            </tr>
                        </table>
                        <table width='100%' border="1" cellspacing="0" cellpadding="3" class="menu" bordercolor='#BDBEBD' style='border-collapse: collapse; table-layout:fixed;'>
                            <tr bgcolor="#F5F5F5">
                                <td width="50" align="center">No</td>
                                <td width="80" align="center">출력 형태</td>
                                <td height="30" align="center">브라우져 타이틀바</td>
                                <td width="80" align="center">시작일</td>
                                <td width="80" align="center">종료일</td>
                                <td width="70" align="center">팝업상태</td>
                                <td width="100" align="center">관리</td>
                            </tr>
                            <%PT_PopupList%>
                        </table>

                        <center style='padding-top:10px; text-align:center;'><%=PT_PageLink(PageLink,PageStr)%></center>

                    </td>
                </tr>
            </table>
        </td>
    </tr>
</table>

<!--#include virtual = admin/common/bottom.html-->
</body>
</html>