import { createKeybindingsHandler } from "tinykeys"
window.contentListHelper = require( "./contentList.js" ).default;
require( "./filebrowser.js" );
require( "./editors/editors.js" );
require( "./editors/autosave.js" );

window.bootbox = require( "bootbox" );

// GLOBAL STATIC
const REGEX_LOWER = /[a-z]/,
	REGEX_UPPER = /[A-Z]/,
	REGEX_DIGIT = /[0-9]/,
	REGEX_DIGITS = /[0-9].*[0-9]/,
	REGEX_SPECIAL = /[^a-zA-Z0-9]/;

// setup global variables
const $confirmIt = $( "#confirmIt" );
const $remoteModal = $( "#modal" );
// Global Tool Tip Settings
const toolTipSettings = {
	animation : "slide",
	delay     : { show: 100, hide: 100 }
};



document.addEventListener( "DOMContentLoaded", () => {

	// If the sidebar preference is off, toggle it
	if ( $( "body" ).attr( "data-showsidebar" ) == "no" ) {
		toggleSidebar();
	}
	// If "main-content-sidebar" exists then bring toggler in
	if ( $( "#main-content-sidebar" ).attr( "id" ) !== undefined ) {
		$( "#main-content-sidebar-trigger" ).fadeIn();
	}

	// Attach modal listeners
	attachModalListeners();
	// Search Capabilities
	activateContentSearch();
	// activate confirmations
	activateConfirmations();
	// activate tooltips
	activateTooltips();
	// activate navbar state
	activateNavbarState();
	// activate fancy toggles
	activateToggleCheckboxes();

	// global Validaiton settings
	$.validator.setDefaults( {
		// apparently, the *default* of jQuery validation is to ignore validation of hidden elements (e.g., when using tabs, validation is skipped)
		// seriously???
		// anyway, setting ignore: [] fixes it
		ignore    : [],
		//errorElement: 'span',
		//errorClass: 'help-block',
		highlight : function( element ) {
			$( element ).closest( ".form-group" ).removeClass( "success" ).addClass( "error" );
		},
		success : function( element ) {
			element
				.text( "Field is valid" )
				.addClass( "valid" )
				.closest( ".form-group" ).removeClass( "error" ).addClass( "success" );
			element.remove();
		},
		errorPlacement : function( error, element ) {
			if ( $( element ).is( ":hidden" ) ) {
				return false;
			} else {
				error.appendTo( element.closest( "div.controls" ) );
			}
		}
	} );
	$.fn.resetValidations = function() {
		var form = this[0].currentForm;
		// also remove success and error classes
		$( form ).find( ".form-group" ).each( function() {
			$( this ).removeClass( "error" ).removeClass( "success" );
		} );
		$( form ).find( ":input" ).each( function() {
			$( this ).removeClass( "error" ).removeClass( "valid" );
		} );
		return this;
	};
	// simple method to blank out all form fields
	$.fn.clearForm = function() {
		if ( this.data( "validator" ) === undefined ) { return; }
		// reset classes and what not
		this.data( "validator" ).resetForm();
		// run over input fields and blank them out
		this.find( ":input" ).each( function() {
			switch ( this.type ) {
			case "password":
			case "hidden":
			case "select-multiple":
			case "select-one":
			case "text":
			case "textarea":
				$( this ).val( "" );
				break;
			case "checkbox":
			case "radio":
				this.checked = false;
			}
		} );
		$( this.data( "validator" ) ).resetValidations();
		return this;
	};
	$.fn.collect = function() {
		var serializedArrayData = this.serializeArray();
		var data = {};
		$.each( serializedArrayData, function( index, obj ) {
			data[obj.name] = obj.value;
		} );
		return data;
	};

	// flicker messages
	var t = setTimeout( toggleFlickers(), 5000 );

	// Tab link detector for bootstrap
	$( function() {
		var activeTab = $( "[href=\"" + location.hash + "\"]" );
		if ( activeTab ) { activeTab.tab( "show" ); }
	} );

	// Nav Search Shortcut
	createKeybindingsHandler({
		"Ctrl+Shift+S" : () => {
			$( "#nav-search" ).focus();
			return false;
		}
	});

	// find all links with the key-binding data attribute
	$( "[data-keybinding]" ).each( function() {
		var boundItem = $( this );
		createKeybindingsHandler({
			[boundItem.data( "keybinding" )] : () => {
				// give precedence to onclick
				if ( boundItem.attr( "onclick" ) ) {
					// if onclick, call event
					boundItem.click();
				} else {
					// otherwise, follow link
					to( boundItem.attr( "href" ) );
				}
			}
		});
	} );

	// Hide empty menu's due to permissions.
	$( "#main-navbar li.nav-dropdown" ).each( function() {
		if ( !$( this ).find( "ul.nav-sub li" ).length ) {
			$( this ).hide();
		}
	} );

	// match stateful accordions
	$( ".accordion[data-stateful]" ).each( function() {
		var accordion = $( this ),
			data = accordion.data( "stateful" ),
			match;
		if ( data ) {
			// try to retrieve cookie that matches accordion panel id
			match = $.cookie( data );
			// if a match was found...
			if ( match !== null ) {
				// wax defaults that are hardcoded on the template
				accordion.find( ".collapse" ).removeClass( "in" );
				//show the matched group
				$( "#" + match ).addClass( "in" );
			}
		}
		// bind listener for state changes
		accordion.bind( "shown.bs.collapse", function() {
			// grab id from expanded accordion panel
			var active = accordion.find( ".in" ).attr( "id" );
			// set cookie
			$.cookie( data, active );
		} );
	} );


} );

