<cfoutput>
	<div id="comment_#comment.getCommentID()#" class="card mb-5 media comment">
		<div class="card-header">
			<!--- Anchor --->
			<a name="comment_#comment.getCommentID()#"></a>

			<!--- User Avatar --->
			<a class="pull-left" href="##">
				#cb.quickAvatar(
					author 	= comment.getAuthorEmail(),
					size  	= 20,
					class 	= "img-circle"
				)#
			</a>

			<!--- Comment Author --->
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
			<small class="float-end">
				<svg xmlns="http://www.w3.org/2000/svg" width="15" fill="none" viewBox="0 0 24 24" stroke="currentColor">
					<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z" />
				</svg>
				<time>
					#comment.getDisplayCreatedDate()#
				</time>
			</small>
		</div>
		<div class="card-body">
			
			
			<div>

				<!--- Content --->
				<div class="card-text post-content">
					#comment.getDisplayContent()#
				</div>
				
			</div>
			

			
		</div>
	</div>
</cfoutput>
