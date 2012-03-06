$(document).ready(function() {
	$('div.photo a').fancyZoom({scaleImg: true, closeOnClick: true});
});
/**
 * Relocation shorcuts
 * @param link
 * @returns {Boolean}
 */
function to(link){
	window.location = link;
	return false;
}