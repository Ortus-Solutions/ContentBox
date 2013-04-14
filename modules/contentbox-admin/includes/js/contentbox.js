$(document).ready(function() {
	
	// setup global variables
	$confirmIt 			= $('#confirmIt');
	$remoteModal 		= $("#remoteModal");
	$remoteModalContent	= $remoteModal.find("#remoteModelContent");
	$remoteModalLoading	= $remoteModalContent.html();
    
    // handler for "shown" event in modals
    $( '#modal' ).on( 'shown', function() {
        var modal = $( '#modal' ); 
        // only run if modal is in delayed mode
        if( modal.data( 'delay' ) ) {
            // load the modal content
            modal.load( modal.data( 'url' ), modal.data( 'params' ) );    
        }        
    });
    // reset modal content when hidden
    $( '#modal' ).on( 'hidden', function() {
        var modal = $( '#modal' );
        modal.html( '<div class="modal-header"><h3>Loading...</h3></div><div class="modal-body"><i class="icon-spinner icon-spin icon-large icon-4x"></i></div>' );
    })
    
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
	// Search Capabilities
	activateContentSearch();
	// activate confirmations
	activateConfirmations();
	// activate tooltips
	activateTooltips();

	// Expose | Any element with a class of .expose will expose when clicked
	$(".expose").click(function() {
		$(this).expose({ });
	});
	
	//Tabs in box header 
	$("ul.sub_nav").tabs("div.panes > div", {effect: 'fade'});
	//Vertical Navigation	
	$("ul.vertical_nav").tabs("div.panes_vertical> div", {effect: 'fade'});
	//Accordion
	//$("#accordion").tabs("#accordion div.pane", {tabs: 'h2', effect: 'slide', initialIndex:0});		
	
	// flicker messages
	var t=setTimeout("toggleFlickers()",5000);
});
function adminAction( action, actionURL ){
	if( action != 'null' ){
		$("#adminActionsPanel").hide();
		$("#adminActionsIcon").addClass( "icon-spin textOrange" );
		// Run Action Dispatch
		$.post( actionURL , {targetModule: action}, function(data){
			$("#adminActionNotifier").addClass( "alert-info" );
			var message = "<i class='icon-exclamation-sign'></i> <strong>Action Ran, Booya!</strong>";
			if( data.ERROR ){
				$("#adminActionNotifier").addClass( "alert-danger" );
				message = "<i class='icon-exclamation-sign'></i> <strong>Error running action, check logs!</strong>";
			}
			$("#adminActionsIcon").removeClass( "icon-spin textOrange" );
			$("#adminActionNotifier").fadeIn().html( message ).delay( 1500 ).fadeOut();
		} );
	}
}
function activateContentSearch(){
	// local refs
	$nav_search = $("#nav-search");
	$nav_search_results = $("#div-search-results");
	// opacity
	$nav_search.css("opacity","0.8");
	// focus effects
	$nav_search.focusin(function() {
    	$(this).animate({
		    opacity: 1.0,
		    width: '+=95',
		  }, 500, function(){});
    }).blur(function() {
    	$(this).animate({
		    opacity: 0.50,
		    width: '-=95',
		  }, 500, function(){});
    });
	// keyup quick search
	$nav_search.keyup(function(){
		var $this = $(this);
		// Only send requests if more than 2 characters
		if( $this.val().length > 1 ){
			$nav_search_results.load( $("#nav-search-url").val(), { search: $this.val() }, function(data){
				if( $nav_search_results.css("display") == "none" ){
					$nav_search_results.fadeIn().slideDown();
				}
			} );
		}
		
	});
	// add click listener to body to hide quick search panel
    $( 'body' ).click( function( e ){
       var target = $( e.target ),
           ipTarget = target.closest( '#div-search' )
       // if click occurs within visible element, add to ignore list
       if( !ipTarget.length ){
           //run global hide methods
    	   closeSearchBox();
       }
    });
}
function closeSearchBox(){
	$nav_search_results.slideUp();
	$nav_search.val('');
}
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
    $( '#modal' ).modal( 'hide' );
}
/**
* Close a local modal window
* @param div The jquery div object that represents the dialog.
*/
function closeModal(div){
    $(".error").hide();
	div.modal( 'hide' );
}
/**
 * Open a new local modal window.
 * @param div The jquery object of the div to extract the HTML from.
 * @param w The width of the modal
 * @param h The height of the modal
 * @return
 */
function openModal(div, w, h){
    div.modal({
        width: w,
        height: h
    })
}
/**
 * Open a new remote modal window Ajax style.
 * @param url The URL ajax destination
 * @param data The data packet to send
 * @param w The width of the modal
 * @param h The height of the modal
 * @param delay Whether or not to delay loading of dialog until after dialog is created (useful for iframes)
 * @return
 */
function openRemoteModal(url,params,w,h,delay){
    var modal = $( '#modal' );
    // set data values
    modal.data( 'url', url )
	modal.data( 'params', params );
    modal.data( 'width', w != undefined ? w : $( window ).width() * .85 );
    modal.data( 'height', h != undefined ? h : ($( window ).height() -360) );
    
    // in delay mode, we'll create a modal and then load the data (seems to be necessary for iframes)
    if( delay ) {
        var height = modal.data( 'height' );
        // convert height percentage to a numeric value
        if( height.search && height.search( '%' )!=-1 ) {
            height = height.replace( '%', '' ) / 100.00;
            height = $( window ).height() * height;
            modal.data( 'height', height )
        }
        // set delay data in element
        modal.data( 'delay', true );
        // show modal
        modal.modal({
            height: modal.data( 'height' ),
            width: modal.data( 'width' )
        });
    }
    // otherwise, front-load the request and then create modal
    else {
        // load request for content
        modal.load( url, params, function() {
            // in callback, show modal
            var maxHeight = ($( window ).height() -360);
            modal.modal({
                height: h!=undefined ? h : modal.height() < maxHeight ? modal.height() : maxHeight,
                width: w!=undefined ? w : $( window ).width() * .80,
                maxHeight: maxHeight
            })
        }) 
    }
    return;
}

function closeConfirmations(){
	$confirmIt.modal( 'hide' );
}
/**
 * Activate modal confirmation windows
 * @return
 */
function activateConfirmations(){
	// close button triggers for confirmation dialog
	$confirmIt.find("button").click(function(e){
		if( $(this).attr("data-action") == "confirm" ){
			$confirmIt.find("#confirmItButtons").hide();
			$confirmIt.find("#confirmItLoader").fadeIn();
			window.location =  $confirmIt.data('confirmSrc');
		}
	});
	
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
		//$confirmIt.data("overlay").load();
		$confirmIt.modal();
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
/**
 * Get today's date in us or rest of the world format
 * @param {boolean} us defaults to true
 */
function getToday(us){
	// default us to true
	us = ( us == null ? true : us );
	var fullDate = new Date()
	var twoDigitMonth = ((fullDate.getMonth().length+1) === 1)? (fullDate.getMonth()+1) : '0' + (fullDate.getMonth()+1);
	var theYear = String( fullDate.getFullYear() );
	var theLen  = theYear.length;
	theYear = theYear.substring( theLen, theLen - 2 );
	if( us ){
		return twoDigitMonth + "/" + fullDate.getDate() + "/" + theYear;
	}
	else{
		return fullDate.getDate() + "/" + twoDigitMonth + "/" + theYear;	
	}
}