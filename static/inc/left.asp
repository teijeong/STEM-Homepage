<!-- left -->
<% IF mNum="" Then mNum=Request("mNum") %>
<% IF mNum=1 Then %>
<div class="left">
	<div class="category">
		<dl>
		<dt><img src="/images/menu_tit1.gif" alt="" /></dt>
		<dd><a href="javascript:go_menu('sub1_1')" class="<% If sNum=1 Then %>on<% End If %>"><img src="/images/menu1_1.gif" alt="" /></a></dd>
		<dd><a href="javascript:go_menu('sub1_2')" class="<% If sNum=2 Then %>on<% End If %>"><img src="/images/menu1_2.gif" alt="" /></a></dd>
		<dd><a href="javascript:go_menu('sub1_3')" class="<% If sNum=3 Then %>on<% End If %>"><img src="/images/menu1_3.gif" alt="" /></a></dd>
		<dd><a href="javascript:go_menu('sub1_4')" class="<% If sNum=4 Then %>on<% End If %>"><img src="/images/menu1_4.gif" alt="" /></a></dd>
		<dd><a href="javascript:go_menu('sub1_5')" class="<% If sNum=5 Then %>on<% End If %>"><img src="/images/menu1_5.gif" alt="" /></a></dd>
		</dl>
	</div>
</div>
<% ElseIF mNum=2 Then %>
<div class="left">
	<div class="category">
		<dl>
		<dt><img src="/images/menu_tit2.gif" alt="" /></dt>
		<dd><a href="javascript:go_menu('sub2_1')" class="<% If sNum=1 Then %>on<% End If %>"><img src="/images/menu2_1.gif" alt="" /></a></dd>
		<dd><a href="javascript:go_menu('sub2_2')" class="<% If sNum=2 Then %>on<% End If %>"><img src="/images/menu2_2.gif" alt="" /></a></dd>
		<dd><a href="javascript:go_menu('sub2_3')" class="<% If sNum=3 Then %>on<% End If %>"><img src="/images/menu2_3.gif" alt="" /></a></dd>
		<dd><a href="javascript:go_menu('sub2_4')" class="<% If sNum=4 Then %>on<% End If %>"><img src="/images/menu2_4.gif" alt="" /></a></dd>
		<dd><a href="javascript:go_menu('sub2_5')" class="<% If sNum=5 Then %>on<% End If %>"><img src="/images/menu2_5.gif" alt="" /></a></dd>
		</dl>
	</div>
</div>
<% ElseIF mNum=3 Then %>
<div class="left">
	<div class="category">
		<dl>
		<dt><img src="/images/menu_tit3.gif" alt="" /></dt>
		<dd><a href="javascript:go_menu('sub3_1')" class="<% If sNum=1 Then %>on<% End If %>"><img src="/images/menu3_1.gif" alt="" /></a></dd>
		</dl>
	</div>
</div>
<% ElseIF mNum=4 Then %>
<div class="left">
	<div class="category">
		<dl>
		<dt><img src="/images/menu_tit4.gif" alt="" /></dt>
		<dd><a href="javascript:go_menu('sub4_1')" class="<% If sNum=1 Then %>on<% End If %>"><img src="/images/menu4_1.gif" alt="" /></a></dd>
		<dd><a href="javascript:go_menu('sub4_2')" class="<% If sNum=2 Then %>on<% End If %>"><img src="/images/menu4_2.gif" alt="" /></a></dd>
		<dd><a href="javascript:go_menu('sub4_3')" class="<% If sNum=3 Then %>on<% End If %>"><img src="/images/menu4_3.gif" alt="" /></a></dd>
		<dd class="sub4_3"><a href="javascript:go_menu('sub4_3')"><strong>- 후원해주시는 분들</strong></a></dd>
		<dd class="sub4_3_2"><a href="javascript:go_menu('sub4_3_2')"><strong>- 후원방법</strong></a></dd>
		</dl>
	</div>
</div>
<% ElseIF mNum=5 Then %>
<div class="left">
	<div class="category">
		<dl>
		<dt><img src="/images/menu_tit5.gif" alt="" /></dt>
		<dd><a href="javascript:go_menu('sub5_1')" class="<% If sNum=1 Then %>on<% End If %>"><img src="/images/menu5_1.gif" alt="" /></a></dd>
		<dd><a href="javascript:go_menu('sub5_2')" class="<% If sNum=2 Then %>on<% End If %>"><img src="/images/menu5_2.gif" alt="" /></a></dd>
		</dl>
	</div>
</div>
<% ElseIF mNum=6 Then %>
<div class="left">
	<div class="category">
		<dl>
		<dt><img src="/images/menu_tit6.gif" alt="" /></dt>
		<% IF Session("useridx")="" Then %>
		<dd><a href="javascript:go_menu('yak')" class="<% If sNum=1 Then %>on<% End If %>"><img src="/images/menu6_1.gif" alt="" /></a></dd>
		<% Else %>
		<dd><a href="javascript:go_menu('modify')" class="<% If sNum=3 Then %>on<% End If %>"><img src="/images/menu6_3.gif" alt="" /></a></dd>
		<dd><a href="javascript:go_menu('out')" class="<% If sNum=4 Then %>on<% End If %>"><img src="/images/menu6_4.gif" alt="" /></a></dd>
		<% End IF %>
		</dl>
	</div>
</div>
<% Else %>
<% End IF %>
<!-- //left -->