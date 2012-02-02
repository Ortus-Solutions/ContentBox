<cfoutput>
<div id="versionsPager">
	
	<!--- Loader --->
	<div class="loaders floatRight" id="versionsPagerLoader">
		<img src="#prc.cbRoot#/includes/images/ajax-loader-blue.gif" alt="loader"/>
	</div>
	
	<!--- History --->
	<div class="buttonBar">
		<button class="button2" onclick="return to('##');" title="Open History Panel">View Full History</button>
	</div>

	<p>Here are the last #prc.versionsPager_max# content versions.</p>
	
	#html.startForm(name="versionsPagerForm")#
	
	<table id="versionsHistoryTable" width="100%" class="tablelisting" border="0">
	<thead>
		<tr>
		<th width="50" class="center">Diff</th>
		<th width="50" class="center">Version</th>
		<th width="140" class="center">Date</th>
		<th width="90" class="center">Author</th>
		<th>Comment</th>
		<th width="135" class="center">Actions</th>
	</tr>
	</thead>
	<tbody>
	<cfloop array="#prc.versionsPager_versions#" index="thisVersion">
		<tr data-versionID="#thisVersion.getContentVersionID()#">
			<td>
				<input type="radio" class="rb_oldversion" value="#thisVersion.getVersion()#" name="old_version" id="old_version" <cfif thisVersion.getVersion()>checked="checked"</cfif>>
				<input type="radio" class="rb_version" value="#thisVersion.getVersion()#" name="version" id="version" <cfif thisVersion.getVersion()>checked="checked"</cfif>>
			</td>
			
			<td class="center">
				<a href="javascript:openRemoteModal('#event.buildLink(prc.xehVersionQuickLook)#/versionID/#thisVersion.getContentVersionID()#')">#thisVersion.getContentVersionID()#</a>
				</td>
			<td class="center">#thisVersion.getDisplayCreatedDate()#</td>
			<td class="center"><a href="mailto:#thisVersion.getAuthorEmail()#">#thisVersion.getAuthorName()#</a></td>
			<td>#thisVersion.getChangeLog()#</td>
			
			<td class="center">
				
				<!--- ACTIVE INDICATOR --->
				<cfif thisVersion.getIsActive()>
					<img src="#prc.cbRoot#/includes/images/asterisk_orange.png" alt="active" /> <strong>Active</strong>
				</cfif>
				
				<cfif not thisVersion.getIsActive()>
					<!--- ROLLBACK BUTTON --->
					<a href="##" title="Rollback this version"><img src="#prc.cbRoot#/includes/images/arrow_merge.png" alt="rollback" border="0"/></a>
					
					<!--- DELETE VERSION --->
					<a href="##" title="Remove this version"><img src="#prc.cbRoot#/includes/images/delete.png" alt="delete" border="0" /></a>
				</cfif>
			</td>
		</tr>
	</cfloop>
	</tbody>
	</table>
	
	#html.endForm()#
</div>
<!--- Custom JS --->
<script type="text/javascript">
$(document).ready(function() {
	$versionsPager = $("##versionsHistoryTable");
	$versionsPager.find("tr:even").addClass("even");
	// quick look
	$versionsPager.find("tr").bind("contextmenu",function(e) {
		if (e.which === 3) {
			if( $(this).attr('data-versionID') != null ){
				openRemoteModal('#event.buildLink(prc.xehVersionQuickLook)#/versionID/' + $(this).attr('data-versionID'));
				e.preventDefault();
			}
		}
	});
});
</script>
</cfoutput>