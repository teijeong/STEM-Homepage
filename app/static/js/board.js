function writePost(userID, boardID) {
    (function ($){
        var title = $("#title").val();
        var body = CKEDITOR.instances.content.getData();
        $.ajax({
            url: "/post/write",
            type: "POST",
            data: {
                level: 1,
                title: title,
                body: body,
                userID: userID,
                boardID: boardID
            },
            success: function(data) {
                location.href="/sub/5-" + boardID;
            }
        });
    })(jQuery);
}