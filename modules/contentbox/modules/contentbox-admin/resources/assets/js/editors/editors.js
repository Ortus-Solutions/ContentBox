/**
 * Get widget selector URL
 */
window.getWidgetSelectorURL = function(){ return $cbEditorConfig.adminEntryURL + "/widgets/editorselector"; }

/**
 * Get widget preview URL
 */
window.getWidgetPreviewURL = function(){ return $cbEditorConfig.adminEntryURL + "/widgets/preview"; }

/**
 * Get widget editor instance URL
 */
window.getWidgetEditorURL = function(){ return $cbEditorConfig.adminEntryURL + "/widgets/editinstance"; }

/**
 * View widget instance
 */
window.getWidgetInstanceURL = function(){ return $cbEditorConfig.adminEntryURL + "/widgets/viewWidgetInstance"; }

/**
 * Get page editor selector
 */
window.getPageSelectorURL = function(){ return $cbEditorConfig.adminEntryURL + "/pages/editorselector"; }

/**
 * Blog Editor selector
 */
window.getEntrySelectorURL = function(){ return $cbEditorConfig.isBlogDisabled ? "" : $cbEditorConfig.adminEntryURL + "/entries/editorselector"; }

/**
 * Get contentstore selector
 */
window.getContentStoreSelectorURL = function(){ return $cbEditorConfig.adminEntryURL + "/contentStore/editorselector"; }

/**
 * Get content preview URL
 */
window.getPreviewSelectorURL = function(){ return $cbEditorConfig.adminEntryURL + "/content/preview"; }

/**
 * Get author editor preference
 */
window.getAuthorEditorPreferenceURL = function(){ return $cbEditorConfig.adminEntryURL + "/authors/changeEditor"; }

/**
 * Get author save preference
 */
window.getAuthorSavePreferenceURL = function(){ return $cbEditorConfig.adminEntryURL + "/authors/saveSinglePreference"; }

/**
 * Get a module URL link
 * @param  {string} module      The module
 * @param  {string} event       The event to execute
 * @param  {string} queryString The query string to build
 */
