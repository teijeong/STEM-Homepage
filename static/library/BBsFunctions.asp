<%
'=============================게시판 설정 변수값 저장 코드 시작==============================
Sub HK_BBSSetup(HK_BBsCode)
	Dim HK_BBSRs,HK_BBSSql,HK_BBSAllREC
	IF HK_bbsCode<>"" Then
		HK_BBSSql="Select idx,notYN,pdsYN,MemYN,repYn,comYn,pubYN,ViewMode,imgYN,langsort,ImgViewYN,VodUrlYN,DownMode,comMode From boardAdmin WHERE idx="&HK_BBsCode&" Order By Idx DESC"
		Set HK_BBSRs=Server.CreateObject("ADODB.RecordSet")
		HK_BBSRs.Open HK_BBSSql,DBcon,1

		IF Not(HK_BBsRs.Bof Or HK_BBsRs.Eof) Then HK_BBSAllREC=HK_BBSRs.GetRows()

		HK_BBSRs.Close
		Set HK_BBSRs=Nothing

		IF IsArray(HK_BBSAllREC) Then
			HK_notYN=HK_BBsAllrec(1,0)
			HK_pdsYN=HK_BBsAllrec(2,0)
			HK_MemYN=HK_BBsAllrec(3,0)
			HK_repYn=HK_BBsAllrec(4,0)
			HK_comYn=HK_BBsAllrec(5,0)
			HK_pubYn=HK_BBsAllrec(6,0)
			HK_ViewMode=HK_BBsAllrec(7,0)
			HK_imgYN=HK_BBsAllrec(8,0)
			HK_LangSort=HK_BBsAllrec(9,0)
			HK_ImgViewYN=HK_BBsAllrec(10,0)
			HK_VodUrlYN=HK_BBsAllrec(11,0)
			HK_DownMode=HK_BBsAllrec(12,0)
			HK_comMode=HK_BBsAllrec(13,0)
		Else
			Response.Write ExecJavaAlert("게시판정보호출중 오류가 발생했습니다.\nERRORCODE:NOBOARD\n이전페이지로 이동합니다.",0)
			Response.End
		End IF
	End IF
End Sub
'=============================게시판 설정 변수값 저장 코드 끝==============================

' ***************************************************************************************
' * 함수설명 : 게시판 분류 생성(작성,수정페이지용)
' ***************************************************************************************
Function GetBoardSort(BBsCode,BoardSort,ReLevel)
	Dim Rs,Allrec,i,Str,Sql
	Set Rs=Server.CreateObject("ADODB.RecordSet")
	Sql="Select idx,SortName FROM boardsort Where boardidx="&bbsCode
	Rs.Open Sql,DBcon,1

	IF Not(Rs.Bof Or Rs.Eof) Then Allrec=Rs.GetRows()
	Rs.Close : Set Rs=Nothing

	IF IsNull(BoardSort) Then BoardSort=""

	IF IsArray(Allrec) Then
		Str="<Select name='boardsort' class='input'>"&Vbcrlf
		For i=0 To Ubound(Allrec,2)
			Str=Str&"<option value='"&Allrec(0,i)&"' "&SelCheck(Allrec(0,i),BoardSort)&">"&Allrec(1,i)&"</option>"&Vbcrlf
		Next
		Str=Str&"</select>"&Vbcrlf
	End IF

	IF Relevel="A" Or Relevel="" Then GetBoardSort=Str
End Function

Function GetBoardSortList(BBsCode,BoardSort)
	Dim Rs,Allrec,i,Str,Sql
	Set Rs=Server.CreateObject("ADODB.RecordSet")
	Sql="Select idx,SortName,(select Count(*) From bbslist Where boardsort=bs.idx) FROM boardsort bs Where boardidx="&bbsCode
	Rs.Open Sql,DBcon,1

	IF Not(Rs.Bof Or Rs.Eof) Then Allrec=Rs.GetRows()
	Rs.Close : Set Rs=Nothing

	IF IsNull(BoardSort) Then BoardSort=""
	IF IsArray(Allrec) Then
		Str="<div style='width:100%; padding-bottom:10px; text-align:right;'>"
		IF SpaceToZero(BoardSort)=0 Then tmpStr=tmpStr & "<b>"
		IF SpaceToZero(BoardSort)=0 Then tmpStr=tmpStr & "</b>"
		For i=0 To Ubound(Allrec,2)
			IF CStr(BoardSort)=CStr(Allrec(0,i)) Then tmpStr=tmpStr &"<b>"
			tmpStr=tmpStr &"<a href='?serboardsort="&Allrec(0,i)&"'><span style='font-size:12px; padding-left:10px;'>"&Allrec(1,i)&"<font color='#FF8000'>("&Allrec(2,i)&")</font></span></a>"
			IF CStr(BoardSort)=CStr(Allrec(0,i)) Then tmpStr=tmpStr &"</b>"
		Next
		Str=Str&tmpStr
		Str=Str&"</div>"
	End IF
	GetBoardSortList=Str
