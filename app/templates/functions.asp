<%
Function checkParameter(chartype,str)
    IF chartype="int" AND str<>"" Then
        IF IsNumeric(str) Then
            checkParameter=Str
        Else
            Response.Write ExecJavaAlert("잘못된 접근입니다\n이전페이지로 이동합니다.",0)
            Response.End
        End IF
    Else
        checkParameter=Str
    End IF
End Function

Function ChangeWeekDay(Str)
    IF CStr(Str)="1" Then
        ChangeWeekDay="일"
    ElseIF CStr(Str)="2" Then
        ChangeWeekDay="월"
    ElseIF CStr(Str)="3" Then
        ChangeWeekDay="화"
    ElseIF CStr(Str)="4" Then
        ChangeWeekDay="수"
    ElseIF CStr(Str)="5" Then
        ChangeWeekDay="목"
    ElseIF CStr(Str)="6" Then
        ChangeWeekDay="금"
    ElseIF CStr(Str)="7" Then
        ChangeWeekDay="토"
    End IF
End Function

Function ChangeValueBasicStr(Str)
    IF CStr(Str)="" Then
        ChangeValueBasicStr="<span style='color: #B3B3B3;'>미입력</span>"
    Else
        ChangeValueBasicStr="<span style='color: #B50000;'>"&Str&"</span>"
    End IF
End Function

Function ChangeConsultStatus(Str)
    IF CStr(Str)="0" Then
        ChangeConsultStatus="<span style='color: #B50000'>상담대기</span>"
    ElseIF CStr(Str)="1" Then
        ChangeConsultStatus="<span style='color: #3D3D3D'>상담완료</span>"
    End IF
End Function

Function ChangeAdminCalendarStr(Str)
    Str=Replace(Str,"|d","<div style='padding-top:4px; font-size:11px;'>")
    Str=Replace(Str,"d|","</div>")
    ChangeAdminCalendarStr=Str
End Function

