<!-- #include virtual = common/ADdbcon.asp -->
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<%
Dim Idx,Sort,CellName,BoardIdx,BoardName,AlertTag,Result,BBscode
Dim strLocation,Cmd

Idx=Request("idx")
Sort=Request("sort")
BBscode=Request("BBscode")
BoardIdx=Request("boardidx")
BoardName=Request("boardname")
CellName=ReplaceNoHtml(Request("cellname"))

IF Sort="edit" Then
	AlertTag="수정"
	Boardidx=0
Else
	AlertTag="등록"
	Idx=0
End IF

Set Cmd=CreateCommand(DBcon,"UP_CellProc",adCmdStoredProc)
With Cmd
	.Parameters.Append CreateInputParameter("@Idx",adInteger,4,Idx)
	.Parameters.Append CreateInputParameter("@Sort",adVarchar,10,Sort)
	.Parameters.Append CreateInputParameter("@CellName",adVarWchar,30,CellName)
	.Parameters.Append CreateInputParameter("@BoardIdx",adInteger,4,BoardIdx)
	.Parameters.Append CreateInputParameter("@BoardName",adVarWchar,50,BoardName)
	.Parameters.Append CreateOutPutParameter("@Result",adInteger,4)
	.Execute
End With
Result=Cmd.Parameters(5).value

Set Cmd=Nothing
DBcon.Close
Set DBcon=Nothing

strLocation="boardSortAdmin.asp?bbscode="&BBscode
IF Result=1 Then
	Response.Write ExecJavaAlert("중복된 분류가 있습니다. 확인후 다시 시도하세요.",2)
Else
	Response.Write ExecJavaAlert("분류가 "&AlertTag&"되었습니다.",2)
End IF
%>