<!-- #include virtual = common/ADdbcon.asp -->
<%
serconsort=Request("serconsort")
serstatus=Request("serstatus")
searchDate1=Request("searchDate1")
searchDate2=Request("searchDate2")
Searchitem=Request("Searchitem")
serorderby1=Request("serorderby1")
serorderby2=Request("serorderby2")
searchDsort=Request("searchDsort")
SearchStr=Replaceensine(Request("SearchStr"))

Page=Request("page")
idx=Request("idx")
status=Request("status")

Sql="UPDATE Consult Set status="&status&" Where idx="&idx
DBcon.Execute Sql

DBcon.Close
Set DBcon=Nothing

strLocation="ConsultView.asp?idx="&idx&"&page="& page &"&serconsort="& serconsort &"&serstatus="& serstatus &"&searchDate1="& searchDate1 &"&searchDate2="& searchDate2 &"&searchDsort="& searchDsort &"&searchitem="& searchitem &"&serorderby1="& serorderby1 &"&serorderby2="& serorderby2 &"&searchStr="& SearchStr
Response.Write ExecJavaAlert("해당 신청서의 접수상태가 변경되었습니다.",2)
%>