
<script language="JavaScript" type="text/JavaScript">
<!--
function MM_swapImgRestore() { //v3.0
  var i,x,a=document.MM_sr; for(i=0;a&&i<a.length&&(x=a[i])&&x.oSrc;i++) x.src=x.oSrc;
}

function MM_preloadImages() { //v3.0
  var d=document; if(d.images){ if(!d.MM_p) d.MM_p=new Array();
    var i,j=d.MM_p.length,a=MM_preloadImages.arguments; for(i=0; i<a.length; i++)
    if (a[i].indexOf("#")!=0){ d.MM_p[j]=new Image; d.MM_p[j++].src=a[i];}}
}

function MM_findObj(n, d) { //v4.01
  var p,i,x;  if(!d) d=document; if((p=n.indexOf("?"))>0&&parent.frames.length) {
    d=parent.frames[n.substring(p+1)].document; n=n.substring(0,p);}
  if(!(x=d[n])&&d.all) x=d.all[n]; for (i=0;!x&&i<d.forms.length;i++) x=d.forms[i][n];
  for(i=0;!x&&d.layers&&i<d.layers.length;i++) x=MM_findObj(n,d.layers[i].document);
  if(!x && d.getElementById) x=d.getElementById(n); return x;
}

function MM_swapImage() { //v3.0
  var i,j=0,x,a=MM_swapImage.arguments; document.MM_sr=new Array; for(i=0;i<(a.length-2);i+=3)
   if ((x=MM_findObj(a[i]))!=null){document.MM_sr[j++]=x; if(!x.oSrc) x.oSrc=x.src; x.src=a[i+2];}
}
function searchDate(){
    fo_search.submit();
}
//-->
</script>
<script type='text/javascript' src='/common/calendar.js'></script>

<body onLoad="MM_preloadImages('images/btn_over_01.gif')">
  <table width=100% border=0 cellspacing=0 cellpadding=10 align=center>
  <tr> 
    <td height=1 colspan="2" bgcolor=e6e6e6 style='padding:0;'></td>
  </tr>
  <tr height=20> 
    <td colspan="2" bgcolor="E2F1EB" ><font color="2B5E4A"><strong>&nbsp;* 
      확인코자 하는 내역의 조회 기간을 먼저 입력하신 후 조건에 해당하는 항목을 클릭해 주세요!</strong></font></td>
  </tr>
</table>

<%
OpenDB()

YesterDay1 = date() - 1 & " 00:00:00"
YesterDay2 = date() - 1 & " 23:59:59"      
ToDay1 = date()  & " 00:00:00"
ToDay2 = date()  & " 23:59:59"        

sql = "select count(*) from counter"
getrs rs,sql     
Total_Count = rs(0)
Setdefault Total_Count , 0
FreeandNil(rs)


sql = "select count(*) from counter where register between '"& YesterDay1 &"' and '"& YesterDay2 &"' "
getrs rs,sql     
Yesterday_Count = rs(0)
Setdefault Yesterday_Count , 0
FreeandNil(rs)

sql = "select count(*) from counter where register between '"& ToDay1 &"' and '"& ToDay2 &"' "
getrs rs,sql     
Today_Count = rs(0)
Setdefault Today_Count , 0
FreeandNil(rs)          
FreeandNil(Con)
%>

