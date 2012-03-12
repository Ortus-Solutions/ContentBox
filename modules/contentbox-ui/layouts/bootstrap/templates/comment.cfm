<cfoutput>
<div id="comment_#comment.getCommentID()#" class="comment">
	<!--- Anchor --->
	<a name="comment_#comment.getCommentID()#"></a>
	
	<!--- Comment Avatar --->
	<div class="commentPicture">
		#cb.quickAvatar(author=comment.getAuthorEmail(),size=60)#
	</div>
	
	<!--- Comment Author --->
	<h4>
		<cfif len(comment.getAuthorURL())>
			<a href="<cfif NOT findnocase("http",comment.getAuthorURL())>http://</cfif>#comment.getAuthorURL()#" title="Open #comment.getAuthorURL()#"><img src="#cb.layoutRoot()#/includes/images/link.png" alt="url" border="0" /></a>
		</cfif>
		<strong>#comment.getAuthor()#</strong> said
	</h4>
	<p>at #comment.getDisplayCreatedDate()#</p>
	
	<!--- Content --->
	<div class="commentContent">
		#comment.getContent()#
	</div>
</div>
</cfoutput>