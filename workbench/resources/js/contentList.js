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
