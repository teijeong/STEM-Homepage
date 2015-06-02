    /*
    =======================================================================
     이미지 슬라이드
     ydahn
     2007.06.25
    -----------------------------------------------------------------------
     사용예제 (주! [슬라이드ID]("SlideTest")와  생성하는 변수명(SlideTest)은 반드시 동일 해야 함)
                 <script type="text/javascript" src="/lib/js/news.slide.v.1.0.js"></script>
                <!-- 우측 포토/동영상 박스 -->
                <div class="mod_common03 mod_photoMovie">
                    <div class="inner">
                        <h2>포토/동영상</h2>
                            <script>
                                SlideTest = new NewsImageSlide("SlideTest");                                                        // 기본 값 : 3개 이미지가 보이면서, 1개씩 이동 , 왼쪽으로 이동 , 이미지 크기 86x66, 3초마다 이동

                                // 기타 옵션(이미지 수, 다음 보여질 묶음 수, 이미지 가로 크기, 이미지 세로 크기, 슬라이드 속도)을 적용할 경우
                                //SlideTest = new NewsImageSlide("SlideTest", 3);                                                // 3개 이미지가 보이면서, 1개씩 이동 , 왼쪽으로 이동 , 이미지 크기 86x66, 3초마다 이동
                                //SlideTest = new NewsImageSlide("SlideTest", 3, 1);                                        // 3개 이미지가 보이면서, 1개씩 이동 , 왼쪽으로 이동 , 이미지 크기 86x66, 3초마다 이동
                                //SlideTest = new NewsImageSlide("SlideTest", 3, 3, 1);                                    // 3개 이미지가 보이면서, 3개씩 이동 , 오른쪽으로 이동 , 이미지 크기 86x66, 3초마다 이동
                                //SlideTest = new NewsImageSlide("SlideTest", 3, 3, 1, 66, 66);                    // 3개 이미지가 보이면서, 3개씩 이동 , 오른쪽으로 이동 , 이미지 크기 66x66, 3초마다 이동
                                //SlideTest = new NewsImageSlide("SlideTest", 3, 3, 1, 66, 66, 5000);        // 3개 이미지가 보이면서, 3개씩 이동 , 오른쪽으로 이동 , 이미지 크기 66x66, 5초마다 이동
                            
                                // 슬라이드에 이미지 추가 (링크URL, 이미지URL, 제목)
                                SlideTest.add("http://news.nate.com/","http://newsimg.nate.com/img/2007/tmp/tmp06.gif","테스트0");
                                SlideTest.add("http://news.nate.com/","http://newsimg.nate.com/img/2007/tmp/tmp06.gif","테스트1");
                                SlideTest.add("http://news.nate.com/","http://newsimg.nate.com/img/2007/tmp/tmp06.gif","테스트2");
                                SlideTest.add("http://news.nate.com/","http://newsimg.nate.com/img/2007/tmp/tmp06.gif","테스트3");
                                SlideTest.add("http://news.nate.com/","http://newsimg.nate.com/img/2007/tmp/tmp06.gif","테스트4");
                                SlideTest.add("http://news.nate.com/","http://newsimg.nate.com/img/2007/tmp/tmp06.gif","테스트5");
                                SlideTest.add("http://news.nate.com/","http://newsimg.nate.com/img/2007/tmp/tmp06.gif","테스트6");
                                SlideTest.add("http://news.nate.com/","http://newsimg.nate.com/img/2007/tmp/tmp06.gif","테스트7");
                                SlideTest.add("http://news.nate.com/","http://newsimg.nate.com/img/2007/tmp/tmp06.gif","테스트8");
                            
                                SlideTest.Start();
                            </script>
                        </div>
                    </div>
    -----------------------------------------------------------------------
     변경날짜        변경자    변경내용
    =======================================================================
    
*/
    
    function NewsImageSlide()
    {
        // 매개변수 입력
        this.SlideID        = arguments[0];    // 슬라이드ID
        this.ShowCount    = arguments[1];    // 보여질 이미지 수
        this.ShowGroup    = arguments[2];    // 다음 보여질 묶음 수
        this.ShowDirec    = arguments[3];    // 이미지 이동 방향 
        this.ImgWidth        = arguments[4];    // 슬라이드 이미지 가로 크기
        this.ImgHeight    = arguments[5];    // 슬라이드 이미지 세로 크기
        this.SlideSpeed    = arguments[6];    // 슬라이드 속도

        
        // Start ------------------------------ 입력하지 않는 경우 기본값 설정
        
        // 보여질 이미지 수 (기본값 : 3개)
        if (this.ShowCount == null)
            this.ShowCount = 3;
        
        // 다음 보여질 묶음 수 (기본값 : 1개)
        if (this.ShowGroup == null)
            this.ShowGroup = 1;
            
        // 이미지 이동 방향 (기본:왼쪽 = 0)
        if (this.ShowDirec == null)
            this.ShowDirec = 0;
        
        // 이미지 크기    (기본값 : 86x66)
        if ( this.ImgWidth    == null || this.ImgHeight == null)
        {
            // 매개변수 값 입력시 이미지 크기 86x66으로 고정
            this.ImgWidth    = 86;
            this.ImgHeight    = 66;
        }

        // 슬라이드 속도 (기본값 : 3초 = 3,000ms)
        if (this.SlideSpeed == null)
            this.SlideSpeed    = 3000;
            
        // End ------------------------------ 입력하지 않는 경우 기본값 설정
        
        this.Item        = new Array();    // 이미지 정보를 담을 배열
        this.ItemCount    = 0;                        // 이미지 정보 배열 크기
        this.CurShow    = 0;                        // 현재 보여지는 첫번째 이미지 번호
        this.Stop        = false;                // 중지여부 (이미지 슬라이드 부분 마우스 Over시 중지를 위해)

            // 슬라이드 이미지 정보 추가
            // 사용시 매개변수로 XXX.add(링크URL, 이미지URL, 이미지 제목)을 입력
            this.add = function () {
                SlideImage    = arguments[0];        // 이미지 URL
                Title    = arguments[1];        // 이미지 URL
                LinkTag    = arguments[2];        // 이미지 URL
                Content    = arguments[3];        // 이미지 URL

                // 이미지 깜빡임을 없에기 위해 미리 이미지 로딩
                (new Image).src = SlideImage;
                
                SlideHtml = "";
                SlideHtml += "<div style=\"list-style:none; padding:0;\"><table width=\"100%\" border=\"0\" cellpadding=\"0\" cellspacing=\"0\" style='table-layout:fixed; word-wrap:break-word;'>";
                SlideHtml += "  <tr><td align=\"left\" valign=\"top\" width='190'>"+ LinkTag + SlideImage + "</a></td><td valign='top' align='left'>"+LinkTag+"<span style='font-size:12px; font-weight:bold; color:#0a4f9d; line-height:1.4;'>"+Title+"</span></a><div style='line-height:1.5; font-size:11px; color:#888888; padding-top:5px;'>"+Content+"</div></td></tr>";
                SlideHtml += "</table></div>";


                // HTML소스 Item 등록
                this.Item[this.ItemCount] = SlideHtml;
                this.ItemCount++;
                
            }
        
            // 초기 셋팅
            // 이미지 슬라이드가 들어갈 DIV와 다음 및 이전 버튼 이미지
            this.Start = function () {
                
                SlideBase = "";
                
                // 파라미터 값 확인용
                // ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
                // SlideBase += "<center>" + this.SlideID + " : " + this.ShowCount + "," + this.ShowGroup + "," + this.ShowDirec + "," + this.ImgWidth + "," + this.ImgHeight + "," + this.SlideSpeed + "</center>";
                // ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
                
                SlideBase += "                        <div onMouseOver=\""+this.SlideID+".MouseOver();\" onMouseOut=\""+this.SlideID+".MouseOut();\" width='100%'>";
                //SlideBase += "                            <div style=\"float:left; list-style:none; padding:45px 10px 0 10px; white-space:nowrap;\"><img src='images/btn_ar_pre.png' onClick=\""+this.SlideID+".Prev();\" style=\"cursor:pointer;\"></div>"
                SlideBase += "                            <div id=\"" + this.SlideID + "\"></div>"
                //SlideBase += "                            <div style=\"float:right; list-style:none; padding:45px 10px 0 0; white-space:nowrap;\"><img src='/images/btn_ar_next.png' onClick=\""+this.SlideID+".Next();\" style=\"cursor:pointer;\"></div>"
                SlideBase += "                        </div>"

                document.write(SlideBase);
                
                //alert(SlideBase);

                this.ChangeImage();
                
                setTimeout(this.SlideID + '.Rolling()',this.SlideSpeed);

            }
            
            // 자동 롤링
            this.Rolling = function(){
                if(!this.Stop)
                {
                    this.MoveImage(this.ShowDirec);
                    this.ChangeImage();
                }
                setTimeout(this.SlideID + '.Rolling()',this.SlideSpeed);
            }
            
            // 다음 버튼 기능
            this.Next = function(){    
                
                this.MoveImage(0);
                this.ChangeImage();
                
            }
            
            // 이전 버튼 기능
            this.Prev = function(){    

                this.MoveImage(1);
                this.ChangeImage();
                
            }

            // 슬라이드 이미지 이동 기능
            this.MoveImage = function() {
                ShowDirec        = arguments[0];        // 이동 방향 (0:왼쪽, 1:오른쪽)
                
                if(ShowDirec == 0){
    
                    this.CurShow = this.CurShow + this.ShowGroup;
                    
                    if(this.CurShow >= this.ItemCount)
                        this.CurShow = 0;
                }
                else
                {
                    this.CurShow = this.CurShow - this.ShowGroup;
                    
                    if(this.CurShow < 0)
                        this.CurShow = this.ItemCount - 1;
                }
                
            }
            
            // 슬라이드 이미지 변경 기능
            this.ChangeImage = function() {
                tmpHTML = "";
                
                for( i = this.CurShow; i < (this.CurShow + this.ShowCount); i++ )
                {
                    tmpHTML += this.Item[(i % this.ItemCount)];
                }
                Obj = document.getElementById(this.SlideID);
                Obj.innerHTML= tmpHTML;
                //alert(tmpHTML);
            }
            
            // 이미지 슬라이드 부분 마우스 Over 시 정지 설정
            this.MouseOver = function(){
                this.Stop = true;
            }
            
            // 이미지 슬라이드 부분 마우스 Out 시 정지 해제
            this.MouseOut = function(){
                this.Stop = false;
            }
    }