/**
 * Activate the main sidebar state to open or closed
 */
window.activateNavbarState = function() {
	var container = $( "#container" );
	// Bind listener to left toggle action
	$( "#toggle-left" ).bind( "click", function( e ) {

		// Verify window size, do not store if in mobile mode
		if ( $( window ).width() > 768 ) {
			// Are we opened or closed?
			sidemenuCollapse = ( container.hasClass( "sidebar-mini" ) ? "no" : "yes" );

			// Call change user editor preference
			$.ajax( {
				url   : $( "body" ).attr( "data-preferenceURL" ),
				data  : { value: sidemenuCollapse, preference: "sidemenuCollapse" },
				async : true
			} );
		}

	} );
}
/**
 * Check if the main right sidebar is open or not
 * @return {Boolean} open or not
 */
window.isMainSidebarOpen = function() {
	var sidebar = $( "#main-content-sidebar" );
	return ( sidebar.attr( "id" ) !== undefined && sidebar.css( "display" ) === "block" ? true : false );
}
/**
 * Toggle the main sidebar to fully display the main slot of content.
 * main-content-slot (col) main-content-sidebar (col)
 */
window.toggleSidebar = function(){
	var sidebar 		= $( "#main-content-sidebar" );
	var type 			= sidebar.css( "display" );
	var sidebarState 	= false;

	// nosidebar exit
	if ( type === undefined ) { return; }

	// toggles
	if ( type === "block" ) {
		sidebar.fadeOut();
		$( "#main-content-sidebar-trigger i" )
			.removeClass( "fa-minus-square" )
			.addClass( "fa-plus-square" );
		$( "#main-content-slot" )
			.removeClass( "col-md-8" )
			.addClass( "col-md-12" );
	} else {
		$( "#main-content-sidebar-trigger i" )
			.removeClass( "fa-plus-square" )
			.addClass( "fa-minus-square" );
		sidebar.fadeIn();
		$( "#main-content-slot" )
			.removeClass( "col-md-12" )
			.addClass( "col-md-8" );
		sidebarState = true;
	}

	// Call change user editor preference
	$.ajax( {
		url  	: $( "body" ).attr( "data-preferenceURL" ),
		data 	: { value: sidebarState, preference: "sidebarstate" },
		async	: true
	} );
}
/**
 * Run an admin action async
 * @param  {string} action    Target action to execute
 * @param  {string} actionURL The posting executor
 */
