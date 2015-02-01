<!-- #include virtual = common/ADdbcon.asp -->
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<%
idx=Request("chkidx")
Page=Request("page")
BBsCode=Request("bbscode")
serboardsort=Request("serboardsort")
serstorename=Request("serstorename")
Search=Request("Search")
SearchStr=Request("SearchStr")
targetMoveBoardidx=Request("targetMoveBoardidx")
Call HK_BBSSetup(BBsCode)

Sql="SELECT Top 1 idx From boardSort Where boardidx="&targetMoveBoardidx&" Order by idx ASC"
Set Rs=DBcon.Execute(Sql)
IF Rs.Bof OR Rs.Eof THen
    BoardSortidx="null"
Else
    BoardSortidx=Rs("idx")
End IF

IDX=Split(idx,", ")

For i=0 To Ubound(IDX)
    Sql="SELECT Ref,ReLevel FROM BBsList WHERE idx="&Idx(i)
    Set Rs=DBcon.Execute(Sql)
    IF Not(Rs.Bof OR Rs.Eof) Then
        Ref=Rs("Ref") : ReLevel=Rs("ReLevel")

        Sql="UPDATE BBsList SET boardidx="&targetMoveBoardidx&",boardsort="&BoardSortidx&" Where Ref="&Ref
        DBcon.Execute Sql
    End IF
Next

Set UploadForm=Nothing
DBcon.Close
Set DBcon=Nothing

strLocation="bbslist.asp?page="&Page&"&bbscode="&bbsCode&"&serboardsort="&serboardsort&"&serstorename="&serstorename&"&search="&Search&"&searchstr="&SearchStr
Response.Write ExecJavaAlert("선택하신 게시물이 이동되었습니다.",2)
%>