Function ChangeCalendarStr(Str)
    Str=Replace(Str,"_a","·<a href=""javascript:$lb.launch({ url: '/sub/sub5_2View.asp?idx=")
    Str=Replace(Str,""">","', options: 'width:700 height:550'});"">")

    Str=Replace(Str,"a_","</a>")
    Str=Replace(Str,"|","</br>")
    ChangeCalendarStr=Str
End Function

Function Changebbs_status(Str)
    IF CStr(Str)="0" Then
        Changebbs_status="<span style='color: red;'>마감</span>"
    ElseIF CStr(Str)="1" Then
        Changebbs_status="<span style='color: blue;'>채용중</span>"
    ElseIF CStr(Str)="2" Then
        Changebbs_status="<span style='color: black;'>완료</span>"
    End IF
End Function

Function Changebbs_statusIMG(Str)
    IF CStr(Str)="0" Then
        Changebbs_statusIMG="<img src='/images/ico_end.gif'>"
    ElseIF CStr(Str)="1" Then
        Changebbs_statusIMG="<img src='/images/ico_ing.gif'>"
    ElseIF CStr(Str)="2" Then
        Changebbs_statusIMG="<img src='/images/ico_end.gif'>"
    End IF
End Function

Function Changebbs_statusIMGMain(Str)
    IF CStr(Str)="0" Then
        Changebbs_statusIMGMain="<img src='/images/est_yet.gif'>"
    ElseIF CStr(Str)="1" Then
        Changebbs_statusIMGMain="<img src='/images/est_ing.gif'>"
    ElseIF CStr(Str)="2" Then
        Changebbs_statusIMGMain="<img src='/images/est_end.gif'>"
    End IF
End Function

Function Get_ConsultName(Str)
    tmpStr="OOOOOOOOOOOOOOOOOOOOOOOO"
    IF Len(Str)>0 Then
        Get_ConsultName=Left(Str,2)& MID(tmpStr,1,Len(Str)-2)
    Else
        Get_ConsultName="OOO"
    End IF
End Function

Function ChangeMemSort(Str)
    IF CStr(Str)="0" Then
        ChangeMemSort="일반회원"
    ElseIF CStr(Str)="1" Then
        ChangeMemSort="전문가회원"
    End IF
End Function
' ***************************************************************************************
' * 함수설명 : 게시판 코드에 따른 이미지 및 맵
' ***************************************************************************************
Function ChangeAdminBoardTitle(Str)
    IF Str=1 Then
        ChangeAdminBoardTitle="NOTICE"
    ElseIF Str=2 Then
        ChangeAdminBoardTitle="QnA"
    ElseIF Str=3 Then
        ChangeAdminBoardTitle="Scholarship"
    ElseIF Str=4 Then
        ChangeAdminBoardTitle="Service"
    ElseIF Str=5 Then
        ChangeAdminBoardTitle="Exchange"
    ElseIF Str=6 Then
        ChangeAdminBoardTitle="Leadership"
    End IF
End Function

' ***************************************************************************************
' * 함수설명 : 원화로 변환
' ***************************************************************************************
Function ChangeWon(Str)
    IF IsNumerIc(Str) Then
        ChangeWon="\ "&FormatNumber(Str,0)
    Else
        ChangeWon=Str
    End IF
End Function

' ***************************************************************************************
' * 함수설명 : 게시물 확인여부 변환
' ***************************************************************************************
Function ChangeCheckedInStr(val1,val2)
    IF INSTR(val1,val2)=0 Then
        ChangeCheckedInStr=""
    Else
        ChangeCheckedInStr="checked"
    End IF
End Function

Function ChangeCheckedYN(Str)
    IF Str=0 Or lcase(Str)=false Then
        ChangeCheckedYN=""
    Else
        ChangeCheckedYN="checked"
    End IF
End Function
Function ChangeChecked(val1,val2)
    IF CStr(val1)=CStr(val2) Then
        ChangeChecked="checked"
    Else
        ChangeChecked=""
    End IF
End Function

' ***************************************************************************************
' * 함수설명 : 선택폼 체크
' ***************************************************************************************
Function SelCheck(val1,val2)
    IF CStr(val1)=CStr(val2) Then
        SelCheck="selected"
    Else
        SelCheck=""
    End IF
End Function

' ***************************************************************************************
' * 함수설명 : 게시물 확인여부 변환
' ***************************************************************************************
Function ChangeSubmitYN(Str)
    IF Str=0 Or Str=false Then
        ChangeSubmitYN="X"
    Else
        ChangeSubmitYN="O"
    End IF
End Function

' ***************************************************************************************
' * 함수설명 : Text 문자열 변환함수
' * 변수설명 : str : 변환할 변수 값
' * 사용범위 : 프로시져 사용안할시(DB저장전)
' ***************************************************************************************
Function Replaceensine(Str)
    IF IsNull(Str) = False Then
        Str=Replace(Str,"'","''")
        Replaceensine = Str
    End IF
End Function

' ***************************************************************************************
' * 함수설명 : Text 문자열 변환함수
' * 변수설명 : str : 변환할 변수 값
' * 사용범위 : 태그허용안하는 변수에 사용(DB저장전)
' ***************************************************************************************
Function ReplaceNoHtml(Str)
    IF IsNull(Str) = False Then
        Str=Replace(Str,"&","&amp;")
        Str=Replace(Str,"<","&lt;")
        Str=Replace(Str,">","&gt;")
        ReplaceNoHtml = Str
    End IF
End Function

Function deReplaceNoHtml(Str)
    IF IsNull(Str) = False Then
        Str=Replace(Str,"&gt;",">")
        Str=Replace(Str,"&lt;","<")
        Str=Replace(Str,"&amp;","&")
        deReplaceNoHtml = Str
    End IF
End Function

' ***************************************************************************************
' * 함수설명 : Text 문자열 변환함수
' * 변수설명 : str : 변환할 변수 값
' * 사용범위 : 문자를 자바스크립트 변수로 사용될 경우
' ***************************************************************************************
Function ReplaceJScript(Str)
    IF IsNull(Str) = False Then
        Str=Replace(Str,"'","\'")
        Str=Replace(Str,CHR(34),"\""")
        str = REPLACE(str,CHR(13) & CHR(10),"\r")
        ReplaceJScript = Str
    End IF
End Function

' ***************************************************************************************
' * 함수설명 : Text 문자열 변환함수
' * 변수설명 : str : 변환할 변수 값
' * 사용범위 : 문자를 value값으로 받는 모는 TextField
' ***************************************************************************************
Function ReplaceTextField(Str)
    IF IsNull(Str) = False Then
        Str=Replace(Str,"'","&#39;")
        Str=Replace(Str,CHR(34),"&quot;")
        ReplaceTextField = Str
    End IF
End Function

' ***************************************************************************************
' * 함수설명 : HTML BR 태그 변환 함수
' * 변수설명 : str : 변환할 변수 값
' ***************************************************************************************
FUNCTION ReplaceBr(str)
    IF ISNULL(str) = False THEN
        str = REPLACE(str,CHR(13) & CHR(10),"<BR />")
        str = REPLACE(str,CHR(10),"<BR />")
        ReplaceBr = str
    END IF
End Function

' ***************************************************************************************
' * 함수설명 : 배열형태의 폼 전송시 Request
' * 변수설명 : frm -> 전송폼네임
' ***************************************************************************************
Function FormArrayRequest(frm)
    Dim RequestStr,i
    For i=1 To frm.Count
        RequestStr=RequestStr&frm(i)&"|"
    Next
    FormArrayRequest=RequestStr
End Function

' ***************************************************************************************
' * 함수설명 : 글번호 출력
' ***************************************************************************************
Function GetTextNum(Page,Pagesize)
    IF Page=1 Then
        GetTextNum=1
    Else
        GetTextNum=Page*Pagesize-(Pagesize-1)
    End IF
End Function

Function GetTextNumDesc(Page,Pagesize,Record_Cnt)
    If page=1 then
        GetTextNumDesc=Record_Cnt
    Else
        GetTextNumDesc=Record_Cnt-(Page-1)*PageSize
    End if
End Function

' ***************************************************************************************
' * 함수설명 : 페이지 변환
' ***************************************************************************************
Function GetPage()
    IF Request("Page")="" then
        GetPage=1
    Else
        IF IsNumeric(Request("Page")) Then
            GetPage=Request("Page")
        Else
            GetPage=1
        End IF
    END IF
End Function

' ***************************************************************************************
' * 함수설명 : 문자열변환
' ***************************************************************************************
Function AddZero(Str)
    IF len(Str)=1 Then
        AddZero="0"&Str
    Else
        AddZero=Str
    End IF
End Function

Function ChangeNull(Str)
    IF Str="" Then
        ChangeNull=null
    Else
        ChangeNull=Str
    End IF
End Function

Function ChangeStrNull(Str)
    IF Str="" Or IsNull(Str) Then
        ChangeStrNull="null"
    Else
        ChangeStrNull=Str
    End IF
End Function

' ***************************************************************************************
' * 함수설명 : 공백 -> 0
' ***************************************************************************************
Function spaceToZero(Str)
    IF Str="" Then
        spaceToZero=0
    Else
        spaceToZero=str
    End IF
End Function

Function BitToNumber(Str)
    IF Str=False Then
        BitToNumber=0
    Else
        BitToNumber=1
    End IF
End Function

' ***************************************************************************************
' * 함수설명 : 문자열 길이 만큼 자르기
' * 변수설명 : Str = 변형할문자열 , strLen = 문자열수
' ***************************************************************************************
Function getString(str, strlen)
    Dim rValue,nLength,f,tmpStr,tmpLen
    nLength = 0.00
    rValue = ""

    For f = 1 To Len(Str)
        tmpStr = MID(str,f,1)
        tmpLen = ASC(tmpStr)
        IF  (tmpLen < 0) Then
            ' 한글
            nLength = nLength + 1.4        '한글일때 길이값 설정
            rValue = rValue & tmpStr
        Elseif (tmpLen >= 97 And tmpLen <= 122) Then
            ' 영문 소문자
            nLength = nLength + 0.75       '영문소문자 길이값 설정
            rValue = rValue & tmpStr
        Elseif (tmpLen >= 65 And tmpLen <= 90) Then
            ' 영문 대문자
            nLength = nLength + 1           ' 영문대문자 길이값 설정
            rValue = rValue & tmpStr
        Else
            ' 그외 키값
            nLength = nLength + 1.7         '특수문자 기호값...
            rValue = rValue & tmpStr
        End IF

        IF (nLength > strlen) Then
            rValue = rValue & ".."
            Exit For
        End if
    Next
    getString = rValue
End Function

' ***************************************************************************************
' * 함수설명 : 로그인처리에 따른 액션출력
' * 변수설명 : Url  =  로그인시 이동할 Page
' ***************************************************************************************
Function LoginCheck(Url,ReturnUrl)
    IF Session("useridx")="" Then
        LoginCheck="javascript:login('"&ReturnUrl&"');"
    Else
        LoginCheck=Url
    End IF
End Function

Function LoginMemsortCheck(Url,ReturnUrl,MemYN)
    IF Session("useridx")="" Then
        LoginMemsortCheck="javascript:login('"&ReturnUrl&"');"
    ElseIF CStr(Session("Membership"))<MemYN Then
        LoginMemsortCheck="javascript:alert('인트라넷회원 이상 작성 가능합니다.');"
    Else
        LoginMemsortCheck=Url
    End IF
End Function

Function LoginCheckonclick(Url,returnUrl)
    IF Session("useridx")="" Then
        LoginCheckonclick="login('"&returnUrl&"');"
    Else
        LoginCheckonclick=Url
    End IF
End Function

Function LoginCk()
    IF Sign_Idx="" Then
        Response.Write "<SCRIPT LANGUAGE='JavaScript'>"&Vbcrlf
        Response.Write "alert('로그인이 필요한 서비스페이지 입니다.\n로그인후 다시 시도해주세요.')"&Vbcrlf
        Response.Write "history.back();"&Vbcrlf
        Response.Write "</SCRIPT>"&Vbcrlf
        Response.end
    End IF
End Function

Function ADLoginCk()
    IF Request.cookies("acountcode") = "" Then
        Response.Redirect "/admin/login.htm"
        Response.End
    End IF
End Function

' ***************************************************************************************
' * 함수설명 : 자바스크립트 메시지 출력
' * 변수설명 : strMsg  = 출력메시지
' *            strExec = 스크립트 처리 (0:이전화면 / 1:창닫기 / 2:지정한URL / 3:스크립트)
' ***************************************************************************************
FUNCTION ExecJavaAlertgoHref(strMsg,goPage)
    DIM str
    str = "<script language=javascript>" & vbcrlf
    IF strMsg<>"" THEN str = str & "alert('" & strMsg & "');" & vbcrlf
    str = str & "location.href='"&goPage&"';" &vbcrlf
    ExecJavaAlertgoHref = str & "</script>" & vbcrlf
END Function

FUNCTION ExecJavaAlert(strMsg,strExec)
    DIM str
    str = "<script language=javascript>" & vbcrlf
    IF strMsg<>"" THEN str = str & "alert('" & strMsg & "');" & vbcrlf
    IF strExec = "0" THEN
        str = str & "history.back();" & vbcrlf
    ELSEIF strExec = "1" THEN
        str = str & "self.close();" & vbcrlf
    ELSEIF strExec = "2" THEN
        str = str & "location.href='"&strLocation&"';" &vbcrlf
    ELSEIF strExec = "3" THEN
        str = str & strLocation  &vbcrlf
    End IF
    ExecJavaAlert = str & "</script>" & vbcrlf
END FUNCTION

' ***************************************************************************************
' * 함수설명 : IMAGE Width Size 출력
' ***************************************************************************************
Function ImgSize(Path,MaxWidthSize,FileName)
    Dim ImgUrl,MyImg,Width

    ImgUrl=Server.MapPath("\upload\"&Path&"\")&"\"&FileName

    On Error Resume Next
    Set MyImg = LoadPicture(Imgurl)
    Width = Round(MyImg.Width / 26.4583)
    Set MyImg=Nothing

    IF Width>MaxWidthSize Then
        ImgSize=MaxWidthSize
    Else
        ImgSize=Width
    End IF
End Function

Function ImgPerSize(Path,MaxWidthSize,MaxHeightSize,FileName)
    Dim ImgUrl,MyImg,Width,Height,xo,yo,Rate

    Rate = 1
    ImgUrl=Server.MapPath("\upload\"&Path&"\")&"\"&FileName

    On Error Resume Next
    Set MyImg = LoadPicture(Imgurl)
    xo = clng(cdbl(MyImg.width)*24/635)
    yo = clng(cdbl(MyImg.height)*24/635) 

    if xo > MaxWidthSize Then Rate = (MaxWidthSize / xo)
    if yo * Rate > MaxHeightSize Then Rate = (MaxHeightSize / yo)
    Set MyImg = nothing

    ImgPerSize = " width='" & Cint(xo * rate) & "' height='" & Cint(yo * rate) & "'"
End Function

Function ImgPerSize1(Path,MaxWidthSize,MaxHeightSize,FileName)
    Dim ImgUrl,MyImg,Width,Height,xo,yo,Rate

    Rate = 1
    ImgUrl=Server.MapPath("\upload\"&Path&"\")&"\"&FileName

    On Error Resume Next
    Set MyImg = LoadPicture(Imgurl)
    xo = clng(cdbl(MyImg.width)*24/635)
    yo = clng(cdbl(MyImg.height)*24/635) 

    if xo > MaxWidthSize Then Rate = (MaxWidthSize / xo)
    if yo * Rate > MaxHeightSize Then Rate = (MaxHeightSize / yo)
    Set MyImg = nothing

    imgWidth=Cint(xo * rate)
    imgHeight=Cint(yo * rate)
End Function

Function ImgPerSizeType1(Path,MaxWidthSize,MaxHeightSize,FileName)
    Dim ImgUrl,MyImg,Width,Height,xo,yo,Rate

    Rate = 1
    ImgUrl=Server.MapPath("\upload\"&Path&"\")&"\"&FileName

    On Error Resume Next
    Set MyImg = LoadPicture(Imgurl)
    xo = clng(cdbl(MyImg.width)*24/635)
    yo = clng(cdbl(MyImg.height)*24/635) 

    if xo > MaxWidthSize Then Rate = (MaxWidthSize / xo)
    if yo * Rate > MaxHeightSize Then Rate = (MaxHeightSize / yo)
    Set MyImg = nothing

    ImgPerSizeType1 = Cint(xo * rate) & "," & Cint(yo * rate)
End Function

Function getImageThumbFilename(str)
    Dim ThumbFileName,ThumbFileExt
    ThumbFileName=left(str,instrrev(str,".")-1)
    ThumbFileExt=mid(str,instrrev(str,"."))

    getImageThumbFilename=ThumbFileName & "_thumbs"&ThumbFileExt
End Function

' ***************************************************************************************
' * 함수설명 : DextUpload ThumbNail 이미지 Save
' ***************************************************************************************
Function ThumbSaves(BasicWidthSize,BasicHeightSize,FormName,Path,SourceFile,changeName)
    Dim ObjImage,imgWidth,imgHeight,WidthPer,HeightPer,SizePer,SourceFileName,ThumbPath
    Dim ThumbWidth,ThumbHeight
    set objImage =server.CreateObject("DEXT.ImageProc")

    objImage.Quality=100

    if true = objImage.SetSourceFile(Path&"\"&SourceFile) then
        imgWidth = FormName.ImageWidth        '실제이미지 가로사이즈
        imgHeight = FormName.ImageHeight    '실제이미지 세로사이즈

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

        SourceFileName=left(SourceFile,instrrev(SourceFile,".")-1)
        SourceFileExt=mid(SourceFile,instrrev(SourceFile,"."))
        ThumbPath = Path&"\"& SourceFileName & "_"&changeName&SourceFileExt

        objImage.SaveasThumbnail ThumbPath, ThumbWidth, ThumbHeight, false
        ThumbSaves=SourceFileName & "_"&changeName&SourceFileExt
    end if
    set objImage = nothing
End Function

' ***************************************************************************************
' * 함수설명 : DextUpload waterMark 이미지 Save
' ***************************************************************************************
Function WaterMarkSaves(path,SourceFile)
    Dim objImage,SourceFileName,FilePath
    set objImage =server.CreateObject("DEXT.ImageProc")

    if true = objImage.SetSourceFile(Path&"\"&SourceFile) then
        SourceFileName=left(SourceFile,instrrev(SourceFile,".")-1)

        FilePath = Path&"\"&SourceFileName&"_WM.jpg"
        objImage.SaveAsWatermarkImage "/Images/marker/logo.gif",FilePath,-10,-10,false
    end if

    ImgDelete SourceFile,path

    WaterMarkSaves=SourceFileName&"_WM.jpg"
    Set ObjImage=Nothing
End Function

' ***************************************************************************************
' * 함수설명 : DextUpload Image Save
' * 변수설명 : FormName -> 업로드폼네임 , Path -> 업로드경로 , PermissionSize ->허용용량
' ***************************************************************************************
Function ImgSaves(FormName,Path,PermissionSize)
    Dim FileName,FilePath,Filenameonly,Fileext,i

    IF PermissionSize<>"" Then
        IF Int(PermissionSize) < Int(FormName.FileLen) Then
            ImgSaves=False
            Exit Function
        End IF
    End If
    
    filename=Replace(FormName.filename," ","_")

    if instrrev(filename,".") <> 0 then
        filenameonly=left(filename,instrrev(filename,".")-1)
        fileext=mid(filename,instrrev(filename,"."))
    else
        filenameonly=filename
        fileext=""
    end if

    'filenameonly = Mid(Fileext,2)&Right(Replace(Date(),"-",""),6)&Right(Session.sessionID,2)

    FileName=Replace(filenameonly,"|","") & Fileext
    filepath=Path & "\" & FileName
    FolderMake(Path)

    if uploadform.fileexists(filepath) then
        i=0
        Do while(1)
            filepath=Path & "\" & filenameonly & i & fileext
            filename=filenameonly & i & fileext
            if not uploadform.fileexists(filepath) then exit do
            i=i+1
        Loop
    end if
    FormName.saveas filepath
    ImgSaves=Filename
End Function

' ***************************************************************************************
' * 함수설명 : DextUpload Image Delete
' * 변수설명 : FormName -> 업로드폼네임 , Path -> 업로드경로
' ***************************************************************************************
Function ImgDelete(FileName,Path)
    Dim FilePath
    FilePath=Path & "/" & FileName
    UploadForm.DeleteFile FilePath
End Function

' ***************************************************************************************
' * 함수설명 : 폴더 생성
' * 변수설명 : strPath = 생성할 폴더 경로 및 폴더명
' ***************************************************************************************
FUNCTION FolderMake(strPath)
    DIM FSO
    SET FSO = CreateObject("Scripting.FileSystemObject")
    IF NOT(fso.FolderExists(strPath)) THEN
        Fso.CreateFolder(strPath)
    END IF
    SET FSO = NOTHING
End Function

' ***************************************************************************************
' * 함수설명 : 다운로드태그변환
' ***************************************************************************************
Function DownloadTag(str,path)
    IF Not(Str="" Or IsNull(Str) Or IsEmpty(Str)) Then
        DownLoadTag="<a href='/common/download.asp?downfile="&str&"&path="&Path&"'>"&Str&"</a>"
    End IF
End Function

Function DownloadTagEN(str,path)
    IF Str="" Or IsNull(Str) Or IsEmpty(Str) Then
        DownloadTagEN="No AddFile!!!."
    Else
        DownloadTagEN="<a href='/common/download.asp?downfile="&str&"&path="&Path&"'>"&Str&"</a>"
    End IF
End Function

Function pubDownloadTag(str,path,downmode,memberShip)
    IF MemberShip="" Then MemberShip=-1
    IF Not(Str="" Or IsNull(Str) Or IsEmpty(Str)) Then

        IF downmode<>"" Then
            IF CStr(downMode)>CStr(MemberShip) Then
                pubDownloadTag="<a href='#jLink' onclick=""alert('다운로드 권한이 없습니다.\n고객센터에 문의 바랍니다.')"">"&Str&"</a>"
            Else
                pubDownloadTag="<a href='/common/download.asp?downfile="&str&"&path="&Path&"'>"&Str&"</a>"
            End IF
        Else
            pubDownloadTag="<a href='/common/download.asp?downfile="&str&"&path="&Path&"'>"&Str&"</a>"
        End IF
    End IF
End Function

Function pubDownloadImgTag(str,path,downmode,memberShip)
    IF Not(Str="" Or IsNull(Str) Or IsEmpty(Str)) Then
        IF downMode>SpaceToZero(MemberShip) Then
            pubDownloadImgTag="<a href='#jLink' onclick=""alert('수강생 등급 이상 회원만 다운로드 가능합니다.')""><img src='/images/ico_down.png' border='0' align='absmiddle'></a>"
        Else
            pubDownloadImgTag="<a href='/common/download.asp?downfile="&str&"&path="&Path&"'><img src='/images/ico_down.png' border='0' align='absmiddle'></a>"
        End IF
    End IF
End Function

' ***************************************************************************************
' * 함수설명 : Shop 페이징 네비게이션 출력
' * 변수설명 : linkpage  = 이동페이지
' *           str = 겟방식 전송값
' ***************************************************************************************
Function PT_SpPageLink(linkpage,str,ajaxYN)
    Dim BlockPage,i
    Response.Write "<table width='' border='0' align='center' cellpadding='0' cellspacing='0'>" &vbcrlf
    Response.Write "<tr><td align='center' style='font-size:11px; padding:0;'>" &vbcrlf

    blockpage=int((page-1)/10)*10+1

    IF Page<>1 Then
        IF ajaxYN="" Then
            Response.Write "<a href='"&linkpage&"?page=1&"&str&"'><img src='/images/btn_icon1.gif' alt='맨앞으로' border='0' align='absmiddle' /></a>"&Vbcrlf
        Else
            Response.Write "<a href=""javascript:"&linkpage&"("&str&",1)""><img src='/images/btn_icon1.gif' alt='맨앞으로' border='0' align='absmiddle' /></a>"&Vbcrlf
        End IF
    Else
        Response.Write "<img src='/images/btn_icon1.gif' alt='맨앞으로' border='0' align='absmiddle'>"&Vbcrlf
    End IF

    IF Int(page)>1 Then
        IF ajaxYN="" Then
            Response.Write "<a href='"&linkpage&"?page="&page-1&"&"&str&"'><img src='/images/btn_icon2.gif' alt='이전' border='0' align='absmiddle' /></a> "
        Else
            Response.Write "<a href=""javascript:"&linkpage&"("&str&",'"&page-1&"')""><img src='/images/btn_icon2.gif' alt='이전' border='0' align='absmiddle' /></a> "
        End IF
    Else
        Response.Write "<img src='/images/btn_icon2.gif' alt='이전' border='0' align='absmiddle'> "
    End IF

    i=1
    do until i>10 or blockpage > totalpage
        If blockpage=int(page) then
            Response.Write "| <b>"&blockpage&"</b>"&vbcrlf
        Else
            IF ajaxYN="" Then
                Response.Write "| <a href='"&linkpage&"?page="&blockpage&"&"&str&"'>"&blockpage&"</a>"&vbcrlf
            Else
                Response.Write "| <a href=""javascript:"&linkpage&"("&str&",'"&blockpage&"')"">"&blockpage&"</a>"&vbcrlf
            End IF
        End If
        blockpage = blockpage+1
        i=i+1
    loop

    IF Int(page)<Int(totalpage) Then
        IF ajaxYN="" Then
            Response.Write "| <a href='"&linkpage&"?page="&page+1 &"&"&str&"'><img src='/images/btn_icon3.gif' alt='다음' border='0' align='absmiddle' /></a>"&Vbcrlf
        Else
            Response.Write "| <a href=""javascript:"&linkpage&"("&str&",'"&page+1&"')""><img src='/images/btn_icon3.gif' alt='다음' border='0' align='absmiddle' /></a>"&Vbcrlf
        End IF
    Else
        Response.Write "| <img src='/images/btn_icon3.gif' alt='다음' border='0' align='absmiddle'>"&Vbcrlf
    End IF

    IF Cint(page)<totalpage Then
        IF ajaxYN="" Then
            Response.Write "<a href='"&linkpage&"?page="&TotalPage &"&"&str&"'><img src='/images/btn_icon4.gif' alt='맨끝으로' border='0' align='absmiddle' /></a>"&Vbcrlf
        Else
            Response.Write "<a href=""javascript:"&linkpage&"("&str&",'"&TotalPage&"')""><img src='/images/btn_icon4.gif' alt='맨끝으로' border='0' align='absmiddle' /></a>"&Vbcrlf
        End IF
    Else
        Response.Write "<img src='/images/btn_icon4.gif' alt='맨끝으로' border='0' align='absmiddle'>"&Vbcrlf
    End IF
    Response.Write "</td></tr></table>"&vbcrlf
End Function

' ***************************************************************************************
' * 함수설명 : 페이징 네비게이션 출력
' * 변수설명 : linkpage  = 이동페이지
' *           str = 겟방식 전송값
' ***************************************************************************************
Function PT_PageLink(linkpage,str)
    Dim BlockPage,i
    Response.Write "<table border='0' cellpadding='0' cellspacing='0' class='submenu'>" &vbcrlf
    Response.Write "<tr><td height='25' align='center' valign='middle'>" &vbcrlf

    blockpage=int((page-1)/10)*10+1
    if blockpage<>1 then
        Response.Write "<a href='"&linkpage&"?page=1&"&str&"'>[1]</a>" &vbcrlf
        Response.Write "<a href='"&linkpage&"?page="&blockpage-10&"&"&str&"'>[이전 10 페이지]</a>"&vbcrlf
    End If

    i=1
    do until i>10 or blockpage > totalpage
        If blockpage=int(page) then
            Response.Write "<b>[<font color=red>"&blockpage&"</font>]</b>"&vbcrlf
        Else
            Response.Write "<a href='"&linkpage&"?page="&blockpage&"&"&str&"'>["&blockpage&"]</a>"&vbcrlf
        End If
        blockpage = blockpage+1
        i=i+1
    loop
    If blockpage > totalpage Then
    Else
        Response.Write "<a href='"&linkpage&"?page="&blockpage&"&"&str&"'>[다음 10 페이지]"&vbcrlf
        Response.Write "<a href='"&linkpage&"?page="&totalpage&"&"&str&"'>["&totalpage&"]"&vbcrlf
    End if
    Response.Write "</td></tr></table>"&vbcrlf
End Function

' ***************************************************************************************
' * 함수설명 : 카테고리 selectbox 셋팅
' ***************************************************************************************
Function PT_CateScript()
    Dim i,depth1,Depth2,Depth3,PreCaCode
    Response.Write "<SCRIPT LANGUAGE='JavaScript'>"&Vbcrlf
    Response.Write "depth1 = new Array();"&Vbcrlf
    Response.Write "depth1_value = new Array();"&Vbcrlf
    Response.Write "depth2 = new Array();"&Vbcrlf
    Response.Write "depth2_value =  new Array();"&Vbcrlf
    Response.Write "depth3 = new Array();"&Vbcrlf
    Response.Write "depth3_value =  new Array();"&Vbcrlf

    IF IsArray(Allrec) Then
        Depth1=-1 : Depth2=0 : Depth3=0 : PreCaCode=""
        For i=0 To Ubound(Allrec,2)
            IF Allrec(2,i)=Allrec(3,i) Then
                Depth1=Depth1+1
                Response.Write "depth1["&Depth1&"]='"&ReplaceJScript(Allrec(0,i))&"';"&Vbcrlf
                Response.Write "depth1_value["&Depth1&"]="&Allrec(1,i)&";"&Vbcrlf
                Response.Write "depth2["&Depth1&"] = new Array();"&Vbcrlf
                Response.Write "depth2_value["&Depth1&"] = new Array();"&Vbcrlf
                Response.Write "depth3["&Depth1&"] = new Array();"&Vbcrlf
                Response.Write "depth3_value["&Depth1&"] = new Array();"&Vbcrlf
                Depth2=0
            Elseif Allrec(1,i)=Allrec(2,i) Then
                Response.Write "depth2["&Depth1&"]["&Depth2&"]='"&ReplaceJScript(Allrec(0,i))&"';"&Vbcrlf
                Response.Write "depth2_value["&Depth1&"]["&Depth2&"]="&Allrec(1,i)&";"&Vbcrlf
                Response.Write "depth3["&Depth1&"]["&Depth2&"] = new Array();"&Vbcrlf
                Response.Write "depth3_value["&Depth1&"]["&Depth2&"] = new Array();"&Vbcrlf
                Depth2=Depth2+1
                Depth3=0
            Else
                Response.Write "depth3["&Depth1&"]["&Depth2-1&"]["&Depth3&"]='"&ReplaceJScript(Allrec(0,i))&"';"&Vbcrlf
                Response.Write "depth3_value["&Depth1&"]["&Depth2-1&"]["&Depth3&"]="&Allrec(1,i)&";"&Vbcrlf
                Depth3=Depth3+1
            End IF
        Next
    End IF
    Response.Write "</SCRIPT>"&Vbcrlf
End Function

' ***************************************************************************************
' * 함수설명 : 카운터 Date체크함수
' ***************************************************************************************
Function DateRight(sDate)
    Dim Yy,Mm
    Yy = Mid(sDate,1,4)
    Mm = Mid(sDate,6,2)

    if (Mm = "01") or (Mm = "03") or (Mm = "05") or (Mm = "07") or (Mm = "08") or (Mm = "10") or (Mm = "12") then
        DateRight = Yy & "-" & Mm & "-" & "31"
        Exit Function
    End if

    if (Mm = "04") or (Mm = "06") or (Mm = "09") or (Mm = "11") then
        DateRight = Yy & "-" & Mm & "-" & "30"
        Exit Function
    End if

    if Mm = "02" then
        if DateCheck(Yy & "-" & Mm & "-" & "29") then
            DateRight = Yy & "-" & Mm & "-" & "29"
        ELSE
            DateRight = Yy & "-" & Mm & "-" & "28"
        End if

        Exit Function

    End if
End Function
Function DateCheck(sDate)
    '길이검사
    if Len(sDate) <> 10 then 
        DateCheck = False
        Exit Function
    End if

    '월검사
    if ((Mid(sDate,6,2) < "01") or (Mid(sDate,6,2) > "12")) then 
        DateCheck = False 
        Exit Function
    End if

    '일검사
    if ((Mid(sDate,9,2) < "01") or (Mid(sDate,9,2) > "31")) then 
        DateCheck = False 
        Exit Function
    End if

    if (Mid(sDate,6,2) = "04") or (Mid(sDate,6,2) = "06") or (Mid(sDate,6,2) = "09") or (Mid(sDate,6,2) = "11") then
        if Mid(sDate,9,2) > "30" then 
            DateCheck = False
            Exit Function
        End if
    End if

    '2월윤년검사
    if Mid(sDate,6,2) = "02" then

        if Mid(sDate,9,2) > "29" then 
            DateCheck = False 
            Exit Function
        ELSEif (CINT(Mid(sDate,1,4)) MOD 4) <> 0 then  '4로 나누어서 0가 아닌 것--> 28일이다
            if Mid(sDate,9,2) = "29" then 
                DateCheck = False
                Exit Function
            End if
        ELSE '4로 나누어서 0인것 --> 29일 인것
            if (CINT(Mid(sDate,1,4)) MOD 100) =  0 then  '29 이면 error
                if (((CINT(Mid(sDate,1,4)) MOD 400) <> 0) and (Mid(sDate,9,2) > "28")) then 
                    DateCheck = False
                    Exit Function
                End if 
            End if
        End if
    End if

    DateCheck = True
End Function


'---------------------------------------------------------------------------------------------------
'** SMTP 메일 보내기
'---------------------------------------------------------------------------------------------------
Sub subSendMailSMTP(toMail, reMail, Subject, Body, iFormat , File)
    Dim iMsg
    Dim iConf

    Set iMsg = CreateObject("CDO.Message")
    'SendUsing 속성을 지정하기 위한 개체 생성
    Set iConf = iMsg.Configuration

    iConf.Load 1
    With iConf.Fields

        .item("http://schemas.microsoft.com/cdo/configuration/sendusing") = 2   '1일 경우 로컬(SMTP), 2일 경우 외부(SMTP)로 메일전송
        .item("http://schemas.microsoft.com/cdo/configuration/smtpserver") = "smtp.gmail.com"
        .Item("http://schemas.microsoft.com/cdo/configuration/smtpserverport") = 465 ' 메일 서버의 포트 번호
        .Item("http://schemas.microsoft.com/cdo/configuration/smtpusessl") = true
        .Item("http://schemas.microsoft.com/cdo/configuration/smtpauthenticate") = 1
        .Item("http://schemas.microsoft.com/cdo/configuration/sendusername") = "master@websight.co.kr"
        .Item("http://schemas.microsoft.com/cdo/configuration/sendpassword") = "zmfflr025"
        .item("http://schemas.microsoft.com/cdo/configuration/smtpconnectiontimeout") = 30
        .Update
    End With

    iMsg.To = reMail  '받는 사람 이메일 주소
    iMsg.From = toMail  '보내는 사람 이메일 주소
    iMsg.Subject  = Subject '제목
    iMsg.HTMLBody = Body    '본문

    IF File <> "" Then 
        iMsg.AddAttachment Server.MapPath("/upload/board/") &"/"& File
    End If 

    iMsg.BodyPart.Charset = "utf-8"
    iMsg.HTMLBodyPart.Charset = "utf-8"
    iMsg.Send

    Set iConf = Nothing
    Set iMsg = Nothing
End Sub
'---------------------------------------------------------------------------------------------------

Function Getrows_RecordSet(ProcName)
    Dim Rs
    SET Rs=DBCON.EXECUTE("{call "&procname&"}")
    IF NOT(Rs.BOF or Rs.EOF) then
        Getrows_RecordSet=Rs.Getrows
    END IF
    Rs.Close
    SET Rs=NOTHING
End Function

function CreateCommand(ByRef connection,ByVal cmdText,ByVal cmdType)
    dim objcmd
    set objcmd=Server.CreateObject("ADODB.Command")
        objcmd.ActiveConnection=connection
        objcmd.CommandText=cmdText
        objcmd.CommandType=cmdType
    set CreateCommand=objCmd
end function

function CreateInputParameter(ByVal paramName,ByVal paramType,ByVal paramSize,ByVal paramValue)
    Dim objParam
    set objParam=Server.CreateObject("ADODB.Parameter")
        objParam.Name=paramName
        objParam.Type=paramType
        objParam.direction=&H0001
        objParam.Size=paramSize
        objParam.Value=paramValue
    set CreateInputParameter=objParam
end function

function CreateOutputParameter(ByVal paramName,ByVal paramType,ByVal paramSize)
    Dim objParam
    set objParam=Server.CreateObject("ADODB.Parameter")
        objParam.Name=paramName
        objParam.Type=paramType
        objParam.direction=&H0002
        objParam.Size=paramSize
    set CreateOutputParameter=objParam
end function


' ***************************************************************************************
' * 함수설명 : 태그제거 함수
' * 변수설명 : ActText  = 변경할 스트링 변수
' *            AllowTags = 허용태그설정 변수
' ***************************************************************************************
Function RemoveUnallowTags(ActText, AllowTags)
    content = ActText:
    tags = replace(AllowTags,",","|"):
    if Len(tags) = 0 Then tags = " "

    content    = EregiReplace("<(\/?)(?!\/|" & tags & ")([^<>]*)?>", "", content):
    content = EregiReplace("(javascript\:|vbscript\:)+","$1//",content):
    content = EregiReplace("(\.location|location\.|onload=|\.cookie|alert\(|window\.open\(|onmouse|onkey|onclick|view\-source\:)+","//",content): '//자바스크립트 실행방지
    RemoveUnallowTags = content:
End Function

Function EregiReplace(pattern, replace, text)
    Dim eregobj
    set eregobj= new regexp
    eregobj.pattern= pattern   
    eregobj.ignorecase    = True    
    eregobj.global = True        
    EregiReplace = eregobj.replace(text, replace)    
    
    set eregobj=nothing
End Function

' ***************************************************************************************
' * 함수설명 : Date 형변환.(문자열 -추가)
' * 변수설명 : str : 변환할 변수 값
' ***************************************************************************************
Function DateStr(Str)
    DateStr=Left(Str,4)&"-"&Mid(Str,5,2)&"-"&Right(Str,2)
End Function

' ***************************************************************************************
' * 함수설명 : 게시판 중복방지용 코드생성.
' ***************************************************************************************
Function RdmCodeM()
    Dim str, strlen, tmpCode, Code
    Dim r, i, ds
    Dim RanSu(4)

    Randomize   ' 난수 발생기를 초기화합니다.
    For i=0 To 4
        RanSu(i)=Int((10 * Rnd) + 1)
    Next

    str = "abcdefghijklm0123456789nopqrstuvwxyz"
    strlen = 9 '자릿수
    Randomize '랜덤 초기화

    For i = 0 to strlen
        r = Int((36 - 1 + 1) * Rnd + 1) ' 36은 str의 갯수
        
        tmpCode=Mid(Str,r,1)
        For j=0 To Ubound(RanSu)
            IF RanSu(j)=i Then
                tmpCode="<font color='red'>"&Mid(Str,r,1)&"</font>"
                Code=Code&Mid(Str,r,1)
                Exit For
            End IF
        Next
        serialCode = serialCode + tmpCode
    Next
    RdmCodeM= serialCode&"|"&Code
End Function

' ***************************************************************************************
' * 함수설명 : Layer팝업리스트 Get.
' ***************************************************************************************
SUB Get_PopInfo()
    Dim NowDate,Allrec,i
    Dim Sort,TItle,Content,HtmlYN,LinkUrl,OutputImg
    NowDate=Year(date())&AddZero(Month(Date()))&AddZero(Day(Date()))
    Allrec=GetRows_RecordSet("FM_UP_PopupList(1,'"&NowDate&"')")
    
    IF IsArray(Allrec) Then

        PopStr=""

        For i=0 To Ubound(Allrec,2)
            IF Allrec(11,i)=0 Then
                PopStr = PopStr & "<SCRIPT LANGUAGE='JavaScript'>"&Vbcrlf
                PopStr = PopStr & "popOpen("&Allrec(1,i)&","&Allrec(2,i)&","&Allrec(0,i)&","&Allrec(3,i)&","&Allrec(4,i)&",0);"&Vbcrlf
                PopStr = PopStr & "</SCRIPT>"&Vbcrlf
            ElseIF Allrec(11,i)=1 Then
                Sort=Allrec(5,i) : Title=Allrec(6,i) : Content=Allrec(7,i) : HtmlYn=Allrec(8,i) : LinkUrl=Allrec(9,i) : OutputImg=Allrec(10,i)

                PopStr = PopStr & "<div id='divpop_"&Allrec(0,i)&"' style='position:absolute; top:"&Allrec(3,i)&"px; left:"&Allrec(4,i)&"px; z-index:200; border:3px solid #313031;'>"&Vbcrlf
                PopStr = PopStr & "<table cellpadding=0 cellspacing=0 style='word-break:break-all;'>"&Vbcrlf
                PopStr = PopStr & "    <tr>"&Vbcrlf
                PopStr = PopStr & "        <td bgcolor='#FFFFFF' colspan='2' valign='top' style='padding:3px;'>"&Vbcrlf
                IF Sort=0 Then
                    PopStr = PopStr & "<div id='HKeditorContent' name='HKeditorContent' style='width:"&Allrec(1,i)&"px; height:"&Allrec(2,i)&"px; overflow-y:auto; color: #5D5D5D'>"&Content&"</div>"
                Else
                    IF LinkUrl<>"" Then PopStr = PopStr & "<a href=""javascript:location.href='http://"&LinkUrl&"'"">"&Vbcrlf
                    PopStr = PopStr & "<img src='/upload/popup/"&OutPutImg&"' border='0' align='absmiddle'></a>"&Vbcrlf
                End IF
                PopStr = PopStr & "        </td>"&Vbcrlf
                PopStr = PopStr & "    </tr>"&Vbcrlf
                PopStr = PopStr & "    <tr bgcolor='#313031' height='20' style='cursor:move;' onmouseover='Drag.init(this,divpop_"&Allrec(0,i)&")'>"&Vbcrlf
                PopStr = PopStr & "        <td><img src='/common/memberimg/btn_pop_todayclose_layer.gif' border='0' style='cursor:pointer;' onclick=""closetoLayer('divpop_"&Allrec(0,i)&"')"" /></td>"&Vbcrlf
                PopStr = PopStr & "        <td align='right'><img src='/common/memberimg/btn_pop_close_layer.gif' border='0' onclick='closeLayer(divpop_"&Allrec(0,i)&")' style='cursor:pointer;' /></td>"&Vbcrlf
                PopStr = PopStr & "    </tr>"&Vbcrlf
                PopStr = PopStr & "</table>"&Vbcrlf
                PopStr = PopStr & "</div>"&Vbcrlf
            ElseIF Allrec(11,i)=2 Then
                idx=Allrec(0,i) : Sort=Allrec(5,i) : Title=Allrec(6,i) : HtmlYn=Allrec(8,i) : LinkUrl=Allrec(9,i) : temCode=Allrec(12,i)

                PopStr = PopStr & "<div id='divpop_"&Allrec(0,i)&"' style='width:"&Allrec(1,i)&"px;position:absolute; top:"&Allrec(3,i)&"px; left:"&Allrec(4,i)&"px; z-index:200; border:3px solid #313031;'>"&Vbcrlf
                PopStr = PopStr & "<div id='divtemppop_"&Allrec(0,i)&"' name='divtemppop_"&Allrec(0,i)&"' style='width:"&Allrec(1,i)&"px; height:"&Allrec(2,i)&"px;'></div>"&Vbcrlf
                PopStr = PopStr & "<table cellpadding=0 cellspacing=0 style='word-break:break-all;cursor:move;' width='100%' onmouseover='Drag.init(this,divpop_"&Allrec(0,i)&")'>"&Vbcrlf
                PopStr = PopStr & "    <tr bgcolor='#313031' height='20'>"&Vbcrlf
                PopStr = PopStr & "        <td><img src='/common/memberimg/btn_pop_todayclose_layer.gif' border='0' style='cursor:pointer;' onclick=""closetoLayer('divpop_"&Allrec(0,i)&"')"" /></td>"&Vbcrlf
                PopStr = PopStr & "        <td align='right'><img src='/common/memberimg/btn_pop_close_layer.gif' border='0' onclick='closeLayer(divpop_"&Allrec(0,i)&")' style='cursor:pointer;' /></td>"&Vbcrlf
                PopStr = PopStr & "    </tr>"&Vbcrlf
                PopStr = PopStr & "</table>"&Vbcrlf
                PopStr = PopStr & "</div>"&Vbcrlf
                PopStr = PopStr & "<SCRIPT LANGUAGE='JavaScript'>viewTempPopup('divtemppop_"&Allrec(0,i)&"',"&temCode&",'"&idx&"')</SCRIPT>"&Vbcrlf
            END IF

            IF Allrec(11,i)<>0 Then
                PopStr = PopStr & "<script language=""Javascript"">"&Vbcrlf
                PopStr = PopStr & "if(getCookie(""divpop_"&Allrec(0,i)&""")!=""done""){"&Vbcrlf
                PopStr = PopStr & "    document.all[""divpop_"&Allrec(0,i)&"""].style.visibility = ""visible"";"&Vbcrlf
                PopStr = PopStr & "}else{"&Vbcrlf
                PopStr = PopStr & "    document.all[""divpop_"&Allrec(0,i)&"""].style.visibility = ""hidden"";"&Vbcrlf
                PopStr = PopStr & "}"&Vbcrlf
                PopStr = PopStr & "</script>"&Vbcrlf
            End IF
        Next
    End IF
