<cfoutput>
<div class="main">
	<div class="box">
		<!--- Body Header --->
		<div class="header">
			<ul class="sub_nav">
				<!--- Manage Themes --->
				<li title="Manage Layout Themes"><a href="##manage" class="current"><img src="#prc.cbroot#/includes/images/settings_black.png" alt="icon" border="0"/> Manage</a></li>
				<!--- Install Themes --->
				<cfif prc.oAuthor.checkPermission("FORGEBOX_ADMIN")>
				<li title="Install New Themes"><a href="##install" onclick="loadForgeBox()"><img src="#prc.cbroot#/includes/images/download.png" alt="icon" border="0"/> ForgeBox</a></li>
				</cfif>
			</ul>
			<img src="#prc.cbroot#/includes/images/layouts.png" alt="layouts"/>
			Layout Themes
		</div>

		<!--- Body --->
		<div class="body">
			
			<!--- MessageBox --->
			#getPlugin("MessageBox").renderit()#
			<!--- Logs --->
			<cfif flash.exists("forgeboxInstallLog")>
				<h3>Installation Log</h3>
				<div class="consoleLog">#flash.get("forgeboxInstallLog")#</div>
			</cfif>
			
			<!---Tabs --->
			<div class="panes">
				
				<!---Management Pane --->
				<div id="managePane">
					
					<!--- Vertical Nav --->
					<div class="body_vertical_nav clearfix">
						<!--- Layouts Navigation Bar --->
						<ul class="vertical_nav">
							<li class="active"><a href="##active"><img src="#prc.cbRoot#/includes/images/edit.png" alt="modifiers"/> Active Layout</a></li>
							<li><a href="##manage"><img src="#prc.cbRoot#/includes/images/layout.png" alt="modifiers"/> Manage Layouts</a></li>
						</ul>
						<!--- Layout Panes --->
						<div class="main_column">
							<div class="panes_vertical">
								<!--- Active Layout --->
								<div>
									<div id="layout-info">
										<!---screenshot --->
										<div id="layout-screenshot" class="floatRight">
										<cfif len( prc.activelayout.screenShotURL )>
											<a href="#prc.activelayout.screenShotURL#" target="_blank" title="Open screenshot">
												<img src="#prc.activelayout.screenShotURL#"  alt="screenshot" height="200" border="0"/>
											</a>
											<br/>
										</cfif>
										</div>
										
										<!--- Title --->
										<div id="layout-title"><h2>#prc.activeLayout.layoutName#</h2></div>
										<!---Description --->
										<div id="layout-description>">#prc.activelayout.description#</div>
										<!---Author --->
										<div id="layout-author">
											<img src="#prc.cbRoot#/includes/images/gravatar.png" alt="user"/>
											<strong>Author: </strong> <a href="#prc.layouts.authorURL#" title="#prc.layouts.AuthorURL#" target="_blank">#prc.layouts.Author#</a>
										</div>
										<!--- Version --->
										<div id="layout-version>">
											<img src="#prc.cbRoot#/includes/images/old-versions.png" alt="world"/>
											<strong>Version: </strong>
											#prc.activelayout.version#
										</div>
										<!--- Installed --->
										<div id="layout-location>">
											<img src="#prc.cbRoot#/includes/images/parent.png" alt="world"/>
											<strong>Installed Location: </strong>
											#prc.activelayout.directory#
										</div>
										
										<!--- ForgeBox Slug --->
										<div id="layout-forgebox>">
											<img src="#prc.cbRoot#/includes/images/world.png" alt="world"/>
											<strong>ForgeBox Slug: </strong>
											<cfif len( prc.activelayout.forgeboxSlug )>
												<a href="http://www.coldbox.org/forgebox/view/#prc.activelayout.forgeboxSlug#">#prc.activelayout.forgeboxSlug#</a>
											<cfelse>
												<em>None</em>
											</cfif>
										</div>
										<!---Interceptions --->
										<div id="layout-interceptions">
											<img src="#prc.cbRoot#/includes/images/settings_black.png" alt="world"/>
											<strong>Registered Interceptions: </strong> 
											<cfif len( prc.activeLayout.customInterceptionPoints )>
												#prc.activeLayout.customInterceptionPoints#
											<cfelse>
												<em>None</em>
											</cfif>
										</div>
										<!---Widgets --->
										<div id="layout-widgets">
											<img src="#prc.cbRoot#/includes/images/source.png" alt="world"/>
											<strong>Layout Widgets: </strong> 
											<cfif len( prc.activeLayout.widgets )>
												#prc.activeLayout.widgets#
											<cfelse>
												<em>None</em>
											</cfif>
										</div>
									</div>
									
									<div class="clearfix"></div>
									
									<!---Layout Settings --->
									<cfif len( prc.activelayout.settings )>
									<fieldset>
										<legend> Layout Settings: </legend>
										#html.startForm(action=prc.xehSaveSettings)#
										#html.hiddenField(name="layoutName", value=prc.activelayout.name)#
										
										#prc.layoutService.buildSettingsForm( prc.activeLayout )#
										
										<div class="actionBar">
										<br/>
										#html.submitButton(value="Save Settings", class="buttonred")#
										</div>
										
										#html.endForm()#
										
									</fieldset>
									</cfif>
									
								</div>
								
								<!--- Manage Layouts --->
								<div>
									<!--- Layout Form --->
									#html.startForm(name="layoutForm",action=prc.xehlayoutRemove)#
									#html.hiddenField(name="layoutName")#
									
									<!--- Content Bar --->
									<div class="contentBar">
										<!--- Rebuild Registry Button --->
										<cfif prc.oAuthor.checkPermission("LAYOUT_ADMIN")>
										<div class="buttonBar">
											<button class="button2" onclick="return toggleUploader()" title="Upload and install a new layout theme">Upload Layout</button>
											<button class="button2" onclick="return to('#event.buildLink(prc.xehFlushRegistry)#')" title="Rescan layouts directory and rebuild registry">Rebuild Registry</button>
										</div>
										</cfif>
										<!--- Filter Bar --->
										<div class="filterBar">
											<div>
												#html.label(field="layoutFilter",content="Quick Filter:",class="inline")#
												#html.textField(name="layoutFilter",size="30",class="textfield")#
											</div>
										</div>
									</div>
									
									<!--- Uploader --->
									<div id="uploaderBar" class="contentBar" style="display:none">
									#html.startForm(name="layoutUploadForm",action=prc.xehlayoutupload,multipart=true,novalidate="novalidate")#
										<h3>Layout Uploader</h3>
										#html.fileField(name="fileLayout",label="Upload Layout (.zip): ", class="textfield",required="required", size="50")#		
										<div class="actionBar" id="uploadBar">
											#html.submitButton(value="Upload & Install",class="buttonred")#
										</div>
										<div class="loaders" id="uploadBarLoader">
											<img src="#prc.cbRoot#/includes/images/ajax-loader-blue.gif" alt="loader"/>
										</div>
									#html.endForm()#
									</div>
									
									<!--- layouts --->
									<table name="layouts" id="layouts" class="tablesorter" width="98%">
										<thead>
											<tr>
												<th width="200">Theme Info</th>
												<th width="300">Description</th>
												<th>Included Layouts</th>
												<th width="55" class="center {sorter:false}">Actions</th>
											</tr>
										</thead>				
										<tbody>
											<cfloop query="prc.layouts">
											<!--- Show only non active layouts --->
											<cfif prc.cbSettings.cb_site_layout eq prc.layouts.name><cfcontinue></cfif>
											<tr>
												<td>
													<cfif prc.cbSettings.cb_site_layout eq prc.layouts.name>
														<img src="#prc.cbRoot#/includes/images/asterisk_orange.png" alt="active" />
													</cfif>
													<strong>#prc.layouts.layoutName#</strong>
													<br/>	
													Version #prc.layouts.version# by 
													<a href="#prc.layouts.authorURL#" title="#prc.layouts.AuthorURL#" target="_blank">#prc.layouts.Author#</a>
													<br/>
													<!--- Button Bar --->
													<cfif prc.oAuthor.checkPermission("LAYOUT_ADMIN") AND prc.cbSettings.cb_site_layout NEQ prc.layouts.name>
														<button class="button2"   onclick="popup('#event.buildLink(prc.xehPreview)#/l/#prc.layouts.name#/h/#hash(prc.oAuthor.getAuthorID())#');return false;"  title="Preview this layout">Preview</button>
														<button class="buttonred" onclick="return to('#event.buildLink(prc.xehActivate)#?layoutname=#prc.layouts.name#')" title="Activate this layout">Activate</button>
													</cfif>		
												</td>
												<td>
													<cfif len( prc.layouts.screenShotURL )>
														<!--- image --->
														<a href="#prc.layouts.screenShotURL#" target="_blank" title="Open screenshot">
														<img src="#prc.layouts.screenShotURL#"  alt="screenshot" width="300" border="0"/>
														</a>
														<br/>
													</cfif>
													<!--- description --->
													#prc.layouts.description#<br/>
													<div class="contentBar">
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
												<td class="center">
													<cfif prc.oAuthor.checkPermission("LAYOUT_ADMIN")>
													<!--- Delete Command --->
													<a title="Delete layout" href="javascript:remove('#JSStringFormat(prc.layouts.name)#')" 
													   class="confirmIt" data-title="Delete layout?" data-message="This will permanently remove all layout associated files!"><img src="#prc.cbroot#/includes/images/delete.png" border="0" alt="delete"/></a>
													</cfif>
												</td>
											</tr>
											</cfloop>
										</tbody>
									</table>
									#html.endForm()#
								</div>	
								
							</div>
							<!--- end div panes_vertical --->
						</div>
						<!--- end main_column --->
					</div>
				
				
				</div>
				<!--- end managePane --->

				<!--- ForgeBox Pane --->
				<div id="forgeboxPane">
					<div class="center">
						<img src="#prc.cbRoot#/includes/images/ajax-loader-blue.gif" alt="loader"/><br/>
						Please wait, connecting to ForgeBox...
					</div>
				</div>
			</div>
			<!--- end panes div --->
		</div>	
		<!--- end div body --->
	</div>
	<!--- end div box --->
</div>
</cfoutput>