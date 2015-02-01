<!--#include virtual = common/ADdbcon.asp-->
<form name='theform' method='post' action='pwdEdit.asp'>
</form>
<%
Dim M_Pwd,New_Pwd,Cmd,Result

m_uid=Request("m_uid")
M_Pwd=Request("m_pwd")
New_Pwd=Request("new_pwd")

Set Cmd=CreateCommand(DBcon,"SAP_PwdEditProc",adCmdStoredProc)
With Cmd
    .Parameters.Append CreateInputParameter("@M_Userid",adVarWchar,15,m_uid)
    .Parameters.Append CreateInputParameter("@LoginID",adVarWchar,15,Request.cookies("acountcode"))
    .Parameters.Append CreateInputParameter("@M_Pwd",adVarWchar,15,M_Pwd)
    .Parameters.Append CreateInputParameter("@New_Pwd",adVarWchar,15,New_Pwd)
    .Parameters.Append CreateOutPutParameter("@Result",adTinyInt,1)
    .Execute
End With
Result=Cmd.Parameters("@Result").Value

Set Cmd=Nothing
DBcon.Close
Set DBcon=Nothing

Response.Write "<SCRIPT LANGUAGE='JavaScript'>"&Vbcrlf
IF Result=0 Then
    Response.Cookies("acountcode")=m_uid
    Response.Write "alert('관리자정보가 변경되었습니다.')"&Vbcrlf
    Response.Write "window.close();"&Vbcrlf
ElseIF Result=1 Then
    Response.Write "alert('이미등록된 아이디가 있습니다.\n다시시도해주세요.')"&Vbcrlf
    Response.Write "window.name='modalwin'"&Vbcrlf
    Response.Write "theform.submit();"
Else
    Response.Write "alert('일치하는 정보가 없습니다.\n다시시도해주세요.')"&Vbcrlf
    Response.Write "window.name='modalwin'"&Vbcrlf
    Response.Write "theform.submit();"
End IF
Response.Write "</SCRIPT>"&Vbcrlf
%>