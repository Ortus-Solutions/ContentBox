<cfoutput>
<div class="row">
    <div class="col-md-12">
        <h1 class="h1"><i class="fa fa-picture-o fa-lg"></i> Installed Themes</h1>
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
	<div class="col-md-12">
		<div class="panel panel-default">
		    <div class="panel-body">
		       
		       <!-- Vertical Nav -->
		        <div class="tab-wrapper tab-primary">

		            <!-- Tabs -->
		            <ul class="nav nav-tabs">
						<!--- Manage Themes --->
						<li class="active navbar" title="Manage Themes">
							<a href="##managePane" data-toggle="tab"><i class="fa fa-cog fa-lg"></i> Manage</a>
						</li>

						<!--- Install Themes --->
						<cfif prc.oAuthor.checkPermission( "FORGEBOX_ADMIN" )>
							<li title="Install New Themes" class="navbar">
								<a href="##forgeboxPane"  data-toggle="tab" onclick="loadForgeBox()"><i class="fa fa-cloud-download fa-lg"></i> ForgeBox</a>
							</li>
						</cfif>
		            </ul>
		            <!-- End Tabs -->

		            <!-- Tab Content -->
		            <div class="tab-content">
		            	<!---Management Pane --->
						<div id="managePane" class="tab-pane active">
							
								<!--- Content Bar --->
								<div class="well well-sm">
									<!--- Rebuild Registry Button --->
									<cfif prc.oAuthor.checkPermission( "THEME_ADMIN" )>
										<div class="btn-group btn-sm pull-right">
											<button class="btn btn-sm btn-primary" onclick="return toggleUploader()" ><i class="fa fa-upload"></i> Upload Theme</button>
											<button class="btn btn-sm btn-primary" onclick="return to('#event.buildLink(prc.xehFlushRegistry)#')" title="Rescan Themes directory and rebuild registry"><i class="fa fa-refresh"></i> Rebuild Registry</button>
										</div>
									</cfif>
									<!--- Filter Bar --->
									<div class="form-group form-inline no-margin">
										#html.textField(
											name="themeFilter",
											size="30",
											class="form-control",
											placeholder="Quick Filter"
										)#
									</div>
								</div>

								<!--- Uploader --->
								<div id="uploaderBar" class="well well-sm" style="display:none">
									#html.startForm(
										name="themeUploadForm",
										action=prc.xehThemeupload,
										multipart=true,
										novalidate="novalidate",
										class="form-vertical"
									)#
										<fieldset>
											<legend>Theme Uploader</legend>
											#getModel( "BootstrapFileUpload@contentbox-admin" ).renderIt( 
												name="fileTheme",
												label="Upload Theme (.zip):",
												required=true
											)#
	    									<div id="uploadBar">
	    										#html.submitButton(
	    											value="Upload & Install",
	    											class="btn btn-danger"
	    										)#
	    									</div>
	    									<div class="loaders" id="uploadBarLoader">
	    										<i class="fa fa-spinner fa-spin fa-lg"></i>
	    									</div>
	                                	</fieldset>
									#html.endForm()#
								</div>

								<!--- Theme Form --->
								#html.startForm( name="themeForm", action=prc.xehThemeRemove )#
									#html.hiddenField( name="themeName" )#
									<!--- themes --->
									<table name="themes" id="themes" class="table table-striped table-hover table-condensed" width="100%">
										<thead>
											<tr>
												<th width="300">Theme Info</th>
												<th>Description</th>
											</tr>
										</thead>				
										<tbody>
											<cfloop query="prc.themes">
											<tr>
												<td>
													<cfif prc.cbSettings.cb_site_theme eq prc.themes.name>
														<i class="fa fa-asterisk fa-lg text-warning" title="Active Theme"></i>
													</cfif>
													<strong>#prc.themes.themeName#</strong>
													<br/>	
													Version #prc.themes.version# by 
													<a href="#prc.themes.authorURL#" title="#prc.themes.AuthorURL#" target="_blank">#prc.themes.Author#</a>
													
													<p>&nbsp;</p>

													<!--- Button Bar --->
													<div class="btn-group">
														<cfif prc.oAuthor.checkPermission( "THEME_ADMIN" ) AND prc.activeTheme.name NEQ prc.themes.name>
															<button class="btn btn-success btn-sm" onclick="popup('#event.buildLink(prc.xehPreview)#/l/#prc.themes.name#/h/#hash(prc.oAuthor.getAuthorID())#');return false;">
																<i class="fa fa-eye"></i> Preview
															</button>
															<button class="btn btn-primary btn-sm" onclick="return to('#event.buildLink(prc.xehActivate)#?themeName=#prc.themes.name#')">
																<i class="fa fa-bolt"></i> Activate
															</button>
														</cfif>	

														<!--- Delete Command --->
														<cfif prc.oAuthor.checkPermission( "THEME_ADMIN" ) AND prc.themes.name neq prc.activeTheme.name>
															<a href="javascript:remove('#JSStringFormat(prc.themes.name)#')" 
															   class="confirmIt btn btn-sm btn-danger" data-title="<i class='fa fa-trash-o'></i> Delete Theme?" data-message="This will permanently remove all theme associated files!">
															   <i class="fa fa-trash-o fa-lg"></i> Remove
															</a>
														</cfif>
													</div>

												</td>
												<td class="text-center">
													<cfif len( prc.themes.screenShotURL )>
														<!--- image --->
														<a href="#prc.themes.screenShotURL#" target="_blank">
															<img src="#prc.themes.screenShotURL#"  alt="screenshot" class="img-thumbnail" width="300" border="0"/>
														</a>
														<br/>
													</cfif>
													<!--- description --->
													<p>
														#prc.themes.description#
													</p>
												</td>
											</tr>
											</cfloop>
										</tbody>
									</table>
								#html.endForm()#
						</div>
						<!--- end managePane --->
						
		                <!--- ForgeBox Pane --->
						<div id="forgeboxPane" class="tab-pane">
							<div class="text-center">
								<i class="fa fa-spinner fa-spin fa-lg icon-4x"></i><br/>
								Please wait, connecting to ForgeBox...
							</div>
						</div>
		            </div>
		            <!-- End Tab Content -->
		        </div>
		        <!-- End Vertical Nav -->
		    </div>
		</div>
	</div>
</div>
<div class="row-fluid">
	<div class="box">
		<!--- Body --->
		<div class="body">
			<!---Tabs --->
			<div class="panes tab-content"></div>
			<!--- end panes div --->
		</div>	
		<!--- end div body --->
	</div>
	<!--- end div box --->
</div>
</cfoutput>