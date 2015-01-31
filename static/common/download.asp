<%@codepage="65001" language="VBScript"%>
<%
Session.CodePage = 65001
Response.CharSet = "utf-8"

Response.Clear 
Response.Buffer = False 

Path=Replace(Replace(Request("path"),".",""),"/","")
DownFiles=Replace(Request("downfile"),"/","")
browser = Request.ServerVariables("HTTP_USER_AGENT")

FILE_PATH = Server.MapPath("\upload\"&Path&"") & "\" & DownFiles

IF InStr(LCase(browser),"chrome")=0 AND InStr(LCase(browser),"firefox")=0 Then
	Response.AddHeader "Content-Disposition","attachment;filename=" & Server.URLPathEncode(DownFiles)
End IF

set objFS =Server.CreateObject("Scripting.FileSystemObject") 
set objF = objFS.GetFile(FILE_PATH) 
Response.AddHeader "Content-Length", objF.Size 
set objF = nothing 
set objFS = nothing 

Response.ContentType = "application/unknown"  
Response.CacheControl = "public" 

Set objDownload = Server.CreateObject("DEXT.FileDownload") 
objDownload.Download FILE_PATH 
Set objDownload = Nothing 
%>