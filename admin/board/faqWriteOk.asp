<!-- #include virtual = common/ADdbcon.asp -->
<%
Dim strLocation,Page
Dim Idx,BoardSort,Sort,Title,Content,AlertTag
Dim Sql,ObjCmd

Page=Request("page")
BoardSort=Request("BoardSort")
Title=ReplaceNoHtml(Request("title"))
Content = Replace(Request("content"),"http://"&Request.Servervariables("Server_name")&"/","/")
Idx=Request("idx")
Sort=Request("sort")

IF Sort="edit" Then
    AlertTag="수정"
    Sql="Update faq Set BoardSort=?, Title=?,Content=? Where idx="&idx
Else
    AlertTag="등록"
    Sql="INSERT INTO faq(BoardSort,Title,Content) VALUES(?, ?, ?)"
End IF

Set objCmd = Server.CreateObject("ADODB.Command")
With objCmd
    .ActiveConnection = DBcon
    .CommandType = adCmdText
    .CommandText = Sql
    
    .Parameters.Append .CreateParameter("@BoardSort", adTinyInt, adParamInput, 1, SpaceToZero(BoardSort))
    .Parameters.Append .CreateParameter("@title", adVarWChar, adParamInput, 200, title)
    .Parameters.Append .CreateParameter("@content", adVarWChar, adParamInput, 2147483647, content)
    .Execute,,adExecuteNoRecords
End With
Set objCmd = Nothing

DBcon.Close
Set DBcon=Nothing

strLocation="Faqlist.asp?page="&Page
Response.Write ExecJavaAlert("게시물이 "&AlertTag&"되었습니다.",2)
%>