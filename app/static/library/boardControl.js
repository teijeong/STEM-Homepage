//캘린더 컨트롤////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function viewCalendarThumMainArea(strYear,strMonth){
    var params = "c_year="+strYear+"&c_month="+strMonth;
    new Ajax.Updater('calendarthumDiv', '/ajaxpage/calendarMain.asp', { method:'post',evalScripts:true, encoding : 'utf-8', parameters:params });
}
function viewCalendarArea(strYear,strMonth){
    var params = "c_year="+strYear+"&c_month="+strMonth;
    new Ajax.Updater('calendarDiv', '/ajaxpage/calendar.asp', { method:'post',evalScripts:true, encoding : 'utf-8', parameters:params });
}
function calendarGoMain(value,Year,Month){
    if(Month+value==0){
        Year--;
        Month=12;
    }
    else if(Month+value==13){
        Year++;
        Month=1;
    }
    else{ Month=Month+value;}

    viewCalendarThumMainArea(Year,Month);
}
function calendarGo(value,Year,Month){
    if(Month+value==0){
        Year--;
        Month=12;
    }
    else if(Month+value==13){
        Year++;
        Month=1;
    }
    else{ Month=Month+value;}

    viewCalendarArea(Year,Month);
}

function goPwdpage(sort,index){
    var f=document.boardActfrm;
    f.sort.value=sort;
    f.idx.value=index;
    f.mode.value="pwdinput";
    f.submit();
}

function goMemberCheck(sort,index){
    var f=document.boardActfrm;
    if (sort=="modify"){
        f.action="";
        f.mode.value=sort;
    }else{
        f.action="/board/ok_bbsDel.asp";
    }
    f.idx.value=index;
    f.submit();
}

//게시판 비밀번호 컨트롤///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function boardcheckpwd(sort){
    var f=document.passFrm;

    if(f.pwd.value==""){
        alert("비밀번호를 입력하세요.");
        f.pwd.focus();
        return;
    }

    var params = Form.serialize($('passFrm'));
    new Ajax.Updater('boardactDiv', "/ajaxpage/boardPassSet.asp", 
    { method:'post',evalScripts:true, encoding : 'utf-8', parameters:params ,
        onComplete: function(){

            if(sort=="view"){
                document.boardActfrm.action=document.boardActfrm.prepage.value;
                document.boardActfrm.mode.value="view";
                document.boardActfrm.prepage.value="";
            }else if(sort=="bbsmodify"){
                document.boardActfrm.action=document.boardActfrm.prepage.value;
                document.boardActfrm.mode.value="modify";
                document.boardActfrm.prepage.value="";
            }else if(sort=="bbsdel"){
                document.boardActfrm.action='/board/ok_bbsdel.asp';
            }
            document.boardActfrm.submit();

        }
    });
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//게시판 함수//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function searchGo(){
    var f=document.searchfrm;
    f.submit();
}

function sendit(){
    var f=document.boardfrm;
    if(f.writer.value==""){
        alert("이름을 입력하세요.");
        f.writer.focus();
        return;
    }
    if(f.pass){
        if(f.pass.value==""){
            alert("글 비밀번호를 입력하세요.");
            f.pass.focus();
            return;
        }
    }
    if(f.tel){
        if(f.tel.value==""){
            alert("연락처를 입력하세요.");
            f.tel.focus();
            return;
        }
    }
    if(f.title.value==""){
        alert("제목을 입력하세요");
        f.title.focus();
        return;
    }
    if(CKEDITOR.instances.content.getData() == '') {
        alert('내용을 입력해 주세요.');
        CKEDITOR.instances.content.focus();
        return;
    }
    if(f.imgfiles){
        if(uploadImg_check(f.imgfiles.value,"이미지를 올바로 입력하세요.")==false){
            return;
        }
    }
    f.submit();
}
function modifysendit(){
    var f=document.boardfrm;
    if(f.writer.value==""){
        alert("이름을 입력하세요.");
        f.writer.focus();
        return;
    }
    if(f.pass){
        if(f.pass.value==""){
            alert("글 비밀번호를 입력하세요.");
            f.pass.focus();
            return;
        }
    }
    if(f.tel){
        if(f.tel.value==""){
            alert("연락처를 입력하세요.");
            f.tel.focus();
            return;
        }
    }
    if(f.title.value==""){
        alert("제목을 입력하세요");
        f.title.focus();
        return;
    }
    if(CKEDITOR.instances.content.getData() == '') {
        alert('내용을 입력해 주세요.');
        CKEDITOR.instances.content.focus();
        return;
    }
    if(f.imgfiles){
        if(f.imgDel_Chk.checked){
            if(uploadImg_check(f.imgfiles.value,"이미지를 올바로 입력하세요.")==false){
                return;
            }
        }
    }
    f.submit();
}

