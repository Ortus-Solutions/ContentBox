/**
 * Get widget selector URL
 */
function getWidgetSelectorURL(){ return $cbEditorConfig.adminEntryURL + "/widgets/editorselector"; }

/**
 * Get widget preview URL
 */
function getWidgetPreviewURL(){ return $cbEditorConfig.adminEntryURL + "/widgets/preview"; }

/**
 * Get widget editor instance URL
 */
function getWidgetEditorURL(){ return $cbEditorConfig.adminEntryURL + "/widgets/editinstance"; }

/**
 * View widget instance
 */
function getWidgetInstanceURL(){ return $cbEditorConfig.adminEntryURL + "/widgets/viewWidgetInstance"; }

/**
 * Get page editor selector
 */
function getPageSelectorURL(){ return $cbEditorConfig.adminEntryURL + "/pages/editorselector"; }

/**
 * Blog Editor selector
 */
function getEntrySelectorURL(){ return $cbEditorConfig.isBlogDisabled ? '' : $cbEditorConfig.adminEntryURL + '/entries/editorselector'; }

/**
 * Get contentstore selector
 */
function getContentStoreSelectorURL(){ return $cbEditorConfig.adminEntryURL + "/contentStore/editorselector"; }

/**
 * Get content preview URL
 */
function getPreviewSelectorURL(){ return $cbEditorConfig.adminEntryURL + "/content/preview"; }

/**
 * Get a module URL link
 * @param  {string} module      The module
 * @param  {string} event       The event to execute
 * @param  {string} queryString The query string to build
 */
function getModuleURL( module, event, queryString ){
	var returnURL = "";

	$.ajax( {
		url 	: $cbEditorConfig.adminEntryURL + '/modules/buildModuleLink',
		data 	: { module: module, moduleEvent : event, moduleQS : queryString },
		async 	: false,
		success : function( data ){
			returnURL = data;
		}
	} );

	return $.trim( returnURL );
}

/**
 * Load the asset chooser from the media manager
 * @param  {Function} callback A call back URL to call for media item selections
 * @param  {numeric}   w        Window width
 * @param  {numeric}   h        Window height
 * @return {[type]}            [description]
 */
function loadAssetChooser( callback, w, h ){
	openRemoteModal(
		$cbEditorConfig.adminEntryURL + "/ckFileBrowser/assetChooser?callback=" + callback,
		{},
		w || "75%",
		h
	);
}

/**
 * Switch editors
 * @param  {string} editorType The editor to switch to
 */
function switchEditor( editorType ){
	// Save work
	if( confirm( "Would you like to save your work before switching editors?" ) ){
		$changelog.val( 'Editor Change Quick Save' );
		quickSave();
	}
	// Call change user editor preference
	$.ajax( {
		url 	: $targetEditorSaveURL,
		data 	: { editor: editorType },
		async 	: false,
		success : function( data ){
			location.reload();
		}
	} );
}

/**
 * Setup the editors. 
 * @param theForm The form container for the editor
 * @param withExcerpt Using excerpt or not apart from the main 'content' object
 * @param saveURL The URL used for saving the content asynchronously
 * @param collapseNav Automatically collapse main navigation for better editing experience 
 */
