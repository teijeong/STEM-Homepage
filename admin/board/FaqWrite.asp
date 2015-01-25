<!--#include virtual = common/ADdbcon.asp-->
<%
Dim Sql,Rs,Allrec,Idx,Content,TitleTag,Title,Sort,Page
Dim TitleImg,BoardSort

Sort=Request("sort")
Page=Request("page")
Idx=Request("idx")

IF Idx<>"" Then
	Sql="SELECT title,content,BoardSort FROM Faq WHERE idx="&idx
		
	Set Rs=DBcon.Execute(Sql)
	IF Not(Rs.Bof Or Rs.Eof) Then
		Allrec=Rs.GetRows
		Content=ReplaceNoHtml(Allrec(1,0))
		Title=ReplaceTextField(Allrec(0,0))
		BoardSort=Allrec(2,0)
	End IF
	Set Rs=Nothing

	TitleTag="수정"
	Sort="edit"
Else
	TitleTag="등록"
End IF

DBcon.Close
Set DBcon=Nothing
%>

<!--#include virtual = admin/common/adminHeader.asp-->
<SCRIPT language=JavaScript src="/ckeditor/ckeditor.js" type='text/javascript'></SCRIPT>
<SCRIPT LANGUAGE="JavaScript">
<!--
function sendit(){
	var form=document.boardform;
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
								<td style='color:#39518C;;'><img src='/admin/image/titleArrow1.gif'><b>자주하는질문(FAQ)</td>
							</tr>
						</table>
					</td>
				</tr>
				<tr>
					<td>
						<table width="100%" border="1" cellpadding="3" cellspacing="0" bordercolor='#BDBEBD' class="menu" style='border-collapse: collapse'>
						<form name="boardform" action="faqwriteok.asp" method="post">
						<input type='hidden' name='sort' value='<%=Sort%>'>
						<input type='hidden' name='idx' value='<%=Idx%>'>
						<input type='hidden' name='page' value='<%=Page%>'>
							<tr bgcolor="#F6F6F6">
								<td align='right' colspan='2'>게시물&nbsp; <%=TitleTag%>&nbsp;&nbsp;</td>
							</tr>
							<!-- <tr>
								<td width='100' bgcolor="#F6F6F6">&nbsp;등록분류</td>
								<td>
									<select name="BoardSort">
										<option value="1">중고관련</option>
										<option value="2" <%=selCheck(boardsort,2)%>>창업관련</option>
										<option value="3" <%=selCheck(boardsort,3)%>>회원정보</option>
										<option value="4" <%=selCheck(boardsort,4)%>>주문/배송관련</option>
										<option value="5" <%=selCheck(boardsort,5)%>>입금/결제</option>
										<option value="6" <%=selCheck(boardsort,6)%>>교환/반품/AS</option>
										<option value="7" <%=selCheck(boardsort,7)%>>취소/환불</option>
										<option value="8" <%=selCheck(boardsort,8)%>>적립금/사은품</option>
										<option value="9" <%=selCheck(boardsort,9)%>>방문구매</option>
										<option value="10" <%=selCheck(boardsort,10)%>>고객센터</option>
										<option value="11" <%=selCheck(boardsort,11)%>>세금계산서/영수증</option>
										<option value="12" <%=selCheck(boardsort,12)%>>대량구매/제휴</option>
									</select>
								</td>
							</tr> -->
							<tr>
								<td width='100' bgcolor="#F6F6F6">&nbsp;글제목</td>
								<td>
									<input type='text' name='title' style='width:99%;' class='input' Value='<%=Title%>' maxlength='100'>
								</td>
							</tr>
							<tr>
								<td bgcolor="#F6F6F6">&nbsp;내용</td>
								<td>
									<textarea name='content' style='width:100%; word-break:break-all;' rows='30' class='ckeditor'><%=Content%></textarea>
								</td>
							</tr>
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