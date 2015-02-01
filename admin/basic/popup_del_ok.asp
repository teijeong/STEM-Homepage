<!--#include virtual = common/ADdbcon.asp-->
<%
Dim Idx,Cmd,DelFileName,Result,AlertStr,UploadForm

Idx=Request("idx")

Server.ScriptTimeOut=7200
set UploadForm=server.CreateObject("DEXT.FileUpload")
uploadform.DefaultPath=Server.MapPath("/upload/Popup/")

Set Cmd=CreateCommand(DBcon,"FM_AP_PopupDel",adCmdStoredProc)
With Cmd
    .Parameters.Append CreateInputParameter("@Idx",adBigint,8,Idx)
    .Parameters.Append CreateOutputParameter("@DelFileName",adVarWchar,50)
    .Parameters.Append CreateOutputParameter("@Result",adInteger,4)
    .Execute
End With
DelFileName=Cmd.Parameters(1).Value
Result=Cmd.Parameters(2).Value

IF Result=0 Then
    IF DelFileName<>"" Then    ImgDelete DelFileName,UploadForm.DefaultPath
    AlertStr="팝업이 삭제되었습니다."
Else
    AlertStr="팝업삭제중 에러... 다시시도해주세요."
End IF

Set Cmd=Nothing
Set UploadForm=Nothing
DBcon.Close
Set DBcon=Nothing

Response.Write "<SCRIPT LANGUAGE='JavaScript'>"&Vbcrlf
Response.Write "alert('"&AlertStr&"');"&Vbcrlf
Response.Write "location.href='popup.asp';"&Vbcrlf
Response.Write "</SCRIPT>"&Vbcrlf
%>