function setupEditors( theForm, withExcerpt, saveURL, collapseNav ){
	// Setup global editor elements
	$targetEditorForm   	= theForm;
	$targetEditorSaveURL 	= saveURL;
	$uploaderBarLoader 		= $targetEditorForm.find( "#uploadBarLoader" );
	$uploaderBarStatus 		= $targetEditorForm.find( "#uploadBarLoaderStatus" );
	$excerpt				= $targetEditorForm.find( "#excerpt" );
	$content 				= $targetEditorForm.find( "#content" );
	$isPublished 			= $targetEditorForm.find( "#isPublished" );
	$contentID				= $targetEditorForm.find( "#contentID" );
	$changelog				= $targetEditorForm.find( "#changelog" );
	$slug 					= $targetEditorForm.find( '#slug' );
	$withExcerpt			= withExcerpt || true;
	$wasSubmitted 			= false;
	
	// Startup the choosen editor via driver CFC
	$cbEditorStartup();

	// Activate date pickers
	$( "[type=date]" ).datepicker( { format: 'yyyy-mm-dd' } );
	$( ".datepicker" ).datepicker( { format: 'yyyy-mm-dd' } );

	// Activate Form Validators
	$targetEditorForm.validate( {
    	ignore : 'content',
        submitHandler : function( form ) {
			// Update Editor Content
        	try{ updateEditorContent(); } catch( err ){ console.log( err ); };
			// Update excerpt
			if( $withExcerpt ){
				try{ updateEditorExcerpt(); } catch( err ){ console.log( err ); };
			}
			// if it's valid, submit form
            if( $content.val().length ) {
            	// enable slug for saving.
            	$slug.prop( "disabled", false );
            	// submit
            	form.submit();
            } else {
            	alert( 'Please enter some content!' );
           	}
        }
    } );

	// Changelog mandatory?
	if( $cbEditorConfig.changelogMandatory ){
		$changelog.attr( "required", $cbEditorConfig.changelogMandatory );
	}

	// Activate blur slugify on titles
	var $title = $targetEditorForm.find( "#title" );
	// set up live event for title, do nothing if slug is locked..
	$title.on( 'blur', function(){
		if( !$slug.prop( "disabled" ) ){
			createPermalink( $title.val() );
		}
	} );
	// Activate permalink blur
	$slug.on( 'blur',function(){
		if( !$( this ).prop( "disabled" ) ){
			permalinkUniqueCheck();
		}
	} );

	// Editor dirty checks
	window.onbeforeunload = askLeaveConfirmation;
	
	// counters
	$( "#htmlKeywords" ).keyup(function(){
		$( "#html_keywords_count" ).html( $( "#htmlKeywords" ).val().length );
	} );
	$( "#htmlDescription" ).keyup(function(){
		$( "#html_description_count" ).html( $( "#htmlDescription" ).val().length );
	} );

	// setup clockpickers
    $( '.clockpicker' ).clockpicker();

	// setup autosave
	autoSave( $content, $contentID, 'contentAutoSave' );

	// Collapse navigation for better editing experience
    var bodyEl = $( '#container' );
    collapseNav = collapseNav || true;
    if( collapseNav && !$( bodyEl ).hasClass( 'sidebar-mini' ) ){
        $( 'body' ).removeClass('off-canvas-open');
        $( bodyEl ).toggleClass( 'sidebar-mini' );
    }
}


/**
 * Quick save content
 */
function quickSave(){
	// Draft it
	$isPublished.val( "false" );
	// Commit Changelog default it to quick save if not set
	if( !$changelog.val().length ){
		$changelog.val( "quick save" );
	}
	// Validation of Form First before quick save
	if( !$targetEditorForm.valid() ){
		adminNotifier( "error", "Form is not valid, please verify." );
		return false;
	}
	// Verify Content
	if( !getEditorContent().length ){
		alert( "Please enter content before saving." );
		return;
	}
	// Activate Loader
	toggleLoaderBar();
	// Save current content, just in case editor has not saved it
	if( !$content.val().length ){
		$content.val( getEditorContent() );	
	}
	// enable for quick save, if disabled
	var disableSlug = false;
	if( $slug.prop( "disabled" ) ){ 
		$slug.prop( "disabled", false );
		disableSlug = true;
	}
	// Post it
	$.post(
		$targetEditorSaveURL, 
		$targetEditorForm.serialize(), 
		function( data ){
			// Save new id
			$contentID.val( data.CONTENTID );
			// finalize
			$changelog.val( '' );
			$uploaderBarLoader.fadeOut( 1500 );
			$uploaderBarStatus.html( 'Draft Saved!' );
			$isPublished.val( 'true' );
			// bring back slug if needed.
			if( disableSlug ){
				$slug.prop( "disabled", true );
			}
			// notify
			adminNotifier( "info", "Draft Saved!" );
		},
		"json" 
	);
}

/**
 * Quick Live Preview
 * @return {[type]} [description]
 */
function previewContent(){
	// Open the preview window for content
	openRemoteModal( 
		getPreviewSelectorURL(),
		{ 
			content		: getEditorContent(), 
			layout		: $( "#layout" ).val(),
			title		: $( "#title" ).val(),
			slug		: $slug.val(),
			contentType : $( "#contentType" ).val(),
			markup 		: $( "#markup" ).val(),
			parentPage	: $( "#parentPage" ).val() || ''
		},
		$( window ).width() - 50,
		$( window ).height() - 200,
        true
	);
}

/**
 * Set the correct publish date to now
 */
