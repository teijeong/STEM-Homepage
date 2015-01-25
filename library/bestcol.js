	var html;
	var i=0;
	
	function formatnumber(v1,v2){
	var str=new Array();
	v1=String(v1);
	for(var i=1;i<=v1.length;i++){
		if(i%v2) str[v1.length-i]=v1.charAt(v1.length-i);
		else str[v1.length-i]=','+v1.charAt(v1.length-i);
	}
	return str.join('').replace(/^,/,'');
	}

	function startscroll(conf)
	{ // 스크롤 시작
		i=0;
		for (i in conf['scroll_content']) conf['n_panel']++; // 스크롤 게시물 갯수 계산
		conf['n_panel'] = conf['n_panel'] -1 ; // 스크롤 게시물 배열 끝 Key 번호로 리셋팅
		conf['startPanel'] = Math.round(Math.random()*conf['n_panel']); // 스크롤할 게시물 배열 시작 Key 번호 셋팅(랜덤 방식)

		// 스크롤할 게시물 area 삽입 : Start
		// 시작 Key 번호가 첫 Key 번호와 동일 한 경우
		if(conf['startPanel'] == 0) 
		{
			i=0;
			for (i in conf['scroll_content']) 
				insert_area(conf,conf['total_area'], conf['total_area']++); // area 삽입
		}
		// 시작 Key 번호가 끝 Key 번호와 동일 한 경우
		else if(conf['startPanel'] == conf['n_panel']) 
		{
			insert_area(conf,conf['startPanel'], conf['total_area']++);
			for (i=0; i<conf['startPanel']; i++) 
				insert_area(conf,i, conf['total_area']++); // area 삽입
		}
		// 시작 Key 번호가 첫 Key 번호 보다 크거나 끝 Key 번호 보다 작을 경우
		else if((conf['startPanel'] > 0) || (conf['startPanel'] < conf['n_panel'])) 
		{
			insert_area(conf,conf['startPanel'], conf['total_area']++);
			for (i=conf['startPanel']+1; i<=conf['n_panel']; i++) 
				insert_area(conf,i, conf['total_area']++); // area 삽입
			for (i=0; i<conf['startPanel']; i++) 
				insert_area(conf,i, conf['total_area']++); // area 삽입
		}
		// 스크롤할 게시물 area 삽입 : End
		
		window.setTimeout("scrolling("+conf['name']+")",conf['waitingtime']);
	}
	function scrolling(conf){ // 실제로 스크롤 하는 부분
		if (conf['bMouseOver'] && conf['wait_flag'])
		{
			for (i=0;i<conf['total_area'];i++){
				tmp = document.getElementById(conf['areaname']+i).style;
				if (conf['axis']=='x'){ // 스크롤러 롤링 x축 인 경우
					if( conf['arrow'] == 'lt' ){ // LEFT&TOP 방향
						tmp.top = parseInt(tmp.top)-conf['scrollspeed'];
						if (parseInt(tmp.top) <= -conf['scrollerheight']){
							tmp.top = conf['scrollerheight']*(conf['total_area']-1);
						}
					} else { // RIGHT&BOTTOM 방향
						tmp.top = parseInt(tmp.top)+conf['scrollspeed'];
						if (parseInt(tmp.top) >= (conf['scrollerheight']*(conf['total_area']-1))){
							tmp.top = -conf['scrollerheight'];
						}						
					}					
				} else { // 스크롤러 롤링 y축 인 경우
					if( conf['arrow'] == 'lt' ){ // LEFT&TOP 방향
						tmp.left = parseInt(tmp.left)-conf['scrollspeed'];
						if (parseInt(tmp.left) <= -conf['scrollerheight']){
							tmp.left = conf['scrollerheight']*(conf['total_area']-1);
						}
					} else { // RIGHT&BOTTOM 방향
						tmp.left = parseInt(tmp.left)+conf['scrollspeed'];
						if (parseInt(tmp.left) >= (conf['scrollerheight']*(conf['total_area']-1))){
							tmp.left = -conf['scrollerheight'];
						}						
					}					
				}
				if (++conf['s_tmp'] == (conf['s_amount']-1)*conf['scroll_content'].length){
					conf['wait_flag']=false;
					window.setTimeout(conf['name']+"['wait_flag']=true;"+conf['name']+"['s_tmp']=0;",conf['waitingtime']);
				}
			}
		}
		window.setTimeout("scrolling("+conf['name']+")",1);
	}
	/*
	idx : 스크롤 게시물 번호
	n : 게시물 출력 area 번호
	*/
	function insert_area(conf,idx, n){ // area 삽입
		if (conf['axis']=='x'){ // 스크롤러 롤링 x축 인 경우
			var divwidth = '100%';
			var divheight = conf['scrollerheight'];
			var divtop = (conf['scrollerheight']*n);			
			var divleft = '0';
		} else { // 스크롤러 롤링 y축 인 경우
			var divwidth = conf['scrollerheight'];
			var divheight = '100%';
			var divtop = '0';
			var divleft = (conf['scrollerheight']*n);
		}
		html='<div style="position: absolute; width:'+divwidth+'; height:'+divheight+'; top: '+divtop+'px; left: '+divleft+'px;" id="'+conf['areaname']+n+'">\n';
		html+=conf['scroll_content'][idx]+'\n';
		html+='</div>\n';
		document.write(html);
	}
	function arrow_invert(conf,arrow){
		conf['arrow']=(arrow=='lt'?'lt':'rb');
		
		for (i=0;i<conf['total_area'];i++){
			tmp = document.getElementById(conf['areaname']+i).style;
			if (conf['axis']=='x'){ // 스크롤러 롤링 x축 인 경우
				if( conf['arrow'] == 'lt' ){ // LEFT&TOP 방향
					if( parseInt(tmp.top) >= 0 ) tmp.top = (parseInt(parseInt(tmp.top) / parseInt(conf['scrollerheight']))) * parseInt(conf['scrollerheight'])+1;
					else tmp.top = (parseInt(parseInt(tmp.top) / parseInt(conf['scrollerheight']))-1) * parseInt(conf['scrollerheight'])+1;
					if (parseInt(tmp.top) <= -conf['scrollerheight']){
						tmp.top = conf['scrollerheight']*(conf['total_area']-1);
					}
				} else { // RIGHT&BOTTOM 방향
					if( parseInt(tmp.top) >= 0 ) tmp.top = (parseInt(parseInt(tmp.top) / parseInt(conf['scrollerheight']))+1) * parseInt(conf['scrollerheight'])-1;
					else tmp.top = (parseInt(parseInt(tmp.top) / parseInt(conf['scrollerheight']))) * parseInt(conf['scrollerheight'])-1;
					if (parseInt(tmp.top) >= (conf['scrollerheight']*(conf['total_area']-1))){
						tmp.top = -conf['scrollerheight'];
					}						
				}					
			} else { // 스크롤러 롤링 y축 인 경우
				if( conf['arrow'] == 'lt' ){ // LEFT&TOP 방향
					if( parseInt(tmp.left) >= 0 ) tmp.left = (parseInt(parseInt(tmp.left) / parseInt(conf['scrollerheight']))) * parseInt(conf['scrollerheight'])+1;
					else tmp.left = (parseInt(parseInt(tmp.left) / parseInt(conf['scrollerheight']))-1) * parseInt(conf['scrollerheight'])+1;
					if (parseInt(tmp.left) <= -conf['scrollerheight']){
						tmp.left = conf['scrollerheight']*(conf['total_area']-1);
					}
				} else { // RIGHT&BOTTOM 방향
					if( parseInt(tmp.left) >= 0 ) tmp.left = (parseInt(parseInt(tmp.left) / parseInt(conf['scrollerheight']))+1) * parseInt(conf['scrollerheight'])-1;
					else tmp.left = (parseInt(parseInt(tmp.left) / parseInt(conf['scrollerheight']))) * parseInt(conf['scrollerheight'])-1;
					if (parseInt(tmp.left) >= (conf['scrollerheight']*(conf['total_area']-1))){
						tmp.left = -conf['scrollerheight'];
					}						
				}					
			}
		}
	}
