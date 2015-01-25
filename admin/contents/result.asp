<!--#include virtual = common/ADdbcon.asp-->
<%
Dim SpItemCnt

bansort=Request("bansort")
If bansort="" Then bansort=1

Sql="select idx,title,filenames from resultAdmin Where bansort="&bansort&" order by listnum ASC, idx desc"
Set Rs=Server.CreateObject("ADODB.RecordSet")
Rs.Open Sql,DBcon,1

IF Not(Rs.Bof Or Rs.Eof) Then Allrec=Rs.GetRows
Rs.Close

Set Rs=Nothing
DBcon.Close
Set DBcon=Nothing

Function PT_SpecialItemList()
	Dim i
	IF IsArray(Allrec) Then
		SpItemCnt=Ubound(Allrec,2)
		For i=0 To SpItemCnt
			Response.Write "<option value='"&Allrec(0,i)&"'>"&i+1&". "&Allrec(1,i)&"</option>"&vbcrlf
		Next
	End If
	IF SpItemCnt="" Then SpItemCnt=-1
End Function
%>

<!--#include virtual = admin/common/adminHeader.asp-->
<SCRIPT LANGUAGE="JavaScript">
<!--
function boardView(){
	if(document.goods_form.selcode.selectedIndex==-1){
		alert("수정하실 게시물을 선택하세요.");
		return;
	}
	idx=document.goods_form.selcode[document.goods_form.selcode.selectedIndex].value;
	openWindow(770,410,'resultEdit.asp?Idx='+idx,'add','yes')
}
function boardDel(){
	if(document.goods_form.selcode.selectedIndex==-1){
		alert("삭제하실 게시물을 선택하세요.");
		return;
	}
	var value=confirm("선택하신 게시물을 삭제하시겠습니까?");
	if(value){
		idx=document.goods_form.selcode[document.goods_form.selcode.selectedIndex].value;
		location.href='resultDel.asp?idx='+idx;
	}
}
function goAdd(){
	f=document.resultform;
	if(f.title.value==""){
		alert("이름을 입력하세요");
		f.title.focus();
		return;
	}
	if(f.note1.value==""){
		alert("학과를 입력하세요");
		f.note1.focus();
		return;
	}
	if(uploadImg_check(f.files.value,"이미지를 올바로 입력하세요.",1)==false){
		return;
	}
	document.resultform.submit();
}

//+++++++++++++++++++++++++++ 카테고리 선택에 따른 SELECTBOX 변경함수 끝 ++++++++++++++++++++++++++++++++

function move(temp) {
	cur_index = document.goods_form.selcode.selectedIndex;
	if (cur_index==-1) {
		alert("이동할 게시물을 선택하세요.");
		return;
	}
	if (temp=="up" && cur_index==0) {
		alert("선택하신 게시물은 더이상 위로 이동되지 않습니다.");
		return;
	}
	if (temp=="down" && cur_index==(document.goods_form.selcode.length-1)) {
		alert("선택하신 게시물은 더이상 아래로 이동되지 않습니다.");
	return;
	}
	if (temp=="up") index = cur_index-1;
	else if(temp=="down") index = cur_index+1;

	index_value = document.goods_form.selcode.options[index].value;
	index_text = document.goods_form.selcode.options[index].text;

	document.goods_form.selcode.options[index].value = document.goods_form.selcode.options[cur_index].value;
	document.goods_form.selcode.options[index].text = document.goods_form.selcode.options[cur_index].text;

	document.goods_form.selcode.options[cur_index].value = index_value;
	document.goods_form.selcode.options[cur_index].text = index_text;

	document.goods_form.selcode.selectedIndex = index;
	document.goods_form.ok.value="yes";
}

