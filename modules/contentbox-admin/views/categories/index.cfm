<cfoutput>
<div class="row-fluid" id="main-content">
	<div class="box">
		<!--- Body Header --->
		<div class="header">
			<i class="icon-tags icon-large"></i>
			Content Categories
		</div>
		<!--- Body --->
		<div class="body">
			
			<!--- MessageBox --->
			#getPlugin("MessageBox").renderit()#
			
			<!---Import Log --->
			<cfif flash.exists( "importLog" )>
			<div class="consoleLog">#flash.get( "importLog" )#</div>
			</cfif>
			
			<!--- CategoryForm --->
			#html.startForm(name="categoryForm", action=prc.xehCategoryRemove, class="form-vertical")#
			<input type="hidden" name="categoryID" id="categoryID" value="" />
			
			<!--- Content Bar --->
			<div class="well well-small">
				<!--- Command Bar --->
				<div class="pull-right">
					<!---Global --->
					<cfif prc.oAuthor.checkPermission( "CATEGORIES_ADMIN,TOOLS_IMPORT,TOOLS_EXPORT" )>
					<div class="btn-group">
				    	<a class="btn dropdown-toggle" data-toggle="dropdown" href="##">
							Global Actions <span class="caret"></span>
						</a>
				    	<ul class="dropdown-menu">
				    		<cfif prc.oAuthor.checkPermission( "CATEGORIES_ADMIN" )>
				    		<li><a href="javascript:bulkRemove()" class="confirmIt"
									data-title="Delete Selected Categories?" data-message="This will delete the categories and associations, are you sure?"><i class="icon-trash"></i> Delete Selected</a></li>
							</cfif>
							<cfif prc.oAuthor.checkPermission( "CATEGORIES_ADMIN,TOOLS_IMPORT" )>
				    		<li><a href="javascript:importContent()"><i class="icon-upload-alt"></i> Import</a></li>
							</cfif>
							<cfif prc.oAuthor.checkPermission( "CATEGORIES_ADMIN,TOOLS_EXPORT" )>
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
					</cfif>
					<!--- Create --->
					<a href="##" onclick="return createCategory();" class="btn btn-danger">Create Category</a>
				</div>
				<!--- Filter Bar --->
				<div class="filterBar">
					<div>
						#html.textField(name="categoryFilter",size="30", class="textfield", label="Quick Filter: ", labelClass="inline")#
					</div>
				</div>
			</div>
			
			<!--- categories --->
			<table name="categories" id="categories" class="tablesorter table table-striped table-hover" width="98%">
				<thead>
					<tr>
						<th id="checkboxHolder" class="{sorter:false}" width="20"><input type="checkbox" onClick="checkAll(this.checked,'categoryID')"/></th>
						<th>Category Name</th>
						<th>Slug</th>		
						<th width="75" class="center">Pages</th>
						<th width="75" class="center">Entries</th>	
						<th width="75" class="center {sorter:false}">Actions</th>
					</tr>
				</thead>				
				<tbody>
					<cfloop array="#prc.categories#" index="category">
					<tr id="categoryID-#category.getCategoryID()#" data-categoryID="#category.getCategoryID()#">
						<!--- check box --->
						<td>
							<input type="checkbox" name="categoryID" id="categoryID" value="#category.getCategoryID()#" />
						</td>
						<td><a href="javascript:edit('#category.getCategoryID()#',
							   						 '#HTMLEditFormat( JSStringFormat( category.getCategory() ) )#',
							   						 '#HTMLEditFormat( JSStringFormat( category.getSlug() ) )#')" title="Edit #category.getCategory()#">#category.getCategory()#</a></td>
						<td>#category.getSlug()#</td>
						<td class="center"><span class="badge badge-info">#category.getNumberOfPages()#</span></td>
						<td class="center"><span class="badge badge-info">#category.getnumberOfEntries()#</span></td>
						<td class="center">
							<cfif prc.oAuthor.checkPermission("CATEGORIES_ADMIN")>
							<!--- Edit Command --->
							<a href="javascript:edit('#category.getCategoryID()#',
							   						 '#HTMLEditFormat( JSStringFormat( category.getCategory() ) )#',
							   						 '#HTMLEditFormat( JSStringFormat( category.getSlug() ) )#')" title="Edit #category.getCategory()#"><i class="icon-edit icon-large"></i></a>
							<!--- Delete Command --->
							<a title="Delete Category" href="javascript:remove('#category.getcategoryID()#')" class="confirmIt" data-title="Delete Category?"><i class="icon-trash icon-large" id="delete_#category.getCategoryID()#"></i></a>
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
<cfif prc.oAuthor.checkPermission("CATEGORIES_ADMIN")>
<!--- Permissions Editor --->
<div id="categoryEditorContainer" class="modal hide fade">
	<div id="modalContent">
	<div class="modal-header">
		<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
		<h3>Category Editor</h3>
    </div>
	<!--- Create/Edit form --->
	#html.startForm(action=prc.xehCategoriesSave,name="categoryEditor",novalidate="novalidate",class="form-vertical")#
	<div class="modal-body">
		#html.hiddenField(name="categoryID",value="")#
		#html.textField(name="category",label="Category:",required="required",maxlength="100",size="30",class="input-block-level",wrapper="div class=controls",labelClass="control-label",groupWrapper="div class=control-group")#
		#html.textField(name="slug",label="Slug (blank to generate it):",maxlength="100",size="30",class="input-block-level",wrapper="div class=controls",labelClass="control-label",groupWrapper="div class=control-group")#
	</div>
	<!--- Footer --->
	<div class="modal-footer">
		#html.resetButton(name="btnReset",value="Cancel",class="btn", onclick="closeModal( $('##categoryEditorContainer') )")#
		#html.submitButton(name="btnSave",value="Save Category",class="btn btn-danger")#
	</div>
	#html.endForm()#
	</div>
</div>
<cfelseif prc.oAuthor.checkPermission( "CATEGORIES_ADMIN,TOOLS_IMPORT" )>
<!---Import Dialog --->
<div id="importDialog" class="modal hide fade">
	<div id="modalContent">
	    <div class="modal-header">
	        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
	        <h3><i class="icon-copy"></i> Import Categories</h3>
	    </div>
        #html.startForm(name="importForm", action=prc.xehCategoryImport, class="form-vertical", multipart=true)#
        <div class="modal-body">
			<p>Choose the ContentBox <strong>JSON</strong> categories file to import.</p>
			
			#html.fileField(name="importFile", required=true, wrapper="div class=controls")#
			
			<label for="overrideContent">Override Categories?</label>
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