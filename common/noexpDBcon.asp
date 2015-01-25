<%
set fso = Server.CreateObject("Scripting.FileSystemObject")
set f = fso.OpenTextFile("C:\ConnectString4Web\stem\stem.dat")
strconnect = f.Readline

Set DBCon = Server.CreateObject("ADODB.Connection") 
DBCon.Open strConnect

Set Fso=Nothing
Set F=Nothing
%>