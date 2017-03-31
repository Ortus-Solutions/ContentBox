setTimeout( insertMainModeBanner, 500 );
function insertMainModeBanner(){
	var div 				= document.createElement( "div" );
	div.style.padding 		= "5px";
	div.style.width 		= "100%";
	div.style.top 			= "0px";
	div.style.left 			= "0px";
	div.style.textAlign 	= "center";
	div.style.background 	= "red";
	div.style.color 		= "white";
	div.innerHTML 			= "This website is in maintenance mode for all visitors not logged in.";
	document.body.insertBefore( div, document.body.firstChild );
}