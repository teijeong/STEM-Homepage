<!-- #include virtual = common/ADdbcon.asp -->
<%
Server.ScriptTimeOut=7200
Set uploadform=server.CreateObject("DEXT.FileUpload")
uploadform.DefaultPath=Server.MapPath("/upload/mainbanner/")

title=ReplaceNoHtml(UploadForm("title"))
linkurl=UploadForm("linkurl")
Bansort=UploadForm("Bansort")
Note1=ReplaceNoHtml(UploadForm("Note1"))
Note2=ReplaceNoHtml(UploadForm("Note2"))
Note3=ReplaceNoHtml(UploadForm("Note3"))

Filename=UploadForm("filename")
filedelchk=UploadForm("filedelchk")
Idx=UploadForm("idx")
Sort=UploadForm("sort")

IF filedelchk<>"" And Filename<>"" Then
    ImgDelete Filename,UploadForm.DefaultPath
    ImgDelete getImageThumbFilename(Filename),UploadForm.DefaultPath
End IF
IF filedelchk<>"" Or Sort="" Then 
    IF UploadForm("files")<>"" Then 
        Filename=ImgSaves(UploadForm("files"),uploadform.defaultpath,51200000)
        IF Filename=False Then Result=1

        IF Result=1 Then
            Set UploadForm=Nothing
            DBcon.Close
            Set DBcon=Nothing
            Response.Write ExecJavaAlert("업로드 허용용량(50M)을 초과하여 업로드를 실패하였습니다.",0)
            Response.End
        Else
            ThumbSaves 500,500,UploadForm("files"),uploadform.DefaultPath,Filename, "thumbs"
        End IF
    Else
        Filename=""
    End IF
End IF

IF Sort="edit" Then
    Sql="Update mainbannerAdmin Set note1=?, note2=?, note3=?, bansort=?, title=?, filenames=?, linkurl=? Where idx="&idx
Else
    Sql="Insert INTO mainbannerAdmin(note1,note2,note3,bansort,title,filenames,linkurl) values(?,?,?,?,?,?,?)"
End IF

Set objCmd = Server.CreateObject("ADODB.Command")
With objCmd
    .ActiveConnection = DBcon
    .CommandType = adCmdText
    .CommandText = Sql
    
    .Parameters.Append .CreateParameter("@note1", adVarWChar, adParamInput, 400, note1)
    .Parameters.Append .CreateParameter("@note1", adVarWChar, adParamInput, 200, note2)
    .Parameters.Append .CreateParameter("@note1", adVarWChar, adParamInput, 200, note3)
    .Parameters.Append .CreateParameter("@bansort", adBigint, adParamInput, 8, bansort)
    .Parameters.Append .CreateParameter("@title", adVarWChar, adParamInput, 100, title)
    .Parameters.Append .CreateParameter("@Filenames", adVarWChar, adParamInput, 100, Filename)
    .Parameters.Append .CreateParameter("@linkurl", adVarWChar, adParamInput, 200, linkurl)

    .Execute,,adExecuteNoRecords
End With

Set objCmd = Nothing
DBcon.Close
Set DBcon=Nothing

IF Sort="edit" Then
    strLocation="self.close(); parent.opener.location.reload();"
    Response.Write ExecJavaAlert("게시물이 수정 되었습니다.",3)
Else
    strLocation="mainbanner.asp?Bansort="&Bansort
    Response.Write ExecJavaAlert("게시물이 추가 되었습니다.",2)
End IF
%>