<!-- #include virtual=common/addbcon.asp -->
<%
Dim Selcodes,Num,i,CateIdx,strLocation,Sql

Bansort=Request("Bansort")
SelCodes=Request("selcodes")
Selcodes=Split(Selcodes,",")
	
Num=1
For i=0 To Ubound(SelCodes)
	Sql="UPDATE mainbannerAdmin SET ListNum="&Num&" WHERE idx="&SelCodes(i)
	DBcon.Execute Sql
	Num=Num+1
Next

Dbcon.Close
Set Dbcon=Nothing

strLocation="mainbanner.asp?Bansort="&Bansort
Response.Write ExecJavaAlert("게시물 순서가 수정되었습니다.",2)
%>