function move2top(){
	cur_index = document.goods_form.selcode.selectedIndex;
	if (cur_index==-1) {
		alert("이동할 게시물을 선택하세요.");
		return;
	}
	len=document.goods_form.selcode.length-1;
	index_value = document.goods_form.selcode.options[cur_index].value;
	index_text = document.goods_form.selcode.options[cur_index].text;
	for(i=cur_index;i>0;i--){
		document.goods_form.selcode.options[i].value=document.goods_form.selcode.options[i-1].value;
		document.goods_form.selcode.options[i].text=document.goods_form.selcode.options[i-1].text;
	}
	document.goods_form.selcode.options[0].value=index_value;
	document.goods_form.selcode.options[0].text=index_text;
	document.goods_form.selcode.selectedIndex=0;
	document.goods_form.ok.value="yes";
}

function move2bottom(){
	cur_index = document.goods_form.selcode.selectedIndex;
	if (cur_index==-1) {
		alert("이동할 게시물을 선택하세요.");
		return;
	}
	len=document.goods_form.selcode.length-1;
	index_value = document.goods_form.selcode.options[cur_index].value;
	index_text = document.goods_form.selcode.options[cur_index].text;
	for(i=cur_index;i<len;i++){
		document.goods_form.selcode.options[i].value=document.goods_form.selcode.options[i+1].value;
		document.goods_form.selcode.options[i].text=document.goods_form.selcode.options[i+1].text;
	}
	document.goods_form.selcode.options[len].value=index_value;
	document.goods_form.selcode.options[len].text=index_text;
	document.goods_form.selcode.selectedIndex=len;
	document.goods_form.ok.value="yes";
}

