<cfoutput>
<div id="versionsPager">
	
	<!--- Loader --->
	<div class="loaders floatRight" id="versionsPagerLoader">
		<img src="#prc.cbRoot#/includes/images/ajax-loader-blue.gif" alt="loader"/>
	</div>
	
	<!--- History --->
	<div class="buttonBar">
		<button class="button2" onclick="return to('#event.buildLink(prc.xehVersionHistory)#/contentID/#prc.versionsPager_contentID#');" title="Open History Panel">View Full History</button>
	</div>

	<p>Here are the last #prc.versionsPager_max# content versions out of a total of #prc.versionsPager_count# versions.</p>
	
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
		<tr id="version_row_#thisVersion.getContentVersionID()#" data-versionID="#thisVersion.getContentVersionID()#">
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
					<a href="javascript:versionsPagerRollback('#thisVersion.getContentVersionID()#')" title="Rollback this version"
					   class="confirmIt"
					   data-message="Do you really want to rollback to this version?"><img id="version_rollback_#thisVersion.getContentVersionID()#"  src="#prc.cbRoot#/includes/images/arrow_merge.png" alt="rollback" border="0"/></a>
					
					<!--- DELETE VERSION --->
					<a href="javascript:versionsPagerRemove('#thisVersion.getContentVersionID()#')" title="Remove this version" class="confirmIt"
					   data-title="Remove Content Version"
					   data-message="Do you really want to remove this content version?"><img id="version_delete_#thisVersion.getContentVersionID()#" src="#prc.cbRoot#/includes/images/delete.png" alt="delete" border="0" /></a>
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
function versionsPagerRemove(versionID){
	$('##version_delete_'+versionID).attr('src','#prc.cbRoot#/includes/images/ajax-spinner.gif');
	// ajax remove change
	$.post("#event.buildlink(linkTo=prc.xehVersionRemove)#",{versionID:versionID},function(data){
		if( data ){
			$('##version_row_'+versionID).fadeOut().remove();		
		}
		else{
			alert("Weird error removing version. Please try again or check the logs.");
			$('##version_delete_'+versionID).attr('src','#prc.cbRoot#/includes/images/delete.png');
		}
	},"json");	
}
function versionsPagerRollback(versionID){
	$('##version_rollback_'+versionID).attr('src','#prc.cbRoot#/includes/images/ajax-spinner.gif');
	// ajax rollback change
	$.post("#event.buildlink(linkTo=prc.xehVersionRollback)#",{revertID:versionID},function(data){
		if( data ){
			location.reload();	
		}
		else{
			alert("Weird error rolling back version. Please try again or check the logs.");
			$('##version_rollback_'+versionID).attr('src','#prc.cbRoot#/includes/images/arrow_merge.png');
		}
	},"json");	
}
</script>
</cfoutput>