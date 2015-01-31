{% extends "base.html" %}
{% block container %}
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
					<li class="stit"><img src="/images/stit{{mNum}}_{{sNum}}.gif" alt="" /></li>
					<li class="con_img"><img src="/images/sub2_2.gif">
					<p style="padding-top:50px;"><img src="/images/sub2_2_2.gif"></p>
					<p style="padding-top:50px;"><img src="/images/sub2_2_3.gif"></p>
					<p style="padding-top:50px;"><img src="/images/sub2_2_4.gif"></p>
					</li>
				</ul>
			</div>
		</div>
	</div>
	<!--//container-->
{% endblock %}