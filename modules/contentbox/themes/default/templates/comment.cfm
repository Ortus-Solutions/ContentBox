<cfoutput>
<div id="comment_#comment.getCommentID()#" class="media comment">

	<!--- Anchor --->
	<a name="comment_#comment.getCommentID()#"></a>

	<!--- User Avatar --->
    <a class="pull-left" href="##">
		#cb.quickAvatar(
			author 	= comment.getAuthorEmail(),
			size  	= 60,
			class 	= "img-circle"
		)#
	</a>

    <div>
		<!--- Comment Author --->
		<h4>
			<cfif len( comment.getAuthorURL() )>
				<a
					href="<cfif NOT findnocase( "http", comment.getAuthorURL() )>http://</cfif>#encodeForHTMLAttribute( comment.getAuthorURL() )#"
					title="Open Author URL"
					target="_blank"
					rel="noopener"
				>
					<i class="fa fa-link"></i>
					<strong>#encodeForHTML( comment.getAuthor() )#</strong>
				</a>
			<cfelse>
				<strong>#encodeForHTML( comment.getAuthor() )#</strong>
			</cfif>

			<div>
				<small>
					<time>
						#comment.getDisplayCreatedDate()#
					</time>
				</small>
			</div>
		</h4>

		<!--- Content --->
		<div class="post-content">
			#comment.getDisplayContent()#
		</div>
    </div>
</div>

</cfoutput>