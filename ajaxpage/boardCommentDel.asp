<!-- #include virtual = common/dbcon.asp -->
<%
Dim IDx,Sql,ManageYn,StrLocation,Rs,UIdx
Idx=Request("idx")
Pwd=Request("Pwd")
bbscode=Request("bbscode")
Page=Request("Page")

Sql="SELECT IsNull(useridx,'') As useridx,pwd,boardidx,cadwrite,co_ref,co_ReLevel from CommentAdmin WHERE idx="&Idx
Rs=DBcon.Execute(Sql)
UIdx=Rs(0) : UPwd=Rs(1) : boardidx=Rs(2) : cadwrite=Rs(3) : co_ref=Rs(4) : co_ReLevel=Rs(5)

IF cadwrite="False" Then
    IF pwd="" Then
        IF IsNull(UIdx) Or Cstr(UIdx)<>Cstr(Trim(Session("UserIdx"))) Then
            DBcon.Close
            Set DBcon=Nothing
            Response.Write ExecJavaAlert("작성자 정보와 일치하지 않습니다.","")
            Response.End
        End IF
    Else
        IF Upwd<>Pwd Then
            DBcon.Close
            Set DBcon=Nothing
            Response.Write ExecJavaAlert("비밀번호가 일치하지 않습니다.","")
            Response.End
        End IF
    End If
Else
    DBcon.Close
    Set DBcon=Nothing
    Response.Write ExecJavaAlert("작성자 정보와 일치하지 않습니다.","")
    Response.End
End IF

'================코멘트 댓글 존재 여부에 따른 삭제 처리=========================
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
'===============================================================================

DBcon.Close
Set DBcon=Nothing

StrLocation="viewBoardCommentArea('"&boardidx&"','"&bbscode&"','"&Page&"');"
Response.write ExecJavaAlert("코멘트가 삭제되었습니다.",3)
%>