/**
 * @license Copyright (c) 2003-2012, CKSource - Frederico Knabben. All rights reserved.
 * For licensing, see LICENSE.html or http://ckeditor.com/license
 */
CKEDITOR.editorConfig = function( config ) {
	// Define changes to default configuration here. For example:
	// config.language = 'fr';
	// config.uiColor = '#AADC6E';
	config.extraPlugins 				= 'cbKeyBinding,cbWidgets,cbLinks,cbEntryLinks,cbContentStore,cbIpsumLorem,wsc,mediaembed,insertpre'; 
	config.tabSpaces 					= 4;
	config.enableTabKeyTools 			= true;
	config.entities 					= false;
	config.docType 						= '<!DOCTYPE html>';
	config.disableNativeSpellChecker 	= false;
	config.allowedContent 				= true;
	config.removePlugins 				= 'autogrow';
	// Allow i,a,span empty tags
	config.protectedSource.push( /<(i|span|a) [^>]*><\/(i|span|a)>/g );
	config.protectedSource.push( /<ins[\s|\S]+?<\/ins>/g); // Protects <INS> tags
	// Markdown editor
	config.markdown	= {
		theme : "paraiso-dark"
	};
	//config.protectedSource.push( /<\/(i|span|a)>/g );
	//config.protectedSource.push( /<(i|span|a) *?\>/g );
};