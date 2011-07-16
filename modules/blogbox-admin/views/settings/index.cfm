<cfoutput>
<!--============================Sidebar============================-->
<div class="sidebar">
	<!--- Info Box --->
	<div class="small_box">
		<div class="header">
			<img src="#prc.bbroot#/includes/images/settings.png" alt="info" width="24" height="24" />Setting Editor
		</div>
		<div class="body">
			<!--- Create/Edit form --->
			#html.startForm(action=rc.xehSettingSave,name="settingEditor",novalidate="novalidate")#
				<input type="hidden" name="settingID" id="settingID" value="" />
				
				<label for="name">Setting:</label>
				<input name="name" id="name" type="text" required="required" maxlength="100" size="30" class="textfield"/>
				
				<label for="value">Value:</label>
				<textarea name="value" id="value" rows="8" required="required"></textarea>
				
				<div class="actionBar">
					#html.resetButton(name="btnReset",value="Reset",class="button")#
					#html.submitButton(name="btnSave",value="Save",class="button2")#
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
			<img src="#prc.bbroot#/includes/images/database.png" alt="sofa" width="30" height="30" />
			BlogBox Raw Settings Manager
		</div>
		<!--- Body --->
		<div class="body">
			<p>Manage the raw settings at your own risk buddy!</p>
			<!--- MessageBox --->
			#getPlugin("MessageBox").renderit()#
			
			<!--- settingForm --->
			<form name="settingForm" id="settingForm" method="post" action="#event.buildLink(rc.xehSettingRemove)#">
			<input type="hidden" name="settingID" id="settingID" value="" />
			
			<!--- Filter Bar --->
			<div class="filterBar">
				<div>
					#html.label(field="settingFilter",content="Quick Filter:",class="inline")#
					#html.textField(name="settingFilter",size="30",class="textfield")#
				</div>
			</div>
			
			<!--- authors --->
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
						<td>#setting.getValue()#</td>
						<td class="center">
							<!--- Edit Command --->
							<a href="javascript:edit('#setting.getSettingId()#','#setting.getName()#','#JSStringFormat(setting.getValue())#')" title="Edit Setting"><img src="#prc.bbroot#/includes/images/edit.png" alt="edit" border="0" /></a>
							<!--- Delete Command --->
							<a title="Delete Setting" href="javascript:remove('#setting.getsettingID()#')" class="confirmIt" data-title="Delete Setting?"><img id="delete_#setting.getsettingID()#" src="#prc.bbroot#/includes/images/delete.png" border="0" alt="delete"/></a>
						</td>
					</tr>
					</cfloop>
				</tbody>
			</table>
			</form>
		
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