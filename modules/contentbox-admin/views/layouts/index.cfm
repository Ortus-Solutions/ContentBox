<cfoutput>
<div class="row">
    <div class="col-md-12">
        <h1 class="h1"><i class="fa fa-picture-o icon-large"></i> Layout Themes</h1>
    </div>
</div>
<div class="row">
    <div class="col-md-12">
       	<!--- MessageBox --->
		#getPlugin("MessageBox").renderit()#
		<!--- Logs --->
		<cfif flash.exists("forgeboxInstallLog")>
			<h3>Installation Log</h3>
			<div class="consoleLog">#flash.get("forgeboxInstallLog")#</div>
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
						<cfif prc.oAuthor.checkPermission("FORGEBOX_ADMIN")>
							<li title="Install New Themes" class="navbar-right">
								<a href="##forgeboxPane"  data-toggle="tab" onclick="loadForgeBox()"><i class="fa fa-cloud-download icon-large"></i> ForgeBox</a>
							</li>
						</cfif>
						<!--- Manage Themes --->
						<li class="active navbar-right" title="Manage Layout Themes">
							<a href="##managePane" data-toggle="tab"><i class="fa fa-cog icon-large"></i> Manage</a>
						</li>
		            </ul>
		            <!-- End Tabs -->
		            <!-- Tab Content -->
		            <div class="tab-content">
		            	<!---Management Pane --->
						<div id="managePane" class="tab-pane active">
							
							<!--- Vertical Nav --->
							<div class="tab-wrapper tab-primary">
								<!--- Layouts Navigation Bar --->
								<ul class="nav nav-tabs">
									<li class="active">
										<a href="##active" data-toggle="tab"><i class="fa fa-star icon-large"></i> Active Layout</a>
									</li>
									<li>
										<a href="##layoutsPane" data-toggle="tab"><i class="fa fa-columns icon-large"></i> Manage Layouts</a>
									</li>
								</ul>
								<!--- Tab Content --->
								<div class="tab-content">
									<!--- Active Layout --->
									<div class="tab-pane active" id="active">
										
										<!---screenshot --->
										<div id="layout-screenshot" class="pull-right">
											<cfif len( prc.activelayout.screenShotURL )>
												<a href="#prc.activelayout.screenShotURL#" target="_blank">
													<img src="#prc.activelayout.screenShotURL#" alt="screenshot" height="200" border="0" class="img-polaroid img-screenshot"/>
												</a>
												<br/>
											</cfif>
										</div>
										
										<!--- Title --->
										<div id="layout-title"><h2>#prc.activeLayout.layoutName#</h2></div>
										<!---Description --->
										<p id="layout-description" class="lead">#prc.activelayout.description#</p>
										<!---Author --->
										<div id="layout-author">
											<i class="fa fa-user"></i>
											<strong>Author: </strong> <a href="#prc.activelayout.authorURL#" title="#prc.activelayout.AuthorURL#" target="_blank">#prc.activelayout.Author#</a>
										</div>
										<!--- Version --->
										<div id="layout-version>">
											<i class="fa fa-clock-o"></i>
											<strong>Version: </strong>
											#prc.activelayout.version#
										</div>
										<!--- Installed --->
										<div id="layout-location>">
											<i class="fa fa-laptop"></i>
											<strong>Installed Location: </strong>
											#prc.activelayout.directory#
										</div>
										
										<!--- ForgeBox Slug --->
										<div id="layout-forgebox>">
											<i class="fa fa-cloud-download"></i>
											<strong>ForgeBox Slug: </strong>
											<cfif len( prc.activelayout.forgeboxSlug )>
												<a href="http://www.coldbox.org/forgebox/view/#prc.activelayout.forgeboxSlug#">#prc.activelayout.forgeboxSlug#</a>
											<cfelse>
												<em>None</em>
											</cfif>
										</div>
										<!---Interceptions --->
										<div id="layout-interceptions">
											<i class="fa fa-bullhorn"></i>
											<strong>Registered Interceptions: </strong> 
											<cfif len( prc.activeLayout.customInterceptionPoints )>
												#prc.activeLayout.customInterceptionPoints#
											<cfelse>
												<em>None</em>
											</cfif>
										</div>
										<!---Widgets --->
										<div id="layout-widgets">
											<i class="fa fa-magic"></i>
											<strong>Layout Widgets: </strong> 
											<cfif len( prc.activeLayout.widgets )>
												#prc.activeLayout.widgets#
											<cfelse>
												<em>None</em>
											</cfif>
										</div>
		                                <!---Layout Settings --->
										<cfif len( prc.activelayout.settings )>
											#html.startForm(action=prc.xehSaveSettings, class="form-vertical")#	
											<br />
											<fieldset>
												<legend> Layout Settings: </legend>
												#html.hiddenField(name="layoutName", value=prc.activelayout.name)#
												#prc.layoutService.buildSettingsForm( prc.activeLayout )#
											</fieldset>
											<br />
											<div class="form-actions">
												#html.submitButton(value="Save Settings", class="btn btn-danger")#
											</div>
			                                #html.endForm()#
										</cfif>
									</div>								
									<!--- Manage Layouts --->
									<div class="tab-pane" id="layoutsPane">
										<!--- Content Bar --->
										<div class="well well-sm">
											<!--- Rebuild Registry Button --->
											<cfif prc.oAuthor.checkPermission("LAYOUT_ADMIN")>
												<div class="btn-group btn-sm pull-right">
													<button class="btn btn-sm btn-primary" onclick="return toggleUploader()" ><i class="fa fa-upload-alt"></i> Upload Layout</button>
													<button class="btn btn-sm btn-primary" onclick="return to('#event.buildLink(prc.xehFlushRegistry)#')" title="Rescan layouts directory and rebuild registry"><i class="fa fa-refresh"></i> Rebuild Registry</button>
												</div>
											</cfif>
											<!--- Filter Bar --->
											<div class="form-group form-inline no-margin">
												#html.textField(
													name="layoutFilter",
													size="30",
													class="form-control",
													placeholder="Quick Filter"
												)#
											</div>
										</div>

										<!--- Uploader --->
										<div id="uploaderBar" class="well well-sm" style="display:none">
											#html.startForm(
												name="layoutUploadForm",
												action=prc.xehlayoutupload,
												multipart=true,
												novalidate="novalidate",
												class="form-vertical"
											)#
												<fieldset>
													<legend>Layout Uploader</legend>
													#getMyPlugin( plugin="BootstrapFileUpload", module="contentbox" ).renderIt( 
														name="fileLayout",
														label="Upload Layout (.zip):",
														required=true
													)#
			    									<div id="uploadBar">
			    										#html.submitButton(
			    											value="Upload & Install",
			    											class="btn btn-danger"
			    										)#
			    									</div>
			    									<div class="loaders" id="uploadBarLoader">
			    										<i class="fa fa-spinner fa-spin icon-large"></i>
			    									</div>
			                                	</fieldset>
											#html.endForm()#
										</div>

										<!--- Layout Form --->
										#html.startForm(name="layoutForm",action=prc.xehlayoutRemove)#
											#html.hiddenField(name="layoutName")#
											<!--- layouts --->
											<table name="layouts" id="layouts" class="table table-striped table-hover" width="100%">
												<thead>
													<tr class="info">
														<th width="200">Theme Info</th>
														<th width="300">Description</th>
														<th>Included Layouts</th>
														<th width="55" class="text-center {sorter:false}">Actions</th>
													</tr>
												</thead>				
												<tbody>
													<cfloop query="prc.layouts">
													<!--- Show only non active layouts --->
													<cfif prc.cbSettings.cb_site_layout eq prc.layouts.name>
														<cfcontinue>
													</cfif>
													<tr>
														<td>
															<cfif prc.cbSettings.cb_site_layout eq prc.layouts.name>
																<i class="fa fa-asterisk icon-large textOrance"></i>
															</cfif>
															<strong>#prc.layouts.layoutName#</strong>
															<br/>	
															Version #prc.layouts.version# by 
															<a href="#prc.layouts.authorURL#" title="#prc.layouts.AuthorURL#" target="_blank">#prc.layouts.Author#</a>
															<br/>
															<!--- Button Bar --->
															<cfif prc.oAuthor.checkPermission("LAYOUT_ADMIN") AND prc.cbSettings.cb_site_layout NEQ prc.layouts.name>
																<div class="btn-group">
																<button class="btn btn-primary" onclick="popup('#event.buildLink(prc.xehPreview)#/l/#prc.layouts.name#/h/#hash(prc.oAuthor.getAuthorID())#');return false;">Preview</button>
																<button class="btn btn-danger" onclick="return to('#event.buildLink(prc.xehActivate)#?layoutname=#prc.layouts.name#')">Activate</button>
																</div>
															</cfif>		
														</td>
														<td>
															<cfif len( prc.layouts.screenShotURL )>
																<!--- image --->
																<a href="#prc.layouts.screenShotURL#" target="_blank">
																	<img src="#prc.layouts.screenShotURL#"  alt="screenshot" class="img-polaroid" width="300" border="0"/>
																</a>
																<br/>
															</cfif>
															<!--- description --->
															#prc.layouts.description#<br/>
															<div class="well well-small">
																Theme located in <em title="#prc.layoutsPath#/#prc.layouts.name#">contentbox-ui/layouts/#prc.layouts.name#</em>
															</div>
														</td>
														<td>
															<ul>
															<cfloop list="#prc.layouts.layouts#" index="thisLayout">
																<li>#thisLayout#</li>
															</cfloop>
															</ul>
														</td>
														<td class="text-center">
															<cfif prc.oAuthor.checkPermission("LAYOUT_ADMIN")>
															<!--- Delete Command --->
															<a href="javascript:remove('#JSStringFormat(prc.layouts.name)#')" 
															   class="confirmIt btn btn-sm btn-danger" data-title="<i class='fa fa-trash-o'></i> Delete layout?" data-message="This will permanently remove all layout associated files!"><i class="fa fa-trash-o icon-large"></i></a>
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
								<i class="fa fa-spinner fa-spin icon-large icon-4x"></i><br/>
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
			<div class="panes tab-content">
				
				

				
			</div>
			<!--- end panes div --->
		</div>	
		<!--- end div body --->
	</div>
	<!--- end div box --->
</div>
</cfoutput>