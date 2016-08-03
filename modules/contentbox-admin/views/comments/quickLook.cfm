<cfoutput>
<div class="modal-dialog modal-lg" role="document" >
	<div class="modal-content">
		<div class="modal-header">
		    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
		    <h4><i class="fa fa-comments"></i> Comment Quick Look</h4>
		</div>
		<div class="modal-body">
			#getModel( "Avatar@cb" ).renderAvatar(email=rc.comment.getAuthorEmail(), size="50" )#
			&nbsp;<a href="mailto:#rc.comment.getAUthorEmail()#" title="#rc.comment.getAUthorEmail()#">#rc.comment.getAuthor()#</a>
			<br/>
			<cfif len(rc.comment.getAuthorURL())>
				<i class="fa fa-cloud"></i>
				<a href="<cfif NOT findnocase( "http",rc.comment.getAuthorURL())>http://</cfif>#rc.comment.getAuthorURL()#" title="Open URL" target="_blank">
					#rc.comment.getAuthorURL()#
				</a>
				<br />
			</cfif>
			<i class="fa fa-laptop"></i>
			<a href="#prc.cbSettings.cb_comments_whoisURL#=#rc.comment.getAuthorIP()#" title="Get IP Information" target="_blank">#rc.comment.getauthorIP()#</a>
			<hr/>
			#rc.comment.getDisplayContent()#
		</div>
		<!--- Button Bar --->
		<div class="modal-footer">
			<button class="btn" onclick="closeRemoteModal()"> Close </button>
		</div>
	</div>
</div>
</cfoutput>