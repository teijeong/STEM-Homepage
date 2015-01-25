<!-- #include virtual = common/dbcon.asp -->
<%
C_Year=Request("c_year")
C_Month=Request("c_month")

IF C_Year="" Then
	C_Year = Year(Now)
	C_Month = Month(Now)
End IF

IF MemberChkYN<>"0" Then
	Set cmd=CreateCommand(dbcon,"UP_Calendar",adCmdStoredProc)
	With cmd
		.Parameters.Append CreateInputParameter("@Date",adChar,7,C_Year&"-"&AddZero(C_Month))
		Set Rs=.execute
	End With

	IF Not(Rs.Bof Or Rs.Eof) Then Allrec=Rs.GetRows()
	Set Rs = Rs.NextRecordset
	IF Not(Rs.Bof Or Rs.Eof) Then Allrec1=Rs.GetRows()

	Rs.Close()
	Set Rs=Nothing
End IF

Function PT_Calendar()
	IF IsArray(Allrec) Then
		For i=0 TO Ubound(Allrec,2)
			Response.write "<tr>"&Vbcrlf
			For j=0 To Ubound(Allrec)
				IF IsNull(Allrec(j,i)) Then
					Response.write "	<td>&nbsp;</td>"&vbcrlf
				Else

					DateColor=""
					IF j=0 Then
						DateColor="red"
					ElseIF j=6 Then
						DateColor="blue"
					End IF

					IF Allrec1(0,Cint(Allrec(j,i))-1)="" Then
						Response.write "	<td valign='top' align='left'><div style='color: "&DateColor&"'>"&Cint(Allrec(j,i))&"</div> <div style='word-wrap:break-word; word-break:break-all; font-size:11px; line-height:1.1;' class='daycont'>"&ChangeCalendarStr(Allrec1(0,Cint(Allrec(j,i))-1))&"</div></td>"&vbcrlf
					Else
						Response.write "	<td valign='top' align='left' class='bg'><div style='color: "&DateColor&"'>"&Cint(Allrec(j,i))&"</div> <div style='word-wrap:break-word; word-break:break-all; font-size:11px; line-height:1.1;' class='daycont'>"&ChangeCalendarStr(Allrec1(0,Cint(Allrec(j,i))-1))&"</div></td>"&vbcrlf
					End IF
				End IF
			Next
			Response.write "</tr>"&Vbcrlf
		Next
	End IF
End Function
%>
<table cellpadding='0' cellspacing='0' width='100%' align='center'>
	<tr>
		<td valign='top'>
			<div id="calendarDetailDiv" name="calendarDetailDiv" style="position:absolute; visibility:hidden;"></div>



<table border="1" cellspacing="1" summary="" class="cal_simple">
  <colgroup>
	<col width='14%' />
	<col width='14%' />
	<col width='14%' />
	<col width='14%' />
	<col width='14%' />
	<col width='14%' />
	<col width='14%' />
  </colgroup>
	<caption>
		<a href="javascript:calendarGo(-1,<%=C_Year%>,<%=C_Month%>)"><img src="/images/btn_c_prev.gif" alt="" /></a>
		<strong><%=C_Year%>.<%=AddZero(C_Month)%></strong>
		<a href="javascript:calendarGo(1,<%=C_Year%>,<%=C_Month%>)"><img src="/images/btn_c_next.gif" alt="" /></a>
	</caption>
  <thead>
	<tr>
	  <th class="day" scope='col'>일</th>
	  <th class="day" scope='col'>월</th>
	  <th class="day" scope='col'>화</th>
	  <th class="day" scope='col'>수</th>
	  <th class="day" scope='col'>목</th>
	  <th class="day" scope='col'>금</th>
	  <th class="day" scope='col'>토</th>
	</tr>
  </thead>
  <tbody>
    <% PT_Calendar %>
  </tbody>
</table>