End Function

Function CheckBoardsortAndRedim(BBsCode,BoardSort)
	Dim Rs,Allrec,i,Str,Sql,tmpBoardsort
	Set Rs=Server.CreateObject("ADODB.RecordSet")

	IF Boardsort="" Or IsNull(Boardsort) Then
		Sql="Select Top 1 idx FROM boardsort Where boardidx="&BBscode
		Rs.Open Sql,DBcon,1
		IF Rs.Bof Or Rs.Eof Then
			tmpBoardsort=""
		Else
			tmpBoardsort=Rs("idx")
		End IF
		Rs.Close
	Else
		Sql="Select Top 1 idx FROM boardsort Where boardidx="&BBscode&" AND idx="&BoardSort
		Rs.Open Sql,DBcon,1

		IF Rs.Bof Or Rs.Eof Then
			Rs.Close

			Sql="Select Top 1 idx FROM boardsort Where boardidx="&BBscode
			Rs.Open Sql,DBcon,1
			IF Rs.Bof Or Rs.Eof Then
				tmpBoardsort=""
			Else
				tmpBoardsort=Rs("idx")
			End IF
		Else
			tmpBoardsort=Rs("idx")
		End IF
		Rs.Close
	End IF

	CheckBoardsortAndRedim=tmpBoardsort
End Function

' ***************************************************************************************
' * 함수설명 : 게시판 분류 생성(리스트 검색필드용)
' ***************************************************************************************
Function GetBoardSortSh(BBsCode,BoardSort)
	Dim Rs,Allrec,i,Str,Sql
	Set Rs=Server.CreateObject("ADODB.RecordSet")
	Sql="Select idx,SortName FROM boardsort Where boardidx="&bbsCode
	Rs.Open Sql,DBcon,1

	IF Not(Rs.Bof Or Rs.Eof) Then Allrec=Rs.GetRows()
	Rs.Close : Set Rs=Nothing

	IF IsNull(BoardSort) Then BoardSort=""
	IF IsArray(Allrec) Then
		Str="<Select name='serboardsort' class='input' style='width:150px;' onchange='document.searchfrm.submit();'>"&Vbcrlf
		Str=Str&"<option value=''>- 카테고리전체 -</option>"&Vbcrlf
		For i=0 To Ubound(Allrec,2)
			Str=Str&"<option value='"&Allrec(0,i)&"' "&SelCheck(Allrec(0,i),BoardSort)&">"&Allrec(1,i)&"</option>"&Vbcrlf
		Next
		Str=Str&"</select>"&Vbcrlf
	End IF
	GetBoardSortSh=Str
End Function