window.adminAction = function( action, actionURL ) {
	if ( action != "null" ) {
		$( "#adminActionsIcon" ).addClass( "fa-spin textOrange" );
		// Run Action Dispatch
		$.post( actionURL, { targetModule: action }, function( data ) {
			if ( data.ERROR ) {
				adminNotifier( "error", "<i class='fa-exclamation-sign'></i> <strong>Error running action, check logs!</strong>" );
			} else {
				adminNotifier( "info", "<i class='fa-exclamation-sign'></i> <strong>Action Ran, Booya!</strong>" );
			}
			$( "#adminActionsIcon" ).removeClass( "fa-spin textOrange" );
		} );
	}
}
/**
 * Send an admin notifier popup for a few seconds
 * @param type The type to send: Defaults to warn, available are warning, info, error, success
 * @param message The message to display in the notifier
 * @param delay The delay of the message, defaults to 1500 ms
 */
window.adminNotifier = function( type, message, delay ) {
	toastr.options = {
		"closeButton"       : true,
		"preventDuplicates" : true,
		"progressBar"       : true,
		"showDuration"      : "300",
		"timeOut"           : "2000",
		"positionClass"     : "toast-top-center"
	};
	switch ( type ) {
	case "info":
	{ toastr.info( message ); break; }
	case "error":
	{ toastr.error( message ); break; }
	case "success":
	{ toastr.success( message ); break; }
	case "warning":
	{ toastr.warning( message ); break; }
	default:
	{
		toastr.info( message );
		break;
	}
	}

}

window.activateContentSearch = function() {
	// local refs
	var $nav_search = $( "#nav-search" );
	var $nav_search_results = $( "#div-search-results" );
	// opacity
	$nav_search.css( "opacity", "0.8" );
	// focus effects
	$nav_search.focusin( function() {
		//if( $nav_search.is( ":focus" ) ){ return; }
		$( this ).animate( { opacity: 1.0 },
			500,
			function() {}
		);
	} ).blur( function() {
		$( this ).animate( { opacity: 0.50 },
			500,
			function() {}
		);
	} );
	// keyup quick search
	$nav_search.keyup(
		_.debounce(
			function() {
				var $this = $( this );
				// Only send requests if more than 2 characters
				if ( $this.val().length > 1 ) {
					$nav_search_results.load(
						$( "#nav-search-url" ).val(), { search: $this.val() },
						function( data ) {
							if ( $nav_search_results.css( "display" ) === "none" ) {
								$nav_search_results.fadeIn().slideDown();
							}
						}
					);
				}
			},
			300
		)
	);
	// add click listener to body to hide quick search panel
	$( "body" ).click( function( e ) {
		var target = $( e.target ),
			ipTarget = target.closest( "#div-search" );
		// if click occurs within visible element, add to ignore list
		if ( !ipTarget.length ) {
			//run global hide methods
			closeSearchBox();
		}
	} );
}

window.closeSearchBox = function() {
	$( "#div-search-results" ).slideUp();
	$( "#nav-search" ).val( "" );
}

window.quickLinks = function( inURL ) {
	if ( inURL != "null" ) {
		window.location = inURL;
	}
}

window.activateTooltips = function() {
	//Tooltip
	$( "[title]" ).tooltip( toolTipSettings );
}

window.hideAllTooltips = function(){
	$( ".tooltip" ).hide();
}

window.toggleFlickers = function(){
	$( ".flickerMessages" ).slideToggle();
	$( ".flickers" ).fadeOut( 3000 );
}
/**
 * Close the remote loaded modal
 */
window.closeRemoteModal = function() {
	$remoteModal.modal( "hide" );
}
/**
 * Reset a modal form according to the passed container
 * @param  {object} container The container
 */
window.resetContainerForms = function( container ) {
	// Clears a form in the div element, usually to reset forms in dialogs.
	var frm = container.find( "form" );
	if ( frm.length ) {
		$( frm[0] ).clearForm();
	}
}
/**
 * Close a local modal window
 * @param div The jquery div object that represents the dialog.
 */
window.closeModal = function( div ) {
	div.modal( "hide" );
}
/**
 * Open a new local modal window based on a div container
 * @param div The jquery object of the div to extract the HTML from.
 * @param w The width of the modal
 * @param h The height of the modal
 */
