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

Sql="Insert INTO CommentAdmin(boardcode,boardidx,useridx,pwd,name,content) VALUES("&BBscode&","&Idx&","&UserIdx&",N'"&Pwd&"',N'"&Name&"',N'"&Content&"')"
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