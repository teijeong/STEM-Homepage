<!-- #include virtual = common/dbcon.asp -->
<%
Idx=Request("idx")
admemo=ReplaceEnSine(Request("admemo"))

Sql="update consult set memo=N'"&admemo&"' where idx="&idx
DBcon.Execute Sql

DBcon.Close
Set DBcon=Nothing

StrLocation="top.location.reload();"
Response.write ExecJavaAlert("메모가 수정되었습니다.",3)
%>