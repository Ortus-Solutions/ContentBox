<cfoutput>
<!--============================Sidebar============================-->
<div class="sidebar">
	<cfif prc.oAuthor.checkPermission("MODULES_ADMIN")>
	<!--- Upload Box --->
	<div class="small_box">
		<div class="header">
			<i class="icon-upload-alt"></i> Module Uploader
		</div>
		<div class="body">
			#html.startForm(name="moduleUploadForm",action=prc.xehModuleUpload,multipart=true,novalidate="novalidate")#

				#html.fileField(name="fileModule",label="Upload Module: ", class="textfield",required="required")#

				<div class="actionBar" id="uploadBar">
					#html.submitButton(value="Upload & Install",class="btn btn-danger")#
				</div>

				<!--- Loader --->
				<div class="loaders" id="uploadBarLoader">
					<i class="icon-spinner icon-spin icon-large icon-2x"></i>
				</div>
			#html.endForm()#
		</div>
	</div>
	<!--- Actions Box --->
	<div class="small_box">
		<div class="header">
			<i class="icon-cogs"></i> Module Admin Actions
		</div>
		<div class="body">
			<a href="#event.buildLink(prc.xehModuleReset)#" title="Deactivates, Wipes and Re-Registers All Modules"><button class="btn btn-primary">Reset Modules</button></a>
			<a href="#event.buildLink(prc.xehModuleRescan)#" title="Rescans the Modules for new registrations"><button class="btn btn-primary">Rescan Modules</button></a>
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
				<li title="Manage Modules"><a href="##manage" class="current"><i class="icon-cog icon-large"></i> Manage</a></li>
				<cfif prc.oAuthor.checkPermission("FORGEBOX_ADMIN")>
				<!--- Install --->
				<li title="Install New Modules"><a href="##install" onclick="loadForgeBox()"><i class="icon-cloud-download icon-large"></i> ForgeBox</a></li>
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
									<i class="icon-ok icon-large textGreen"></i>
									<span class="hidden">active</span>
								<cfelse>
									<i class="icon-remove icon-large textRed"></i>
									<span class="hidden">deactivated</span>
								</cfif>
							</td>
							<td class="center">
							<cfif prc.oAuthor.checkPermission("MODULES_ADMIN")>

								<cfif !len(module.getForgeBoxSlug())>
								<!--- Update Check --->
								<a title="Check For Updates" href="##"><i class="icon-refresh icon-large"></i></a>
								&nbsp;
								</cfif>
								<!--- Check if active --->
								<cfif module.getIsActive()>
									<!--- Update Check --->
									<a title="Deactivate Module" href="javascript:deactivate('#JSStringFormat(module.getName())#')"><i class="icon-thumbs-down icon-large"></i></a>
									&nbsp;
								<cfelse>
									<a title="Activate Module" href="javascript:activate('#JSStringFormat(module.getName())#')"><i class="icon-thumbs-up icon-large"></i></a>
									&nbsp;
									<!--- Delete Module --->
									<a title="Delete Module" href="javascript:remove('#JSStringFormat(module.getName())#')" class="confirmIt"
										data-title="Delete #module.getName()#?"><i class="icon-remove-sign icon-large"></i></a>
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
						<i class="icon-spinner icon-spin icon-large icon-4x"></i><br/>
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