<!-- #include virtual = common/ADdbcon.asp -->
<%
Dim Content,Idx
Dim Sql,StrLocation

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

Sql="Insert INTO CommentAdmin(boardcode,boardidx,useridx,pwd,name,content,cadwrite,co_ref,co_ReLevel) VALUES("&BBscode&","&boardidx&","&Request.Cookies("acountidx")&",'',N'관리자',N'"&Content&"',1,"&co_ref&",'"&MaxReLevel&"')"
DBcon.Execute Sql

DBcon.Close
Set DBcon=Nothing

StrLocation="viewBoardCommentArea('"&boardidx&"','"&bbscode&"','"&Page&"');"
Response.write ExecJavaAlert("코멘트가 등록되었습니다.",3)
%>