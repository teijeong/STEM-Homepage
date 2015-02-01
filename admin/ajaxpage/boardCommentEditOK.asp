<!-- #include virtual = common/ADdbcon.asp -->
<%
Dim Content,Idx
Dim Sql,StrLocation

Page=Request("Page")

Content=ReplaceNoHtml(Replaceensine(Request("content")))
Idx=Request("idx")
BBscode=Request("BBscode")

Sql="Select Top 1 boardidx From commentAdmin Where idx="&Idx
Set Rs=DBcon.Execute(Sql)
IF Rs.Bof Or Rs.Eof Then
    Response.write ExecJavaAlert("잘못된접근입니다.","")
    DBcon.Close
    Set DBcon=Nothing
    Response.End
Else
    boardidx=Rs("boardidx")
End IF

Sql="UPDATE commentAdmin Set content=N'"&content&"' Where idx="&Idx
DBcon.Execute Sql

DBcon.Close
Set DBcon=Nothing

StrLocation="viewBoardCommentArea('"&boardidx&"','"&bbscode&"','"&Page&"');"
Response.write ExecJavaAlert("코멘트가 수정되었습니다.",3)
%>