<!--#include virtual = common/dbcon.asp-->
<%
ItemIdx=Request("ItemIdx")
Page=GetPage()
PageSize=6

Sql="select top "&PageSize&" imgname FROM ProductDetailImg WHERE itemidx="&ItemIdx&" AND idx NOT IN (select top "&(Page-1)*PageSize&" idx from ProductDetailImg WHERE itemidx="&ItemIdx&" order by Idx ASC) order by Idx ASC"
Set Rs=Server.CreateObject("ADODB.RecordSet")
Rs.Open Sql,DBcon,1

IF Not(Rs.Bof Or Rs.Eof) Then
    Record_Cnt=Dbcon.Execute("select count(*) from ProductDetailImg WHERE itemidx="&ItemIdx)
    TotalPage=Int((CInt(Record_Cnt(0))-1)/CInt(PageSize)) +1
    imageRec=Rs.GetRows
    Count=Record_Cnt(0)

    TopImg=imageRec(0,0)
Else
    Count=0
    TotalPage=1
End IF
Rs.Close

Set Rs=Nothing
DBcon.Close
Set DBcon=Nothing

Function PT_ItemList()
    Dim i,Num

    Num=GetTextNum(Page,Pagesize)
    IF IsArray(imageRec) Then
        For i=0 To UBound(imageRec,2)
            Response.write "<li style='float:left; padding:2px;'><img src='/upload/item/"&imageRec(0,i)&"' width='80' height='56' onClick=""callme('/upload/item/"&imageRec(0,i)&"','"&i&"', "&ImgPerSizeType1("item",600,400,imageRec(0,i))&");"" style='cursor:pointer; vertical-align:middle;'></li>"&Vbcrlf

            Num=Num+1
        Next

        For i=i To 5
            Response.Write "<li style='float:left; padding:2px;'><img src='/images/noimg.gif' width='80' height='56' style='vertical-align:middle;'></li>"&Vbcrlf
        Next
    End IF
End Function
%>

<% IF IsArray(imageRec) Then %>
    <div style="padding:30px 0 0px 0; width:100%;">
    <center>
    <div style='border:0px solid #E4E4E4; width:600px; height:400px; overflow: hidden; padding:0;'>
        <table cellpadding='0' cellspacing='0' border='0' height='100%' align='center'>
            <tr><td valign='bottom' style='padding:0;' ><img src="/upload/item/<%=TopImg%>" <%=ImgPerSize("item",600,400,TopImg)%> name="imgview" border="0" align='absmiddle'style="filter:progid:DXImageTransform.Microsoft.Fade(duration=1.0,overlap=1.0);"></td></tr>
        </table>
    </div>
    </center>

    <p style="text-align:center; margin:0; padding-top:10px;">

    <table cellpadding='0' cellspacing='0' align='center'>
        <tr>
            <td style='border:0px; padding:8px 5px 0 0;' valign='top'>
                <% If CStr(Page)<>1 Then %>
                <img src="/images/btn_arrow_left.gif" style='cursor:pointer;' onclick="viewResultImg('<%=ItemIdx%>','<%=Page-1%>')" style='vertical-align:middle;' />
                <% Else %>
                <img src="/images/btn_arrow_left.gif" style='vertical-align:middle;' />
                <% End IF %>
            </td>
            <td style='border:0px;'>
                <%=PT_ItemList()%>
            </td>
            <td style='border:0px; padding:8px 0 0 5px;' valign='top'>
                <% If CStr(Page)<CStr(TotalPage) Then %>
                <img src="/images/btn_arrow_right.gif" style='cursor:pointer;' onclick="viewResultImg('<%=ItemIdx%>','<%=Page+1%>')" style='vertical-align:middle;' />
                <% Else %>
                <img src="/images/btn_arrow_right.gif" style='vertical-align:middle;' />
                <% End IF %>
            </td>
        </tr>
    </table>

    </p>
    </div>
<% End IF %>