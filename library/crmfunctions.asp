<%
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
' Set Default Value
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
Sub SetDefault(Var, Value)
	if (Var = "") or isNull(Var) then
		Var = Value
	End if
End Sub

''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
' Open Database
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
Sub OpenDB()
	set fso = Server.CreateObject("Scripting.FileSystemObject")
	set f = fso.OpenTextFile("C:\ConnectString4Web\stem\stem.dat")
	StrConn = f.Readline

	Set Fso=Nothing
	Set F=Nothing
%><OBJECT RUNAT=Server PROGID=ADODB.Connection Id=Con></OBJECT><%
	Con.open StrConn
End Sub 

''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
' Get RecordSet
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
Sub GetRS(RecordSet, SQL)
	Set RecordSet = Con.Execute(SQL)
End Sub

''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
' Com Object Free and Null
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
Sub FreeAndNil(Com)
	Free(Com)
	Nil(Com)
End Sub

''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
' Com Object Free
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
Sub Free(Com)
	Com.Close
End Sub

''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
' Com Object Null
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
Sub Nil(Com)
	Set Com = Nothing
End Sub

''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
' Get PageControl RecordSet
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
Sub GetPage(RecordSet, SQL, PageSize)
	Set RecordSet = Server.CreateObject("ADODB.RECORDSET")
	RecordSet.PageSize = PageSize
	RecordSet.Open SQL, Con, adOpenStatic
End Sub

''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
' Check Null
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
Function ChkNull(Object)
	ChkNull = false
	
	if (isNull(Object) or (Object = "") or (Object = " ")) then
		ChkNull = true
	end if
End Function

''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
' Strings Replace Word Size
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
Function ReSize(String, ReLen)
	t = ReLen - Len(String)
	Do While not t <= 0
		String = "0" & String
		t = t - 1
	Loop
	
	ReSize = String
End Function

' ***************************************************************************************
' * 함수설명 : 자바스크립트 메시지 출력
' * 변수설명 : strMsg  = 출력메시지
' *            strExec = 스크립트 처리 (0:이전화면 / 1:창닫기 / 2:지정한URL / 3:스크립트)
' ***************************************************************************************
FUNCTION ExecJavaAlert(strMsg,strExec)
	DIM str
	str = "<script language=javascript>" & vbcrlf
	IF strMsg<>"" THEN str = str & "alert('" & strMsg & "');" & vbcrlf
	IF strExec = "0" THEN
		str = str & "history.back();" & vbcrlf
	ELSEIF strExec = "1" THEN
		str = str & "self.close();" & vbcrlf
	ELSEIF strExec = "2" THEN
		str = str & "location.href='"&strLocation&"';" &vbcrlf
	ELSEIF strExec = "3" THEN
		str = str & strLocation  &vbcrlf
	End IF
	ExecJavaAlert = str & "</script>" & vbcrlf
END FUNCTION
%>