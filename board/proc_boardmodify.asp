<%
Page=checkParameter("int",Request("page"))
serboardsort=checkParameter("int",Request("serboardsort"))
Search=checkParameter("char",Request("Search"))
SearchStr=checkParameter("char",Request("SearchStr"))
idx=checkParameter("int",Request("idx"))
inputPwd=Session("boardPass")

IF BBsCode=false Or Idx="" Then 
    Response.write ExecJavaAlert("잘못된 접근입니다.\n이전페이지로 이동합니다.",0)
    Response.End
End IF
Call HK_BBSSetup(BBsCode)

Sql="Select writer,title,content,pwd,IsNull(UserIdx,0) As Useridx,relevel,adwrite,boardsort,imgNames,email FROM BBslist Where Idx=?"
Set objCmd = Server.CreateObject("ADODB.Command")
With objCmd
    .ActiveConnection = DBcon
    .CommandType = adCmdText
    .CommandText = Sql
    
    .Parameters.Append .CreateParameter("@idx", adBigint, adParamInput, 8, Idx)
End With
Set Rs = objCmd.Execute()

IF Rs.Bof Or Rs.Eof Then
    Response.Write ExecJavaAlert("잘못된접근입니다.다시시도해주세요.",0)
    Response.End
Else
    writer=ReplaceTextField(Rs("writer")) : title=ReplaceTextField(Rs("title"))
    content=ReplaceNoHtml(Rs("content")) : pwd=Rs("pwd")
    UserIdx=Rs("useridx") : relevel=Rs("relevel") : AdWrite=Rs("adwrite") : boardsort=Rs("boardsort")
    imgNames=Rs("imgNames") : Email=ReplaceTextField(Rs("Email"))

    BBsSort=GetBoardSort(BBsCode,BoardSort,ReLevel)

    souchk=0

    IF AdWrite="False" Then
        IF inputPwd="" Then
            IF CStr(UserIdx)=CStr(Session("useridx")) THen souchk=souchk+1
            AlertMsg="작성자 정보와 일치하지 않습니다."
        Else
            IF inputPwd=Pwd THen souchk=souchk+1
            AlertMsg="비밀번호가 일치하지 않습니다."
        End IF
    Else
        AlertMsg="작성자 정보와 일치하지 않습니다."
    End IF

    IF souchk=false Then
        Response.Write ExecJavaalert(AlertMsg&"\n다시시도해주세요.",0)
        Response.End
    End IF

    '=============파일정보Get======================================
    Set Rs=Server.CreateObject("ADODB.RecordSet")
    Sql="Select idx,filenames From BBSData Where bidx="&Idx
    Rs.Open Sql,DBcon,1

    IF Not(Rs.Bof Or Rs.Eof) Then FileRec=Rs.Getrows()
    Rs.Close
    '==============================================================
End IF
%>