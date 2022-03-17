/**
 * ContentBox - A Modular Content Platform
 * Copyright since 2012 by Ortus Solutions, Corp
 * www.ortussolutions.com/products/contentbox
 * ---
 * SimpleMDE Implementation
 */
component
	implements="contentbox.models.ui.editors.IEditor"
	accessors ="true"
	singleton
{

	// DI
	property name="log" inject="logbox:logger:{this}";

	/**
	 * Constructor
	 *
	 * @coldbox.inject        coldbox
	 * @settingService.inject settingService@contentbox
	 * @html.inject           HTMLHelper@coldbox
	 */
	function init(
		required coldbox,
		required settingService,
		required html
	){
		// register dependencies
		variables.interceptorService = arguments.coldbox.getInterceptorService();
		variables.requestService     = arguments.coldbox.getRequestService();
		variables.coldbox            = arguments.coldbox;
		variables.settingService     = arguments.settingService;
		variables.html               = arguments.html;

		// Store admin entry point and base URL settings
		ADMIN_ENTRYPOINT = arguments.coldbox.getSetting( "modules" )[ "contentbox-admin" ].entryPoint;
		EDITOR_ROOT      = arguments.coldbox.getSetting( "modules" )[ "contentbox-markdowneditor" ].mapping;
		HTML_BASE_URL    = variables.requestService.getContext().getHTMLBaseURL();

		// Store Toolbars
		variables.toolbarJS        = buildToolbarJS( "content" );
		variables.toolbarExcerptJS = buildToolbarJS( "excerpt" );

		// Register our Editor events
		interceptorService.appendInterceptionPoints( "cbadmin_mdEditorToolbar,cbadmin_mdEditorExtraConfig" );

		return this;
	}

	/**
	 * Get the internal name of an editor
	 */
	function getName(){
		return "simplemde";
	}

	/**
	 * Get the display name of an editor
	 */
	function getDisplayName(){
		return "Code Editor";
	};

	/**
	 * Startup the editor(s) on a page
	 */
	function startup(){
		// prepare toolbar announcement on startup
		var iData = {
			toolbar        : variables.toolbarJS,
			excerptToolbar : variables.toolbarExcerptJS
		};
		// Announce the editor toolbar is about to be processed
		interceptorService.announce( "cbadmin_mdEditorToolbar", iData );
		// Load extra configuration
		var iData2 = { extraConfig : "" };
		// Announce extra configuration
		interceptorService.announce( "cbadmin_mdEditorExtraConfig", iData2 );
		// Now prepare our JavaScript and load it.
		return compileJS( iData, iData2 );
	}

	/**
	 * This is fired once editor javascript loads, you can use this to return back functions, asset calls, etc.
	 * return the appropriate JavaScript
	 */
	function loadAssets(){
		var js = "";

		// Load Assets, they are included with ContentBox
		html.addAsset( "#variables.EDITOR_ROOT#/includes/simplemde/simplemde.min.css" );
		html.addAsset( "#variables.EDITOR_ROOT#/includes/simplemde/simplemde.min.js" );
		// Custom Styles
		// cfformat-ignore-start
		html.addStyleContent(
			"
			.CodeMirror{
			    height: 400px;
			}
			.CodeMirror-fullscreen{
				z-index: 1000 !important;
			}
			div.fullscreen{
				z-index: 1000 !important;
			}
		",
			true
		);

		savecontent variable="js" {
			writeOutput( "
			function getContentEditor(){
				return simpleMDE_content.codemirror;
			}
			function getExcerptEditor(){
				return simpleMDE_excerpt.codemirror;
			}
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
			function setEditorContent( editorName, content ){
				if( editorName.indexOf( 'content' ) >= 0 ){
					simpleMDE_content.value( content );
				} else {
					simpleMDE_excerpt.value( content );
				}
			}
			function insertEditorContent( editorName, content ){
				if( editorName.indexOf( 'content' ) >= 0 ){
					simpleMDE_content.codemirror.replaceRange( content, simpleMDE_content.codemirror.getCursor() );
				} else {
					simpleMDE_excerpt.codemirror.replaceRange( content, simpleMDE_excerpt.codemirror.getCursor() );
				}
			}

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
				loadAssetChooser( '$insertCBMediaContent' );
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
			");
		}
		// cfformat-ignore-end

		return js;
	};

	/**
	 * Compile the needed JS to display into the screen
	 */
	private function compileJS( required iData, required iData2 ){
		var js = "";

		// Determine Extra Configuration
		var extraConfig = "";
		if ( len( arguments.iData2.extraConfig ) ) {
			extraConfig = "#arguments.iData2.extraConfig#,";
		}

		// cfformat-ignore-start
		savecontent variable="js" {
			writeOutput( "
			// Activate on content object
			simpleMDE_content = new SimpleMDE( {
				#extraConfig#
				element 		: document.getElementById( 'content' ),
				autosave 		: { enabled : false },
				promptURLs 		: true,
				tabSize 		: 4,
				forceSync 		: true,
				placeholder 	: 'Type here...',
				spellChecker 	: false,
				toolbar 		: #arguments.iData.toolbar#
			} );

			// Active Excerpts
			if( $withExcerpt ){
				// Activate on content object
				simpleMDE_excerpt = new SimpleMDE( {
					#extraConfig#
					element  		: document.getElementById( 'excerpt' ),
					autosave  		: { enabled : false },
					promptURLs  	: true,
					tabSize  		: 4,
					forceSync  		: true,
					placeholder 	: 'Type here...',
					spellChecker  	: false,
					toolbar 		: #arguments.iData.excerptToolbar#
				} );
			};

			// Global Configuration Variables
			simpleMDETargetEditor = '';
			simpleMDE_content.isDirty = false;

			// Listen for Editor Changes
			simpleMDE_content.codemirror.on( 'change', function(){
			    simpleMDE_content.isDirty = true;
			} );
			" );
		}
		// cfformat-ignore-end

		return js;
	}

	/**
	 * Shutdown the editor(s) on a page
	 */
	function shutdown(){
		var js = "";

		// cfformat-ignore-start
		savecontent variable="js" {
			writeOutput( "
				// Activate on content object
				simpleMDE_content.toTextArea();
				simpleMDE_content = null;
				// Active Excerpts
				try{
					simpleMDE_excerpt.toTextArea();
					simpleMDE_excerpt = null;
				} catch( error ){
					// ignore.
				}
			");
		}
		// cfformat-ignore-end

		return js;
	}

	/**
	 * Build the toolbar JS according to editor name
	 *
	 * @editor The editor name to bind the toolbar to
	 */
	private function buildToolbarJS( required editor ){
		// cfformat-ignore-start
		return "[
			{
				name : 'cbSave',
				action : function(){ quickSave(); },
				className : 'far fa-save',
				title : 'ContentBox Quick Save'
			},
			{
				name : 'cbUndo',
				action : function(){ simpleMDE_#arguments.editor#.undo(); },
				className : 'fa fa-undo',
				title : 'Undo'
			},
			{
				name : 'cbRedo',
				action : function(){ simpleMDE_#arguments.editor#.redo(); },
				className : 'fa fa-repeat',
				title : 'Redo'
			},
			'|',
			'bold', 'italic', 'strikethrough', 'heading', 'heading-smaller', 'heading-bigger', '|',
			'code', 'quote', 'unordered-list', 'ordered-list', '|',
			'link', 'image', 'table', 'horizontal-rule', '|',
			'preview', 'side-by-side', 'fullscreen',
			{
				name : 'cbLivePreview',
				action : function(){ previewContent(); },
				className : 'fa fa-bolt',
				title : 'ContentBox Responsive Preview'
			},
			'|',
			{
				name : 'cbWidget',
				action : function(){ $insertCBWidget( '#arguments.editor#' ); },
				className : 'fa fa-magic',
				title : 'Insert a ContentBox Widget'
			},
			{
				name : 'cbContentStore',
				action : function(){ $insertCBContentStore( '#arguments.editor#' ); },
				className : 'far fa-hdd',
				title : 'Insert ContentBox Content Store Item'
			},
			{
				name : 'cbEntryLink',
				action : function(){ $insertCBEntryLink( '#arguments.editor#' ); },
				className : 'fas fa-blog',
				title : 'Insert ContentBox Entry Link'
			},
			{
				name : 'cbPageLink',
				action : function(){ $insertCBPageLink( '#arguments.editor#' ); },
				className : 'fa fa-file-o',
				title : 'Insert ContentBox Page Link'
			},
			{
				name : 'cbMediaManager',
				action : function(){ $insertCBMedia( '#arguments.editor#' ); },
				className : 'fa fa-database',
				title : 'Insert ContentBox Media'
			}
		]";
		// cfformat-ignore-end
	}

}
