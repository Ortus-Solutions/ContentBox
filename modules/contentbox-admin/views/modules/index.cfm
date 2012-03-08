<cfoutput>
<!--============================Sidebar============================-->
<div class="sidebar">
	<cfif prc.oAuthor.checkPermission("MODULES_ADMIN")>
	<!--- Upload Box --->
	<div class="small_box">
		<div class="header">
			<img src="#prc.cbroot#/includes/images/settings.png" alt="info" width="24" height="24" />Module Uploader
		</div>
		<div class="body">
			#html.startForm(name="moduleUploadForm",action=prc.xehModuleUpload,multipart=true,novalidate="novalidate")#

				#html.fileField(name="fileModule",label="Upload Module: ", class="textfield",required="required")#

				<div class="actionBar" id="uploadBar">
					#html.submitButton(value="Upload & Install",class="buttonred")#
				</div>

				<!--- Loader --->
				<div class="loaders" id="uploadBarLoader">
					<img src="#prc.cbRoot#/includes/images/ajax-loader-blue.gif" alt="loader"/>
				</div>
			#html.endForm()#
		</div>
	</div>
	<!--- Actions Box --->
	<div class="small_box">
		<div class="header">
			<img src="#prc.cbroot#/includes/images/settings.png" alt="info" width="24" height="24" />Module Admin Actions
		</div>
		<div class="body">
			<a href="#event.buildLink(prc.xehModuleReset)#" title="Deactivates, Wipes and Re-Registers All Modules"><button class="button2">Reset Modules</button></a>
			<a href="#event.buildLink(prc.xehModuleRescan)#" title="Rescans the Modules for new registrations"><button class="button2">Rescan Modules</button></a>
		</div>
	</div>
	</cfif>
</div>
<!--End sidebar-->
<!--============================Main Column============================-->
<div class="main_column">
	<div class="box">
		<!--- Body Header --->
		<div class="header">
			<ul class="sub_nav">
				<!--- Manage --->
				<li title="Manage Modules"><a href="##manage" class="current"><img src="#prc.cbroot#/includes/images/settings_black.png" alt="icon" border="0"/> Manage</a></li>
				<cfif prc.oAuthor.checkPermission("MODULES_ADMIN")>
				<!--- Install --->
				<li title="Install New Modules"><a href="##install" onclick="loadForgeBox()"><img src="#prc.cbroot#/includes/images/download.png" alt="icon" border="0"/> ForgeBox</a></li>
				</cfif>
			</ul>
			<img src="#prc.cbroot#/includes/images/ContentBox-Circle_32.png" alt="modules"/>
			Modules
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

			<div class="panes">
				<div id="managePane">
				<!--- CategoryForm --->
				#html.startForm(name="moduleForm")#
				#html.hiddenField(name="moduleName")#

				<!--- Content Bar --->
				<div class="contentBar">
					<!--- Filter Bar --->
					<div class="filterBar">
						<div>
							#html.label(field="moduleFilter",content="Quick Filter:",class="inline")#
							#html.textField(name="moduleFilter",size="30",class="textfield")#
						</div>
					</div>
				</div>

				<!--- modules --->
				<table name="modules" id="modules" class="tablesorter" width="98%">
					<thead>
						<tr>
							<th>Module</th>
							<th>Description</th>
							<th width="75" class="center">Activated</th>
							<th width="100" class="center {sorter:false}">Actions</th>
						</tr>
					</thead>
					<tbody>
						<cfloop array="#prc.modules#" index="module">
						<tr <cfif !module.getIsActive()>class="selected"</cfif>>
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
							<td class="center">
								<cfif module.getIsActive()>
									<img src="#prc.cbRoot#/includes/images/button_ok.png" alt="active" title="Module is active!" />
									<span class="hidden">active</span>
								<cfelse>
									<img src="#prc.cbRoot#/includes/images/button_cancel.png" alt="deactivated" title="Module is not active!" />
									<span class="hidden">deactivated</span>
								</cfif>
							</td>
							<td class="center">
							<cfif prc.oAuthor.checkPermission("MODULES_ADMIN")>

								<cfif len(module.getForgeBoxSlug())>
								<!--- Update Check --->
								<a title="Check For Updates" href="##"><img src="#prc.cbRoot#/includes/images/download_black.png" alt="download" /></a>
								&nbsp;
								</cfif>
								<!--- Check if active --->
								<cfif module.getIsActive()>
									<!--- Update Check --->
									<a title="Deactivate Module" href="javascript:deactivate('#JSStringFormat(module.getName())#')"><img src="#prc.cbRoot#/includes/images/hand_contra.png" alt="deactivate" /></a>
									&nbsp;
								<cfelse>
									<a title="Activate Module" href="javascript:activate('#JSStringFormat(module.getName())#')"><img src="#prc.cbRoot#/includes/images/hand_pro.png" alt="activate" /></a>
									&nbsp;
									<!--- Delete Module --->
									<a title="Delete Module" href="javascript:remove('#JSStringFormat(module.getName())#')" class="confirmIt"
										data-title="Delete #module.getName()#?"><img src="#prc.cbroot#/includes/images/delete.png" border="0" alt="delete"/></a>
									</cfif>
							</cfif>
							</td>
						</tr>
						</cfloop>
					</tbody>
				</table>

				#html.endForm()#
				</div>
				<!--- end manage pane --->

				<cfif prc.oAuthor.checkPermission("MODULES_ADMIN")>
				<!--- ForgeBox --->
				<div id="forgeboxPane">
					<div class="center">
						<img src="#prc.cbRoot#/includes/images/ajax-loader-blue.gif" alt="loader"/><br/>
						Please wait, connecting to ForgeBox...
					</div>
				</div>
				</cfif>

			<!--- end panes --->
		</div>
		<!--- end body --->
	</div>
</div>
</cfoutput>