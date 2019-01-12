<cfoutput>
<div class="row">
    <div class="col-md-12">
        <h1 class="h1"><i class="fa fa-bolt fa-lg"></i> Modules</h1>
    </div>
</div>
<div class="row">
    <div class="col-md-12">
       	<!--- MessageBox --->
		#getModel( "messagebox@cbMessagebox" ).renderit()#
    </div>
</div>
<div class="row">
	<div class="col-md-9">
		<div class="panel panel-default">
		    <div class="panel-body">

				<!--- CategoryForm --->
				#html.startForm( name="moduleForm" )#
					#html.hiddenField( name="moduleName" )#

					<!--- Content Bar --->
					<div class="well well-sm">
						<div class="form-group form-inline no-margin">
							#html.textField(
								name        = "moduleFilter",
								size        = "30",
								class       = "form-control",
								placeholder = "Quick Search"
							)#
						</div>
					</div>

					<!--- modules --->
					<table name="modules" id="modules" class="table table-striped table-hover table-condensed" width="100%">
						<thead>
							<tr>
								<th>Module</th>
								<th>Type</th>
								<th>Description</th>
								<th width="100" class="text-center {sorter:false}">Actions</th>
							</tr>
						</thead>
						<tbody>
							<cfloop array="#prc.modules#" index="module">
							<tr <cfif !module.getIsActive()>class="warning"</cfif>>
								<td>
									<strong>#module.getTitle()#</strong><br/>
									Version #module.getVersion()#
									By <a href="#module.getWebURL()#" target="_blank" title="#module.getWebURL()#">#module.getAuthor()#</a>
								</td>

								<td>
									<span class="label label-#( module.getModuleType() eq "core" ? "info" : "success" )#">#module.getModuleType()#</span>
								</td>

								<td>
									#module.getDescription()#<br/>
								</td>

								<td class="text-center">
								<cfif prc.oCurrentAuthor.checkPermission( "MODULES_ADMIN" )>
									<div class="btn-group btn-group-sm">
									<!--- Check if active --->
									<cfif module.getIsActive()>
										<!--- Update Check --->
										<a class="btn btn-sm btn-primary" title="Deactivate Module" href="javascript:deactivate('#JSStringFormat(module.getName())#')"><i class="fa fa-thumbs-down fa-lg"></i></a>
										&nbsp;
									<cfelse>
										<a class="btn btn-sm btn-primary" title="Activate Module" href="javascript:activate('#JSStringFormat(module.getName())#')"><i class="fa fa-thumbs-up fa-lg"></i></a>
										&nbsp;
										<!--- Delete Module --->
										<a class="btn btn-sm btn-danger" title="Delete Module" href="javascript:remove('#JSStringFormat(module.getName())#')" class="confirmIt"
											data-title="<i class='fa fa-trash-o'></i> Delete #module.getName()#?"><i class="fa fa-trash-o fa-lg"></i></a>
									</cfif>
									</div>
								</cfif>
								</td>
							</tr>
							</cfloop>
						</tbody>
					</table>
				#html.endForm()#

		    </div>
		</div>
	</div>


	<div class="col-md-3">
		<cfif prc.oCurrentAuthor.checkPermission( "MODULES_ADMIN" )>
			<div class="panel panel-primary">
			    <div class="panel-heading">
			        <h3 class="panel-title"><i class="fa fa-cogs"></i> Module Admin Actions</h3>
			    </div>
			    <div class="panel-body">
			    	<div class="btn-group text-center">
						<a href="#event.buildLink(prc.xehModuleReset)#" title="Deactivate + Rescan" class="btn btn-info"><i class="fa fa-hdd-o"></i> Reset</a>
						<a href="#event.buildLink(prc.xehModuleRescan)#" title="Scans For New Modules" class="btn btn-info"><i class="fa fa-refresh"></i> Rescan</a>
					</div>
			    </div>
			</div>

		</cfif>
	</div>
</div>
</cfoutput>
