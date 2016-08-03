<cfoutput>
<div class="row">
	<div class="col-md-12">
		<h1 class="h1"><i class="fa fa-tag"></i> Content Categories</h1>
	</div>
</div>
<div class="row">
	<div class="col-md-12">
		<!--- MessageBox --->
		#getModel( "messagebox@cbMessagebox" ).renderit()#
		<!---Import Log --->
		<cfif flash.exists( "importLog" )>
			<div class="consoleLog">#flash.get( "importLog" )#</div>
		</cfif>
	</div>
</div>
<div class="row">
	<div class="col-md-12">
		#html.startForm( name="categoryForm", action=prc.xehCategoryRemove )#
		#html.hiddenField( name="categoryID", value="" )#
		<div class="panel panel-default">
			<div class="panel-heading">
				<div class="row">
					<div class="col-md-6">
						<div class="form-group form-inline no-margin">
							#html.textField( 
								name="categorySearch",
								class="form-control",
								placeholder="Quick Search"
							)#
						</div>
					</div>
					<div class="col-md-6">
						<div class="pull-right">
							<cfif prc.oAuthor.checkPermission( "CATEGORIES_ADMIN,TOOLS_IMPORT,TOOLS_EXPORT" )>
								<div class="btn-group btn-group-sm">
							    	<button class="btn dropdown-toggle btn-info" data-toggle="dropdown">
										Bulk Actions <span class="caret"></span>
									</button>
							    	<ul class="dropdown-menu">
							    		<cfif prc.oAuthor.checkPermission( "CATEGORIES_ADMIN" )>
							    		<li><a href="javascript:bulkRemove()" class="confirmIt"
												data-title="<i class='fa fa-trash-o'></i> Delete Selected Categories?" data-message="This will delete the categories and associations, are you sure?"><i class="fa fa-trash-o"></i> Delete Selected</a></li>
										</cfif>
										<cfif prc.oAuthor.checkPermission( "CATEGORIES_ADMIN,TOOLS_IMPORT" )>
							    		<li><a href="javascript:importContent()"><i class="fa fa-upload"></i> Import</a></li>
										</cfif>
							    		<cfif prc.oAuthor.checkPermission( "CATEGORIES_ADMIN,TOOLS_EXPORT" )>
											<li><a href="#event.buildLink (linkto=prc.xehExportAll )#.json" target="_blank"><i class="fa fa-download"></i> Export All as JSON</a></li>
											<li><a href="#event.buildLink( linkto=prc.xehExportAll )#.xml" target="_blank"><i class="fa fa-download"></i> Export All as XML</a></li>
										</cfif>
							    	</ul>
							    </div>
							</cfif>
							<cfif prc.oAuthor.checkPermission( "CATEGORIES_ADMIN" )>
								<!--- Create --->
								<button onclick="return createCategory();" class="btn btn-primary btn-sm">Create Category</button>
							</cfif>
						</div>
					</div>
				</div> <!--- end row --->
				
			</div> <!--- end panel-heading --->
			<div class="panel-body">
				<table id="categories" class="table table-striped table-hover table-condensed" cellspacing="0" width="100%">
					<thead>
						<tr>
							<th id="checkboxHolder" class="{sorter:false} text-center" width="15"><input type="checkbox" onClick="checkAll(this.checked,'categoryID')"/></th>
							<th>Category Name</th>
							<th>Slug</th>		
							<th width="75" class="text-center">Pages</th>
							<th width="75" class="text-center">Entries</th>	
							<th width="100" class="text-center {sorter:false}">Actions</th>
						</tr>
					</thead>
					<tbody>
						<cfloop array="#prc.categories#" index="category">
						<tr id="categoryID-#category.getCategoryID()#" data-categoryID="#category.getCategoryID()#">
							<!--- check box --->
							<td class="text-center">
								<input type="checkbox" name="categoryID" id="categoryID" value="#category.getCategoryID()#" />
							</td>
							<td><a href="javascript:edit('#category.getCategoryID()#',
								   						 '#HTMLEditFormat( JSStringFormat( category.getCategory() ) )#',
								   						 '#HTMLEditFormat( JSStringFormat( category.getSlug() ) )#')" title="Edit #category.getCategory()#">#category.getCategory()#</a></td>
							<td>#category.getSlug()#</td>
							<td class="text-center"><span class="badge badge-info">#category.getNumberOfPages()#</span></td>
							<td class="text-center"><span class="badge badge-info">#category.getnumberOfEntries()#</span></td>
							<td class="text-center">
								<div class="btn-group">
									<cfif prc.oAuthor.checkPermission( "CATEGORIES_ADMIN" )>
									<!--- Edit Command --->
									<button type="button" class="btn btn-primary btn-sm" onclick="javascript:edit('#category.getCategoryID()#','#HTMLEditFormat( JSStringFormat( category.getCategory() ) )#',
									'#HTMLEditFormat( JSStringFormat( category.getSlug() ) )#')" title="Edit #category.getCategory()#"><i class="fa fa-edit"></i></button>
									<!--- Delete Command --->
									<a class="btn btn-danger btn-sm confirmIt" href="javascript:removeCategory('#category.getcategoryID()#')" title="Delete Category" data-title="Delete Category?">
										<i class="fa fa-trash-o" id="delete_#category.getCategoryID()#"></i>
									</a>
									</cfif>
								</div>
							</td>
						</tr>
						</cfloop>
					</tbody>
				</table>
			</div>
		</div>
		#html.endForm()#
	</div>
</div>

<!---only show if user has rights to categories admin--->
<cfif prc.oAuthor.checkPermission( "CATEGORIES_ADMIN" )>
	<!--- Category Editor --->
	<div id="categoryEditorContainer" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="categoryLabel" aria-hidden="true">
		<div class="modal-dialog">
	        <div class="modal-content" id="modalContent">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
	                <h4 class="modal-title" id="categoryLabel"><i class="fa fa-tag"></i> Category Editor</h4>
			    </div>
				<!--- Create/Edit form --->
				#html.startForm(action=prc.xehCategoriesSave,name="categoryEditor",novalidate="novalidate",class="form-vertical",role="form" )#
				<div class="modal-body">
					#html.hiddenField(name="categoryID",value="" )#
					#html.textField(
						name="category",
						label="Category:",
						required="required",
						maxlength="100",
						size="30",
						placeholder="Enter Category",
						class="form-control",
						wrapper="div class=controls",
						labelClass="control-label",
						groupWrapper="div class=form-group"
					)#
					#html.textField(
						name="slug",
						label="Slug (blank to generate it):",
						maxlength="100",
						size="30",
						class="form-control",
						wrapper="div class=controls",
						labelClass="control-label",
						groupWrapper="div class=form-group"
					)#
				</div>
				<!--- Footer --->
				<div class="modal-footer">
					#html.resetButton(name="btnReset",value="Cancel",class="btn", onclick="closeModal( $('##categoryEditorContainer') )" )#
					#html.submitButton(name="btnSave",value="Save Category",class="btn btn-danger" )#
				</div>
				#html.endForm()#
			</div>
		</div>
	</div>
</cfif>

<!---only show if user has rights to categories admin and tool import--->
<cfif prc.oAuthor.checkPermission( "CATEGORIES_ADMIN,TOOLS_IMPORT" )>
	#renderView( 
		view 	= "_tags/dialog/import",
		args 	= {
			title 		= "Import Users",
			contentArea = "user",
			action 		= prc.xehImportAll,
			contentInfo = "Choose the ContentBox <strong>JSON</strong> users file to import."
		}
	)#	
</cfif>
</cfoutput>