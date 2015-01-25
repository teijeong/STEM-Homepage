<%
Call HK_BBSSetup(BBsCode)
BBsViewModeChk("reply")
BbsAdminChk()

Idx=Request("idx")
Ref=Request("Ref")
ReLevel=Request("ReLevel")
Page=Request("Page")

serboardsort=Request("serboardsort")
Search=Request("Search")
SearchStr=Request("SearchStr")

Sql="Select publicYN FROM BBslist Where idx="&Idx
Set Rs=DBcon.Execute(Sql)

IF Rs.Bof Or Rs.Eof Then
	Response.write ExecJavaAlert("잘못된 접근입니다.\n이전페이지로 이동합니다.",0)
	Response.End
Else
	IF Rs(0)="True" Then
		Response.write ExecJavaAlert("비공개 게시물에는 답변글을 작성하실수 없습니다.",0)
		Response.End
	End IF
End IF
%>