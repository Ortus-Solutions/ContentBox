<cfoutput>
<div class="row-fluid">
	<!--- main content --->
	<div class="span9" id="main-content">
		<div class="box">
			<!--- Body Header --->
			<div class="header">
				<i class="icon-user icon-large"></i>
				User Management
			</div>
			<!--- Body --->
			<div class="body">
				<!--- MessageBox --->
				#getPlugin("MessageBox").renderit()#
				
				<!---Import Log --->
				<cfif flash.exists( "importLog" )>
				<div class="consoleLog">#flash.get( "importLog" )#</div>
				</cfif>
				
				<!--- AuthorForm --->
				#html.startForm(name="authorForm",action=prc.xehAuthorRemove)#
				<input type="hidden" name="authorID" id="authorID" value="" />
	
				<div class="well well-small">
					<!--- Create Butons --->
					<div class="buttonBar">
						<!---Global --->
						<cfif prc.oAuthor.checkPermission("AUTHOR_ADMIN,TOOLS_IMPORT,TOOLS_EXPORT")>
						<div class="btn-group">
					    	<a class="btn dropdown-toggle" data-toggle="dropdown" href="##">
								Bulk Actions <span class="caret"></span>
							</a>
					    	<ul class="dropdown-menu">
					    		<cfif prc.oAuthor.checkPermission("AUTHOR_ADMIN,TOOLS_IMPORT")>
					    		<li><a href="javascript:importContent()"><i class="icon-upload-alt"></i> Import</a></li>
								</cfif>
								<cfif prc.oAuthor.checkPermission("AUTHOR_ADMIN,TOOLS_EXPORT")>
					    		<li class="dropdown-submenu">
									<a href="##"><i class="icon-download icon-large"></i> Export All</a>
									<ul class="dropdown-menu text-left">
										<li><a href="#event.buildLink(linkto=prc.xehExportAll)#.json" target="_blank"><i class="icon-code"></i> as JSON</a></li>
										<li><a href="#event.buildLink(linkto=prc.xehExportAll)#.xml" target="_blank"><i class="icon-sitemap"></i> as XML</a></li>
									</ul>
								</li>
								</cfif>
								<li><a href="javascript:contentShowAll()"><i class="icon-list"></i> Show All</a></li>
					    	</ul>
					    </div>
						</cfif>
						<cfif prc.oAuthor.checkPermission("AUTHOR_ADMIN")>
						<button class="btn btn-danger" onclick="return to('#event.buildLink(prc.xehAuthorEditor)#')">Create User</button>
						</cfif>
					</div>
	
					<!--- Filter Bar --->
					<div class="filterBar">
						<div>
							#html.label(field="userSearch",content="Quick Search:",class="inline")#
							#html.textField(name="userSearch", class="textfield", size="30")#
						</div>
					</div>
				</div>
	
				<!--- container --->
    			<div id="authorTableContainer"><p class="text-center"><i id="userLoader" class="icon-spinner icon-spin icon-large icon-4x"></i></p></div>
				

				#html.endForm()#
	
			</div>	<!--- body --->
		</div> <!--- main box --->
	</div>

	<!--- main sidebar --->
	<div class="span3" id="main-sidebar">
		<!--- Filter Box --->
		<div class="small_box">
			<div class="header">
				<i class="icon-filter"></i> Filters
			</div>
			<div class="body" id="filterBox">
				#html.startForm( name="filterForm", action=prc.xehAuthorSearch )#
				<!--- Status --->
				<label for="fStatus">Status: </label>
				<select name="fStatus" id="fStatus" class="input-block-level">
					<option value="any">Any Status</option>
					<option value="true">Active</option>
					<option value="false">Deactivated</option>
				</select>

				<!--- Roles --->
				<label for="fRole">Roles: </label>
				<select name="fRole" id="fRole" class="input-block-level">
					<option value="any">All Roles</option>
					<cfloop array="#prc.roles#" index="thisRole">
					<option value="#thisRole.getRoleID()#">#thisRole.getRole()#</option>
					</cfloop>
				</select>
				
				<a class="btn btn-danger" href="javascript:contentFilter()">Apply Filters</a>
				<a class="btn" href="javascript:resetFilter( true )">Reset</a>
				#html.endForm()#
			</div>
		</div>
	</div>
</div>

<cfif prc.oAuthor.checkPermission("AUTHOR_ADMIN,TOOLS_IMPORT")>
<!---Import Dialog --->
<div id="importDialog" class="modal hide fade">
	<div id="modalContent">
	    <div class="modal-header">
	        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
	        <h3><i class="icon-copy"></i> Import Users</h3>
	    </div>
        #html.startForm(name="importForm", action=prc.xehImportAll, class="form-vertical", multipart=true)#
        <div class="modal-body">
			<p>Choose the ContentBox <strong>JSON</strong> users file to import.</p>
			
			#getMyPlugin( plugin="BootstrapFileUpload", module="contentbox" ).renderIt( 
				name="importFile", 
				required=true
			)#

			<label for="overrideContent">Override Users?</label>
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