<cfoutput>
#html.startForm(name="updateForm",action=prc.xehUpdateApply)#
<h2>Update Check: #rc.channel#</h2>
<div>
	#getPlugin("MessageBox").renderit()#

	<cfif prc.updateFound>
	<h3 class="border_grey">Version Information:</h3>
	<table name="settings" id="settings" class="tablesorter" width="98%">
		<thead>
			<tr>
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
	
	<!--- download URL --->
	#html.hiddenField(name="downloadURL",value=prc.updateEntry.downloadURL)#
	#html.hiddenField(name="version",value=prc.updateEntry.version)#
	
	<h3 class="border_grey">Description:</h3>
	<p>#prc.updateEntry.description#</p>
	
	<cfif len(prc.updateEntry.installInstructions)>
		<h2 class="border_grey">Special Instructions:</h2>
		<p>#prc.updateEntry.InstallInstructions#</p>
	</cfif>
	
	<h3 class="border_grey">Changelog:</h3>
	<p>#prc.updateEntry.changelog#</p>
	
	<div class="infoBar">
		<img src="#prc.cbRoot#/includes/images/info.png" alt="info" />
		Please make sure you do any backups before applying this update.
	</div>
	
	#html.submitButton(name="submitUpdate",class="button2",value="Apply Update",onclick="return confirm('Are you positive?')")#
	</cfif>
	
</div>
<hr/>
#html.endForm()#
<!--- Button Bar --->
<div id="bottomCenteredBar" class="textRight">
	<button class="buttonred" onclick="return closeRemoteModal()"> Close </button>
</div>
</cfoutput>