window.getModuleURL = function( module, event, queryString ){
	var returnURL = "";

	$.ajax( {
		url    	: $cbEditorConfig.adminEntryURL + "/modules/buildModuleLink",
		data   	: { module: module, moduleEvent: event, moduleQS: queryString },
		async  	: false,
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
window.loadAssetChooser = function( callback, w, h ){
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
window.switchEditor = function( editorType ){
	// Save work
	if ( confirm( "Would you like to save your work before switching editors?" ) ){
		$changelog.val( "Editor Change Quick Save" );
		quickSave();
	}
	// Call change user editor preference
	$.ajax( {
		url    	: getAuthorEditorPreferenceURL(),
		data   	: { editor: editorType },
		async  	: false,
		success : function( data ){
			location.reload();
		}
	} );
}

/**
 * Setup the editors.
 *
 * @param theForm The form container for the editor
 * @param withExcerpt Using excerpt or not apart from the main 'content' object
 * @param saveURL The URL used for saving the content asynchronously
 * @param collapseNav Automatically collapse main navigation for better editing experience
 */
window.setupEditors = function( theForm, withExcerpt, saveURL, collapseNav ){
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
	$slug 					= $targetEditorForm.find( "#slug" );
	$publishingBar 			= $targetEditorForm.find( "#publishingBar" );
	$actionBar 				= $targetEditorForm.find( "#actionBar" );
	$publishButton 			= $targetEditorForm.find( "#publishButton" );
	$withExcerpt			= withExcerpt || true;
	$wasSubmitted 			= false;

	// Startup the choosen editor via driver CFC
	$cbEditorStartup();

	// Activate date pickers
	$( "[type=date]" ).datepicker( { format: "yyyy-mm-dd" } );
	$( ".datepicker" ).datepicker( { format: "yyyy-mm-dd" } );

	// Activate Form Validators
	$targetEditorForm.validate( {
    	ignore      		: "content",
		submitHandler	: function( form ) {
			// Update Editor Content
        	try {
        		updateEditorContent();
        	} catch ( err ){
        		console.log( err );
        	};

			// Update excerpt
			if ( $withExcerpt ){
				try {
					updateEditorExcerpt();
				} catch ( err ){
					console.log( err );
				};
			}

			// if it's valid, submit form
			if ( $content.val().length ) {
            	// enable slug for saving.
            	$slug.prop( "disabled", false );
            	// Disable Publish Buttons
            	$publishButton.prop( "disabled", true );
            	// submit
            	form.submit();
			} else {
            	alert( "Please enter some content!" );
           	}
		}
	} );

	// Changelog mandatory?
	if ( $cbEditorConfig.changelogMandatory ){
		$changelog.attr( "required", $cbEditorConfig.changelogMandatory );
	}

	// Activate blur slugify on titles
	var $title = $targetEditorForm.find( "#title" );
	// set up live event for title, do nothing if slug is locked..
	$title.on( "blur", function(){
		if ( !$slug.prop( "disabled" ) ){
			createPermalink( $title.val() );
		}
	} );
	// Activate permalink blur
	$slug.on( "blur",function(){
		if ( !$( this ).prop( "disabled" ) ){
			permalinkUniqueCheck();
		}
	} );

	// Editor dirty checks
	window.onbeforeunload = askLeaveConfirmation;

	// Editor alerts
	window.alerts = [];

	// counters
	$( "#htmlKeywords" ).keyup( function(){
		$( "#html_keywords_count" ).html( $( "#htmlKeywords" ).val().length );
	} );
	$( "#htmlDescription" ).keyup( function(){
		$( "#html_description_count" ).html( $( "#htmlDescription" ).val().length );
	} );

	// setup clockpickers
	$( ".clockpicker" ).clockpicker();

	// setup autosave
	autoSave( $content, $contentID, "contentAutoSave" );

	// Collapse navigation for better editing experience
	var bodyEl = $( "#container" );
	collapseNav = collapseNav || true;
	if ( collapseNav && !$( bodyEl ).hasClass( "sidebar-mini" ) ){
		$( "body" ).removeClass( "off-canvas-open" );
		$( bodyEl ).toggleClass( "sidebar-mini" );
	}
}

/**
 * Checks if user wants to draft content that is published already
 * @return {boolean}
 */
window.shouldPublish = function(){
	// Confirm if you really want to quick save if content is published already
	if ( $contentID.val().length && $isPublished.val() == "true" ){
		return confirm(
			"Your content is published already, quick saving it will draft it and unpublish it." +
			"If you want to re-publish, just hit Publish again." +
			"Are you sure you want to draft the content?"
		);
	}
	return true;
}

/**
 * Quick save content
 */
window.quickSave = function(){
	// Confirm if you really want to quick save if content is published already
	if ( !shouldPublish() ){
		return;
	}

	// Draft it
	$isPublished.val( "false" );

	// Commit Changelog default it to quick save if not set
	if ( !$changelog.val().length ){
		$changelog.val( "quick save" );
	}
	// Validation of Form First before quick save
	if ( !$targetEditorForm.valid() ){
		adminNotifier( "error", "Form is not valid, please verify." );
		return false;
	}
	// Verify Content
	if ( !getEditorContent().length ){
		alert( "Please enter content before saving." );
		return;
	}
	// Activate Loader
	toggleLoaderBar();
	// Save current content, just in case editor has not saved it
	if ( !$content.val().length ){
		$content.val( getEditorContent() );
	}
	// enable for quick save, if disabled
	var disableSlug = false;
	if ( $slug.prop( "disabled" ) ){
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
			$changelog.val( "" );
			$uploaderBarLoader.fadeOut( 1500 );
			$uploaderBarStatus.html( "Draft Saved!" );
			$isPublished.val( "true" );
			// bring back slug if needed.
			if ( disableSlug ){
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
window.previewContent = function(){
	// Open the preview window for content
	openRemoteModal(
		getPreviewSelectorURL(),
		{
			content      	: getEditorContent(),
			layout       	: $( "#layout" ).val(),
			title        	: $( "#title" ).val(),
			slug         	: $slug.val(),
			contentType  	: $( "#contentType" ).val(),
			markup       	: $( "#markup" ).val(),
			parentContent	: $( "#parentContent" ).val() || ""
		},
		$( window ).width() - 50,
		$( window ).height() - 200,
		true
	);
}

/**
 * Set the correct publish date to now
 */
window.publishNow = function(){
	var fullDate = new Date();
	$( "#publishedDate" ).val( getToday() );
	$( "#publishedHour" ).val( fullDate.getHours() );
	$( "#publishedMinute" ).val( fullDate.getMinutes() );
}

/**
 * Switch markup type
 * @param  {string} markupType The markup type
 */
window.switchMarkup = function( markupType ){
	$( "#markup" ).val( markupType );
	$( "#markupLabel" ).html( markupType );
}

/**
 * Set that the form was submitted
 */
window.setWasSubmitted = function(){
	$wasSubmitted = true;
}

/**
 * As for leave confirmation if content is dirty
 * @return {string} The confirmation message the browser will ask if set.
 */
window.askLeaveConfirmation = function(){
	if ( checkIsDirty() && !$wasSubmitted ){
   		return "You have unsaved changes.";
   	}
}

/**
 * Check if permalink is unique
 * @param  {string} linkToUse The link to check
 */
window.permalinkUniqueCheck = function( linkToUse ){
	linkToUse = linkToUse || $slug.val();
	linkToUse = $.trim( linkToUse ); //slugify still appends a space at the end of the string, so trim here for check uniqueness
	if ( !linkToUse.length ){ return; }
	// Verify unique
	$.getJSON(
		$cbEditorConfig.slugCheckURL,
		{
			slug        : linkToUse,
			contentID   : $( "#contentID" ).val(),
			contentType : $( "#contentType" ).val()
		},
		function( data ){
			if ( !data.UNIQUE ){
				$( "#slugCheckErrors" )
					.html( "The permalink slug you entered is already in use, please enter another one or modify it." )
					.addClass( "alert alert-danger" );
			} else {
				$( "#slugCheckErrors" )
					.html( "" )
					.removeClass( "alert alert-danger" );
			}
		}
	);
}

/**
 * Create a permalink
 * @param  {string} linkToUse [description]
 */
window.createPermalink = function( linkToUse ){
	var $title 		= $targetEditorForm.find( "#title" );
	var linkToUse 	= linkToUse || $title.val();
	if ( !linkToUse.length ){ return; }

	togglePermalink();

	$.get(
		$cbEditorConfig.slugifyURL,
		{ slug: linkToUse },
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
window.togglePermalink = function(){
	var toggle = $( "#togglePermalink" );
	// Toggle lock icon on click..
	toggle.hasClass( "fa fa-lock" ) ? toggle.attr( "class", "fa fa-unlock" ) : toggle.attr( "class", "fa fa-lock" );
	//disable input field
	$slug.prop( "disabled", !$slug.prop( "disabled" ) );
}

/**
 * Toggle draft mode or not
 * @return {boolean} Returns an indicator if we should publish or not
 */
window.toggleDraft = function(){
	// Confirm if you really want to quick save if content is published already
	if ( !shouldPublish() ){
		return false;
	}
	// set published bit to false
	$isPublished.val( "false" );
	// record we are submitting
	setWasSubmitted();
	return true;
}

/**
 * Quick publish
 *
 * @param  {Boolean} isDraft draft mode or publish
 */
window.quickPublish = function( isDraft ){
	if ( isDraft ){
		// verify we can draft this content
		if ( !toggleDraft() ){
			return;
		}
	} else {
		// set published bit
		$isPublished.val( "true" );
		// set was submitted
		setWasSubmitted();
	}

	// Verify changelogs and open sidebar if closed:
	if ( $cbEditorConfig.changelogMandatory && !isMainSidebarOpen() ){
		toggleSidebar();
	}

	// submit form
	$targetEditorForm.submit();
}

/**
 * Toggle the loader bar visibility
 */
window.toggleLoaderBar = function(){
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
window.featuredImageCallback = function( filePath, fileURL, fileType ){
	if ( $( "#featuredImage" ).val().length ){ cancelFeaturedImage(); }
	$( "#featuredImageControls" ).toggleClass( "hide" );
	$( "#featuredImage" ).val( filePath );
	$( "#featuredImageURL" ).val( fileURL );
	$( "#featuredImagePreview" ).attr( "src", fileURL );
	closeRemoteModal();
}

/**
 * Cancel featured image
 */
window.cancelFeaturedImage = function(){
	$( "#featuredImage" ).val( "" );
	$( "#featuredImageURL" ).val( "" );
	$( "#featuredImagePreview" ).attr( "src", "" );
	$( "#featuredImageControls" ).toggleClass( "hide" );
}

window.onContentTemplateChange = function( e ){
	let templateId = e.target.value;
	if( !templateId || templateId == 'null' ) return;
	// TODO: Replace this with a more elegant promise-based confirmation
	if( confirm( "Changing the content template may add new custom fields and change values of this content item. Are you sure you want to do this?" ) ){
		return applyContentTemplate( templateId, true );
	}
}

window.applyContentTemplate = function( templateId ){
	fetch(
		`/cbapi/v1/content-templates/${templateId}`,
		{
			headers : {
				"Authorization" : `Bearer ${window.authentication.access_token}`
			}
		}
	).then( r => r.json() )
	.then( response => Object.keys( response.definition ).forEach( key => applyContentTemplateToField( key, response.definition ) ) )
	.catch( error => {
		this.globalAlert.type = "danger";
		this.globalAlert.message = error.toString();
		console.log( error );
	} );
}

window.announceModifiedByTemplate = function(){
	if( !window.alerts.some( alert => alert.type == 'template' ) ){
		window.alerts.push(
			{
				"type" : "template",
				"class" : "warning",
				"message" : "This content item has been modified by changes to the assigned template. You will need to re-save or re-publish this item for the template changes to take effect."
			}
		);
	}
}

window.applyContentTemplateToField = function( fieldName, definition ){
	var template = getContentTemplate();
	if( definition.hasOwnProperty( fieldName ) ){
		switch( fieldName ){
			case "customFields":{
				definition.customFields.forEach(
					fieldDefinition => {
						let isApplied = document.getElementsByClassName( 'customFieldKey' ).some( el => el.value == fieldDefinition.name );
						var $templateNode;
						if( !isApplied ){
							$( "#addCustomFieldButton" ).click();
							setTimeout( () => {
								$templateNode = $( ".template", "#customFields" ).last();
								$( "input.customFieldKey", $templateNode ).val( fieldDefinition.name );
								if( fieldDefinition.defaultValue ){
									$( "input.customFieldKey", $templateNode ).val( fieldDefinition.defaultValue )
								}
								announceModifiedByTemplate();
							}, 100);
						} else {
							$templateNode = $( `input.customFieldKey[value='${fieldDefinition.name}']` ).closest( ".template" );
							let $valueInput = $( "input.customFieldValue", $templateNode );
							if( !$valueInput.val() && fieldDefinition.defaultValue ){
								$valueInput.val( fieldDefinition.defaultValue );
								announceModifiedByTemplate();
							}
						}
						$templateNode.addClass( "template-required" );
						$( ".dynamicRemove", $templateNode )
							.attr( "disabled", true )
							.tooltip( "This custom field may not be removed as it is part of the template definition" );
					}
				);
				break;
			}
			default : {
				var $templateField = $( `[name=${fieldName}]` );
				if( $templateField.length ){
					let nodeType = templateField[ 0 ].nodeType;
					switch( nodeType ){
						case "radio":
						case "checkbox":{
							$templateField.each(
								$check => {
									if(
										$check.prop( "value" ) == definition[ fieldName ].value
										&&
										!$check.prop( "checked" )
									){
										$check.click();
										announceModifiedByTemplate();
									}
								}
							)
						}
						default:{
							if( $templateField.hasAttr( "multiple" ) ){
								$templateField.find( "option" ).each(
									$option => {
										$values = Array.isArray( definition[ fieldName ].value )
													? definition[ fieldName ].value
													: definition[ fieldName ].value.split( ',' );
										if(
											$values.indexOf( $option[ 0 ].value ) > -1
											&&
											!$option.hasAttr( "selected" )
										){
											$option.attr( "selected", true );
											announceModifiedByTemplate();
										}
									}
								);
							} else if( !$templateField.val() && definition[ fieldName ].value ) {
								$templateField.val( definition[ fieldName ].value );
								announceModifiedByTemplate();
							}

						}
					}
				} else {
					console.error( `A field matching the name of ${fieldName} could not be found in the rendered editor. This template field cannot be validated or applied.` );
				}

			}
		}
	}
}