$(document).ready(function() {
	// Global Tool Tip Settings
	toolTipSettings	= {	//will make a tooltip of all elements having a title property
		 opacity: 0.8,
		 effect: 'slide',
		 predelay: 200,
		 delay: 10,
		 offset:[5, 0]
	};
	
	// toggle flicker messages
	$(".flickerMessages").slideDown();
	//Main Navigation
	$('#main_nav > li > ul').hide(); // Hide all subnavigation
	// Show current subnavigation	
	$('#main_nav > li > a.current').parent().children("ul").show(); 
	// li clicks
	$('#main_nav > li > a[href="#"]').click( 
		function() {
			$(this).parent().siblings().children("a").removeClass('current'); // Remove .current class from all tabs
			$(this).addClass('current'); // Add class .current
			$(this).parent().siblings().children("ul").fadeOut(100); // Hide all subnavigation
			$(this).parent().children("ul").fadeIn(100); // Show current subnavigation
			return false;
		}
	);
	
	// setup global variables
	$confirmIt 			= $('#confirmIt');
	$remoteModal 		= $("#remoteModal");
	$remoteModalContent	= $remoteModal.find("#remoteModelContent");
	$remoteModalLoading	= $remoteModalContent.html();
	
	// activate confirmations
	activateConfirmations();
	// activate tooltips
	activateTooltips();
	
	// Jump Menu
	$('.jump_menu').hover(function(){
		$('.jump_menu_btn').toggleClass('active');
		$("ul.jump_menu_list").slideDown(200);
		}, function(){
			$('.jump_menu_btn').toggleClass('active');
			$(".jump_menu_list").hide();
	});
	
	// Expose | Any element with a class of .expose will expose when clicked
	$(".expose").click(function() {
		$(this).expose({ });
	});
	
	//Tabs in box header 
	$("ul.sub_nav").tabs("div.panes > div", {effect: 'fade'});
	//Vertical Navigation	
	$("ul.vertical_nav").tabs("div.panes_vertical> div", {effect: 'fade'});
	//Accordion
	$("#accordion").tabs("#accordion div.pane", {tabs: 'h2', effect: 'slide', initialIndex:0});		
	
	// flicker messages
	var t=setTimeout("toggleFlickers()",5000);
	
});
function quickLinks( inURL ){
	if( inURL != 'null' )
		window.location = inURL;
}
function exposeIt(vID){
	$(vID).expose();
}
function activateTooltips(){
	//Tooltip 
	$("[title]").tooltip(toolTipSettings)
		 .dynamic({bottom: { direction: 'down', bounce: true}   //made it dynamic so it will show on bottom if there isn't space on the top
	});
}
function hideAllTooltips(){
	$(".tooltip").hide();
}
function toggleFlickers(){
	$(".flickerMessages").slideToggle();
	$(".cbox_messagebox_info").slideToggle();
	$(".cbox_messagebox_warn").slideToggle();
	$(".cbox_messagebox_error").slideToggle();
}

/**
 * A-la-Carte closing of remote modal windows
 * @return
 */
function closeRemoteModal(){
	$(".error").hide();
	$remoteModal.data("overlay").close();
	$remoteModalContent.html('').html($remoteModalLoading);
}
/**
 * Open a new remote modal window Ajax style.
 * @param url The URL ajax destination
 * @param data The data packet to send
 * @param w The width of the modal
 * @param h The height of the modal
 * @return
 */
function openRemoteModal(url,params,w,h){
	$remoteModal.overlay({
		mask: {
			color: '#fff',
			loadSpeed: 200,
			opacity: 0.6 },
		closeOnClick : true,
		closeOnEsc : true,
		onBeforeLoad : function(){
			$remoteModalContent.load( $remoteModal.data("url"),$remoteModal.data("params") );
		},
		onClose: function(){ closeRemoteModal(); }
	});
	$remoteModal.find("a.close").attr("title","Close Window");
	// Set data for this remote modal
	$remoteModal.data("url",url).data("params",params);
	// width/height
	if( w ){ $remoteModal.css("width",w); }
	if( h ){ $remoteModal.css("height",h); }
	// open the remote modal
	$remoteModal.data("overlay").load();
}
/**
 * Activate modal confirmation windows
 * @return
 */
function activateConfirmations(){
	
	// verify overlay already loaded
	if( !$confirmIt.data("overlay") ){
		// Overlay the global confirmation
		$confirmIt.overlay({
			mask: {
				color: '#fff',
				loadSpeed: 200,
				opacity: 0.6
			},
			closeOnClick:false
		});
		
		// close button triggers for confirmation dialog
		$confirmIt.find("button").click(function(e){
			if( $(this).attr("data-action") == "confirm" ){
				window.location =  $confirmIt.data('confirmSrc');
			}
		});
	}
	
	// Activate dynamic confirmations from <a> of class confirmIt
	$('a.confirmIt').click(function(e){
		// setup the href
		$confirmIt.data("confirmSrc", $(this).attr('href'));
		// data-message
		if( $(this).attr('data-message') ){
			$confirmIt.find("#confirmItMessage").html( $(this).attr('data-message') );
		}
		// data-title
		if( $(this).attr('data-title') ){
			$confirmIt.find("#confirmItTitle").html( $(this).attr('data-title') );
		}
		// show the confirmation when clicked
		$confirmIt.data("overlay").load();
		// prevent default action
		e.preventDefault();
	});
}
function popup(url,w,h){
	var winWidth = 1000;
	var winHeight = 750;
	if( w ){ var minWidth = w; }
	if( h ){ var winHeight = h; }
	var xPosition = (screen.width / 2) - (winWidth / 2);
	var yPosition = (screen.height / 2) - (winHeight / 2);
	window.open(url,'layoutPreview','resizable=yes,status=yes,location=no,menubar=no,toolbar=no,scrollbars=yes,width='+winWidth+',height='+winHeight+',left='+xPosition+',top='+yPosition+',screenX='+xPosition+',screenY='+yPosition);
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
/**
 * Check all checkboxes utility function
 * @param checked
 * @param id
 */
function checkAll(checked,id){
	$("input[name='"+id+"']").each(function(){
		this.checked = checked;
	});
}
/**
 * Check all checkboxes by value
 * @param id
 * @param recordID
 * @returns
 */
function checkByValue(id,recordID){
	$("input[name='"+id+"']").each(function(){
		if( this.value == recordID ){ this.checked = true; }
		else{ this.checked = false; }
	});	
}