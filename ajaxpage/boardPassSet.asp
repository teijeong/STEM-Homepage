<%@codepage="65001" language="VBScript"%>
<%
Session.CodePage = 65001
Response.CharSet = "utf-8"

with response
    .expires=-1
    .addheader "pragma","no-cache"
    .addheader "cache-control","no-cache"
end with

pwd=Request("pwd")

Session("boardPass")=pwd
%>