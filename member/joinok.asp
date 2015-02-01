<!-- #include virtual = common/dbcon.asp -->
<%
Dim FileDel_Chk(2),FileName(2)

Sort=Request("sort")
IF Sort="" Then Sort=1

IF Sort="2" Then
HK_returnURL="/member/modify.asp"
%><!-- #include virtual = common/sessionchk.asp --><%
End IF

UserIdx=Session("useridx")
IF UserIdx="" Then UserIdx=0

Server.ScriptTimeOut=7200
set UploadForm=server.CreateObject("DEXT.FileUpload")
UploadForm.DefaultPath=Server.MapPath("/upload/member/")

memsort=ReplaceNoHtml(UploadForm("memsort"))
userid=ReplaceNoHtml(UploadForm("userid"))
passwd=UploadForm("passwd")
name=ReplaceNoHtml(UploadForm("name"))
zip=Replace(UploadForm("zip"),", ","-")
addr1=UploadForm("addr1")
addr2=ReplaceNoHtml(UploadForm("addr2"))
tel=Replace(UploadForm("tel"),", ","-")
phone=Replace(UploadForm("phone"),", ","-")
email=ReplaceNoHtml(UploadForm("email"))
EmailYN=UploadForm("EmailYN")
smsYN=UploadForm("smsYN")

birthday=Replace(UploadForm("birthday"),", ","-")
Sex=ReplaceNoHtml(UploadForm("Sex"))

FileDel_Chk(0)=UploadForm("FileDel_Chk")
FileName(0)=UploadForm("filename")

For i=1 To UploadForm("files").count
    IF FileDel_Chk(i-1)<>"" And FileName(i-1)<>"" Then ImgDelete FileName(i-1),UploadForm.DefaultPath

    IF FileDel_Chk(i-1)<>"" Or Sort=1 Then 
        IF UploadForm("files")(i)<>"" Then 
            FileName(i-1)=ImgSaves(UploadForm("files")(i),UploadForm.defaultpath,30720000)
            IF FileName(i-1)=False Then Result=1

            IF Result=1 Then
                Set UploadForm=Nothing
                DBcon.Close
                Set DBcon=Nothing
                Response.Write ExecJavaAlert("업로드 허용용량(30M)을 초과하여 업로드를 실패하였습니다.",0)
                Response.End
            End IF
        Else
            FileName(i-1)=""
        End IF
    End IF
Next

set cmd=CreateCommand(dbcon,"AP_MembersSet",adCmdStoredProc)
With cmd
    .Parameters.Append CreateInputParameter("@Sort",adVarchar,10,Sort)
    .Parameters.Append CreateInputParameter("@Idx",adBigint,8,SpaceToZero(UserIdx))
    .Parameters.Append CreateInputParameter("@memsort",adTinyint,1,SpaceToZero(memsort))
    .Parameters.Append CreateInputParameter("@userid",adVarWChar,15,userid)
    .Parameters.Append CreateInputParameter("@passwd",adVarWChar,15,passwd)
    .Parameters.Append CreateInputParameter("@name",adVarWChar,20,name)
    .Parameters.Append CreateInputParameter("@zip",adVarChar,7,zip)
    .Parameters.Append CreateInputParameter("@addr1",adVarWChar,100,addr1)
    .Parameters.Append CreateInputParameter("@addr2",adVarWChar,100,addr2)
    .Parameters.Append CreateInputParameter("@tel",adVarWChar,15,tel)
    .Parameters.Append CreateInputParameter("@phone",adVarWChar,15,phone)
    .Parameters.Append CreateInputParameter("@email",adVarWChar,100,email)
    .Parameters.Append CreateInputParameter("@EmailYN",adTinyint,1,EmailYN)
    .Parameters.Append CreateInputParameter("@smsYN",adTinyint,1,smsYN)
    .Parameters.Append CreateInputParameter("@FileName",adVarWChar,50,FileName(0))

    .Parameters.Append CreateInputParameter("@birthday",adVarWChar,100,birthday)
    .Parameters.Append CreateInputParameter("@Sex",adVarWChar,10,Sex)
    .Parameters.Append CreateOutputParameter("@result",adInteger,4)

    .execute
End With
Result=Cmd.Parameters("@result").Value

Set Cmd=Nothing
DBcon.Close
Set DBcon=Nothing

IF Result=0 Then
    strLocation="top.location.href='/';"
    Response.Write ExecJavaAlert("회원가입이 정상적으로 이루어졌습니다..","3")
ElseIF Result=1 then
    IF FileName(0)<>"" Then ImgDelete FileName(0),UploadForm.DefaultPath
    Response.Write ExecJavaAlert("중복된 아이디입니다.\n\n확인후 다시 시도해주세요","")
ElseIF Result=5 then
    IF FileName(0)<>"" Then ImgDelete FileName(0),UploadForm.DefaultPath
    Response.Write ExecJavaAlert("중복된 이메일주소입니다.\n\n확인후 다시 시도해주세요","")
ElseIF Result=3 then
    strLocation="top.location.reload();"
    Response.Write ExecJavaAlert("회원정보가 정상적으로 수정되었습니다.","3")
ElseIF Result=4 then
    strLocation="top.location.reload();"
    Response.Write ExecJavaAlert("중복된 이메일주소입니다\n이메일정보를 제외한 회원정보가 정상적으로 수정되었습니다.","3")
End IF
%>