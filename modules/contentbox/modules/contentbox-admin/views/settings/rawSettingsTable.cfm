<cfoutput>
<!--- settings --->
<table name="settings" id="settings" class="table table-striped-removed table-hover">
	<thead>
		<tr>
			<th id="checkboxHolder" class="{sorter:false} text-center" width="15">
				<input type="checkbox" onClick="checkAll( this.checked, 'settingID' )"/>
			</th>
			<th width="280">Name</th>
			<th width="80">Site</th>
			<th class="text-center" width="25">Core</th>
			<th width="25" class="text-center {sorter:false}">Actions</th>
		</tr>
	</thead>

	<tbody>
		<cfloop array="#prc.settings#" index="setting">
		<tr>
			<!--- check box --->
			<td class="text-center">
				<input
					type="checkbox"
					name="settingID"
					id="settingID"
					value="#setting.getSettingID()#" />
			</td>
			<td>
				<a 	href="javascript:edit(
					'#setting.getSettingId()#',
					'#HTMLEditFormat( setting.getName() )#',
					'#HTMLEditFormat( JSStringFormat( setting.getValue() ) )#',
					#setting.getIsCore()# )"
					title="Edit Setting"
				>
					#setting.getName()#
				</a>

				<div class="mt10">
					<cfif len( setting.getValue() ) gt 90 >
						#html.textarea(
							value 	= setting.getValue(),
							rows 	= "5",
							class 	= "form-control",
							disabled = "true"
						)#
					<cfelse>
						#encodeForHTML( setting.getValue() )#
					</cfif>
				</div>
			</td>

			<td>
				<cfif setting.hasSite()>
					#setting.getSite().getSlug()#
				<cfelse>
					---
				</cfif>
			</td>

			<td class="text-center">
				<cfif setting.getIsCore()>
					<i class="far fa-dot-circle text-success" title="Core Setting"></i>
				<cfelse>
					<i class="far fa-dot-circle text-danger"></i>
				</cfif>
			</td>

			<td class="text-center">
				<div class="btn-group btn-group-sm">

					<!--- Actions --->
					<div class="btn-group btn-group-sm">
						<a class="btn btn-sm btn-default btn-more dropdown-toggle" data-toggle="dropdown" href="##" title="Role Actions">
							<i class="fas fa-ellipsis-v fa-lg"></i>
						</a>
						<ul class="dropdown-menu text-left pull-right">
							<!--- Edit Command --->
							<li>
								<a
									href="javascript:edit(
										'#setting.getSettingId()#',
										'#encodeForHTMLAttribute( setting.getName() )#',
										'#encodeForHTMLAttribute( JSStringFormat( setting.getValue() ) )#',
										#setting.getIsCore() ? 'true' : 'false'#,
										'#setting.getsiteID()#'
									)"
									title="Edit Setting"
								>
									<i class="fas fa-pen fa-lg"></i> Edit
								</a>
							</li>
							<cfif prc.oCurrentAuthor.checkPermission( "TOOLS_EXPORT" )>
								<li>
									<a href="#event.buildLink( prc.xehExport )#/settingID/#setting.getSettingID()#.json" target="_blank">
										<i class="fas fa-file-export fa-lg"></i> Export
									</a>
								</li>
							</cfif>
							<!--- Delete Command --->
							<li>
								<cfif setting.getIsCore()>
									<a
										disabled="disabled"
								<cfelse>
									<a
										class="confirmIt"
										href="javascript:remove( '#setting.getsettingID()#' )"
										title="Delete Setting"
								</cfif>
										data-title="<i class='far fa-trash-alt'></i> Delete Setting?"
									>
										<i class="far fa-trash-alt fa-lg" id="delete_#setting.getsettingID()#"></i> Delete
									</a>
							</li>
						</ul>
					</div>



				</div>
			</td>
		</tr>
		</cfloop>
	</tbody>
</table>

<!--- Paging --->
<cfif !rc.viewAll>
	#prc.oPaging.renderit(
		foundRows 	= prc.settingsCount,
		link 		= prc.pagingLink,
		asList 		= true
	)#
</cfif>
</cfoutput>
