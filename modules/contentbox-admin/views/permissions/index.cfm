<cfoutput>
<div class="row-fluid" id="main-content">
	<div class="box">
		<!--- Body Header --->
		<div class="header">
			<i class="icon-lock icon-large"></i>
			Permissions
		</div>
		
		<!--- Body --->
		<div class="body">
			
			<!--- MessageBox --->
			#getPlugin("MessageBox").renderit()#
			
			<!---Import Log --->
			<cfif flash.exists( "importLog" )>
			<div class="consoleLog">#flash.get( "importLog" )#</div>
			</cfif>
			
			<!--- PermissionForm --->
			#html.startForm(name="permissionForm",action=prc.xehPermissionRemove)#
			#html.hiddenField(name="permissionID",value="")#
			
			<!--- Content Bar --->
			<div class="well well-small">
				<!--- Command Bar --->
				<cfif prc.oAuthor.checkPermission("PERMISSIONS_ADMIN,TOOLS_IMPORT,TOOLS_EXPORT")>
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
					<a href="##" onclick="return createPermission();" class="btn btn-danger">Create Permission</a>
				</div>
				</cfif>
				<!--- Filter Bar --->
				<div class="filterBar">
					<div>
						#html.label(field="permissionFilter",content="Quick Filter:",class="inline")#
						#html.textField(name="permissionFilter",size="30",class="textfield")#
					</div>
				</div>
			</div>
				
				<!--- permissions --->
				<table name="permissions" id="permissions" class="tablesorter table table-hover table-striped" width="98%">
					<thead>
						<tr>
							<th>Permission</th>
							<th>Description</th>
							<th class="center">Roles Assigned</th>		
							<th width="150" class="center {sorter:false}">Actions</th>
						</tr>
					</thead>				
					<tbody>
						<cfloop array="#prc.permissions#" index="permission">
						<tr>
							<td>
								<cfif prc.oAuthor.checkPermission("PERMISSIONS_ADMIN,TOOLS_IMPORT,TOOLS_EXPORT")>
								<a href="javascript:edit('#permission.getPermissionID()#',
								   						 '#HTMLEditFormat( jsstringFormat(permission.getPermission()) )#',
								   						 '#HTMLEditFormat( jsstringFormat(permission.getDescription()) )#')" 
								   title="Edit #permission.getPermission()#">#permission.getPermission()#</a>
								<cfelse>
									#permission.getPermission()#
								</cfif>
							</td>
							<td>#permission.getDescription()#</td>
							<td class="center">
								<span class="badge badge-info">#permission.getNumberOfRoles()#</span>
							</td>
							<td class="center">
								<div class="btn-group">
								<cfif prc.oAuthor.checkPermission("PERMISSIONS_ADMIN")>
								<!--- Edit Command --->
								<a class="btn" href="javascript:edit('#permission.getPermissionID()#',
								   						 '#HTMLEditFormat( jsstringFormat(permission.getPermission()) )#',
								   						 '#HTMLEditFormat( jsstringFormat(permission.getDescription()) )#')" 
								   title="Edit #permission.getPermission()#"><i class="icon-edit icon-large"></i></a>
								<!--- Delete Command --->
								<a class="btn confirmIt" title="Delete Permission" href="javascript:remove('#permission.getPermissionID()#')" data-title="Delete Permission?"><i id="delete_#permission.getPermissionID()#" class="icon-trash icon-large"></i></a>
								</cfif>
								</div>
							</td>
						</tr>
						</cfloop>
					</tbody>
				</table>			
			</div>
         #html.endForm()#	
	</div>
</div>
<cfif prc.oAuthor.checkPermission("PERMISSIONS_ADMIN")>
<!--- Permissions Editor --->
<div id="permissionEditorContainer" class="modal hide fade">
	<div id="modalContent">
	<div class="modal-header">
		<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
		<h3>Permission Editor</h3>
    </div>
	<!--- Create/Edit form --->
	#html.startForm(action=prc.xehPermissionSave,name="permissionEditor",novalidate="novalidate",class="form-vertical")#
	<div class="modal-body">
			#html.hiddenField(name="permissionID",value="")#
			#html.textField(name="permission",label="Permission:",required="required",maxlength="255",size="30",class="input-block-level",title="The unique permission name",wrapper="div class=controls",labelClass="control-label",groupWrapper="div class=control-group")#
			#html.textArea(name="description",label="Description:",cols="20",rows="3",class="input-block-level",required="required",title="A short permission description",wrapper="div class=controls",labelClass="control-label",groupWrapper="div class=control-group")#
	</div>
	<!--- Footer --->
	<div class="modal-footer">
		#html.resetButton(name="btnReset",value="Cancel",class="btn", onclick="closeModal( $('##permissionEditorContainer') )")#
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
	        <h3><i class="icon-copy"></i> Import Permissions</h3>
	    </div>
        #html.startForm(name="importForm", action=prc.xehImportAll, class="form-vertical", multipart=true)#
        <div class="modal-body">
			<p>Choose the ContentBox <strong>JSON</strong> permissions file to import.</p>
			
			#getMyPlugin( plugin="BootstrapFileUpload", module="contentbox" ).renderIt( 
				name="importFile",
				required=true
			)#
			
			<label for="overrideContent">Override Permissions?</label>
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