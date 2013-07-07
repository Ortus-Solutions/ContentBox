<cfoutput>
<div class="row-fluid">    
	<!--- main content --->    
	<div class="span9" id="main-content">    
	    <div class="box">
			<!--- Body Header --->
			<div class="header">
				<i class="icon-tasks icon-large"></i>
				Custom HTML
			</div>
			<!--- Body --->
			<div class="body">	
			
			<!--- messageBox --->
			#getPlugin("MessageBox").renderit()#
			
			<!---Import Log --->
			<cfif flash.exists( "importLog" )>
			<div class="consoleLog">#flash.get( "importLog" )#</div>
			</cfif>
			
			<!--- Info --->
			<p>
				Custom HTML can be used in any layout or content to easily add any type of HTML assets, snippets, custom css, js, 
				you name it!
			</p>
			
			<!--- entryForm --->
			#html.startForm(name="contentForm",action=prc.xehRemoveHTML)#
				#html.hiddenField(name="page",value=rc.page)#
				#html.hiddenField(name="contentID")#
			
				<!--- Content Bar --->
				<div class="well well-small" id="contentBar">
					<!--- Create Butons --->
					<cfif prc.oAuthor.checkPermission("CUSTOMHTML_ADMIN")>
					<div class="buttonBar">
						<!---Global --->
						<div class="btn-group">
					    	<a class="btn dropdown-toggle" data-toggle="dropdown" href="##">
								Global Actions <span class="caret"></span>
							</a>
					    	<ul class="dropdown-menu">
					    		<li><a href="javascript:importContent()"><i class="icon-upload-alt"></i> Import</a></li>
					    		<li class="dropdown-submenu">
					    			<a href="##"><i class="icon-download icon-large"></i> Export All</a>
									<ul class="dropdown-menu text-left">
										<li><a href="#event.buildLink(linkto=prc.xehExportAllHTML)#.json" target="_blank"><i class="icon-code"></i> as JSON</a></li>
										<li><a href="#event.buildLink(linkto=prc.xehExportAllHTML)#.xml" target="_blank"><i class="icon-sitemap"></i> as XML</a></li>
									</ul>
								</li>
					    	</ul>
					    </div>
						<!---Create --->
						<button class="btn btn-danger" onclick="return to('#event.buildLink(prc.xehEditorHTML)#');">Create Content</button>
					</div>
					</cfif>
					
					<!--- Filter Bar --->
					<div class="filterBar">
						<div>
							#html.label(field="entryFilter",content="Quick Filter:",class="inline")#
							#html.textField(name="entryFilter",size="30",class="textfield")#
						</div>
					</div>
				</div>
				
				<!--- comments --->
				<table name="entries" id="entries" class="tablesorter table table-striped table-hover" width="98%">
					<thead>
						<tr>
							<th>Title</th>
							<th width="300">Slug</th>
							<th>Author</th>
							<th width="90" class="center {sorter:false}">Actions</th>
						</tr>
					</thead>
					
					<tbody>
						<cfloop array="#prc.entries#" index="entry">
						<tr>
							<td>
								<cfif prc.oAuthor.checkPermission("CUSTOMHTML_ADMIN")>
									<a href="#event.buildLink(prc.xehEditorHTML)#/contentID/#entry.getContentID()#" title="Edit Content">#entry.getTitle()#</a>
								<cfelse>
									#entry.getTitle()#
								</cfif>
								<br>#entry.getDescription()#
							</td>
							<td>
								#entry.getSlug()#
							</td>
							<td>
								<cfif entry.hasCreator()>#entry.getCreatorName()#<cfelse><span class="label label-warning">none</span></cfif>
							</td>
							<td class="center">
								
								<div class="btn-group">
							    	<a class="btn dropdown-toggle" data-toggle="dropdown" href="##" title="Page Actions">
										<i class="icon-cogs icon-large"></i>
									</a>
							    	<ul class="dropdown-menu text-left">
										<cfif prc.oAuthor.checkPermission("CUSTOMHTML_ADMIN")>
										<!--- Edit Command --->
										<li><a href="#event.buildLink(prc.xehEditorHTML)#/contentID/#entry.getContentID()#" title="Edit Content"><i class="icon-edit icon-large"></i> Edit</a></li>
										<!--- Delete Command --->
										<li><a title="Delete Content Permanently" href="javascript:remove('#entry.getContentID()#')" class="confirmIt" data-title="Delete Content?"><i id="delete_#entry.getContentID()#" class="icon-trash icon-large"></i> Delete</a></li>
										<!--- Export --->
										<li class="dropdown-submenu">
											<a href="##"><i class="icon-download icon-large"></i> Export</a>
											<ul class="dropdown-menu text-left">
												<li><a href="#event.buildLink(linkto=prc.xehExportHTML)#/contentID/#entry.getContentID()#.json" target="_blank"><i class="icon-code"></i> as JSON</a></li>
												<li><a href="#event.buildLink(linkto=prc.xehExportHTML)#/contentID/#entry.getContentID()#.xml" target="_blank"><i class="icon-sitemap"></i> as XML</a></li>
											</ul>
										</li>
										</cfif>
							    	</ul>
							    </div>
							</td>
						</tr>
						</cfloop>
					</tbody>
				</table>
				
				<!--- Paging --->
				#prc.pagingPlugin.renderit(foundRows=prc.entriesCount, link=prc.pagingLink, asList=true)#
			
			#html.endForm()#
			
			</div>
		</div>
	</div>    

	<!--- main sidebar --->    
	<div class="span3" id="main-sidebar">    
		<!--- Saerch Box --->
		<div class="small_box">
			<div class="header">
				<i class="icon-search"></i> Search
			</div>
			<div class="body<cfif len(rc.search)> selected</cfif>">
				<!--- Search Form --->
				#html.startForm(name="htmlSearchForm",action=prc.xehCustomHTML)#
					#html.textField(label="Search:",name="search",class="input-block-level",size="16",title="Search all content pieces",value=rc.search)#
					<button type="submit" class="btn btn-danger">Search</button>
					<button class="btn" onclick="return to('#event.buildLink(prc.xehCustomHTML)#')">Clear</button>				
				#html.endForm()#
			</div>
		</div>	
		
		<!--- Filter Box --->
		<div class="small_box">
			<div class="header">
				<i class="icon-filter"></i> Filters
			</div>
			<div class="body<cfif prc.isFiltering> selected</cfif>">
				#html.startForm(name="contentFilterForm", action=prc.xehContentSearch)#
				<!--- Authors --->
				<label for="fAuthors">Authors: </label>
				<select name="fAuthors" id="fAuthors" class="input-block-level">
					<option value="all" <cfif rc.fAuthors eq "all">selected="selected"</cfif>>All Authors</option>
					<cfloop array="#prc.authors#" index="author">
					<option value="#author.getAuthorID()#" <cfif rc.fAuthors eq author.getAuthorID()>selected="selected"</cfif>>#author.getName()#</option>
					</cfloop>
				</select>
				<!--- Status 
				<label for="fStatus">Page Status: </label>
				<select name="fStatus" id="fStatus" class="input-block-level">
					<option value="any"   <cfif rc.fStatus eq "any">selected="selected"</cfif>>Any Status</option>
					<option value="true"  <cfif rc.fStatus eq "true">selected="selected"</cfif>>Published</option>
					<option value="false" <cfif rc.fStatus eq "false">selected="selected"</cfif>>Draft</option>
				</select>
				--->
				
				<button type="submit" class="btn btn-danger">Apply Filters</button>
				<button class="btn" onclick="return to('#event.buildLink( prc.xehCustomHTML )#')">Reset</button>
				#html.endForm()#
			</div>
		</div>
	
	</div>    
</div>

<!---import dialog --->
<div id="importDialog" class="modal hide fade">
	<div id="modalContent">
	    <div class="modal-header">
	        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
	        <h3><i class="icon-copy"></i> Import CustomHTML</h3>
	    </div>
        #html.startForm(name="importForm", action=prc.xehImportHTML, class="form-vertical", multipart=true)#
        <div class="modal-body">
			<p>Choose the ContentBox <strong>JSON</strong> custom HTML file to import. The creator of the customHTML is matched via their <strong>username</strong> and 
			content overrides are matched via their <strong>slug</strong>.
			If the importer cannot find the username from the import file in your installation, then it will continue saving the content with no creator attached.</p>
			
			#html.fileField(name="importFile", required=true, wrapper="div class=controls")#
			
			<label for="overrideContent">Override custom HTML?</label>
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
</cfoutput>