function movesend() {
	if (document.goods_form.ok.value!="yes") {
		alert("순서의 변동사항이 없습니다.");
		return;
	}
	if (!confirm("현재의 순서대로 저장하시겠습니까?")) return;
	temp = "";
	for (i=0;i<=(document.goods_form.selcode.length-1);i++) {
		if (i==0) temp = document.goods_form.selcode.options[i].value;
		else temp+=","+document.goods_form.selcode.options[i].value;
	}
	document.goods_form.selcodes.value = temp;
	document.goods_form.index.value=document.goods_form.selcode.length;
	document.goods_form.action="resultNumChangeOk.asp"
	document.goods_form.submit();
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
						<table cellpadding="0" cellspacing="0" class="menu" width="100%">
							<tr>
								<td style='color:#39518C;' class='menu'><img src='/admin/image/titleArrow2.gif'><b>PeoPle관리</td>
								<td align='right'>
									<select name='bansort' style='background-Color: #B0CEFF;' onchange="location.href='?bansort='+this.value;">
										<% For i=1 To 100%>
										<option value="<%=i%>" <%=selcheck(i,bansort)%>><%=i%>기 PeoPle 리스트</option>
										<% Next %>
									</select>
								</td>
							</tr>
						</table>
					</td>
				</tr>
				<tr>
					<td>

<form method="post" name="goods_form">
<input type='hidden' name='bansort' value='<%=bansort%>'>
<table border=0 cellpadding=0 cellspacing=1 bgcolor=#DADADA width=100% class='menu'>
	<tr bgcolor=#F6F6F6 height=30><td align=center><b><font color='red'>게시물</font> 목록</b></td></tr>
	<tr bgcolor=#FFFFFF><td align=center>
		<table border=0 cellpadding=3 cellspacing=0 class='menu' width='100%' style='table-layout:fixed;'>
		<colgroup>
		<col width='*'></col>
		<col width='195'></col>
		</colgroup>
			<tr>
				<td align=center valign=middle>
					<select name=selcode size=15 style="width:100%; font-size:11px;" multiple ondblclick='boardView()'>
					<%PT_SpecialItemList()%>
					</select>
				</td>
				<td valign='top'>
					<table cellpadding='0' cellspacing='0'>
						<tr>
							<td align='center'>
							<a href="JavaScript:move2top()"><img src="images/brcode_top.gif" border=0 style='vertical-align: middle;' alt="최상위로"></a>
							<a href="JavaScript:move('up')"><img src="images/xcode_up.gif" border=0 style='vertical-align: middle;' alt="위로"></a>
							<img src="images/xcode_sort.gif" style='vertical-align: middle;'>
							<a href="JavaScript:move('down')"><img src="images/xcode_down.gif" border=0 style='vertical-align: middle;' alt="아래로"></a>
							<a href="JavaScript:move2bottom()"><img src="images/brcode_bottom.gif" border=0 style='vertical-align: middle;' alt="최하위로"></a>
							</td>
						</tr>
						<tr>
							<td align='center' height='27'><input type='button' value='게시물 순서저장하기' class='button' style='width:100%; height:25px; background-color: #EBEBEB;' onclick='movesend()'></td>
						</tr>
						<tr>
							<td align='center' height='27'><input type='button' value='선택게시물 수정하기' class='button' style='width:100%; height:25px; background-color: #EBEBEB; color:blue;' onclick='boardView()'></td>
						</tr>
						<tr>
							<td align='center' height='27'><input type='button' value='선택게시물 삭제하기' class='button' style='width:100%; height:25px; background-color: #EBEBEB; color:red;' onclick='boardDel()'></td>
						</tr>
					</table>
				</td>
			</tr>
			<tr>
				<td colspan='2' align='right'>
					<font color='red'>TIP</font> - 좌측 항목을 더블클릭하거나 , 클릭후 우측 수정하기 버튼을 클릭하시면 수정페이지로 넘어갑니다.<br>
				</td>
			</tr>
		</table>
	</td></tr>
</table>
<input type='hidden' name='num' value="<%=SpItemCnt%>">
<input type='hidden' name='index'>
<input type='hidden' name='ok'>
<input type='hidden' name='selcodes'>
</form>

					</td>
				</tr>
				<tr><td height='10'></td></tr>
				<tr>
					<td>
<form name='resultform' method='post' ENCTYPE="multipart/form-data" action='resultOk.asp'>
<input type='hidden' name='bansort' value='<%=bansort%>'>
<table width="100%" border="1" cellpadding="0" cellspacing="0" bordercolor='#BDBEBD' class="menu" style='border-collapse: collapse'>
	<tr><td height='30' colspan='2' bgcolor='#EFEFEF' align='center'><b>게시물 추가</b></td></tr>
	<tr align="center">
		<td width='150' align="center" bgcolor="#F6F6F6">이름</td>
		<td align='left' style='padding: 5px;'><input type='text' name='title' style='width:100%;' class='input' maxlength='50'></td>
	</tr>
	<tr align="center">
		<td width='150' align="center" bgcolor="#F6F6F6">학과</td>
		<td align='left' style='padding: 5px;'><input type='text' name='note1' style='width:100%;' class='input' maxlength='50' value='<%=note1%>'></td>
	</tr>
	<tr align="center">
		<td width='150' align="center" bgcolor="#F6F6F6">이메일</td>
		<td align='left' style='padding: 5px;'><input type='text' name='email' style='width:100%;' class='input' maxlength='50' value='<%=email%>'></td>
	</tr>
	<tr align="center">
		<td width='150' align="center" bgcolor="#F6F6F6">Department</td>
		<td align='left' style='padding: 5px;'><input type='text' name='note2' style='width:100%;' class='input' maxlength='50' value='<%=note2%>'></td>
	</tr>
	<tr align="center">
		<td width='150' align="center" bgcolor="#F6F6F6">Awards & career</td>
		<td align='left' style='padding: 5px;'>
			<textarea name='content1' style='width:100%; height:70px;' class='input'></textarea>
		</td>
	</tr>
	<tr align="center">
		<td width='150' align="center" bgcolor="#F6F6F6">Commenets</td>
		<td align='left' style='padding: 5px;'>
			<textarea name='content2' style='width:100%; height:70px;' class='input'></textarea>
		</td>
	</tr>

	<tr align="center">
		<td align="center" bgcolor="#F6F6F6">이미지업로드</td>
		<td align='left' style='padding: 5px;'><input type='file' name='files' style='width:70%;' class='input'> 이미지 최적사이즈 230*280</td>
	</tr>
</table>
</form>
<div style='padding-top:10px; text-align:right'>
<input type='button' value='게시물 추가하기' class='btn' style='cursor:pointer; color:blue; width:120px;' onclick='goAdd()'>
</div>

					</td>
				</tr>
			</table>
		</td>
	</tr>
</table>
<!--#include virtual = admin/common/bottom.html-->