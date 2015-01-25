<!-- #include virtual = common/ADdbcon.asp -->
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<%
Dim Sql,strLocation
Dim Page,Idx

Page=Request("page")
idx=Request("idx")

Sql="Delete Faq Where Idx="&Idx
DBcon.Execute Sql

DBcon.Close
Set DBcon=Nothing

strLocation="faqList.asp?page="&Page
Response.Write ExecJavaAlert("선택하신 글이 삭제되었습니다.",2)
%>