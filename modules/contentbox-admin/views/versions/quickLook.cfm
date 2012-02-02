<cfoutput>
<h2>Version: #prc.contentVersion.getVersion()# - Active: #yesNoFormat( prc.contentVersion.getIsActive() )#</h2>
<div>
#prc.contentVersion.renderContent()#
</div>
<hr/>
<!--- Button Bar --->
<div id="bottomCenteredBar" class="textRight">
	<button class="buttonred" onclick="closeRemoteModal()"> Close </button>
</div>
</cfoutput>