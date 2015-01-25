<table width="100%" align="center" cellpadding="0" cellspacing="0">
  <tr>
	<td align="center" style="padding:25px;">

		<form name='passFrm' id='passFrm' method='post' action='' style='margin:0;' onSubmit="boardcheckpwd('<%=Sort%>');return false;" >
		<% IF Sort="bbsdel" Then %>
		<div style='padding-bottom:15px; font-size:12px;'>해당글을 지우시겠습니까? 한번 삭제하게되면 복구할 수 없습니다.<br />
		삭제를 원하시면 해당글의 비밀번호를 입력해주십시오.</div>
		<% ElseIF Sort="view" Then %>
		<div style='padding-bottom:15px; font-size:12px;'>비밀글입니다.<br />
		확인을 원하시면 해당글의 비밀번호를 입력해주십시오.</div>
		<% Else %>
		<div style='padding-bottom:15px; font-size:12px;'>해당글을 수정하시겠습니까?<br />
		수정을 원하시면 해당글의 비밀번호를 입력해주십시오</div>
		<% End IF %>
		<strong style='font-size:12px;'>비밀번호</strong>
		<input type="password" size='30' name='pwd' style='height:18px; margin:0; padding:0; border:1px solid #9D9D9D' />

		<div style='text-align:center; padding-top:10px;'>
			<input type='button' value='확인' class='button1' onclick='boardcheckpwd("<%=Sort%>");' style='cursor:pointer; width:50px;'>
			<input type='button' value='취소' class='button1' onclick='history.back();' style='cursor:pointer; width:50px;'>
		</div>
		</form>

	</td>
  </tr>
</table>

<form name='boardActfrm' id='boardActfrm' method='get' action='' style='margin:0;'>
<input type='hidden' name='mode'>
<input type='hidden' name='idx' value='<%=idx%>'>
<input type='hidden' name='Page' value='<%=Page%>'>
<input type='hidden' name='BBSCode' value='<%=BBSCode%>'>
<input type='hidden' name='serboardsort' value='<%=serboardsort%>'>
<input type='hidden' name='Search' value='<%=Search%>'>
<input type='hidden' name='SearchStr' value='<%=SearchStr%>'>
<input type='hidden' name='prepage' value='<%=prepage%>'>
<input type='hidden' name='storeidx' value='<%=storeidx%>'>
</form>