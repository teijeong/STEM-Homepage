<!-- #include virtual = common/ADdbcon.asp -->
<%
Dim Sql,strLocation,uploadform
Dim FileName,Idx,Page

Idx=Request("idx")
Page=Request("page")

Server.ScriptTimeOut=7200
set uploadform=server.CreateObject("DEXT.FileUpload")
uploadform.DefaultPath=Server.MapPath("/upload/mainbanner/")

Sql="SELECT Bansort,filenames From mainbannerAdmin Where idx="&IDX
SET Rs=DBcon.Execute(Sql)
If Not(Rs.Bof Or Rs.Eof) Then
	IF Rs(1)<>"" Then
		ImgDelete Rs(1),UploadForm.DefaultPath
		ImgDelete getImageThumbFilename(Rs(1)),UploadForm.DefaultPath
	End IF
	Bansort=Rs(0)
End IF

Sql="DELETE mainbannerAdmin WHERE idx="&Idx
DBcon.Execute Sql

Set UploadForm=Nothing
DBcon.Close
Set DBcon=Nothing

strLocation="mainbanner.asp?Bansort="&Bansort
Response.Write ExecJavaAlert("선택하신 게시물이 삭제되었습니다.",2)
%>