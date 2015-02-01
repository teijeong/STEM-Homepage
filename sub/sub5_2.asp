<!--#include virtual = common/dbcon.asp-->
<%
Dim Rs,Sql,Allrec
Dim Record_Cnt,TotalPage,PageSize,Page,Count
Dim Search,SearchStr,StrWhere,BBsSelectField
Dim BBsCode,strLocation,i
Dim BoardSort,BBsSort
Dim Idx,Filename(1),FilDownTag(1),souchk,AlertMsg
Dim title,writer,regdate,content,Ref,ReLevel,Pwd,TopYn,TopTag,ReadNum,PublicYN,inputPwd,UserIdx
Dim serboardsort
Dim PreTag,NextTag
Dim AdWrite,imgnames

bbscode=2
mode=Request("mode")
prePage="/sub/sub5_2.asp"
recordTitleCutNum=40

IF mode="write" Then
%><!--#include virtual = board/proc_boardwrite.asp--><%
ElseIF mode="view" Then
%><!--#include virtual = board/proc_boardview.asp--><%
ElseIF mode="modify" Then
%><!--#include virtual = board/proc_boardmodify.asp--><%
ElseIF mode="reply" Then
%><!--#include virtual = board/proc_boardreply.asp--><%
ElseIF mode="pwdinput" Then
%><!--#include virtual = board/proc_pwdinput.asp--><%
Else
%><!--#include virtual = board/proc_boardlist.asp--><%
End IF

Set Rs=Nothing
DBcon.Close
Set DBcon=Nothing
%>
{% extends "base.html" %}
{% block container %}
<div id="boardPwdINPUTDiv" name="boardPwdINPUTDiv" style="position:absolute; visibility:hidden;"></div>
<div id="boardcommentPwdINPUTDiv" name="boardcommentPwdINPUTDiv" style="position:absolute; visibility:hidden;"></div>
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
                    <li class="con_img">

                        <% IF mode="write" Then %>
                        <!--#include virtual = board/bbs_Write.asp-->
                        <% ElseIF mode="view" Then %>
                        <!--#include virtual = board/bbs_View.asp-->
                        <% ElseIF mode="modify" Then %>
                        <!--#include virtual = board/bbs_Modify.asp-->
                        <% ElseIF mode="reply" Then %>
                        <!--#include virtual = board/bbs_Reply.asp-->
                        <% ElseIF mode="pwdinput" Then %>
                        <!--#include virtual = board/bbs_pwdinput.asp-->
                        <% Else %>
                        <!--#include virtual = board/bbs_list.asp-->
                        <% End IF %>

                    </li>
                </ul>
            </div>
        </div>
    </div>
    <!--//container-->
{% endblock %}