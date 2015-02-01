<SCRIPT language=JavaScript src="/ckeditor/ckeditor.js" type='text/javascript'></SCRIPT>

<form name='boardfrm' id='boardfrm' action='/board/ok_bbswrite.asp' method='post' ENCTYPE="multipart/form-data" style='margin:0;'>
<input type="hidden" name='storeidx' id='storeidx' value='<%=storeidx%>'>
<input type="hidden" name='bbscode' id='bbscode' value='<%=BBsCode%>'>
<input type="hidden" name='serboardsort' id='serboardsort' value='<%=serboardsort%>'>
<input type="hidden" name='prePage' id='prePage' value='<%=prePage%>'>
<input type="hidden" name='useridx' id='useridx' value='<%=Session("useridx")%>'>
<table cellspacing="0" border="0" summary="글 내용을 작성" class="tbl_write" style='table-layout:fixed;'>
<colgroup>
<col width="100">
<col>
<col width="100">
<col>
</colgroup>
<thead>
    <% IF HK_PubYN="True" Then %>
    <tr>
        <th scope="row">잠금설정</th>
        <td colspan="3">
            <input name="publicYN" type="radio" value="0" checked style='border:none;'>
            공개글
            <input name="publicYN" type="radio" value="1" style='border:none;'>
            비공개글
        </td>
    </tr>
    <% End IF %>
    <tr>
        <th scope="row">작성자</th>
        <td <% IF Not(HK_MemYN="" AND Session("useridx")="") Then %>colspan='3'<% End IF %>><input name="writer" type="text" size='35' maxlength='10' class='input' value='<%=Session("username")%>'></td>
        <% IF HK_MemYN="" AND Session("useridx")="" Then %>
        <th scope="row">비밀번호</th>
        <td><input name="pass" type="password" size='35' maxlength='10' class='input'></td>
        <% End IF %>
    </tr>
</thead>
<tbody>
    <% IF BBsSort<>"" Then %>
    <tr>
        <th scope="row">질문유형</th>
        <td colspan="3"><%=BBsSort%></td>
    </tr>
    <% Else %>
        <input type='hidden' name='boardsort' value='<%=BoardSort%>'>
    <% End IF %>
    <tr>
        <th scope="row">Email</th>
        <td colspan="3"><input name="email" type="text" maxlength='45' class='input' style="width:98%;"></td>
    </tr>
    <tr>
        <th scope="row">제목</th>
        <td colspan="3"><input name="title" type="text" maxlength='45' class='input' style="width:98%;"></td>
    </tr>
    <% IF HK_imgYN<>"False" Then %>
    <tr>
        <th scope="row">이미지첨부</th>
        <td colspan="3"><input type='file' name='imgfiles' style="width:70%" class="input"></td>
    </tr>
    <% End IF %>
    <tr>
        <td colspan="4" class="cont" style='padding:10px 0 5px 0;'><div id='textareaDIV'><textarea name="content" id="content" style='width:100%; word-break:break-all;' rows="15" class='ckeditor'></textarea></div></td>
    </tr>
    <% IF HK_PdsYN<>"False" Then %>
    <tr>
    <th scope="row">파일첨부</th>
        <td colspan="3">
            <table cellpadding='0' cellspacing='0' width='100%' id="inRow">
                <tr>
                    <td style='padding:1px 0; border:0px solid #ffffff'>
                        <input type='file' name='files' style='width:350px' class='input'>
                        <input type='hidden' name='filedel_idx' value='0'>
                        <a href='#jLink' onclick="addRow()"><span style='color: #D90000'>필드추가</span></a>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <% End IF %>
</tbody>
</table>

<div style='padding:10px; text-align:center;'>
    <input type='button' value='확인' class='button2' onclick='sendit();' style='cursor:pointer'>
    <input type='button' value='취소' class='button1' onclick='history.back();' style='cursor:pointer'>
</div>
</form>

<SCRIPT LANGUAGE="JavaScript">
CKEDITOR.replace( 'content', { customConfig: 'config_user.js' } );
</SCRIPT>