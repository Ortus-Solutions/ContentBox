<cfoutput>
<div class="row-fluid">    
	<!--- main content --->    
	<div class="span9" id="main-content">    
	    <div class="box">
			<!--- Body Header --->
			<div class="header">
				<i class="icon-hdd icon-large"></i>
				Content Store
			</div>
			<!--- Body --->
			<div class="body">
				
				<!--- MessageBox --->
				#getPlugin("MessageBox").renderit()#
				
				<!---Import Log --->
				<cfif flash.exists( "importLog" )>
				<div class="consoleLog">#flash.get( "importLog" )#</div>
				</cfif>
				
				<!--- contentForm --->
				#html.startForm(name="contentForm",action=prc.xehContentRemove)#
				#html.hiddenField(name="contentStatus",value="")#
				#html.hiddenField(name="contentID",value="")#
				
				<!--- Content Bar --->
				<div class="well well-small" id="contentBar">
					
					<!--- Create Butons --->
					<div class="buttonBar">
						<cfif prc.oAuthor.checkPermission("CONTENTSTORE_ADMIN,TOOLS_IMPORT,TOOLS_EXPORT")>
						<div class="btn-group">
					    	<a class="btn dropdown-toggle" data-toggle="dropdown" href="##">
								Global Actions <span class="caret"></span>
							</a>
					    	<ul class="dropdown-menu">
					    		<cfif prc.oAuthor.checkPermission("CONTENTSTORE_ADMIN")>
								<li><a href="javascript:bulkRemove()" class="confirmIt"
									data-title="Delete Selected Content?" data-message="This will delete the content, are you sure?"><i class="icon-trash"></i> Delete Selected</a></li>
								<li><a href="javascript:bulkChangeStatus('draft')"><i class="icon-ban-circle"></i> Draft Selected</a></li>
								<li><a href="javascript:bulkChangeStatus('publish')"><i class="icon-ok-sign"></i> Publish Selected</a></li>
								</cfif>
								<cfif prc.oAuthor.checkPermission("CONTENTSTORE_ADMIN,TOOLS_IMPORT")>
								<li><a href="javascript:importContent()"><i class="icon-upload-alt"></i> Import</a></li>
								</cfif>
								<cfif prc.oAuthor.checkPermission("CONTENTSTORE_ADMIN,TOOLS_EXPORT")>
								<li class="dropdown-submenu">
									<a href="##"><i class="icon-download icon-large"></i> Export All</a>
									<ul class="dropdown-menu text-left">
										<li><a href="#event.buildLink(linkto=prc.xehContentExportAll)#.json" target="_blank"><i class="icon-code"></i> as JSON</a></li>
										<li><a href="#event.buildLink(linkto=prc.xehContentExportAll)#.xml" target="_blank"><i class="icon-sitemap"></i> as XML</a></li>
									</ul>
								</li>
								</cfif>
								<li><a href="javascript:contentShowAll()"><i class="icon-list"></i> Show All</a></li>
					    	</ul>
					    </div>
						</cfif>
						<button class="btn btn-danger" onclick="return to('#event.buildLink(linkTo=prc.xehContentEditor)#');">Create Content</button>
					</div>
					
					<!--- Filter Bar --->
					<div class="filterBar">
						<div>
							#html.label(field="contentSearch",content="Quick Search:",class="inline")#
							#html.textField(name="contentSearch", class="textfield", size="30")#
						</div>
					</div>
				</div>
				
				<!--- content container --->
    			<div id="contentTableContainer"><p class="text-center"><i id="contentLoader" class="icon-spinner icon-spin icon-large icon-4x"></i></p></div>
				
				#html.endForm()#
	
			</div>	
		</div>
	</div>    

	<!--- main sidebar --->    
	<div class="span3" id="main-sidebar">    
		<!--- Filter Box --->
		<div class="small_box">
			<div class="header">
				<i class="icon-filter"></i> Filters
			</div>
			<div class="body" id="filterBox">
				#html.startForm(name="contentFilterForm", action=prc.xehContentSearch)#
				<!--- Authors --->
				<label for="fAuthors">Authors: </label>
				<select name="fAuthors" id="fAuthors" class="input-block-level">
					<option value="all" selected="selected">All Authors</option>
					<cfloop array="#prc.authors#" index="author">
					<option value="#author.getAuthorID()#">#author.getName()#</option>
					</cfloop>
				</select>
				<!--- Categories --->
				<label for="fCategories">Categories: </label>
				<select name="fCategories" id="fCategories" class="input-block-level">
					<option value="all">All Categories</option>
					<option value="none">Uncategorized</option>
					<cfloop array="#prc.categories#" index="category">
					<option value="#category.getCategoryID()#">#category.getCategory()#</option>
					</cfloop>
				</select>
				<!--- Status --->
				<label for="fStatus">Status: </label>
				<select name="fStatus" id="fStatus" class="input-block-level">
					<option value="any">Any Status</option>
					<option value="true">Published</option>
					<option value="false">Draft</option>
				</select>
	
				<a class="btn btn-danger" href="javascript:contentFilter()">Apply Filters</a>
				<a class="btn" href="javascript:resetFilter( true )">Reset</a>
				#html.endForm()#
			</div>
		</div>
	</div>    
