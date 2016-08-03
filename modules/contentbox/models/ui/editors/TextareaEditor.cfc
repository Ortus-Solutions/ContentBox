/**
* ContentBox - A Modular Content Platform
* Copyright since 2012 by Ortus Solutions, Corp
* www.ortussolutions.com/products/contentbox
* ---
* Simple textarea editor
*/
component implements="contentbox.models.ui.editors.IEditor" accessors="true" singleton{

	// DI
	property name="log" inject="logbox:logger:{this}";

	/**
	* Constructor
	*/
	function init(){
		return this;
	}

	/**
	* Get the internal name of an editor
	*/
	function getName(){
		return "textarea";
	}
	
	/**
	* Get the display name of an editor
	*/
	function getDisplayName(){
		return "Textarea";
	};
	
	/**
	* This is fired once editor javascript loads, you can use this to return back functions, asset calls, etc. 
	* return the appropriate JavaScript
	*/
	function loadAssets(){
		var js = "";
		
		savecontent variable="js"{
			writeOutput( "
			function getContentEditor(){
				return $( '##content' )
			}
			function getExcerptEditor(){
				return $( '##excerpt' )
			}
			function checkIsDirty(){
				return false;
			}
			function getEditorContent(){
				return $( '##content' ).val();
			}
			function getEditorExcerpt(){
				return $( '##excerpt' ).val();
			}
			function updateEditorContent(){
				// not needed
			}
			function updateExcerptContent(){
				// not needed
			}
			function setEditorContent( editorName, content ){
				$( '##' + editorName ).val( content );
			}
			function insertEditorContent( editorName, content ){
				// not used yet
				var currentValue = $( '##' + editorName ).val();
				$( '##' + editorName ).val( currentValue + '\n' + content );
			}
			" );
		}
		
		return js;
	};
	
	/**
	* Startup the editor(s) on a page
	*/
	function startup(){
		log.info( getName() & " editor started up." );
	}
	
	/**
	* Shutdown the editor(s) on a page
	*/
	function shutdown(){
		log.info( getName() & " editor shutdown." );
	}

} 