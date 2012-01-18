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
				<li title="Raw Settings"><a href="##" class="current">Raw Settings</a></li>
				<li title="CacheBox Monitor"><a href="##">CacheBox Monitor</a></li>
			</ul>
			<img src="#prc.cbroot#/includes/images/database.png" alt="sofa" width="30" height="30" />
			ContentBox Raw Geek Settings
		</div>
		<!--- Body --->
		<div class="body">
			<div class="panes">
				<!--- Raw Settings Pane --->
				<div class="clearfix">
					<p>Manage the raw settings at your own risk buddy!</p>
					<!--- MessageBox --->
					#getPlugin("MessageBox").renderit()#
					
					<!--- settingForm --->
					#html.startForm(name="settingForm",action=rc.xehSettingRemove)#
					<input type="hidden" name="settingID" id="settingID" value="" />
					
					<!--- content bar --->
					<div class="contentBar">
						<!--- Flush Cache Button --->
						<div class="buttonBar">
							<button class="button2" onclick="openRemoteModal('#event.buildLink(rc.xehViewCached)#');return false" title="View cached settings">View Cached Settings</button>
							<button class="button2" onclick="return to('#event.buildLink(rc.xehFlushCache)#')" title="Flush the settings cache">Flush Settings Cache</button>
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
					#rc.pagingPlugin.renderit(rc.settingsCount,rc.pagingLink)#
				
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
							<cfloop array="#rc.settings#" index="setting">
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
					#rc.pagingPlugin.renderit(rc.settingsCount,rc.pagingLink)#
				</div>
				
				<!--- CacheBox Pane --->
				<div>
					<cfimport prefix="cachebox" taglib="/coldbox/system/cache/report">
					<cachebox:monitor cacheFactory="#controller.getCacheBox()#" 
									  baseURL="#event.buildLink(prc.xehRawSettings)#"
									  enableMonitor=false/>
				</div>
			</div>
					
			#html.endForm()#			
		</div>	
	</div>
</div>
<!--- Custom JS --->
<script type="text/javascript">
$(document).ready(function() {
	$settingEditor = $("##settingEditor");
	// table sorting + filtering
	$("##settings").tablesorter();
	$("##settingFilter").keyup(function(){
		$.uiTableFilter( $("##settings"), this.value );
	});
	// form validator
	$settingEditor.validator({position:'bottom left'});
	// reset
	$('##btnReset').click(function() {
		$settingEditor.find("##settingID").val( '' );
		$settingEditor.find("##btnSave").val( "Save" );
		$settingEditor.find("##btnReset").val( "Reset" );
	});
});
function edit(settingID,name,value){
	$settingEditor.find("##settingID").val( settingID );
	$settingEditor.find("##name").val( name );
	$settingEditor.find("##value").val( value );
	$settingEditor.find("##btnSave").val( "Update" );
	$settingEditor.find("##btnReset").val( "Cancel" );
}
function remove(settingID){
	var $settingForm = $("##settingForm");
	$settingForm.find("##settingID").val( settingID );
	$settingForm.submit();
}
</script>
</cfoutput>