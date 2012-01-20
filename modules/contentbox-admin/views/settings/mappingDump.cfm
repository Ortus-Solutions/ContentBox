<cfoutput>
<h2>WireBox Mapping For: #rc.id#</h2>
<div>
	<cfdump var="#prc.mapping.getMemento()#" expand="false">
</div>
<hr/>
<!--- Button Bar --->
<div id="bottomCenteredBar" class="textRight">
	<button class="buttonred" onclick="closeRemoteModal()"> Close </button>
</div>
</cfoutput>