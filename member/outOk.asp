<!-- #include virtual = common/dbcon.asp -->
<% HK_returnURL="/member/out.asp" %>
<!--#include virtual = common/sessionchk.asp-->
<%
Content=checkParameter("char",ReplaceNoHtml(Request("Content"))
Pwd=checkParameter("char",Request("pwd"))

Sql="Select idx From Members Where idx=? AND pwd=?"
Set objCmd = Server.CreateObject("ADODB.Command")
With objCmd
	.ActiveConnection = DBcon
	.CommandType = adCmdText
	.CommandText = Sql
	
	.Parameters.Append .CreateParameter("@Par", adBigint, adParamInput, 8, Session("useridx"))
	.Parameters.Append .CreateParameter("@Par", adVarWChar, adParamInput, 20, Pwd)
End With
Set Rs = objCmd.Execute()
Set objCmd = Nothing

IF Rs.Bof Or Rs.Eof Then
	Response.Write ExecJavaAlert("죄송합니다.비밀번호가 일치하지않아 탈퇴신청이 중지되었습니다.\n확인후 다시시도해주시길 바랍니다.",0)
	Response.End
End IF

Sql="Insert INTO ExitMember(useridx,title,regdate) values(?,?,Convert(Varchar(10),GetDate(),23))"
Set objCmd = Server.CreateObject("ADODB.Command")
With objCmd
	.ActiveConnection = DBcon
	.CommandType = adCmdText
	.CommandText = Sql
	
	.Parameters.Append .CreateParameter("@email", adBigint, adParamInput, 8, Session("useridx"))
	.Parameters.Append .CreateParameter("@BoardSort", adVarWChar, adParamInput, 100, Content)
	.Execute,,adExecuteNoRecords
End With
Set objCmd = Nothing


DBcon.close
Set DBcon=Nothing

Session.Contents.RemoveAll
strLocation="/"
Response.WRite ExecJavaAlert("회원탈퇴신청을 완료하셨습니다.\n그동안 이용해주셔서 감사합니다.",2)
%>