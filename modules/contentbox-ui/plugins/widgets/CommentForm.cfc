/**
* A cool basic commenting form for ContentBox
*/
component extends="contentbox.model.ui.BaseWidget" singleton{
	
	CommentForm function init(controller){
		// super init
		super.init(controller);
		
		// Widget Properties
		setPluginName("CommentForm");
		setPluginVersion("1.0");
		setPluginDescription("A cool basic commenting form for ContentBox");
		setPluginAuthor("Ortus Solutions");
		setPluginAuthorURL("www.ortussolutions.com");
		setForgeBoxSlug("cbwidget-commentForm");
		
		return this;
	}
	
	/**
	* The main commenting form widget
	* @content The content object to build the comment form for: page or entry
	*/
	any function renderIt(content){
		var event 		= getRequestContext();
		var cbSettings 	= event.getValue(name="cbSettings",private=true);
		var captcha		= "";
		var commentForm = "";
		var cID 		= "";
		
		// Determine ID
		if( structKeyExists(arguments.content,"getPageID") ){  cID = arguments.content.getPageID(); }
		if( structKeyExists(arguments.content,"getEntryID") ){ cID = arguments.content.getEntryID(); }
		
		// captcha?
		if( cbSettings.cb_comments_captcha ){
			saveContent variable="captcha"{
				writeOutput("
					#getMyPlugin(plugin="Captcha",module="contentbox").display()#<br />  
					#html.textField(name="captchacode",label="Enter the security code shown above:",required="required",size="50")#
				");
			}
		}
		
		// generate comment form
		saveContent variable="commentForm"{
			writeOutput('
			#html.startForm(name="commentForm",action=cb.linkCommentPost(),novalidate="novalidate")#
			
				#cb.event("cbui_preCommentForm")#
				
				#getPlugin("MessageBox").renderit()#
				
				#html.hiddenField(name="contentID",value=cID)#
				#html.hiddenField(name="contentType",value=arguments.content.getType())#
				
				#html.textField(name="author",label="Name: (required)",size="50",required="required",value=event.getValue("author",""))#
				#html.inputField(name="authorEmail",type="email",label="Email: (required)",size="50",required="required",value=event.getValue("authorEmail",""))#
				#html.inputField(name="authorURL",type="url",label="Website:",size="50",value=event.getValue("authorURL",""))#
				
				#html.textArea(name="content",label="Comment:",required="required",value=event.getValue("content",""))#

				#captcha#
				
				#cb.event("cbui_postCommentForm")#
				
				<div class="buttons">
					#html.submitButton(name="commentSubmitButton",value="Submit")#
				</div>
			#html.endForm()#		
			');
		}
		
		return commentForm;
	}
	
}
