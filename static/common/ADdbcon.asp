<%@codepage="65001" language="VBScript"%>
<%
Session.CodePage = 65001
Response.CharSet = "utf-8"

with response
    .expires=-1
    .addheader "pragma","no-cache"
    .addheader "cache-control","no-cache"
end with
%>

<!--#include virtual = library/functions.asp-->
<!--#include virtual = Library/BBsFunctions.asp-->
<%
ADLoginCk()
Dim DBcon,strconnect
Dim HK_notYN,HK_pdsYN,HK_MemYN,HK_repYn,HK_comYn,HK_pubYn,HK_imgYN,HK_LangSort,HK_ImgViewYN,HK_ViewMode,HK_VodUrlYN,HK_comMode,HK_DownMode

Dim Fso,F
set fso = Server.CreateObject("Scripting.FileSystemObject")
set f = fso.OpenTextFile("C:\ConnectString4Web\stem\stem.dat")
strconnect = f.Readline

Set DBCon = Server.CreateObject("ADODB.Connection") 
DBCon.Open strConnect

Set Fso=Nothing
Set F=Nothing
%>