/**
* ContentBox - A Modular Content Platform
* Copyright since 2012 by Ortus Solutions, Corp
* www.ortussolutions.com/products/contentbox
* ---
* CKEditor Implementation
*/
component implements="contentbox.models.ui.editors.IEditor" accessors="true" singleton{

	// DI
	property name="log" inject="logbox:logger:{this}";

	/**
	* The static JSON for our default toolbar
	*/
	property name="TOOLBAR_JSON";

	/**
	* The extra plugins we have created for CKEditor
	*/
	property name="extraPlugins";
	
	/**
	* Constructor
	* @coldbox.inject coldbox
	* @settingService.inject settingService@cb
	* @html.inject HTMLHelper@coldbox
	*/
	function init( 
		required coldbox, 
		required settingService,
		required html
	){
		
		// register dependencies
		variables.interceptorService = arguments.coldbox.getInterceptorService();
		variables.requestService	 = arguments.coldbox.getRequestService();
		variables.coldbox 			 = arguments.coldbox;
		variables.settingService	 = arguments.settingService;
		variables.html 				 = arguments.html;
		
		// Store admin entry point and base URL settings
		ADMIN_ENTRYPOINT 	= arguments.coldbox.getSetting( "modules" )[ "contentbox-admin" ].entryPoint;
		ADMIN_ROOT 			= arguments.coldbox.getSetting( "modules" )[ "contentbox-admin" ].mapping;
		CKEDITOR_ROOT 		= arguments.coldbox.getSetting( "modules" )[ "contentbox-ckeditor" ].mapping;
		HTML_BASE_URL	 	= variables.requestService.getContext().getHTMLBaseURL();
		
		return this;
	}

	/**
	* Get the internal name of an editor
	*/
	function getName(){
		return "ckeditor";
	}
	
	/**
	* Get the display name of an editor
	*/
	function getDisplayName(){
		return "CKEditor";
	};
	
	/**
	* Startup the editor(s) on a page
	*/
	function startup(){
		// prepare toolbar announcement on startup
		var iData = { 
			toolbar 		= deserializeJSON( settingService.getSetting( "cb_editors_ckeditor_toolbar" ) ), 
			excerptToolbar 	= deserializeJSON( settingService.getSetting( "cb_editors_ckeditor_excerpt_toolbar" ) )
		};
		// Announce the editor toolbar is about to be processed
		interceptorService.processState( "cbadmin_ckeditorToolbar", iData);
		// Load extra plugins according to our version
		var iData2 = { extraPlugins = listToArray( settingService.getSetting( "cb_editors_ckeditor_extraplugins" ) ) };
		// Announce extra plugins to see if user implements more.
		interceptorService.processState( "cbadmin_ckeditorExtraPlugins", iData2);
		// Load extra configuration
		var iData3 = { extraConfig = "" };
		// Announce extra configuration
		interceptorService.processState( "cbadmin_ckeditorExtraConfig", iData3);
		// Now prepare our JavaScript and load it. No need to send assets to the head as CKEditor comes pre-bundled
		return compileJS( iData, iData2, iData3 );
	}
	
	/**
	* This is fired once editor javascript loads, you can use this to return back functions, asset calls, etc. 
	* return the appropriate JavaScript
	*/
	function loadAssets(){
		var js = "";
		
		// Load Assets, they are included with ContentBox
		html.addAsset( "#variables.CKEDITOR_ROOT#/includes/ckeditor/ckeditor.js" );
		html.addAsset( "#variables.CKEDITOR_ROOT#/includes/ckeditor/adapters/jquery.js" );

		savecontent variable="js"{
			writeOutput( "
			function getContentEditor(){
				return $content.ckeditorGet();
			}
			function getExcerptEditor(){
				return $excerpt.ckeditorGet();
			}
			function checkIsDirty(){
				return $content.ckeditorGet().checkDirty();
			}
			function getEditorContent(){
				return $content.ckeditorGet().getData();
			}
			function getEditorExcerpt(){
				return $excerpt.ckeditorGet().getData();
			}
			function updateEditorContent(){
				CKEDITOR.instances.content.updateElement();
			}
			function updateEditorExcerpt(){
				CKEDITOR.instances.excerpt.updateElement();
			}
			function setEditorContent( editorName, content ){
				$( '##' + editorName ).ckeditorGet().setData( content );
			}
			function insertEditorContent( editorName, content ){
				// if simple value, insert as html
				if( jQuery.type( content ) == 'string' )
					$( '##' + editorName ).ckeditorGet().insertHtml( content );
				// else insert as element
				else
					$( '##' + editorName ).ckeditorGet().insertElement( content );
			}
			" );
		}
		
		return js;
	};
	
	/**
	* Compile the needed JS to display into the screen
	*/
	private function compileJS( required iData, required iData2, required iData3 ){
		var js 					= "";
		var event 				= requestService.getContext();
		var cbAdminEntryPoint 	= event.getValue( name="cbAdminEntryPoint", private=true );
		
		// CK Editor Integration Handlers
		var xehCKFileBrowserURL			= "#cbAdminEntryPoint#/ckfilebrowser/";
		var xehCKFileBrowserURLImage	= "#cbAdminEntryPoint#/ckfilebrowser/";
		var xehCKFileBrowserURLFlash	= "#cbAdminEntryPoint#/ckfilebrowser/";
		
		// Determine Extra Plugins code
		var extraPlugins = "";
		if( arrayLen( arguments.iData2.extraPlugins ) ){
			extraPlugins = "extraPlugins : '#arrayToList( arguments.iData2.extraPlugins )#',";
		}
		// Determin Extra Configuration
		var extraConfig = "";
		if( len( arguments.iData3.extraConfig ) ){
			extraConfig = "#arguments.iData3.extraConfig#,";
		}
		
		/**
		 We build the compiled JS with the knowledge of some inline variables we have context to
		 $excerpt - The excerpt jquery object
		 $content - The content jquery object
		 $withExcerpt - an argument telling us if an excerpt is available to render or not
		*/
		
		savecontent variable="js"{
			writeOutput( "
			// toolbar Configuration
			var ckToolbar = $.parseJSON( '#serializeJSON( arguments.iData.toolbar )#' );
			var ckExcerptToolbar = $.parseJSON( '#serializeJSON( arguments.iData.excerptToolbar )#' );
			
			// Activate ckeditor on content object
			$content.ckeditor( function(){}, {
					#extraPlugins#
					#extraConfig#
					toolbar: ckToolbar,
					toolbarCanCollapse: true,
					height:400,
					filebrowserBrowseUrl : '#event.buildLink( xehCKFileBrowserURL )#',
					filebrowserImageBrowseUrl : '#event.buildLink( xehCKFileBrowserURLIMage )#',
					filebrowserFlashBrowseUrl : '#event.buildLink( xehCKFileBrowserURLFlash )#',
					baseHref : '#HTML_BASE_URL#/'
				} );
				
			// Active Excerpts
			if( $withExcerpt ){
				$excerpt.ckeditor(function(){}, {
					#extraConfig#
					toolbar: ckExcerptToolbar,
					toolbarCanCollapse: true,
					height: 200,
					filebrowserBrowseUrl: '#event.buildLink( xehCKFileBrowserURL )#',
					baseHref: '#HTML_BASE_URL#/'
				} );
			}
			" );
		}
		
		return js;
	}

	/**
	* Shutdown the editor(s) on a page
	*/
	function shutdown(){
		
	}

} 