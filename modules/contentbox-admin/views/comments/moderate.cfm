<cfoutput>		
<!--============================Sidebar============================-->
<div class="sidebar">
	<!--- Info Box --->
	<div class="small_box">
		<div class="header">
			<i class="icon-cogs"></i> Actions
		</div>
		<div class="body">
			<!--- Search Form --->
			#html.startForm(name="commentForm",action=prc.xehCommentstatus)#
				#html.hiddenField(name="commentID",bind=rc.comment)#
				#html.hiddenField(name="commentStatus",value="approve")#
				<!--- Buttons --->
				<input type="submit" value="Delete Comment" class="btn btn-danger" onclick="removeComment()" />
				<input type="submit" value="Approve Comment" class="btn btn-primary" />				
			#html.endForm()#
		</div>
	</div>		
	
</div>
<!--End sidebar-->	
<!--============================Main Column============================-->
<div class="main_column" id="main_column">
	<div class="box">
		<!--- Body Header --->
		<div class="header">
			<i class="icon-comments icon-large"></i>
			Comment Moderator
		</div>
		<!--- Body --->
		<div class="body">	

			<!--- Comment Details --->
			<fieldset>
				<legend><i class="icon-eye-open icon-large"></i> Comment Details</legend>
					#getMyPlugin(plugin="Avatar",module="contentbox").renderAvatar(email=rc.comment.getAuthorEmail())#
					&nbsp;<a href="mailto:#rc.comment.getAUthorEmail()#" title="#rc.comment.getAUthorEmail()#">#rc.comment.getAuthor()#</a>
					<br/>
					<cfif len(rc.comment.getAuthorURL())>
						<i class="icon-cloud"></i> 
						<a href="<cfif NOT findnocase("http",rc.comment.getAuthorURL())>http://</cfif>#rc.comment.getAuthorURL()#" title="Open URL" target="_blank">
							#rc.comment.getAuthorURL()#
						</a>
						<br />
					</cfif>
					<!--- IP Address --->
					<i class="icon-laptop"></i> 
					<a href="#prc.cbSettings.cb_comments_whoisURL#=#rc.comment.getAuthorIP()#" title="Get IP Information" target="_blank">#rc.comment.getauthorIP()#</a>
					<br/>
					<!--- Date --->
					<i class="icon-calendar"></i> 
					#rc.comment.getDisplayCreatedDate()#
				
			</fieldset>
			
			<!--- content --->
			<fieldset>
				<legend><i class="icon-comment"></i> Comment</legend>
				#rc.comment.getContent()#
			</fieldset>
			
		</div>	
	</div>
</div>
</cfoutput>