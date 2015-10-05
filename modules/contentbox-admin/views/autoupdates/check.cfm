<cfoutput>

<div class="modal-header">
    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
	<h3><i class="icon-bolt fa-lg"></i> Update Check: <span class="label label-inverse">#rc.channel#</span></h3>
</div>
<div class="modal-body">
    #html.startForm(name="updateForm",action=prc.xehUpdateApply,class="form-vertical" )#
	#getModel( "messagebox@cbMessagebox" ).renderit()#

	<cfif prc.updateFound>
	#html.startFieldSet(legend="Version Information" )#
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
	#html.endFieldset()#
	
	<!--- download URL --->
	#html.hiddenField(name="downloadURL",value=prc.updateEntry.downloadURL)#
	#html.hiddenField(name="version",value=prc.updateEntry.version)#
	
	#html.startFieldSet(legend="Description" )#
	<p>#prc.updateEntry.description#</p>
	
	<cfif len(prc.updateEntry.installInstructions)>
	<div class="alert">
		<h3>Special Instructions:</h3>
		<p>#prc.updateEntry.InstallInstructions#</p>	
	</div>
	</cfif>
	#html.endFieldSet()#
	
	#html.startFieldSet(legend="Changelog" )#	
	<p>#prc.updateEntry.changelog#</p>
	#html.endFieldSet()#
	
	<div class="form-actions text-center">
		<div class="alert alert-error">
			<i class="icon-warning-sign fa-lg"></i>
			Please make sure you do any backups before applying this update.
		</div>
		#html.button(type="submit", name="submitUpdate", class="btn btn-danger btn-large", value="<i class='icon-ok'></i> Apply Update", onclick="return confirm('Are you positive?')" )#
	</div>
	</cfif>
	#html.endForm()#
</div>
<!--- Button Bar --->
<div class="modal-footer">
	<button class="btn" onclick="return closeRemoteModal()"> Close </button>
</div>
</cfoutput>