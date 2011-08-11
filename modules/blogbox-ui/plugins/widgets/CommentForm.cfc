/**
* A cool basic commenting form for BlogBox
*/
component extends="blogbox.model.ui.BaseWidget" singleton{
	
	CommentForm function init(controller){
		// super init
		super.init(controller);
		
		// Widget Properties
		setPluginName("CommentForm");
		setPluginVersion("1.0");
		setPluginDescription("A cool basic commenting form for BlogBox");
		setPluginAuthor("Luis Majano");
		setPluginAuthorURL("www.ortussolutions.com");
		setForgeBoxSlug("bbwidget-commentForm");
		
		return this;
	}
	
	/**
	* The main commenting form widget
	* @content The content object to build the comment form for: page or entry
	*/
	any function renderIt(content){
		var event 		= getRequestContext();
		var bbSettings 	= event.getValue(name="bbSettings",private=true);
		var captcha		= "";
		var commentForm = "";
		var cID 		= "";
		var cContent	= "";
		
		// Determine ID
		if( structKeyExists(arguments.content,"getPageID") ){ cID = "pageID"; }
		if( structKeyExists(arguments.content,"getEntryID") ){ cID = "entryID"; }
		
		// captcha?
		if( bbSettings.bb_comments_captcha ){
			saveContent variable="captcha"{
				writeOutput("
					#getMyPlugin(plugin="captcha",module="blogbox").display()#<br />  
					#html.textField(name="captchacode",label="Enter the security code shown above:",required="required",size="50")#
				");
			}
		}
		
		// generate comment form
		saveContent variable="commentForm"{
			writeOutput('
			#html.startForm(name="commentForm",action=bb.linkCommentPost(),novalidate="novalidate")#
			
				#bb.event("bbui_preCommentForm")#
				
				#getPlugin("MessageBox").renderit()#
				
				#html.hiddenField(name=cID,bind=arguments.content)#
				
				#html.textField(name="author",label="Name: (required)",size="50",required="required",value=event.getValue("author",""))#
				#html.inputField(name="authorEmail",type="email",label="Email: (required)",size="50",required="required",value=event.getValue("authorEmail",""))#
				#html.inputField(name="authorURL",type="url",label="Website:",size="50",value=event.getValue("authorURL",""))#
				
				#html.textArea(name="content",label="Comment:",required="required",value=event.getValue("content",""))#

				#captcha#
				
				#bb.event("bbui_postCommentForm")#
				
				<div class="buttons">
					#html.submitButton(name="commentSubmitButton",value="Submit")#
				</div>
			#html.endForm()#		
			');
		}
		
		return commentForm;
	}
	
}
