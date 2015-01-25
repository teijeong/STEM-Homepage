<!--#include virtual = common/dbcon.asp-->
<%
chkidx=Request("chkidx")

Set Rs=server.CreateObject("ADODB.RecordSet")
Sql = "select " 
Sql = Sql & "ID"
'Sql = Sql & ",pwd"
'Sql = Sql & ",Case When memsort=0 Then '<font color=red>일반회원</font>' When memsort=1 Then '<font color=red>VIP회원</font>' End "
Sql = Sql & ",name"
Sql = Sql & ",birthday"
Sql = Sql & ",zipcode"
Sql = Sql & ",addr1"
Sql = Sql & ",addr2"
Sql = Sql & ",tel"
Sql = Sql & ",phone"
Sql = Sql & ",email"
Sql = Sql & ",Case When emailYN=0 Then '<font color=red>메일수신을 받지않습니다.</font>' Else '<font color=blue>메일수신을 받습니다.</font>' End "
'Sql = Sql & ",note"
Sql = Sql & ",regdate"
Sql = Sql & ",loginCnt"
Sql = Sql & ",lastLogin "
Sql = Sql & "from members WHERE idx IN("&chkidx&") order by idx desc"
Rs.Open Sql,dbcon,1

IF Rs.Bof Or Rs.Eof Then
	Response.Write ExecJavaAlert("검색된 회원이 없습니다.",0)
	Response.End
Else
	Allrec=Rs.GetRows()
End IF
Rs.Close

FieldData="<td>순번</td>"
FieldData=FieldData&"<td>아이디</td>"
'FieldData=FieldData&"<td>비밀번호</td>"
'FieldData=FieldData&"<td>회원등급</td>"
FieldData=FieldData&"<td>성명</td>"
FieldData=FieldData&"<td>생년월일</td>"
FieldData=FieldData&"<td>우편번호</td>"
FieldData=FieldData&"<td>주소1</td>"
FieldData=FieldData&"<td>주소2</td>"
FieldData=FieldData&"<td>전화번호</td>"
FieldData=FieldData&"<td>휴대폰번호</td>"
FieldData=FieldData&"<td>이메일</td>"
FieldData=FieldData&"<td>이메일수신여부</td>"
'FieldData=FieldData&"<td>기타내용</td>"
FieldData=FieldData&"<td>등록일</td>"
FieldData=FieldData&"<td>접속회수</td>"
FieldData=FieldData&"<td>최종접속일</td>"


WriteData = "<table border='1' cellspacing='0' cellpadding='3' bordercolor='#BDBEBD' style='border-collapse: collapse'><tr align='center' height='30' bgcolor='#E1E1E1'>"
WriteData = WriteData & FieldData
For i=0 To Ubound(Allrec,2)
	WriteData = WriteData & "<tr align='center' height='25'><td>"&i+1&"</td>"
	For j=0 To Ubound(Allrec)
		WriteData = WriteData & "<td>"&Allrec(j,i)&"</td>"
	Next
	WriteData = WriteData & "</tr>"
Next
WriteData = WriteData & "</table>"

Set Rs=Nothing
DBcon.Close
Set DBcon=Nothing

Response.ContentType  = "application/x-msexcel"
Response.CacheControl = "public"
Response.AddHeader "Content-Disposition","attachment;filename="&Server.URLPathEncode("회원리스트.xls")
Response.Write WriteData
%>