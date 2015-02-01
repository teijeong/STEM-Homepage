<!--#include virtual = common/ADdbcon.asp-->
<%
Dim Sql,BBSCode
Dim Idx,Ref,ReLevel,Page,Search,SearchStr

Idx=Request("idx")
Ref=Request("Ref")
ReLevel=Request("ReLevel")
Page=Request("Page")
bbscode=Request("bbscode")
sersel1=Request("sersel1")
serboardsort=Request("serboardsort")

Call HK_BBSSetup(Cint(BBsCode))

Sql="SELECT title,content FROM bbslist WHere idx="&IDX
Set Rs=DBcon.Execute(Sql)
IF Rs.Bof Or Rs.Eof Then
    REsponse.Write ExecJavaAlert("원글정보를 찾을수 없습니다.\n다시시도해주세요.",0)
    Response.End
Else
    title=ReplaceTextField(Rs("title"))
    Content=ReplaceNoHtml(Rs("content"))
End IF

DBcon.Close
Set DBcon=Nothing

Writer=Request.Cookies("acountname")
%>

<!--#include virtual = admin/common/adminHeader.asp-->
<SCRIPT language=JavaScript src="/ckeditor/ckeditor.js" type='text/javascript'></SCRIPT>
<SCRIPT LANGUAGE="JavaScript">
<!--
function sendit(){
    var form=document.boardform;
    if(form.writer.value==false){
        alert("작성자를 입력하세요.");
        form.writer.focus();
        return;
    }
    if(form.title.value==false){
        alert("글제목을 입력하세요.");
        form.title.focus();
        return;
    }
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
                        <table cellpadding="0" cellspacing="0" class="menu" width="100%">
                            <tr>
                                <td style='color:#39518C;;'><img src='/admin/image/titleArrow1.gif'><b><%=ChangeAdminBoardTitle(bbscode)%></td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td>
                        <table width="100%" border="1" cellpadding="3" cellspacing="0" bordercolor='#BDBEBD' class="menu" style='border-collapse: collapse; table-layout:fixed;'>
                        <form name="boardform" action="bbsReplyOk.asp" method="post" ENCTYPE="multipart/form-data">
                        <input type='hidden' name='bbsCode' value='<%=bbsCode%>'>
                        <input type='hidden' name='idx' value='<%=Idx%>'>
                        <input type='hidden' name='page' value='<%=Page%>'>
                        <input type="hidden" name='Ref' value='<%=Ref%>'>
                        <input type="hidden" name='ReLevel' value='<%=ReLevel%>'>
                        <input type='hidden' name='sersel1' value='<%=sersel1%>'>
                        <input type='hidden' name='serboardsort' value='<%=serboardsort%>'>
                        <input type='hidden' name='Search' value='<%=Search%>'>
                        <input type='hidden' name='SearchStr' value='<%=SearchStr%>'>
                        <colgroup>
                            <col width='120'></col>
                            <col width='*'></col>
                        </colgroup>
                            <tr bgcolor="#F6F6F6">
                                <td align='right' colspan='2'>게시물&nbsp; 답변&nbsp;&nbsp;</td>
                            </tr>
                            <tr>
                                <td bgcolor="#F6F6F6">&nbsp;작성자</td>
                                <td><input type='text' name='writer' style='width:30%' maxlength='10' class='input' Value='<%=Writer%>'></td>
                            </tr>
                            <tr>
                                <td bgcolor="#F6F6F6">&nbsp;글제목</td>
                                <td><input type='text' name='title' style='width:70%' maxlength='50' class='input' Value='<%=title%>'></td>
                            </tr>
                            <tr>
                                <td bgcolor="#F6F6F6">&nbsp;내용</td>
                                <td>
                                    <textarea name='content' style='width:100%; word-break:break-all;' class='ckeditor'>===Origin Content=====================================<br><%=Content%><br>==============================================<br></textarea>
                                </td>
                            </tr>
                        <% IF HK_PdsYN<>"False" Then %>
                            <tr>
                                <td bgcolor="#F6F6F6">&nbsp;파일첨부</td>
                                <td>
                                    <table cellpadding='0' cellspacing='0' width='100%' id="inRow">
                                        <tr>
                                            <td style='padding:1px 0;'>
                                                <input type='file' name='files' style='width:350px' class='input'>
                                                <input type='hidden' name='filedel_idx' value='0'>
                                                <a href='#jLink' onclick="addRow()"><span style='color: #D90000'>필드추가</span></a>
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                        <% End IF %>
                        </form>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td>
                        <table cellpadding='0' cellspacing='0' width='100%' class='menu'>
                            <tr>
                                <td align='right'>
                                    <a href='javascript:sendit();'><img src='/admin/image/icon/bwrite.gif' border='0'></a>
                                    <a href='javascript:history.back()'><img src='/admin/image/icon/bback.gif' border='0'></a>
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