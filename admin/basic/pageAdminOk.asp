<!-- #include virtual = common/ADdbcon.asp -->
<%
resultSortidx = Request("resultSortidx")
Content = Request("Content")
Idx = Request("idx")
Sort = Request("sort")
Content = Replace(Content,"http://"&Request.Servervariables("Server_name")&"/","/")

Sql="Select * FROM PageAdmin WHERE resultSortidx="&resultSortidx
Set Rs=DBcon.Execute(Sql)

IF Rs.Bof Or Rs.Eof Then
	Sql="Insert INTO PageAdmin(resultSortidx,content) values(?,?)"
Else
	Sql="Update PageAdmin Set resultSortidx=?, content=? Where resultSortidx="&resultSortidx
End IF

Set objCmd = Server.CreateObject("ADODB.Command")
With objCmd
	.ActiveConnection = DBcon
	.CommandType = adCmdText
	.CommandText = Sql
	
	.Parameters.Append .CreateParameter("@resultSortidx", adInteger, adParamInput, 4, resultSortidx)
	.Parameters.Append .CreateParameter("@Content", adVarWChar, adParamInput, 2147483647, Content)

	.Execute,,adExecuteNoRecords
End With

Set objCmd = Nothing
DBcon.Close
Set DBcon=Nothing

strLocation="PageAdmin.asp?resultSortidx="&resultSortidx
Response.Write ExecJavaAlert("페이지가 수정 되었습니다.",2)
%>