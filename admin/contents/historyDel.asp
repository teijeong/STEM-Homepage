<!-- #include virtual = common/ADdbcon.asp -->
<%
Dim Sql,strLocation,uploadform
Dim FileName,Idx,Page

Idx=Request("idx")
Page=Request("page")

Sql="SELECT Bansort From historyAdmin Where idx="&IDX
SET Rs=DBcon.Execute(Sql)
If Not(Rs.Bof Or Rs.Eof) Then Bansort=Rs(0)

Sql="DELETE historyAdmin WHERE idx="&Idx
DBcon.Execute Sql

Set UploadForm=Nothing
DBcon.Close
Set DBcon=Nothing

strLocation="history.asp?Bansort="&Bansort
Response.Write ExecJavaAlert("선택하신 게시물이 삭제되었습니다.",2)
%>