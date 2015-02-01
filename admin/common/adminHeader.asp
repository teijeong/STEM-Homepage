<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko" lang="ko">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>관리자페이지</title>
<link href="/css/shopstyle.css" rel="stylesheet" type="text/css">
<link href="/css/editorContent.css" rel="stylesheet" type="text/css">
<script type="text/javascript" src="/library/jquery.min.js"></script>
<script type="text/javascript" src="/library/prototype.js"></script>
<script language='javascript' src='/library/functions.js'></script>
</head>

<script type="text/javascript">
jQuery(function() {
    jQuery("#progressDIV").height(jQuery(window).height() );
    jQuery(window).resize(function() {
      jQuery("#progressDIV").height(jQuery(window).height() )  ;
    });
});
</script>

<body>

<div id="layerShow" name='layerShow' style="width:100%; zoom:1; position:fixed; _position:absolute;  left:0px; z-index:100; top:0px; display:none;"></div>
<div id='progressDIV' style='background:#000000; width:100%; zoom:1; position:fixed; _position:absolute;  left:0px; z-index:100; top:0px; opacity:0.3; filter:alpha(opacity:70); display:none;' >
<table border=0 cellpadding=0 cellspacing=0 width='100%' height='100%'>
    <tr>
        <td align=center bgcolor='#000000'>
            <img src=/common/memberimg/progress.gif>
            <div style='color: red; padding-top:5px; font-size:13px;'>처리중입니다. 잠시만 기다려주세요.</div>
        </td>
    </tr>
</table>
</div>