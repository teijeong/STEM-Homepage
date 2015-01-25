<!-- #include virtual = common/dbcon.asp -->
<%
Dim Content,Idx
Dim Sql,StrLocation

Page=Request("Page")
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
BBscode=Request("BBscode")

Sql="Select Top 1 pwd,IsNull(useridx,'') As useridx,boardidx,cadwrite From commentAdmin Where idx="&Idx
Set Rs=DBcon.Execute(Sql)
IF Rs.Bof Or Rs.Eof Then
	Response.write ExecJavaAlert("잘못된접근입니다.","")
	DBcon.Close
	Set DBcon=Nothing
	Response.End
Else
	inputPwd=Rs("pwd") : inputuseridx=Rs("useridx") : boardidx=Rs("boardidx") : cadwrite=Rs("cadwrite")
End IF

IF cadwrite="False" Then
	IF inputPwd="" Then
		IF CStr(inputuseridx)=CStr(UserIdx) THen souchk=1
		AlertMsg="작성자 정보와 일치하지 않습니다."
	Else
		IF inputPwd=Pwd THen souchk=1
		AlertMsg="비밀번호가 일치하지 않습니다."
	End If
Else
	AlertMsg="작성자 정보와 일치하지 않습니다."
End IF

IF souchk<>1 Then
	Response.Write ExecJavaalert(AlertMsg&"\n다시시도해주세요.","")
	Response.End
End IF

Sql="UPDATE commentAdmin Set content=N'"&content&"' Where idx="&Idx
DBcon.Execute Sql

DBcon.Close
Set DBcon=Nothing

StrLocation="viewBoardCommentArea('"&boardidx&"','"&bbscode&"','"&Page&"');"
Response.write ExecJavaAlert("코멘트가 수정되었습니다.",3)
%>