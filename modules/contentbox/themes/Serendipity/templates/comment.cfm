<cfoutput>
	<div id="comment_#comment.getCommentID()#" class="card mb-5 media comment">
		<div class="card-body">
			<!--- Anchor --->
			<a name="comment_#comment.getCommentID()#"></a>
			<div class="row">
				<div class="col-md-1">
					<!--- User Avatar --->
					<div class="rounded mx-auto">
						#cb.quickAvatar(
							author 	= comment.getAuthorEmail(),
							size  	= 50,
							class 	= "img-circle"
						)#
					</div>
				</div>
				<div class="col-md-11">
					<div>
						<!--- Comment Date and time --->
						<small>
							<svg xmlns="http://www.w3.org/2000/svg" width="15" fill="none" viewBox="0 0 24 24" stroke="currentColor">
								<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z" />
							</svg>
							<time>
								#comment.getDisplayCreatedDate()#
							</time>
						</small>
					</div>
					<!--- Comment Author --->
					<cfif len( comment.getAuthorURL() )>
						<a
							href="<cfif NOT findnocase( "http", comment.getAuthorURL() )>http://</cfif>#encodeForHTMLAttribute( comment.getAuthorURL() )#"
							title="Open Author URL"
							target="_blank"
							rel="noopener"
						>
							<i class="fa fa-link"></i>
							<h4>#encodeForHTML( comment.getAuthor() )#</h4>
						</a>
					<cfelse>
						<h4>#encodeForHTML( comment.getAuthor() )#</h4>
					</cfif>

					<div>

						<!--- Content --->
						<div class="card-text post-content text-black">
							#comment.getDisplayContent()#
						</div>
						
					</div>
				</div>
			</div>
			

			
		</div>
	</div>
</cfoutput>
