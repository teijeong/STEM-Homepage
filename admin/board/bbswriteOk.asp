<!-- #include virtual = common/ADdbcon.asp -->
<%
Dim strLocation,Cmd,Code,ReLevel,Writer,Page,BbsCode,Topyn,imgName(0),imgDel_Chk(0)
Dim Idx,Sort,Title,Content,AlertTag,BoardSort,Search,SearchStr
Dim Sql,ObjCmd,Result,i
Dim Wip,UploadForm

WIP=Request.ServerVariables("REMOTE_ADDR")

Server.ScriptTimeOut=7200
set uploadform=server.CreateObject("DEXT.FileUpload")
uploadform.DefaultPath=Server.MapPath("/upload/board/")

sersel1=UploadForm("sersel1")
serboardsort=UploadForm("serboardsort")
Search=UploadForm("Search")
SearchStr=UploadForm("SearchStr")
BoardSort=ChangeNull(UploadForm("BoardSort"))
ref=UploadForm("ref")
ReLevel=UploadForm("ReLevel")
bbscode=UploadForm("bbscode")
Page=UploadForm("page")
Writer=ReplaceNoHtml(UploadForm("Writer"))
Title=ReplaceNoHtml(UploadForm("title"))
VodUrl=ReplaceNoHtml(UploadForm("VodUrl"))
Content = Replace(UploadForm("content"),"http://"&Request.Servervariables("Server_name")&"/","/")
Idx=UploadForm("idx")
Sort=UploadForm("sort")
Topyn=UploadForm("topyn")
imgDel_Chk(0)=UploadForm("imgDel_Chk")
imgName(0)=UploadForm("imgname")

startdate=UploadForm("startdate")
enddate=UploadForm("enddate")
Note1=ReplaceNoHtml(UploadForm("Note1"))
Note2=ReplaceNoHtml(UploadForm("Note2"))
status=spaceToZero(UploadForm("status"))

Call HK_BBSSetup(BBsCode)

Dim ThumbFileName,tmpFileName
For i=1 To UploadForm("imgfiles").count
    IF imgDel_Chk(i-1)<>"" And imgName(i-1)<>"" Then
        ImgDelete imgName(i-1),UploadForm.DefaultPath
        ImgDelete getImageThumbFilename(imgName(i-1)),UploadForm.DefaultPath
    End IF

    IF imgDel_Chk(i-1)<>"" Or Sort="" Then 
        IF UploadForm("imgfiles")(i)<>"" Then 
            imgName(i-1)=ImgSaves(UploadForm("imgfiles")(i),uploadform.defaultpath,30720000)
            IF imgName(i-1)=False Then Result=1

            IF Result=1 Then
                Set UploadForm=Nothing
                DBcon.Close
                Set DBcon=Nothing
                Response.Write ExecJavaAlert("업로드 허용용량(30M)을 초과하여 업로드를 실패하였습니다.",0)
                Response.End
            Else
                ThumbSaves 500 , 500 , UploadForm("imgfiles")(i) , uploadform.DefaultPath, imgName(i-1), "thumbs"
            End IF
        Else
            imgName(i-1)=""
        End IF
    End IF
Next

IF Sort="edit" Then
    IF ReLevel="A" Then
        Sql="Update BBsList Set BoardSort="&ChangeStrNull(BoardSort)&" Where ref="&Idx
        DBcon.Execute Sql
    End IF
    Sql="UPDATE BBsList Set topYN="&spaceToZero(Topyn)&" Where ref="&ref
    DBcon.Execute Sql

    AlertTag="수정"
    Sql="Update bbslist Set status=?,note1=?,note2=?,VodUrl=?,startdate=?,enddate=?,boardSort=?,writer=?,Title=?,Content=?,wip=?,imgnames=? Where idx="&idx
Else
    AlertTag="등록"
    Sql="INSERT INTO bbslist(status,note1,note2,VodUrl,startdate,enddate,BoardSort,writer,Title,Content,wip,regdate,imgnames,boardidx,useridx,pwd,topyn,publicYN,submit,adwrite) "
    Sql = Sql & "VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, getdate()  ,?,?,null,null,?,?,1,1)"
End IF

