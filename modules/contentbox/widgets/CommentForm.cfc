/**
* A cool basic commenting form for ContentBox
*/
component extends="contentbox.models.ui.BaseWidget" singleton{

	CommentForm function init(){
		// Widget Properties
		setName( "CommentForm" );
		setVersion( "1.0" );
		setDescription( "A cool basic commenting form for ContentBox content objects." );
		setAuthor( "Ortus Solutions" );
		setAuthorURL( "http://www.ortussolutions.com" );
		setIcon( "comment-add.png" );
		setCategory( "Miscellaneous" );
		return this;
	}

	/**
	* The main commenting form widget
	* @content.hint The content object to build the comment form for: page or entry
	*/
	any function renderIt(any content){
		var event 		= getRequestContext();
		var cbSettings 	= event.getValue(name="cbSettings",private=true);
		var captcha		= "";
		var commentForm = "";
		
		// captcha?
		if( cbSettings.cb_comments_captcha ){
			saveContent variable="captcha"{
				writeOutput( "
					<img src='#event.buildLink( event.getValue( 'cbEntryPoint', '', true) & '__captcha')#'>
					#html.textField(name="captchacode",label="Enter the security code shown above:",required="required",size="50" )#
				" );
			}
		}

		// generate comment form
		saveContent variable="commentForm"{
			writeOutput('
			#html.startForm( name="commentForm", action=cb.linkCommentPost( arguments.content ), novalidate="novalidate" )#

				#cb.event( "cbui_preCommentForm" )#

				#getModel( "messagebox@cbMessagebox" ).renderIt()#

				#html.hiddenField( name="contentID", value=arguments.content.getContentID() )#
				#html.hiddenField( name="contentType",value=arguments.content.getContentType() )#

				#html.textField( name="author", label="Name: (required)",size="50", required="required", value=event.getValue( "author","" ) )#
				#html.inputField( name="authorEmail", type="email", label="Email: (required)", size="50", required="required", value=event.getValue( "authorEmail","" ) )#
				#html.inputField( name="authorURL", type="url", label="Website:", size="50", value=event.getValue( "authorURL","" ) )#

				#html.textArea( name="content", label="Comment:", required="required", value=event.getValue( "content","" ) )#
				#html.checkBox( name="subscribe", label="Notify me of follow-up comments by email." )#
				#captcha#

				#cb.event( "cbui_postCommentForm" )#

				<div class="buttons">
					#html.submitButton( name="commentSubmitButton", value="Submit" )#
				</div>
			#html.endForm()#
			');
		}

		return commentForm;
	}

}
