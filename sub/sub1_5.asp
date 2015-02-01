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
                    <li class="con_img"><img src="/images/sub1_5.gif"></li>
                </ul>
            </div>
        </div>
    </div>
    <!--//container-->
{% endblock %}