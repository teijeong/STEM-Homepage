<!-- #include virtual = common/ADdbcon.asp -->
<%
Dim IDx,Sql,ManageYn,StrLocation,Rs,UIdx
Idx=Request("idx")
bbscode=Request("bbscode")
Page=Request("Page")

Sql="SELECT boardidx,co_ref,co_ReLevel from CommentAdmin WHERE idx="&Idx
Rs=DBcon.Execute(Sql)
boardidx=Rs(0) : co_ref=Rs(1) : co_ReLevel=Rs(2)

Sql="Select idx,co_ReLevel From CommentAdmin Where co_Ref="&co_ref&" AND co_ReLevel Like '"&co_ReLevel&"_'"
Set Rs=DBcon.Execute(Sql)

IF Rs.Bof Or Rs.Eof Then
	Sql="DELETE CommentAdmin WHERE idx="&Idx
	DBcon.Execute Sql

	For i=Len(co_ReLevel)-1 To i=1 step i-1
		Sql="Select idx From CommentAdmin Where co_Ref="&co_Ref&" And co_ReLevel like '"&Left(co_ReLevel,i)&"%' AND co_DelYN<>1 AND idx<>"&IDx
		Set Rs=DBcon.Execute(Sql)

		IF Rs.Bof Or Rs.Eof Then
			Sql="Delete CommentAdmin Where co_Ref="&co_Ref&" And co_ReLevel Like '"&Left(co_ReLevel,i)&"%'"
			DBcon.Execute Sql
		Else
			Exit For
		End IF
	Next
Else
	Sql="Update CommentAdmin Set co_DelYN=1 Where idx="&Idx
	DBcon.Execute Sql
End IF

DBcon.Close
Set DBcon=Nothing

StrLocation="viewBoardCommentArea('"&boardidx&"','"&bbscode&"','"&Page&"');"
Response.write ExecJavaAlert("코멘트가 삭제되었습니다.",3)
%>