<!--#include virtual = common/ADdbcon.asp-->
<%
Dim Sql,Rs,Allrec,Idx,Content,TitleTag,Title,Sort,BBSCode,Writer,Page,FileName,FileName1
Dim Relevel,BBsSort
Dim BoardSort,Search,SearchStr

Sort=Request("sort")
Page=Request("page")
bbscode=Cint(Request("bbscode"))
sersel1=Request("sersel1")
serboardsort=Request("serboardsort")
Search=Request("Search")
SearchStr=Request("SearchStr")

Idx=Request("idx")

IF Idx<>"" Then
    Sql="SELECT title,content,writer,ReLevel,boardsort,imgNames,ref,topyn,startdate,enddate,VodUrl,note1,note2,status FROM BBsList WHERE idx="&idx

    Set Rs=DBcon.Execute(Sql)
    IF Not(Rs.Bof Or Rs.Eof) Then
        Allrec=Rs.GetRows
        Writer=Allrec(2,0)
        Content=ReplaceNoHtml(Allrec(1,0))
        Title=ReplaceTextField(Allrec(0,0))
        ReLevel=Allrec(3,0)
        BoardSort=Allrec(4,0)
        imgNames=Allrec(5,0)
        ref=Allrec(6,0)
        topyn=Allrec(7,0)
        startdate=ReplaceTextField(Allrec(8,0))
        enddate=ReplaceTextField(Allrec(9,0))
        VodUrl=ReplaceTextField(Allrec(10,0))
        note1=ReplaceTextField(Allrec(11,0))
        note2=ReplaceTextField(Allrec(12,0))
        status=ReplaceTextField(Allrec(13,0))
    End IF
    Set Rs=Nothing

    TitleTag="수정"
    Sort="edit"

    '=============파일정보Get======================================
    Set Rs=Server.CreateObject("ADODB.RecordSet")
    Sql="Select idx,filenames From BBSData Where bidx="&Idx
    Rs.Open Sql,DBcon,1

    IF Not(Rs.Bof Or Rs.Eof) Then FileRec=Rs.Getrows()
    Rs.Close
    '==============================================================
Else
    BoardSort=serboardsort
    TitleTag="등록"
End IF

Call HK_BBSSetup(BBsCode)
BBsSort=GetBoardSort(BBsCode,BoardSort,ReLevel)

DBcon.Close
Set DBcon=Nothing

IF Writer="" Then Writer=Request.Cookies("acountname")
%>


<!--#include virtual = admin/common/adminHeader.asp-->
<script type='text/javascript' src='/common/calendar.js'></script>
<SCRIPT language=JavaScript src="/ckeditor/ckeditor.js" type='text/javascript'></SCRIPT>
<SCRIPT LANGUAGE="JavaScript">
<!--
function sendit(){
    var form=document.boardform;
    if(form.writer.value==false){
        alert("작성자를 입력하세요.");
        form.writer.focus();
        return;
    }
    if(form.startdate){
        if(form.startdate.value==false){
            alert("이벤트 시작일을 입력하세요.");
            return;
        }
        if(form.enddate.value==false){
            alert("이벤트 종료일을 입력하세요.");
            return;
        }
    }
    if(form.title.value==false){
        alert("글제목을 입력하세요.");
        form.title.focus();
        return;
    }
    if("<%=Sort%>"=="edit"){
        if(form.imgDel_Chk){
            if(form.imgDel_Chk.checked){
                if(form.imgfiles){
                    if(uploadImg_check(form.imgfiles.value,"이미지를 올바로 입력하세요.",1)==false){
                        return;
                    }
                }
            }
        }
    }
    else{
        if(form.imgfiles){
            if(uploadImg_check(form.imgfiles.value,"이미지를 올바로 입력하세요.",1)==false){
                return;
            }
        }
    }
    form.submit();
}
function getFileExtension( filePath ){
    var extension = "";
    var lastIndex = -1;
        lastIndex = filePath.lastIndexOf('.');

    if ( lastIndex != -1 ){
        extension = filePath.substring( lastIndex+1, filePath.len );
    } else{
        extension = "";
    }
        return extension;
}

