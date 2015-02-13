<!-- #include virtual = common/dbcon.asp -->
<%
WIP=Request.ServerVariables("REMOTE_ADDR")

Writer=ReplaceNoHtml(Request("writer"))
Tel=ReplaceNoHtml(Request("Tel"))
consort=ReplaceNoHtml(Request("consort"))

Sql="INSERT INTO Consult1(writer,tel,Consort,wip) VALUES(?, ?, ?, ?)"

Set objCmd = Server.CreateObject("ADODB.Command")
With objCmd
    .ActiveConnection = DBcon
    .CommandType = adCmdText
    .CommandText = Sql
    
    .Parameters.Append .CreateParameter("@Writer", adVarWChar, adParamInput, 50, writer)
    .Parameters.Append .CreateParameter("@Tel", adVarWChar, adParamInput, 100, Tel)
    .Parameters.Append .CreateParameter("@consort", adVarWChar, adParamInput, 100, consort)
    .Parameters.Append .CreateParameter("@wip", adVarChar, adParamInput, 50, wip)

    .Execute,,adExecuteNoRecords
End With
Set objCmd = Nothing

DBcon.Close
Set DBcon=Nothing

strLocation="top.location.reload()"
Response.Write ExecJavaAlert("빠른문의 신청서가 등록되었습니다.\n빠른 시일안에 연락드리겠습니다.",3)
%>