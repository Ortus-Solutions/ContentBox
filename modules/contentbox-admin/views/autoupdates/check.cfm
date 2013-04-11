<cfoutput>
#html.startForm(name="updateForm",action=prc.xehUpdateApply)#
<h2>Update Check: <span class="label label-inverse">#rc.channel#</span></h2>
<div>
	#getPlugin("MessageBox").renderit()#

	<cfif prc.updateFound>
	<div class="alert alert-info">
	<h3>Version Information:</h3>
	<table name="settings" id="settings" class="table table-striped table-hover table-condensed table-bordered" width="98%">
		<thead>
			<tr class="">
				<th width="100">Your Version</th>
				<th width="100">New Version</th>	
				<th>Update Date</th>
			</tr>
		</thead>
		<tbody>
			<tr>
				<th>#prc.contentboxVersion#</th>
				<th>#prc.updateEntry.version#</th>
				<th>#prc.updateEntry.updateDate#</th>
			</tr>
		</tbody>
	</table>
	</div>
	
	<!--- download URL --->
	#html.hiddenField(name="downloadURL",value=prc.updateEntry.downloadURL)#
	#html.hiddenField(name="version",value=prc.updateEntry.version)#
	
	<div class="alert alert-info">
	<h3>Description:</h3>
	<p>#prc.updateEntry.description#</p>
	</div>
	
	<cfif len(prc.updateEntry.installInstructions)>
	<div class="alert">
		<h3>Special Instructions:</h3>
		<p>#prc.updateEntry.InstallInstructions#</p>	
	</div>
	</cfif>
	
	<div class="alert alert-info">
		<h3>Changelog:</h3>
		<p>#prc.updateEntry.changelog#</p>
	</div>
	
	<div class="form-actions text-center">
		<div class="alert alert-error">
			<i class="icon-warning-sign icon-large"></i>
			Please make sure you do any backups before applying this update.
		</div>
		#html.submitButton(name="submitUpdate",class="btn btn-primary",value="Apply Update",onclick="return confirm('Are you positive?')")#
	</div>
	</cfif>
	
</div>
#html.endForm()#
<!--- Button Bar --->
<p class="form-actions text-center">
	<button class="btn btn-danger" onclick="return closeRemoteModal()"> Close </button>
</p>
</cfoutput>