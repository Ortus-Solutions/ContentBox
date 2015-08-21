$(document).ready(function() {
	
	// setup global variables
	$confirmIt 			= $('#confirmIt');
	$remoteModal 		= $( "#modal" );
    
    // handler for "shown" event in modals
	$remoteModal.on( 'shown', function() {
        var modal = $remoteModal; 
        // only run if modal is in delayed mode
        if( modal.data( 'delay' ) ) {
            // load the modal content
            modal.load( modal.data( 'url' ), modal.data( 'params' ) );    
        }        
    } );

    // reset modal content when hidden
	$remoteModal.on( 'hidden.bs.modal', function() {
        var modal = $remoteModal;
        modal.html( '<div class="modal-header"><h3>Loading...</h3></div><div class="modal-body" id="removeModelContent"><i class="fa fa-spinner fa fa-spin fa-lg icon-4x"></i></div>' );
    } )
    
	// Global Tool Tip Settings
	toolTipSettings	= {
		 animation: 'slide',
		 delay: { show: 250, hide: 250 }
	};
	
	// toggle flicker messages
	$( ".flickerMessages" ).slideDown();
	// Search Capabilities
	activateContentSearch();
	// activate confirmations
	activateConfirmations();
	// activate tooltips
	activateTooltips();

    // global Validaiton settings
    $.validator.setDefaults( {
        // apparently, the *default* of jQuery validation is to ignore validation of hidden elements (e.g., when using tabs, validation is skipped)
        // seriously???
        // anyway, setting ignore: [] fixes it
        ignore:[],
        //errorElement: 'span',
        //errorClass: 'help-block',
        highlight: function(element) {
            $(element).closest('.form-group').removeClass('success').addClass('error');
        },
        success: function(element) {
            element
                .text( 'Field is valid' )
                .addClass('valid')
                .closest('.form-group').removeClass('error').addClass('success');
            element.remove();
        },
        errorPlacement: function(error, element) {
            error.appendTo( element.parent( "div.controls" ) );
        }
    } )	
    $.fn.resetValidations = function() {
        var form = this[ 0 ].currentForm;
        // also remove success and error classes
        $( form ).find( '.form-group' ).each(function() {
            $( this ).removeClass( 'error' ).removeClass( 'success' );
        } );
        $( form ).find( ':input' ).each(function() {
            $( this ).removeClass( 'error' ).removeClass( 'valid' );
        } );
        return this;
    }
    // simple method to blank out all form fields 
    $.fn.clearForm = function() {
    	if( this.data( 'validator') == undefined ){ return; }
        // reset classes and what not
        this.data( 'validator' ).resetForm();
        // run over input fields and blank them out
        this.find(':input').each(function() {
            switch(this.type) {
                case 'password':
                case 'hidden':
                case 'select-multiple':
                case 'select-one':
                case 'text':
                case 'textarea':
                    $(this).val('');
                    break;
                case 'checkbox':
                case 'radio':
                    this.checked = false;
            }
        } );
        $( this.data( 'validator' ) ).resetValidations();
        return this;
    }
    $.fn.collect = function() {
        var serializedArrayData = this.serializeArray();
        var data = {};
        $.each( serializedArrayData, function( index, obj ) {
            data[ obj.name ] = obj.value;
        } );
        return data;
    }
	// flicker messages
	var t=setTimeout( "toggleFlickers()",5000);

	// Tab link detector
	$(function () {
	   var activeTab = $('[href="' + location.hash + '"]');
	   activeTab && activeTab.tab('show');
	} );
	
	// Sidebar shortcut keys
	if( $( "#main-sidebar" ).attr( "id" ) == undefined ){
		$( "#sidebar-toggle" ).hide();
	}
	else{
		jwerty.key( "ctrl+shift+e" , toggleSidebar );
	}

	// If the sidebar preference is off, toggle it
	if( $( "body" ).attr( "data-showsidebar" ) == "no" ){
		toggleSidebar();
	}

	// Nav Search Shortcut
	jwerty.key( "ctrl+shift+s" , function(){ $( "#nav-search" ).focus(); return false;} );
	
	// find all links with the key-binding data attribute
	$( '[data-keybinding]' ).each(function(){
		var boundItem = $( this );
		jwerty.key( boundItem.data( 'keybinding' ), function(){ 
			// give precedence to onclick
			if( boundItem.attr( 'onclick' ) ) {
				// if onclick, call event
				boundItem.click();
			}
			else {
				// otherwise, follow link
				to( boundItem.attr( 'href' ) );
			} 
		} );
	} );

	// Hide empty menu's due to permissions.
	$( "#adminMenuBarContent li.dropdown" ).each(function(){
		if( !$( this ).find( "ul.dropdown-menu li" ).length ){
			$( this ).hide();
		}
	} );
    // match stateful accordions
    $( '.accordion[data-stateful]' ).each(function() {
        var accordion = $( this ),
            data = accordion.data( 'stateful' ),
            match;
        if( data ) {
            // try to retrieve cookie that matches accordion panel id
            match = $.cookie( data );
            // if a match was found...
            if ( match != null ) {
                // wax defaults that are hardcoded on the template
                accordion.find( '.collapse' ).removeClass( 'in' );
                //show the matched group
                $( '#' + match ).addClass( 'in' );
            }
        }
        // bind listener for state changes
        accordion.bind( 'shown.bs.collapse', function(){
            // grab id from expanded accordion panel
            var active = accordion.find( '.in' ).attr( 'id' );
            // set cookie
            $.cookie( data, active );
        } )            
    } )
} );
function isSidebarOpen(){
	var sidebar = $( "#main-sidebar" );
	return ( sidebar.attr( "id" ) != undefined && sidebar.css( "display" ) == "block"  ? true : false );
}
function toggleSidebar(){
	var sidebar = $( "#main-sidebar" );
	var type 	= sidebar.css( "display" );
	var sidebarState = false;
	// nosidebar exit
	if( type == undefined ){ return; }
	// toggles
	if( type == "block" ){
		sidebar.fadeOut();
		$( "#sidebar_trigger" ).removeClass( "icon-collapse-alt" ).addClass( "icon-expand-alt" );
		$( "#main-content" ).removeClass( "span9" ).addClass( "span12" );
	}
	else{
		$( "#sidebar_trigger" ).removeClass( "icon-expand-alt" ).addClass( "icon-collapse-alt" );
		sidebar.fadeIn();
		$( "#main-content" ).removeClass( "span12" ).addClass( "span9" );
		sidebarState = true;
	}
	// Call change user editor preference
	$.ajax( {
		url : $( "#sidebar-toggle" ).attr( "data-stateurl" ),
		data : { sidebarState: sidebarState },
		async : true
	} );
}
function adminAction( action, actionURL ){
	if( action != 'null' ){
		$( "#adminActionsIcon" ).addClass( "icon-spin textOrange" );
		// Run Action Dispatch
		$.post( actionURL , {targetModule: action}, function(data){
			if( data.ERROR ){
				adminNotifier( "error", "<i class='icon-exclamation-sign'></i> <strong>Error running action, check logs!</strong>" );
			}
			else{
				adminNotifier( "info", "<i class='icon-exclamation-sign'></i> <strong>Action Ran, Booya!</strong>" );
			}
			$( "#adminActionsIcon" ).removeClass( "icon-spin textOrange" );
			
		} );
	}
}
/**
 * Send an admin notifier popup for a few seconds
 * @param type The type to send: Defaults to warn, available are warn, info, error, success
 * @param message The message to display in the notifier
 * @param delay The delay of the message, defaults to 1500 ms
 */
