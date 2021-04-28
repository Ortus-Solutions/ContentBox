/**
 * ContentBox - A Modular Content Platform
 * Copyright since 2012 by Ortus Solutions, Corp
 * www.ortussolutions.com/products/contentbox
 * ---
 * A cool basic commenting form for ContentBox
 */
component extends="contentbox.models.ui.BaseWidget" singleton {

	// DI
	property name="messagebox" inject="messagebox@cbmessagebox";

	/**
	 * Constructor
	 */
	CommentForm function init(){
		// Widget Properties
		setName( "CommentForm" );
		setDescription( "A cool basic commenting form for ContentBox content objects." );
		setAuthor( "Ortus Solutions" );
		setAuthorURL( "https://www.ortussolutions.com" );
		setIcon( "commenting" );
		setCategory( "Miscellaneous" );
		return this;
	}

	/**
	 * The main commenting form widget
	 *
	 * @content The content object to build the comment form or a content slug to load. If empty, we will take the content object from the prc scopes.
	 */
	any function renderIt( any content ){
		var event          = getRequestContext();
		var prc            = event.getPrivateCollection();
		var cbSettings     = event.getPrivateValue( "cbSettings" );
		var commentForm    = "";
		var oCurrentAuthor = variables.securityService.getAuthorSession();

		// Check if content simple value
		if ( isSimpleValue( arguments.content ) and len( arguments.content ) ) {
			var originalSlug = arguments.content;

			arguments.content = variables.contentService.findBySlug(
				slug  : arguments.content,
				siteID: variables.cb.site().getsiteID()
			);

			if ( !arguments.content.isLoaded() ) {
				return "The content slug: #originalSlug# was not found, cannot generate comment form.";
			}
		}

		// Is it null or still a string?
		if ( isNull( arguments.content ) || isSimpleValue( arguments.content ) ) {
			// Check if we are in a page or entry
			if ( structKeyExists( prc, "entry" ) ) {
				arguments.content = prc.entry;
			} else if ( structKeyExists( prc, "page" ) ) {
				arguments.content = prc.page;
			} else {
				// Default to empty page
				arguments.content = pageService.new();
			}
		}

		// generate comment form
		saveContent variable="commentForm" {
			writeOutput(
				"
			#html.startForm(
					name = "commentForm",
					action = cb.linkCommentPost( arguments.content ),
					novalidate = "novalidate"
				)#

				#cb.event( "cbui_preCommentForm" )#

				#variables.messagebox.renderit()#

				#html.hiddenField( name = "contentID", value = arguments.content.getContentID() )#
				#html.hiddenField( name = "contentType", value = arguments.content.getContentType() )#

				#html.textField(
					name = "author",
					label = "Name: (required)",
					size = "50",
					class = "form-control",
					groupWrapper = "div class=form-group",
					required = "required",
					value = event.getValue( "author", oCurrentauthor.getFullName() )
				)#

				#html.inputField(
					name = "authorEmail",
					type = "email",
					label = "Email: (required)",
					size = "50",
					class = "form-control",
					groupWrapper = "div class=form-group",
					required = "required",
					value = event.getValue( "authorEmail", oCurrentAuthor.getEmail() )
				)#

				#html.inputField(
					name = "authorURL",
					type = "url",
					label = "Website:",
					size = "50",
					class = "form-control",
					groupWrapper = "div class=form-group",
					value = event.getValue( "authorURL", "" )
				)#

				#html.textArea(
					name = "content",
					label = "Comment: (Markdown allowed)",
					class = "form-control",
					required = "required",
					value = event.getValue( "content", "" )
				)#

				#html.checkBox(
					name = "subscribe",
					label = "Notify me of follow-up comments by email.",
					groupwrapper = "div class=checkbox",
					checked = event.getValue( "subscribe", false )
				)#

				#cb.event( "cbui_postCommentForm" )#

<div class=""buttons"">#html.submitButton(
					name = "commentSubmitButton",
					value = "Submit",
					class = "btn btn-primary"
				)#</div>
			#html.endForm()#
			"
			);
		}

		return commentForm;
	}

}
