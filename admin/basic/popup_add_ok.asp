<!--#include virtual = common/ADdbcon.asp-->
<%
Dim UploadForm,Cmd
Dim Sort,Pop_w,Pop_h,Pop_title,Content,Tag,Link_Url,Filse,StartDate,EndDate,Result,FileName,AlertStr

Server.ScriptTimeOut=7200
set uploadform=server.CreateObject("DEXT.FileUpload")
uploadform.DefaultPath=Server.MapPath("/upload/Popup/")

Sort=UploadForm("sort")
StartDate=Replace(UploadForm("SearchDate1"),"-","")
EndDate=Replace(UploadForm("SearchDate2"),"-","")
Pop_w=UploadForm("pop_w")
Pop_h=UploadForm("pop_h")
Pop_title=UploadForm("pop_title")
pTop=UploadForm("pTop")
pLeft=UploadForm("pLeft")
popSort=UploadForm("popSort")
temCode=spaceToZero(UploadForm("temCode"))

IF Sort=1 Then
    Link_Url=UploadForm("link_url")
    FileName=ImgSaves(UploadForm("files"),uploadform.defaultpath,3072000)

    IF FileName=False Then
        Set UploadForm=Nothing
        DBcon.Close
        Set DBcon=Nothing
        Response.Write ExecJavaAlert ("업로드 허용용량(3M)을 초과하여 업로드를 실패하였습니다.",0)
    End IF
Else
    Content = Replace(UploadForm("content"),"http://"&Request.Servervariables("Server_name")&"/","/")
End IF

Set Cmd=CreateCommand(DBcon,"FM_AP_PopupAdd",adCmdStoredProc)
With Cmd
    .Parameters.Append CreateInputParameter("@popSort",adTinyint,1,popSort)
    .Parameters.Append CreateInputParameter("@temCode",adTinyint,1,temCode)
    .Parameters.Append CreateInputParameter("@Sort",adInteger,4,Sort)
    .Parameters.Append CreateInputParameter("@StartDate",adChar,8,StartDate)
    .Parameters.Append CreateInputParameter("@EndDate",adChar,8,EndDate)
    .Parameters.Append CreateInputParameter("@WSize",adInteger,4,Pop_w)
    .Parameters.Append CreateInputParameter("@HSize",adInteger,4,Pop_h)
    .Parameters.Append CreateInputParameter("@Title",adVarWchar,50,Pop_Title)
    .Parameters.Append CreateInputParameter("@Content",adVarWchar,2147483647,Content)
    .Parameters.Append CreateInputParameter("@HtmlYN",adInteger,4,0)
    .Parameters.Append CreateInputParameter("@LinkUrl",adVarchar,100,Link_Url)
    .Parameters.Append CreateInputParameter("@OutPutImg",adVarWchar,50,FileName)
    .Parameters.Append CreateInputParameter("@pTop",adInteger,4,spaceToZero(pTop))
    .Parameters.Append CreateInputParameter("@pLoeft",adInteger,4,spaceToZero(pLeft))
    .Parameters.Append CreateOutputParameter("@Result",adInteger,4)
    .Execute
End With
Result=Cmd.Parameters("@Result").Value

Set Cmd=Nothing
Set UploadForm=Nothing
DBcon.Close
Set DBcon=Nothing

IF Result=0 Then
    AlertStr="팝업이 등록되었습니다."
Else
    AlertStr="등록중 에러... 다시시도해주세요."
End IF

Response.Write "<SCRIPT LANGUAGE='JavaScript'>"&Vbcrlf
Response.Write "alert('"&AlertStr&"');"&Vbcrlf
Response.Write "location.href='popup.asp';"&Vbcrlf
Response.Write "</SCRIPT>"&Vbcrlf
%>
