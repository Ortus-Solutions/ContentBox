/**
 * Auto save functionality
 * @param  {object} editor   The editor reference
 * @param  {string} pageID   The content object id
 * @param  {string} ddMenuID The menu ID
 * @param  {object} options  The override options such as: storeMax, timeout
 * @return {object}          Returns the auto save closure
 */
autoSave = function( editor, pageID, ddMenuID, options ){
	// Verify local storage, else disable feature
	if( !Modernizr.localstorage ){
		$( "#" + ddMenuID ).find( ".autoSaveBtn" )
			.html( "Auto Save Unavailable" )
			.addClass( 'disabled' );
		return false;
	}

	// Setup defaults and global options
	var defaults 		= { storeMax : 10, timeout : 4000 };
	var opts 			= $.extend( {}, defaults, options || {} );
	var editorID 		= editor.attr( 'id' );
	// Retrieve the actual editor driver implementation using ContentBox JS Interface Method
	var oEditorDriver 	= getContentEditor();
	var saveStoreKey 	= 'autosave_' + window.location + "_" + editorID;
	var timer 			= 0, savingActive = false;

	// Setup SavesStore
	if( !localStorage.getItem( saveStoreKey ) ){
		localStorage.setItem( saveStoreKey, '[]' );
	}
	var saveStore = JSON.parse( localStorage.getItem( saveStoreKey ) );

	/**
	 * Remove old saves
	 * @param  {Function} callback The callback function
	 */
	var removeOldSaves = function( callback ){
		var overMax = saveStore.length - opts.storeMax;
		for( var i = 0; i < overMax; i++ ){
		  localStorage.removeItem( saveStore[ i ] );
		  saveStore.splice( i, 1 );
		}
		if( callback ){
			callback();
		}
	};

	/**
	 * Add to saved storage
	 * @param {string} saveKey The save storage key
	 */
	var addToStore = function( saveKey ){
		saveStore.push( saveKey );
		if( saveStore.length > opts.storeMax ){
		  removeOldSaves( updateAutoSaveMenu );
		} else {
		  updateAutoSaveMenu();
		}
	};

	/**
	 * Update auto save dropdown menu
	 */
	var updateAutoSaveMenu = function(){
		localStorage.setItem( saveStoreKey, JSON.stringify( saveStore ) );
		var ulList = '';
		for( var i = saveStore.length; i--; ){
		  var newItemDate 	= moment( saveStore[ i ].replace( editorID + '_', '' ), 'x' );
		  var dateTitle 	= moment().diff( newItemDate, "hours" ) < 1 ? newItemDate.fromNow() : newItemDate.format( "MM/DD/YYYY h:mm a" );
		  ulList += '<li><a href="javascript:void(0)" data-id="' + saveStore[ i ] + '">' + dateTitle +'</a></li>';
		}
		// No records
		if( !saveStore.length ){
			ulList = '<li><a href="javascript:void(0)">No Autosaves, type something :)</a></li>';
		}
		// Add records
		$( "#" + ddMenuID ).find( ".autoSaveMenu" ).html( ulList );
	};

	/**
	 * Start the autosave timer
	 * @param  {object} event The JS event object
	 */
	var startTimer = function( event ){
	  	if( timer ){ clearTimeout( timer ); }
	  	timer = setTimeout( onTimer, opts.timeout, event );
	};

	/**
	 * Autosave Command
	 * @param  {object} event The JS event object
	 */
	var onTimer = function( event ){
		if( savingActive ) {
		  startTimer( event );
		} else {
			savingActive = true;
			var autoSaveKey = editorID + "_" + Date.now();
			// Store it
			localStorage.setItem( autoSaveKey, LZString.compressToUTF16( getEditorContent() ) );
			// Add to items
			addToStore( autoSaveKey );
			// mark as done
			savingActive = false;
		}
	};

	/**
	 * Load content back into editor
	 * @param  {string} contentID The content ID to load from local storage
	 */
	var loadContent = function( contentID ){
		var content = localStorage.getItem( contentID );
		setEditorContent( 'content', LZString.decompressFromUTF16( content ) );
		if( timer ){ clearTimeout( timer ); }
	};

	// Register change event for auto saving
	getContentEditor().on( 'change', startTimer );
	
	// Load Previous AutoLoad when selected from the Dropdown menu
	$( '#' + ddMenuID ).on( 'click', 'li > a', function( evt ){
		loadContent( $( evt.currentTarget ).data( 'id' ) );
	} );
	// Update auto save menu
	updateAutoSaveMenu();
};