<cfoutput>
<cfif prc.oCurrentAuthor.hasPermission( "EDITORS_MODIFIERS" )>
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
				<div class="form-group">
					<label for="contentTemplate" class="control-label">
						<i class="fa fa-map"></i>
						Content Template:
					</label>
					<cfif prc.availableTemplates.len()>
						<select
							name="contentTemplate"
							id="contentTemplate"
							class="form-control input-sm"
							@change="applyContentTemplate"
						>
								<option value="null">- No Template -</option>
								<cfloop array="#prc.availableTemplates#" item="template" index="i">
									<option value="#template[ "templateID" ]#"<cfif !isNull( prc.oContent.getContentTemplate() ) && prc.oContent.getContentTemplate().getTemplateID() == template[ "templateID" ]> selected</cfif>>
										#template[ "name" ]#
									</option>
								</cfloop>
						</select>
						<p class="text-muted text-center hidden template-highlight-info">
							<span style="width: 10px;height:10px; display:inline-block; margin-right: 10px; border: 1px ##efefef solid" class="template-defined"></span> <small>Template defined fields are shown with this background color.</small>
						</p>
					<cfelse>
						<p class="text-muted text-center">
							No Content Templates are Currently Available
							<br/><br/>
							<a class="btn btn-secondary btn-sm" href="#event.buildLink( prc.xehTemplates & "##create-" & prc.oContent.getContentType() )#" target="_blank">
								#cbAdminComponent( "ui/Icon", { name : "PlusSmall", size : "sm" } )#
								 Create Template</a>
						</p>
					</cfif>

				</div>

				<cfif prc.oContent.getContentType() NEQ "Entry">

					<div class="form-group">
						<label for="childContentTemplate" class="control-label">
							<i class="fa fa-map"></i>
							Child Content Template:
						</label>
						<cfif prc.availableTemplates.len()>
							<select
								name="childContentTemplate"
								id="childContentTemplate"
								class="form-control input-sm"
							>
									<option value="null">- No Template -</option>
									<cfloop array="#prc.availableTemplates#" item="template" index="i">
										<option value="#template[ "templateID" ]#"<cfif !isNull( prc.oContent.getChildContentTemplate() ) && prc.oContent.getChildContentTemplate().getTemplateID() == template[ "templateID" ]> selected</cfif>>
											#template[ "name" ]#
										</option>
									</cfloop>
							</select>
						<cfelse>
							<p class="text-muted text-center">
								No Content Templates are Currently Available
								<br/><br/>
								<a class="btn btn-secondary btn-sm" href="#event.buildLink( prc.xehTemplates & "##create-" & prc.oContent.getContentType() )#" target="_blank">
									#cbAdminComponent( "ui/Icon", { name : "PlusSmall", size : "sm" } )#
									Create Template
								</a>
							</p>
						</cfif>

					</div>
					<!--- Parent --->
					<div class="form-group">
						<label for="parentContent" class="control-label">
							<i class="fa fa-sitemap"></i>
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
				<cfelse>
					<!--- Set to NULL in case this is an entry that accidentally had a parent  --->
					#html.hiddenField( name="parentContent", value="null" )#
				</cfif>

				<!--- Creator --->
				<cfif prc.oContent.isLoaded() and prc.oCurrentAuthor.hasPermission( "CONTENTSTORE_ADMIN,ENTRIES_ADMIN,PAGES_ADMIN" )>
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
							<i class="fa fa-comments"></i>
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
							<i class="fa fa-key"></i> Password Protection:
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
