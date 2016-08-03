<cfoutput>
<div class="row">
    <div class="col-md-12">
        <h1 class="h1"><i class="fa fa-bolt fa-lg"></i> Modules</h1>
    </div>
</div>
<div class="row">
    <div class="col-md-12">
       	<!--- MessageBox --->
		#getModel( "messagebox@cbMessagebox" ).renderit()#

		<!--- Logs --->
		<cfif flash.exists( "forgeboxInstallLog" )>
			<h3>Installation Log</h3>
			<div class="consoleLog">#flash.get( "forgeboxInstallLog" )#</div>
		</cfif>
    </div>
</div>
<div class="row">
	<div class="col-md-9">
		<div class="panel panel-default">
		    <div class="panel-body">
		        <!-- Vertical Nav -->
		        <div class="tab-wrapper tab-primary">
		            <!-- Tabs -->
		            <ul class="nav nav-tabs">
		            	<!--- Manage --->
						<li class="active" title="Manage Modules">
							<a href="##managePane" data-toggle="tab"><i class="fa fa-cog fa-lg"></i> Manage</a>
						</li>
						<cfif prc.oAuthor.checkPermission( "FORGEBOX_ADMIN" )>
						<!--- Install --->
							<li title="Install New Modules">
								<a href="##forgeboxPane" data-toggle="tab" onclick="loadForgeBox()"><i class="fa fa-cloud-download fa-lg"></i> ForgeBox</a>
							</li>
						</cfif>
		            </ul>
		            <!-- End Tabs -->
		            <!-- Tab Content -->
		            <div class="tab-content">
		                <!-- Tab ` -->
		                <div id="managePane" class="tab-pane active">
							<!--- CategoryForm --->
							#html.startForm(name="moduleForm" )#
								#html.hiddenField(name="moduleName" )#
								<!--- Content Bar --->
								<div class="well well-sm">
									<div class="form-group form-inline no-margin">
										#html.textField(
											name="moduleFilter",
											size="30",
											class="form-control",
											placeholder="Quick Search"
										)#
									</div>
								</div>
				
								<!--- modules --->
								<table name="modules" id="modules" class="table table-striped table-hover table-condensed" width="100%">
									<thead>
										<tr>
											<th>Module</th>
											<th>Description</th>
											<th width="100" class="text-center {sorter:false}">Actions</th>
										</tr>
									</thead>
									<tbody>
										<cfloop array="#prc.modules#" index="module">
										<tr <cfif !module.getIsActive()>class="warning"</cfif>>
											<td>
												<strong>#module.getTitle()#</strong><br/>
												Version #module.getVersion()#
												By <a href="#module.getWebURL()#" target="_blank" title="#module.getWebURL()#">#module.getAuthor()#</a>
											</td>
											<td>
												#module.getDescription()#<br/>
												<cfif len( module.getForgeBoxSlug() )>
												ForgeBox URL: <a href="#prc.forgeBoxEntryURL & "/" & module.getForgeBoxSlug()#" target="_blank">#module.getForgeBoxSlug()#</a>
												</cfif>
											</td>
											<td class="text-center">
											<cfif prc.oAuthor.checkPermission( "MODULES_ADMIN" )>
												<div class="btn-group btn-group-sm">
												<!--- Check if active --->
												<cfif module.getIsActive()>
													<!--- Update Check --->
													<a class="btn btn-sm btn-primary" title="Deactivate Module" href="javascript:deactivate('#JSStringFormat(module.getName())#')"><i class="fa fa-thumbs-down fa-lg"></i></a>
													&nbsp;
												<cfelse>
													<a class="btn btn-sm btn-primary" title="Activate Module" href="javascript:activate('#JSStringFormat(module.getName())#')"><i class="fa fa-thumbs-up fa-lg"></i></a>
													&nbsp;
													<!--- Delete Module --->
													<a class="btn btn-sm btn-danger" title="Delete Module" href="javascript:remove('#JSStringFormat(module.getName())#')" class="confirmIt"
														data-title="<i class='fa fa-trash-o'></i> Delete #module.getName()#?"><i class="fa fa-trash-o fa-lg"></i></a>
												</cfif>
												</div>
											</cfif>
											</td>
										</tr>
										</cfloop>
									</tbody>
								</table>
							#html.endForm()#
						</div>
						<!--- end manage pane --->
						<cfif prc.oAuthor.checkPermission( "MODULES_ADMIN" )>
							<!--- ForgeBox --->
							<div id="forgeboxPane" class="tab-pane">
								<div class="text-center">
									<i class="fa fa-spinner fa-spin fa-lg icon-4x"></i><br/>
									Please wait, connecting to ForgeBox...
								</div>
							</div>
						</cfif>
		            </div>
		            <!-- End Tab Content -->
		        </div>
		        <!-- End Vertical Nav -->
		    </div>
		</div>
	</div>
	<div class="col-md-3">
		<cfif prc.oAuthor.checkPermission( "MODULES_ADMIN" )>
			<div class="panel panel-primary">
			    <div class="panel-heading">
			        <h3 class="panel-title"><i class="fa fa-cogs"></i> Module Admin Actions</h3>
			    </div>
			    <div class="panel-body">
			    	<div class="btn-group text-center">
						<a href="#event.buildLink(prc.xehModuleReset)#" title="Deactivate + Rescan" class="btn btn-info"><i class="fa fa-hdd-o"></i> Reset</a>
						<a href="#event.buildLink(prc.xehModuleRescan)#" title="Scans For New Modules" class="btn btn-info"><i class="fa fa-refresh"></i> Rescan</a>
					</div>
			    </div>
			</div>
			<div class="panel panel-primary">
			    <div class="panel-heading">
			        <h3 class="panel-title"><i class="fa fa-upload"></i> Module Uploader</h3>
			    </div>
			    <div class="panel-body">
			    	#html.startForm(
			    		name="moduleUploadForm",
			    		action=prc.xehModuleUpload,
			    		multipart=true,
			    		novalidate="novalidate"
			    	)#
						#getModel( "BootstrapFileUpload@contentbox-admin" ).renderIt( 
							name="fileModule",
							label="Upload Module:",
							columnWidth=2,
							useRemoveButton=false,
							required=true
						)#
		
						<div class="actionBar" id="uploadBar">
							#html.submitButton( value="Upload & Install",class="btn btn-danger" )#
						</div>
						<!--- Loader --->
						<div class="loaders" id="uploadBarLoader">
							<i class="fa fa-spinner fa-spin fa-lg fa-2x"></i> Uploading...
						</div>
					#html.endForm()#
			    </div>
			</div>
		</cfif>
	</div>
</div>
</cfoutput>