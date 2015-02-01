<!-- #include virtual = common/dbcon.asp -->
<%
response.expires = -1 
Dim Name,Icode,Sql,Rs,strLocation
Dim alertMsg,Sort

catecode=Replaceensine(Request("catecode"))
lccode=Replaceensine(Request("lccode"))

IF catecode<>"" Then
    Sql="Select itemname From Product WHERE catecode='"&Catecode&"'"
    Set Rs=DBcon.Execute(Sql)
    IF Not(Rs.Bof Or Rs.Eof) Then ProductRec=Rs.GetRows()
    Set Rs=Nothing
END IF

Response.write "<SCRIPT LANGUAGE='JavaScript>"&Vbcrlf
Response.write "var cnt=document.getElementById('selBox4').length;"&vbcrlf
Response.Write "for(var i=0;i<cnt;i++){ document.getElementById('selBox4').remove(1); }"&Vbcrlf
Response.Write "document.getElementById('selBox4').style.display='inline';"&Vbcrlf
IF IsArray(ProductRec) Then
    For i=0 To Ubound(ProductRec,2)
        Response.write "document.getElementById('selBox4').options.add(new Option('"&Replace(Replace(ProductRec(0,i),"'","_"),"""","_")&"','"&Replace(Replace(ProductRec(0,i),"'","_"),"""","_")&"'));"
    Next
End IF
Response.write "</SCRIPT>"&Vbcrlf

DBcon.Close
Set DBcon=Nothing
%>