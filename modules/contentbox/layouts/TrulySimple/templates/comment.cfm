<cfoutput>
<div id="comment_#comment.getCommentID()#" class="comment">
	<!--- Anchor --->
	<a name="comment_#comment.getCommentID()#"></a>

	<div class="commentPicture">
		#cb.quickAvatar(author=comment.getAuthorEmail(),size=50)#
		<p>
		<cfif len(comment.getAuthorURL())>
		by <a href="<cfif NOT findnocase("http",comment.getAuthorURL())>http://</cfif>#comment.getAuthorURL()#" title="Open #comment.getAuthorURL()#">#comment.getAuthor()#</a>
		<cfelse>
		by #comment.getAuthor()#
		</cfif>
		</br>
		#comment.getDisplayCreatedDate()#
		</p>
	</div>

	<!--- Content --->
	<div class="commentContent">
		<p>#comment.getContent()#</p>
	</div>
</div>
</cfoutput>