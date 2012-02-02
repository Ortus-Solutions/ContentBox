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
</cfoutput>