function writeCpIframe(cpUri)
{
    if (cpUri==null)
    {
        alert("CP 페이지 URL이 존재하지 않습니다.");
        return;
    }

    var scrollMode = "no";
    var frameHeight = 1000;

    if(window.navigator.userAgent.indexOf("MSIE 7") > -1)
    {
        scrollMode = "no";
        frameHeight = 1200;
    }
    if (cpUri.indexOf("?")>-1)
    {
        cpUri += "&";
    } else
    {
        cpUri += "?";
    }
    document.write('<iframe src="'+cpUri+'" name="cpframe" id="cpframe" width="720" height="'+frameHeight+'" marginwidth="0" marginheight="0" hspace="0" vspace="0" scrolling="auto" frameborder="0" allowTransparency="true"></iframe>');
}
