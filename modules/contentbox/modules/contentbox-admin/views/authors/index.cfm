<cfoutput>
<div class="row">
	<div class="col-md-12">
		<h1 class="h1">
			<i class="fas fa-user"></i> Users
			<span id="authorCountContainer"></span>
		</h1>
	</div>
</div>

<div class="row">
	<div class="col-md-9">
		<!--- MessageBox --->
		#cbMessageBox().renderit()#

		<!--- Import Log --->
		<cfif flash.exists( "importLog" )>
			<div class="consoleLog">#flash.get( "importLog" )#</div>
		</cfif>

		#html.startForm( name="authorForm", action=prc.xehAuthorRemove )#
			<input type="hidden" name="targetAuthorID" id="targetAuthorID" value="" />

			<div class="panel panel-default">

				<div class="panel-heading">
					<div class="row">

						<!--- Quick Search --->
						<div class="col-md-6 col-xs-4">
							<div class="form-group form-inline no-margin">
								#html.textField(
									name 		= "userSearch",
									class 		= "form-control rounded quicksearch",
									placeholder	= "Quick Search"
								)#
							</div>
						</div>

						<div class="col-md-6 col-xs-8">

							<!--- Actions Bar --->
							<div class="text-right">
								<cfif prc.oCurrentAuthor.checkPermission( "AUTHOR_ADMIN,TOOLS_IMPORT,TOOLS_EXPORT" )>
									<div class="btn-group">

								    	<button class="btn dropdown-toggle btn-info" data-toggle="dropdown">
											Bulk Actions <span class="caret"></span>
										</button>

								    	<ul class="dropdown-menu">

								    		<cfif prc.oCurrentAuthor.checkPermission( "AUTHOR_ADMIN,TOOLS_IMPORT" )>
												<li>
													<a href="javascript:importContent()">
														<i class="fas fa-file-import fa-lg"></i> Import
													</a>
												</li>
											</cfif>

											<cfif prc.oCurrentAuthor.checkPermission( "AUTHOR_ADMIN,TOOLS_EXPORT" )>
												<li>
													<a href="#event.buildLink( prc.xehExportAll )#.json" target="_blank">
														<i class="fas fa-file-export fa-lg"></i> Export All
													</a>
													<li>
														<a href="javascript:exportSelected( '#event.buildLink( prc.xehExportAll )#' )">
															<i class="fas fa-file-export fa-lg"></i> Export Selected
														</a>
													</li>
												</li>
												<li>
													<a 	href="#event.buildLink( prc.xehGlobalPasswordReset )#"
														class="confirmIt"
														data-title="<i class='fa fa-exclamation-triangle'></i> Really issue a global password reset?"
														title="Users will be prompted to change their passwords upon login"
													>
														<i class="fas fa-key fa-lg"></i> Reset All Passwords
													</a>
												</li>
											</cfif>

											<li>
												<a href="javascript:contentShowAll()">
													<i class="fas fa-list fa-lg"></i> Show All
												</a>
											</li>
								    	</ul>
								    </div>
								</cfif>

								<cfif prc.oCurrentAuthor.checkPermission( "AUTHOR_ADMIN" )>
									<button
										class="btn btn-primary"
										onclick="return to('#event.buildLink( prc.xehAuthorCreate )#')"
									>
										Create User
									</button>
								</cfif>

							</div>
						</div>
					</div>
				</div>

				<div class="panel-body">
					<!--- container --->
					<div id="authorTableContainer">
						<p class="text-center">
							<i id="userLoader" class="fa fa-spinner fa-spin fa-lg icon-4x"></i>
						</p>
					</div>
				</div>
			</div>
		#html.endForm()#
	</div>

	<!--- Sidebar Filters --->
	<div class="col-md-3">

		<div class="panel panel-primary">

			<div class="panel-heading">
				<h3 class="panel-title"><i class="fas fa-filter"></i> Filters</h3>
			</div>

			<div class="panel-body">
				<div id="filterBox">
					#html.startForm( name="filterForm", action=prc.xehAuthorSearch, class="form-vertical",role="form" )#
						<!---Status--->
						<div class="form-group">
							<label for="fStatus" class="control-label">Status: </label>
							<select name="fStatus" id="fStatus" class="form-control input-sm">
								<option value="any">Any Status</option>
								<option value="true" selected="selected">Active (#prc.statusReport.active#)</option>
								<option value="false">Deactivated (#prc.statusReport.deactivated#)</option>
							</select>
						</div>

						<!--- 2 Factor Auth --->
						<div class="form-group">
							<label for="f2FactorAuth" class="control-label">2 Factor Auth: </label>
							<select name="f2FactorAuth" id="f2FactorAuth" class="form-control input-sm">
								<option value="any" selected="selected">Any Status</option>
								<option value="true">Active (#prc.statusReport.2FactorAuthEnabled#)</option>
								<option value="false">Deactivated (#prc.statusReport.2FactorAuthDisabled#)</option>
							</select>
						</div>

						<!--- Roles --->
						<div class="form-group">
							<label for="fRole" class="control-label">Roles: </label>
							<select name="fRole" id="fRole" class="form-control input-sm">
								<option value="any">All Roles</option>
								<cfloop array="#prc.aRoles#" index="thisRole">
								<option value="#thisRole.getRoleID()#">#thisRole.getRole()# (#thisRole.getNumberOfAuthors()#)</option>
								</cfloop>
							</select>
						</div>

						<!--- Permission Groups --->
						<div class="form-group">
							<label for="fGroups" class="control-label">Permission Groups: </label>
							<select name="fGroups" id="fGroups" class="form-control input-sm">
								<option value="any">All Groups</option>
								<cfloop array="#prc.aPermissionGroups#" index="thisGroup">
								<option value="#thisGroup.getPermissionGroupID()#">#thisGroup.getName()# (#thisGroup.getNumberOfAuthors()#)</option>
								</cfloop>
							</select>
						</div>

						<!--- Sort By --->
						<div class="form-group">
							<label for="sortOrder" class="control-label">Sort By: </label>
							<select name="sortOrder" id="sortOrder" class="form-control input-sm">
								<option value="name_asc" 			>Name</option>
								<option value="lastLogin_desc" 		>Recent Sign in</option>
								<option value="lastLogin_asc"  		>Oldest Sign in</option>
								<option value="createdDate_desc" 	>Last Created</option>
								<option value="createdDate_asc"   	>Oldest Created</option>
								<option value="modifiedDate_desc" 	>Last Updated</option>
								<option value="modifiedDate_asc"  	>Oldest Updated</option>
							</select>
						</div>

						<div class="text-center">
							<a class="btn btn-sm btn-default" href="javascript:resetFilter( true )">Reset</a>
							<a class="btn btn-primary btn-sm" href="javascript:contentFilter()">Apply</a>
						</div>
					#html.endForm()#
				</div>
			</div>
		</div>
	</div>
</div>

<cfif prc.oCurrentAuthor.checkPermission( "AUTHOR_ADMIN,TOOLS_IMPORT" )>
	#renderView(
		view = "_tags/dialog/import",
		args = {
			title 		: "Import Users",
			contentArea : "user",
			action 		: prc.xehImportAll,
			contentInfo : "Choose the ContentBox <strong>JSON</strong> users file to import."
		},
		prePostExempt = true
	)#
</cfif>
</cfoutput>
