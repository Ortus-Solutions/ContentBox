<cfoutput>
<div class="row-fluid" id="main-content">   
    <div class="box">
		<!--- Body Header --->
		<div class="header">
			<i class="icon-group"></i>
			Roles
		</div>
		<!--- Body --->
		<div class="body">
			
			<!--- MessageBox --->
			#getPlugin("MessageBox").renderit()#
			
			<!---Import Log --->
			<cfif flash.exists( "importLog" )>
			<div class="consoleLog">#flash.get( "importLog" )#</div>
			</cfif>
			
			<!--- RoleForm --->
			#html.startForm(name="roleForm",action=prc.xehRoleRemove)#
			#html.hiddenField(name="roleID",value="")#
			
			<!--- Content Bar --->
			<div class="well well-small">
				<!--- Command Bar --->
				<cfif prc.oAuthor.checkPermission("ROLES_ADMIN,TOOLS_IMPORT,TOOLS_EXPORT")>
				<div class="pull-right">
					<!---Global --->
					<div class="btn-group">
				    	<a class="btn dropdown-toggle" data-toggle="dropdown" href="##">
							Global Actions <span class="caret"></span>
						</a>
				    	<ul class="dropdown-menu">
				    		<cfif prc.oAuthor.checkPermission("PERMISSIONS_ADMIN,TOOLS_IMPORT")>
				    		<li><a href="javascript:importContent()"><i class="icon-upload-alt"></i> Import</a></li>
							</cfif>
							<cfif prc.oAuthor.checkPermission("PERMISSIONS_ADMIN,TOOLS_EXPORT")>
				    		<li class="dropdown-submenu">
								<a href="##"><i class="icon-download icon-large"></i> Export All</a>
								<ul class="dropdown-menu text-left">
									<li><a href="#event.buildLink(linkto=prc.xehExportAll)#.json" target="_blank"><i class="icon-code"></i> as JSON</a></li>
									<li><a href="#event.buildLink(linkto=prc.xehExportAll)#.xml" target="_blank"><i class="icon-sitemap"></i> as XML</a></li>
								</ul>
							</li>
							</cfif>
				    	</ul>
				    </div>
					<a href="##" onclick="return createRole();" class="btn btn-danger">Create Role</a>
				</div>
				</cfif>
				<!--- Filter Bar --->
				<div class="filterBar">
					<div>
						#html.label(field="roleFilter",content="Quick Filter:",class="inline")#
						#html.textField(name="roleFilter",size="30",class="textfield")#
					</div>
				</div>
			</div>
			
			<!--- Info Bar --->
			<div class="alert">
				<i class="icon-warning-sign icon-large"></i>
				You cannot delete roles that have authors attached to them.  You will need to un-attach those authors from the role first.
			</div>			
			
			<!--- roles --->
			<table name="roles" id="roles" class="tablesorter table table-hover table-striped" width="98%">
				<thead>
					<tr>
						<th>Role</th>
						<th>Description</th>		
						<th width="95" class="center">Permissions</th>
						<th width="95" class="center">Authors</th>
						<th width="150" class="center {sorter:false}">Actions</th>
					</tr>
				</thead>				
				<tbody>
					<cfloop array="#prc.roles#" index="role">
					<tr>
						<td>
							<cfif prc.oAuthor.checkPermission("ROLES_ADMIN")>
							<a href="javascript:edit('#role.getRoleID()#',
							   					 '#HTMLEditFormat( jsstringFormat( role.getRole() ) )#',
							   					 '#HTMLEditFormat( jsstringFormat( role.getDescription() ) )#')" 
							   title="Edit #role.getRole()#">#role.getRole()#</a>
							<cfelse>
								#role.getRole()#
							</cfif>
						</td>
						<td>#role.getDescription()#</td>
						<td class="center"><span class="badge badge-info">#role.getNumberOfPermissions()#</span></td>
						<td class="center"><span class="badge badge-info">#role.getNumberOfAuthors()#</span></td>
						<td class="center">
							<!--- Actions --->
							<div class="btn-group">
								<!--- permissions --->
								<a class="btn" href="javascript:openRemoteModal('#event.buildLink(prc.xehRolePermissions)#', {roleID: '#role.getRoleID()#'} );" title="Manage Permissions"><i class="icon-lock icon-large"></i></a>
								<!--- Actions --->	
						    	<a class="btn dropdown-toggle" data-toggle="dropdown" href="##" title="Role Actions">
									<i class="icon-cogs icon-large"></i>
								</a>
						    	<ul class="dropdown-menu text-left pull-right">
									<cfif prc.oAuthor.checkPermission("ROLES_ADMIN,TOOLS_EXPORT")>
										<!--- Delete Command --->
										<cfif role.getNumberOfAuthors() eq 0>
										<li><a href="javascript:remove('#role.getRoleID()#')" class="confirmIt" data-title="Delete Role?"><i class="icon-trash icon-large" id="delete_#role.getRoleID()#"></i> Delete</a></li>
										</cfif>
										<!--- Edit Command --->
										<li><a href="javascript:edit('#role.getRoleID()#',
									   					 '#HTMLEditFormat( jsstringFormat( role.getRole() ) )#',
									   					 '#HTMLEditFormat( jsstringFormat( role.getDescription() ) )#')"><i class="icon-edit icon-large"></i> Edit</a></li>
									
										<!--- Export --->
										<cfif prc.oAuthor.checkPermission("PERMISSIONS_ADMIN,TOOLS_EXPORT")>
										<li class="dropdown-submenu pull-left">
											<a href="javascript:null"><i class="icon-download icon-large"></i> Export</a>
											<ul class="dropdown-menu text-left">
												<li><a href="#event.buildLink(linkto=prc.xehExport)#/roleID/#role.getRoleID()#.json" target="_blank"><i class="icon-code"></i> as JSON</a></li>
												<li><a href="#event.buildLink(linkto=prc.xehExport)#/roleID/#role.getRoleID()#.xml" target="_blank"><i class="icon-sitemap"></i> as XML</a></li>
											</ul>
										</li>
										</cfif>
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
<cfif prc.oAuthor.checkPermission("ROLES_ADMIN")>
<!--- Role Editor --->
<div id="roleEditorContainer" class="modal hide fade">
	<div id="modalContent">
	<div class="modal-header">
		<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
		<h3>Role Editor</h3>
    </div>
	<!--- Create/Edit form --->
	#html.startForm(action=prc.xehRoleSave,name="roleEditor",novalidate="novalidate",class="form-vertical")#
	<div class="modal-body">
		#html.hiddenField(name="roleID",value="")#
		#html.textField(name="role",label="Role:",required="required",maxlength="255",size="30",class="input-block-level",title="A unique role name",wrapper="div class=controls",labelClass="control-label",groupWrapper="div class=control-group")#
		#html.textArea(name="description",label="Description:",cols="20",rows="3",class="input-block-level",title="A short role description",wrapper="div class=controls",labelClass="control-label",groupWrapper="div class=control-group")#
	</div>
	<!--- Footer --->
	<div class="modal-footer">
		#html.resetButton(name="btnReset",value="Cancel",class="btn", onclick="closeModal( $('##roleEditorContainer') )")#
		#html.submitButton(name="btnSave",value="Save",class="btn btn-danger")#
	</div>
	#html.endForm()#
	</div>
