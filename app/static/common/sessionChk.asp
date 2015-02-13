<%
IF Session("useridx")="" Or Session("membership")=3 Then
    Response.Write "<SCRIPT LANGUAGE='JavaScript'>"&Vbcrlf
    Response.Write "<!--"&Vbcrlf
    Response.Write "alert('로그인이 필요한 페이지 입니다.\n로그인 처리후 다시 시도해주세요.');"&Vbcrlf
    Response.Write "history.back();;"&Vbcrlf
    'Response.Write "location.href='/index.asp';"&Vbcrlf
    Response.Write "//-->"&Vbcrlf
    Response.Write "</SCRIPT>"&Vbcrlf
    Response.End
End IF
%>