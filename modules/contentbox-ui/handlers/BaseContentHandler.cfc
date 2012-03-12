/**
********************************************************************************
ContentBox - A Modular Content Platform
Copyright 2012 by Luis Majano and Ortus Solutions, Corp
www.gocontentbox.org | www.luismajano.com | www.ortussolutions.com
********************************************************************************
Apache License, Version 2.0

Copyright Since [2012] [Luis Majano and Ortus Solutions,Corp]

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
********************************************************************************
* Base Content Handler
*/
component{

	// DI
	property name="authorService"		inject="id:authorService@cb";
	property name="categoryService"		inject="id:categoryService@cb";
	property name="commentService"		inject="id:commentService@cb";
	property name="CBHelper"			inject="id:CBHelper@cb";
	property name="rssService"			inject="id:rssService@cb";
	property name="validator"			inject="id:Validator@cb";

	// pre Handler
	function preHandler(event,action,eventArguments){
		var rc 	= event.getCollection();
		var prc = event.getCollection(private=true);

		// Maintenance Mode?
		if( prc.cbSettings.cb_site_maintenance ){
			event.overrideEvent("contentbox-ui:page.maintenance");
			return;
		}

		// set blog layout
		event.setLayout("#prc.cbLayout#/layouts/blog");

		// Get all categories
		prc.categories = categoryService.list(sortOrder="category",asQuery=false);

		// Home page determination either blog or a page
		if( event.getCurrentRoute() eq "/" AND prc.cbSettings.cb_site_homepage neq "cbBlog"){
			event.overrideEvent("contentbox-ui:page.index");
			prc.pageOverride = prc.cbSettings.cb_site_homepage;
		}
	}

	/**
	* Go Into maintenance mode.
	*/
	function maintenance(event,rc,prc){
		event.renderData(data=prc.cbSettings.cb_site_maintenance_message);
	}


	/*
	* Error Control
	*/
	function onError(event,faultAction,exception,eventArguments){
		var rc 	= event.getCollection();
		var prc = event.getCollection(private=true);

		// store exceptions
		prc.faultAction = arguments.faultAction;
		prc.exception   = arguments.exception;

		// announce event
		announceInterception("cbui_onError",{faultAction=arguments.faultAction,exception=arguments.exception,eventArguments=arguments.eventArguments});

		// Set view to render
		event.setView(view="#prc.cbLayout#/views/error",layout="#prc.cbLayout#/layouts/pages");
	}

	/************************************** PRIVATE *********************************************/

	/**
	* Validate incoming comment post
	*/
	private array function validateCommentPost(event,rc,prc,thisContent){
		var commentErrors = [];

		// param values
		event.paramValue("author","");
		event.paramValue("authorURL","");
		event.paramValue("authorEmail","");
		event.paramValue("content","");
		event.paramValue("captchacode","");

		// Check if comments enabled? else kick them out, who knows how they got here
		if( NOT CBHelper.isCommentsEnabled( thisContent ) ){
			getPlugin("MessageBox").warn("Comments are disabled! So you can't post any!");
			setNextEvent( CBHelper.linkContent( thisContent ) );
		}

		// Trim values & XSS Cleanup of fields
		var antiSamy 	= getPlugin("AntiSamy");
		rc.author 		= antiSamy.htmlSanitizer( trim(rc.author) );
		rc.authorEmail 	= antiSamy.htmlSanitizer( trim(rc.authorEmail) );
		rc.authorURL 	= antiSamy.htmlSanitizer( trim(rc.authorURL) );
		rc.captchacode 	= antiSamy.htmlSanitizer( trim(rc.captchacode) );
		rc.content 		= antiSamy.htmlSanitizer( xmlFormat(trim(rc.content)) );

		// Validate incoming data
		commentErrors = [];
		if( !len(rc.author) ){ arrayAppend(commentErrors,"Your name is missing!"); }
		if( !len(rc.authorEmail) OR NOT validator.checkEmail(rc.authorEmail)){ arrayAppend(commentErrors,"Your email is missing or is invalid!"); }
		if( len(rc.authorURL) AND NOT validator.checkURL(rc.authorURL) ){ arrayAppend(commentErrors,"Your website URL is invalid!"); }
		if( !len(rc.content) ){ arrayAppend(commentErrors,"Your URL is invalid!"); }

		// Captcha Validation
		if( prc.cbSettings.cb_comments_captcha AND NOT getMyPlugin(plugin="Captcha",module="contentbox").validate( rc.captchacode ) ){
			ArrayAppend(commentErrors, "Invalid security code. Please try again.");
		}

		// announce event
		announceInterception("cbui_preCommentPost",{commentErrors=commentErrors,content=thisContent,contentType=thisContent.getContentType()});

		return commentErrors;
	}

	/**
	* Save the comment
	*/
	private function saveComment(thisContent){
		// Get new comment to persist
		var comment = populateModel( commentService.new() );
		// relate it to content
		comment.setRelatedContent( thisContent );
		// save it
		var results = commentService.saveComment( comment );

		// announce event
		announceInterception("cbui_onCommentPost",{comment=comment,content=thisContent,moderationResults=results,contentType=thisContent.getContentType()});

		// Check if all good
		if( results.moderated ){
			// Message
			getPlugin("MessageBox").warn(messageArray=results.messages);
			flash.put(name="commentErrors",value=results.messages,inflateTOPRC=true);
			// relocate back to comments
			setNextEvent(URL=CBHelper.linkComments( thisContent ));
		}
		else{
			// relocate back to comment
			setNextEvent(URL=CBHelper.linkComment( comment ));
		}
	}

}