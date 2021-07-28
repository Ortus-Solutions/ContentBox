<cfoutput>
<cfif prc.oCurrentAuthor.checkPermission( "EDITORS_MODIFIERS" )>
	<div class="panel panel-default">
		<div class="panel-heading">
			<h4 class="panel-title">
				<a class="accordion-toggle collapsed block" data-toggle="collapse" data-parent="##accordion" href="##modifiers">
					<i class="fas fa-toolbox"></i> Modifiers
				</a>
			</h4>
		</div>
		<div id="modifiers" class="panel-collapse collapse">
			<div class="panel-body">

				<!--- Parent Content --->
				<div class="form-group">
					<i class="fas fa-sitemap"></i>
					#html.label( field="parentContent",content='Parent:' )#
					<select name="parentContent" id="parentContent" class="form-control input-sm">
						<option value="null">No Parent</option>
						#html.options(
							values=prc.allContent,
							column="contentID",
							nameColumn="title",
							selectedValue=prc.parentcontentID
						)#>
						#html.options(
							values=prc.allContent,
							column="contentID",
							nameColumn="slug",
							selectedValue=prc.parentcontentID
						)#
					</select>
				</div>

				<!--- Creator --->
				<cfif prc.oContent.isLoaded() and prc.oCurrentAuthor.checkPermission( "CONTENTSTORE_ADMIN" )>
					<div class="form-group">
						<i class="fa fa-user"></i>
						#html.label(field="creatorID",content="Creator:",class="inline" )#
						<select name="creatorID" id="creatorID" class="form-control input-sm">
							<cfloop array="#prc.authors#" index="author">
							<option value="#author.getAuthorID()#" <cfif prc.oContent.getCreator().getAuthorID() eq author.getAuthorID()>selected="selected"</cfif>>#author.getFullName()#</option>
							</cfloop>
						</select>
					</div>
				</cfif>

				<!--- Retrieval Order --->
				<div class="form-group">
					<i class="fa fa-sort"></i>
					<!--- menu order --->
					#html.inputfield(
						type        = "number",
						label       = "Retrieval Order: (0-99)",
						name        = "order",
						bind        = prc.oContent,
						title       = "The ordering index used when retrieving content store items",
						class       = "form-control",
						size        = "5",
						maxlength   = "2",
						min         = "0",
						max         = "99"
					)#
				</div>
			</div>
		</div>
	</div>
	<cfelse>
		#html.hiddenField( name="parentContent", value=prc.parentcontentID )#
	</cfif>
</cfoutput>