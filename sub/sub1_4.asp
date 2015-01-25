<!--#include virtual = "/inc/body.asp"-->
<% mNum=1 : sNum=4 %>
<!--#include virtual = "/inc/top.asp"-->
	<!--container-->
	<div id="container">
		<div class="contain">
			<div class="s_contents">
				<!--#include virtual = "/inc/right_login.asp"-->
				<!--#include virtual = "/inc/left.asp"-->
			</div>
			<div class="con">
				<ul>
					<li class="stit"><img src="/images/stit<%=mNum%>_<%=sNum%>.gif" alt="" /></li>
					<li class="con_img"><iframe id="contentFrame" name="contentFrame" src="http://www.snu.ac.kr/campus/Gwanak/subway" marginwidth="0" marginheight="0" frameborder="0" width="718" height="3000" scrolling="no"></iframe></li>
				</ul>
			</div>
		</div>
	</div>
	<!--//container-->
<!--#include virtual = "/inc/footer.asp"-->