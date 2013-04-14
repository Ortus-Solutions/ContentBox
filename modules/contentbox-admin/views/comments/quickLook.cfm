<cfoutput>
<div class="modal-header">
    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
    <h3 id="header">Comment Quick Look</h3>
</div>
<div class="modal-body">
	#getMyPlugin(plugin="Avatar",module="contentbox").renderAvatar(email=rc.comment.getAuthorEmail(),size="50")#
	&nbsp;<a href="mailto:#rc.comment.getAUthorEmail()#" title="#rc.comment.getAUthorEmail()#">#rc.comment.getAuthor()#</a>
	<br/>
	<cfif len(rc.comment.getAuthorURL())>
		<i class="icon-cloud"></i>
		<a href="<cfif NOT findnocase("http",rc.comment.getAuthorURL())>http://</cfif>#rc.comment.getAuthorURL()#" title="Open URL" target="_blank">
			#rc.comment.getAuthorURL()#
		</a>
		<br />
	</cfif>
	<i class="icon-laptop"></i>
	<a href="#prc.cbSettings.cb_comments_whoisURL#=#rc.comment.getAuthorIP()#" title="Get IP Information" target="_blank">#rc.comment.getauthorIP()#</a>
	<hr/>
	#rc.comment.getDisplayContent()#
</div>
<!--- Button Bar --->
<div class="modal-footer">
	<button class="btn btn-danger" onclick="closeRemoteModal()"> Close </button>
</div>
</cfoutput>