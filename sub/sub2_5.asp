<!--#include virtual = common/dbcon.asp-->
<%
bansort=Request("bansort")
Search=Replaceensine(ReplaceNoHtml(Request("Search")))
SearchStr=Replaceensine(ReplaceNoHtml(Request("SearchStr")))

IF bansort="" Then bansort=Year(Date())
IF Search<>"" Then strWhere = strWhere & " And "&Search&" LIKE N'%"&SearchStr&"%' "

Page=GetPage()
PageSize=1000

Set Rs=Server.CreateObject("ADODB.RecordSet")
Sql="select top "&PageSize&" idx,title,bansort,content from historyadmin WHERE bansort="&bansort&""&strWhere&" AND idx NOT IN (select top "&(Page-1)*PageSize&" idx from historyadmin Where bansort="&bansort&""&strWhere&" order by listnum ASC, Idx ASC) order by listnum ASC, Idx ASC"
Rs.Open Sql,DBcon,1

IF Not(Rs.Bof Or Rs.Eof) Then
	Record_Cnt=Dbcon.Execute("select count(idx) from historyadmin Where bansort="&bansort&""&strWhere)
	TotalPage=Int((CInt(Record_Cnt(0))-1)/CInt(PageSize)) +1
	Allrec=Rs.GetRows
	Count=Record_Cnt(0)
Else
	Count=0
End IF
Rs.Close

Sql="SELECT bansort FROM historyadmin Group By bansort Order by bansort ASC"
Set Rs=DBcon.Execute(Sql)
IF Not(Rs.Bof Or Rs.Eof) Then YearRec=Rs.GetRows()
Rs.Close

Set Rs=Nothing
DBcon.Close
Set DBcon=Nothing

Function PT_SelectBox()
	IF IsArray(YearRec) Then
		For i=0 To UBound(YearRec,2)
			Response.Write "<option value='"&YearRec(0,i)&"' "&selCheck(YearRec(0,i),bansort)&">"&YearRec(0,i)&"년</option>"
		Next
	End IF
End Function

Function PT_ItemList()
	Dim i,k,ThumbFileName,tmpFileName

	IF IsArray(Allrec) Then
		For i=0 To UBound(Allrec,2)
			Response.WRite "<tr>"&Vbcrlf
			Response.WRite "	<th>"&Allrec(1,i)&"</th>"&Vbcrlf
			Response.WRite "	<td><div id='HKeditorContent' name='HKeditorContent'>"&Allrec(3,i)&"</div></td>"&Vbcrlf
			Response.WRite "</tr>"&Vbcrlf
		Next
	Else
		Response.WRite "<li>검색된 게시물이 없습니다.</li>"&Vbcrlf
	End IF
End Function
%>

<!--#include virtual = "/inc/body.asp"-->
<% mNum=2 : sNum=5 %>
<!--#include virtual = "/inc/top.asp"-->
	<!--container-->
	<div id="container">
		<div class="contain">
			<div class="s_contents">
				<!--#include virtual = "/inc/right_login.asp"-->
				<!--#include virtual = "/inc/left.asp"-->
			</div>
			<div class="con">
				<ul>
					<li class="stit"><img src="/images/stit<%=mNum%>_<%=sNum%>.gif" alt="" /></li>
					<li class="con_img">
						<p style="text-align:right">
							<select name="bansort" class="" onchange="location.href='?bansort='+this.value">
							<%=PT_SelectBox%>
							</select>
						</p>
						<table cellspacing="0" cellpadding="0" class="history">
						<colgroup><col width="30%" /><col /></colgroup>
						<thead>
							<tr>
							<th>일 시</th>
							<th>활동내용</th>
							</tr>
						</thead>
						<tbody>
							<%=PT_ItemList()%>
						</tbody>
						</table>
					</li>
				</ul>
			</div>
		</div>
	</div>
	<!--//container-->
<!--#include virtual = "/inc/footer.asp"-->