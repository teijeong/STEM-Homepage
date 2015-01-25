<!-- #include virtual = common/ADdbcon.asp -->
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<%
Dim Idx,Sql,strLocation,Rs,BBscode
Idx=Request("idx")
BBscode=Request("BBscode")

Sql="DELETE BoardSort WHERE idx="&Idx
DBcon.Execute Sql

DBcon.Close
Set DBcon=Nothing

strLocation="boardSortAdmin.asp?bbscode="&BBscode
Response.Write ExecJavaAlert("선택하신 분류가 삭제되었습니다.",2)
%>