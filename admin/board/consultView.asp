<!--#include virtual = common/ADdbcon.asp-->
<%
Page=Request("page")
Search=Request("Search")
SearchStr=Request("SearchStr")

Idx=Request("idx")

Sql="Select Writer,email,tel,title,Content,submit,regdate,wip,filenames,icode,note1,note2,note3,note4,note5,note6,note7,note8,note9 FROM consult Where idx="&Idx
Set Rs=DBcon.Execute(Sql)

IF Rs.Bof Or Rs.Eof Then
    Response.Write ExecJavaAlert("잘못된 접근입니다.\n이전페이지로 이동합니다.",0)
    Response.End
Else

    Writer=Rs("Writer")
    email=Rs("email")
    tel=Rs("tel")
    title=Rs("title")
    Content=Rs("Content")

    submit=Rs("submit") : regdate=Rs("regdate") : wip=Rs("wip")
    filenames=Rs("filenames")

    icode=Rs("icode")
    note1=Rs("note1")
    note2=Rs("note2")
    note3=Rs("note3")
    note4=Rs("note4")
    note5=Rs("note5")
    note6=Rs("note6")
    note7=Rs("note7")
    note8=Rs("note8")
    note9=Rs("note9")
End IF

FilDownTag=DownloadTag(filenames,"board")

IF submit="0" Or Submit=False Then
    Sql="UPDATE consult SET Submit=1 Where idx="&Idx
    DBcon.Execute Sql
End IF

Rs.Close
Set Rs=Nothing
DBcon.Close
Set DBcon=Nothing
%>

<!--#include virtual = admin/common/adminHeader.asp-->
<script type="text/javascript" src="/library/adminboardControl.js"></script>
<SCRIPT LANGUAGE="JavaScript">
<!--
function boardDel(idx){
    var value=confirm("해당 게시물을 삭제하시겠습니까?");
    if(value){
        location.href='consultDel.asp?page=<%=Page%>&search=<%=Search%>&searchstr=<%=SearchStr%>&idx='+idx;
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
                                <td style='color:#39518C;;'><img src='/admin/image/titleArrow1.gif'><b>예약문의</td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td>
                        <form name="boardform" action="" method="post">
                        <table width="100%" border="1" cellpadding="3" cellspacing="0" bordercolor='#BDBEBD' class="menu" style='border-collapse: collapse; word-break:break-all; table-layout:fixed;'>
                        <colgroup>
                            <col width='15%'></col>
                            <col width='35%'></col>
                            <col width='15%'></col>
                            <col width=''></col>
                        </colgroup>
                            <tr bgcolor="#F6F6F6">
                                <td align='right' colspan='4'>
                                    작성일 : <%=Regdate%> <b>(작성IP : <%=WIP%>)</b>
                                </td>
                            </tr>
                            <tr>
                                <td width='15%' bgcolor="#F6F6F6" align='center'>이름</td>
                                <td width='35%'><%=Writer%></td>
                                <td width='15%' bgcolor="#F6F6F6" align='center'>주민등록번호</td>
                                <td width=''><%=icode%></td>
                            </tr>
                            <tr>
                                <td width='15%' bgcolor="#F6F6F6" align='center'>연락처</td>
                                <td width=''><%=tel%></td>
                                <td width='15%' bgcolor="#F6F6F6" align='center'>E-mail</td>
                                <td width=''><%=email%></td>
                            </tr>

                            <tr>
                                <td width='15%' bgcolor="#F6F6F6" align='center'>진행과정</td>
                                <td width='' colspan='3'><%=note1%></td>
                            </tr>
                            <tr>
                                <td width='15%' bgcolor="#F6F6F6" align='center'>운전면허번호</td>
                                <td width=''><%=note2%></td>
                                <td width='15%' bgcolor="#F6F6F6" align='center'>면허종류</td>
                                <td width=''><%=note3%></td>
                            </tr>
                            <tr>
                                <td width='15%' bgcolor="#F6F6F6" align='center'>현주소</td>
                                <td width='' colspan='3'><%=note4%></td>
                            </tr>
                            <tr>
                                <td width='15%' bgcolor="#F6F6F6" align='center'>출발일시</td>
                                <td width=''><%=note5%></td>
                                <td width='15%' bgcolor="#F6F6F6" align='center'>반납일시</td>
                                <td width=''><%=note6%></td>
                            </tr>
                            <tr>
                                <td width='15%' bgcolor="#F6F6F6" align='center'>변속기 종류</td>
                                <td width=''><%=note7%></td>
                                <td width='15%' bgcolor="#F6F6F6" align='center'>차종선택</td>
                                <td width=''><%=note8%></td>
                            </tr>
                            <tr>
                                <td width='15%' bgcolor="#F6F6F6" align='center'>기사포함 유/무</td>
                                <td width='' colspan='3'><%=note9%></td>
                            </tr>

                            <tr height='100'>
                                <td bgcolor="#F6F6F6" align='center'>내용</td>
                                <td valign='top' colspan='3'>
                                    <%=ReplaceBr(Content)%>
                                </td>
                            </tr>
                            <% IF FileNames<>"" Then %>
                            <tr>
                                <td bgcolor="#F6F6F6" align='center'>첨부파일</td>
                                <td width='' colspan='3'><%=FilDownTag%></td>
                            </tr>
                            <% End IF %>
                        </table>
                        </form>
                    </td>
                </tr>
                <tr>
                    <td align='right'>
                        <a href="javascript:boardDel(<%=Idx%>);"><img src='/admin/image/icon/board_del.gif' border='0'></a>
                        <a href='consult.asp?page=<%=Page%>&search=<%=Search%>&searchstr=<%=SearchStr%>'><img src='/admin/image/icon/bt_list.gif' border='0'></a>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
</table>

<!--#include virtual = admin/common/bottom.html-->