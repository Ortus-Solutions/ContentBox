<cfoutput>
<div class="row">
	<div class="col-md-12">
		<h1 class="h1">
			<i class="fas fa-file-export fa-lg"></i> ContentBox Export
		</h1>
	</div>
</div>

<div class="row">
	<div class="col-md-12">
		#cbMessageBox().renderit()#
	</div>
</div>

<div class="row">
	<div class="col-md-12">

		#html.startForm(
			name       = "exporterForm",
			action     = prc.xehExport,
			novalidate = "novalidate",
			target     = "_blank"
		)#

		<div class="panel panel-default">

				<div class="panel-heading">
					<!--- Title --->
					<div class="size16 p10">
						<i class="fa fa-archive"></i> Box Archives
					</div>
				</div>

				<div class="panel-body">

					<p>
						From this panel you can choose to export your entire ContentBox site or parts of it as a <strong>*.box</strong> archive package.
					</p>

					<div class="row">

						<!--- EVERYTHING --->
						<div class="col-md-6">
							<div class="well well-sm text-center alert-success rounded" style="min-height: 185px">
								<h2>Option ##1: Everything!</h2>
								<small>No mess, no fuss, just a full export of EVERYTHING! </small><br /><br />
								<label class="btn btn-success btn-toggle radio" for="export_everything">
									#html.radioButton(
										name 	= "export_type",
										id 		= "export_everything",
										checked = true,
										value 	= "everything"
									)# Export Everything
								</label>
							</div>
						</div>

						<!--- Mr Picky --->
						<div class="col-md-6">
							<div class="well well-sm text-center rounded" style="min-height: 185px">
								<h2>Option ##2: Mr. Picky</h2>
								<small>For the more discriminating, select only the bits that you want to export.</small><br />
								<label class="btn btn-toggle radio" for="export_selective">
									#html.radioButton(
										name 	= "export_type",
										id 		= "export_selective",
										value 	= "selective"
									)#
									Export a-la-carte
								</label>
							</div>
						</div>
					</div>

					<!--- Mr Picky Controls --->
					<fieldset style="display:none;" id="selective_controls" class="well">
						<div class="row">
							<div class="col-md-3">
								<h4><i class="fa fa-file fa-lg"></i> Pages</h4>
								<small class="muted">Export site pages with comments</small>
							</div>
							<div class="col-md-9">
								<div class="controls checkbox-spacer">
									<label for="export_pages" class="checkbox">
										#html.checkbox( name="export_pages", checked=true )# All Pages (with comments)
									</label>
								</div>
							</div>
						</div>

						<hr>

						<div class="row">
							<div class="col-md-3">
								<h4><i class="fas fa-blog fa-lg"></i> Entries</h4>
								<small class="muted">Export blog entries with comments</small>
							</div>
							<div class="col-md-9">
								<div class="controls checkbox-spacer">
									<label for="export_entries" class="checkbox">
										#html.checkbox( name="export_entries", checked=true )# All Entries (with comments)
									</label>
								</div>
							</div>
						</div>

						<hr>

						<div class="row">
							<div class="col-md-3">
								<h4><i class="fas fa-tags fa-lg"></i> Categories</h4>
								<small class="muted">Export categories</small>
							</div>
							<div class="col-md-9">
								<div class="controls checkbox-spacer">
									<label for="export_categories" class="checkbox">
										#html.checkbox( name="export_categories", checked=true )# All Categories
									</label>
								</div>
							</div>
						</div>

						<hr>

						<div class="row">
							<div class="col-md-3">
								<h4><i class="far fa-hdd fa-lg"></i> Content Store</h4>
								<small class="muted">Export the Content Store</small>
							</div>
							<div class="col-md-9">
								<div class="controls checkbox-spacer">
									<label for="export_contentstore" class="checkbox">
										#html.checkbox( name="export_contentstore", checked=true )# All Content Store
									</label>
								</div>
							</div>
						</div>

						<hr>

						<div class="row">
							<div class="col-md-3">
								<h4><i class="fas fa-bars fa-lg"></i> Menus</h4>
								<small class="muted">Export menus</small>
							</div>
							<div class="col-md-9">
								<div class="controls checkbox-spacer">
									<label for="export_menus" class="checkbox">
										#html.checkbox( name="export_menus", checked=true )# All Menus
									</label>
								</div>
							</div>
						</div>

						<hr>

						<div class="row">
							<div class="col-md-3">
								<h4><i class="fa fa-user fa-lg"></i> Authors</h4>
								<small class="muted">Export all site authors</small>
							</div>
							<div class="col-md-9">
								<div class="controls checkbox-spacer">
									<label for="export_authors" class="checkbox">
										#html.checkbox( name="export_authors", checked=true )# All Authors
									</label>
								</div>
							</div>
						</div>

						<hr>

						<div class="row">
							<div class="col-md-3">
								<h4><i class="fas fa-key fa-lg"></i> Permissions</h4>
								<small class="muted">Export all author permissions</small>
							</div>
							<div class="col-md-9">
								<div class="controls checkbox-spacer">
									<label for="export_permissions" class="checkbox">
										#html.checkbox( name="export_permissions", checked=true )# All Permissions
									</label>
								</div>
							</div>
						</div>

						<hr>

						<div class="row">
							<div class="col-md-3">
								<h4><i class="fas fa-user-shield fa-lg"></i> Roles</h4>
								<small class="muted">Export all author roles</small>
							</div>
							<div class="col-md-9">
								<div class="controls checkbox-spacer">
									<label for="export_roles" class="checkbox">
										#html.checkbox( name="export_roles", checked=true )# All Roles
									</label>
								</div>
							</div>
						</div>

						<hr>

						<div class="row">
							<div class="col-md-3">
								<h4><i class="fas fa-passport fa-lg"></i> Security Rules</h4>
								<small class="muted">Export configured site security rules</small>
							</div>
							<div class="col-md-9">
								<div class="controls checkbox-spacer">
									<label for="export_securityrules" class="checkbox">
										#html.checkbox( name="export_securityrules", checked=true )# All Security Rules
									</label>
								</div>
							</div>
						</div>

						<hr>

						<div class="row">
							<div class="col-md-3">
								<h4><i class="fa fa-wrench fa-lg"></i> Settings</h4>
								<small class="muted">Export all site settings</small>
							</div>
							<div class="col-md-9">
								<div class="controls checkbox-spacer">
									<label for="export_settings" class="checkbox">
										#html.checkbox( name="export_settings", checked=true )# All Settings
									</label>
								</div>
							</div>
						</div>

						<hr>

						<div class="row">
							<div class="col-md-3">
								<h4><i class="fas fa-photo-video fa-lg"></i> Media Library</h4>
								<small class="muted">Export all Media Library content</small>
							</div>
							<div class="col-md-9">
								<div class="controls checkbox-spacer">
									<label for="export_medialibrary" class="checkbox">
										#html.checkbox( name="export_medialibrary", checked=true )# All Media Library
									</label>
								</div>
							</div>
						</div>

						<hr>

						<div class="row">
							<div class="col-md-3">
								<h4><i class="far fa-envelope-open fa-lg"></i> Email Templates</h4>
								<small class="muted">Export all Email Templates</small>
							</div>
							<div class="col-md-9">
								<div class="controls checkbox-spacer">
									<label for="export_emailtemplates" class="checkbox">
										#html.checkbox( name="export_emailtemplates", checked=true )# All Email Templates
									</label>
								</div>
							</div>
						</div>

						<hr>

						<div class="row">
							<div class="col-md-3">
								<h4><i class="fa fa-bolt fa-lg"></i> Custom Modules</h4>
								<div class="checkbox">
									<label class="checkbox" for="toggle_modules">
										#html.checkbox(name="toggle_modules",checked=true,data={togglegroup="export_modules"} )# Toggle All
									</label>
									<small class="muted clearfix">Export modules, all or a-la-carte</small>
								</div>
							</div>
							<div class="col-md-9">
								<div class="controls checkbox-spacer">
									<div class="row">
										<cfset mcounter = 1>
										<cfloop array="#prc.modules#" index="module">
											<div class="col-md-6">
												<cfset name = module.getName()>
												<label for="export_modules_#name#" class="checkbox">#html.checkbox(name="export_modules",id="export_modules_#name#",value="#name#",checked=true,data={alacarte=true} )# #module.getTitle()#</label>
											</div>
											<cfif mcounter MOD 2 eq 0>
												</div>
												<div class="row">
											</cfif>
											<cfset mcounter++>
										</cfloop>

										<cfif !arrayLen( prc.modules )>
											<strong>No custom modules found!</strong>
										</cfif>
									</div>
								</div>
							</div>
						</div>



						<hr>

						<div class="row">

							<div class="col-md-3">
								<h4><i class="fa fa-photo fa-lg"></i> Themes</h4>
								<div class="checkbox">
									<label class="checkbox" for="toggle_layouts">
										#html.checkbox(
											name 	= "toggle_layouts",
											checked = true,
											data 	= { togglegroup="export_layouts" }
										)# Toggle All
									</label>
									<small class="muted clearfix">Export layouts, all or a-la-carte</small>
								</div>
							</div>

							<div class="col-md-9">
								<div class="controls checkbox-spacer">
									<div class="row">
										<cfloop collection="#prc.themes#" item="themeName">
											<cfset thisTheme = prc.themes[ themeName ]>
											<div class="col-md-6">
												<cfset name = thisTheme.name>
												<label for="export_themes_#name#" class="checkbox">
													#html.checkbox(
														name 	= "export_themes",
														id 		= "export_themes_#name#",
														value 	= "#thisTheme.name#",
														checked = true,
														data 	= { alacarte=true }
													)# #name#
												</label>
											</div>
										</cfloop>
										<cfif prc.themes.isEmpty()>
											<strong>No custom themes found!</strong>
										</cfif>
									</div>
								</div>
							</div>
						</div>

						<hr>

						<div class="row">
							<div class="col-md-3">
								<h4><i class="fa fa-magic fa-lg"></i> Custom Widgets</h4>
								<div class="checkbox">
									<label class="checkbox" for="toggle_widgets">
										#html.checkbox( name="toggle_widgets", checked=true, data={ togglegroup="export_widgets" } )# Toggle All
									</label>
									<small class="muted clearfix">Export custom widgets, all or a-la-carte. For layout or module widgets, please export the necessary layout and/or modules.</small>
								</div>
							</div>
							<div class="col-md-9">
								<div class="controls checkbox-spacer">
									<div class="row">
										<cfset counter = 1>
										<!-- Here is the pull request: https://github.com/Ortus-Solutions/ContentBox/pull/383/-->
										<!-- Error when clicking Tools -> Export in the admin -->
										<!-- In CF11 cfloop on query object is not working(query object which is created by using queryNew() function) -->
										<!-- So, instead of cfloop use for() loop in cfscript. Rewrite the set of code in cfscript, previously some part was written in tags and some was in cfscript. -->
										<!-- NOTE: Only for CF11 cfloop is not supporting. -->
										<!-- NOTE: We can revisit the code once CF11 support is dropped. -->
										<!---<cfloop array="#prc.widgets#" index="w">
										<cfif w.widgettype eq "Custom">
											<div class="col-md-6">
												<cfscript>
												try{
													p = prc.widgetService.getWidget( name=w.name, type=w.widgetType );
												} catch( Any e ){
													log.error( 'Error Building #w.toString()#. #e.message# #e.detail#', e );
													writeOutput( "<div class='alert alert-danger'>Error building '#w.name#' widget: #e.message# #e.detail#</div>" );
													continue;
												}
												</cfscript>
												<label for="export_widgets_#w.name#" class="checkbox">
													#html.checkbox(
														name      	= "export_widgets",
														id        	= "export_widgets_#w.name#",
														value 		= "#w.name#",
														checked 	= true,
														data  		= { alacarte = true }
													)# #w.name#
												</label>
											</div>
											<cfif counter MOD 2 eq 0>
												</div>
												<div class="row">
											</cfif>
											<cfset counter++>
										</cfif>
										</cfloop>--->
										<!-- for() loop-->
										<cfscript>
											for (w in prc.widgets){
												if (w.widgettype eq "Custom"){
													writeOutput('<div class="col-md-6">');
														try{
															p = prc.widgetService.getWidget( name=w.name, type=w.widgetType );
														} catch( Any e ){
															log.error( 'Error Building #w.toString()#. #e.message# #e.detail#', e );
															writeOutput( "<div class='alert alert-danger'>Error building '#w.name#' widget: #e.message# #e.detail#</div>" );
															continue;
														}
														writeOutput('<label for="export_widgets_#w.name#" class="checkbox">
															#html.checkbox(
																name      	= "export_widgets",
																id        	= "export_widgets_#w.name#",
																value 		= "#w.name#",
																checked 	= true,
																data  		= { alacarte = true }
															)# #w.name#
														</label>
													</div>');
													if (counter MOD 2 eq 0){
														writeOutput('</div>
														<div class="row">');
													}
													counter++;
												}
											}
										</cfscript>
									</div>
								</div>
							</div>
						</div>

						<hr>

					</fieldset>

					<!--- Submit Button --->
					<div class="actionBar" id="uploadBar">
						<button
							type 	= "button"
							id 		= "previewButton"
							class   = "btn btn-info btn-normal btn-lg"
							onclick = "return previewExport()"
						>
							<i class='fa fa-search'></i> Preview Export
						</button>

						<button
							type 	= "button"
							id 		= "exportButton"
							class   = "btn btn-danger btn-lg"
							onclick = "doExport()"
						>
							<i class='far fa-play-circle' id='export-icon'></i> Start Export
						</button>
					</div>

					<!--- Loader --->
					<div class="loaders" id="uploadBarLoader">
						<i class="fa fa-spinner fa-spin fa-lg icon-4x"></i><br/>
					   <h2> Doing some awesome exporting action, please wait...</h2><br>
					</div>
				</div>
			</div>
		#html.endForm()#

		<!--- Site Generator --->
		#html.startForm(
			name       = "siteGeneratorForm",
			action     = prc.xehSiteGenerator,
			novalidate = "novalidate"
		)#
			<div class="panel panel-default">

				<div class="panel-heading">
					<!--- Title --->
					<div class="size16 p10">
						<i class="fas fa-cloud-download-alt"></i> Static Site Generator
					</div>
				</div>

				<div class="panel-body">
					<p>ContentBox can export your entire site as a static HTML generated site. Please fill out the following options in order to generate your static site.</p>

					<div class="checkbox">
						<label>
							<input type="checkbox" value="true" name="blogContent" checked="checked"> Include Blog Content
						</label>
					</div>

					<!--- Submit Button --->
					<div class="actionBar" id="siteGeneratorBar">
						#html.button(
							type    = "button",
							value   = "<i class='far fa-play-circle' id='export-icon'></i> Start Generation",
							class   = "btn btn-danger btn-lg",
							onclick = "doSiteExport()"
						)#
					</div>

					<!--- Loader --->
					<div class="text-center loaders" id="siteGeneratorLoader">
						<i class="fa fa-spinner fa-spin fa-4x"></i><br/>
						<h2>Building your beautiful static site, please wait...</h2><br>
					</div>

				</div>


			</div>
		#html.endForm()#

	</div>
</div>

<!--- ************************************************************************************************--->
<!---                               EXPORT PREVIEW DIALOG                                             --->
<!--- ************************************************************************************************--->
<div id="exportPreviewDialog" class="modal fade" role="dialog" tabindex="-1">
	<div class="modal-dialog modal-lg">

		<div class="modal-content">

			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
				<h4><i class="fas fa-search"></i> Export Preview</h4>
			</div>

			<div class="modal-body" id="previewBody"></div>
		</div>
	</div>
</div>
</cfoutput>
