<cfoutput>
<!--============================Sidebar============================-->
<div class="sidebar">
	<!--- Info Box --->
	<div class="small_box">
		<div class="header">
			<img src="#prc.cbroot#/includes/images/settings.png" alt="info" width="24" height="24" />Setting Editor
		</div>
		<div class="body">
			<p>You can create/edit settings from right here raw style!</p>
			<!--- Create/Edit form --->
			#html.startForm(action=prc.xehSettingsave,name="settingEditor",novalidate="novalidate")#
				<input type="hidden" name="settingID" id="settingID" value="" />
				<input type="hidden" name="page" id="page" value="#rc.page#" />
				
				<label for="name">Setting:</label>
				<input name="name" id="name" type="text" required="required" maxlength="100" size="30" class="textfield"/>
				
				<label for="value">Value:</label>
				<textarea name="value" id="value" rows="4"></textarea>
				
				<div class="actionBar">
					#html.resetButton(name="btnReset",value="Reset",class="button")#
					#html.submitButton(name="btnSave",value="Save",class="buttonred")#
				</div>
			#html.endForm()#
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
				<li title="Raw Settings"><a href="##raw" class="current"><img src="#prc.cbroot#/includes/images/settings_black.png" alt="icon" border="0"/> Raw Settings</a></li>
				<li title="WireBox"><a href="##wirebox"><img src="#prc.cbroot#/includes/images/eye.png" alt="icon" border="0"/> WireBox</a></li>
				<li title="CacheBox Monitor"><a href="##cachebox"><img src="#prc.cbroot#/includes/images/database_black.png" alt="icon" border="0"/> CacheBox</a></li>
			</ul>
			<img src="#prc.cbroot#/includes/images/face-glasses.png" alt="geek" width="30" height="30" />
			Geek Panel (#getSetting('Environment')#)
		</div>
		<!--- Body --->
		<div class="body">
			<!--- MessageBox --->
			#getPlugin("MessageBox").renderit()#
				
			<div class="panes">
				
				<!--- Raw Settings Pane --->
				<div class="clearfix">
					<p>Manage the raw settings at your own risk buddy!</p>
					
					<!--- settingForm --->
					#html.startForm(name="settingForm",action=prc.xehSettingRemove)#
					<input type="hidden" name="settingID" id="settingID" value="" />
					
					<!--- content bar --->
					<div class="contentBar">
						<!--- Flush Cache Button --->
						<div class="buttonBar">
							<button class="button2" onclick="openRemoteModal('#event.buildLink(prc.xehViewCached)#');return false" title="View cached settings">View Cached Settings</button>
							<button class="button2" onclick="return to('#event.buildLink(prc.xehFlushCache)#')" title="Flush the settings cache">Flush Settings Cache</button>
						</div>
						
						<!--- Filter Bar --->
						<div class="filterBar">
							<div>
								#html.label(field="settingFilter",content="Quick Filter:",class="inline")#
								#html.textField(name="settingFilter",size="30",class="textfield")#
							</div>
						</div>
					</div>
					
					<!--- Paging --->
					#prc.pagingPlugin.renderit(prc.settingsCount,prc.pagingLink)#
				
					<!--- settings --->
					<table name="settings" id="settings" class="tablesorter" width="98%">
						<thead>
							<tr>
								<th width="250">Name</th>
								<th>Value</th>			
								<th width="125" class="center {sorter:false}">Actions</th>
							</tr>
						</thead>
						
						<tbody>
							<cfloop array="#prc.settings#" index="setting">
							<tr>
								<td><a href="javascript:edit('#setting.getSettingId()#','#setting.getName()#','#JSStringFormat(setting.getValue())#')" title="Edit Setting">#setting.getName()#</a></td>
								<td>#htmlEditFormat(setting.getValue())#</td>
								<td class="center">
									<!--- Edit Command --->
									<a href="javascript:edit('#setting.getSettingId()#','#setting.getName()#','#JSStringFormat(setting.getValue())#')" title="Edit Setting"><img src="#prc.cbroot#/includes/images/edit.png" alt="edit" border="0" /></a>
									<!--- Delete Command --->
									<a title="Delete Setting" href="javascript:remove('#setting.getsettingID()#')" class="confirmIt" data-title="Delete Setting?"><img id="delete_#setting.getsettingID()#" src="#prc.cbroot#/includes/images/delete.png" border="0" alt="delete"/></a>
								</td>
							</tr>
							</cfloop>
						</tbody>
					</table>
				
					<!--- Paging --->
					#prc.pagingPlugin.renderit(prc.settingsCount,prc.pagingLink)#
					
					#html.endForm()#
				</div>
				
				<!--- WireBox Pane --->
				<div>
					<p>The following are all the objects that are currently in the singleton scope.</p>
					
					#html.startForm(name="singletonForm")#
					
					<!--- content bar --->
					<div class="contentBar">
						<!--- Flush Cache Button --->
						<div class="buttonBar">
							<button class="button2" onclick="return to('#event.buildLink(prc.xehFlushSingletons)#')" title="Clear All Singletons">Clear All Singletons</button>
						</div>
						<!--- Filter Bar --->
						<div class="filterBar">
							<div>
								#html.label(field="singletonsFilter",content="Quick Filter:",class="inline")#
								#html.textField(name="singletonsFilter",size="30",class="textfield")#
							</div>
						</div>
					</div>
					
					<!--- settings --->
					<table name="singletons" id="singletons" class="tablesorter" width="98%">
						<thead>
							<tr>
								<th width="250">ID</th>	
								<th>Path</th>
								<th width="50" class="center {sorter:false}">Actions</th>
							</tr>
						</thead>
						
						<tbody>
							<cfloop collection="#prc.singletons#" item="target">
							<tr>
								<td><strong>#target#</strong></td>
								<td>
									#wirebox.getBinder().getMapping(target).getPath()#
								</td>
								<td class="center">
									<a href="javascript:openRemoteModal('#event.buildLink(prc.xehMappingDump)#', {id:'#target#'})" title="Dump Mapping Memento"><img src="#prc.cbroot#/includes/images/eye.png" alt="icon" border="0"/></a>
								</td>
							</tr>
							</cfloop>
						</tbody>
					</table>
					
					#html.endForm()#
										
				</div>
				
				<!--- CacheBox Pane --->
				<div>
					<cfimport prefix="cachebox" taglib="/coldbox/system/cache/report">
					<cachebox:monitor cacheFactory="#controller.getCacheBox()#" 
									  baseURL="#event.buildLink(prc.xehRawSettings)#"
									  enableMonitor=false/>
				</div>
			</div>
					
						
		</div>	
	</div>
</div>
</cfoutput>