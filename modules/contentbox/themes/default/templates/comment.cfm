<cfoutput>
<div id="comment_#comment.getCommentID()#" class="media comment">
	
	<!--- Anchor --->
	<a name="comment_#comment.getCommentID()#"></a>

    <a class="pull-left" href="##">#cb.quickAvatar( author=comment.getAuthorEmail(), size=60 )#</a>
    <div class="media-body">
		<!--- Comment Author --->
		<h4>
			<cfif len( comment.getAuthorURL() )>
				<a href="<cfif NOT findnocase( "http", comment.getAuthorURL() )>http://</cfif>#comment.getAuthorURL()#" title="Open #comment.getAuthorURL()#"><i class="icon-link"></i>
					<strong>#comment.getAuthor()#</strong>
				</a>
			</cfif>
		</h4>

		<p>#comment.getDisplayContent()#</p>
		<time>#comment.getDisplayCreatedDate()#</time>
    </div>
</div>

</cfoutput>