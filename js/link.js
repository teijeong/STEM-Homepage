function go_menu(tar){

	/* Greetings */
	if(tar=='sub1_1')
		location.href = "/sub/sub1_1.asp", "_self";
	/* Vision, Statement */
	if(tar=='sub1_2')
		location.href = "/sub/sub1_2.asp", "_self";
	/* organization  */
	if(tar=='sub1_3')
		location.href = "/sub/sub1_3.asp", "_self";
	/* Map */
	if(tar=='sub1_4')
		location.href = "/sub/sub1_4.asp", "_self";
	/* Contact */
	if(tar=='sub1_5')
		location.href = "/sub/sub1_5.asp", "_self";

	/* Scholarship */
	if(tar=='sub2_1')
		location.href = "/sub/sub2_1.asp", "_self";
	/* Service */
	if(tar=='sub2_2')
		location.href = "/sub/sub2_2.asp", "_self";
	/* Exchange */
	if(tar=='sub2_3')
		location.href = "/sub/sub2_3.asp", "_self";
	/* Leadership */
	if(tar=='sub2_4')
		location.href = "/sub/sub2_4.asp", "_self";
	/* Leadership */
	if(tar=='sub2_5')
		location.href = "/sub/sub2_5.asp", "_self";

	/* People */
	if(tar=='sub3_1')
		location.href = "/sub/sub3_1.asp", "_self";

	/* Recruiting */
	if(tar=='sub4_1')
		location.href = "/sub/sub4_1.asp", "_self";
	/* Cooperation */
	if(tar=='sub4_2')
		location.href = "/sub/sub4_2.asp", "_self";
	/* Donation */
	if(tar=='sub4_3')
		location.href = "/sub/sub4_3.asp", "_self";
		/* Donation */
	if(tar=='sub4_3_2')
		location.href = "/sub/sub4_3_2.asp", "_self";

	/* Notice */
	if(tar=='sub5_1')
		location.href = "/sub/sub5_1.asp", "_self";
	/* QnA */
	if(tar=='sub5_2')
		location.href = "/sub/sub5_2.asp", "_self";

	
	/* 회원가입 */
	if(tar=='yak')
		location.href = "/member/yak.asp", "_self";
	/* 회원가입 */
	if(tar=='join')
		location.href = "/member/join.asp", "_self";
	/* 회원가입 */
	if(tar=='join_com')
		location.href = "/member/join_com.asp", "_self";
	/* 주문/배송조회 */
	if(tar=='order')
		location.href = "/member/order.asp", "_self";
	/* 회원정보수정 */
	if(tar=='point')
		location.href = "/member/point.asp", "_self";
	/* 회원정보수정 */
	if(tar=='modify')
		location.href = "/member/modify.asp", "_self";
	/* 회원탈퇴 */
	if(tar=='out')
		location.href = "/member/out.asp", "_self";
	/* 아이디찾기 */
	if(tar=='id_seek')
		{ var w=400; var h=240; var top=(screen.availHeight-h)/2; var left=(screen.availWidth-w)/2; window.open("/member/id_seek.asp", "theWindow", "toolbar=0, resizable=no, status=1, scrollbars=no, copyhistory=0, width=" + w + ", height=" + h + ", top=" + top + ", left=" + left); }
	/* 비번찾기 */
	if(tar=='pw_seek')
		{ var w=400; var h=260; var top=(screen.availHeight-h)/2; var left=(screen.availWidth-w)/2; window.open("/member/pw_seek.asp", "theWindow", "toolbar=0, resizable=no, status=1, scrollbars=no, copyhistory=0, width=" + w + ", height=" + h + ", top=" + top + ", left=" + left); }
	/* 아이디중복확인 */
	if(tar=='id_check')
		{ var w=360; var h=240; var top=(screen.availHeight-h)/2; var left=(screen.availWidth-w)/2; window.open("/member/id_check.asp", "theWindow", "toolbar=0, resizable=no, status=1, scrollbars=no, copyhistory=0, width=" + w + ", height=" + h + ", top=" + top + ", left=" + left); }
	/* 우편번호찾기 */
	if(tar=='post')
		{ var w=360; var h=405; var top=(screen.availHeight-h)/2; var left=(screen.availWidth-w)/2; window.open("/member/post.asp", "theWindow", "toolbar=0, resizable=no, status=1, scrollbars=no, copyhistory=0, width=" + w + ", height=" + h + ", top=" + top + ", left=" + left); }

	/* 바로구매 */
	if(tar=='payment')
		location.href = "/pay/payment.asp", "_self";
	/* 바로구매 */
	if(tar=='account')
		location.href = "/pay/account.asp", "_self";
	/* 장바구니 */
	if(tar=='cart')
		location.href = "/cart/cart.asp", "_self";
	/* 관심상품 */
	if(tar=='wish')
		location.href = "/cart/wish.asp", "_self";

/* 즐겨찾기 */
	if(tar=='favorite')
		 bookmarksite('우수학생센터 공우','http://');
	
	/* 메인으로 */
	if(tar=='main')
		location.href = "/index.asp", "_self";

}
function bookmarksite(title,url) { 
 // Internet Explorer
 if(document.all){
  window.external.AddFavorite(url, title); 
 }
 // Firefox
 else if (window.sidebar) // firefox 
 {
  window.sidebar.addPanel(title, url, ""); 
 }
 // Google Chrome & Safari
 else if(window.chrome || navigator.appName=="Netscape"){
  alert("Ctrl+D키를 누르시면 즐겨찾기에 추가하실 수 있습니다.");
 }
 // Opera
 else if(window.opera && window.print)
 { // opera 
  var elem = document.createElement('a'); 
  elem.setAttribute('href',url); 
  elem.setAttribute('title',title); 
  elem.setAttribute('rel','sidebar'); 
  elem.click(); 
 }
		
}