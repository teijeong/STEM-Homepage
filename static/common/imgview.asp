<%@codepage="65001" language="VBScript"%>
<%
Session.CodePage = 65001
Response.CharSet = "utf-8"

Dim imgname,myImg,Width,height,Path,ImgUrl
Path=Request("Path")
Imgname=Request("imgname")
ImgUrl=Server.MapPath("/upload/"&Path)&"/"&ImgName

Set MyImg = LoadPicture(Imgurl)
Width = Round(MyImg.Width / 26.4583) 
Height = Round(MyImg.Height / 26.4583)
Set MyImg=Nothing
%>
<html>
<head>
<meta http-equiv=content-type content=text/html;charset=utf-8>
<title>이미지보기</title>
<style type="text/css">
<!--
td {font-size:9pt; font-family: 굴림;}
-->
</style>
<script language="JavaScript">
 function resize() {

	if(screen.availHeight-100 > <%=height%>){
		winHeight = <%=height%> + 100;
	}else{
		winHeight = screen.availHeight - 100;
	}

	if(screen.availWidth-40 > <%=width%>){
		winWidth = <%=width%> + 40;
	}else{
		winWidth = screen.availWidth-40;
	}

	var winPosLeft = (screen.width - winWidth) / 2; // 새창 Y 좌표
	var winPosTop = (screen.height - winHeight) / 2; // 새창 X 좌표

	window.moveTo(winPosLeft,winPosTop);
    window.resizeTo(winWidth,winHeight);

//screen.availWidth
//screen.availHeight
 }
</script>
</head>
<body onload="resize()"  topmargin=10 leftmargin=0 marginheight = 0 marginwidth = 0 >
<table border=0 cellpadding=0 cellspacing=0 align=center width='100%' height='100%'>
<tr><td align='center' valign='middle'><a href="JavaScript:window.close();"><img src="<%="/upload/"&Path&"/"&Imgname%>" border=0></a></td></tr>
</table>
</body>
</html>