<!-- #include virtual = common/dbcon.asp -->
<%
response.expires = -1 
Dim Name,Icode,Sql,Rs,strLocation
Dim alertMsg,Sort

ItemBoxViewYN=""
catecode=Replaceensine(Request("catecode"))
lccode=Replaceensine(Request("lccode"))
lowcode=Replaceensine(Request("lowcode"))

IF catecode<>"" Then
	Sql="Select lowcode,name From Category Where Topcode="&catecode&" AND lowcode=middlecode AND lowcode<>topcode Order By align1Num ASC,align2Num ASC,align3Num ASC"
	Set Rs=DBcon.Execute(Sql)

	IF Not(Rs.Bof Or Rs.Eof) Then
		Allrec=Rs.GetRows()
	Else
		ItemBoxViewYN="True"
		Sql="Select itemname From Product WHERE catecode IN (select lowcode from category where lowcode='"&CateCode&"' Or Middlecode='"&CateCode&"' Or Topcode='"&CateCode&"')"
		Set Rs1=DBcon.Execute(Sql)
		IF Not(Rs1.Bof Or Rs1.Eof) Then ProductRec=Rs1.GetRows()
		Set Rs1=Nothing
	End IF
	Rs.Close
	Set Rs=Nothing
END IF

Response.write "<SCRIPT LANGUAGE='JavaScript>"&Vbcrlf
Response.write "var cnt=document.getElementById('selBox2').length;"&vbcrlf
Response.Write "for(var i=0;i<cnt;i++){ document.getElementById('selBox2').remove(1); }"&Vbcrlf

IF IsArray(Allrec) Then
	Response.Write "document.getElementById('selBox2').style.display='inline';"&Vbcrlf
	For i=0 To Ubound(Allrec,2)
		Response.write "document.getElementById('selBox2').options.add(new Option('"&Allrec(1,i)&"','"&Allrec(0,i)&"'));"&Vbcrlf
	Next

	IF lccode<>"" Then
		Response.write "for(i=0;i<document.getElementById('selBox2').options.length;i++){"&Vbcrlf
		Response.write "	if(document.getElementById('selBox2').options[i].value=="&lccode&"){"&Vbcrlf
		Response.write "		document.getElementById('selBox2').options[i].selected=true; break;"&Vbcrlf
		Response.write "	}"&Vbcrlf
		Response.write "}"&Vbcrlf
	End IF
Else
	Response.Write "document.getElementById('selBox2').style.display='none';"&Vbcrlf
End IF

IF ItemBoxViewYN="True" Then
	Response.Write "document.getElementById('selBox4').style.display='inline';"&Vbcrlf

	Response.write "var cnt=document.getElementById('selBox4').length;"&vbcrlf
	Response.Write "for(var i=0;i<cnt;i++){ document.getElementById('selBox4').remove(1); }"&Vbcrlf
	Response.Write "document.getElementById('selBox4').style.display='inline';"&Vbcrlf
	IF IsArray(ProductRec) Then
		For i=0 To Ubound(ProductRec,2)
			Response.write "document.getElementById('selBox4').options.add(new Option('"&Replace(Replace(ProductRec(0,i),"'","_"),"""","_")&"','"&Replace(Replace(ProductRec(0,i),"'","_"),"""","_")&"'));"
		Next
	End IF
Else
	Response.Write "document.getElementById('selBox4').style.display='none';"&Vbcrlf
End IF

Response.write "</SCRIPT>"&Vbcrlf

DBcon.Close
Set DBcon=Nothing
%>