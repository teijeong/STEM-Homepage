<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<!-- #include virtual = Library/functions.asp -->
<%
RESPONSE.EXPIRES     = 0
SERVER.SCRIPTTIMEOUT = 2000

Set UploadForm=server.CreateObject("DEXT.FileUpload")
UploadForm.DefaultPath=Server.MapPath("/upload/editorData/")

FileName=ImgSaves(UploadForm("AttachFile"),UploadForm.DefaultPath,30720000)
IF FileName=False Then
	Set UploadForm=Nothing
	Response.Write ExecJavaAlert("파일 허용용량(30M)을 초과하여 업로드를 실패하였습니다.", 3)
	Response.End
Else
	Fileext=mid(FileName,instrrev(FileName,".")+1)
	IF UCASE(fileext)="JPG" OR UCASE(fileext)="BMP" OR UCASE(fileext)="GIF" OR UCASE(fileext)="JPEG" Then
		ThumbSavesAS 120,90,Server.MapPath("/upload/editordata/"),Server.MapPath("/upload/thumeditordate/"),FileName
	End IF
End IF

Set UploadForm=Nothing

strLocation="top.location.reload();"
Response.Write ExecJavaAlert("파일이 성공적으로 업로드 되었습니다.",3)


Function ThumbSavesAS(BasicWidthSize,BasicHeightSize,Path,attPath,SourceFile)
	Dim ObjImage,imgWidth,imgHeight,WidthPer,HeightPer,SizePer,SourceFileName,ThumbPath
	Dim ThumbWidth,ThumbHeight
	set objImage =server.CreateObject("DEXT.ImageProc")

	if true = objImage.SetSourceFile(Path&"\"&SourceFile) then
		ImgUrl=Path&"\"&SourceFile
		Set MyImg = LoadPicture(Imgurl)
		imgWidth = clng(cdbl(MyImg.width)*24/635)		'실제이미지 가로사이즈
		imgHeight = clng(cdbl(MyImg.height)*24/635) 	'실제이미지 세로사이즈

		IF imgWidth<BasicWidthSize AND imgHeight<BasicHeightSize Then
			ThumbWidth=int(imgWidth)
			ThumbHeight=int(imgHeight)
		Else
			WidthPer=imgWidth/BasicWidthSize
			HeightPer=imgHeight/BasicHeightSize

			IF WidthPer>HeightPer Then
				SizePer=WidthPer
			Else
				SizePer=HeightPer
			End IF

			ThumbWidth=int(imgWidth/SizePer)
			ThumbHeight=int(imgHeight/SizePer)
		End IF

		ThumbPath = attPath&"\"& SourceFile

		objImage.SaveasThumbnail ThumbPath, ThumbWidth, ThumbHeight, false
		ThumbSavesAS=SourceFile
	end if
	set objImage = nothing
End Function
%>