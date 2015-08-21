<cfoutput>
<div class="row">
    <div class="col-md-12">
        <h1 class="h1"><i class="fa fa-picture-o fa-lg"></i> Themes</h1>
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
						<!--- Install Themes --->
						<cfif prc.oAuthor.checkPermission( "FORGEBOX_ADMIN" )>
							<li title="Install New Themes" class="navbar-right">
								<a href="##forgeboxPane"  data-toggle="tab" onclick="loadForgeBox()"><i class="fa fa-cloud-download fa-lg"></i> ForgeBox</a>
							</li>
						</cfif>
						<!--- Manage Themes --->
						<li class="active navbar-right" title="Manage Themes">
							<a href="##managePane" data-toggle="tab"><i class="fa fa-cog fa-lg"></i> Manage</a>
						</li>
		            </ul>
		            <!-- End Tabs -->
		            <!-- Tab Content -->
		            <div class="tab-content">
		            	<!---Management Pane --->
						<div id="managePane" class="tab-pane active">
							
							<!--- Vertical Nav --->
							<div class="tab-wrapper tab-primary">
								<!--- Themes Navigation Bar --->
								<ul class="nav nav-tabs">
									<li class="active">
										<a href="##active" data-toggle="tab"><i class="fa fa-star fa-lg"></i> Active Theme</a>
									</li>
									<li>
										<a href="##themesPane" data-toggle="tab"><i class="fa fa-columns fa-lg"></i> Manage Themes</a>
									</li>
								</ul>
								<!--- Tab Content --->
								<div class="tab-content">
									<!--- Active Theme --->
									<div class="tab-pane active" id="active">
										
										<!---screenshot --->
										<div id="theme-screenshot" class="pull-right">
											<cfif len( prc.activeTheme.screenShotURL )>
												<a href="#prc.activeTheme.screenShotURL#" target="_blank">
													<img src="#prc.activeTheme.screenShotURL#" alt="screenshot" height="200" border="0" class="img-polaroid img-screenshot"/>
												</a>
												<br/>
											</cfif>
										</div>
										
										<!--- Title --->
										<div id="theme-title"><h2>#prc.activeTheme.themeName#</h2></div>
										<!---Description --->
										<p id="theme-description" class="lead">#prc.activeTheme.description#</p>
										<!---Author --->
										<div id="theme-author">
											<i class="fa fa-user"></i>
											<strong>Author: </strong> <a href="#prc.activeTheme.authorURL#" title="#prc.activeTheme.AuthorURL#" target="_blank">#prc.activeTheme.Author#</a>
										</div>
										<!--- Version --->
										<div id="theme-version>">
											<i class="fa fa-clock-o"></i>
											<strong>Version: </strong>
											#prc.activeTheme.version#
										</div>
										<!--- ForgeBox Slug --->
										<div id="theme-forgebox>">
											<i class="fa fa-cloud-download"></i>
											<strong>ForgeBox Slug: </strong>
											<cfif len( prc.activeTheme.forgeboxSlug )>
												<a href="http://www.coldbox.org/forgebox/view/#prc.activeTheme.forgeboxSlug#">#prc.activeTheme.forgeboxSlug#</a>
											<cfelse>
												<em>None</em>
											</cfif>
										</div>
										<!---Interceptions --->
										<div id="theme-interceptions">
											<i class="fa fa-bullhorn"></i>
											<strong>Registered Interceptions: </strong> 
											<cfif len( prc.activeTheme.customInterceptionPoints )>
												#prc.activeTheme.customInterceptionPoints#
											<cfelse>
												<em>None</em>
											</cfif>
										</div>
										<!---Widgets --->
										<div id="theme-widgets">
											<i class="fa fa-magic"></i>
											<strong>Theme Widgets: </strong> 
											<cfif len( prc.activeTheme.widgets )>
												#prc.activeTheme.widgets#
											<cfelse>
												<em>None</em>
											</cfif>
										</div>
		                                <!---Theme Settings --->
										<cfif len( prc.activeTheme.settings )>
											#html.startForm(action=prc.xehSaveSettings, class="form-vertical" )#	
											<br />
											<fieldset>
												<legend> Theme Settings: </legend>
												#html.hiddenField(name="themeName", value=prc.activeTheme.name)#
												#prc.themeService.buildSettingsForm( prc.activeTheme )#
											</fieldset>
											<br />
											<div class="form-actions">
												#html.submitButton(value="Save Settings", class="btn btn-danger" )#
											</div>
			                                #html.endForm()#
										</cfif>
									</div>								
									<!--- Manage Themes --->
									<div class="tab-pane" id="themesPane">
										<!--- Content Bar --->
										<div class="well well-sm">
											<!--- Rebuild Registry Button --->
											<cfif prc.oAuthor.checkPermission( "THEME_ADMIN" )>
												<div class="btn-group btn-sm pull-right">
													<button class="btn btn-sm btn-primary" onclick="return toggleUploader()" ><i class="fa fa-upload-alt"></i> Upload Theme</button>
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
										#html.startForm(name="themeForm",action=prc.xehThemeRemove)#
											#html.hiddenField(name="themeName" )#
											<!--- themes --->
											<table name="themes" id="themes" class="table table-striped table-hover" width="100%">
												<thead>
													<tr class="info">
														<th width="200">Theme Info</th>
														<th width="300">Description</th>
														<th>Included Themes</th>
														<th width="55" class="text-center {sorter:false}">Actions</th>
													</tr>
												</thead>				
												<tbody>
													<cfloop query="prc.themes">
													<!--- Show only non active themes --->
													<cfif prc.cbSettings.cb_site_theme eq prc.themes.name>
														<cfcontinue>
													</cfif>
													<tr>
														<td>
															<cfif prc.cbSettings.cb_site_theme eq prc.themes.name>
																<i class="fa fa-asterisk fa-lg textOrance"></i>
															</cfif>
															<strong>#prc.themes.themeName#</strong>
															<br/>	
															Version #prc.themes.version# by 
															<a href="#prc.themes.authorURL#" title="#prc.themes.AuthorURL#" target="_blank">#prc.themes.Author#</a>
															<br/>
															<!--- Button Bar --->
															<cfif prc.oAuthor.checkPermission( "THEME_ADMIN" ) AND prc.cbSettings.cb_site_theme NEQ prc.themes.name>
																<div class="btn-group">
																<button class="btn btn-primary" onclick="popup('#event.buildLink(prc.xehPreview)#/l/#prc.themes.name#/h/#hash(prc.oAuthor.getAuthorID())#');return false;">Preview</button>
																<button class="btn btn-danger" onclick="return to('#event.buildLink(prc.xehActivate)#?themeName=#prc.themes.name#')">Activate</button>
																</div>
															</cfif>		
														</td>
														<td>
															<cfif len( prc.themes.screenShotURL )>
																<!--- image --->
																<a href="#prc.themes.screenShotURL#" target="_blank">
																	<img src="#prc.themes.screenShotURL#"  alt="screenshot" class="img-polaroid" width="300" border="0"/>
																</a>
																<br/>
															</cfif>
															<!--- description --->
															#prc.themes.description#<br/>
															<div class="well well-small">
																Theme located in <em title="#prc.themesPath#/#prc.themes.name#">#prc.themesPath#/#prc.themes.name#</em>
															</div>
														</td>
														<td>
															<ul>
															<cfloop list="#prc.themes.layouts#" index="thisLayout">
																<li>#thisLayout#</li>
															</cfloop>
															</ul>
														</td>
														<td class="text-center">
															<cfif prc.oAuthor.checkPermission( "THEME_ADMIN" )>
															<!--- Delete Command --->
															<a href="javascript:remove('#JSStringFormat(prc.themes.name)#')" 
															   class="confirmIt btn btn-sm btn-danger" data-title="<i class='fa fa-trash-o'></i> Delete Theme?" data-message="This will permanently remove all theme associated files!"><i class="fa fa-trash-o fa-lg"></i></a>
															</cfif>
														</td>
													</tr>
													</cfloop>
												</tbody>
											</table>
										#html.endForm()#
									</div>	
									<!--- end manage tab --->
								</div>
								<!--- End Tab cContent --->
							</div>
		                    <!--- End Vertical Tabs --->
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