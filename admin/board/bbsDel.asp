<!-- #include virtual = common/ADdbcon.asp -->
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<%
Dim Sql,UploadForm,strLocation,Rs
Dim Page,Idx,BBsCode
Dim imgnames,Ref,ReLevel
Dim serboardsort,Search,SearchStr

Page=Request("page")
BBsCode=Request("bbscode")
sersel1=Request("sersel1")
serboardsort=Request("serboardsort")
Search=Request("Search")
SearchStr=Request("SearchStr")
delsort=Request("delsort")
Call HK_BBSSetup(BBsCode)

Server.ScriptTimeOut=7200
set UploadForm=server.CreateObject("DEXT.FileUpload")
uploadform.DefaultPath=Server.MapPath("/upload/board/")

IF Request("delSort")="group" Then
	idx=Request("chkidx")
Else
	idx=Request("idx")
End IF

IDX=Split(idx,", ")

For i=0 To Ubound(IDX)
	Sql="SELECT Ref,ReLevel FROM BBsList WHERE idx="&Idx(i)
	Set Rs=DBcon.Execute(Sql)
	IF Not(Rs.Bof OR Rs.Eof) Then
		Ref=Rs("Ref") : ReLevel=Rs("ReLevel")

		Sql="SELECT idx,imgnames From BBsList Where Ref="&Ref&" And ReLevel Like '"&ReLevel&"%'"
		SET Rs=DBcon.Execute(Sql)

		IF Not(Rs.Bof Or Rs.Eof) Then
			Do Until Rs.Eof
				imgnames=Rs("imgnames")
				IF imgnames<>"" Then
					ImgDelete imgnames,UploadForm.DefaultPath
					ImgDelete getImageThumbFilename(imgnames),UploadForm.DefaultPath
				End IF

				Sql="SELECT filenames FROM BBSData WHERE bidx="&Rs("idx")
				Set FileRs=DBcon.Execute(Sql)
				IF Not(FileRs.Bof Or FileRs.Eof) Then
					Do Until FileRs.Eof
						If FileRs("filenames")<>""  Then ImgDelete FileRs("filenames"),UploadForm.DefaultPath
						FileRs.MoveNext()
					Loop
				End IF
				Sql="DELETE BBSData WHERE bidx="&Rs("idx")
				DBcon.Execute Sql
				
				Rs.MoveNext()
			Loop
		End IF

		Sql="Delete BBsList Where Ref="&Ref&" And ReLevel Like '"&ReLevel&"%'"
		DBcon.Execute Sql
	End IF
Next



Set UploadForm=Nothing
DBcon.Close
Set DBcon=Nothing

strLocation="bbslist.asp?page="&Page&"&bbscode="&bbsCode&"&sersel1="&sersel1&"&serboardsort="&serboardsort&"&search="&Search&"&searchstr="&SearchStr
Response.Write ExecJavaAlert("선택하신 게시물이 삭제되었습니다.",2)
%>