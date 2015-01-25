<!--#include virtual = common/ADdbcon.asp-->
<%
Dim Idx,Sort,StartDate,EndDate,WSize,HSize,Title,Content,HtmlYN,LinkUrl,OutputImg,Rs
Dim S_Year,S_Mon,S_Day,E_Year,E_Mon,E_Day
Idx=Request("idx")

Set Rs=DBcon.Execute("FM_AP_PopupView("&Idx&")")

Sort=Rs(0) : StartDate=Rs(1) : EndDate=Rs(2) : WSize=Rs(3) : HSize=Rs(4) : Title=ReplaceTextField(Rs(5))
HtmlYN=Rs(7) : LinkUrl=Rs(8) : OutputImg=Rs(9) : Content=ReplaceNoHtml(Rs(6))
pTop=Rs(10) : pLeft=Rs(11) : popSort=Rs(12) : temcode=Rs(13)

Set Rs=Nothing
DBcon.Close
Set DBcon=Nothing

Function PT_JavaScript
	Response.Write "<SCRIPT LANGUAGE='JavaScript'>"&Vbcrlf
	Response.Write "var form=document.popup_form ;"&Vbcrlf
	Response.Write "form.sort["&Sort&"].checked=true;"&Vbcrlf
	Response.Write "</SCRIPT>"&Vbcrlf
End Function
%>

<!--#include virtual = admin/common/adminHeader.asp-->
<script type="text/javascript" src="/library/datepicker.js"></script> 
<link type="text/css" href="/library/datepicker.css" rel="stylesheet" />
<script type="text/javascript">
jQuery(function() {
	jQuery("#datepicker1").datepicker();
	jQuery("#datepicker2").datepicker();
});
</script>	
<SCRIPT language=JavaScript src="/ckeditor/ckeditor.js" type='text/javascript'></SCRIPT>
<SCRIPT LANGUAGE="JavaScript">
<!--
function popup_view(){
	form=document.popup_form ;
	if(form.sort[0].checked){
		document.all.view[0].style.display="none";
		document.all.view[1].style.display="none";
		document.all.view[2].style.display="none";
		document.all.view[3].style.display="";
		alditorById("content")
	}
	else if(form.sort[1].checked){
		document.all.view[0].style.display="";
		document.all.view[1].style.display="";
		document.all.view[2].style.display="";
		document.all.view[3].style.display="none";
	}
}

function sendit(){
	var form=document.popup_form;
	if(form.searchDate1.value==false){
		alert("시작일을 입력해주세요.");
		return;
	}
	if(form.searchDate2.value==false){
		alert("종료일을 입력해주세요.");
		return;
	}
	if(form.pop_w.value==false){
		alert("가로사이즈를 입력하세요.");
		form.pop_w.focus();
		return;
	}
	if(form.pop_h.value==false){
		alert("세로사이즈를 입력하세요.");
		form.pop_h.focus();
		return;
	}
	if(form.pop_title.value==""){
		alert("브라우져 타이틀을 입력하세요.");
		form.pop_title.focus();
		return;
	}
	if(form.sort[1].checked && form.files.value==""){
		if(form.imgDel_Chk.checked){
			alert("출력이미지를 선택하세요.");
			return;
		}
	}
	document.getElementById("pop_w").disabled=false;
	document.getElementById("pop_h").disabled=false;
	form.submit();
}
function changePopsort(str){
	if(str=="2"){
		document.getElementById("pop_w").disabled=true;
		document.getElementById("pop_w").style.background='#eeeeee';
		document.getElementById("pop_h").disabled=true;
		document.getElementById("pop_h").style.background='#eeeeee';
		document.getElementById("sort2").disabled=true;
		document.getElementById("sort1").checked=true;
		document.getElementById("tempListDiv").style.display="inline";
		popup_view();
		changeTempPopSize();
	}else{
		document.getElementById("pop_w").disabled=false;
		document.getElementById("pop_w").style.background='#ffffff';
		document.getElementById("pop_h").disabled=false;
		document.getElementById("pop_h").style.background='#ffffff';
		document.getElementById("sort2").disabled=false;
		document.getElementById("tempListDiv").style.display="none";
	}
}
function changeTempPopSize(){
	if(document.getElementById("temCode1").checked){
		document.getElementById("pop_w").value="350";
		document.getElementById("pop_h").value="400";
	}else if(document.getElementById("temCode2").checked){
		document.getElementById("pop_w").value="350";
		document.getElementById("pop_h").value="400";
	}else if(document.getElementById("temCode3").checked){
		document.getElementById("pop_w").value="350";
		document.getElementById("pop_h").value="455";
	}else if(document.getElementById("temCode4").checked){
		document.getElementById("pop_w").value="600";
		document.getElementById("pop_h").value="485";
	}else if(document.getElementById("temCode5").checked){
		document.getElementById("pop_w").value="400";
		document.getElementById("pop_h").value="500";
	}else if(document.getElementById("temCode6").checked){
		document.getElementById("pop_w").value="400";
		document.getElementById("pop_h").value="500";
	}else if(document.getElementById("temCode7").checked){
		document.getElementById("pop_w").value="400";
		document.getElementById("pop_h").value="500";
	}else if(document.getElementById("temCode8").checked){
		document.getElementById("pop_w").value="393";
		document.getElementById("pop_h").value="373";
	}else if(document.getElementById("temCode9").checked){
		document.getElementById("pop_w").value="530";
		document.getElementById("pop_h").value="565";
	}else if(document.getElementById("temCode10").checked){
		document.getElementById("pop_w").value="400";
		document.getElementById("pop_h").value="456";
	}
}
//-->
</SCRIPT>