Set objCmd = Server.CreateObject("ADODB.Command")
With objCmd
    .ActiveConnection = DBcon
    .CommandType = adCmdText
    .CommandText = Sql

    .Parameters.Append .CreateParameter("@status", adTinyint, adParamInput, 1, status)
    .Parameters.Append .CreateParameter("@note1", adVarWchar, adParamInput, 800, note1)
    .Parameters.Append .CreateParameter("@note2", adVarWchar, adParamInput, 200, note2)
    .Parameters.Append .CreateParameter("@VodUrl", adVarWchar, adParamInput, 200, VodUrl)
    .Parameters.Append .CreateParameter("@startdate", adVarchar, adParamInput, 10, startdate)
    .Parameters.Append .CreateParameter("@enddate", adVarchar, adParamInput, 10, enddate)
    .Parameters.Append .CreateParameter("@BoardSort", adInteger, adParamInput, 4, BoardSort)
    .Parameters.Append .CreateParameter("@Writer", adVarWchar, adParamInput, 20, Writer)
    .Parameters.Append .CreateParameter("@title", adVarWchar, adParamInput, 100, title)
    .Parameters.Append .CreateParameter("@content", adVarWchar, adParamInput, 2147483647, content)
    .Parameters.Append .CreateParameter("@Wip", adVarChar, adParamInput, 50, WIP)
    .Parameters.Append .CreateParameter("@imgNames", adVarWchar, adParamInput, 100, imgName(0))
    IF Sort<>"edit" Then
    .Parameters.Append .CreateParameter("@BoardIdx", adInteger, adParamInput, 4, BBsCode)
    .Parameters.Append .CreateParameter("@Topyn", adBoolean, adParamInput, 1, spaceToZero(Topyn))
    .Parameters.Append .CreateParameter("@PublicYN", adBoolean, adParamInput, 1, PublicYN)
    End IF
    .Execute,,adExecuteNoRecords
End With
Set objCmd = Nothing

Dim bIdx,MaxIdx
IF Sort="edit" Then
    bIdx=Idx

    Sql="UPDATE bbslist SET status="&status&" Where ref="&idx
    DBcon.Execute Sql
Else
    Sql="Select Max(Idx) From BBsList"
    MaxIdx=DBcon.Execute(Sql)
    bIdx=MaxIdx(0)
    
    Sql="UPDATE BBsList Set Ref="&MaxIdx(0)&",ReLevel='A' Where idx="&MaxIdx(0)
    DBcon.Execute Sql
End IF

'====================첨부파일 업로드 작업==========================================================
For i=1 To UploadForm("files").count
    IF Sort<>"edit" Then 
        IF UploadForm("files")(i)<>"" Then 
            Filenames=ImgSaves(UploadForm("files")(i),uploadform.defaultpath,30720000)
            IF Filenames=False Then Result=1

            IF Result=1 Then
                Set UploadForm=Nothing
                DBcon.Close
                Set DBcon=Nothing
                Response.Write ExecJavaAlert("업로드 허용용량(30M)을 초과하여 업로드를 실패하였습니다.",0)
                Response.End
            Else
                Sql="INSERT INTO BBSData(bidx,filenames,regdate) values("&bIdx&",'"&Filenames&"',getdate())"
                DBcon.Execute Sql
            End IF
        End IF
    Else
        IF UploadForm("filedel_idx")(i)<>"" Then
            IF UploadForm("filedel_idx")(i)<>"0" Then
                Sql="Select filenames From BBSData WHERE idx="&UploadForm("filedel_idx")(i)
                Set Rs=DBcon.Execute(Sql)
                IF Not(Rs.Bof Or Rs.Eof) Then
                    ImgDelete Rs("filenames"),UploadForm.DefaultPath
                End IF
                Set Rs=NOthing

                IF UploadForm("files")(i)="" Then
                    Sql="DELETE BBSData WHERE idx="&UploadForm("filedel_idx")(i)
                    DBcon.Execute Sql
                Else
                    filenames=ImgSaves(UploadForm("files")(i),uploadform.defaultpath,30720000)
                    IF filenames=False Then Result=1

                    IF Result=1 Then
                        Set UploadForm=Nothing
                        DBcon.Close
                        Set DBcon=Nothing
                        Response.Write ExecJavaAlert("업로드 허용용량(30M)을 초과하여 업로드를 실패하였습니다.",0)
                        Response.End
                    Else
                        Sql="Update BBSData Set filenames='"&filenames&"',regdate=getdate() Where idx="&UploadForm("filedel_idx")(i)
                        DBcon.Execute Sql
                    End IF
                End IF
            Else
                IF UploadForm("files")(i)<>"" Then 
                    filenames=ImgSaves(UploadForm("files")(i),uploadform.defaultpath,30720000)
                    IF filenames=False Then Result=1

                    IF Result=1 Then
                        Set UploadForm=Nothing
                        DBcon.Close
                        Set DBcon=Nothing
                        Response.Write ExecJavaAlert("업로드 허용용량(30M)을 초과하여 업로드를 실패하였습니다.",0)
                        Response.End
                    Else
                        Sql="INSERT INTO BBSData(bidx,filenames,regdate) values("&idx&",'"&filenames&"',getdate())"
                        DBcon.Execute Sql
                    End IF
                End IF
            End IF
        End IF
    End IF
Next
'===============================================================================================

Set Cmd=Nothing
DBcon.Close
Set DBcon=Nothing

strLocation="bbslist.asp?page="&Page&"&bbscode="&BBscode&"&sersel1="&sersel1&"&serboardsort="&serboardsort&"&search="&Search&"&searchstr="&SearchStr
Response.Write ExecJavaAlert("게시물이 "&AlertTag&"되었습니다.",2)
%>