</div>
</cfif>
<cfif prc.oAuthor.checkPermission("PERMISSIONS_ADMIN,TOOLS_IMPORT")>
<!---Import Dialog --->
<div id="importDialog" class="modal hide fade">
	<div id="modalContent">
	    <div class="modal-header">
	        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
	        <h3><i class="icon-copy"></i> Import Roles</h3>
	    </div>
        #html.startForm(name="importForm", action=prc.xehImportAll, class="form-vertical", multipart=true)#
        <div class="modal-body">
			<p>Choose the ContentBox <strong>JSON</strong> roles file to import.</p>
			
			#getMyPlugin( plugin="BootstrapFileUpload", module="contentbox" ).renderIt( 
				name="importFile",
				required=true
			)#
			
			<label for="overrideContent">Override Roles?</label>
			<small>By default all content that exist is not overwritten.</small><br>
			#html.select(options="true,false", name="overrideContent", selectedValue="false", class="input-block-level",wrapper="div class=controls",labelClass="control-label",groupWrapper="div class=control-group")#
			
			<!---Notice --->
			<div class="alert alert-info">
				<i class="icon-info-sign icon-large"></i> Please note that import is an expensive process, so please be patient when importing.
			</div>
		</div>
        <div class="modal-footer">
            <!--- Button Bar --->
        	<div id="importButtonBar">
          		<button class="btn" id="closeButton"> Cancel </button>
          		<button class="btn btn-danger" id="importButton"> Import </button>
            </div>
			<!--- Loader --->
			<div class="center loaders" id="importBarLoader">
				<i class="icon-spinner icon-spin icon-large icon-2x"></i>
				<br>Please wait, doing some hardcore importing action...
			</div>
        </div>
		#html.endForm()#
	</div>
</div>
</cfif>
</cfoutput>