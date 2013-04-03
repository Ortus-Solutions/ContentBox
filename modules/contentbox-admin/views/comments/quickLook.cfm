<cfoutput>
<h2>Comment Quick Look</h2>
<div>
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
</div>
<hr/>
<div>
#rc.comment.getDisplayContent()#
</div>
<hr/>
<!--- Button Bar --->
<div id="bottomCenteredBar" class="textRight">
	<button class="buttonred" onclick="closeRemoteModal()"> Close </button>
</div>
</cfoutput>