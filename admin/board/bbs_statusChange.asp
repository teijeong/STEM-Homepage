<!-- #include virtual = common/ADdbcon.asp -->
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<%
idx=Request("idx")
status=Request("status")
bbscode=Request("bbscode")

Call HK_BBSSetup(Cint(BBsCode))

Sql="UPDATE bbslist SET status="&status&" Where ref="&idx
DBcon.Execute Sql

DBcon.Close
Set DBcon=Nothing

StrLocation="top.location.reload();"
Response.write ExecJavaAlert("해당 게시물의 상태가 변경되었습니다.",3)
%>