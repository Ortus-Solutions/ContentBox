<cfoutput>
<div id="versionsPager">

	<!--- Loader --->
	<div class="loaders floatRight" id="versionsPagerLoader">
		<i class="fa fa-spinner fa-spin fa-lg fa-2x"></i>
	</div>

	<p>Here are the past versions of your content. You can compare previous versions and even right click on the rows to get a quick peek at the versioned
	 content.  Please also remember that the limit of versions per content
	 object is currently set at <strong>#prc.cbSettings.cb_versions_max_history#</strong>.</p>

	 <!--- History --->
	<div class="buttonBar">
		<cfif arrayLen( prc.versionsPager_versions ) gt 1>
		<button class="btn btn-sm btn-danger" onclick="return versionsPagerDiff();"><i class="icon-exchange"></i> Compare Versions</button>
		</cfif>
		<cfif prc.versionsPager_viewFullHistory>
		<button class="btn btn-sm btn-default" onclick="return accesskey=to('#event.buildLink(prc.xehVersionHistory)#/contentID/#prc.versionsPager_contentID#');"><i class="icon-time"></i> Full History</button>
		</cfif>
	</div>
	
	#html.startForm(name="versionsPagerForm" )#

	<table id="versionsHistoryTable" width="100%" class="tablesorter table table-hover table-condensed table-striped table-bordered" border="0">
		<thead>
			<tr class="info">
				<th width="50" class="text-center">Diff</th>
				<th width="50" class="text-center">Version</th>
				<th width="140" class="text-center">Date</th>
				<th width="90" class="text-center">Author</th>
				<th>Comment</th>
				<th width="135" class="text-center">Actions</th>
			</tr>
		</thead>
		<tbody>
		<cfloop array="#prc.versionsPager_versions#" index="thisVersion">
			<!--- get Active Version --->
			<cfif thisVersion.getIsActive()>
				<cfset activeVersion = thisVersion.getVersion()>
			</cfif>
			<tr id="version_row_#thisVersion.getContentVersionID()#" data-versionID="#thisVersion.getContentVersionID()#">
				<td>
					<!--- old version --->
					<input type="radio" class="rb_oldversion" value="#thisVersion.getContentVersionID()#"
						   name="old_version" id="old_version" <cfif thisVersion.getVersion() eq (activeVersion-1)>checked="checked"</cfif>>
					<!--- current version --->
					<input type="radio" class="rb_version" value="#thisVersion.getContentVersionID()#"
						   name="version" id="version" <cfif thisVersion.getIsActive()>checked="checked"</cfif>>
				</td>
				<td class="text-center">
					<a href="javascript:openRemoteModal('#event.buildLink(prc.xehVersionQuickLook)#/versionID/#thisVersion.getContentVersionID()#')">#thisVersion.getVersion()#</a>
				</td>
				<td class="text-center">#thisVersion.getDisplayCreatedDate()#</td>
				<td class="text-center"><a href="mailto:#thisVersion.getAuthorEmail()#">#thisVersion.getAuthorName()#</a></td>
				<td>#thisVersion.getChangeLog()#</td>

				<td class="text-center">
					<!--- ACTIVE INDICATOR --->
					<cfif thisVersion.getIsActive()>
						<span class="label label-warning">Active</span>
					</cfif>

					<cfif not thisVersion.getIsActive()>
						<cfif prc.oAuthor.checkPermission( "VERSIONS_ROLLBACK" )>
						<!--- ROLLBACK BUTTON --->
						<a href="javascript:versionsPagerRollback('#thisVersion.getContentVersionID()#')" title="Rollback this version"
						   class="confirmIt"
						   data-message="Do you really want to rollback to this version?"><i class="fa fa-refresh fa-lg" id="version_rollback_#thisVersion.getContentVersionID()#"></i></a>
						</cfif>

						<cfif prc.oAuthor.checkPermission( "VERSIONS_DELETE" )>
						<!--- DELETE VERSION --->
						<a href="javascript:versionsPagerRemove('#thisVersion.getContentVersionID()#')" title="Remove this version" class="confirmIt"
						   data-title="<i class='fa fa-trash-o'></i> Remove Content Version"
						   data-message="Do you really want to remove this content version?"><i class="fa fa-trash-o fa-lg" id="version_delete_#thisVersion.getContentVersionID()#"></i></a>
						</cfif>
					</cfif>
				</td>
			</tr>
		</cfloop>
		</tbody>
	</table>

	#html.endForm()#
</div>
</cfoutput>