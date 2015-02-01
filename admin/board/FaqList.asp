<!--#include virtual = common/ADdbcon.asp-->
<%
Dim Rs,Sql,Allrec,TitleImg
Dim Record_Cnt,TotalPage,PageSize,Page,Count

Page=GetPage()
PageSize=10

Sql="select top "&PageSize&" idx,title,regdate,boardsort from Faq WHERE idx NOT IN (select top "&(Page-1)*PageSize&" idx from Faq order by Idx DESC) order by Idx DESC"

Set Rs=Server.CreateObject("ADODB.RecordSet")
Rs.Open Sql,DBcon,1

IF Not(Rs.Bof Or Rs.Eof) Then
    Record_Cnt=Dbcon.Execute("select count(idx) from Faq")
    TotalPage=Int((CInt(Record_Cnt(0))-1)/CInt(PageSize)) +1
    Allrec=Rs.GetRows
    Count=Record_Cnt(0)
End If

Rs.Close
Set Rs=Nothing
DBcon.Close
Set DBcon=Nothing

Function PT_BBsList
    Dim i,Num,LevelView,Depth,j,TitleView,TopTag,TrBg,PublicIcon
    Num=1

    IF IsArray(Allrec) Then
        Num=GetTextNumDesc(Page,Pagesize,Count)
        For i=0 To Ubound(Allrec,2)

            Response.Write "<tr height='25' align='center' "&TrBg&">"&Vbcrlf
            Response.Write "<td>"&Num&"</td>"&Vbcrlf
            Response.Write "<td align='left' style='padding:2px;'><a href='faqView.asp?idx="&Allrec(0,i)&"'>"&Allrec(1,i)&"</a></td>"&Vbcrlf '<b>["&ChangeFaqSort(Allrec(3,i))&"]</b>
            Response.Write "<td>"&Left(Allrec(2,i),10)&"</td>"&Vbcrlf
            Response.Write "<td><a href=javascript:boardDel("&Allrec(0,i)&");><img src='/admin/image/icon/bt_del1.gif' border='0'></a></td>"&Vbcrlf
            Response.Write "</tr>"&Vbcrlf
            Num=Num-1
        Next
    Else
        Response.Write "<tr><td colspan='100' align='center' height='100'>등록된 글이 없습니다.</td></tr>"&Vbcrlf
    End IF
End Function
%>

<!--#include virtual = admin/common/adminHeader.asp-->
<SCRIPT LANGUAGE="JavaScript">
<!--
function boardDel(idx){
    var value=confirm("선택하신 게시물을 삭제하시겠습니까?");
    if(value){
        location.href='faqDel.asp?page=<%=Page%>&idx='+idx;
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
                                <td align='right'>
                                    <a href='faqwrite.asp'><img src='/admin/image/icon/bt_write.gif' border='0'></a>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td>
                        <form name="boardform" method="post">
                        <table width="100%" border="1" cellpadding="0" cellspacing="0" bordercolor='#BDBEBD' class="menu" style='border-collapse: collapse; word-wrap:break-word; word-break:break-all;'>
                            <tr height="25" align="center" bgcolor="#F6F6F6">
                                <td width="50">순번</td>
                                <td>제목</td>
                                <td width="100">등록일</td>
                                <td width="50">관리</td>
                            </tr>
                            <%PT_BBsList%>
                        </table>
                        </form>
                    </td>
                </tr>
                <tr><td align='right'><%=PT_PageLink("FaqList.asp","")%></td></tr>
            </table>
        </td>
    </tr>
</table>

<!--#include virtual = admin/common/bottom.html-->
</body>
</html>