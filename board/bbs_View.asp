<script language="javascript" id="resultProc"></script>
<table cellspacing="0" border="0" summary="글 내용을 표시" class="tbl_view" style='table-layout:fixed;'>
<colgroup>
<col width="80">
<col>
<col width="80">
<col width="200">
<col width="80">
<col width="100">
</colgroup>
<thead>
	<tr>
		<th scope="row">제목</th>
		<td colspan="5"><%=Title%></td>
	</tr>
	<tr>
		<th scope="row">작성자</th>
		<td><%=Writer%></td>
		<th scope="row">작성일</th>
		<td class="num"><%=Regdate%></td>
		<th scope="row">조회</th>
		<td class="num"><%=ReadNum%></td>
	</tr>
</thead>
<tbody>

	<tr>
		<td colspan="6" style='padding:10px;'>
			<%=PT_FileArea()%>

<% IF VodUrl<>"" Then %>
<div style='text-align:center; padding-bottom:10px;'>
<iframe width="640" height="360" src="<%=VodUrl%>" frameborder="0" allowfullscreen></iframe>
</div>
<% End IF %>

			<% IF ImgNames<>"" AND HK_ImgViewYN<>"False" Then Response.write "<center><img src='/upload/board/"&ImgNames&"' width='"&ImgSize("board",700,ImgNames)&"' onclick=""openWindow(0,0,'/common/imgview.asp?path=board&imgname="&ImgNames&"','imgview','yes');"" style='cursor:pointer;'></center><br>" %>
			<%

				IF IsArray(FileRec) Then
					For i=0 To UBound(FileRec,2)
						Exitsts=UCase(mid(FileRec(0,i),instrrev(FileRec(0,i),".")+1))
						IF Exitsts="JPG" Or Exitsts="JPEG" Or Exitsts="GIF" Then
							Response.write "<center><img src='/upload/board/"&FileRec(0,i)&"' width='"&ImgSize("board",700,FileRec(0,i))&"' onclick=""openWindow(0,0,'/common/imgview.asp?path=board&imgname="&FileRec(0,i)&"','imgview','yes');"" style='cursor:pointer;'></center><br>"
						End If
					Next
				End IF
			%>

			<div><div id='HKeditorContent' name='HKeditorContent'><%=Content%></div></div>
		</td>
	</tr>
</tbody>
</table>

<!-- 글읽기 S -->
<form name='boardActfrm' id='boardActfrm' method='get' action='' style='margin:0;'>
<input type='hidden' name='mode'>
<input type='hidden' name='sort'>
<input type='hidden' name='idx'>
<input type='hidden' name='Page' value='<%=Page%>'>
<input type='hidden' name='BBSCode' value='<%=BBSCode%>'>
<input type='hidden' name='serboardsort' value='<%=serboardsort%>'>
<input type='hidden' name='Search' value='<%=Search%>'>
<input type='hidden' name='SearchStr' value='<%=SearchStr%>'>
<input type='hidden' name='prepage' value='<%=prepage%>'>
<input type='hidden' name='storeidx' value='<%=storeidx%>'>
</form>

<div style='float:left; padding: 10px 0;'>
	<%=PreTag%>&nbsp;<%=NextTag%>
</div>

<div style='float:right; padding: 10px 0;'>
	<% IF HK_RepYN = "True" And TopYn<>"True" AND PublicYN="False" AND HK_ImgYN<>"True" Then %>
		<input type='button' value='답변' class='button2' onclick="<%=WriteModeChk(HK_MemYN,"location.href='?mode=reply&idx="& Idx &"&Ref="& Ref &"&ReLevel="& ReLevel &"&page="& Page &"&storeidx="& storeidx &"&search="& Search &"&SearchStr="& SearchStr &"&serboardsort="& serboardsort&"'",prepage)%>" style='cursor:pointer'>
	<% End IF %>

	<% IF HK_NotYN<>"True" AND HK_MemYN="1" AND Session("MemberShip")="1" Then %>
		<input type='button' value='수정' class='button2' onclick="goMemberCheck('modify','<%=idx%>');" style='cursor:pointer'>
		<input type='button' value='삭제' class='button2' onclick='goMemberCheck("del","<%=idx%>");' style='cursor:pointer'>
	<% ElseIF HK_NotYN<>"True" AND (HK_MemYN="" OR HK_MemYN="0") Then %>
		<% IF Pwd="" Or IsNull(Pwd) THen %>
			<input type='button' value='수정' class='button2' onclick="goMemberCheck('modify','<%=idx%>');" style='cursor:pointer'>
		<% Else %>
			<input type='button' value='수정' class='button2' onclick="goPwdpage('bbsmodify',<%=idx%>);" style='cursor:pointer'>
		<% End IF %>
		<% IF Pwd="" Or IsNull(Pwd) THen %>
			<input type='button' value='삭제' class='button2' onclick='goMemberCheck("del","<%=idx%>");' style='cursor:pointer'>
		<% Else %>
			<input type='button' value='삭제' class='button2' onClick="goPwdpage('bbsdel',<%=idx%>)" style='cursor:pointer'>
		<% End IF %>
	<% End IF %>

	<input type='button' value='목록' class='button2' onClick="location.href='?page=<%=Page%>&storeidx=<%=storeidx%>&serboardsort=<%=serboardsort%>&search=<%=Search%>&SearchStr=<%=SearchStr%>'" style='cursor:pointer'>
</div>

<% IF HK_comYn=True Then %>
<div id="boardCommentDiv" name="boardCommentDiv" style='padding-top:10px;'></div>
<SCRIPT LANGUAGE="JavaScript">viewBoardCommentArea('<%=idx%>','<%=BBscode%>','')</SCRIPT>
<% End IF%>

<div style='height:50px;'></div>