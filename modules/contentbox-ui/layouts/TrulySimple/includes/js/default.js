$(document).ready(function() {
	// activate tooltips
	activateTooltips();
});
function activateTooltips(){
	// Tooltip settings
	var toolTipSettings	= {	//will make a tooltip of all elements having a title property
		 opacity: 0.8,
		 effect: 'slide',
		 predelay: 200,
		 delay: 10,
		 offset:[5, 0]
	};
	//Tooltip 
	$("[title]").tooltip(toolTipSettings)
		 .dynamic({bottom: { direction: 'down', bounce: true}   //made it dynamic so it will show on bottom if there isn't space on the top
	});
}
/**
 * Relocation shorcuts
 * @param link
 * @returns {Boolean}
 */
function to(link){
	window.location = link;
	return false;
}