function uploadImg_check( value,msg,sort ){
    var src = getFileExtension(value);

    if(sort==1 && value==""){return true;}
    if ( src == ""){
        alert(msg);
        return false;
    } else if ( !((src.toLowerCase() == "gif") || (src.toLowerCase() == "jpg") || (src.toLowerCase() == "jpeg")) ) {
        alert('gif 와 jpg 파일만 업로드 하실 수 있습니다.');
        return false;
    }else{return true;}
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
            <table cellpadding="2" cellspacing="0" width="880">
                <tr>
                    <td>
                        <table cellpadding="0" cellspacing="0" class="menu" width="100%">
                            <tr>
                                <td style='color:#39518C;;'><img src='/admin/image/titleArrow1.gif'><b><%=ChangeAdminBoardTitle(bbscode)%></td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td>
                        <table width="100%" border="1" cellpadding="3" cellspacing="0" bordercolor='#BDBEBD' class="menu" style='border-collapse: collapse; table-layout:fixed;'>
                        <form name="boardform" action="bbswriteok.asp" method="post" ENCTYPE="multipart/form-data">
                        <input type='hidden' name='sort' value='<%=Sort%>'>
                        <input type='hidden' name='bbsCode' value='<%=bbsCode%>'>
                        <input type='hidden' name='idx' value='<%=Idx%>'>
                        <input type='hidden' name='page' value='<%=Page%>'>
                        <input type='hidden' name='sersel1' value='<%=sersel1%>'>
                        <input type='hidden' name='relevel' value='<%=ReLevel%>'>
                        <input type='hidden' name='ref' value='<%=ref%>'>
                        <input type='hidden' name='serboardsort' value='<%=serboardsort%>'>
                        <input type='hidden' name='Search' value='<%=Search%>'>
                        <input type='hidden' name='SearchStr' value='<%=SearchStr%>'>
                        <colgroup>
                            <col width='120'></col>
                            <col width='*'></col>
                        </colgroup>
                            <tr bgcolor="#F6F6F6">
                                <td align='right' colspan='2'>게시물&nbsp; <%=TitleTag%>&nbsp;&nbsp;</td>
                            </tr>
                        <% IF BBscode=100 Then %>
                            <tr>
                                <td bgcolor="#F6F6F6">&nbsp;공고상태</td>
                                <td>
                                    <select name='status'>
                                        <option value='1'>채용중</option>
                                        <option value='0' <%=selCheck(0,status)%>>마감</option>
                                    </select>
                                </td>
                            </tr>
                        <% End IF %>
                        <% IF BBsSort<>"" Then %>
                            <tr>
                                <td bgcolor="#F6F6F6">&nbsp;분류</td>
                                <td><%=BBsSort%></td>
                            </tr>
                        <% Else %>
                            <input type='hidden' name='boardsort' value='<%=BoardSort%>'>
                        <% End IF %>
                            <tr>
                                <td bgcolor="#F6F6F6">&nbsp;작성자</td>
                                <td><input type='text' name='writer' style='width:17%' maxlength='10' class='input' Value='<%=Writer%>'></td>
                            </tr>
                            <tr>
                                <td bgcolor="#F6F6F6">&nbsp;글제목</td>
                                <td>
                                    <input type='text' name='title' style='width:70%' maxlength='50' class='input' Value='<%=Title%>'>
                                <% IF HK_imgYN<>"True" Then %>
                                    &nbsp;&nbsp;&nbsp;&nbsp;<input type='checkbox' name='topyn' Value='1' <%=ChangeCheckedYN(TopYN)%>> 공지글 체크
                                <% End IF %>
                                </td>
                            </tr>
                        <% IF BBscode=100 Then %>
                            <tr>
                                <td bgcolor="#F6F6F6">&nbsp;간략설명</td>
                                <td><input type='text' name='note1' style='width:99%' maxlength='300' class='input' Value='<%=note1%>'></td>
                            </tr>
                        <% End IF %>
                        <% IF BBscode=100 Then %>
                            <tr>
                                <td width='100' bgcolor="#F6F6F6">&nbsp;이벤트기간</td>
                                <td>
                                    <input type='text' name='startdate' size='10' maxlength='10' class='input' Value='<%=startdate%>' readonly onclick="popUpCalendar(this, startdate, 'yyyy-mm-dd')"> ~ 
                                    <input type='text' name='enddate' size='10' maxlength='10' class='input' Value='<%=enddate%>' readonly onclick="popUpCalendar(this, enddate, 'yyyy-mm-dd')">
                                </td>
                            </tr>
                            <tr>
                                <td width='100' bgcolor="#F6F6F6">&nbsp;간략내용</td>
                                <td><input type='text' name='note1' style='width:99%' maxlength='100' class='input' Value='<%=note1%>'></td>
                            </tr>
                        <% End IF %>
                            <tr>
                                <td bgcolor="#F6F6F6">&nbsp;내용</td>
                                <td>
                                    <textarea name='content' style='width:100%; word-break:break-all;' class='ckeditor'><%=Content%></textarea>
                                </td>
                            </tr>
                            
                        <% IF HK_VodUrlYN<>"False" Then %>
                            <tr>
                                <td bgcolor="#F6F6F6">&nbsp;유투브URL</td>
                                <td>
                                    <input type='text' name='VodUrl' style='width:100%' maxlength='100' class='input' value='<%=VodUrl%>'>
                                </td>
                            </tr>
                        <% End IF %>
                        <% IF HK_imgYN<>"False" Then %>
                            <tr>
                                <td bgcolor="#F6F6F6">&nbsp;이미지첨부</td>
                                <td>
                                    <input type='file' name='imgfiles' style='width:60%' class='input'>
                                    <% IF Sort="edit" Then %>
                                    <input type='hidden' name='imgname' value="<%=imgNames%>">
                                    <input type='checkbox' name='imgDel_Chk'> 파일변경여부
                                    <% End IF %>
                                    <% IF ImgNames<>"" Then %>
                                    <a href='javascript:openWindow(100,100,"/common/imgview.asp?path=board&imgname=<%=ImgNames%>","imgView","yes")'><img src='/admin/image/icon/bt_view.gif' border='0' align='absmiddle'></a>
                                    <% End IF %>
                                </td>
                            </tr>
                        <% End IF %>
                        <% IF HK_PdsYN<>"False" Then %>
                            <tr>
                                <td bgcolor="#F6F6F6">&nbsp;파일첨부</td>
                                <td>
                                    <table cellpadding='0' cellspacing='0' width='100%' id="inRow">
                                    <% IF IsArray(FileRec) Then %>
                                        <% For i=0 To UBound(FileRec,2) %>
                                        <tr>
                                            <td style='padding:1px 0;'>
                                                <input type='file' name='files' style='width:350px' class='input'>
                                                <a href='/common/download.asp?downfile=<%=FileRec(1,i)%>&path=board'><img src='/admin/image/icon/bt_download.gif' border='0' align='absmiddle'></a>
                                                <input type='hidden' name='filedel_idx' value='0'>
                                                <input type='checkbox' name='delchk' onclick='changeFilech(<%=i%>,<%=FileRec(0,i)%>)'> 파일수정여부

                                                <% IF i=0 Then %><a href='#jLink' onclick="addRow()"><span style='color: #D90000'>&nbsp;필드추가</span></a><% End IF %>
                                            </td>
                                        </tr>
                                        <% Next%>
                                    <% Else %>
                                        <tr>
                                            <td style='padding:1px 0;'>
                                                <input type='file' name='files' style='width:350px' class='input'>
                                                <input type='hidden' name='filedel_idx' value='0'>
                                                <a href='#jLink' onclick="addRow()"><span style='color: #D90000'>필드추가</span></a>
                                            </td>
                                        </tr>
                                    <% End IF %>
                                    </table>
                                </td>
                            </tr>
                        <% End IF %>
                        </form>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td>
                        <table cellpadding='0' cellspacing='0' width='100%' class='menu'>
                            <tr>
                                <td align='right'>
                                    <a href='javascript:sendit();'><img src='/admin/image/icon/bwrite.gif' border='0'></a>
                                    <a href='javascript:history.back()'><img src='/admin/image/icon/bback.gif' border='0'></a>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>


        </td>
    </tr>
</table>

<!--#include virtual = admin/common/bottom.html-->
</body>
</html>