<%
Dim Shop_Rec,ShopInfoSql,ShopTagtop,ShopTagmiddle
Dim Shop_point,    Shop_point_reg,    Shop_point_use,    Shop_exp_sort, Shop_exp_price, Shop_exp_Mprice
ShopInfoSql="Select fax,shop_name,shop_num,shop_ceo,shop_license,shop_email,safeguard_admin,shop_tel1,shop_address,point,point_reg,point_use,exp_sort,exp_price,exp_Mprice FROM Shopinfo"
Set Shop_Rec=DBcon.Execute(shopInfoSql)

IF Not(Shop_Rec.Bof Or Shop_Rec.Eof) Then
    Shop_point=Shop_Rec("point") : Shop_point_reg=Shop_Rec("point_reg") : Shop_point_use=Shop_Rec("point_use")
    Shop_exp_sort=Shop_Rec("exp_sort") : Shop_exp_price=Shop_Rec("exp_price") : Shop_exp_Mprice=Shop_Rec("exp_Mprice")

    ShopTagtop="" : ShopTagmiddle=""
    IF Shop_Rec("shop_address")<>"" Then ShopTagtop=ShopTagtop&Shop_Rec("shop_address")&" / "
    IF Shop_Rec("shop_tel1")<>"" Then ShopTagtop=ShopTagtop&"TEL. "&Shop_Rec("shop_tel1")&" / "
    IF Shop_Rec("fax")<>"" Then ShopTagtop=ShopTagtop&"FAX. "&Shop_Rec("fax")&" / "
    IF Shop_Rec("shop_email")<>"" Then ShopTagtop=ShopTagtop&"Email. "&Shop_Rec("shop_email")

    IF Shop_Rec("shop_name")<>"" Then ShopTagmiddle=ShopTagmiddle&"상호. "&Shop_Rec("shop_name")&" / "
    IF Shop_Rec("shop_num")<>"" Then ShopTagmiddle=ShopTagmiddle&"사업자등록번호. "&Shop_Rec("shop_num")&" / "
    IF Shop_Rec("shop_license")<>"" Then ShopTagmiddle=ShopTagmiddle&"통신판매업신고. "&Shop_Rec("shop_license")&" / "
    IF Shop_Rec("safeguard_admin")<>"" Then ShopTagmiddle=ShopTagmiddle&"정보책임자. "&Shop_Rec("safeguard_admin")&" / "
    IF Shop_Rec("shop_ceo")<>"" Then ShopTagmiddle=ShopTagmiddle&"대표. "&Shop_Rec("shop_ceo")
End IF

Set SerRs=Server.CreateObject("ADODB.RecordSet")
'=============================카테고리 하단배너 Get================================='
Dim CateBottomBannerRec
SerSql="Select Top 3 ViewImage,LinkUrl From BannerAdmin Where bannerSort=1 Order By Idx Desc"
SerRs.Open SerSql,DBcon,1

IF Not(SerRs.Bof Or SerRs.Eof) Then CateBottomBannerRec=SerRs.GetRows()
SerRs.Close
'==================================================================================='

Set SerRs=Nothing

Function PT_CateBottomBanner()
    Dim i
    IF IsArray(CateBottomBannerRec) Then
        For i=0 To Ubound(CateBottomBannerRec,2)
            Response.write "<tr><td><a href='"&CateBottomBannerRec(1,i)&"'><img src='/upload/banner/"&CateBottomBannerRec(0,i)&"' align='absmiddle' width='186' height='88' border='0'></a></td></tr>"&Vbcrlf
            Response.write "<tr><td height='7'></td></tr>"&Vbcrlf
        Next
    End IF
End Function
%>