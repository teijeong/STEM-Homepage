<!-- #include virtual = common/dbcon.asp -->
<%
areaidx=Replaceensine(Request("areaidx"))
lccode=Replaceensine(Request("lccode"))
objname1=Replaceensine(Request("objname1"))
objname2=Replaceensine(Request("objname2"))

IF areaidx<>"" Then
	Set Rs=Server.CreateObject("ADODB.RecordSet")
	Sql="Select idx,areaname From areadetail Where areaidx="&areaidx&" Order By areaname ASC, idx ASC"
	Set Rs=DBcon.Execute(Sql)

	IF Not(Rs.Bof Or Rs.Eof) Then Allrec=Rs.GetRows()

	Rs.Close
	Set Rs=Nothing
END IF

Response.write "<SCRIPT LANGUAGE='JavaScript>"&Vbcrlf
Response.write "var cnt=document.getElementById('"&objname2&"').length;"&vbcrlf
Response.Write "for(var i=0;i<cnt;i++){ document.getElementById('"&objname2&"').remove(1); }"&Vbcrlf

IF IsArray(Allrec) Then
	For i=0 To Ubound(Allrec,2)
		tmpAreaName=Allrec(1,i)
		IF InStr(tmpAreaName,"(") Then
			tmpAreaName=Split(tmpAreaName,"(")(0)
		End IF
		Response.write "document.getElementById('"&objname2&"').options.add(new Option('"&tmpAreaName&"','"&Allrec(0,i)&"'));"
	Next
End IF

IF lccode<>"" Then
	Response.write "for(i=0;i<document.getElementById('"&objname2&"').options.length;i++){"&Vbcrlf
	Response.write "	if(document.getElementById('"&objname2&"').options[i].value=="&lccode&"){"&Vbcrlf
	Response.write "		document.getElementById('"&objname2&"').options[i].selected=true; break;"&Vbcrlf
	Response.write "	}"&Vbcrlf
	Response.write "}"&Vbcrlf
End IF
Response.write "</SCRIPT>"&Vbcrlf

DBcon.Close
Set DBcon=Nothing
%>