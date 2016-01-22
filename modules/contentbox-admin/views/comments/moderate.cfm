<cfoutput>	
<div class="row-fluid" id="main-content">
	<!--- main content --->
	<div class="box">
		<!--- Body Header --->
		<div class="header">
			<i class="fa fa-comments fa-lg"></i>
			Comment Moderator
		</div>
		<!--- Body --->
		<div class="body">	

			<!--- Comment Details --->
			<fieldset>
				<legend><i class="fa fa-eye fa-lg"></i> Comment Details</legend>
					#getModel( "Avatar@cb" ).renderAvatar(email=rc.comment.getAuthorEmail())#
					&nbsp;<a href="mailto:#rc.comment.getAUthorEmail()#" title="#rc.comment.getAUthorEmail()#">#rc.comment.getAuthor()#</a>
					<br/>
					<cfif len(rc.comment.getAuthorURL())>
						<i class="fa fa-cloud"></i> 
						<a href="<cfif NOT findnocase( "http",rc.comment.getAuthorURL())>http://</cfif>#rc.comment.getAuthorURL()#" target="_blank">
							#rc.comment.getAuthorURL()#
						</a>
						<br />
					</cfif>
					<!--- IP Address --->
					<i class="fa fa-laptop"></i> 
					<a href="#prc.cbSettings.cb_comments_whoisURL#=#rc.comment.getAuthorIP()#" title="Get IP Information" target="_blank">#rc.comment.getauthorIP()#</a>
					<br/>
					<!--- Date --->
					<i class="fa fa-calendar"></i> 
					#rc.comment.getDisplayCreatedDate()#
				
			</fieldset>
			
			<!--- content --->
			<fieldset>
				<legend><i class="fa fa-comment"></i> Comment</legend>
				#rc.comment.getContent()#
			</fieldset>

			<!--- Search Form --->
			#html.startForm(name="commentForm",action=prc.xehCommentstatus)#
				#html.hiddenField(name="commentID",bind=rc.comment)#
				#html.hiddenField(name="commentStatus",value="approve" )#
				<div class="form-actions">
				<!--- Buttons --->
				<button type="submit" class="btn btn-primary" onclick="removeComment()"><i class="fa fa-trash"></i> Delete</button>
				<button type="submit" class="btn btn-danger" /><i class="fa fa-check"></i> Approve</button>
				</div>				
			#html.endForm()#
			
		</div>	
	</div>
	
</div>
</cfoutput>