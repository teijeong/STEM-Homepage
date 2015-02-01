<!-- #include virtual = common/ADdbcon.asp -->
<%
Page=Request("page")
idx=Request("idx")
Search=Request("Search")
SearchStr=Request("SearchStr")

Server.ScriptTimeOut=7200
set UploadForm=server.CreateObject("DEXT.FileUpload")
uploadform.DefaultPath=Server.MapPath("/upload/board/")

Sql="SELECT FileNames From consult Where idx="&idx
SET Rs=DBcon.Execute(Sql)

IF Not(Rs.Bof Or Rs.Eof) Then
    FileNames=Rs("FileNames")

    IF FileNames<>"" Then ImgDelete FileNames,UploadForm.DefaultPath
End IF

Sql="Delete Consult Where idx="&Idx
DBcon.Execute Sql

Set UploadForm=Nothing
DBcon.Close
Set DBcon=Nothing

strLocation="consult.asp?page="&Page&"&search="&Search&"&searchstr="&SearchStr
Response.Write ExecJavaAlert("선택하신 게시물이 삭제되었습니다.",2)
%>