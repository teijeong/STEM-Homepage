<!-- #include virtual = common/dbcon.asp -->
<%
DIM ID,PWD,Cmd,result,strLocation,prepage,MemberShip,MemSort,ConfirmCode,returnURL

IF Request("logout")=1 Then
    Session.Contents.RemoveAll
    strLocation="/"
    Response.Write ExecJavaAlert("정상적으로 로그아웃이 되었습니다.",2)
    Response.End
Else
    WIP=Request.ServerVariables("REMOTE_ADDR")
    rememberIDYN=Request("rememberIDYN")

    PrePage=Request("prepage")
    ID=request("userid")
    PWD=request("passwd")
    IntraYN=SpaceToZero(Request("IntraYN"))
    guestCHK=request("guestCHK")
    returnURL=request("returnURL")

    IF rememberIDYN="" OR IsNull(rememberIDYN) Then
        Response.Cookies("rememberID").Expires=Dateadd("d",-7,Date)
    Else
        Response.Cookies("rememberID").expires=Dateadd("d",+7,Date)
        Response.Cookies("rememberID")=ID
    End IF

    Set Cmd=CreateCommand(dbcon,"UP_UserLogin",adCmdStoredProc)
    With Cmd
        .Parameters.Append CreateInputParameter("@u_id",adVarWChar,15,ID)
        .Parameters.Append CreateInputParameter("@m_pwd",adVarWChar,100,PWD)
        .Parameters.Append CreateInputParameter("@IntraYN",adTinyint,1,IntraYN)
        .Parameters.Append CreateOutPutParameter("@result",AdInteger,4)
        .Parameters.Append CreateOutPutParameter("@Username",adVarWChar,20)
        .Parameters.Append CreateOutPutParameter("@Memsort",adTinyint,1)
        .execute
    End With
    Result=Cmd.Parameters("@result").value
    UserName=Cmd.Parameters("@Username").value
    MemSort=Cmd.Parameters("@Memsort").value
    Set Cmd=Nothing

    IF Result=0 Then
        Response.Write ExecJavaAlert("일치하는정보가 없습니다.\n확인후 다시 시도해주십시오.",0)
        Response.End
    Else
        Session("UserIdx") = Result
        Session("UserID") = ID
        Session("UserName") = UserName
        Session("MemberShip") = MemSort

        IF returnURL<>"" Then
            PrePage = returnURL
        End IF
        IF PrePage="" Then PrePage="/"

        strLocation=PrePage
        Response.Write ExecJavaAlert("",2)
        Response.End
    End IF
End IF

DBcon.close
Set DBcon=Nothing
%>