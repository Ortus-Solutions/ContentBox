<cfoutput>		
<!--============================Sidebar============================-->
<div class="sidebar">
	<!--- Info Box --->
	<div class="small_box">
		<div class="header">
			<img src="#prc.cbroot#/includes/images/settings.png" alt="info" width="24" height="24" />Actions
		</div>
		<div class="body">
			<!--- Search Form --->
			#html.startForm(name="commentForm",action=prc.xehCommentstatus)#
				#html.hiddenField(name="commentID",bind=rc.comment)#
				#html.hiddenField(name="commentStatus",value="approve")#
				<!--- Buttons --->
				<input type="submit" value="Delete Comment" class="buttonred" onclick="removeComment()" />
				<input type="submit" value="Approve Comment" class="button2" />				
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
			<img src="#prc.cbroot#/includes/images/comments_32.png" alt="sofa" width="30" height="30" />
			Comment Moderator
		</div>
		<!--- Body --->
		<div class="body">	

			<!--- Comment Details --->
			<fieldset>
				<legend><img src="#prc.cbRoot#/includes/images/settings_black.png" alt="details" /> Comment Details</legend>
					#getMyPlugin(plugin="Avatar",module="contentbox").renderAvatar(email=rc.comment.getAuthorEmail())#
					&nbsp;<a href="mailto:#rc.comment.getAUthorEmail()#" title="#rc.comment.getAUthorEmail()#">#rc.comment.getAuthor()#</a>
					<br/>
					<cfif len(rc.comment.getAuthorURL())>
						<img src="#prc.cbRoot#/includes/images/link.png" alt="link" /> 
						<a href="<cfif NOT findnocase("http",rc.comment.getAuthorURL())>http://</cfif>#rc.comment.getAuthorURL()#" title="Open URL" target="_blank">
							#rc.comment.getAuthorURL()#
						</a>
						<br />
					</cfif>
					<!--- IP Address --->
					<img src="#prc.cbRoot#/includes/images/database_black.png" alt="server" /> 
					<a href="#prc.cbSettings.cb_comments_whoisURL#=#rc.comment.getAuthorIP()#" title="Get IP Information" target="_blank">#rc.comment.getauthorIP()#</a>
					<br/>
					<!--- Date --->
					<img src="#prc.cbRoot#/includes/images/calendar.png" alt="calendar" /> 
					#rc.comment.getDisplayCreatedDate()#
				
			</fieldset>
			
			<!--- content --->
			<fieldset>
				<legend><img src="#prc.cbRoot#/includes/images/comments_black.png" alt="details" /> Comment</legend>
				#rc.comment.getContent()#
			</fieldset>
			
		</div>	
	</div>
</div>
</cfoutput>