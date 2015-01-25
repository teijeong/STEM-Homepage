<!-- #include virtual = common/ADdbcon.asp -->
<%
Dim Content,Idx
Dim Sql,StrLocation

Content=ReplaceNoHtml(Replaceensine(Request("content")))
Idx=Request("idx")
bbscode=Request("bbscode")

Sql="Insert INTO CommentAdmin(boardcode,boardidx,useridx,pwd,name,content,cadwrite) VALUES("&BBscode&","&Idx&","&Request.Cookies("acountidx")&",'',N'관리자',N'"&Content&"',1)"
DBcon.Execute Sql

'=================원글 코멘트 셋팅================
Dim MaxIdx

Sql="Select Max(Idx) From CommentAdmin"
MaxIdx=DBcon.Execute(Sql)

Sql="UPDATE CommentAdmin Set co_Ref="&MaxIdx(0)&",co_ReLevel='A' Where idx="&MaxIdx(0)
DBcon.Execute Sql
'=================================================

DBcon.Close
Set DBcon=Nothing

StrLocation="viewBoardCommentArea('"&idx&"','"&bbscode&"','');"
Response.write ExecJavaAlert("코멘트가 등록되었습니다.",3)
%>