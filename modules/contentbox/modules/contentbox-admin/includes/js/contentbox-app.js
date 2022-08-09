document.addEventListener( "DOMContentLoaded", () => {
	// GLOBAL STATIC
	REGEX_LOWER = /[a-z]/,
	REGEX_UPPER = /[A-Z]/,
	REGEX_DIGIT = /[0-9]/,
	REGEX_DIGITS = /[0-9].*[0-9]/,
	REGEX_SPECIAL = /[^a-zA-Z0-9]/;

	// If the sidebar preference is off, toggle it
	if ( $( "body" ).attr( "data-showsidebar" ) == "no" ) {
		toggleSidebar();
	}
	// If "main-content-sidebar" exists then bring toggler in
	if ( $( "#main-content-sidebar" ).attr( "id" ) !== undefined ) {
		$( "#main-content-sidebar-trigger" ).fadeIn();
	}

	// setup global variables
	$confirmIt = $( "#confirmIt" );
	$remoteModal = $( "#modal" );

	// Attach modal listeners
	attachModalListeners();

	// Global Tool Tip Settings
	toolTipSettings = {
		animation : "slide",
		delay     : { show: 100, hide: 100 }
	};

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
	jwerty.key(
		"ctrl+shift+s",
		function() {
			$( "#nav-search" ).focus();
			return false;
		}
	);

	// find all links with the key-binding data attribute
	$( "[data-keybinding]" ).each( function() {
		var boundItem = $( this );
		jwerty.key( boundItem.data( "keybinding" ), function() {
			// give precedence to onclick
			if ( boundItem.attr( "onclick" ) ) {
				// if onclick, call event
				boundItem.click();
			} else {
				// otherwise, follow link
				to( boundItem.attr( "href" ) );
			}
		} );
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
function activateNavbarState() {
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
function isMainSidebarOpen() {
	var sidebar = $( "#main-content-sidebar" );
	return ( sidebar.attr( "id" ) !== undefined && sidebar.css( "display" ) === "block" ? true : false );
}
/**
 * Toggle the main sidebar to fully display the main slot of content.
 * main-content-slot (col) main-content-sidebar (col)
 */
function toggleSidebar() {
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
function adminAction( action, actionURL ) {
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
function adminNotifier( type, message, delay ) {
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

function activateContentSearch() {
	// local refs
	$nav_search = $( "#nav-search" );
	$nav_search_results = $( "#div-search-results" );
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

function closeSearchBox() {
	$( "#div-search-results" ).slideUp();
	$( "#nav-search" ).val( "" );
}

function quickLinks( inURL ) {
	if ( inURL != "null" ) {
		window.location = inURL;
	}
}

function activateTooltips() {
	//Tooltip
	$( "[title]" ).tooltip( toolTipSettings );
}

function hideAllTooltips() {
	$( ".tooltip" ).hide();
}

function toggleFlickers() {
	$( ".flickerMessages" ).slideToggle();
	$( ".flickers" ).fadeOut( 3000 );
}
/**
 * Close the remote loaded modal
 */
function closeRemoteModal() {
	$remoteModal.modal( "hide" );
}
/**
 * Reset a modal form according to the passed container
 * @param  {object} container The container
 */
function resetContainerForms( container ) {
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
function closeModal( div ) {
	div.modal( "hide" );
}
/**
 * Open a new local modal window based on a div container
 * @param div The jquery object of the div to extract the HTML from.
 * @param w The width of the modal
 * @param h The height of the modal
 */
function openModal( div, w, h ) {
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
function openRemoteModal( url, params, w, h, delay ) {
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
function setPreviewSize( activeBtn, w ) {
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
function attachModalListeners() {
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
function activateToggleCheckboxes() {
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
function closeConfirmations() {
	$confirmIt.modal( "hide" );
}

/**
 * Activate modal confirmation windows
 */
function activateConfirmations() {
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

function popup( url, w, h ) {
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
function to( link ) {
	window.location = link;
	return false;
}
/**
 * Check all checkboxes utility function
 * @param checked
 * @param id
 */
function checkAll( checked, id ) {
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
function checkByValue( id, recordID ) {
	$( "input[name='" + id + "']" ).each( function() {
		if ( this.value === recordID ) { this.checked = true; } else { this.checked = false; }
	} );
}
/**
 * Get today's date in us or rest of the world format
 * @param {boolean} us defaults to true
 */
function getToday( us ) {
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
function importContent(){
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
function toggleMoreInfoPanel( contentId ){
	$( "#moreInfo-" + contentId ).toggleClass( "hidden" );
	$( "#moreInfoOpenButton-" + contentId ).toggleClass( "hidden" );
	$( "#moreInfoCloseButton-" + contentId ).toggleClass( "hidden" );
}

/**
 * Password meter event closure used to monitor password changes for the meter rules to activate.
 * This expects the following ID's to be in DOM: pw_rule_lower, upper, digit, symbol and count.
 * It also expects the passwordRules element to contain the min length data element
 */
function passwordMeter( event ) {
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
function passwordValidator( value ) {
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
function toLocalString( dateTime, options ){
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
function toLocaleDateString( dateTime, options ){
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
function toLocaleTimeString( dateTime, options ){
	return new Date( dateTime ).toLocaleTimeString( undefined, options || getDefaultDateTimeOptions() );
}

function getDefaultDateTimeOptions(){
	return { dateStyle: "medium", timeStyle: "long" };
}

/**
 * Scroll to a specific id hash
 * @param {*} hashName
 */
function scrollToHash( hashName ) {
	location.hash = "#" + hashName;
}

var app = function() {

	var init = function() {
		tooltips();
		toggleMenuLeft();
		toggleMenuRight();
		switcheryToggle();
		menu();
		togglePanel();
		closePanel();
	};

	var tooltips = function() {
		$( "#toggle-left" ).tooltip( { delay: 100 } );
	};

	var togglePanel = function() {
		$( ".actions > .fa-chevron-down" ).click( function() {
			$( this ).parent().parent().next().slideToggle( "fast" );
			$( this ).toggleClass( "fa-chevron-down fa-chevron-up" );
		} );
	};

	var toggleMenuLeft = function() {
		$( "#toggle-left" ).bind( "click", function( e ) {
			$( "body" ).removeClass( "off-canvas-open" );
			var bodyEl = $( "#container" );
			( $( window ).width() > 767 ) ? $( bodyEl ).toggleClass( "sidebar-mini" ): $( bodyEl ).toggleClass( "sidebar-opened" );
		} );
	};

	var toggleMenuRight = function() {
		$( "#toggle-right" ).click( function(){
			$( ".off-canvas" ).toggleClass( "off-canvas-open" );
		} );
	};

	var switcheryToggle = function() {
		var elems = Array.prototype.slice.call( document.querySelectorAll( ".js-switch" ) );
		elems.forEach( function( html ) {
			var switchery = new Switchery( html, { size: "small" } );
		} );
	};

	var closePanel = function() {
		$( ".actions > .fa-times" ).click( function() {
			$( this ).parent().parent().parent().fadeOut();
		} );

	};

	var menu = function() {
		var subMenu = $( ".sidebar .nav" );
		$( subMenu ).navgoco( {
			caretHtml : false,
			accordion : true,
			slide     : {
				duration : 400,
				easing   : "swing"
			}
		} );

	};
	//End functions

	//morris pie chart
	var morrisPie = function() {

		Morris.Donut( {
			element : "donut-example",
			data    : [
				{
					label : "Chrome",
					value : 73
				},
				{
					label : "Firefox",
					value : 71
				},
				{
					label : "Safari",
					value : 69
				},
				{
					label : "Internet Explorer",
					value : 40
				},
				{
					label : "Opera",
					value : 20
				},
				{
					label : "Android Browser",
					value : 10
				}

			],
			colors : [
				"#1abc9c",
				"#293949",
				"#e84c3d",
				"#3598db",
				"#2dcc70",
				"#f1c40f"
			]
		} );
	};

	// Sliders
	var sliders = function() {
		$( ".slider-span" ).slider();
	};

	// return functions
	return {
		init      : init,
		sliders   : sliders,
		morrisPie : morrisPie
	};
}();

document.addEventListener( "DOMContentLoaded", () => {
	app.init();
	// Collapsed nav if <=768 by default
	var bodyEl = $( "#container" );
	if ( $( window ).width() <= 768 && !$( bodyEl ).hasClass( "sidebar-mini" ) ){
		$( "body" ).removeClass( "off-canvas-open" );
		$( bodyEl ).toggleClass( "sidebar-mini" );
	}
} );
const contentListHelper = ( () => {

	const JSON_HEADER = { "Content-type": "application/json;charset=UTF-8" };

	// Properties
	var $adminEntryPoint = "";
	var $tableContainer  = "";
	var $tableURL		 = "";
	var $searchField 	 = "";
	var $searchName		 = "";
	var $contentForm	 = "";
	var $bulkStatusURL   = "";
	var $cloneDialog	 = "";
	var $parentID 		 = "";

	/**
	 * Load content into the setup properties. We define it here, so the references can be compiled on the returned exposed functions
	 *
	 * @param {*} criteria Object literal of filtering options: search, page, parent, fAuthors, fCreators, fCatetories, fStatus, showAll
	 */
	var contentLoad = ( criteria ) => {
		// default checks
		if ( criteria == undefined ){ criteria = {}; }
		// default criteria matches
		if ( !( "search" in criteria ) ){ criteria.search = ""; }
		if ( !( "page" in criteria ) ){ criteria.page = 1; }
		if ( !( "parent" in criteria ) ){ criteria.parent = ""; }
		if ( !( "fAuthors" in criteria ) ){ criteria.fAuthors = "all"; }
		if ( !( "fCreators" in criteria ) ){ criteria.fCreators = "all"; }
		if ( !( "fCategories" in criteria ) ){ criteria.fCategories = "all"; }
		if ( !( "fStatus" in criteria ) ){ criteria.fStatus = "any"; }
		if ( !( "showAll" in criteria ) ){ criteria.showAll = false; }

		// loading effect
		$tableContainer.css( "opacity", .60 );
		var args = {
			page     			: criteria.page,
			parent   			: criteria.parent,
			fAuthors  		: criteria.fAuthors,
			fCategories	: criteria.fCategories,
			fStatus   		: criteria.fStatus,
			showAll   		: criteria.showAll,
			fCreators 		: criteria.fCreators,
		};
		// Add dynamic search key name
		args[ $searchName ] = criteria.search;
		// load content
		$tableContainer.load( $tableURL, args, function(){
			$tableContainer.css( "opacity", 1 );
			$( this ).fadeIn( "fast" );
		} );
	};

	/**
	 * Applies filters and loads the content
	 */
	var contentFilter = () => {
		if ( $( "#fAuthors" ).val() != "all" ||
			$( "#fCreators" ).val() != "all" ||
			$( "#fCategories" ).val() != "all" ||
			$( "#fStatus" ).val() != "any" ) {
			$( "#filterBox" ).addClass( "selected" );
		}
		else {
			$( "#filterBox" ).removeClass( "selected" );
		}
		contentLoad( {
			fAuthors    : $( "#fAuthors" ).val(),
			fCategories : $( "#fCategories" ).val(),
			fStatus     : $( "#fStatus" ).val(),
			fCreators   : $( "#fCreators" ).val()
		} );
	};

	// reset filters
	var resetFilter = ( reload ) => {
		// reload check
		if ( reload ){
			contentLoad();
		}
		// reload filters
		$( "#filterBox" ).removeClass( "selected" );
		$( "#fAuthors" ).val( "all" );
		$( "#fCategories" ).val( "all" );
		$( "#fStatus" ).val( "any" );
		$( "#fCreators" ).val( "all" );
	};

	// Return our encapsulated module
	return {

		// Setup the content view with the settings object
		init : ( settings ) => {
			// setup model properties
			$adminEntryPoint = settings.adminEntryPoint;
			$tableContainer = settings.tableContainer;
			$tableURL		= settings.tableURL;
			$searchField 	= settings.searchField;
			$searchName		= settings.searchName;
			$contentForm	= settings.contentForm;
			$bulkStatusURL  = settings.bulkStatusURL;
			$cloneDialog	= settings.cloneDialog;
			$parentID 		= settings.parentID;

			// Create history Listener
			History.Adapter.bind( window, "statechange", function(){
				contentLoad( { parent: History.getState().data.parent } );
			} );

			// quick search binding
			$searchField.keyup(
				_.debounce(
					function(){
						contentLoad( { search: $( this ).val() } );
					},
					300
				)
			);

			// load content on startup, using default parents if passed.
			if ( $parentID.length ){
				// Load initial data
				contentLoad( { parent: $parentID } );
			} else {
				contentLoad( {} );
			}
		},

		contentLoad  	: contentLoad,
		contentFilter	: contentFilter,
		resetFilter  	: resetFilter,

		// Content drill down
		contentDrilldown : ( parent ) => {
			resetFilter();
			if ( parent == undefined ){ parent = ""; }
			$searchField.val( "" );
			// push history
			History.pushState( { parent: parent }, document.title, "?parent=" + parent );
			// Scroll back up
			scrollToHash( "container" );
		},

		// show all content
		contentShowAll : () => {
			resetFilter();
			contentLoad ( { showAll: true } );
		},

		// content paginate
		contentPaginate : ( page ) => {
			// paginate with kept searches and filters.
			contentLoad( {
				search      : $searchField.val(),
				page        : page,
				parent      : History.getState().data.parent || $parentID,
				fAuthors    : $( "#fAuthors" ).val(),
				fCategories : $( "#fCategories" ).val(),
				fStatus     : $( "#fStatus" ).val(),
				fCreators   : $( "#fCreators" ).val()
			} );
		},

		// Get info panel contents
		getInfoPanelContent : ( contentID ) => {
			return $( "#infoPanel_" + contentID ).html();
		},

		// Activate info panels
		activateInfoPanels : () => {
			$( ".popovers" ).popover( {
				html    : true,
				content : function(){
					return getInfoPanelContent( $( this ).attr( "data-contentID" ) );
				},
				trigger   : "hover",
				placement : "left",
				title     : "<i class=\"fa fa-info-circle\"></i> Quick Info",
				delay     : { show: 200, hide: 500 }
			} );
		},

		// Activate quick looks
		activateQuickLook : ( $table, quickLookURL ) => {
			$table.find( "tr" ).bind( "contextmenu",function( e ) {
				if ( e.which === 3 ) {
					if ( $( this ).attr( "data-contentID" ) != null ) {
						openRemoteModal( quickLookURL + $( this ).attr( "data-contentID" ) );
						e.preventDefault();
					}
				}
			} );
		},

		// Remove content
		remove : ( contentID, id ) => {
			id = typeof id !== "undefined" ? id : "contentID";
			checkAll( false, id );
			if ( contentID != null ){
				$( "#delete_"+ contentID ).removeClass( "fa fa-minus-circle" ).addClass( "fa fa-spinner fa-spin" );
				checkByValue( id, contentID );
			}
			$contentForm.submit();
		},

		// Bulk Remove
		bulkRemove : () => {
			$contentForm.submit();
		},

		exportSelected : ( exportEvent ) => {
			var selected = [];
			$( "#contentID:checked" ).each( function(){
				selected.push( $( this ).val() );
			} );
			if ( selected.length ){
				checkAll( false, "contentID" );
				window.open( exportEvent + "/contentID/" + selected );
			} else {
				alert( "Please select something to export!" );
			}
		},

		// Bulk change status
		bulkChangeStatus : ( status, contentID ) => {
			// Setup the right form actions and status
			$contentForm.attr( "action", $bulkStatusURL );
			$contentForm.find( "#contentStatus" ).val( status );
			// only submit if something selected
			if ( contentID != null ){
				$( "#status_"+ recordID ).removeClass( "fa fa-minus-circle" ).addClass( "fa fa-spinner fa-spin" );
				checkByValue( "contentID", contentID );
			}
			$contentForm.submit();
		},

		// Clone Dialog
		openCloneDialog : ( contentID, title ) => {
			// local id's
			var $cloneForm = $cloneDialog.find( "#cloneForm" );
			// open modal for cloning options
			openModal( $cloneDialog, 500 );
			// form validator and data
			$cloneForm.validate( {
				submitHandler : function( form ){
					$cloneDialog.find( "#cloneButtonBar" ).slideUp();
					$cloneDialog.find( "#clonerBarLoader" ).slideDown();
					form.submit();
				}
			} );
			// Setup title and content id.
			$cloneForm.find( "#contentID" ).val( contentID );
			$cloneForm.find( "#title" ).val( title ).focus();
			// clone button actions
			$cloneDialog.find( "#cloneButton" ).click( function( e ){
				$cloneForm.submit();
			} );

		},

		/**
		 * Reset the hits on a sepcific content object
		 *
		 * @param {*} contentID The content id to reset the hits on
		 */
		resetHits : ( contentID ) => {
			// if no length, exit out
			if ( !contentID.length ){ return; }

			fetch( $adminEntryPoint + "/content/resetHits", {
				method 	: "POST",
				headers : JSON_HEADER,
				body   	: JSON.stringify( { contentID: contentID } )
			} )
				.then( response => response.json() )
				.then( data => {
					if ( !data.error ){
						adminNotifier( "info", data.messages.join( "<br>" ), 3000 );
						contentFilter();
					} else {
						alert( "Error Reseting Hits: " + data.messages.join( "," ) );
					}
				} )
				.catch( error => {
					alert( "Error Reseting Hits: " + error );
				} )
			;
		},

		/**
		 * Reset the hits for multiple selected content objects
		 */
		resetBulkHits : () => {
			var selected = [];
			$( "#contentID:checked" ).each( function(){
				selected.push( $( this ).val() );
			} );
			if ( selected.length ){
				resetHits( selected.join( "," ) );
			}
		}
	};

} )();

/**
 *********************************************************************************
 * Copyright since 2005 ColdBox Framework by Luis Majano and Ortus Solutions, Corp
 * www.coldbox.org | www.luismajano.com | www.ortussolutions.com
 *********************************************************************************
 * This callbacks js is used to place common editor, OS software callbacks so they
 * can be reused.  You can also modify it to add your own.
 */

/**
 * CKEditor Call Back
 * @param sPath
 * @param sURL
 * @param sType
 */
function fbCKSelect( sPath, sURL, sType ){
	/**
	 * Get specific URL param
	 * @param  {string} paramName Param Nam
	 * @return {string}           The cleaned param name
	 */
	var getURLParam = function( paramName ){
		var reParam 	= new RegExp( "(?:[\?&]|&amp;)" + paramName + "=([^&]+)", "i" );
		var match 	= window.location.search.match( reParam );
		return ( match && match.length > 1 ) ? match[ 1 ] : "" ;
	};

	if ( !sPath.length || sType === "dir" ){
		alert( "Please select a file first." );
		return;
	}
	var funcNum = getURLParam( "CKEditorFuncNum" );
	window.opener.CKEDITOR.tools.callFunction( funcNum, sURL );
	window.close();
}
/**
 * Generic close callback
 */
function fbGenericClose(){
	window.close();
}
/**
 * Testing select calback
 * @param path
 * @param rPath
 * @param type
 */
function fbTestChoose( path, rPath, type ){
	alert( "Path: " + path + "\n URL: " + rPath + "\n Type: " + type );
}
/**
 * Cancel called
 * @return {[type]} [description]
 */
function fbTestCancel(){
	alert( "Cancel Called" );
}

function fbUpload(){
	$( "#uploadBar" ).slideToggle();
}

/** Verifies which view is active */
function fbVerifyActiveView() {
	let identifier = "#" + $listType.val() + $listFolder.val();
	$( identifier ).removeClass( "btn-more" ).addClass( "btn-default" );
}
