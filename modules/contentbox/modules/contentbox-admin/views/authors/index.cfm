<cfoutput>
<div class="row">
	<div class="col-md-12">
		<h1 class="h1"><i class="fa fa-user"></i> User Management</h1>
	</div>
</div>
<div class="row">
	<div class="col-md-9">
		<!--- MessageBox --->
		#getModel( "messagebox@cbMessagebox" ).renderit()#
		<!---Import Log --->
		<cfif flash.exists( "importLog" )>
			<div class="consoleLog">#flash.get( "importLog" )#</div>
		</cfif>
		#html.startForm( name="authorForm",action=prc.xehAuthorRemove )#
			<input type="hidden" name="authorID" id="authorID" value="" />
			<div class="panel panel-default">
				<div class="panel-heading">
					<div class="row">
						<div class="col-md-6">
							<div class="form-group form-inline no-margin">
								#html.textField(
									name="userSearch", 
									class="form-control",
									placeholder="Quick Search"
								)#
							</div>
						</div>
						<div class="col-md-6">
							<div class="pull-right">
								<cfif prc.oAuthor.checkPermission( "AUTHOR_ADMIN,TOOLS_IMPORT,TOOLS_EXPORT" )>
									<div class="btn-group btn-group-sm">
								    	<a class="btn btn-sm btn-info dropdown-toggle" data-toggle="dropdown" href="##">
											Bulk Actions <span class="caret"></span>
										</a>
								    	<ul class="dropdown-menu">
								    		<cfif prc.oAuthor.checkPermission( "AUTHOR_ADMIN,TOOLS_IMPORT" )>
								    		<li><a href="javascript:importContent()"><i class="fa fa-upload"></i> Import</a></li>
											</cfif>
											<cfif prc.oAuthor.checkPermission( "AUTHOR_ADMIN,TOOLS_EXPORT" )>
												<li><a href="#event.buildLink (linkto=prc.xehExportAll )#.json" target="_blank"><i class="fa fa-download"></i> Export All as JSON</a></li>
												<li><a href="#event.buildLink( linkto=prc.xehExportAll )#.xml" target="_blank"><i class="fa fa-download"></i> Export All as XML</a></li>
											</cfif>
											<li><a href="javascript:contentShowAll()"><i class="fa fa-list"></i> Show All</a></li>
								    	</ul>
								    </div>
								</cfif>
								<cfif prc.oAuthor.checkPermission( "AUTHOR_ADMIN" )>
									<button class="btn btn-sm btn-primary" onclick="return to('#event.buildLink(prc.xehAuthorEditor)#')">Create User</button>
								</cfif>
							</div>
						</div>
					</div>
				</div>
				<div class="panel-body">
					<!--- container --->
					<div id="authorTableContainer">
						<p class="text-center"><i id="userLoader" class="fa fa-spinner fa-spin fa-lg icon-4x"></i>
						</p>
					</div>
				</div>
			</div>
		#html.endForm()#
	</div>
	<div class="col-md-3">
		<div class="panel panel-primary">
			<div class="panel-heading">
				<h3 class="panel-title"><i class="fa fa-filter"></i> Filters</h3>
			</div>
			<div class="panel-body">
				<div id="filterBox">
					#html.startForm(name="filterForm", action=prc.xehAuthorSearch, class="form-vertical",role="form" )#
						<!---Status--->
						<div class="form-group">
							<label for="fStatus" class="control-label">Status: </label>
							<select name="fStatus" id="fStatus" class="form-control input-sm">
								<option value="any">Any Status</option>
								<option value="true">Active</option>
								<option value="false">Deactivated</option>
							</select>
						</div>
						<!--- Roles --->
						<div class="form-group">
							<label for="fRole" class="control-label">Roles: </label>
							<select name="fRole" id="fRole" class="form-control input-sm">
								<option value="any">All Roles</option>
								<cfloop array="#prc.roles#" index="thisRole">
								<option value="#thisRole.getRoleID()#">#thisRole.getRole()#</option>
								</cfloop>
							</select>
						</div>
						<a class="btn btn-info btn-sm" href="javascript:contentFilter()">Apply Filters</a>
						<a class="btn btn-sm btn-default" href="javascript:resetFilter( true )">Reset</a>
					#html.endForm()#
				</div>
			</div>
		</div>
	</div>
</div>

<cfif prc.oAuthor.checkPermission( "AUTHOR_ADMIN,TOOLS_IMPORT" )>
	<cfscript>
		dialogArgs = {
			title 		= "Import Users",
			contentArea = "user",
			action 		= prc.xehImportAll,
			contentInfo = "Choose the ContentBox <strong>JSON</strong> users file to import."
		};
	</cfscript>
	#renderView( view="_tags/dialog/import", args=dialogArgs )#
</cfif>
</cfoutput>