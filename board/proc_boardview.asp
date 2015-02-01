<%
Page=checkParameter("int",Request("page"))
serboardsort=checkParameter("int",Request("serboardsort"))
Search=checkParameter("char",Request("Search"))
SearchStr=checkParameter("char",Request("SearchStr"))
idx=checkParameter("int",Request("idx"))
inputPwd=Session("boardPass")

IF Search<>"" Then StrWhere = StrWhere & " And "&Search&" LIKE N'%"&SearchStr&"%' "
IF serboardsort<>"" Then StrWhere = StrWhere & " And BoardSort = '"&serboardsort&"' "
IF storeidx<>"" Then StrWhere = StrWhere & " And storeidx = '"&storeidx&"' "

IF BBsCode=false Or Idx="" Then
    Response.write ExecJavaAlert("잘못된 접근입니다.\n이전페이지로 이동합니다.",0)
    Response.End
End IF

Call HK_BBSSetup(BBsCode)
BBsViewModeChk("view")

Sql="Select title,writer,regdate,content,Ref,ReLevel,pwd,TopYn,readNum,publicYN,IsNull(UserIdx,0) As Useridx,SortName,imgnames,WIP,vodUrl FROM BBslist AS B Left Outer Join BoardSort AS S ON BoardSort=S.idx Where b.idx=?"
Set objCmd = Server.CreateObject("ADODB.Command")
With objCmd
    .ActiveConnection = DBcon
    .CommandType = adCmdText
    .CommandText = Sql
    
    .Parameters.Append .CreateParameter("@idx", adBigint, adParamInput, 8, idx)
End With
Set Rs = objCmd.Execute()
Set objCmd = Nothing

IF Not(Rs.Bof Or Rs.Eof) Then
    title=Rs("title") : writer=Rs("writer") : regdate=Rs("regdate") : content=Rs("content")
    Ref=Rs("Ref") : ReLevel=Rs("ReLevel") : Pwd=Rs("pwd") : TopYn=Rs("TopYn")
    ReadNum=Rs("readNum") : PublicYN=Rs("publicYN") : UserIdx=Rs("UserIdx") : SortName=Rs("sortName") : imgnames=Rs("imgnames")
    WIP=Rs("WIP") : vodUrl=Rs("vodUrl")

    IF PublicYN="True" Then
        IF inputPwd="" Then
            IF CStr(UserIdx)=CStr(Session("useridx")) THen souchk=souchk+1
            AlertMsg="작성자 정보와 일치하지 않습니다."
        Else
            IF inputPwd=Pwd THen souchk=souchk+1
            AlertMsg="비밀번호가 일치하지 않습니다."
        End IF
        IF souchk=false Then
            Response.Write ExecJavaalert(AlertMsg&"\n다시시도해주세요.",0)
            Response.End
        End IF
    End IF

    ' 조회수 증가 쿠키관련
    IF Request.Cookies("cpbview")(BBsCode&"st"&Idx)="" Then
        Sql="UPdate BBslist Set ReadNum=ReadNum+1 Where idx="&Idx
        DBcon.Execute Sql

        Response.Cookies("cpbview")(BBsCode&"st"&Idx) = Idx
        Response.cookies("cpbview").Expires = dateadd("h", 2, now())
        Response.Cookies("cpbview").Path = "/"
        ReadNum=ReadNum+1
    End IF

    '========================================이전/다음글 찾기 ====================================
    PreTag="<input type='button' value='이전글' class='button1'>" : NextTag="<input type='button' value='다음글' class='button1'>"

    SQL="SELECT TOP 1 idx,title,ref,relevel,DelYN,TopYn,publicYN,pwd FROM BBslist WHERE ((ref="&Ref&" AND Relevel<'"&ReLevel&"') OR ref>"&Ref&") AND TopYn="&BitToNumber(TopYn)&" AND boardidx="&BBsCode & StrWhere&" ORDER BY ref ASC, relevel DESC"
    Set Rs=DBcon.Execute(Sql)
    IF Not(Rs.Bof Or Rs.Eof) Then
        IF Rs(4)="True" Then
            PreTag="<input type='button' value='이전글' class='button1'>"
        Else
            IF Rs(6)="True" AND Not(Rs(7)="" Or IsNull(Rs(7))) Then
                PreTag="<input type='button' value='이전글' class='button1' onclick=""goPwdpage('view',"&Rs(0)&")"" style='cursor:pointer;'>"
            Else
                PreTag="<input type='button' value='이전글' class='button1' onclick=""location.href='?mode=view&page="&Page&"&idx="&Rs(0)&"&storeidx="&storeidx&"&serboardsort="&serboardsort&"&search="&Search&"&searchstr="&SearchStr&"'"" style='cursor:pointer;'>"
            End IF
        End IF
    End IF
    Rs.Close

    Sql="SELECT TOP 1 idx,title,ref,relevel,DelYN,TopYn,publicYN,pwd FROM BBslist WHERE ((ref="&Ref&" AND relevel>'"&ReLevel&"') OR ref<"&Ref&") AND TopYn="&BitToNumber(TopYn)&" AND boardidx="&BBsCode & StrWhere&" Order by ref DESC,relevel ASC"
    Set Rs=DBcon.Execute(Sql)
    IF Not(Rs.Bof Or Rs.Eof) Then
        IF Rs(4)="True" Then
            NextTag="<input type='button' value='다음글' class='button1'>"
        Else
            IF Rs(6)="True" AND Not(Rs(7)="" Or IsNull(Rs(7))) Then
                NextTag="<input type='button' value='다음글' class='button1' onclick=""goPwdpage('view',"&Rs(0)&")"" style='cursor:pointer;'>"
            Else
                NextTag="<input type='button' value='다음글' class='button1' onclick=""location.href='?mode=view&page="&Page&"&idx="&Rs(0)&"&storeidx="&storeidx&"&serboardsort="&serboardsort&"&search="&Search&"&searchstr="&SearchStr&"'"" style='cursor:pointer;'>"
            End IF
        End If
    End IF
    Rs.Close
    '=============================================================================================

