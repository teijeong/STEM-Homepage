<!--#include virtual = common/ADdbcon.asp-->
<%
Dim Sql,Rs,Allrec,Page,PageSize,Record_Cnt,TotalPage,Count

Page=Request("page")
PageSize=10

Search=Replaceensine(ReplaceNoHtml(Request("Search")))
SearchStr=Replaceensine(ReplaceNoHtml(Request("SearchStr")))

IF Page="" Then	Page=1
IF Search<>"" Then StrWhere = StrWhere & " And "&Search&" LIKE '%"&SearchStr&"%' "

Sql="Select top "&PageSize&" idx,id,name,regdate,email from admin where idx<>1 "&StrWhere&" AND idx not in"
Sql=Sql & "(select top "&(Page-1)*Pagesize&" idx from admin Where idx<>1 "&StrWhere&" order by idx DESC) order by idx DESC"

Set Rs=Server.CreateObject("ADODB.RecordSet")
Rs.Open Sql,dbcon,1

IF Not(Rs.Bof Or Rs.Eof) Then
	Record_Cnt=Dbcon.Execute("select count(idx) from admin Where idx<>1 "&StrWhere)
	Count=Record_Cnt(0)
	TotalPage=Int((CInt(Count)-1)/CInt(PageSize)) +1 
	Allrec=Rs.GetRows
End IF
Rs.Close

Set Rs=Nothing
DBcon.Close
Set DBcon=Nothing

Function PT_Mlist
	Dim i,No
	IF Page=1 Then
		No=Count
	Else
		No=Count-(Page-1)*Pagesize
	End IF
	IF IsArray(Allrec) Then
		For i=0 To Ubound(Allrec,2)
			Response.Write "<tr align='center'>"&Vbcrlf
			Response.Write "<td height='25'>"&No&"</td>"&Vbcrlf
			Response.Write "<td>"&Allrec(1,i)&"</td>"&Vbcrlf
			Response.Write "<td>"&Allrec(2,i)&"</td>"&Vbcrlf
			Response.Write "<td>"&Allrec(4,i)&"</td>"&Vbcrlf
			Response.Write "<td>"&Left(Allrec(3,i),10)&"</td>"&Vbcrlf
			Response.Write "<td>"&Vbcrlf
			Response.Write "<a href='adminadd.asp?idx="&Allrec(0,i)&"&Page="&Page&"&Search="&Search&"&SearchStr="&SearchStr&"'><img src='/admin/image/icon/bt_detail.gif' border='0' align='absmiddle'></a>"&Vbcrlf
			Response.Write "<a href='javascript:memDel("&Allrec(0,i)&");'><img src='/admin/image/icon/bt_del1.gif' border='0' align='absmiddle'></a>"&Vbcrlf
			Response.Write "</td></tr>"&Vbcrlf
			No=No-1
		Next
	Else
		Response.Write "<tr><td colspan='6' align='center' height='200'>검색된 관리자가 없습니다.</td></tr>"&Vbcrlf
	End IF
End Function
%>

<!--#include virtual = admin/common/adminHeader.asp-->
<SCRIPT LANGUAGE="JavaScript">
<!--
function memDel(idx){
	var value=confirm("선택하신 유저를 삭제 하시겠습니까?");
	if(value){
		document.memform.action='adminDel.asp?page=<%=Page%>&search=<%=Search%>&searchStr=<%=searchStr%>&idx='+idx;
		document.memform.submit();
	}
}
function searchGo(){
	var f=document.search;
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
			<table cellpadding="2" cellspacing="0" width='880'>
				<tr>
					<td>
						<table width="100%" border="0" cellspacing="0" cellpadding="0" class="menu">
							<tr>
								<td style='color:#39518C;'><img src='/admin/image/titleArrow2.gif'><b>관리자관리</td>
								<td align='right'>

<table border="0" cellpadding="0" cellspacing="3" >
<form name='search' method='get' action='adminlist.asp' onsubmit="searchGo();event.returnValue= false;">
	<tr>
	  <td>
		<select align="absMiddle" name="search">
			<option value="name">이 름</option>
			<option value="id">아이디</option>
			<option value="email">Email</option>
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
						<table width='100%' border='1' cellspacing='0' cellpadding='3' bordercolor='#BDBEBD' class='menu' style='border-collapse: collapse'>
							<form name='memform' method='post' action=''>
							<tr align='center' bgcolor='#F6F6F6'>
								<td width='8%' height='25'>No</td>
								<td width='15%'>아이디</td>
								<td>이 름</td>
								<td>Email</td>
								<td width='12%'>등록일자</td>
								<td width='14%'>관리</td>
							</tr>
							<%PT_Mlist%>
							</form>
						</table>
					</td>
				</tr>
				<tr>
					<td>
						<table width="100%" border="0" cellspacing="0" cellpadding="0">
							<tr> 
								<td align='center'><%=PT_PageLink("adminlist.asp","search="&Search&"&searchStr="&searchStr)%></td>
								<td align='right' width='10%'><a href='adminadd.asp'><img src='/admin/image/icon/bt_write.gif' border='0'></a></td>
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