END Sub

SUB Get_EngPopInfo()
    Dim NowDate,Allrec,i
    Dim Sort,TItle,Content,HtmlYN,LinkUrl,OutputImg
    NowDate=Year(date())&AddZero(Month(Date()))&AddZero(Day(Date()))
    Allrec=GetRows_RecordSet("FM_UP_EngPopupList(1,'"&NowDate&"')")
    
    IF IsArray(Allrec) Then

        PopStr=""

        For i=0 To Ubound(Allrec,2)
            IF Allrec(11,i)=0 Then
                PopStr = PopStr & "<SCRIPT LANGUAGE='JavaScript'>"&Vbcrlf
                PopStr = PopStr & "engpopOpen("&Allrec(1,i)&","&Allrec(2,i)&","&Allrec(0,i)&","&Allrec(3,i)&","&Allrec(4,i)&",0);"&Vbcrlf
                PopStr = PopStr & "</SCRIPT>"&Vbcrlf
            ElseIF Allrec(11,i)=1 Then

                Sort=Allrec(5,i) : Title=Allrec(6,i) : Content=Allrec(7,i) : HtmlYn=Allrec(8,i) : LinkUrl=Allrec(9,i) : OutputImg=Allrec(10,i)

                PopStr = PopStr & "<div id=""engdivpop_"&Allrec(0,i)&""" style=""position:absolute;left:"&Allrec(4,i)&"px;top:"&Allrec(3,i)&"px;z-index:200; border:1px solid #B2B2B2;"">"&Vbcrlf
                PopStr = PopStr & "<table width="&Allrec(1,i)&" cellpadding=1 cellspacing=0 style='word-break:break-all;'>"&Vbcrlf
                PopStr = PopStr & "<tr><td height='20' colspan='2' valign='top' bgcolor='#254181' style='color:#FFFFFF; padding-left:5px;'><b>"&Title&"</b></td></tr>"&Vbcrlf
                PopStr = PopStr & "<tr><td height='2' colspan='2' bgcolor='#000000;'></td></tr>"&Vbcrlf
                PopStr = PopStr & "<tr><td height="&Allrec(2,i)&" bgcolor=white colspan='2' valign='top'>"&Vbcrlf
                IF Sort=0 Then
                    PopStr = PopStr & "<div id='HKeditorContent' name='HKeditorContent'>"&Content&"</div>"
                Else
                    IF LinkUrl<>"" Then PopStr = PopStr & "<a href=""javascript:location.href='http://"&LinkUrl&"'"">"&Vbcrlf
                    PopStr = PopStr & "<img src='/upload/popup/"&OutPutImg&"' border='0' align='absmiddle'></a>"&Vbcrlf
                End IF            
                PopStr = PopStr & "</td></tr>"&Vbcrlf
                PopStr = PopStr & "<form name=""notice_form"">"&Vbcrlf
                PopStr = PopStr & "<tr><td height='1' bgcolor='#D1D1D1' colspan='2'></td></tr>"&Vbcrlf
                PopStr = PopStr & "<tr bgcolor='#EEEEEE' height='20'>"&Vbcrlf
                PopStr = PopStr & "<td><img src=""/common/memberimg/btn_pop_todaycloseeng.gif"" width=""98"" height=""20"" hspace=""5"" border='0'  style=""cursor:hand;"" onclick=""closetoLayer('engdivpop_"&Allrec(0,i)&"')"" /></td>"&Vbcrlf
                PopStr = PopStr & "<td align=""right"" style=""padding-right:5px;""><img src=""/common/memberimg/btn_pop_closeeng.gif"" width=""47"" height=""20"" border='0' onclick=""closeLayer(engdivpop_"&Allrec(0,i)&")"" style=""cursor:hand;"" /></td>"&Vbcrlf
                PopStr = PopStr & "</tr>"&Vbcrlf
                PopStr = PopStr & "</form>"&Vbcrlf
                PopStr = PopStr & "</table>"&Vbcrlf
                PopStr = PopStr & "</div>"&Vbcrlf

                PopStr = PopStr & "<script language=""Javascript"">"&Vbcrlf
                PopStr = PopStr & "if(getCookie(""engdivpop_"&Allrec(0,i)&""")!=""done""){"&Vbcrlf
                PopStr = PopStr & "    document.all[""engdivpop_"&Allrec(0,i)&"""].style.visibility = ""visible"";"&Vbcrlf
                PopStr = PopStr & "}else{"&Vbcrlf
                PopStr = PopStr & "    document.all[""engdivpop_"&Allrec(0,i)&"""].style.visibility = ""hidden"";"&Vbcrlf
                PopStr = PopStr & "}"&Vbcrlf
                PopStr = PopStr & "</script>"&Vbcrlf

            END IF
        Next
    End IF
END Sub
%>