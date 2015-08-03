/*
 Copyright (c) 2003-2012, CKSource - Frederico Knabben. All rights reserved.
 For licensing, see LICENSE.html or http://ckeditor.com/license
 */
// Default style
if (typeof(CKEDITOR.config.insertpre_style) == 'undefined')
	CKEDITOR.config.insertpre_style = 'background-color:#C6E1FF;border:1px solid #DDD;padding:10px;';
var format=function( code ) {
	code=code.replace(/<br>/g,"\n" );
	code=code.replace(/&amp;/g,"&" );
	code=code.replace(/&lt;/g,"<" );
	code=code.replace(/&gt;/g,">" );
	code=code.replace(/&quot;/g,'"');
    code=code.replace(/&nbsp;/g,' ');
	return code;
};
CKEDITOR.plugins.add( 'insertpre',
	{
		requires: 'dialog',
		lang : 'en,pl', // %REMOVE_LINE_CORE%
		icons: 'insertpre', // %REMOVE_LINE_CORE%
		onLoad : function()
		{
			CKEDITOR.addCss( 'pre{' + CKEDITOR.config.insertpre_style + '}' );
		},
		init : function( editor )
		{
			// Double click handler
			editor.on( 'doubleclick', function( evt )
			{
				// get editor selection and first element from selection
				var thisSelection = editor.getSelection(),
					element = thisSelection.getStartElement();
				// verify the element exists
				if ( element ){
					// element exists so get to the closes pre selection
					element = element.getAscendant( 'pre', true );
				}
				// No element or not a pre
				if ( element && element.getName() == 'pre' )
				{
					evt.data.dialog = 'insertpre';
			        editor.getSelection().selectElement( element );
				}
			} );
			
			// Register insertpre dialog command
			editor.addCommand( 'insertpre', new CKEDITOR.dialogCommand( 'insertpre' ) );
			// Add UI button
			editor.ui.addButton( 'InsertPre', {
					label : editor.lang.insertpre.title,
					icon : this.path + 'icons/insertpre-color.png',
					command : 'insertpre',
					toolbar: 'insert,99'
				} );
			
			// Context Menu for editing code
			if ( editor.contextMenu )
			{
				editor.addMenuGroup( 'code' );
				editor.addMenuItem( 'insertpre',
					{
						label : editor.lang.insertpre.edit,
						icon : this.path + 'icons/insertpre-color.png',
						command : 'insertpre',
						group : 'code'
					} );
				editor.contextMenu.addListener( function( element )
				{
					if ( element )
						element = element.getAscendant( 'pre', true );
					if ( element && !element.isReadOnly() )
						return { insertpre : CKEDITOR.TRISTATE_OFF };
					return null;
				} );
			}
			
			// Dialog window
			CKEDITOR.dialog.add( 'insertpre', function( editor )
			{
				return {
					title : editor.lang.insertpre.title,
					minWidth : 540,
					minHeight : 400,
					contents : [
						{
							id : 'general',
							label : editor.lang.insertpre.code,
							elements : [
								{
									type : 'textarea',
									id : 'contents',
									label : editor.lang.insertpre.code,
									cols: 140,
									rows: 22,
									validate : CKEDITOR.dialog.validate.notEmpty( editor.lang.insertpre.notEmpty ),
									required : true,
									setup : function( element )
									{
										var html = element.getHtml();
										// If there is loaded HTML already then... do some div stuff, not sure why.
										if ( html )
										{
											this.setValue( format( html ) );
										}
									},
									commit : function( element )
									{
										element.setHtml( CKEDITOR.tools.htmlEncode( this.getValue() ) );
									}
								}// end textarea,
								// code class
								,{
									type : 'text',
									id : 'contentclass',
									label : editor.lang.insertpre.codeclass,
									required : false,
									setup : function( element ){
										this.setValue( element.getAttribute( "class" ) ? $.trim( element.getAttribute( "class" ) ) : '' );
									},
									commit : function( element )
									{
										if( this.getValue().length ){
											element.setAttribute( 'class', $.trim( this.getValue() ) );
										}
										else{
											element.setAttribute( 'class', '');
										}
										
									}
								}// end class element
								
							]
						}
					], // end contents of dialog window
					// Fires when dialog shows.
					onShow : function()
					{
						// get editor selection and first element from selection
						var thisSelection = editor.getSelection(),
							element = thisSelection.getStartElement();
						// verify the element exists
						if ( element ){
							// element exists so get to the closes pre selection
							element = element.getAscendant( 'pre', true );
						}
						// No element or not a pre
						if ( !element || element.getName() != 'pre' )
						{
							element = editor.document.createElement( 'pre' );
							this.insertMode = true;
						}
						// we are in edit mode
						else{
							this.insertMode = false;
						}
						// store it so its available in the onOk function
						this.element = element;
						// setup the elements
						this.setupContent( this.element );
					},
					onOk : function()
					{
						var dialog = this,
							pre = this.element;
						// commit the content
						this.commitContent( pre );
						// Insert element if in create mode only
						if( this.insertMode ){
							editor.insertElement( pre );
						}
						
					}
				};
			} );
		}
	} );