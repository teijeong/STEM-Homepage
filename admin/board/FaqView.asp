<!--#include virtual = common/ADdbcon.asp-->
<%
Dim Sql,Rs,Idx,Page,Regdate,TitleImg
Dim title,writer,content,Boardsort

Page=Request("page")
Idx=Request("idx")

Sql="Select title,regdate,content,boardsort FROM Faq Where idx="&Idx
Set Rs=DBcon.Execute(Sql)

IF Not(Rs.Bof Or Rs.Eof) Then
    title=Rs("title")
    regdate=Rs("regdate")
    content=Rs("content")
    Boardsort=Rs("boardsort")
End IF

Rs.Close
Set Rs=Nothing
DBcon.Close
Set DBcon=Nothing
%>

<!--#include virtual = admin/common/adminHeader.asp-->
<SCRIPT LANGUAGE="JavaScript">
<!--
function boardDel(idx){
    var value=confirm("선택하신 게시물을 삭제하시겠습니까?");
    if(value){
        location.href='FaqDel.asp?page=<%=Page%>&idx='+idx;
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
            <table cellpadding="2" cellspacing="0" width="880">
                <tr>
                    <td>
                        <table cellpadding="0" cellspacing="0" class="menu" width="100%">
                            <tr>
                                <td style='color:#39518C;;'><img src='/admin/image/titleArrow1.gif'><b>자주하는질문(FAQ)</td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td>
                        <table width="100%" border="1" cellpadding="3" cellspacing="0" bordercolor='#BDBEBD' class="menu" style='border-collapse: collapse; word-break:break-all'>
                        <form name="boardform" action="" method="post">
                            <col width='100'></col>
                            <col></col>
                            <tr bgcolor="#F6F6F6">
                                <td align='right' colspan='2'>
                                    작성일 : <%=Regdate%>
                                </td>
                            </tr>
                            <tr>
                                <td width='100' bgcolor="#F6F6F6">&nbsp;글제목</td>
                                <td><%=Title%></td>
                            </tr>
                            <tr height='300'>
                                <td bgcolor="#F6F6F6">&nbsp;내용</td>
                                <td valign='top'><div id='HKeditorContent' name='HKeditorContent'><%=Content%></div></td>
                            </tr>
                        </form>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td align='right'>
                        <a href='Faqwrite.asp?page=<%=Page%>&idx=<%=Idx%>'><img src='/admin/image/icon/board_edit.gif' border='0'></a>
                        <a href="javascript:boardDel(<%=Idx%>);"><img src='/admin/image/icon/board_del.gif' border='0'></a>
                        <a href='Faqlist.asp?page=<%=Page%>'><img src='/admin/image/icon/bt_list.gif' border='0'></a>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
</table>

<!--#include virtual = admin/common/bottom.html-->
</body>
</html>