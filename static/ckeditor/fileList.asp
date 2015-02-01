<!--#include virtual = common/dbcon.asp-->
<!--#include virtual = Library/imageDictionary.asp-->
<%
Page=GetPage()
PageSize=24

Set Rs = server.createobject("adodb.recordset")
Rs.cursorlocation = aduseclient
Rs.fields.append "file_name", advarchar, 200
Rs.fields.append "file_Size", advarchar, 200
Rs.fields.append "file_ModifyDate", adDBTimeStamp, 8
Rs.cursortype = adopenstatic
Rs.locktype = adlockbatchoptimistic
Rs.PageSize = PageSize
Rs.Open

Set Fso = createobject("scripting.filesystemobject")
File_Path = Server.MapPath("\upload")&"\editorData\"
Set ObjFolder = Fso.GetFolder(File_path)
Set Files = ObjFolder.Files

For Each File IN Files
    Rs.addnew
    Rs("file_name") = File.name
    Rs("file_Size") = File.Size
    Rs("file_ModifyDate") = File.DateCreated
next
Rs.sort = "file_ModifyDate DESC, file_name asc"
totalpage = Rs.PageCount

IF Not(Rs.Bof Or Rs.Eof) Then
    Rs.AbsolutePage = page
    Count=Rs.RecordCount
    Allrec=Rs.GetRows
Else
    Count=0
End IF
Rs.Close

Function GetFileFormatByResult(FileName,uploadFolder)
    Dim fileext,FileImage
    IF FileName<>"" Then
        Fileext=mid(FileName,instrrev(FileName,".")+1)

        IF UCASE(fileext)="JPG" OR UCASE(fileext)="BMP" OR UCASE(fileext)="GIF" OR UCASE(fileext)="JPEG" Then
            GetFileFormatByResult="<img src='/upload/"&UploadFolder&"/"&FileName&"' "&ImgPerSize(uploadFolder,120,90,FileName)&">"
        Else
            GetFileFormatByResult="<img src='/common/memberimg/img_notimage.gif' width='120' height='90'>"
        End IF
    End IF
End Function

Function FileList()
    IF IsArray(Allrec) Then
        Do Until i>Ubound(Allrec,2)  
            Response.Write "<tr>"&Vbcrlf
            For k=0 To 5
                IF i>Ubound(Allrec,2) OR i=PageSize Then Exit For
                Response.Write "    <td valign='top' align='center'>"&Vbcrlf
                Response.Write "        <table cellpadding='0' cellspacing='0' border='0' style='word-break:break-all;' width='120' class='menu'>"&Vbcrlf
                Response.Write "            <tr>"&Vbcrlf
                Response.Write "                <td align='center' valign='top'><div style='border:1px solid #E4E4E4; width:120px; height:90px;position:relative;overflow: hidden;'><table cellpadding='0' cellspacing='0' border='0' height='100%'><tr><td valign='middle'>"&GetFileFormatByResult(Allrec(0,i),"thumeditordate")&"</td></tr></table><div style='position:absolute; top:1px; left:1px;' id='menufour"&i&"'><img src='/ckeditor/images/icon_showdetails.gif' alt='action' onclick=""layerview('menufour"&i&"','"&Allrec(0,i)&"')""></div></div></td>"&Vbcrlf
                Response.Write "            </tr>"&Vbcrlf
                Response.Write "            <tr><td height='5'></td></tr>"&Vbcrlf
                Response.Write "            <tr><td align='center' style='font-size:11px;'>"&GetFileStsImage(Allrec(0,i))&" "&Allrec(0,i)&"</td></tr>"&Vbcrlf
                Response.Write "        </table>"&Vbcrlf
                Response.Write "    </td>"&Vbcrlf
                i=i+1
            Next
            Response.Write "</tr>"&Vbcrlf
            Response.Write "<tr align='center' valign='middle'><td height='10' colspan='5'></td></tr>"&Vbcrlf
            IF i=PageSize Then Exit Do
        loop
    Else
        Response.Write "<tr><td align='center' colspan='5' height='200'>파일이 존재하지 않습니다.</td></tr>"&vbcrlf
    End IF
End Function

Set Rs=Nothing
DBcon.CLose
Set DBcon=Nothing
%>

<table width="100%" border="0" cellspacing="0" cellpadding="0" class="menu" align="center">
    <tr>
        <td>
            <table border="0" width="100%" cellspacing="0" cellpadding="4" class="menu">
                <tr><td width='16%'></td><td width='16%'></td><td width='16%'></td><td width='16%'></td><td width='16%'></td><td width='16%'></td></tr>
                <%FileList()%>
            </table>
        </td>
    </tr>
    <tr>
        <td>
            <table cellpadding='0' cellspacing='0' width='100%'>
                <tr><td height='1' bgcolor='#CECECE'></td></tr>
                <tr>
                    <td align='center' width='90%'><%=PT_spPageLink("viewArea","''","yes")%></td>
                </tr>
            </table>
        </td>
    </tr>
</table>