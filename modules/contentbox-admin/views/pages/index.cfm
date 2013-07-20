<cfoutput>
<div class="row-fluid">
	<!--- main content --->
	<div class="span9" id="main-content">
		<div class="box">
			<!--- Body Header --->
			<div class="header">
				<i class="icon-file-alt icon-large"></i>
				Pages
			</div>
			<!--- Body --->
			<div class="body">
	
				<!--- MessageBox --->
				#getPlugin("MessageBox").renderit()#
				
				<!---Import Log --->
				<cfif flash.exists( "importLog" )>
				<div class="consoleLog">#flash.get( "importLog" )#</div>
				</cfif>
	
				<!--- pageForm --->
				#html.startForm(name="pageForm",action=prc.xehPageRemove)#
				#html.hiddenField(name="contentStatus",value="")#
				#html.hiddenField(name="contentID",value="")#
	
				<!--- Info Bar --->
				<cfif NOT prc.cbSettings.cb_comments_enabled>
					<div class="alert alert-info">
						<i class="icon-exclamation-sign icon-large"></i>
						Comments are currently disabled site-wide!
					</div>
				</cfif>
	
				<!--- Content Bar --->
				<div class="well well-small" id="contentBar">
	
					<!--- Create Butons --->
					<div class="buttonBar">
					    <cfif prc.oAuthor.checkPermission("PAGES_ADMIN,TOOLS_IMPORT,TOOLS_EXPORT")>
						<div class="btn-group">
					    	<a class="btn dropdown-toggle" data-toggle="dropdown" href="##">
								Global Actions <span class="caret"></span>
							</a>
					    	<ul class="dropdown-menu">
					    		<cfif prc.oAuthor.checkPermission("PAGES_ADMIN")>
								<li><a href="javascript:bulkRemove()" class="confirmIt"
									data-title="Delete Selected Page(s)?" data-message="This will delete the page(s) and all of its sub-pages, are you sure?"><i class="icon-trash"></i> Delete Selected</a></li>
								<li><a href="javascript:bulkChangeStatus('draft')"><i class="icon-ban-circle"></i> Draft Selected</a></li>
								<li><a href="javascript:bulkChangeStatus('publish')"><i class="icon-ok-sign"></i> Publish Selected</a></li>
								</cfif>
								<cfif prc.oAuthor.checkPermission("PAGES_ADMIN,TOOLS_IMPORT")>
								<li><a href="javascript:importContent()"><i class="icon-upload-alt"></i> Import</a></li>
								</cfif>
								<cfif prc.oAuthor.checkPermission("PAGES_ADMIN,TOOLS_EXPORT")>
								<li class="dropdown-submenu">
									<a href="##"><i class="icon-download icon-large"></i> Export All</a>
									<ul class="dropdown-menu text-left">
										<li><a href="#event.buildLink(linkto=prc.xehPageExportAll)#.json" target="_blank"><i class="icon-code"></i> as JSON</a></li>
										<li><a href="#event.buildLink(linkto=prc.xehPageExportAll)#.xml" target="_blank"><i class="icon-sitemap"></i> as XML</a></li>
									</ul>
								</li>
								</cfif>
								<li><a href="javascript:pagesShowAll()"><i class="icon-list"></i> Show All</a></li>
					    	</ul>
					    </div>
						</cfif>
						<button class="btn btn-danger" 
								onclick="return to('#event.buildLink(linkTo=prc.xehPageEditor)#/parentID/' + getParentPage() )">Create Page</button>
					</div>
					
	
					<!--- Search Bar --->
					<div class="filterBar">
						<div>
							#html.label(field="pageSearch", content="Quick Search:", class="inline")#
							#html.textField(name="pageSearch", class="textfield span3")#
						</div>
					</div>
				</div>
	
				<!--- pages container --->
    			<div id="pagesTableContainer"><p class="text-center"><i id="pageLoader" class="icon-spinner icon-spin icon-large icon-4x"></i></p></div>
	
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
				#html.startForm(name="pageFilterForm", action=prc.xehPageSearch)#
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
				<label for="fStatus">Page Status: </label>
				<select name="fStatus" id="fStatus" class="input-block-level">
					<option value="any">Any Status</option>
					<option value="true">Published</option>
					<option value="false">Draft</option>
				</select>
	
				<a class="btn btn-danger" href="javascript:pagesFilter()">Apply Filters</a>
				<a class="btn" href="javascript:resetFilter()">Reset</a>
				#html.endForm()#
			</div>
		</div>
	
		<!--- Help Box--->
		<div class="small_box" id="help_tips">
			<div class="header">
				<i class="icon-question-sign"></i> Help Tips
			</div>
			<div class="body">
				<ul class="tipList unstyled">
					<li><i class="icon-lightbulb icon-larg"></i> Right click on a row to activate quick look!</li>
					<li><i class="icon-lightbulb icon-larg"></i> Sorting is only done within your paging window</li>
					<li><i class="icon-lightbulb icon-larg"></i> Quick Filtering is only for viewed results</li>
					<li><i class="icon-lightbulb icon-larg"></i> Cloning does not copy comments or version history</li>
					<li><i class="icon-lightbulb icon-larg"></i> You can quickly order the pages by dragging the rows</li>
				</ul>
			</div>
		</div>
	</div>
