<!--#include virtual = common/ADdbcon.asp-->
<%
Dim Rs,Sql,Allrec

Sql="select e.idx,id,name,e.title,e.regdate,e.useridx from exitmember as e inner Join members as m on e.useridx=m.idx"

Set Rs=Server.CreateObject("ADODB.RecordSet")
Rs.Open Sql,DBcon,1

IF Not(Rs.Bof Or Rs.Eof) Then
    Allrec=Rs.GetRows
End If

Rs.Close
Set Rs=Nothing
DBcon.Close
Set DBcon=Nothing

Function Pt_exitmem
    Dim i,Num
    Num=1
    IF IsArray(Allrec) Then
        For i=0 To Ubound(Allrec,2)
            Response.Write "<tr>"&Vbcrlf
            Response.Write "<td align='center'>"&Num&"</td>"&Vbcrlf
            Response.Write "<td align='center'>"&Allrec(1,i)&"</td>"&Vbcrlf
            Response.Write "<td align='center'>"&Allrec(2,i)&"</td>"&Vbcrlf
            Response.Write "<td style='padding-left:5'>"&Allrec(3,i)&"</td>"&Vbcrlf
            Response.Write "<td align='center'>"&Allrec(4,i)&"</td>"&Vbcrlf
            Response.Write "<td width='100' align='center'>"&Vbcrlf
            Response.Write "<a href='javascript:memDel("&Allrec(5,i)&",5);'><img src='../image/icon/bt_memberdel.gif' border='0' align='absmiddle'></a>"&Vbcrlf
            Response.Write "<a href='javascript:memDel("&Allrec(0,i)&",4);'><img src='../image/icon/bt_del1.gif' border='0' align='absmiddle'></a>"&Vbcrlf
            Response.Write "</td></tr>"&Vbcrlf
            Num=Num+1
        Next
    Else
        Response.Write "<tr><td colspan='7' height='150' align='center' class='graytext'>등록된 탈퇴 신청서가 없습니다.</td></tr>"&Vbcrlf
    End IF
End Function
%>

<!--#include virtual = admin/common/adminHeader.asp-->
<SCRIPT LANGUAGE="JavaScript">
<!--
function memDel(idx,Sort){
    var msg;

    if(Sort==5){msg="선택하신 회원을 탈퇴처리 하시겠습니까?"}
    else{msg="선택하신 탈퇴신청서를 삭제하시겠습니까?"}

    var value=confirm(msg);
    if(value){
        document.exitform.action='memberDel.asp?sort='+Sort+'&idx='+idx;
        document.exitform.submit();
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
                                <td style='color: #39518C;'><img src='/admin/image/titleArrow2.gif'><b>탈퇴신청서</td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td>
<table width='100%' border='1' cellspacing='0' cellpadding='3' bordercolor='#BDBEBD' class='menu' style='border-collapse: collapse' style='word-break:break-all'>
    <form name='exitform' method='post' action=''>
    <tr align='center' bgcolor='#EFEFEF'>
        <td width='30' height='25'>No</td>
        <td width='70' height='25'>아이디</td>
        <td width='60' height='25'>이 름</td>
        <td width='' height='25'>탈퇴사유</td>
        <td width='70' height='25'>작성일</td>
        <td width='100' height='25'>관리</td>
    </tr>
    <%Pt_exitmem%>
    </form>
</table>
                    </td>
                </tr>
                <tr>
                    <td>
<fieldset class='menu'><legend align="left"><b>☞탈퇴신청서메뉴 설명☜</b></legend>
<table class='menu' align='center' width='100%'>
    <tr>
        <td>
            ※ 회원이 탈퇴신청시 해당메뉴에 신청내역이 나타납니다.<br>
            ※ 신청내역에는 간략한 회원정보가 표시되며 탈퇴,삭제버튼을 통해 회원탈퇴 및 신청서 삭제처리를 하실 수 있습니다.<br>
            ※ 탈퇴버튼은 해당 신청서를 작성한 회원을 탈퇴처리합니다.<br>
            &nbsp;&nbsp;&nbsp;&nbsp;탈퇴처리된 회원은 회원리스트에서 붉은색으로 표시되며 로그인이 불가능한 상태로 변경됩니다.<br>
            ※ 삭제버튼클릭시 해당 탈퇴신청서만 삭제됩니다..<br>
        </td>
    </tr>
    <tr><td height='5'></td></tr>
    </table>
</fieldset>


<!--     <font color='red'>※ 주의사항</font><br>
    기존 카테고리 삭제시 카테고리에 등록된 모든 상품은 삭제되지만 해당 상품 이미지는 삭제되지않습니다.<br>
    <font color='#8073F7'>상품리스트에서 상품 삭제후 카테고리삭제를 권장합니다.</font> -->

                    </td>
                </tr>
            </table>
        </td>
    </tr>
</table>

<!--#include virtual = admin/common/bottom.html-->