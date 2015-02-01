<!--#include virtual = common/dbcon.asp-->
<%
bansort=checkParameter("int",Request("bansort"))
Search=checkParameter("char",Request("Search"))
SearchStr=checkParameter("char",Request("SearchStr"))
IF bansort="" Then bansort=1

Page=GetPage()
PageSize=5

Sql="select top "&PageSize&" idx,title,filenames,bansort,note1,note2,content1,content2,email from resultadmin WHERE bansort=? AND idx NOT IN (select top "&(Page-1)*PageSize&" idx from resultadmin Where bansort=? order by listnum ASC, Idx DESC) order by listnum ASC, Idx DESC; select count(idx) from resultadmin Where bansort=?"
Set objCmd = Server.CreateObject("ADODB.Command")
With objCmd
    .ActiveConnection = DBcon
    .CommandType = adCmdText
    .CommandText = Sql
    
    .Parameters.Append .CreateParameter("@Par", adBigint, adParamInput, 8, bansort)
    .Parameters.Append .CreateParameter("@Par", adBigint, adParamInput, 8, bansort)
    .Parameters.Append .CreateParameter("@Par", adBigint, adParamInput, 8, bansort)
End With
Set Rs = objCmd.Execute()
Set objCmd = Nothing

IF Not(Rs.Bof Or Rs.Eof) Then
    Allrec=Rs.GetRows
    Record_Cnt=Rs.NextRecordSet
    TotalPage=Int((CInt(Record_Cnt(0))-1)/CInt(PageSize)) +1
    Count=Record_Cnt(0)
Else
    Count=0
End IF

Sql="SELECT bansort FROM resultadmin Group By bansort Order by bansort ASC"
Set Rs=DBcon.Execute(Sql)
IF Not(Rs.Bof Or Rs.Eof) Then YearRec=Rs.GetRows()
Rs.Close

Set Rs=Nothing
DBcon.Close
Set DBcon=Nothing

Function PT_SelectBox()
    IF IsArray(YearRec) Then
        For i=0 To UBound(YearRec,2)
            Response.Write "<option value='"&YearRec(0,i)&"' "&selCheck(YearRec(0,i),bansort)&">"&YearRec(0,i)&"기</option>"
        Next
    End IF
End Function

Function PT_ItemList()
    Dim i,k,ThumbFileName,tmpFileName

    IF IsArray(Allrec) Then
        For i=0 To UBound(Allrec,2)
            ImgTag="" : MainIcon=""

            IF Allrec(2,i)="" OR IsNull(Allrec(2,i)) Then
                ImgTag="<img src='/images/noPic.gif' border='0' width='230' height='280' align='center'>"
            Else
                thumbFileName=getImageThumbFilename(Allrec(2,i))
                ImgTag="<img src='/upload/result/"&thumbFileName&"' border='0' "&imgPerSize("result",230,280,thumbFileName)&" align='center'>"
            End IF

            IF Allrec(8,i)<>"" Then MainIcon="<a href=""mailto:"&Allrec(8,i)&"""><img src=""/images/ico_mail.gif"" style=""margin-top:-6px"" /></a>"
'idx,title,filenames,bansort,note1,note2,content1,content2,email

            Response.WRite "<li>"&Vbcrlf
            Response.WRite "    <div class=""thum"">"&ImgTag&"</div>"&Vbcrlf
            Response.WRite "    <dl>"&Vbcrlf
            Response.WRite "    <dt>"&Allrec(1,i)&" ("&Allrec(4,i)&", "&Allrec(3,i)&") "&MainIcon&"</dt>"&Vbcrlf
            Response.WRite "    <dd><span>Department</span><em style='word-wrap:break-word; line-height:1.4'>"&Allrec(5,i)&"</em></dd>"&Vbcrlf
            Response.WRite "    <dd><span>Awards & career</span><em style='word-wrap:break-word; line-height:1.4'>"&ReplaceBr(Allrec(6,i))&"</em></dd>"&Vbcrlf
            Response.WRite "    <dd><span>Commenets</span><em style='word-wrap:break-word; line-height:1.4'>"&ReplaceBr(Allrec(7,i))&"</em></dd>"&Vbcrlf
            Response.WRite "    </dl>"&Vbcrlf
            Response.WRite "</li>"&Vbcrlf
        Next
    Else
        Response.WRite "<li>검색된 게시물이 없습니다.</li>"&Vbcrlf
    End IF
End Function
%>

{% extends "base.html" %}
{% block container %}
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
                        <div class="board_search">
                            <select name="bansort" class="" onchange="location.href='?bansort='+this.value">
                            <option selected> - 기수선택 - </option>
                            <%=PT_SelectBox()%>
                            </select>
                        </div>
                        <ul class="people">
                        <%=PT_ItemList()%>
                        </ul>
                        <center><div><%=PT_SpPageLink("","bansort="&bansort,"")%></div></center>
                    </li>
                </ul>
            </div>
        </div>
    </div>
    <!--//container-->
{% endblock %}