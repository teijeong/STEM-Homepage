<!-- #include virtual = common/ADdbcon.asp -->
<%
Dim Writer,Page
Dim Idx,Title,Content,Ref,ReLevel
Dim Sql,ObjCmd,Rs,Wip,UploadForm,Result
Dim FileName(1),i
Dim BBsCode,strLocation
Dim PublicYN,Useridx,Pwd,BoardSort

WIP=Request.ServerVariables("REMOTE_ADDR")

Server.ScriptTimeOut=7200
set uploadform=server.CreateObject("DEXT.FileUpload")
uploadform.DefaultPath=Server.MapPath("/upload/board/")

sersel1=UploadForm("sersel1")
serboardsort=UploadForm("serboardsort")
Search=UploadForm("Search")
SearchStr=UploadForm("SearchStr")
BBsCode=UploadForm("bbscode")
Page=UploadForm("page")
Writer=ReplaceNoHtml(UploadForm("Writer"))
Title=ReplaceNoHtml(UploadForm("title"))
Content = Replace(UploadForm("content"),"http://"&Request.Servervariables("Server_name")&"/","/")
Idx=UploadForm("idx")
Ref=UploadForm("Ref")
ReLevel=UploadForm("ReLevel")

Call HK_BBSSetup(BBsCode)

Sql="Select Top 1 PublicYN,Useridx,Pwd,BoardSort,status FROM BBsList Where Ref="&Ref&" AND ReLevel='A'"
Set Rs=DBcon.Execute(Sql)
PublicYN=Rs(0) : Useridx=Rs(1) : Pwd=Rs(2) : BoardSort=Rs(3) : status=Rs(4)

Dim MaxReLevelRec,MaxReLevel
Sql="Select Top 1 ReLevel From BBsList Where ref="&Ref&" And ReLevel Like '"&ReLevel&"_' Order By ReLevel DESC"
Set MaxReLevelRec=DBcon.Execute(Sql)

IF MaxReLevelRec.Eof Then
	MaxReLevel = ReLevel&"A"
Else
	MaxReLevel = ReLevel&Chr(ASC(Right(MaxReLevelRec(0),1))+1)
End IF

Set MaxReLevelRec=Nothing

Sql="INSERT INTO bbsList(status,BoardSort,writer,Title,Content,wip,regdate,boardidx,useridx,pwd,ref,reLevel,submit,adwrite,PublicYN) "
Sql = Sql & "VALUES( ?, ?, ?, ?, ?, ?, Getdate() ,?,?,?,?,?,1,1,?)"

Set objCmd = Server.CreateObject("ADODB.Command")
With objCmd
	.ActiveConnection = DBcon
	.CommandType = adCmdText
	.CommandText = Sql
	
	.Parameters.Append .CreateParameter("@status", adTinyint, adParamInput, 1, spaceToZero(status))
	.Parameters.Append .CreateParameter("@BoardSort", adInteger, adParamInput, 4, BoardSort)
	.Parameters.Append .CreateParameter("@Writer", adVarWchar, adParamInput, 20, Writer)
	.Parameters.Append .CreateParameter("@title", adVarWchar, adParamInput, 100, title)
	.Parameters.Append .CreateParameter("@content", adVarWchar, adParamInput, 2147483647, content)
	.Parameters.Append .CreateParameter("@Wip", adVarChar, adParamInput, 50, WIP)
	.Parameters.Append .CreateParameter("@BoardIdx", adInteger, adParamInput, 4, BBsCode)
	.Parameters.Append .CreateParameter("@UserIdx", adBigint, adParamInput, 8, UserIdx)
	.Parameters.Append .CreateParameter("@Pwd", adVarWchar, adParamInput, 10, Pwd)
	.Parameters.Append .CreateParameter("@Ref", adBigint, adParamInput, 8, Ref)
	.Parameters.Append .CreateParameter("@ReLevel", adVarChar, adParamInput, 50, MaxReLevel)
	.Parameters.Append .CreateParameter("@PublicYN", adBoolean, adParamInput, 1, PublicYN)
	.Execute,,adExecuteNoRecords
End With
Set objCmd = Nothing

Sql="Select Max(Idx) From BBsList"
MaxIdx=DBcon.Execute(Sql)
bIdx=MaxIdx(0)

'====================첨부파일 업로드 작업==========================================================
For i=1 To UploadForm("files").count
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
Next
'===============================================================================================

Set Rs = Nothing
DBcon.Close
Set DBcon=Nothing

strLocation="bbslist.asp?page="&Page&"&bbscode="&bbsCode&"&sersel1="&sersel1&"&serboardsort="&serboardsort&"&search="&Search&"&searchstr="&SearchStr
Response.Write ExecJavaAlert("게시물이 등록 되었습니다.",2)
%>