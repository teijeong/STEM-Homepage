<!-- #include virtual = common/addbcon.asp -->
<%
Sort=Request("sort")
IDX=Request("idx")

IF CSTR(idx)="0" Then
    Response.write Execjavaalert("접근할수 없는 사용자코드입니다.\n다시시도해주세요.",0)
    Response.end
End IF
IF Sort="" Then Sort=1

id=Request("id")
pwd=Request("pwd")
name=ReplaceNoHtml(Request("name"))
tel=ReplaceNoHtml(Request("tel"))
email=ReplaceNoHtml(Request("email"))

set cmd=CreateCommand(dbcon,"AP_adminSet",adCmdStoredProc)
With cmd
    .Parameters.Append CreateInputParameter("@Sort",adInteger,4,Sort)
    .Parameters.Append CreateInputParameter("@Idx",adInteger,4,SpaceToZero(IDX))
    .Parameters.Append CreateInputParameter("@id",adVarWChar,15,ID)
    .Parameters.Append CreateInputParameter("@Name",adVarWChar,10,Name)
    .Parameters.Append CreateInputParameter("@pwd",adVarWChar,15,Pwd)
    .Parameters.Append CreateInputParameter("@email",adVarWChar,50,Email)
    .Parameters.Append CreateInputParameter("@tel",adVarWChar,15,tel)
    .Parameters.Append CreateOutputParameter("@result",adInteger,4)
    .execute
End With
Result=Cmd.Parameters("@result").Value

Set Cmd=Nothing
DBcon.Close
Set DBcon=Nothing

IF Result=0 Then
    strLocation="top.location.href='adminlist.asp'"
    Response.Write ExecJavaAlert("관리자가 등록되었습니다.",3)
ElseIF Result=1 then
    Response.Write ExecJavaAlert("중복된 아이디입니다..\n\n확인후 다시 시도해주세요","")
ElseIF Result=2 then
    strLocation="top.location.reload();"
    Response.Write ExecJavaAlert("관리자정보가 정상적으로 수정되었습니다.","3")
End IF
%>