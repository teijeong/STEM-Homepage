<!-- #include virtual = common/dbcon.asp -->
<%
Dim AdId,AdPwd,strLocation,Cmd,result

IF Request("logout")=1 then
    Response.Cookies("acountcode").Expires=Dateadd("d",-1,Date)
    Response.Cookies("accuntmemsort").Expires=Dateadd("d",-1,Date)
    Response.Cookies("acountidx").Expires=Dateadd("d",-1,Date)
    Response.Cookies("acountname").Expires=Dateadd("d",-1,Date)

    strLocation="/admin/login.htm"
    Response.Write ExecJavaAlert("정상적으로 로그아웃이 되었습니다.",2)
    Response.End
Else
    AdId=Request("admin_userid")
    adpwd=Request("admin_passwd")
    rememberadINFOYN=Request("rememberadINFOYN")

    IF rememberadINFOYN="" OR IsNull(rememberadINFOYN) Then
        Response.Cookies("rememberADID").Expires=Dateadd("d",-7,Date)
        Response.Cookies("rememberADPWD").Expires=Dateadd("d",-7,Date)
    Else
        Response.Cookies("rememberADID").expires=Dateadd("d",+7,Date)
        Response.Cookies("rememberADPWD").expires=Dateadd("d",+7,Date)
        Response.Cookies("rememberADID")=AdId
        Response.Cookies("rememberADPWD")=adpwd
    End IF

    Set Cmd=CreateCommand(dbcon,"SAP_Login",adCmdStoredProc)
    With Cmd
        .Parameters.Append CreateInputParameter("@UId",AdVarWChar,15,AdId)
        .Parameters.Append CreateInputParameter("@UPwd",AdVarWChar,15,adpwd)
        .Parameters.Append CreateOutPutParameter("@ResultID",AdVarWChar,15)
        .Parameters.Append CreateOutPutParameter("@ResultMemsort",adInteger,4)
        .Parameters.Append CreateOutPutParameter("@ResultIDx",adBigint,8)
        .Parameters.Append CreateOutPutParameter("@ResultName",AdVarWChar,10)
        .execute
    End With
    ResultID=Cmd.Parameters(2).value
    ResultMemsort=Cmd.Parameters(3).value
    ResultIDx=Cmd.Parameters(4).value
    ResultName=Cmd.Parameters(5).value
    
    Set Cmd=Nothing
    DBcon.Close
    Set DBcon=Nothing

    IF ResultID = "0" Then
        Response.Write ExecJavaAlert("로그인정보 불일치 \n확인후 다시 시도해주십시오.",0)
        Response.end
    Else
        Response.Cookies("acountcode")=ResultID
        Response.Cookies("accuntmemsort")=ResultMemsort
        Response.Cookies("acountidx")=ResultIDx
        Response.Cookies("acountname")=ResultName

        IF ResultMemsort=0 Then
            strLocation="index.asp"
        Else
            strLocation="/admin/intra/useredit.asp"
        End IF
        Response.Write ExecJavaAlert("",2)
        Response.end
    End IF
End IF
%>