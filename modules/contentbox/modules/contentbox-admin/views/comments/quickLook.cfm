<cfoutput>
<div class="modal-dialog modal-lg" role="document" >
	<!--- Modal Content --->
	<div class="modal-content">

		<!--- Header --->
		<div class="modal-header">
		    <button
		    	type="button"
		    	class="close"
		    	data-dismiss="modal"
		    	aria-hidden="true">&times;</button>
		    <h4>
				<i class="far fa-comments"></i> Comment Quick Look
			</h4>
		</div>

		<!--- Body --->
		<div class="modal-body">
			<div class="row">
				<div class="col-md-6">
					#getInstance( "Avatar@contentbox" ).renderAvatar(
						email = encodeForHTMLAttribute( rc.comment.getAuthorEmail() ),
						size  = "50",
						class = "img-circle"
					)#
					&nbsp;
					<a
						href="mailto:#encodeForHTMLAttribute( rc.comment.getAUthorEmail() )#"
						title="#encodeForHTMLAttribute( rc.comment.getAUthorEmail() )#"
					>
						#encodeForHtml( rc.comment.getAuthor() )#
					</a>
				</div>

				<div class="col-md-6 text-right">
					<cfif len( rc.comment.getAuthorURL() )>
						<div>
							<i class="fa fa-cloud"></i>
							<a
								href="<cfif NOT findnocase( "http", rc.comment.getAuthorURL() )>http://</cfif>#encodeForHTMLAttribute( rc.comment.getAuthorURL() )#"
								title="Open URL"
								target="_blank"
							>
								#encodeForHtml( rc.comment.getAuthorURL() )#
							</a>
						</div>
					</cfif>

					<div>
						<i class="fa fa-laptop"></i>
						<a
							href="#prc.cbSettings.cb_comments_whoisURL#=#rc.comment.getAuthorIP()#"
							title="Get IP Information"
							target="_blank"
						>
							#rc.comment.getAuthorIP()#
						</a>
					</div>
				</div>
			</div>

			<hr/>
			#rc.comment.getDisplayContent()#
		</div>

		<!--- Button Bar --->
		<div class="modal-footer">
			<button class="btn btn-default" onclick="closeRemoteModal()"> Close </button>
		</div>
	</div>
</div>
</cfoutput>