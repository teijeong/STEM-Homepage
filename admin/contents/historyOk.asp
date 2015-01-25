<!-- #include virtual = common/ADdbcon.asp -->
<%
title=ReplaceNoHtml(Request("title"))
Bansort=Request("Bansort")
content=Replace(Request("content"),"http://"&Request.Servervariables("Server_name")&"/","/")

Idx=Request("idx")
Sort=Request("sort")

IF Sort="edit" Then
	Sql="Update historyAdmin Set content=?, bansort=?, title=? Where idx="&idx
Else
	Sql="Insert INTO historyAdmin(content,bansort,title) values(?,?,?)"
End IF

Set objCmd = Server.CreateObject("ADODB.Command")
With objCmd
	.ActiveConnection = DBcon
	.CommandType = adCmdText
	.CommandText = Sql
	
	.Parameters.Append .CreateParameter("@content", adVarWchar, adParamInput, 2147483647, content)
	.Parameters.Append .CreateParameter("@bansort", adInteger, adParamInput, 1, bansort)
	.Parameters.Append .CreateParameter("@title", adVarWChar, adParamInput, 100, title)

	.Execute,,adExecuteNoRecords
End With

Set objCmd = Nothing
DBcon.Close
Set DBcon=Nothing

IF Sort="edit" Then
	strLocation="self.close(); parent.opener.location.reload();"
	Response.Write ExecJavaAlert("게시물이 수정 되었습니다.",3)
Else
	strLocation="history.asp?Bansort="&Bansort
	Response.Write ExecJavaAlert("게시물이 추가 되었습니다.",2)
End IF
%>