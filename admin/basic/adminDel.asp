<!-- #include virtual = common/ADdbcon.asp -->
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<%
Search=Request("Search")
SearchStr=Request("SearchStr")
Page=Request("page")
idx=Request("idx")

IF CSTR(idx)="0" Then
    Response.write Execjavaalert("접근할수 없는 사용자코드입니다.\n다시시도해주세요.",0)
    Response.end
End IF

Sql="Delete admin Where idx="&Idx
DBcon.Execute Sql

Set Rs=Nothing
Set UploadForm=Nothing
DBcon.Close
Set DBcon=Nothing

strLocation="adminlist.asp?search="&Search&"&searchStr="&searchStr&"&page="&Page
Response.Write ExecJavaAlert("선택하신 유저가 삭제되었습니다.",2)
%>