<table cellpadding=5 cellspacing=0 border=0 width=100% align=center class='menu'>
  <form name=fo_search method=get>
    <input type=hidden name=tp value="<%=TP%>">
  <tr> 
    <td colspan="2" height=1 bgcolor=e6e6e6 style='padding:0'></td>
  </tr>
    <tr> 
      <td align=right bgcolor="E2F1EB" ><font color="2B5E4A"><strong>총접속수 :</strong></font>&nbsp;</td>
      <td ><%=FormatNumber(Total_Count,0)%> 명</td>
    </tr>
  <tr> 
    <td colspan="2" height=1 bgcolor=e6e6e6 style='padding:0'></td>
  </tr>
  </tr>
    <tr> 
      <td align=right bgcolor="E2F1EB" ><font color="2B5E4A"><strong>어제 접속수:&nbsp;</strong></font></td>
      <td ><%=FormatNumber(Yesterday_Count,0)%> 명</td>
    </tr>
  <tr> 
    <td colspan="2" height=1 bgcolor=e6e6e6 style='padding:0'></td>
  </tr>
  </tr>
    <tr> 
      <td align=right bgcolor="E2F1EB" ><font color="2B5E4A"><strong>오늘 
        접속수:</strong></font>&nbsp;</td>
      <td ><%=FormatNumber(Today_Count,0)%> 명</td>
    </tr>
  <tr> 
    <td colspan="2" height=1 bgcolor=e6e6e6 style='padding:0'></td>
  </tr>    
  </tr>
    <tr> 
      <td align=right bgcolor="E2F1EB" ><font color="2B5E4A"><strong>조회기간 
        :&nbsp;</strong></font></td>
      <td ><input type=text class=text size=12 name=fd maxlength=10 value='<%=FDATE%>' readonly onclick="popUpCalendar(this, fd, 'yyyy-mm-dd')">
        - 
        <input type=text class=text size=12 name=ed maxlength=10 value='<%=EDATE%>' readonly onclick="popUpCalendar(this, ed, 'yyyy-mm-dd')">
        <!-- <input type='button' value='검색' style='cursor:pointer;' onclick='searchDate()'> -->
      </td>
    </tr>
  <tr> 
    <td colspan="2" height=1 bgcolor=e6e6e6 style='padding:0'></td>
  </tr>
        <tr>
            
      <td align=right bgcolor="E2F1EB" ><font color="2B5E4A"><strong>조회항목 :&nbsp;</strong></font></td>
      <td >
        <table cellpadding='2' cellspacing='0'>
            <tr>
                <td><a href="#" onclick='fnSearch(SEARCH_TYPE_1);' onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image1','','images/btn_over_01.gif',1)"><img src="<%if tp = "1" then%>images/btn_over_01.gif<% else %>images/btn_01.gif<% end if %>" name="Image1"  border="0"></a></td>
                <td><a href="#" onclick='fnSearch(SEARCH_TYPE_2);' onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image2','','images/btn_over_02.gif',2)"><img src="<%if tp = "2" then%>images/btn_over_02.gif<% else %>images/btn_02.gif<% end if %>" name="Image2"  border="0"></a></td>
                <td><a href="#" onclick='fnSearch(SEARCH_TYPE_3);' onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image3','','images/btn_over_03.gif',3)"><img src="<%if tp = "3" then%>images/btn_over_03.gif<% else %>images/btn_03.gif<% end if %>" name="Image3"  border="0"></a></td>
                <td><a href="#" onclick='fnSearch(SEARCH_TYPE_4);' onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image4','','images/btn_over_04.gif',4)"><img src="<%if tp = "4" then%>images/btn_over_04.gif<% else %>images/btn_04.gif<% end if %>" name="Image4"  border="0"></a></td>
                <td><a href="#" onclick='fnSearch(SEARCH_TYPE_5);' onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image5','','images/btn_over_05.gif',5)"><img src="<%if tp = "5" then%>images/btn_over_05.gif<% else %>images/btn_05.gif<% end if %>" name="Image5"  border="0"></a></td>
                <td><a href="#" onclick='fnSearch(SEARCH_TYPE_6);' onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image6','','images/btn_over_06.gif',6)"><img src="<%if tp = "6" then%>images/btn_over_06.gif<% else %>images/btn_06.gif<% end if %>" name="Image6"  border="0"></a></td>
                <td><a href="#" onclick='fnSearch(SEARCH_TYPE_7);' onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image7','','images/btn_over_07.gif',7)"><img src="<%if tp = "7" then%>images/btn_over_07.gif<% else %>images/btn_07.gif<% end if %>" name="Image7"  border="0"></a></td>
                <td><a href="#" onclick='fnSearch(SEARCH_TYPE_8);' onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image8','','images/btn_over_08.gif',8)"><img src="<%if tp = "8" then%>images/btn_over_08.gif<% else %>images/btn_08.gif<% end if %>" name="Image8"  border="0"></a></td>
                <td><a href="#" onclick='fnSearch(SEARCH_TYPE_9);' onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image9','','images/btn_over_09.gif',9)"><img src="<%if tp = "9" then%>images/btn_over_09.gif<% else %>images/btn_09.gif<% end if %>" name="Image9"  border="0"></a></td>
            </tr>
        </table>
        </td>
        </tr>
      <tr> 
        <td colspan="2" height=1 bgcolor=e6e6e6 style='padding:0'></td>
      </tr>
  </form>
</table>