</div>

<!--- Clone Dialog --->
<cfif prc.oAuthor.checkPermission("PAGES_EDITOR,PAGES_ADMIN")>
<div id="cloneDialog" class="modal hide fade">
	<div id="modalContent">
	    <div class="modal-header">
	        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
	        <h3><i class="icon-copy"></i> Page Cloning</h3>
	    </div>
        #html.startForm(name="cloneForm", action=prc.xehPageClone, class="form-vertical")#
        <div class="modal-body">
			<p>By default, all internal page links are updated for you as part of the cloning process.</p>
		
			#html.hiddenField(name="contentID")#
			#html.textfield(name="title", label="Please enter the new page title:", class="input-block-level", required="required", size="50",wrapper="div class=controls",labelClass="control-label",groupWrapper="div class=control-group")#
			<label for="pageStatus">Publish all pages in hierarchy?</label>
			<small>By default all cloned pages are published as drafts.</small><br>
			#html.select(options="true,false", name="pageStatus", selectedValue="false", class="input-block-level",wrapper="div class=controls",labelClass="control-label",groupWrapper="div class=control-group")#
			
			<!---Notice --->
			<div class="alert alert-info">
				<i class="icon-info-sign icon-large"></i> Please note that cloning is an expensive process, so please be patient when cloning big hierarchical content trees.
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
<cfif prc.oAuthor.checkPermission("PAGES_ADMIN,TOOLS_IMPORT")>
<div id="importDialog" class="modal hide fade">
	<div id="modalContent">
	    <div class="modal-header">
	        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
	        <h3><i class="icon-copy"></i> Import Pages</h3>
	    </div>
        #html.startForm(name="importForm", action=prc.xehPageImport, class="form-vertical", multipart=true)#
        <div class="modal-body">
			<p>Choose the ContentBox <strong>JSON</strong> pages file to import. The creator of the page is matched via their <strong>username</strong> and 
			page overrides are matched via their <strong>slug</strong>.
			If the importer cannot find the username from the import file in your installation, then it will ignore the record.</p>
			
			#html.fileField(name="importFile", required=true, wrapper="div class=controls")#
			
			<label for="overrideContent">Override blog entries?</label>
			<small>By default all content that exist is not overwritten.</small><br>
			#html.select(options="true,false", name="overrideContent", selectedValue="false", class="input-block-level", 
						 wrapper="div class=controls", labelClass="control-label", groupWrapper="div class=control-group")#
			
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