/**
* A cool basic commenting form for ContentBox
*/
component extends="contentbox.models.ui.BaseWidget" singleton{

	CommentForm function init(){
		// super init
		//super.init();

		// Widget Properties
		setName("CommentForm");
		setVersion("1.0");
		setDescription("A cool basic commenting form for ContentBox content objects.");
		setAuthor("Tropicalista");
		setAuthorURL("http://www.tropicalseo.net");
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
				writeOutput("
					<img src='#event.buildLink( event.getValue( 'cbEntryPoint', '', true) & '__captcha')#'>
					#html.textField(name="captchacode",label="Enter the security code shown above:",class="form-control",groupWrapper="div class=form-group",required="required",size="50")#
				");
			}
		}

		// generate comment form
		saveContent variable="commentForm"{
			writeOutput('
			#html.startForm(name="commentForm",action=cb.linkCommentPost(arguments.content),novalidate="novalidate")#

				#cb.event("cbui_preCommentForm")#

				#getModel( "messagebox@cbMessagebox" ).renderIt()#

				#html.hiddenField(name="contentID",value=arguments.content.getContentID())#
				#html.hiddenField(name="contentType",value=arguments.content.getContentType())#

				#html.textField(name="author",label="Name: (required)",size="50",class="form-control",groupWrapper="div class=form-group",required="required",value=event.getValue("author",""))#
				#html.inputField(name="authorEmail",type="email",label="Email: (required)",class="form-control",groupWrapper="div class=form-group",size="50",required="required",value=event.getValue("authorEmail",""))#
				#html.inputField(name="authorURL",type="url",label="Website:",groupWrapper="div class=form-group",class="form-control",size="50",value=event.getValue("authorURL",""))#

				#html.textArea(name="content",label="Comment:",class="form-control",required="required",value=event.getValue("content",""))#
				
				<p></p>
				<p>
				#captcha#
				</p>
					
				#cb.event("cbui_postCommentForm")#

				<p class="buttons">
					#html.submitButton(name="commentSubmitButton",value="Submit",class="btn btn-primary")#
				</p>
			#html.endForm()#
			');
		}

		return commentForm;
	}

}
