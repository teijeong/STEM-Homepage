<!--#include virtual = common/dbcon.asp-->
<%
Dim Id,Sql,IdYN,InsertTag,Chk
id=Request("id")

Sql="Select Top 1 * from Members WHERE id='"&id&"'"
Set IdYN=DBcon.Execute(sql)

IF IdYN.Bof or IdYN.Eof Then
    Response.Write "useY"
Else
    Response.Write "useN"
End IF

IDYN.Close
Set IdYN=Nothing
DBcon.Close
Set DBcon=Nothing
%>