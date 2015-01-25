<!--#include virtual = common/ADdbcon.asp-->
<%
Dim SpItemCnt,resultSortName
resultSortidx=Request("resultSortidx")
IF resultSortidx="" Then resultSortidx=1

Sql="select Top 1 content from PageAdmin WHERE resultSortidx="&resultSortidx
Set Rs=DBcon.Execute(Sql)

IF Not(Rs.BOf OR Rs.Eof) Then Content=ReplaceNoHtml(Rs("Content"))

Set Rs=Nothing
DBcon.Close
Set DBcon=Nothing
%>

<!--#include virtual = admin/common/adminHeader.asp-->
<SCRIPT LANGUAGE="JavaScript">
<!--
function goAdd(){
	f=document.Pageform;
	document.Pageform.submit();
}
//-->
</SCRIPT>
<SCRIPT language=JavaScript src="/ckeditor/ckeditor.js" type='text/javascript'></SCRIPT>

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
						<table cellpadding="0" cellspacing="0" class="menu" width="100%">
							<tr>
								<td style='color:#39518C;' class='menu'><img src='/admin/image/titleArrow2.gif'><b>페이지관리</td>
								<td align='right'>
									<select name='resultSortidx' style='width:300px; background-color: #D7E7FF;' onchange="location.href='Pageadmin.asp?resultSortidx='+this.value;">
										<option value='1' <%=SelCheck(1,resultSortidx)%>>제품소개페이지</option>
									</select>
								</td>
							</tr>
						</table>
					</td>
				</tr>
				<tr>
					<td>

<form name='Pageform' method='post' action='PageAdminOk.asp'>
<input type='hidden' name='resultSortidx' value="<%=resultSortidx%>">
<table width="100%" border="1" cellpadding="0" cellspacing="0" bordercolor='#BDBEBD' class="menu" style='border-collapse: collapse'>
	<tr><td height='30' bgcolor='#EFEFEF' align='center'><b><font color='red'><%=resultSortName%></font> 페이지 수정</b></td></tr>
	<tr>
		<td align='center' style='padding:5px;'>
			<textarea name='content' rows='25' class='ckeditor' style='width:100%;'><%=Content%></textarea>
		</td>
	</tr>
	<tr><td align='center' height='25'><input type='button' value='페이지 수정하기' class='btn' style='width:99%;' onclick='goAdd()'></td></tr>
</table>
</form>

					</td>
				</tr>
			</table>
		</td>
	</tr>
</table>

<!--#include virtual = admin/common/bottom.html-->