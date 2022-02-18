<cfoutput>
<cfif prc.oCurrentAuthor.checkPermission( "EDITORS_MODIFIERS" )>
	<div class="panel panel-default">

		<div class="panel-heading">
			<h4 class="panel-title">
				<a
					class="accordion-toggle collapsed block"
					data-toggle="collapse"
					data-parent="##accordion"
					href="##modifiers">
					<i class="fas fa-toolbox"></i> Modifiers
				</a>
			</h4>
		</div>

		<div id="modifiers" class="panel-collapse collapse">
			<div class="panel-body">

				<!--- Parent --->
				<div class="form-group">
					<label for="parentContent" class="control-label">
						<i class="fas fa-sitemap"></i>
						Parent:
					</label>
					<select
						name="parentContent"
						id="parentContent"
						class="form-control input-sm"
					>
						<option value="null">- No Parent -</option>
						#html.options(
							values        : prc.allContent,
							column        : "contentID",
							nameColumn    : "slug",
							selectedValue : prc.parentcontentID
						)#
					</select>
				</div>

				<!--- Creator --->
				<cfif prc.oContent.isLoaded() and prc.oCurrentAuthor.checkPermission( "CONTENTSTORE_ADMIN" )>
					<div class="form-group">
						<label for="creatorID" class="control-label">
							<i class="fa fa-user"></i>
							Creator:
						</label>
						<select
							name="creatorID"
							id="creatorID"
							class="form-control input-sm"
						>
							<cfloop array="#prc.authors#" index="author">
								<option
									value="#author.getAuthorID()#"
									<cfif prc.oContent.getCreator().getAuthorID() eq author.getAuthorID()>
										selected="selected"
									</cfif>
								>
									#author.getFullName()#
								</option>
							</cfloop>
						</select>
					</div>
				</cfif>

				<!--- Allow Comments --->
				<cfif prc.cbSiteSettings.cb_comments_enabled and prc.oContent.commentsAllowed()>
					<div class="form-group">
						<label for="allowComments" class="control-label">
							<i class="far fa-comments"></i>
							Allow Comments:
						</label>
						#html.select(
							name          : "allowComments",
							options       : "Yes,No",
							selectedValue : yesNoFormat( prc.oContent.getAllowComments() ),
							class         : "form-control input-sm"
						)#
					</div>
				</cfif>

				<!--- Password Protection --->
				<cfif !prc.oContent.isContentStore()>
					<div class="form-group">
						<label for="passwordProtection">
							<i class="fas fa-key"></i> Password Protection:
						</label>
						#html.textfield(
							name      : "passwordProtection",
							bind      : prc.oContent,
							title     : "Basic Password protect your content, leave empty for none",
							class     : "form-control",
							maxlength : "100"
						)#
					</div>
				</cfif>

				<!--- Retrieval Order --->
				<cfif structKeyExists( prc.oContent, "getOrder" )>
					<div class="form-group">
						<label for="order" class="control-label">
							<i class="fa fa-sort"></i>
							Retrieval Order:
						</label>
						#html.inputfield(
							type        = "number",
							name        = "order",
							bind        = prc.oContent,
							title       = "The ordering index",
							class       = "form-control",
							size        = "5",
							maxlength   = "2",
							min         = "0",
							max         = "2000"
						)#
					</div>
				</cfif>
			</div>
		</div>
	</div>
<cfelse>
	#html.hiddenField( name="parentContent", value=prc.parentcontentID )#
</cfif>
</cfoutput>
