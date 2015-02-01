<!--#include virtual = common/ADdbcon.asp-->
<%
Dim Sql,Allrec,Sort,strLocation,Idx,alertMsg

Sort=Request("sort") : Idx=Request("idx")
chkidx=Request("chkidx")
Page=Request("page")
serMemsort = Request("serMemsort")
serOrderbyStr=Request("serOrderbyStr")
serOrderbyDec=Request("serOrderbyDec")
searchitem=Request("searchitem")
searchstr=Request("searchstr")
seroutmember=Request("seroutmember")

If Sort=1 Then
    strLocation="MemberList.asp?page="& page &"&seroutmember="& seroutmember &"&serMemsort="& serMemsort &"&serOrderbyStr="& serOrderbyStr &"&serOrderbyDec="& serOrderbyDec &"&searchitem="& searchitem &"&searchstr="& searchstr
    alertMsg="선택하신 회원이 탈퇴상황으로 수정되었습니다."

    Sql="Update members Set outmember=1,outDate=Convert(Varchar(10),getdate(),23) Where idx IN ("&chkIdx&")"
ElseIf Sort=2 Then
    Sql="SELECT FileName FROM members WHERE idx="&Idx
    Set Rs=DBcon.Execute(Sql)
    IF Not(Rs.Bof Or Rs.Eof) Then
        Server.ScriptTimeOut=7200
        set UploadForm=server.CreateObject("DEXT.FileUpload")
        uploadform.DefaultPath=Server.MapPath("/upload/member/")

        IF Rs("FileName")<>"" Then ImgDelete Rs("FileName"),UploadForm.DefaultPath
        Set UploadForm=Nothing
    End IF
    
    strLocation="MemberList.asp?page="& page &"&seroutmember="& seroutmember &"&serMemsort="& serMemsort &"&serOrderbyStr="& serOrderbyStr &"&serOrderbyDec="& serOrderbyDec &"&searchitem="& searchitem &"&searchstr="& searchstr
    alertMsg="해당회원이 영구삭제 되었습니다."
    Sql="Delete members Where idx="&Idx
ElseIf Sort=3 Then
    strLocation="MemberList.asp?page="& page &"&seroutmember="& seroutmember &"&serMemsort="& serMemsort &"&serOrderbyStr="& serOrderbyStr &"&serOrderbyDec="& serOrderbyDec &"&searchitem="& searchitem &"&searchstr="& searchstr
    alertMsg="해당회원이 복구되었습니다."
    Sql="Update members Set outmember=0,outDate=null Where idx="&Idx
ElseIF Sort=4 Then
    strLocation="exitmemberlist.asp"
    alertMsg="선택하신 탈퇴신청서가 삭제되었습니다."
    Sql="Delete ExitMember Where idx="&Idx
Else
    strLocation="exitmemberlist.asp"
    alertMsg="선택하신 회원이 탈퇴상황으로 수정되었습니다."
    Sql="Update members Set outmember=1,outDate=Convert(Varchar(10),getdate(),23) Where idx IN ("&idx&")"
End If
DBcon.Execute Sql

DBcon.Close
Set DBcon=Nothing

Response.Write ExecJavaAlert(alertMsg,2)
%>