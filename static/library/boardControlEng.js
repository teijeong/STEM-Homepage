//게시판 비밀번호 컨트롤///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function viewPwdInput(temp,sort,index,e){
    if(temp=='visible'){
        var params = Form.serialize($('boardActfrm'));
        var params = params+"&sort="+sort+"&idx="+index;
        new Ajax.Updater('boardPwdINPUTDiv', '/eng/ajaxpage/bbs_Pwdinput.asp', { method:'post',evalScripts:true, encoding : 'utf-8', parameters:params });

        if(typeof(document.all('boardPwdINPUTDiv'))!='undefined'){
            var _x = e.clientX+(document.documentElement.scrollLeft?document.documentElement.scrollLeft:document.body.scrollLeft)-130;
            var _y = e.clientY+(document.documentElement.scrollTop?document.documentElement.scrollTop:document.body.scrollTop)+10; 

            boardPwdINPUTDiv.style.posLeft=_x;
            boardPwdINPUTDiv.style.posTop=_y;
            boardPwdINPUTDiv.style.zIndex='10000';
        }
    }
    if(typeof(document.all('boardPwdINPUTDiv'))!='undefined'){
        boardPwdINPUTDiv.style.visibility=temp;
    }
}

function boardcheckpwd(sort){
    if(document.boardpwdchk.pwd.value==""){
        alert("Input Password!!!");
        document.boardpwdchk.pwd.focus();
        return;
    }
    if(sort=="view"){
        document.boardpwdchk.action='?mode=view';
    }else if(sort=="bbsmodify"){
        document.boardpwdchk.action='?mode=modify';
    }else if(sort=="bbsdel"){
        document.boardpwdchk.action='/eng/board/ok_bbsdel.asp';
    }
    document.boardpwdchk.submit();
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


//게시판 코멘트 컨트롤/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function viewBoardCommentArea(index,bbscode,page){
    var params = "idx="+index+"&bbscode="+bbscode+"&page="+page;
    new Ajax.Updater('boardCommentDiv', '/eng/ajaxpage/boardCommentArea.asp', { method:'post',evalScripts:true, encoding : 'utf-8', parameters:params });
}
function boardcommentEditView(idx){
    srcz = "/eng/ajaxpage/boardCommentEditChk.asp?idx="+idx;
    boardCommentresultProc.src=srcz;
}
function viewboardCommentPwdInput(memYN,temp,index,bbscode,page,e){
    if(memYN==''){
        if(temp=='visible'){
            var params = "idx="+index+"&bbscode="+bbscode+"&page="+page;
            new Ajax.Updater('boardcommentPwdINPUTDiv', '/eng/ajaxpage/boardCommentPwdinput.asp', { method:'post',evalScripts:true, encoding : 'utf-8', parameters:params });

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
        var val=confirm("Remove Comment?");
        if (val){
            var params = "idx="+index+"&bbscode="+bbscode+"&page="+page;
            new Ajax.Updater('boardactDiv', "/eng/ajaxpage/boardCommentDel.asp", { method:'post',evalScripts:true, encoding : 'utf-8', parameters:params });
        }
    }
}
function boardcommentcheckpwd(){
    if(document.boardcommentpwdchk.pwd.value==""){
        alert("Input Password!!!");
        document.boardcommentpwdchk.pwd.focus();
        return;
    }
    var params = Form.serialize($('boardcommentpwdchk'));
    new Ajax.Updater('boardactDiv', "/eng/ajaxpage/boardCommentDel.asp", { method:'post',evalScripts:true, encoding : 'utf-8', parameters:params });
    viewboardCommentPwdInput('','hidden');
}
function boardcommentGo(commentSort){
    if(commentSort=="add"){
        f=document.commentfrm;
        var params = Form.serialize($('commentfrm'));
        targetPage="/eng/ajaxpage/BoardCommentAddOK.asp"
    }else{
        f=document.commenteditfrm;
        var params = Form.serialize($('commenteditfrm'));
        targetPage="/eng/ajaxpage/BoardCommentEditOK.asp"
    }
    if(f.name){
        if(f.name.value==""){
            alert("Input Name!!!");
            f.name.focus();
            return;
        }
    }
    if(f.pwd){
        if(f.pwd.value==""){
            alert("Input Password!!!");
            f.pwd.focus();
            return;
        }
    }
    if(f.content.value==false){
        alert("Input Content!!!");
        f.content.focus();
        return;
    }
    new Ajax.Updater('boardactDiv', targetPage, { method:'post',evalScripts:true, encoding : 'utf-8', parameters:params });
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
        alert("Input Name!!!");
        f.writer.focus();
        return;
    }
    if(f.pass){
        if(f.pass.value==""){
            alert("Input Password!!!");
            f.pass.focus();
            return;
        }
    }
    if(f.title.value==""){
        alert("Input Title!!!");
        f.title.focus();
        return;
    }
    if(f.content.value==""){
        alert("Input Content!!!");
        f.content.focus();
        return;
    }
    if(f.imgfiles){
        if(uploadImg_check(f.imgfiles.value,"Image Format Check!!!")==false){
            return;
        }
    }
    f.submit();
}
function modifysendit(){
    var f=document.boardfrm;
    if(f.writer.value==""){
        alert("Input Name!!!");
        f.writer.focus();
        return;
    }
    if(f.pass){
        if(f.pass.value==""){
            alert("Input Password!!!");
            f.pass.focus();
            return;
        }
    }
    if(f.title.value==""){
        alert("Input Title!!!");
        f.title.focus();
        return;
    }
    if(f.content.value==""){
        alert("Input Content!!!");
        f.content.focus();
        return;
    }
    if(f.imgfiles){
        if(uploadImg_check(f.imgfiles.value,"Image Format Check!!!")==false){
            return;
        }
    }
    f.submit();
}

function replysendit(){
    var f=document.boardfrm;
    if(f.writer.value==""){
        alert("Input Name!!!");
        f.writer.focus();
        return;
    }
    if(f.pass){
        if(f.pass.value==""){
            alert("Input Password!!!");
            f.pass.focus();
            return;
        }
    }
    if(f.title.value==""){
        alert("Input Title!!!");
        f.title.focus();
        return;
    }
    if(f.content.value==""){
        alert("Input Content!!!");
        f.content.focus();
        return;
    }f.submit();
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////