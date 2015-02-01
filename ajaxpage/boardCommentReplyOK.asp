<!-- #include virtual = common/dbcon.asp -->
<%
Dim Content,Idx
Dim Sql,StrLocation

Name=Request("name")
Pwd=Request("pwd")
UserIdx="Null"

IF Pwd="" Then
    IF Session("UserIdx")="" Then
        Response.write ExecJavaAlert("로그인이필요한페이지입니다.","")
        DBcon.Close
        Set DBcon=Nothing
        Response.End
    Else
        UserIdx=Session("UserIdx")
        Name=Session("UserName")
    End IF
End IF

Content=ReplaceNoHtml(Replaceensine(Request("content")))
Idx=Request("idx")
bbscode=Request("bbscode")
Page=Request("Page")

Sql="SELECT boardidx,co_ref,co_ReLevel from CommentAdmin WHERE idx="&Idx
Rs=DBcon.Execute(Sql)
boardidx=Rs(0) : co_ref=Rs(1) : co_ReLevel=Rs(2)

Dim MaxReLevelRec,MaxReLevel
Sql="Select Top 1 co_ReLevel From CommentAdmin Where co_ref="&co_ref&" And co_ReLevel Like '"&co_ReLevel&"_' Order By co_ReLevel DESC"
Set MaxReLevelRec=DBcon.Execute(Sql)

IF MaxReLevelRec.Eof Then
    MaxReLevel = co_ReLevel&"A"
Else
    MaxReLevel = co_ReLevel&Chr(ASC(Right(MaxReLevelRec(0),1))+1)
End IF

Set MaxReLevelRec=Nothing

Sql="Insert INTO CommentAdmin(boardcode,boardidx,useridx,pwd,name,content,co_ref,co_ReLevel) VALUES("&BBscode&","&boardidx&","&UserIdx&",N'"&Pwd&"',N'"&Name&"',N'"&Content&"',"&co_ref&",'"&MaxReLevel&"')"
DBcon.Execute Sql

DBcon.Close
Set DBcon=Nothing

StrLocation="viewBoardCommentArea('"&boardidx&"','"&bbscode&"','"&Page&"');"
Response.write ExecJavaAlert("코멘트가 등록되었습니다.",3)
%>