function publishNow(){
	var fullDate = new Date();
	$( "#publishedDate" ).val( getToday() );
	$( "#publishedHour" ).val( fullDate.getHours() );
	$( "#publishedMinute" ).val( fullDate.getMinutes() );
}

/**
 * Switch markup type
 * @param  {string} markupType The markup type
 */
function switchMarkup(markupType){
	$( "#markup" ).val( markupType );
	$( "#markupLabel" ).html( markupType );
}

/**
 * Set that the form was submitted
 */
function setWasSubmitted(){
	$wasSubmitted = true;
}

/**
 * As for leave confirmation if content is dirty
 * @return {string} The confirmation message the browser will ask if set.
 */
function askLeaveConfirmation(){
	if ( checkIsDirty() && !$wasSubmitted ){
   		return "You have unsaved changes.";
   	}
}

/**
 * Check if permalink is unique
 * @param  {string} linkToUse The link to check
 */
function permalinkUniqueCheck( linkToUse ){
	var linkToUse = linkToUse || $slug.val();
	linkToUse = $.trim( linkToUse ); //slugify still appends a space at the end of the string, so trim here for check uniqueness	
	if( !linkToUse.length ){ return; }
	// Verify unique
	$.getJSON( 
		$cbEditorConfig.slugCheckURL, 
		{ slug : linkToUse, contentID : $( "#contentID" ).val() }, 
		function( data ){
			if( !data.UNIQUE ){
				$( "#slugCheckErrors" )
					.html( "The permalink slug you entered is already in use, please enter another one or modify it." )
					.addClass( "alert alert-danger" );
			} else {
				$( "#slugCheckErrors" ).html( "" ).removeClass( "alert alert-danger" );
			}
		} 
	);
}

/**
 * Create a permalink
 * @param  {string} linkToUse [description]
 */
function createPermalink( linkToUse ){
	var $title 		= $targetEditorForm.find( "#title" );
	var linkToUse 	= linkToUse || $title.val();
	if( !linkToUse.length ){ return; }
	
	togglePermalink()
	
	$.get( 
		$cbEditorConfig.slugifyURL, 
		{ slug : linkToUse }, 
		function( data ){
			$slug.val( data );
			permalinkUniqueCheck();
			togglePermalink();
		} 
	);
}

/**
 * Toggle permalink 
 */
function togglePermalink(){
	var toggle = $( '#togglePermalink' );
	// Toggle lock icon on click..	
	toggle.hasClass( 'fa fa-lock' ) ? toggle.attr( 'class', 'fa fa-unlock' ) : toggle.attr( 'class', 'fa fa-lock' );
	//disable input field
	$slug.prop( "disabled", !$slug.prop( "disabled" ) );
}

/**
 * Toggle draft mode or not
 */
function toggleDraft(){
	$isPublished.val( 'false' );
}

/**
 * Quick publish 
 * @param  {Boolean} isDraft draft mode or publish
 */
function quickPublish( isDraft ){
	if( isDraft ){
		toggleDraft();
	}
	// Verify changelogs and open sidebar if closed:
	if( $cbEditorConfig.changelogMandatory && !isMainSidebarOpen() ){
		toggleSidebar();
	}
	// submit form
	$targetEditorForm.submit();
}

/**
 * Toggle the loader bar visibility
 */
function toggleLoaderBar(){
	// Activate Loader
	$uploaderBarStatus.html( "Saving..." );
	$uploaderBarLoader.slideToggle();
}

/**
 * Featured image callback
 * @param  {string} filePath The file path
 * @param  {string} fileURL  The file URL
 * @param  {string} fileType Directory or file
 */
function featuredImageCallback( filePath, fileURL, fileType ){
	if( $( "#featuredImage" ).val().length ){ cancelFeaturedImage(); }
    $( "#featuredImageControls" ).toggleClass( "hide" );
    $( "#featuredImage" ).val( filePath );
    $( "#featuredImageURL" ).val( fileURL );
    $( "#featuredImagePreview" ).attr( "src", fileURL );
    closeRemoteModal();
}

/**
 * Cancel featured image
 */
function cancelFeaturedImage(){
    $( "#featuredImage" ).val( "" );
    $( "#featuredImageURL" ).val( "" );
    $( "#featuredImagePreview" ).attr( "src", "" );
    $( "#featuredImageControls" ).toggleClass( "hide" );
}