function replysendit(){
    var f=document.boardfrm;
    if(f.writer.value==""){
        alert("이름을 입력하세요.");
        f.writer.focus();
        return;
    }
    if(f.pass){
        if(f.pass.value==""){
            alert("글 비밀번호를 입력하세요.");
            f.pass.focus();
            return;
        }
    }
    if(f.title.value==""){
        alert("제목을 입력하세요");
        f.title.focus();
        return;
    }
    if(CKEDITOR.instances.content.getData() == '') {
        alert('내용을 입력해 주세요.');
        CKEDITOR.instances.content.focus();
        return;
    }
    f.submit();
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//게시판 코멘트 컨트롤/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
var gb_ViewDivID="";

function viewBoardCommentArea(index,bbscode,page){
    var params = "idx="+index+"&bbscode="+bbscode+"&page="+page;
    new Ajax.Updater('boardCommentDiv', '/ajaxpage/boardCommentArea.asp', { method:'post',evalScripts:true, encoding : 'utf-8', parameters:params });
}
function viewboardCommentPwdInput(memYN,temp,index,bbscode,page,e){
    if(gb_ViewDivID!=""){
        document.getElementById(gb_ViewDivID).style.display="none";
    }

    if(memYN==''){
        if(temp=='visible'){
            var params = "idx="+index+"&bbscode="+bbscode+"&page="+page;
            new Ajax.Updater('boardcommentPwdINPUTDiv', '/ajaxpage/boardCommentPwdinput.asp', { method:'post',evalScripts:true, encoding : 'utf-8', parameters:params });

            if(typeof(document.all('boardcommentPwdINPUTDiv'))!='undefined'){
                
                var _x = e.clientX+(document.documentElement.scrollLeft?document.documentElement.scrollLeft:document.body.scrollLeft)-130;
                var _y = e.clientY+(document.documentElement.scrollTop?document.documentElement.scrollTop:document.body.scrollTop)+10; 
    
                boardcommentPwdINPUTDiv.style.posLeft=_x;
                boardcommentPwdINPUTDiv.style.posTop=_y;
                boardcommentPwdINPUTDiv.style.zIndex='10000';
            }
        }
        if(typeof(document.all('boardcommentPwdINPUTDiv'))!='undefined'){
            boardcommentPwdINPUTDiv.style.visibility=temp;
        }
    }else{
        var val=confirm("해당 코멘트를 삭제하시겠습니까?");
        if (val){
            var params = "idx="+index+"&bbscode="+bbscode+"&page="+page;
            new Ajax.Updater('boardactDiv', "/ajaxpage/boardCommentDel.asp", { method:'post',evalScripts:true, encoding : 'utf-8', parameters:params });
        }
    }
}
function boardcommentcheckpwd(){
    if(document.boardcommentpwdchk.pwd.value==""){
        alert("비밀번호를 입력하세요.");
        document.boardcommentpwdchk.pwd.focus();
        return;
    }
    var params = Form.serialize($('boardcommentpwdchk'));
    new Ajax.Updater('boardactDiv', "/ajaxpage/boardCommentDel.asp", { method:'post',evalScripts:true, encoding : 'utf-8', parameters:params });
    viewboardCommentPwdInput('','hidden');
}
function boardcommentGo(){
    f=document.commentfrm;
    var params = Form.serialize($('commentfrm'));

    if(f.name){
        if(f.name.value==""){
            alert("이름을 입력해주세요.");
            f.name.focus();
            return;
        }
    }
    if(f.pwd){
        if(f.pwd.value==""){
            alert("비밀번호를 입력해주세요.");
            f.pwd.focus();
            return;
        }
    }
    if(f.content.value==false){
        alert("내용을 입력해주세요.");
        f.content.focus();
        return;
    }
    new Ajax.Updater('boardactDiv', "/ajaxpage/BoardCommentAddOK.asp", { method:'post',evalScripts:true, encoding : 'utf-8', parameters:params });
}

function viewboardCommentReply(targetDiv,index,bbscode,page){
    if(gb_ViewDivID!=""){
        document.getElementById(gb_ViewDivID).style.display="none";
    }
    gb_ViewDivID=targetDiv;
    document.getElementById(gb_ViewDivID).style.display="inline";

    var params = "idx="+index+"&bbscode="+bbscode+"&page="+page;
    new Ajax.Updater(targetDiv, "/ajaxpage/boardCommentReply.asp", { method:'post',evalScripts:true, encoding : 'utf-8', parameters:params });
}

function boardcommentEditView(targetDiv,index,bbscode,page){
    if(gb_ViewDivID!=""){
        document.getElementById(gb_ViewDivID).style.display="none";
    }
    gb_ViewDivID=targetDiv;
    document.getElementById(gb_ViewDivID).style.display="inline";

    var params = "idx="+index+"&bbscode="+bbscode+"&page="+page;
    new Ajax.Updater(targetDiv, "/ajaxpage/boardCommentEdit.asp", { method:'post',evalScripts:true, encoding : 'utf-8', parameters:params });
}

function boardcommentReply(thisFORM){
    var f=eval(thisFORM)
    
    var params = Form.serialize($(thisFORM));
    targetPage="/ajaxpage/BoardCommentReplyOK.asp"

    if(f.name){
        if(f.name.value==""){
            alert("이름을 입력해주세요.");
            f.name.focus();
            return;
        }
    }
    if(f.pwd){
        if(f.pwd.value==""){
            alert("비밀번호를 입력해주세요.");
            f.pwd.focus();
            return;
        }
    }
    if(f.content.value==false){
        alert("내용을 입력해주세요.");
        f.content.focus();
        return;
    }
    new Ajax.Updater('boardactDiv', targetPage, { method:'post',evalScripts:true, encoding : 'utf-8', parameters:params });
}

function boardcommentEdit(thisFORM){
    var f=eval(thisFORM)
    
    var params = Form.serialize($(thisFORM));
    targetPage="/ajaxpage/BoardCommentEditOK.asp"

    if(f.pwd){
        if(f.pwd.value==""){
            alert("비밀번호를 입력해주세요.");
            f.pwd.focus();
            return;
        }
    }
    if(f.content.value==false){
        alert("내용을 입력해주세요.");
        f.content.focus();
        return;
    }
    new Ajax.Updater('boardactDiv', targetPage, { method:'post',evalScripts:true, encoding : 'utf-8', parameters:params });
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////