Else
    Response.write ExecJavaAlert("잘못된 접근입니다.\n이전페이지로 이동합니다.",0)
    Response.End
End IF

IF TopYn="True" Then TopTag="[공지]"

IF HK_PdsYN = "True" Then
    Set Rs=Server.CreateObject("ADODB.RecordSet")
    Sql="SELECT filenames FROM bbsData WHERE bidx="&idx
    Rs.Open Sql,DBcon,1
    If Not(Rs.Bof Or Rs.Eof) Then FileRec=Rs.GetRows()
    Rs.CLose()
End IF

Function PT_FileArea()
    IF IsArray(FileRec) Then
    Response.Write "<div class=""attachedFile"">"&Vbcrlf
    Response.Write "    <dl>"&Vbcrlf
    Response.Write "        <dt><img src=""/common/memberimg/iconFiles.gif"" alt=""첨부"" /> <button type=""button"" class=""fileToggle"" onclick=""changeFileArea()"" style='color: #3383AE;'>첨부파일보기("&UBound(FileRec,2)+1&")</button></dt>"&Vbcrlf
    Response.Write "        <dd>"&Vbcrlf
    Response.Write "        <ul class=""files"" style='display:none;' id='fileArea' name='fileArea'>"&Vbcrlf
        For i=0 To UBound(FileRec,2)
            Response.Write "            <li>"&DownloadTag(FileRec(0,i),"board")&"</li>"&Vbcrlf
        Next
    Response.Write "        </ul>"&Vbcrlf
    Response.Write "        </dd>"&Vbcrlf
    Response.Write "    </dl>"&Vbcrlf
    Response.Write "</div>"&Vbcrlf
    End IF
End Function
%>