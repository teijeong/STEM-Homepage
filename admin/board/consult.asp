<!--#include virtual = common/ADdbcon.asp-->
<%
Search=Replaceensine(ReplaceNoHtml(Request("Search")))
SearchStr=Replaceensine(ReplaceNoHtml(Request("SearchStr")))

IF Search<>"" Then StrWhere = StrWhere & " And "&Search&" LIKE N'%"&SearchStr&"%' "
Page=GetPage()
PageSize=10

Set Rs=Server.CreateObject("ADODB.RecordSet")
Sql="select top "&PageSize&" idx,writer,note1,title,submit,regdate from consult WHERE 1=1 "&StrWhere&" AND idx NOT IN (select top "&(Page-1)*PageSize&" idx from consult Where 1=1 "&StrWhere&" order by Idx DESC) order by Idx DESC"
Rs.Open Sql,DBcon,1

IF Not(Rs.Bof Or Rs.Eof) Then
    Record_Cnt=Dbcon.Execute("select count(idx) from consult Where 1=1 "&StrWhere)
    TotalPage=Int((CInt(Record_Cnt(0))-1)/CInt(PageSize)) +1
    Allrec=Rs.GetRows
    Count=Record_Cnt(0)
End If

Rs.Close
Set Rs=Nothing
DBcon.Close
Set DBcon=Nothing

Function PT_BBsList
    Dim i,Num
    Num=1

    IF IsArray(Allrec) Then
        Num=GetTextNumDesc(Page,Pagesize,Count)
        For i=0 To Ubound(Allrec,2)
            Response.Write "<tr align='center' "&TrBg&">"&Vbcrlf
            Response.Write "<td>"&Num&"</td>"&Vbcrlf
            Response.Write "<td align='left' style='padding:4px 5px;'><a href='consultView.asp?idx="&Allrec(0,i)&"&page="&Page&"&search="&Search&"&SearchStr="&SearchStr&"'>"&Allrec(3,i)&"</a></td>"&Vbcrlf
            Response.Write "<td>"&Left(Allrec(5,i),10)&"</td>"&Vbcrlf
            Response.Write "<td>"&ChangeSubmitYN(Allrec(4,i))&"</td>"&Vbcrlf
            Response.Write "<td><a href=javascript:boardDel("&Allrec(0,i)&");><img src='/admin/image/icon/bt_del1.gif' border='0'></a></td>"&Vbcrlf
            Response.Write "</tr>"&Vbcrlf
            Num=Num-1
        Next
    Else
        Response.Write "<tr><td colspan='6' align='center' height='100'>등록된 게시물이 없습니다.</td></tr>"&Vbcrlf
    End IF
End Function
%>

<!--#include virtual = admin/common/adminHeader.asp-->
<SCRIPT LANGUAGE="JavaScript">
<!--
function boardDel(idx){
    var value=confirm("해당 게시물을 삭제하시겠습니까?");
    if(value){
        location.href='consultDel.asp?page=<%=Page%>&search=<%=Search%>&searchstr=<%=SearchStr%>&idx='+idx;
    }
}
function searchGo(){
    var f=document.search;
    if(f.searchstr.value==""){
        alert("검색어를 입력하세요.");
        f.searchstr.focus();
        return;
    }
    f.submit();
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
                                <td style='color:#39518C;;'><img src='/admin/image/titleArrow1.gif'><b>예약문의</td>
                                <td align='right'>

<table border="0" cellpadding="0" cellspacing="3">
<form name='searchfrm' method='get' action='' onsubmit="searchGo();event.returnValue= false;">
    <tr>
      <td>
        <select align="absMiddle" name="search">
            <option value="writer">작성자</option>
        </select>
      </td>
      <td><input class="input" align="absmiddle" name="searchstr"></td>
      <td><input type='button' value='검색' class='btn' onclick='searchGo();' style='width:80px;'></td>
    </tr>
</form>
</table>
                                    
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td>
                        <table width="100%" border="1" cellpadding="0" cellspacing="0" bordercolor='#BDBEBD' class="menu" style='border-collapse: collapse'>
                        <form name="boardform" method="post">
                            <tr height="25" align="center" bgcolor="#F6F6F6">
                                <td width="80">순번</td>
                                <td width=''>제목</td>
                                <td width="80">등록일</td>
                                <td width="40">확인</td>
                                <td width="50">관리</td>
                            </tr>
                            <%PT_BBsList%>
                        </form>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td>
                        <table cellpadding='0' cellspacing='0' width='100%'>
                            <tr>
                                <td align='center' width='90%'><%=PT_PageLink("consult.asp","search="&Search&"&searchstr="&SearchStr)%></td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
</table>

<!--#include virtual = admin/common/bottom.html-->