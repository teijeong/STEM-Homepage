	<!--footer-->
	<div id="footer">
		<div class="foot"><img src="/images/copyright.gif" /></div>
		<div class="foot_familysite">
			<select name="" class="input" style="width:150px;" onChange="navChange3(this); return true;">
			<option selected>Family Site</option>
			<option value='http://eng.snu.ac.kr' >서울대학교 공과대학</option>
			<option value='http://www.snu.ac.kr' >서울대학교</option>
			<option value='http://www.dongbuhitek.co.kr' >동부하이텍</option>
			<option value='http://www.dongbufoundation.or.kr' >동부문화재단</option>
			</select>
			<script language="javascript">
			function navChange3(popup) {
			  if (popup.options[popup.selectedIndex].value != "")
			  {
				window.open(popup.options[popup.selectedIndex].value, '_blank');
				popup.selectedIndex=0;
			  }
			}
			</script>
		</div>
	</div>
	<!--//footer-->
</div>

</body>
</html>
