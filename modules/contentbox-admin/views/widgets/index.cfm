<cfoutput>
<!--============================Sidebar============================-->
<div class="sidebar">
	<!--- Info Box --->
	<div class="small_box">
		<cfif prc.oAuthor.checkPermission("WIDGET_ADMIN")>
		<div class="header">
			<img src="#prc.cbroot#/includes/images/settings.png" alt="info" width="24" height="24" />Widget Uploader
		</div>
		<div class="body">
			#html.startForm(name="widgetUploadForm",action=prc.xehWidgetupload,multipart=true,novalidate="novalidate")#

				#html.fileField(name="filePlugin",label="Upload Widget: ", class="textfield",required="required")#

				<div class="actionBar" id="uploadBar">
					#html.submitButton(value="Upload & Install",class="buttonred")#
				</div>

				<!--- Loader --->
				<div class="loaders" id="uploadBarLoader">
					<img src="#prc.cbRoot#/includes/images/ajax-loader-blue.gif" alt="loader"/>
				</div>
			#html.endForm()#
		</div>
		</cfif>
	</div>
</div>
<!--End sidebar-->
<!--============================Main Column============================-->
<div class="main_column">
	<div class="box">
		<!--- Body Header --->
		<div class="header">
			<ul class="sub_nav">
				<!--- Manage --->
				<li title="Manage Widgets"><a href="##manage" class="current"><img src="#prc.cbroot#/includes/images/settings_black.png" alt="icon" border="0"/> Manage</a></li>
				<!--- Install --->
				<li title="Install New Widgets"><a href="##install" onclick="loadForgeBox()"><img src="#prc.cbroot#/includes/images/download.png" alt="icon" border="0"/> ForgeBox</a></li>
			</ul>
			<img src="#prc.cbroot#/includes/images/widgets.png" alt="widgets"/>
			Widgets
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
				#html.startForm(name="widgetForm",action=prc.xehWidgetRemove)#
				#html.hiddenField(name="widgetFile")#
	
				<!--- Content Bar --->
				<div class="contentBar">
					<!--- Create Widget --->
					<div class="buttonBar">
						<button class="button2" onclick="openRemoteModal('#event.buildLink(prc.xehWidgetCreate)#');return false"
								title="Create a spanking new Widget">Create New Widget</button>
					</div>
	
					<!--- Filter Bar --->
					<div class="filterBar">
						<div>
							#html.label(field="widgetFilter",content="Quick Filter:",class="inline")#
							#html.textField(name="widgetFilter",size="30",class="textfield")#
						</div>
					</div>
				</div>
	
				<!--- widgets --->
				<table name="widgets" id="widgets" class="tablesorter" width="98%">
					<thead>
						<tr>
							<th>Widget</th>
							<th>Description</th>
							<th width="100" class="center {sorter:false}">Actions</th>
						</tr>
					</thead>
					<tbody>
						<cfloop query="prc.widgets">
						<cfset p = prc.widgets.plugin>
						<cfif isSimpleValue(p)>
							<tr class="selected">
								<td colspan="4">There is a problem creating widget: '#prc.widgets.name#', please check the application log files.</td>
							</tr>
						<cfelse>
						<tr>
							<td>
								<strong>#p.getPluginName()#</strong><br/>
								Version #p.getPluginVersion()#
								By <a href="#p.getPluginAuthor()#" target="_blank" title="#p.getPluginAuthorURL()#">#p.getPluginAuthor()#</a>
							</td>
							<td>
								#p.getPluginDescription()#<br/>
								<cfif len( p.getForgeBoxSlug() )>
								ForgeBox URL: <a href="#prc.forgeBoxEntryURL & "/" & p.getForgeBoxSlug()#" target="_blank">#p.getForgeBoxSlug()#</a>
								</cfif>
							</td>
							<td class="center">
								<!--- Documentation Icon --->
								<a title="Read Widget Documentation" href="javascript:openRemoteModal('#event.buildLink(prc.xehWidgetDocs)#',{widget:'#urlEncodedFormat(prc.widgets.name)#'})"><img src="#prc.cbRoot#/includes/images/docs_icon.png" alt="docs" /></a>
								&nbsp;
								<cfif prc.oAuthor.checkPermission("WIDGET_ADMIN")>
	
								<cfif len(p.getForgeBoxSlug())>
								<!--- Update Check --->
								<a title="Check For Updates" href="##"><img src="#prc.cbRoot#/includes/images/download_black.png" alt="download" /></a>
								&nbsp;
								</cfif>
								<!--- Editor --->
								<a title="Edit Widget" href="#event.buildLink(linkTo=prc.xehWidgetEditor,queryString='widget=#prc.widgets.name#')#"><img src="#prc.cbRoot#/includes/images/edit.png" alt="edit" /></a>
								&nbsp;
								<!--- Delete Command --->
								<a title="Delete Widget" href="javascript:remove('#JSStringFormat(prc.widgets.name)#')" class="confirmIt"
									data-title="Delete #prc.widgets.name#?"><img src="#prc.cbroot#/includes/images/delete.png" border="0" alt="delete"/></a>
								</cfif>
							</td>
						</tr>
						</cfif>
						</cfloop>
					</tbody>
				</table>
	
				<!--- help bars --->
				<div class="infoBar">
					<img src="#prc.cbRoot#/includes/images/info.png" alt="info" />Use the CB Helper in your layouts by using:
					 ##cb.widget("name",{arg1=val,arg2=val})##
				</div>
				<div class="infoBar">
					<img src="#prc.cbRoot#/includes/images/info.png" alt="info" />Get a widget in your layouts by using:
					 ##cb.getWidget("name")##
				</div>
				#html.endForm()#
				</div>
				<!--- end manage pane --->
				
				<!--- ForgeBox --->
				<div id="forgeboxPane">
					<div class="center">
						<img src="#prc.cbRoot#/includes/images/ajax-loader-blue.gif" alt="loader"/><br/>
						Please wait, connecting to ForgeBox...
					</div>
				</div>
			<!--- end panes --->
		</div>
		<!--- end body --->
	</div>
</div>
</cfoutput>