window.openModal = function( div, w, h ) {
	// Open the modal
	div.modal();
	// attach a listener to clear form when modal closes
	$( div ).on( "hidden.bs.modal", function() {
		resetContainerForms( $( this ) );
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
window.openRemoteModal = function( url, params, w, h, delay ) {
	// if no URL, set warning and exit
	if ( !url ) {
		console.log( "URL needed" );
		return;
	}
	var modal = $remoteModal;
	var args = {};
	var maxHeight = ( $( window ).height() - 200 );
	var maxWidth = ( $( window ).width() * 0.85 );

	// Set default values for modal data elements
	modal.data( "url", url );
	modal.data( "params", params );
	modal.data( "width", w !== undefined ? w : maxWidth );
	modal.data( "height", h !== undefined ? h : maxHeight );

	// convert height percentage to a numeric value
	var height = modal.data( "height" );
	if ( height.search && height.search( "%" ) !== -1 ) {
		height = height.replace( "%", "" ) / 100.00;
		height = $( window ).height() * height;
	}
	// Check max heights conditions
	if ( height > maxHeight ) {
		height = maxHeight;
	}
	modal.data( "height", height );

	// in delay mode, we'll create a modal and then load the data (seems to be necessary for iframes to load correctly)
	if ( delay ) {
		modal.data( "delay", true );
		modal.modal();
	}
	// otherwise, front-load the request and then create modal
	else {
		// load request for content modal
		modal.load( url, params, function() {
			// Show modal, once content has being retrieved
			modal.modal();
		} );
	}
	return;
}

/**
 * Resize the modal content preview window
 * @param {object} activeBtn The active button object
 * @param {numeric} w The width to use in pixels
 */
window.setPreviewSize = function( activeBtn, w ) {
	var modalDialog = $remoteModal.find( ".modal-dialog" ),
		frame = $( "#previewFrame" ).length ? $( "#previewFrame" ) : modalDialog,
		orig = { "width": $remoteModal.data( "width" ) },
		modalSize = { "width": w };

	// width is bigger than original size, reset to original
	if ( !w || modalSize.width > orig.width ) {
		modalSize = { "width": orig.width };
	}

	// toggle "Quick Preview" on Mobile Views
	$remoteModal.find( ".header-title" ).toggle( modalSize.width > 600 );
	// Set current active buttons
	$( activeBtn ).siblings( ".btn-primary" ).removeClass( "btn-primary" ).addClass( "btn-info" );
	$( activeBtn ).removeClass( "btn-info" ).addClass( "btn-primary" );

	// resize it now.
	modalDialog.animate( modalSize, 500 );
}
/**
 * Attach modal listeners to global modals: Remote and ConfirmIt
 */
window.attachModalListeners = function() {
	// Remote show event: Usually we resize the window here.
	$remoteModal.on( "show.bs.modal", function() {
		var modal = $remoteModal;
		modal.find( ".modal-dialog" ).css( {
			width  : modal.data( "width" ),
			height : modal.data( "height" )
		} );
	} );
	// Remote shown event: Delayed loading of content
	$remoteModal.on( "shown.bs.modal", function() {
		var modal = $remoteModal;
		// only run if modal is in delayed mode
		if ( modal.data( "delay" ) ) {
			modal.load( modal.data( "url" ), modal.data( "params" ), function() {
				modal.find( ".modal-dialog" ).css( {
					width  : modal.data( "width" ),
					height : modal.data( "height" )
				} );
			} );
		}
	} );
	// Remote hidden event: Reset loader
	$remoteModal.on( "hidden.bs.modal", function() {
		var modal = $remoteModal;
		// reset modal html
		modal.html( "<div class=\"modal-header\"><h3>Loading...</h3></div><div class=\"modal-body\" id=\"removeModelContent\"><i class=\"fa fa-spinner fa-spin fa-lg fa-4x\"></i></div>" );
		// reset container forms
		resetContainerForms( modal );
	} );
}

/**
 * Activate fancy toggle checkboxes
 */
window.activateToggleCheckboxes = function() {
	// toggle checkboxes
	$( "input[data-toggle=\"toggle\"]" ).change( function() {
		var inputMatch = $( this ).data( "match" );
		$( "#" + inputMatch ).val( $( this ).prop( "checked" ) );
		//console.log( $( this ).prop( 'checked' ) + " input match :" + inputMatch );
	} );
}

/**
 * Close confirmation modal
 */
window.closeConfirmations = function() {
	$confirmIt.modal( "hide" );
}

/**
 * Activate modal confirmation windows
 */
window.activateConfirmations = function() {
	// close button triggers for confirmation dialog
	$confirmIt.find( "button" ).click( function( e ) {
		if ( $( this ).attr( "data-action" ) === "confirm" ) {
			$confirmIt.find( "#confirmItButtons" ).hide();
			$confirmIt.find( "#confirmItLoader" ).fadeIn();
			window.location = $confirmIt.data( "confirmSrc" );
		}
	} );

	// Activate dynamic confirmations from <a> of class confirmIt
	$( ".confirmIt" ).click( function( e ) {
		// Enable button
		$confirmIt.find( "#confirmItButtons" ).fadeIn();
		$confirmIt.find( "#confirmItLoader" ).hide();
		// setup the href
		$confirmIt.data( "confirmSrc", $( this ).attr( "href" ) );
		// defaults
		var dataMessage = $( this ).attr( "data-message" ) ? $( this ).attr( "data-message" ) : "Are you sure you want to perform this action?";
		var dataTitle = $( this ).attr( "data-title" ) ? $( this ).attr( "data-title" ) : "Are you sure?";
		// set message
		$confirmIt.find( "#confirmItMessage" ).html( dataMessage );
		// set title
		$confirmIt.find( "#confirmItTitle" ).html( dataTitle );
		// show the confirmation when clicked
		$confirmIt.modal();
		// prevent default action
		e.preventDefault();
	} );
}

window.popup = function( url, w, h )  {
	var winWidth = 1000;
	var winHeight = 750;
	if ( w ) { minWidth = w; }
	if ( h ) { winHeight = h; }
	var xPosition = ( screen.width / 2 ) - ( winWidth / 2 );
	var yPosition = ( screen.height / 2 ) - ( winHeight / 2 );
	window.open( url, "layoutPreview", "resizable=yes,status=yes,location=no,menubar=no,toolbar=no,scrollbars=yes,width=" + winWidth + ",height=" + winHeight + ",left=" + xPosition + ",top=" + yPosition + ",screenX=" + xPosition + ",screenY=" + yPosition );
}
/**
 * Relocation shorcuts
 * @param link
 * @returns {Boolean}
 */
window.to = function( link ) {
	window.location = link;
	return false;
}
/**
 * Check all checkboxes utility function
 * @param checked
 * @param id
 */
window.checkAll = function( checked, id ) {
	$( "input[name='" + id + "']" ).each( function() {
		this.checked = checked;
	} );
}
/**
 * Check all checkboxes by value
 * @param id
 * @param recordID
 * @returns
 */
window.checkByValue = function( id, recordID ) {
	$( "input[name='" + id + "']" ).each( function() {
		if ( this.value === recordID ) { this.checked = true; } else { this.checked = false; }
	} );
}
/**
 * Get today's date in us or rest of the world format
 * @param {boolean} us defaults to true
 */
window.getToday = function( us ) {
	// default us to true
	us = ( us == null ? true : us );
	if ( us ) {
		return moment().format( "YYYY-MM-DD" );
	} else {
		return moment().format( "DD-MM-YYYY" );
	}
}

/**
 * Import Content Dialog Forms.
 * This function takes care of opening a generic configured import dialog and setup all
 * the events to submit it.
 */
window.importContent = function(){
	// local id's
	var $importForm = $( "#importForm" );
	var $importDialog = $( "#importDialog" );

	// open modal for cloning options
	openModal( $importDialog, 500, 350 );

	// form validator button bar loader
	$importForm.validate( {
		submitHandler : function( form ){
			$importForm.find( "#importButtonBar" ).slideUp();
			$importForm.find( "#importBarLoader" ).slideDown();
			form.submit();
		}
	} );

	// close button
	$importForm.find( "#closeButton" ).click( function( e ){
		closeModal( $importDialog );
		return false;
	} );

	// clone button
	$importForm.find( "#importButton" ).click( function( e ){
		$importForm.submit();
	} );
}

/**
 * Toggle More info panels
 */
window.toggleMoreInfoPanel = function( contentId ){
	$( "#moreInfo-" + contentId ).toggleClass( "hidden" );
	$( "#moreInfoOpenButton-" + contentId ).toggleClass( "hidden" );
	$( "#moreInfoCloseButton-" + contentId ).toggleClass( "hidden" );
}

/**
 * Password meter event closure used to monitor password changes for the meter rules to activate.
 * This expects the following ID's to be in DOM: pw_rule_lower, upper, digit, symbol and count.
 * It also expects the passwordRules element to contain the min length data element
 */
window.passwordMeter = function( event ) {
	var value = $( this ).val();
	//console.log( value );

	// Counter bind
	$( "#pw_rule_count" ).html( value.length );
	var minLength = $( "#passwordRules" ).data( "min-length" );

	// Rule Checks
	var rules = {
		lower   : REGEX_LOWER.test( value ),
		upper   : REGEX_UPPER.test( value ),
		digit   : REGEX_DIGIT.test( value ),
		special : REGEX_SPECIAL.test( value )
	};

	// Counter
	if ( value.length >= minLength ) {
		$( "#pw_rule_count" ).addClass( "badge-success" );
	} else {
		$( "#pw_rule_count" ).removeClass( "badge-success" );
	}

	// Iterate and test rules
	for ( var key in rules ) {
		if ( rules[key] ) {
			$( "#pw_rule_" + key ).addClass( "badge-success" );
		} else {
			$( "#pw_rule_" + key ).removeClass( "badge-success" );
		}
	}
}

/**
 * Used by our form validator to validate password fields according to default rules
 * @param  {any} value The password value
 * @return {boolean} Password validates via our rules
 */
window.passwordValidator = function( value ) {
	var minLength = $( "#passwordRules" ).data( "min-length" );

	var lower = REGEX_LOWER.test( value ),
		upper = REGEX_UPPER.test( value ),
		digit = REGEX_DIGIT.test( value ),
		digits = REGEX_DIGITS.test( value ),
		special = REGEX_SPECIAL.test( value );

	return lower // has a lowercase letter
        &&
        upper // has an uppercase letter
        &&
        digit // has at least one digit
        &&
        special // has special chars
        &&
        value.length >= minLength; // at least characters
}

/**
 * Convert an iso8601 to local browser date time
 *
 * @see https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Date/toLocaleString
 *
 * @param {*} dateTime The iso8601 date time object
 * @returns A local browser date time
 */
window.toLocalString = function( dateTime, options ){
	return new Date( dateTime ).toLocaleString( undefined, options || getDefaultDateTimeOptions() );
}

/**
 * Convert an iso8601 to local browser date object
 *
 * @see https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Date/toLocaleDateString
 *
 * @param {*} dateTime The iso8601 date time object
 * @returns A local browser date time
 */
window.toLocaleDateString = function( dateTime, options ){
	return new Date( dateTime ).toLocaleDateString( undefined, options || getDefaultDateTimeOptions() );
}

/**
 * Convert an iso8601 to local browser time object
 *
 * @see https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Date/toLocaleTimeString
 *
 * @param {*} dateTime The iso8601 date time object
 * @returns A local browser date time
 */
window.toLocaleTimeString = function( dateTime, options ){
	return new Date( dateTime ).toLocaleTimeString( undefined, options || getDefaultDateTimeOptions() );
}

window.getDefaultDateTimeOptions = function(){
	return { dateStyle: "medium", timeStyle: "long" };
}

/**
 * Scroll to a specific id hash
 * @param {*} hashName
 */
window.scrollToHash = function( hashName ) {
	location.hash = "#" + hashName;
}
