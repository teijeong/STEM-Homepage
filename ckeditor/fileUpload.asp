<!--#include virtual = common/dbcon.asp-->
<%
' 변수들은 위에서 말한 개발자 가이드 문서에서 뽑았습니다.
' Required: anonymous function number as explained above.
funcNum = Request("CKEditorFuncNum")
'Optional: instance name (might be used to load specific configuration file or anything else)
CKEditor = Request("CKEditor")
' Optional: might be used to provide localized messages
langCode = Request("langCode")
' Check the jQuery_FILES array and save the file. Assign the correct path to some variable (jQueryurl).
'fileUrl = ""
' Usually you will assign here something only if file could not be uploaded.
'message = "성공적으로 파일 업로드"

DBcon.CLose
Set DBcon=Nothing
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<head>
<meta http-equiv="content-type" content="text/html; charset=utf-8">
<link rel="stylesheet" type="text/css" href="/css/shopstyle.css">
<script type="text/javascript" src="/ckeditor/jquery-1.2.2.pack.js"></script>
<script type="text/javascript" src="/ckeditor/jquery.menu.js"></script>
<script type="text/javascript" src="/library/prototype.js"></script>
<title>File Manager</title>

<style>
a{color: #005CA8; font-size:12px;}
a:visited{color: #005CA8; font-size:12px;}
a:hover{text-decoration:none; color: #005CA8; font-size:12px;}

#root-menu-div ul {
	border: 1px solid #000;
}
#root-menu-div li{
	white-space:nowrap; padding: 2px; background-color: #E7E7E7;
}
ul.menu,
#root-menu-div ul {
	background-color: #fff;
	list-style: none;
	margin: 0;
	padding: 0;
}
</style>
</head>

<SCRIPT LANGUAGE="JavaScript">
<!--
function layerview(str,filestr){
	var options = {minWidth: 90, arrowSrc: ''};
	var menu = new jQuery.Menu('#'+str+'', null, options);
	menu.addItems([
		new jQuery.MenuItem({src: '파일선택', url :"javascript:fileSelect('"+filestr+"');"}, options),
		new jQuery.MenuItem({src: '다운로드', url:"/common/download.asp?downfile="+filestr+"&path=editordata"}, options),
		new jQuery.MenuItem({src: '삭제', url:"javascript:fileDel('"+filestr+"');"}, options)
	]);
}

function fileDownload(filestr){
	var val=confirm("해당파일을 다운로드 받으시겠습니까?");
	if(val){
		document.actFrm.filename.value=filestr;
		document.actFrm.action='fileDownLoad.asp';
		document.actFrm.submit();
	}
}

function fileSelect(filestr){
	window.opener.CKEDITOR.tools.callFunction('<%=funcNum%>', '/upload/editordata/'+filestr,'')
	self.close();
}

function fileDel(filestr){
	var val=confirm("파일을 삭제하면 해당파일을 사용하는 모든 컨텐츠에서 사용이 중지됩니다\n해당파일을 삭제하시겠습니까?");
	if(val){
		document.actFrm.filename.value=filestr;
		document.actFrm.action='fileDel.asp';
		document.actFrm.submit();
	}
}

function filesendit() {
	if(document.fileaddFrm.AttachFile.value==""){
		alert("업로드할 파일을 입력해주세요");
		return;
	}
	document.fileaddFrm.submit();
}
function viewArea(spacestr,page){
	var params = "page="+page;
	new Ajax.Updater('fileDiv', 'fileList.asp', { method:'post',evalScripts:true, encoding : 'utf-8', parameters:params });
}
//-->
</SCRIPT>

<body topmargin='0' leftmargin='0'>
<table width="100%" border="0" cellspacing="0" cellpadding="0" class="menu" align="center">
<form name='actFrm' action='' method='post' target='iframes'>
	<input type='hidden' name='filename'>
	<input type='hidden' name='page' value='<%=Page%>'>
</form>
	<tr>
		<td align='center'>
			<form name="fileaddFrm" method="post" action="FileUploadOK.asp" enctype="multipart/form-data" target='iframes'>
			<table border='0' cellspacing='0' cellpadding='0' class='menu' height='30' width='100%'>
				<tr><td height='3' bgcolor='#00647C'></td></tr>
				<tr>
					<td align='center' bgcolor='#00A0C6' height='30' style='font-weight:bold; color:#FFFFFF'>HTML EDITOR FILE MANAGER</td>
				</tr>
				<tr><td height='1' bgcolor='#00647C'></td></tr>
				<tr>
					<td align='right' bgcolor='#F7EFEF' height='30' style='padding-right:5px;'>
						<img src='/ckeditor/images/fileMannagerUpload.gif' align='absmiddle'>
						<input type="file" size="37" name="AttachFile" class="input">
						<img src='/ckeditor/images/fileManngerBtnUpload.gif' align='absmiddle' style='cursor:pointer;' onclick='filesendit()'>
					</td>
				</tr>
				<tr><td height='1' bgcolor='#C3C3C3'></td></tr>
			</table>
			</form>
			<iframe name='iframes' frameborder='0' width='100%' height='0'></iframe>
		</td>
	</tr>
	<!--========================== 파일찾기 필드 ================================================================-->
	<tr>
		<td>
			<div id='fileDiv'></div>
			<SCRIPT LANGUAGE="JavaScript">viewArea('','')</SCRIPT>
		</td>
	</tr>
	<!--=====================================================================================================-->
</table>
</body>
</html>