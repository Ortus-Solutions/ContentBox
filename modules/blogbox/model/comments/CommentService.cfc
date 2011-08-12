/**
* Service to handle comment operations.
*/
component extends="coldbox.system.orm.hibernate.VirtualEntityService" singleton{
	
	// DI
	property name="mailService"		inject="coldbox:plugin:MailService";
	property name="renderer" 		inject="coldbox:plugin:Renderer";
	property name="settingService"	inject="id:settingService@bb";
	property name="bbHelper"		inject="id:bbhelper@bb";
	property name="log"				inject="logbox:logger:{this}";

	/**
	* Constructor
	*/
	public CommentService function init(){
		super.init(entityName="bbComment");
		return this;
	}
	
	/**
	* Comment listing for UI of approved comments, returns struct of results=[comments,count]
	*/
	function findApprovedComments(entryID,pageID,max=0,offset=0){
		var results = {};
		// get Hibernate Restrictions class
		var restrictions = getRestrictions();	
		// criteria queries
		var criteria = [];
		
		// only approved comments
		arrayAppend(criteria, restrictions.eq("isApproved", javaCast("boolean",1)) );
		
		// By Entry?
		if( structKeyExists(arguments,"entryID") AND len(arguments.entryID) ){
			arrayAppend(criteria, restrictions.eq("entry.entryID",javaCast("int", arguments.entryID)));			
		}
		
		// By Page?
		if( structKeyExists(arguments,"pageID") AND len(arguments.pageID) ){
			arrayAppend(criteria, restrictions.eq("page.pageID",javaCast("int", arguments.pageID)));			
		}
		
		// run criteria query and projections count
		results.comments = criteriaQuery(criteria=criteria,offset=arguments.offset,max=arguments.max,sortOrder="createdDate",asQuery=false);
		results.count 	 = criteriaCount(criteria=criteria);
		
		return results;
	}
	
	/**
	* Save a comment according to our rules and process it. Returns a structure of information
	* results = [moderated:boolean,messages:array]
	* @comment The comment to try to save
	*/
	struct function saveComment(required comment) transactional{
		// Comment reference
		var inComment = arguments.comment;
		// get settings
		var inSettings = settingService.getAllSettings(asStruct=true);
		// results
		var results = {moderated=true,messages=[]};
		
		// Log the IP Address
		inComment.setAuthorIP( cgi.remote_addr );
		// Default moderation
		inComment.setIsApproved( false );
		
		// Check if activating URL's on Comment Content
		if( inSettings.bb_comments_urltranslations ){
			inComment.setContent( activateURLs( inComment.getContent() ) );
		}
		
		// Run moderation rules
		if( runModerationRules(inComment,inSettings) ){
			// send for saving, finally phew!
			save( inComment );	
			// Send Notification or Moderation Email?
			sendNotificationEmails( inComment, inSettings );
			// Return results
			if( inComment.getIsApproved() ){ results.moderated = false; }
			else{ arrayAppend(results.messages,"Comment was moderated! Please wait for the system administrator to approve it."); }
		}
		else{
			// Messages
			arrayAppend(results.messages,"Geez! Comment was blocked!");
			
			// discard it from session
			evictEntity( inComment );
			// log it
			if( log.canWarn() ){
				log.warn("Incoming comment was blocked!",inComment.getMemento());
			}
		}	
		
		return results;
	}
	
	/**
	* Run moderation rules on an incoming comment and set of blogbox settings. If this method returns a false then the comment is moderated 
	* and can continue to be saved. If returns false, then it is blocked and must NOT be saved.
	* @comment Comment to moderate check
	* @settings The blogbox settings to moderate against
	*/
	private boolean function runModerationRules(comment,settings){
		// Comment reference
		var inComment 	= arguments.comment;
		var inSettings 	= arguments.settings; 
		var results		= true;
		
		// Not moderation, just approve and return
		if( NOT settings.bb_comments_moderation ){ 
			inComment.setIsApproved( true );
			return true;
		}
		
		// Check if user has already an approved comment. If they do, then approve them
		if( inSettings.bb_comments_moderation_whitelist AND userHasPreviousAcceptedComment( inComment.getAuthorEmail() ) ){
			inComment.setIsApproved( true );
			return true;
		}
		
		// Execute moderation queries
		if( len(inSettings.bb_comments_moderation_blacklist) AND anyKeywordMatch(inComment,inSettings.bb_comments_moderation_blacklist) ){
			inComment.setIsApproved( false );
		}
				
		// Execute blocking queries
		if( len(inSettings.bb_comments_moderation_blockedlist) AND anyKeywordMatch(inComment,inSettings.bb_comments_moderation_blockedlist) ){
			inComment.setIsApproved( false );
			results = false;
		}	
		
		return results;		
	}
	
	/**
	* Regex matching of a list of entries against a comment and matching keyword list
	*/
	private boolean function anyKeywordMatch(comment,matchList){
		var inComment 	= arguments.comment;
		var del 		= chr(13) & chr(10);
		var inList 		= listToArray(arguments.matchList,del);
		
		for(var x=1; x lte arrayLen(inList); x++){
			
			// Verify each keword via regex
			if( refindNoCase( inList[x], inComment.getContent() ) OR 
				refindNoCase( inList[x], inComment.getAuthor() ) OR 
				refindNoCase( inList[x], inComment.getAuthorIP() ) ){
				return true;
			}
			
		}		
		
		return false;		
	}
		
	/**
	* Check if the user has already a comment in the system
	* @email The email address to check.
	*/
	private boolean function userHasPreviousAcceptedComment(required email){
		return ( countWhere(authorEmail=arguments.email,isApproved=true) GT 0 );
	}
	
	/**
	* Send a notification email for comments
	* @comment Comment to moderate check
	* @settings The blogbox settings to moderate against
	*/
	private void function sendNotificationEmails(comment,settings){
		// Comment reference
		var inComment 	= arguments.comment;
		var inSettings 	= arguments.settings; 
		var outEmails	= inSettings.bb_site_email;
		var subject		= "";
		var template	= "";
		
		// More notification emails
		if( len(inSettings.bb_comments_notifyemails) ){
			outEmails &= "," & inSettings.bb_comments_notifyemails;
		}
		
		// get mail payload
		var bodyTokens = inComment.getMemento();
		bodyTokens["whoisURL"] 		= inSettings.bb_comments_whoisURL;
		bodyTokens["commentURL"] 	= bbHelper.linkComment( inComment );
		bodyTokens["deleteURL"] 	= bbHelper.linkAdmin("comments.moderate") & "?commentID=#inComment.getCommentID()#";
		bodyTokens["approveURL"] 	= bbHelper.linkAdmin("comments.moderate") & "?commentID=#inComment.getCommentID()#";
		if( inComment.hasEntry() ){
			bodyTokens["entryURL"] 		= bbHelper.linkEntry( inComment.getEntry() );
		}
		else{
			bodyTokens["entryURL"] 		= bbHelper.linkPage( inComment.getPage() );
		}
		bodyTokens["entryTitle"] 	= inComment.getParentTitle();
		
		// Moderation Email? Comment is moderated?
		if( inComment.getIsApproved() eq false AND inSettings.bb_comments_moderation_notify ){
			subject  = "New comment needs moderation on post: #bodyTokens.entryTitle#";
			template = "comment_moderation";
		}
		// Post Notification Email?
		else if( inSettings.bb_comments_notify ){
			subject  = "New comment on post: #bodyTokens.entryTitle#";
			template = "comment_new";
		}
		
		// Send it baby!
		var mail = mailservice.newMail(to=outEmails,
									   from=settings.bb_site_outgoingEmail,
									   subject=subject,
									   bodyTokens=bodyTokens);
		// generate content for email from template
		mail.setBody( renderer.renderView(view="email_templates/#template#",module="blogbox") );
		// send it out
		mailService.send( mail );		
	}
	
	/**
	* Activate URL's from text
	*/
	private function activateURLs(required text){
		return REReplaceNoCase(arguments.text, "((https?|ftp):\/\/)([^\s]*)\s?","<a href=""\1\3"">\1\3</a> ", "ALL");
	}
	
	/**
	* comment search returns struct with keys [comments,count]
	*/
	struct function search(search="",isApproved,entryID,pageID,max=0,offset=0){
		var results = {};
		// get Hibernate Restrictions class
		var restrictions = getRestrictions();	
		// criteria queries
		var criteria = [];
		
		// isApproved filter
		if( structKeyExists(arguments,"isApproved") AND arguments.isApproved NEQ "any"){
			arrayAppend(criteria, restrictions.eq("isApproved", javaCast("boolean",arguments.isApproved)) );
		}		
		// Entry Filter
		if( structKeyExists(arguments,"entryID") AND arguments.entryID NEQ "all"){
			arrayAppend(criteria, restrictions.eq("entry.entryID", javaCast("int",arguments.entryID)) );
		}
		// Page Filter
		if( structKeyExists(arguments,"pageID") AND arguments.pageID NEQ "all"){
			arrayAppend(criteria, restrictions.eq("page.pageID", javaCast("int",arguments.pageID)) );
		}
		// Search Criteria
		if( len(arguments.search) ){
			// like disjunctions
			var orCriteria = [];
 			arrayAppend(orCriteria, restrictions.like("author","%#arguments.search#%"));
 			arrayAppend(orCriteria, restrictions.like("authorEmail","%#arguments.search#%"));
 			arrayAppend(orCriteria, restrictions.like("content","%#arguments.search#%"));
			// append disjunction to main criteria
			arrayAppend( criteria, restrictions.disjunction( orCriteria ) );
		}
		
		// run criteria query and projections count
		results.comments = criteriaQuery(criteria=criteria,offset=arguments.offset,max=arguments.max,sortOrder="createdDate DESC",asQuery=false);
		results.count 	= criteriaCount(criteria=criteria);
		
		return results;
	}

	/**
	* Bulk Updates
	* @commentID The list or array of ID's to bulk update
	* @status The status either 'approve' or 'moderate'
	*/ 
	any function bulkStatus(any commentID,status){
		var approve = false;
		
		// approve flag
		if( arguments.status eq "approve" ){
			approve = true;
		}
		
		// Get all by id
		var comments = getAll(id=arguments.commentID);
		for(var x=1; x lte arrayLen(comments); x++){
			comments[x].setisApproved( approve );
		}
		// transaction the save of all the comments
		saveAll( comments );
		
		return this;		
	}

}