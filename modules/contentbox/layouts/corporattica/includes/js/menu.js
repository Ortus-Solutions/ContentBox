var jMenu_timeout    = 300;
var jMenu_effectTime = 200;
var jMenu_closetimer = 0;
var jMenu_ddmenuitem = 0;
var jMenu_openid = 0;
var jMenu_action = false;
function jMenu_open()
{
	jMenu_canceltimer();
	
	if($("a", this).html() == jMenu_openid)
		return;
		
	if(jMenu_action)
		return;
		
	jMenu_close();

	if($("ul", this).size() == 0)
		return;
	
	jMenu_action = true;
	jMenu_ddmenuitem = $(this).find('ul').fadeIn(jMenu_effectTime, function() {jMenu_action = false;});
	jMenu_openid = $("a", this).html();
	if (document.getElementById('ul'))
		document.getElementById('ul').className = 'current';
}

function jMenu_close()
{
	if(jMenu_action)
		return;
			
	if(jMenu_ddmenuitem)
	{
		jMenu_action = true;
		jMenu_ddmenuitem.fadeOut(jMenu_effectTime, function() {jMenu_action = false;});
		jMenu_ddmenuitem = null;
		jMenu_openid = null;
	}
}

function jMenu_timer()
{
	jMenu_closetimer = window.setTimeout(jMenu_close, jMenu_timeout);
}

function jMenu_canceltimer()
{
	if(jMenu_closetimer)
	{
		window.clearTimeout(jMenu_closetimer);
		jMenu_closetimer = null;
	}
}

$(document).ready(function() {
	$('#menu > li').bind('mouseover', jMenu_open)
	$('#menu > li').bind('mouseout',  jMenu_timer)
	$('#menu > li > ul').bind('mouseover',  jMenu_canceltimer)
	$('#menu > li > ul > li').bind('mouseover',  jMenu_canceltimer)
});

document.onclick = jMenu_close;