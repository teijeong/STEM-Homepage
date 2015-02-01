//게시판 코멘트 컨트롤///////////////////////////////
var gb_ViewDivID="";

function viewBoardCommentArea(index,bbscode,page){
    var params = "idx="+index+"&bbscode="+bbscode+"&page="+page;
    new Ajax.Updater('boardCommentDiv', '/admin/ajaxpage/boardCommentArea.asp', { method:'post',evalScripts:true, encoding : 'utf-8', parameters:params });
}

function viewboardCommentPwdInput(memYN,temp,index,bbscode,page){
    var val=confirm("해당 코멘트를 삭제하시겠습니까?");
    if (val){
        var params = "idx="+index+"&bbscode="+bbscode+"&page="+page;
        new Ajax.Updater('boardactDiv', "/admin/ajaxpage/boardCommentDel.asp", { method:'post',evalScripts:true, encoding : 'utf-8', parameters:params });
    }
}

function viewboardCommentReply(targetDiv,index,bbscode,page){
    if(gb_ViewDivID!=""){
        document.getElementById(gb_ViewDivID).style.display="none";
    }
    gb_ViewDivID=targetDiv;
    document.getElementById(gb_ViewDivID).style.display="inline";

    var params = "idx="+index+"&bbscode="+bbscode+"&page="+page;
    new Ajax.Updater(targetDiv, "/admin/ajaxpage/boardCommentReply.asp", { method:'post',evalScripts:true, encoding : 'utf-8', parameters:params });
}

function boardcommentEditView(targetDiv,index,bbscode,page){
    if(gb_ViewDivID!=""){
        document.getElementById(gb_ViewDivID).style.display="none";
    }
    gb_ViewDivID=targetDiv;
    document.getElementById(gb_ViewDivID).style.display="inline";

    var params = "idx="+index+"&bbscode="+bbscode+"&page="+page;
    new Ajax.Updater(targetDiv, "/admin/ajaxpage/boardCommentEdit.asp", { method:'post',evalScripts:true, encoding : 'utf-8', parameters:params });
}

function boardcommentReply(thisFORM){
    var f=eval(thisFORM)
    var params = Form.serialize($(thisFORM));

    if(f.content.value==false){
        alert("내용을 입력해주세요.");
        f.content.focus();
        return;
    }
    new Ajax.Updater('boardactDiv', "/admin/ajaxpage/BoardCommentReplyOK.asp", { method:'post',evalScripts:true, encoding : 'utf-8', parameters:params });
}

function boardcommentEditGo(thisFORM){
    var f=eval(thisFORM)
    var params = Form.serialize($(thisFORM));

    if(f.content.value==false){
        alert("내용을 입력해주세요.");
        f.content.focus();
        return;
    }
    new Ajax.Updater('boardactDiv', "/admin/ajaxpage/BoardCommentEditOK.asp", { method:'post',evalScripts:true, encoding : 'utf-8', parameters:params });
}

function boardcommentGo(){
    f=document.commentfrm;
    var params = Form.serialize($('commentfrm'));
    if(f.content.value==false){
        alert("내용을 입력해주세요.");
        f.content.focus();
        return;
    }
    new Ajax.Updater('boardactDiv', "/admin/ajaxpage/BoardCommentAddOK.asp", { method:'post',evalScripts:true, encoding : 'utf-8', parameters:params });
}
/////////////////////////////////////////////////////