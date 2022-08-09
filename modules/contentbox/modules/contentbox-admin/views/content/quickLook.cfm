<cfoutput>
	<div class="modal-dialog modal-lg" role="document" >

		<div class="modal-content">

			<!--- Header  --->
			<div class="modal-header">

				<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>

				<!--- Status --->
				<div class="float-right mr20 mt5">
					<cfif prc.content.isExpired()>
						<span class="p5 label label-danger">
							Expired on #prc.content.getDisplayExpiredDate()#
						</span>
					<cfelseif prc.content.isPublishedInFuture()>
						<span class="p5 label label-info">
							Publishes on #prc.content.getDisplayPublishedDate()#
						</span>
					<cfelseif prc.content.isContentPublished()>
						<span class="p5 label label-success">
							#getInstance( "Avatar@contentbox" ).renderAvatar(
								email	= prc.content.getAuthorEmail(),
								size	= "20",
								class	= "img img-circle"
							)#
							Published on #prc.content.getDisplayPublishedDate()#
						</span>
					<cfelse>
						<span class="p5 label label-default">
							Draft
						</span>
					</cfif>
				</div>

				<!--- Left Title --->
				<div class="size20">
					<i class="far fa-eye"></i>

					<!--- Content Title --->
					#prc.content.getTitle()#

					<!--- External Link --->
					<cfif prc.content.getContentType() neq "contentstore">
						<a href="#prc.cbHelper.linkContent( prc.content )#" title="Open in Site" target="_blank" class="size14">
							<i class="fas fa-external-link-alt"></i>
						</a>
					</cfif>
				</div>
			</div>

			<div class="modal-body">

				<!--- Info Snapshot --->
				<div class="well well-sm rounded">

					<div class="float-right mt5">
						<a
							href="#event.buildLink( '#prc.cbAdminEntryPoint#.versions.index' )#/contentID/#prc.content.getContentId()#"
							class="btn btn-default btn-sm"
						>
							<i class="fas fa-history"></i> View History
						</a>
					</div>

					<!--- Creator --->
					<div>
						<a
							href="mailto:#prc.content.getCreatorEmail()#"
							class="text-muted"
							title="Created by #prc.content.getCreatorName()#"
						>
							#getInstance( "Avatar@contentbox" ).renderAvatar(
								email	= prc.content.getCreatorEmail(),
								size	= "30",
								class	= "img img-circle"
							)#
							<span class="ml5">
								#prc.content.getCreatorName()#
								created on #prc.content.getDisplayCreatedDate()#
							</span>
						</a>
					</div>

					<!--- Last Edit --->
					<cfif prc.content.getAuthorEmail() neq prc.content.getCreatorEmail()>
						<div class="mt10">
							<a
								href="mailto:#prc.content.getAuthorEmail()#"
								class="text-muted"
								title="Last edit by #prc.content.getAuthorName()#"
							>
								#getInstance( "Avatar@contentbox" ).renderAvatar(
									email	= prc.content.getAuthorEmail(),
									size	= "30",
									class	= "img img-circle"
								)#
								<span class="ml5">
									#prc.content.getAuthorName()#
									edited on #prc.content.getDisplayModifiedDate()#
								</span>
							</a>
						</div>
					</cfif>

					<!--- Changelog --->
					<cfif len( prc.content.getActiveContent().getChangelog() )>
						<div class="mt10 ml5" title="Commit Changelog">
							<i class="fas fa-sticky-note fa-lg mr5"></i> #prc.content.getActiveContent().getChangelog()#
						</div>
					</cfif>

					<!--- Categories --->
					<div class="mt10 ml5" title="Categories">
						<i class="fas fa-tags fa-lg"></i> #prc.content.getCategoriesList()#
					</div>
				</div>

				<div>

					<!--- Nav Tabs --->
					<ul class="nav nav-tabs" role="tablist">
						<li role="presentation" class="active">
							<a href="##preview" aria-controls="preview" role="tab" data-toggle="tab">Preview</a>
						</li>
						<li role="presentation">
							<a href="##code" aria-controls="code" role="tab" data-toggle="tab">Code</a>
						</li>
					</ul>

					<!--- Tab Panes --->
					<div class="tab-content m10">
						<div role="tabpanel" class="tab-pane active" id="preview">
							#prc.content.renderContent()#
						</div>
						<div role="tabpanel" class="tab-pane" id="code">
							<textarea class="form-control" rows="20">#prc.content.getContent()#</textarea>
						</div>
					</div>

				</div>

			</div>

			<!--- Button Bar --->
			<div class="modal-footer">
				<cfif prc.oCurrentAuthor.checkPermission( "PAGES_ADMIN,PAGES_EDITOR" )>
					<a
						class="btn btn-info"
						href="#event.buildLink( prc.xehContentEditor )#/contentID/#prc.content.getContentID()#"
					>
						Edit
					</a>
				</cfif>
				<button class="btn btn-default" onclick="closeRemoteModal()"> Close </button>
			</div>
		</div>
	</div>
</cfoutput>