Function GetBoardSortShHome(BBsCode,BoardSort)
	Dim Rs,Allrec,i,Str,Sql,tSum
	tSum=0
	Set Rs=Server.CreateObject("ADODB.RecordSet")
	Sql="Select idx,SortName,(select Count(*) From bbslist Where boardidx="&bbscode&" AND boardsort=boardsort.idx) FROM boardsort Where boardidx="&bbsCode
	Rs.Open Sql,DBcon,1

	IF Not(Rs.Bof Or Rs.Eof) Then Allrec=Rs.GetRows()
	Rs.Close : Set Rs=Nothing

	IF IsNull(BoardSort) Then BoardSort=""

	IF IsArray(Allrec) Then
		For i=0 To Ubound(Allrec,2)
			tSum=tSum+Allrec(2,i)
		Next
	End IF

	IF IsArray(Allrec) Then
		Str=Str&"<table width='100%' border='0' cellspacing='0' cellpadding='0'>"&Vbcrlf
		Str=Str&"	<tr>"&Vbcrlf
		Str=Str&"	  <td height='25' bgcolor='efefef' style='padding-left:10px;'>"&Vbcrlf
		IF boardsort="" Then
			Str=Str&"<a href='?mode=list' calss='cate'><span style='color: #3E95FF; font-weight:bold;'>전체("&tSum&")</span></a> | "&Vbcrlf
		Else
			Str=Str&"<a href='?mode=list' calss='cate'>전체("&tSum&")</a> | "&Vbcrlf
		End IF
		For i=0 To Ubound(Allrec,2)
			IF CStr(boardsort)=CStr(Allrec(0,i)) Then
				Str=Str&"<a href='?serboardsort="&Allrec(0,i)&"' calss='cate'><span style='color: #3E95FF; font-weight:bold;'>"&Allrec(1,i)&"("&Allrec(2,i)&")</span></a>"&Vbcrlf
			Else
				Str=Str&"<a href='?serboardsort="&Allrec(0,i)&"' calss='cate'>"&Allrec(1,i)&"("&Allrec(2,i)&")</a>"&Vbcrlf
			End IF
			
			IF i<>Ubound(Allrec,2) Then Str=Str&" | "
		Next
		Str=Str&"	  </td>"&Vbcrlf
		Str=Str&"	</tr>"&Vbcrlf
		Str=Str&"	<tr><td>&nbsp;</td></tr>"&Vbcrlf
		Str=Str&"</table>"&Vbcrlf
	End IF
	GetBoardSortShHome=Str
End Function

' ***************************************************************************************
' * 함수설명 : 게시판 보기권한체크
' ***************************************************************************************
Function BBsViewModeChk(Mode)
	IF HK_ViewMode="3" AND Session("MemberShip")<>3 Then
		Response.Redirect "/intranet/login.asp"
		Response.End
	ElseIF HK_ViewMode<>"" Then
		IF Session("Useridx")="" Then
			Response.Redirect "/member/login.asp"
			Response.End
		ElseIF CStr(Session("Membership"))<HK_ViewMode Then
			Response.Write ExecJavaAlert("인트라넷접근 권한이 없습니다.\n사내회원이시라면 로그인후 이용해주시기 바랍니다.",0)
			Response.End
		End IF
	End IF

	IF Mode="write" Then
		IF HK_notYN="True" THen
			Response.Write ExecJavaAlert("작성권한이 없습니다.",0)
			Response.End
		End IF
	ElseIF Mode="reply" Then
		IF HK_repYn="False" THen
			Response.Write ExecJavaAlert("작성권한이 없습니다.",0)
			Response.End
		End IF
	End IF
End Function

' ***************************************************************************************
' * 함수설명 : 게시판 권한체크
' ***************************************************************************************
Function BbsAdminChk()
	IF HK_MemYN<>"" Then
		IF Session("Useridx")="" Then
			Response.Write ExecJavaAlert("로그인이 필요한 페이지 입니다.\n로그인 처리후 다시 시도해주세요.",0)
			Response.End
		ElseIF CStr(Session("Membership"))<HK_MemYN Then
			Response.Write ExecJavaAlert("작성 권한이 없습니다.",0)
			Response.End
		End IF
	ElseIF BBsCode="" Or BBsCode=false Then
		Response.Write ExecJavaAlert("잘못된접근입니다.\다시 시도해주세요",0)
		Response.End
	End IF
End Function


' ***************************************************************************************
' * 함수설명 : 게시판 회원전용 여부에 따른 이벤트 처리
' * 변수설명 : MemYN = 회원전용여부 코드 , Eventcode = 이벤트 URL 및 전송코드
' ***************************************************************************************
Function WriteModeChk(MemYN,Eventcode,returnUrl)
	IF MemYN="" Then
		WriteModeChk=Eventcode
	ElseIF Session("Useridx")="" Then
		WriteModeChk=LoginCheck(Eventcode,returnUrl)
	Else
		WriteModeChk=LoginMemsortCheck(Eventcode,returnUrl,MemYN)
	End IF
End Function
%>