function adminNotifier(type, message, delay){
	/*
    var $notifier = $( "#adminActionNotifier" ).attr( "class", "alert hide" );
	if( type == null ){ type = "warn";  }
	if( delay == null ){ delay = 1500;  }
	// add type css
	switch( type ){
		case "info" : { $notifier.addClass( "alert-info" ); break; }
		case "error" : { $notifier.addClass( "alert-error" ); break; }
		case "success" : { $notifier.addClass( "alert-success" ); break; }
	}
	// show with message and delay and reset.
	$notifier.fadeIn().html( message ).delay( delay ).fadeOut();
    */
    switch( type ){
        case "info" : { toastr.info( message ); break; }
        case "error" : { toastr.error( message ); break; }
        case "success" : { toastr.success( message ); break; }
    }
    
}
function activateContentSearch(){
	// local refs
	$nav_search = $( "#nav-search" );
	$nav_search_results = $( "#div-search-results" );
	// opacity
	$nav_search.css( "opacity","0.8" );
	// focus effects
	$nav_search.focusin(function() {
		if( $nav_search.is( ":focus" ) ){ return; }
    	$(this).animate( {
		    opacity: 1.0,
		    width: '+=95',
		  }, 500, function(){} );
    } ).blur(function() {
    	$(this).animate( {
		    opacity: 0.50,
		    width: '-=95',
		  }, 500, function(){} );
    } );
	// keyup quick search
	$nav_search.keyup(function(){
		var $this = $(this);
		// Only send requests if more than 2 characters
		if( $this.val().length > 1 ){
			$nav_search_results.load( $( "#nav-search-url" ).val(), { search: $this.val() }, function(data){
				if( $nav_search_results.css( "display" ) == "none" ){
					$nav_search_results.fadeIn().slideDown();
				}
			} );
		}
		
	} );
	// add click listener to body to hide quick search panel
    $( 'body' ).click( function( e ){
       var target = $( e.target ),
           ipTarget = target.closest( '#div-search' )
       // if click occurs within visible element, add to ignore list
       if( !ipTarget.length ){
           //run global hide methods
    	   closeSearchBox();
       }
    } );
}
function closeSearchBox(){
	$nav_search_results.slideUp();
	$nav_search.val('');
}
function quickLinks( inURL ){
	if( inURL != 'null' )
		window.location = inURL;
}
function activateTooltips(){
	//Tooltip 
    $( '[title]' ).tooltip( toolTipSettings )
}
function hideAllTooltips(){
	$( ".tooltip" ).hide();
}
function toggleFlickers(){
	$( ".flickerMessages" ).slideToggle();
	$( ".cbox_messagebox_info" ).slideToggle();
	$( ".cbox_messagebox_warn" ).slideToggle();
	$( ".cbox_messagebox_error" ).slideToggle();
}

