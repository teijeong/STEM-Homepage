<!--#include virtual = common/ADdbcon.asp-->
<%
Dim UploadForm,Cmd,Idx
Dim Sort,Pop_w,Pop_h,Pop_title,Content,Tag,Link_Url,Filse,StartDate,EndDate,Result,FileName,AlertStr,DelFileName

Server.ScriptTimeOut=7200
set UploadForm=server.CreateObject("DEXT.FileUpload")
uploadform.DefaultPath=Server.MapPath("/upload/Popup/")

Idx=UploadForm("idx")
Sort=UploadForm("sort")
StartDate=Replace(UploadForm("SearchDate1"),"-","")
EndDate=Replace(UploadForm("SearchDate2"),"-","")
Pop_w=UploadForm("pop_w")
Pop_h=UploadForm("pop_h")
Pop_title=ReplaceNoHtml(UploadForm("pop_title"))
pTop=UploadForm("pTop")
pLeft=UploadForm("pLeft")
imgDel_Chk=UploadForm("imgDel_Chk")
imgName=UploadForm("imgname")
popSort=UploadForm("popSort")
temCode=spaceToZero(UploadForm("temCode"))

IF Sort=1 Then
	Link_Url=UploadForm("link_url")

	IF imgDel_Chk<>"" And imgName<>"" Then ImgDelete imgName,UploadForm.DefaultPath

	IF imgDel_Chk<>"" Then
		IF UploadForm("files")<>"" Then 
			imgName=ImgSaves(UploadForm("files"),uploadform.defaultpath,30720000)
			IF imgName=False Then Result=1

			IF Result=1 Then
				Set UploadForm=Nothing
				DBcon.Close
				Set DBcon=Nothing
				Response.Write ExecJavaAlert("업로드 허용용량(30M)을 초과하여 업로드를 실패하였습니다.",0)
				Response.End
			End IF
		Else
			imgName=""
		End IF
	End IF
Else
	Content = Replace(UploadForm("content"),"http://"&Request.Servervariables("Server_name")&"/","/")
End IF

Set Cmd=CreateCommand(DBcon,"FM_AP_PopupEdit",adCmdStoredProc)
With Cmd
	.Parameters.Append CreateInputParameter("@Idx",adBigint,8,Idx)
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
	.Parameters.Append CreateInputParameter("@OutPutImg",adVarWchar,50,imgName)
	.Parameters.Append CreateInputParameter("@pTop",adInteger,4,spaceToZero(pTop))
	.Parameters.Append CreateInputParameter("@pLeft",adInteger,4,spaceToZero(pLeft))
	.Parameters.Append CreateOutputParameter("@Result",adInteger,4)
	.Execute
End With
Result=Cmd.Parameters("@Result").Value

IF Result=0 Then
	AlertStr="팝업이 수정되었습니다."
Else
	AlertStr="수정중 에러... 다시시도해주세요."
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