<!--#include virtual = admin/common/topimg.htm-->

<table border="0" cellpadding="0" cellspacing="0" align="center" width='100%'>
<colgroup>
<col width='200'></col>
<col width='*'></col>
</colgroup>
	<tr>
		<td valign="top"><!--#include virtual = admin/common/menubar.asp--></td>
		<td valign="top" style='padding-left:10px;'>
			<table cellpadding="2" cellspacing="0" width='880'>
				<tr>
					<td>
					<table width='100%' border="0" cellspacing="0" cellpadding="0">
						<tr>
							<td style='color:#39518C;' class='menu'><img src='/admin/image/titleArrow2.gif'><b>팝업수정</td>
						</tr>
					</table>
					</td>
				</tr>
				<tr>
					<td>

						<form action="popup_edit_ok.asp" method="post" name="popup_form" enctype="multipart/form-data" style='margin:0'>
						<input type='hidden' name='idx' value=<%=Idx%>>
						<table width='100%' border="1" cellspacing="0" cellpadding="3" class="menu" bordercolor='#BDBEBD' style='border-collapse: collapse; table-layout:fixed;'>
							<tr>
								<td width="120" align="center" bgcolor="#EFEFEF">팝업종류</td>
								<td>
									<input type="radio" name="popSort" value="0" checked onclick='changePopsort(0);' <%=ChangeChecked(0,popSort)%>>일반팝업
									<input type="radio" name="popSort" value="1" onclick='changePopsort(1);' <%=ChangeChecked(1,popSort)%>>레이어팝업
									<input type="radio" name="popSort" value="2" onclick='changePopsort(2);' <%=ChangeChecked(2,popSort)%>>레이어팝업_템플릿
									
									<div style='display:none;' id='tempListDiv'>
										<center>
										<li class='poplisting'><img src='./images/pop1.gif'><div class='f_tahoma'><input type='radio' name='temCode' id='temCode1' value='1' onclick='changeTempPopSize()' <%=ChangeChecked(1,temCode)%>> Type1</div></li>
										<li class='poplisting'><img src='./images/pop2.gif'><div class='f_tahoma'><input type='radio' name='temCode' id='temCode2' value='2' onclick='changeTempPopSize()' <%=ChangeChecked(2,temCode)%>> Type2</div></li>
										<li class='poplisting'><img src='./images/pop3.gif'><div class='f_tahoma'><input type='radio' name='temCode' id='temCode3' value='3' onclick='changeTempPopSize()' <%=ChangeChecked(3,temCode)%>> Type3</div></li>
										<li class='poplisting'><img src='./images/pop4.gif'><div class='f_tahoma'><input type='radio' name='temCode' id='temCode4' value='4' onclick='changeTempPopSize()' <%=ChangeChecked(4,temCode)%>> Type4</div></li>
										<li class='poplisting'><img src='./images/pop5.gif'><div class='f_tahoma'><input type='radio' name='temCode' id='temCode5' value='5' onclick='changeTempPopSize()' <%=ChangeChecked(5,temCode)%>> Type5</div></li>
										<li class='poplisting'><img src='./images/pop6.gif'><div class='f_tahoma'><input type='radio' name='temCode' id='temCode6' value='6' onclick='changeTempPopSize()' <%=ChangeChecked(6,temCode)%>> Type6</div></li>
										<li class='poplisting'><img src='./images/pop7.gif'><div class='f_tahoma'><input type='radio' name='temCode' id='temCode7' value='7' onclick='changeTempPopSize()' <%=ChangeChecked(7,temCode)%>> Type7</div></li>
										<li class='poplisting'><img src='./images/pop8.gif'><div class='f_tahoma'><input type='radio' name='temCode' id='temCode8' value='8' onclick='changeTempPopSize()' <%=ChangeChecked(8,temCode)%>> Type8</div></li>
										<li class='poplisting'><img src='./images/pop9.gif'><div class='f_tahoma'><input type='radio' name='temCode' id='temCode9' value='9' onclick='changeTempPopSize()' <%=ChangeChecked(9,temCode)%>> Type9</div></li>
										<li class='poplisting'><img src='./images/pop10.gif'><div class='f_tahoma'><input type='radio' name='temCode' id='temCode10' value='10' onclick='changeTempPopSize()' <%=ChangeChecked(10,temCode)%>> Type10</div></li>
										</center>
									</div>
								</td>
							</tr>
							<tr>
								<td width="120" align="center" bgcolor="#EFEFEF">형태선택</td>
								<td>
									<input type="radio" name="sort" id='sort1' value="0" checked onclick="popup_view();">HTML
									<input type="radio" name="sort" id='sort2' value="1" onclick="popup_view();">단일이미지
								</td>
							</tr>
							<tr>
								<td align="center" bgcolor="#EFEFEF">시작일/종료일</td>
								<td>
									<input type='text' name='searchDate1' size='10' class='input' readonly id="datepicker1" value='<%=StartDate%>'> ~
									<input type='text' name='searchDate2' size='10' class='input' readonly id="datepicker2" value='<%=EndDate%>'>
								</td>
							</tr>
							<tr>
								<td align="center" bgcolor="#EFEFEF">팝업창 사이즈</td>
								<td>
									<input type="text" name="pop_w" id='pop_w' size="4" maxlength="4" class="input" ONkeyup="check_value(this);" onKeyPress='if( (event.keyCode<48) || (event.keyCode>57) ) event.returnValue=false;' style='text-align: right; color: #FF0000;IME-MODE:disabled;' value='<%=WSize%>'> 가로 x
									<input type="text" name="pop_h" id='pop_h' size="4" maxlength="4" class="input" ONkeyup="check_value(this);" onKeyPress='if( (event.keyCode<48) || (event.keyCode>57) ) event.returnValue=false;' style='text-align: right; color: #FF0000;IME-MODE:disabled;' value='<%=HSize%>'> 세로 (새로운 창의 크기를 설정해주세요.)
								</td>
							</tr>
							<tr>
								<td align="center" bgcolor="#EFEFEF">팝업창 위치</td>
								<td>
									<input type="text" name="pLeft" size="4" maxlength="4" class="input" onKeyPress='if( (event.keyCode<48) || (event.keyCode>57) ) event.returnValue=false;' style='text-align: right; color: #FF0000;IME-MODE:disabled;' value='<%=pLeft%>'> 좌측 x
									<input type="text" name="pTop" size="4" maxlength="4" class="input" onKeyPress='if( (event.keyCode<48) || (event.keyCode>57) ) event.returnValue=false;' style='text-align: right; color: #FF0000;IME-MODE:disabled;' value='<%=pTop%>'> 상단
								</td>
							</tr>
							<tr>
								<td align="center" bgcolor="#EFEFEF">브라우져 타이틀</td>
								<td><input type="text" name="pop_title" size="60" class="input" value='<%=Title%>' maxlength='50'> 간략한설명</td>
							</tr>

							<tr id="view" style="display:none;">
								<td align="center" bgcolor="#EFEFEF">링크 URL</td>
								<td>HTTP:// <input type="text" name="link_url" size="40" class="input" value='<%=LinkUrl%>' maxlength='100'></td>
							</tr>
							<tr id="view" style="display:none;">
								<td align="center" bgcolor="#EFEFEF">출력이미지</td>
								<td>
									<input name="files" type="file" class="input" size="40">
								<% IF OutputImg<>"" Then %>
									<img src='/admin/image/icon/bt_view.gif' border='0' align='absmiddle' onclick="openWindow(0,0,'/common/imgview.asp?path=popup&imgname=<%=OutputImg%>','imgview','no');" style='cursor:pointer;'>
								<% End IF %>
									<input type='hidden' name='imgname' value="<%=OutputImg%>">
									<input type='checkbox' name='imgDel_Chk' style='border:none;'> 이미지변경여부
								</td>
							</tr>
							<tr id="view" style="display:none;">
								<td colspan="2" align="center">* 링크URL을 입력하시면 팝업창 이미지 클릭시 해당 페이지로 이동합니다.</td>
							</tr>
							<tr id="view" style="display:none;">
								<td align="center" bgcolor="#EFEFEF">출력내용</td>
								<td align="center">
									<textarea name='content' id='content' style='width:100%; word-break:break-all;' rows='13' class='ckeditor'><%=Content%></textarea>
								</td>
							</tr>
						</table>
						
						<br>
						<div style='text-align:center;'><a href="javascript:sendit();"><img src="../image/icon/bt_save.gif" width="139" height="36" border="0"></a></div>
						<br>
						</form>



					</td>
				</tr>
			</table>
		</td>
	</tr>
</table>

<!--#include virtual = admin/common/bottom.html-->
</html>

<%PT_JavaScript%>
<SCRIPT LANGUAGE="JavaScript">
<!--
form=document.popup_form ;
if(form.sort[0].checked){
	document.all.view[0].style.display="none";
	document.all.view[1].style.display="none";
	document.all.view[2].style.display="none";
	document.all.view[3].style.display="";
}
else if(form.sort[1].checked){
	document.all.view[0].style.display="";
	document.all.view[1].style.display="";
	document.all.view[2].style.display="";
	document.all.view[3].style.display="none";
}
changePopsort(<%=popSort%>);
//-->
</SCRIPT>