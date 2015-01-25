<%
serboardsort=Request("serboardsort")

Call HK_BBSSetup(BBsCode)
BBsViewModeChk("write")
BbsAdminChk()
BBsSort=GetBoardSort(BBsCode,serboardsort,ReLevel)
%>