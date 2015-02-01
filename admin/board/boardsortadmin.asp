<!--#include virtual = common/ADdbcon.asp-->
<%
Dim Sql,Rs,Allrec,CellRec
Dim Page,PageSize,Record_Cnt,Count,TotalPage
Dim CellPageSize,CellPage,CellRecord_Cnt,CellCount,CellTotalPage,BBscode,strWhere

BBscode=Request("bbscode")
Page=GetPage()
PageSize=10

Set Rs=Server.CreateObject("ADODB.RecordSet")
Sql="Select idx,boardName FROM BoardAdmin Order By idx Asc"
Rs.Open Sql,DBcon,1
IF Not(Rs.Bof Or Rs.Eof) Then Allrec=Rs.GetRows()
Rs.Close

IF BBscode<>"" then strWhere = " Boardidx = "&BBscode&" AND "

'===============================CELL LIST RECORDSET CREATE START
Sql="SELECT top "&PageSize&" idx,boardidx,boardName,sortName FROM boardsort WHERE "&strWhere&" idx not in "
Sql = Sql & "(select top "&(Page-1)*PageSize&" idx from boardsort where "&strWhere&" 1=1 order by idx desc) order by idx desc"
Rs.Open Sql,dbcon,1

IF Not(Rs.Bof Or Rs.Eof) Then
    Record_Cnt=Dbcon.Execute("select count(idx) from boardsort Where "&strWhere&" 1=1")
    Count=Record_Cnt(0)
    TotalPage=Int((CInt(Count)-1)/CInt(PageSize)) +1 
    CellRec=Rs.GetRows
End IF
'===============================CELL LIST RECORDSET CREATE END
Rs.Close


Set Rs=Nothing
DBcon.Close
Set DBcon=Nothing

Function PT_BoardList()
    Dim i
    IF IsArray(Allrec) Then
        For i=0 To Ubound(Allrec,2)
            Response.Write "<option value='"&Allrec(0,i)&"' "&SelCheck(Allrec(0,i),BBscode)&">"&Allrec(1,i)&"</option>"&Vbcrlf
        Next
    End IF
End Function

Function PT_CellList
    Dim i,Num
    Num=GetTextNumDesc(Page,Pagesize,Count)
    IF IsArray(CellRec) Then
        For i=0 To Ubound(CellRec,2)
            Response.WRite "<tr height='25' align='center'>"&Vbcrlf
            Response.WRite "<td>"&Num&"</td>"&Vbcrlf
            Response.WRite "<td>"&CellRec(2,i)&"</td>"&Vbcrlf
            Response.WRite "<td>"&CellRec(3,i)&"</td>"&Vbcrlf
            Response.WRite "<td><img src='../image/icon/bt_edit.gif' board='0' align='absmiddle' onclick='cellEdit("&CellRec(0,i)&")' style='cursor:hand;'>"&Vbcrlf
            Response.Write "<img src='../image/icon/bt_del1.gif' board='0' align='absmiddle' onclick='cellDel("&CellRec(0,i)&");' style='cursor:hand;'></td>"&Vbcrlf
            Response.WRite "</tr>"&Vbcrlf
            Num=Num-1
        Next
    Else
        Response.WRite "<tr><td colspan='4' height='150' align='center'>등록된 분류가 없습니다.</td></tr>"&Vbcrlf
    ENd IF
End Function
%>

<!--#include virtual = admin/common/adminHeader.asp-->
<SCRIPT LANGUAGE="JavaScript">
<!--
function changeBoard(index){
    var val = index.options[index.selectedIndex].value;
    location.href='boardsortadmin.asp?bbscode='+val;
    //var f=document.celladd;
    //if(f.boardidx.selectedIndex!=0){
    //    f.boardname.value=f.boardidx.options[f.boardidx.selectedIndex].text;
    //}
}

function cellEdit(idx){
    var form=document.celladd;
    if(form.cellname.value==false){
        alert("수정할 분류의 새이름을 입력하세요.");
        form.cellname.focus();
        return;
    }
    form.action='celladdOk.asp?sort=edit&idx='+idx;
    form.submit();
}

function cellDel(idx){
    var form=document.celladd;
    var value=confirm("해당분류에 등록된 모든 글도 삭제됩니다.\n해당분류를 삭제하시겠습니까?");
    if(value){
        form.action='cellDel.asp?idx='+idx;
        form.submit();
    }
}

function cellAdd(){
    var form=document.celladd;
    if(form.boardidx.selectedIndex==0){
        alert("게시판을 입력하세요.");
        return;
    }
    if(form.cellname.value==false){
        alert("분류명을 입력하세요.");
        form.cellname.focus();
        return;
    }
    form.boardname.value=form.boardidx.options[form.boardidx.selectedIndex].text;
    form.action='celladdOk.asp'
    form.submit();
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
            <table cellpadding="2" cellspacing="0" width="880">
                <tr>
                    <td>
                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr>
                                <td style='color:#39518C;;' class="menu"><img src='/admin/image/titleArrow1.gif'><b>분류관리</td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td valign='top' width='60%'>
                        <table cellpadding='0' cellspacing='0' width='100%'>
                            <tr>
                                <td>
                                    <table width='100%' cellpadding="0" cellspacing="0" class="menu" style='border-collapse: collapse' border="1" bordercolor='#BDBEBD'>
                                    <form name="cellform" method="post">
                                        <tr height="25" align="center" bgcolor="#EFEFEF">
                                            <td width="40">순번</td>
                                            <td width=''>게시판명</td>
                                            <td width="">분류명</td>
                                            <td width="100">관리</td>
                                        </tr>
                                        <%=PT_CellList%>
                                    </form>
                                    </table>
                                </td>
                            </tr>
                            <tr><td align='right'><%=PT_PageLink("boardsortadmin.asp","bbscode="&bbscode)%></td></tr>
                        </table>
                    </td>
                    <td align='right' valign='top' width='40%'>
<table cellpadding='0' cellspacing='0' width='100%'>
    <tr>
        <td>
            <table width='100%' cellpadding="0" cellspacing="0" class="menu" style='border-collapse: collapse' border="1" bordercolor='#BDBEBD'>
            <form name="celladd" method="post" onsubmit="cellAdd();event.returnValue= false;">
            <input type='hidden' name='bbscode' value='<%=bbscode%>'>
                <tr height="25" align="center" bgcolor="#EFEFEF">
                    <td align='center' colspan='2'>분류 등록</td>
                </tr>
                <tr height='25'>
                    <td align='center' width='100'>게시판명</td>
                    <td>&nbsp;
                        <select name='boardidx' class='input' onchange='changeBoard(this)'>
                            <option value=''>분류선택</option>
                            <%=PT_BoardList%>
                        </select>
                        <input type='hidden' name='boardname' value=''>
                    </td>
                </tr>
                <tr height='25'>
                    <td align='center' width='100'>분류명</td>
                    <td>&nbsp;
                        <input type='text' name='cellname' size='20' maxlength='15' class='input'>
                    </td>
                </tr>
                <tr height='25'>
                    <td align='center' colspan='2' height='40'>
                        <img src='../image/icon/bt_sortadd.gif' align='absmiddle' onclick='cellAdd();' style='cursor:hand;'>
                    </td>
                </tr>
                <tr>
                    <td colspan='2' height='60' class='menu1'>
                    &nbsp;* 분류 등록 : 분류이름 입력후 분류등록하기 버튼클릭<br>
                    &nbsp;* 분류 수정 : 분류이름 입력후 좌측 수정버튼클릭
                    </td>
                </tr>
            </form>
            </table>
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
</body>
</html>