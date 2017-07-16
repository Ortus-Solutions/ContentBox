/**
* ContentBox - A Modular Content Platform
* Copyright since 2012 by Ortus Solutions, Corp
* www.ortussolutions.com/products/contentbox
* ---
* A cool basic commenting form for ContentBox
*/
component extends="contentbox.models.ui.BaseWidget" singleton{

	CommentForm function init(){
		// Widget Properties
		setName( "CommentForm" );
		setVersion( "1.0" );
		setDescription( "A cool basic commenting form for ContentBox content objects." );
		setAuthor( "Ortus Solutions" );
		setAuthorURL( "https://www.ortussolutions.com" );
		setIcon( "commenting" );
		setCategory( "Miscellaneous" );
		return this;
	}

	/**
	* The main commenting form widget
	* @content.hint The content object to build the comment form for: page or entry
	*/
	any function renderIt( any content ){
		var event 			= getRequestContext();
		var cbSettings 		= event.getPrivateValue( name="cbSettings" );
		var oCurrentAuthor 	= securityService.getAuthorSession();
		var iData = { commentForm = "" };

		// generate comment form
		iData.commentForm &= '
			#html.startForm(
				name 		= "commentForm",
				action 		= cb.linkCommentPost( arguments.content ),
				novalidate 	= "novalidate"
			)#
		';

		cb.event( "cbui_preCommentForm", iData );

		iData.commentForm &= '
			#getModel( "messagebox@cbMessagebox" ).renderIt()#

			#html.hiddenField( name="contentID", value=arguments.content.getContentID() )#
			#html.hiddenField( name="contentType", value=arguments.content.getContentType() )#

			#html.textField(
				name 		= "author",
				label 		= "Name: (required)",
				size 		= "50",
				class 		= "form-control",
				groupWrapper= "div class=form-group",
				required 	= "required",
				value 		= event.getValue( "author", oCurrentAuthor.getName() )
			)#

			#html.inputField(
				name 		= "authorEmail",
				type 		= "email",
				label 		= "Email: (required)",
				size 		= "50",
				class 		= "form-control",
				groupWrapper= "div class=form-group",
				required 	= "required",
				value 		= event.getValue( "authorEmail", oCurrentAuthor.getEmail() )
			)#

			#html.inputField(
				name 		= "authorURL",
				type 		= "url",
				label 		= "Website:",
				size 		= "50",
				class 		= "form-control",
				groupWrapper= "div class=form-group",
				value 		= event.getValue( "authorURL", "" )
			)#

			#html.textArea(
				name 		= "content",
				label 		= "Comment:",
				class 		= "form-control",
				required 	= "required",
				value 		= event.getValue( "content", "" )
			)#

			#html.checkBox(
				name 			= "subscribe",
				label 			= "Notify me of follow-up comments by email.",
				groupwrapper 	= "div class=checkbox",
				checked 		= event.getValue( "subscribe", false )
			)#
		';

		cb.event( "cbui_postCommentForm", iData );

		iData.commentForm &= '
			<div class="buttons">
				#html.submitButton( name="commentSubmitButton", value="Submit", class="btn btn-primary" )#
			</div>
			#html.endForm()#
		';

		return iData.commentForm;
	}
}
