//게시판 코멘트 컨트롤///////////////////////////////
function viewBoardCommentArea(index,bbscode,page){
    var params = "idx="+index+"&bbscode="+bbscode+"&page="+page;
    new Ajax.Updater('boardCommentDiv', '/intra/ajaxpage/boardCommentArea.asp', { method:'post',evalScripts:true, encoding : 'utf-8', parameters:params });
}
function boardcommentEditView(idx){
    srcz = "/intra/ajaxpage/boardCommentEditChk.asp?idx="+idx;
    boardCommentresultProc.src=srcz;
}
function boardcommentGo(commentSort){
    if(commentSort=="add"){
        f=document.commentfrm;
        var params = Form.serialize($('commentfrm'));
        targetPage="/intra/ajaxpage/BoardCommentAddOK.asp"
    }else{
        f=document.commenteditfrm;
        var params = Form.serialize($('commenteditfrm'));
        targetPage="/intra/ajaxpage/BoardCommentEditOK.asp"
    }
    if(f.content.value==false){
        alert("내용을 입력해주세요.");
        f.content.focus();
        return;
    }
    new Ajax.Updater('boardactDiv', targetPage, { method:'post',evalScripts:true, encoding : 'utf-8', parameters:params });
}
function viewboardCommentPwdInput(memYN,temp,index,bbscode,page){
    var val=confirm("해당 코멘트를 삭제하시겠습니까?");
    if (val){
        var params = "idx="+index+"&bbscode="+bbscode+"&page="+page;
        new Ajax.Updater('boardactDiv', "/intra/ajaxpage/boardCommentDel.asp", { method:'post',evalScripts:true, encoding : 'utf-8', parameters:params });
    }
}
/////////////////////////////////////////////////////