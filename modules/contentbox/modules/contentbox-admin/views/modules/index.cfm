<cfoutput>
<div class="row">
    <div class="col-md-12">
		<h1 class="h1">
			<i class="fa fa-bolt fa-lg"></i> Modules (#arrayLen( prc.modules )#)
		</h1>
    </div>
</div>

<div class="row">
    <div class="col-md-12">
       	<!--- MessageBox --->
		#cbMessageBox().renderit()#
    </div>
</div>

<div class="row">

	<div class="col-md-12">

		<div class="panel panel-default">

			<div class="panel-heading">
				<div class="row">

					<div class="col-md-6 col-xs-4">
						<div class="form-group form-inline no-margin">
							#html.textField(
								name        = "moduleFilter",
								class       = "form-control rounded quicksearch",
								placeholder = "Quick Search"
							)#
						</div>
					</div>

					<div class="col-md-6 col-xs-8">
						<div class="text-right">
							<a
								href="#event.buildLink( prc.xehModuleReset )#"
								title="Deactivate + Rescan"
								class="btn btn-primary text-white"
							>
								<i class="far fa-hdd"></i> Reset
							</a>
							<a
								href="#event.buildLink( prc.xehModuleRescan )#"
								title="Scans For New Modules"
								class="btn btn-primary text-white"
							>
								<i class="fas fa-recycle"></i> Rescan
							</a>
						</div>
					</div>
				</div>
			</div>

		    <div class="panel-body">

				<!--- CategoryForm --->
				#html.startForm( name="moduleForm" )#
					#html.hiddenField( name="moduleName" )#

					<!--- modules --->
					<table name="modules" id="modules" class="table table-striped-removed table-hover " width="100%">
						<thead>
							<tr>
								<th class="text-center" width="50">Type</th>
								<th>Module</th>
								<th>Description</th>
								<th width="100" class="text-center {sorter:false}">Actions</th>
							</tr>
						</thead>
						<tbody>
							<cfloop array="#prc.modules#" index="module">
							<tr <cfif !module.getIsActive()>class="warning"</cfif>>

								<td class="text-center">
									<span class="label label-#( module.getModuleType() eq "core" ? "info" : "success" )#">#module.getModuleType()#</span>
								</td>

								<td>
									<strong>#module.getTitle()#</strong><br/>
									Version #module.getVersion()#
									By <a href="#module.getWebURL()#" target="_blank" title="#module.getWebURL()#">#module.getAuthor()#</a>
								</td>

								<td>
									#module.getDescription()#<br/>
								</td>

								<td class="text-center">
									<div class="btn-group">
										<a class="btn btn-sm btn-info btn-more dropdown-toggle" data-toggle="dropdown" href="##" title="Site Actions">
											<i class="fas fa-ellipsis-v fa-lg"></i>
										</a>
										<ul class="dropdown-menu text-left pull-right">
											<!--- Check if active --->
											<cfif module.getIsActive()>
												<!--- Update Check --->
												<li>
													<a
														class=""
														title="Deactivate Module"
														href="javascript:deactivate( '#JSStringFormat(module.getName())#' )"
													>
														<i class="fa fa-thumbs-down fa-lg"></i> Deactivate
													</a>
												</li>
											<cfelse>
												<li>
													<a
														class=""
														title="Activate Module"
														href="javascript:activate( '#JSStringFormat(module.getName())#') "
													>
														<i class="fa fa-thumbs-up fa-lg"></i> Activate
													</a>
												</li>
												<li>
													<a
														class="confirmIt"
														title="Delete Module"
														href="javascript:remove( '#JSStringFormat(module.getName())#' )"
														data-title="<i class='far fa-trash-alt'></i> Delete #module.getName()#?"
													>
														<i class="far fa-trash-alt fa-lg"></i> Delete
													</a>
												</li>
											</cfif>
										</ul>
									</div>
								</td>
							</tr>
							</cfloop>
						</tbody>
					</table>
				#html.endForm()#

		    </div>
		</div>
	</div>

</div>
</cfoutput>
