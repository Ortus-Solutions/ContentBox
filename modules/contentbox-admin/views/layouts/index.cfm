<cfoutput>
<!--============================Sidebar============================-->
<div class="sidebar">
	<!--- Install Box --->
	<cfif prc.oAuthor.checkPermission("LAYOUT_ADMIN")>
	<div class="small_box">
		<div class="header">
			<img src="#prc.cbroot#/includes/images/settings.png" alt="info" width="24" height="24" />Layout Uploader
		</div>
		<div class="body">
			#html.startForm(name="layoutUploadForm",action=prc.xehlayoutupload,multipart=true,novalidate="novalidate")#
	
				#html.fileField(name="fileLayout",label="Upload Layout (.zip): ", class="textfield",required="required")#		
				
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
	</cfif>
	<!--- Help Box--->
	<div class="small_box" id="help_tips">
		<div class="header">
			<img src="#prc.cbroot#/includes/images/help.png" alt="info" width="24" height="24" />Help Tips
		</div>
		<div class="body">
			<ul class="tipList">
				<li><strong>Preview</strong> only show the index page of the layout</li>
			</ul>
		</div>
	</div>			
</div>
<!--End sidebar-->	
<!--============================Main Column============================-->
<div class="main_column">
	<div class="box">
		<!--- Body Header --->
		<div class="header">
			<ul class="sub_nav">
				<!--- Manage Themes --->
				<li title="Manage Layout Themes"><a href="##manage" class="current"><img src="#prc.cbroot#/includes/images/settings_black.png" alt="icon" border="0"/> Manage</a></li>
				<!--- Install Themes --->
				<li title="Install New Themes"><a href="##install" onclick="loadForgeBox()"><img src="#prc.cbroot#/includes/images/download.png" alt="icon" border="0"/> ForgeBox</a></li>
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
			<div class="panes">
			
				<div id="managePane">
				<!--- CategoryForm --->
				#html.startForm(name="layoutForm",action=prc.xehlayoutRemove)#
				#html.hiddenField(name="layoutName")#
				
				<!--- Content Bar --->
				<div class="contentBar">
					<!--- Flush Cache Button --->
					<cfif prc.oAuthor.checkPermission("LAYOUT_ADMIN")>
					<div class="buttonBar">
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
				
				<img src="#prc.cbRoot#/includes/images/asterisk_orange.png" alt="active" title="Currently Active Layout"/>
				<strong>Active Layout Theme</strong>
				
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
								<cfif prc.oAuthor.checkPermission("LAYOUT_ADMIN")>
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
								<!--- Update Check --->
								<a title="Check For Updates" href="##"><img src="#prc.cbRoot#/includes/images/download_black.png" alt="download" /></a>
								&nbsp;
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
				<!--- end managePane --->

				<!--- ForgeBox --->
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