/**
 * A-la-Carte closing of remote modal windows
 * @return
 */
function closeRemoteModal(){
    var frm = $remoteModal.find( 'form' );
    if( frm.length ) {
        $( frm[0] ).clearForm();        
    }
    $remoteModal.modal( 'hide' );
}
/**
* Close a local modal window
* @param div The jquery div object that represents the dialog.
*/
function closeModal(div){
    var frm = div.find( 'form' );
    if( frm.length ) {
        $( frm[0] ).clearForm();        
    }
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
    div.modal( {
        width: w,
        height: h
    } );
    // attach a listener to clear form when modal closes
    $( div ).on( 'hidden.bs.modal', function() {
        if( !$( this ).hasClass( 'in' ) ) {
            var frm = $( this ).find( 'form' );
            if( frm.length ) {
                $( frm[0] ).clearForm();        
            }
        }
    } );
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
    var modal = $remoteModal;
    var args = {};
    var maxHeight = ($( window ).height() -360);
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
            //modal.data( 'height', height )
        }
        // set delay data in element
        modal.data( 'delay', true );
        args.width = modal.data( 'width' );
        if( height < maxHeight ) {
            args.height = maxHeight;
        }
        // show modal
        modal.modal( args );
    }
    // otherwise, front-load the request and then create modal
    else {
        // load request for content
        modal.load( url, params, function() {
            // in callback, show modal
            var maxHeight = ($( window ).height() -360);
            var currentHeight = modal.height();
            args.width = w!=undefined ? w : $( window ).width() * .80;
            args.maxHeight = maxHeight;
            if( currentHeight && currentHeight < maxHeight ) {
                args.height = currentHeight;
            }
            if( !currentHeight ) {
                args.height = maxHeight;
            }
            modal.modal( args )
        } ) 
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
	$confirmIt.find( "button" ).click(function(e){
		if( $(this).attr( "data-action" ) == "confirm" ){
			$confirmIt.find( "#confirmItButtons" ).hide();
			$confirmIt.find( "#confirmItLoader" ).fadeIn();
			window.location =  $confirmIt.data('confirmSrc');
		}
	} );
	
	// Activate dynamic confirmations from <a> of class confirmIt
	$('a.confirmIt').click(function(e){
		// setup the href
		$confirmIt.data( "confirmSrc", $(this).attr('href'));
        // defaults
        var dataMessage = $(this).attr('data-message') ? $(this).attr('data-message') : 'Are you sure you want to perform this action?';
        var dataTitle = $(this).attr('data-title') ? $(this).attr('data-title') : 'Are you sure?';
        // set message
        $confirmIt.find( "#confirmItMessage" ).html( dataMessage );
        // set title
        $confirmIt.find( "#confirmItTitle" ).html( dataTitle );
		// show the confirmation when clicked
		//$confirmIt.data( "overlay" ).load();
		$confirmIt.modal();
		// prevent default action
		e.preventDefault();
	} );
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
	$( "input[name='"+id+"']" ).each(function(){
		this.checked = checked;
	} );
}
/**
 * Check all checkboxes by value
 * @param id
 * @param recordID
 * @returns
 */
function checkByValue(id,recordID){
	$( "input[name='"+id+"']" ).each(function(){
		if( this.value == recordID ){ this.checked = true; }
		else{ this.checked = false; }
	} );	
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