</div>
<!--- Clone Dialog --->
<cfif prc.oAuthor.checkPermission("CONTENTSTORE_EDITOR,CONTENTSTORE_ADMIN")>
<div id="cloneDialog" class="modal hide fade">
	<div id="modalContent">
	    <div class="modal-header">
	        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
	        <h3><i class="icon-copy"></i> Content Cloning</h3>
	    </div>
        #html.startForm(name="cloneForm", action=prc.xehContentClone)#
        <div class="modal-body">
			<p>By default, all internal links are updated for you as part of the cloning process.</p>
		
			#html.hiddenField(name="contentID")#
			#html.textfield(name="title", label="Please enter the new content title:", class="input-block-level", required="required", size="50")#
			<label for="contentStatus">Publish Content?</label>
			<small>By default all cloned content is published as drafts.</small><br>
			#html.select(options="true,false", name="contentStatus", selectedValue="false", class="input-block-level")#
			
			<!---Notice --->
			<div class="alert alert-info">
				<i class="icon-info-sign icon-large"></i> Please note that cloning is an expensive process, so please be patient.
			</div>
		</div>
        <div class="modal-footer">
        	<!--- Button Bar --->
        	<div id="cloneButtonBar">
          	 	<button class="btn" id="closeButton"> Cancel </button>
				<button class="btn btn-danger" id="cloneButton"> Clone </button>
			</div>
            <!--- Loader --->
			<div class="center loaders" id="clonerBarLoader">
				<i class="icon-spinner icon-spin icon-large icon-2x"></i>
				<br>Please wait, doing some hardcore cloning action...
			</div>
        </div>
		#html.endForm()#
	</div>
</div>
</cfif>
<cfif prc.oAuthor.checkPermission("CONTENTSTORE_ADMIN,TOOLS_IMPORT")>
<div id="importDialog" class="modal hide fade">
	<div id="modalContent">
	    <div class="modal-header">
	        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
	        <h3><i class="icon-copy"></i> Import Content</h3>
	    </div>
        #html.startForm(name="importForm", action=prc.xehContentImport, class="form-vertical", multipart=true)#
        <div class="modal-body">
			<p>Choose the ContentBox <strong>JSON</strong> content file to import. The creator of the content is matched via their <strong>username</strong> and 
			content overrides are matched via their <strong>slug</strong>.
			If the importer cannot find the username from the import file in your installation, then it will ignore the record.</p>
			
			#html.fileField(name="importFile", required=true, wrapper="div class=controls")#
			
			<label for="overrideContent">Override content?</label>
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