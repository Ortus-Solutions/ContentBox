<cfoutput>
<h2>WireBox Mapping For: #rc.id#</h2>
<div>
	<cfdump var="#prc.mapping.getMemento()#" expand="false">
</div>
<!--- Button Bar --->
<div class="text-center form-actions">
	<button class="btn btn-danger" onclick="closeRemoteModal()"> Close </button>
</div>
</cfoutput>