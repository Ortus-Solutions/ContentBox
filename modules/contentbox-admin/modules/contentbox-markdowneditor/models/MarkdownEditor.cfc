/**
* ContentBox - A Modular Content Platform
* Copyright since 2012 by Ortus Solutions, Corp
* www.ortussolutions.com/products/contentbox
* ---
* SimpleMDE Implementation
*/
component implements="contentbox.models.ui.editors.IEditor" accessors="true" singleton{

	// DI
	property name="log" inject="logbox:logger:{this}";

	/**
	* The static JSON for our default toolbar
	*/
	property name="TOOLBAR_JSON";

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
		EDITOR_ROOT 		= arguments.coldbox.getSetting( "modules" )[ "contentbox-markdowneditor" ].mapping;
		HTML_BASE_URL	 	= variables.requestService.getContext().getHTMLBaseURL();
		// Register our Editor events
		//interceptorService.appendInterceptionPoints( "cbadmin_ckeditorToolbar,cbadmin_ckeditorExtraPlugins,cbadmin_ckeditorExtraConfig" );
		
		return this;
	}

	/**
	* Get the internal name of an editor
	*/
	function getName(){
		return "markdown";
	}
	
	/**
	* Get the display name of an editor
	*/
	function getDisplayName(){
		return "Markdown Editor";
	};
	
	/**
	* Startup the editor(s) on a page
	*/
	function startup(){
		// Now prepare our JavaScript and load it.
		return compileJS();
	}
	
	/**
	* This is fired once editor javascript loads, you can use this to return back functions, asset calls, etc. 
	* return the appropriate JavaScript
	*/
	function loadAssets(){
		var js = "";
		
		// Load Assets, they are included with ContentBox
		html.addAsset( "#variables.EDITOR_ROOT#/includes/simplemde.min.css" );
		html.addAsset( "#variables.EDITOR_ROOT#/includes/simplemde.min.js" );
		// Custom Styles
		html.addStyleContent( "
			.CodeMirror{
			    height: 400px;
			}
			.CodeMirror-fullscreen{
				z-index: 9999 !important;
			}
			div.fullscreen{
				z-index: 9999 !important;
			}
		", true );

		savecontent variable="js"{
			writeOutput( "
			function checkIsDirty(){
				return simpleMDE_content.isDirty;
			}
			function getEditorContent(){
				return simpleMDE_content.value();
			}
			function getEditorExcerpt(){
				return simpleMDE_excerpt.value();
			}
			function updateEditorContent(){
			}
			function updateEditorExcerpt(){
			}
			function insertEditorContent( editorName, content ){
				var cm 	= simpleMDE_content.codemirror;
				if( editorName.indexOf( 'content' ) >= 0 ){
					cm.replaceRange( content, { line: cm.lastLine() } );
				} else {
					simpleMDE_excerpt.codemirror.replaceRange( content, { line: simpleMDE_excerpt.codemirror.lastLine() } );
				}
			}
			" );
		}
		
		return js;
	};
	
	/**
	* Compile the needed JS to display into the screen
	*/
	private function compileJS(){
		var js 					= "";
		var event 				= requestService.getContext();
		var cbAdminEntryPoint 	= event.getValue( name="cbAdminEntryPoint", private=true );
		
		// CK Editor Integration Handlers
		var xehCKFileBrowserURL			= "#cbAdminEntryPoint#/ckfilebrowser/";
		var xehCKFileBrowserURLImage	= "#cbAdminEntryPoint#/ckfilebrowser/";
		var xehCKFileBrowserURLFlash	= "#cbAdminEntryPoint#/ckfilebrowser/";
		
		/**
		 We build the compiled JS with the knowledge of some inline variables we have context to
		 $excerpt - The excerpt jquery object
		 $content - The content jquery object
		 withExcerpt - an argument telling us if an excerpt is available to render or not
		*/
		
		savecontent variable="js"{
			writeOutput( "
			
			// Insert Widgets
			$insertCBWidget = function( editor ){
				// Open the selector widget dialog.
    			openRemoteModal( 
                    getWidgetSelectorURL(), 
                    { editorName : editor }, 
                    $( window ).width() - 200,
                    $( window ).height() - 300,
                    true 
                );
			};

			// Insert ContentStore
			$insertCBContentStore = function( editor ){
				// Open the selector widget dialog.
    			openRemoteModal( getContentStoreSelectorURL(), { editorName: editor } );
			};

			// Insert Entry Link
			$insertCBEntryLink = function( editor ){
				// Open the selector widget dialog.
    			openRemoteModal( getEntrySelectorURL(), { editorName: editor } );
			};

			// Insert Page Link
			$insertCBPageLink = function( editor ){
				// Open the selector widget dialog.
    			openRemoteModal( getPageSelectorURL(), { editorName: editor } );
			};

			// Insert Media
			$insertCBMedia = function( editor ){
				simpleMDETargetEditor = editor;
				openRemoteModal(
					'/cbadmin/ckFileBrowser/assetChooser?callback=$insertCBMediaContent',
					{},
					'75%'
				);
			};
			// Choose Media
			$insertCBMediaContent = function( sPath, sURL, sType ){
				if( !sPath.length || sType === 'dir' ){ 
			        alert( 'Please select a file first.' ); 
			        return; 
			    }
				var link = '![' + sURL.substr( sURL.lastIndexOf( '/' ) + 1 ) + ']('+ sURL + ')';
				insertEditorContent( simpleMDETargetEditor, link );
				closeRemoteModal();
			}

			// Activate on content object
			simpleMDE_content = new SimpleMDE( { 
				element 		: $content[ 0 ],
				autosave 		: { enabled : false },
				promptURLs 		: true,
				tabSize 		: 4,
				forceSync 		: true,
				placeholder 	: 'Type here...',
				spellChecker 	: false,
				toolbar 		: [ 
					'bold', 'italic', 'strikethrough', 'heading', 'heading-smaller', 'heading-bigger', '|', 
					'code', 'quote', 'unordered-list', 'ordered-list', '|', 
					'link', 'image', 'table', 'horizontal-rule', '|',
					'preview', 'side-by-side', 'fullscreen', 'guide', '|',
					{
						name : 'cbWidget',
						action : function(){ $insertCBWidget( 'content' ); },
						className : 'fa fa-magic',
						title : 'Insert a ContentBox Widget'
					},
					{
						name : 'cbContentStore',
						action : function(){ $insertCBContentStore( 'content' ); },
						className : 'fa fa-hdd-o',
						title : 'Insert ContentBox Content Store Item'
					},
					{
						name : 'cbEntryLink',
						action : function(){ $insertCBEntryLink( 'content' ); },
						className : 'fa fa-quote-left',
						title : 'Insert ContentBox Entry Link'
					},
					{
						name : 'cbPageLink',
						action : function(){ $insertCBPageLink( 'content' ); },
						className : 'fa fa-file-o',
						title : 'Insert ContentBox Page Link'
					},
					{
						name : 'cbMediaManager',
						action : function(){ $insertCBMedia( 'content' ); },
						className : 'fa fa-database',
						title : 'Insert ContentBox Media'
					}
				]
			} );

			// Active Excerpts
			if( withExcerpt ){
				// Activate on content object
				simpleMDE_excerpt = new SimpleMDE( { 
					element  		: $excerpt[ 0 ],
					autosave  		: { enabled : false },
					promptURLs  	: true,
					tabSize  		: 4,
					forceSync  		: true,
					placeholder 	: 'Type here...',
					spellChecker  	: false,
					toolbar  		: [ 
						'bold', 'italic', 'strikethrough', 'heading', 'heading-smaller', 'heading-bigger', '|', 
						'code', 'quote', 'unordered-list', 'ordered-list', '|', 
						'link', 'image', 'table', 'horizontal-rule', '|',
						'preview', 'side-by-side', 'fullscreen', 'guide', '|',
						{
							name : 'cbWidget',
							action : function(){ $insertCBWidget( 'excerpt' ); },
							className : 'fa fa-magic',
							title : 'Insert a ContentBox Widget'
						},
						{
							name : 'cbContentStore',
							action : function(){ $insertCBContentStore( 'excerpt' ); },
							className : 'fa fa-hdd-o',
							title : 'Insert ContentBox Content Store Item'
						},
						{
							name : 'cbEntryLink',
							action : function(){ $insertCBEntryLink( 'excerpt' ); },
							className : 'fa fa-quote-left',
							title : 'Insert ContentBox Entry Link'
						},
						{
							name : 'cbPageLink',
							action : function(){ $insertCBPageLink( 'excerpt' ); },
							className : 'fa fa-file-o',
							title : 'Insert ContentBox Page Link'
						},
						{
							name : 'cbMediaManager',
							action : function(){ $insertCBMedia( 'excerpt' ); },
							className : 'fa fa-database',
							title : 'Insert ContentBox Media'
						}
					]
				} );
			}
			simpleMDETargetEditor = '';
			simpleMDE_content.isDirty = false;
			simpleMDE_content.codemirror.on( 'change', function(){
			    simpleMDE_content.isDirty = true;
			} );
			" );
		}
		
		return js;
	}

	/**
	* Shutdown the editor(s) on a page
	*/
	function shutdown(){
		var js = "";
		savecontent variable="js"{
			writeOutput( "
			// Activate on content object
			simpleMDE_content.toTextArea();
			simpleMDE_content = null;

			// Active Excerpts
			if( withExcerpt ){
				simpleMDE_excerpt.toTextArea();
				simpleMDE_excerpt = null;
			}
			" );
		}
		
		return js;
	}

} 