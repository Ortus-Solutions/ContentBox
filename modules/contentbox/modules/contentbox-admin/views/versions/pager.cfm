<cfoutput>
<div id="versionsPager">

	<!--- Loader --->
	<div class="loaders float-right" id="versionsPagerLoader">
		<i class="fa fa-spinner fa-spin fa-lg fa-2x"></i>
	</div>

	<p>
		Here are the past versions of your content. You can compare previous versions and even right click on the rows to get a quick peek at the versioned
	 content.
	</p>

	 <!--- History --->
	<div class="buttonBar">
		<cfif arrayLen( prc.versionsPager_versions ) gt 1>
			<button
				class="btn btn-sm btn-info"
				onclick="return versionsPagerDiff();"
				title="Compare the two selected versions below"
			>
				<i class="far fa-object-ungroup"></i> Compare
			</button>
		</cfif>
		<cfif prc.versionsPager_viewFullHistory>
			<button
				class="btn btn-sm btn-default"
				title="Go to the history visualizer"
				onclick="return accesskey=to('#event.buildLink(prc.xehVersionHistory)#/contentID/#prc.versionsPager_contentID#');"
			>
				<i class="fas fa-history"></i> Full History
			</button>
		</cfif>
	</div>

	#html.startForm(name="versionsPagerForm" )#

	<table id="versionsHistoryTable" width="100%" class="table table-hover  table-striped-removed" border="0">
		<thead>
			<tr>
				<th width="50" class="text-center">Diff</th>
				<th width="50" class="text-center">Version</th>
				<th width="50" class="text-center">Status</th>
				<th width="160" class="text-center">Date</th>
				<th>Changelog</th>
				<th width="100" class="text-center">Actions</th>
			</tr>
		</thead>
		<tbody>
		<cfset activeVersion = 0>
		<cfloop array="#prc.versionsPager_versions#" index="thisVersion">
			<!--- get Active Version --->
			<cfif thisVersion.getIsActive()>
				<cfset activeVersion = thisVersion.getVersion()>
			</cfif>
			<tr id="version_row_#thisVersion.getContentVersionID()#" data-versionID="#thisVersion.getContentVersionID()#">
				<!--- Diff --->
				<td class="text-center">
					<!--- old version --->
					<input
						type="radio"
						class="rb_oldversion"
						value="#thisVersion.getContentVersionID()#"
						name="old_version"
						id="old_version"
						<cfif thisVersion.getVersion() eq ( activeVersion - 1 )>checked="checked"</cfif>
					>
					<!--- current version --->
					<input
						type="radio"
						class="rb_version"
						value="#thisVersion.getContentVersionID()#"
						name="version"
						id="version"
						<cfif thisVersion.getIsActive()>checked="checked"</cfif>
					>
				</td>

				<!--- Version Number --->
				<td class="text-center">
					<a href="javascript:openRemoteModal( '#event.buildLink( prc.xehVersionQuickLook )#/versionID/#thisVersion.getContentVersionID()#')">
						#thisVersion.getVersion()#
					</a>
				</td>

				<!--- Status --->
				<td class="text-center">
					<cfif thisVersion.getIsActive()>
						<i class="far fa-dot-circle fa-lg text-red" title="Active Version"></i>
					<cfelse>
						<i class="far fa-dot-circle fa-lg text-muted" title="Past Version"></i>
					</cfif>
				</td>

				<!--- Created Version Date --->
				<td class="text-center">
					#thisVersion.getDisplayCreatedDate()#
				</td>

				<!--- Author + Changelog --->
				<td>
					#getInstance( "Avatar@contentbox" ).renderAvatar(
						email	= thisVersion.getAuthorEmail(),
						size	= "20",
						class	= "img img-circle"
					)#
					<a href="mailto:#thisVersion.getAuthorEmail()#">#thisVersion.getAuthorName()#</a>

					<div class="mt5">
						#thisVersion.getChangeLog()#
					</div>
				</td>

				<!--- Actions --->
				<td class="text-center">
					<!--- ACTIVE INDICATOR --->
					<cfif thisVersion.getIsActive()>
						<span class="label label-success">Active</span>
					</cfif>

					<cfif not thisVersion.getIsActive()>
						<cfif prc.oCurrentAuthor.checkPermission( "VERSIONS_ROLLBACK" )>
							<!--- ROLLBACK BUTTON --->
							<a
								href="javascript:versionsPagerRollback('#thisVersion.getContentVersionID()#')"
								title="Rollback this version"
								class="confirmIt"
								data-message="Do you really want to rollback to this version?"
							>
								<i class="fas fa-recycle fa-lg" id="version_rollback_#thisVersion.getContentVersionID()#"></i>
							</a>
						</cfif>

						<cfif prc.oCurrentAuthor.checkPermission( "VERSIONS_DELETE" )>
							<!--- DELETE VERSION --->
							<a
								href="javascript:versionsPagerRemove('#thisVersion.getContentVersionID()#')"
								title="Remove this version"
								class="confirmIt ml5"
								data-title="<i class='far fa-trash-alt'></i> Remove Content Version"
								data-message="Do you really want to remove this content version?"
							>
								<i class="far fa-trash-alt fa-lg" id="version_delete_#thisVersion.getContentVersionID()#"></i>
							</a>
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