<%@codepage="65001" language="VBScript"%>
<%
Session.CodePage = 65001
Response.CharSet = "utf-8"
%>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<!--#include virtual = Library/functions.asp-->
<%
Page=Request("page")

Server.ScriptTimeOut=7200
set UploadForm=server.CreateObject("DEXT.FileUpload")
uploadform.DefaultPath=Server.MapPath("/upload/editorData/")

IF Request("filename")<>"" Then
	ImgDelete Request("filename"),UploadForm.DefaultPath
	ImgDelete Request("filename"),Server.MapPath("/upload/thumeditordate/")
End IF

Set UploadForm=Nothing

strLocation="top.location.reload();"
Response.Write ExecJavaAlert("선택하신 파일이 삭제되었습니다.",3)
%>