<cfoutput>
<div class="row-fluid">    
	<!--- main content --->    
	<div class="span9" id="main-content">    
	    <div class="box">
			<!--- Body Header --->
			<div class="header">
				<i class="icon-quote-left icon-large"></i>
				Blog Entries
				<cfif len(rc.searchEntries)><span class="badge">Search: #rc.searchEntries#</span></cfif>
				<cfif prc.isFiltering> <span class="badge">Filtered View</span></cfif>
			</div>
			<!--- Body --->
			<div class="body">
				
				<!--- MessageBox --->
				#getPlugin("MessageBox").renderit()#
				
				<!---Import Log --->
				<cfif flash.exists( "importLog" )>
				<div class="consoleLog">#flash.get( "importLog" )#</div>
				</cfif>
				
				<!--- entryForm --->
				#html.startForm(name="entryForm",action=prc.xehEntryRemove)#
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
						<cfif prc.oAuthor.checkPermission("ENTRIES_ADMIN,TOOLS_IMPORT,TOOLS_EXPORT")>
						<div class="btn-group">
					    	<a class="btn dropdown-toggle" data-toggle="dropdown" href="##">
								Global Actions <span class="caret"></span>
							</a>
					    	<ul class="dropdown-menu">
					    		<li><a href="javascript:bulkChangeStatus('draft')"><i class="icon-ban-circle"></i> Draft Selected</a></li>
								<li><a href="javascript:bulkChangeStatus('publish')"><i class="icon-ok-sign"></i> Publish Selected</a></li>
								<cfif prc.oAuthor.checkPermission("ENTRIES_ADMIN,TOOLS_IMPORT")>
								<li><a href="javascript:importContent()"><i class="icon-upload-alt"></i> Import</a></li>
								</cfif>
								<cfif prc.oAuthor.checkPermission("ENTRIES_ADMIN,TOOLS_EXPORT")>
								<li class="dropdown-submenu">
									<a href="##"><i class="icon-download icon-large"></i> Export All</a>
									<ul class="dropdown-menu text-left">
										<li><a href="#event.buildLink(linkto=prc.xehEntryExportAll)#.json" target="_blank"><i class="icon-code"></i> as JSON</a></li>
										<li><a href="#event.buildLink(linkto=prc.xehEntryExportAll)#.xml" target="_blank"><i class="icon-sitemap"></i> as XML</a></li>
									</ul>
								</li>
								</cfif>
					    	</ul>
					    </div>
						</cfif>
						<button class="btn btn-danger" onclick="return to('#event.buildLink(linkTo=prc.xehEntryEditor)#');">Create Entry</button>
					</div>
					
					<!--- Filter Bar --->
					<div class="filterBar">
						<div>
							#html.label(field="entryFilter",content="Quick Filter:",class="inline")#
							#html.textField(name="entryFilter",size="30",class="textfield")#
						</div>
					</div>
				</div>
				
				<!--- entries --->
				<table name="entries" id="entries" class="tablesorter table table-hover table-striped" width="98%">
					<thead>
						<tr>
							<th id="checkboxHolder" class="{sorter:false}" width="20"><input type="checkbox" onClick="checkAll(this.checked,'contentID')"/></th>
							<th>Name</th>
							<th width="40" class="center"><i class="icon-globe icon-large" title="Published Status"></i></th>
							<th width="40" class="center"><i class="icon-signal icon-large" title="Hits"></i></th>
							<th width="40" class="center"><i class="icon-comments icon-large" title="Comments"></i></th>
							<th width="100" class="center {sorter:false}">Actions</th>
						</tr>
					</thead>
					
					<tbody>
						<cfloop array="#prc.entries#" index="entry">
						<tr data-contentID="#entry.getContentID()#" 
							<cfif entry.isExpired()>
								class="expired"
							<cfelseif entry.isPublishedInFuture()>
								class="futurePublished"
							<cfelseif !entry.isContentPublished()>
								class="selected"
							</cfif>>
							<!--- check box --->
							<td>
								<input type="checkbox" name="contentID" id="contentID" value="#entry.getContentID()#" />
							</td>
							<td>
								<cfif prc.oAuthor.checkPermission("ENTRIES_EDITOR") OR prc.oAuthor.checkPermission("ENTRIES_ADMIN")>
									<a href="#event.buildLink(prc.xehBlogEditor)#/contentID/#entry.getContentID()#" title="Edit Entry">#entry.getTitle()#</a>
								<cfelse>
									#entry.getTitle()#
								</cfif>
								<!--- password protect --->
								<cfif entry.isPasswordProtected()>
									<i class="icon-lock"></i>
								</cfif>
								<br/><small><i class="icon-tag"></i> #entry.getCategoriesList()#</small>
							</td>
							<td class="center">
								<cfif entry.isExpired()>
									<i class="icon-time icon-large textRed" title="Entry has expired on ( (#entry.getDisplayExpireDate()#))"></i>
									<span class="hidden">expired</span>
								<cfelseif entry.isPublishedInFuture()>
									<i class="icon-fighter-jet icon-large textBlue" title="Entry Publishes in the future (#entry.getDisplayPublishedDate()#)"></i>
									<span class="hidden">published in future</span>
								<cfelseif entry.isContentPublished()>
									<i class="icon-ok icon-large textGreen" title="Entry Published!"></i>
									<span class="hidden">published in future</span>
								<cfelse>
									<i class="icon-remove icon-large textRed" title="Entry Published!"></i>
									<span class="hidden">draft</span>
								</cfif>
							</td>
							<td class="center"><span class="badge badge-info">#entry.getHits()#</span></td>
							<td class="center"><span class="badge badge-info">#entry.getNumberOfComments()#</span></td>
							<td class="center">
								<!---Info Panel --->
								<a 	class="btn popovers" 
									data-contentID="#entry.getContentID()#"
									data-toggle="popover"><i class="icon-info-sign icon-large"></i></a>
								<!---Info Panel --->
								<div id="infoPanel_#entry.getContentID()#" class="hide">
									<!---Creator --->
									<i class="icon-user"></i>
									Created by <a href="mailto:#entry.getCreatorEmail()#">#entry.getCreatorName()#</a> on 
									#entry.getDisplayCreatedDate()#
									</br>
									<!--- Last Edit --->
									<i class="icon-calendar"></i> 
									Last edit by <a href="mailto:#entry.getAuthorEmail()#">#entry.getAuthorName()#</a> on 
									#entry.getActiveContent().getDisplayCreatedDate()#
									</br>
									<!--- comments icon --->
									<cfif !entry.getallowComments()>
										<i class="icon-comments"></i> Open Comments
									<cfelse>
										<i class="icon-warning-sign"></i> Closed Comments
									</cfif>
								</div>
								
								<!--- Entry Actions --->
								<div class="btn-group">
							    	<a class="btn dropdown-toggle" data-toggle="dropdown" href="##" title="Entry Actions">
										<i class="icon-cogs icon-large"></i>
									</a>
							    	<ul class="dropdown-menu text-left pull-right">
							    		<cfif prc.oAuthor.checkPermission("ENTRIES_EDITOR,ENTRIES_ADMIN")>
										<!--- Clone Command --->
										<li><a href="javascript:openCloneDialog('#entry.getContentID()#','#URLEncodedFormat(entry.getTitle())#')"><i class="icon-copy icon-large"></i> Clone</a></li>
										<cfif prc.oAuthor.checkPermission("ENTRIES_ADMIN")>
										<!--- Delete Command --->
										<li>
											<a href="javascript:remove('#entry.getContentID()#')" class="confirmIt" data-title="Delete Entry?"><i id="delete_#entry.getContentID()#" class="icon-trash icon-large" ></i> Delete</a>
										</li>
										</cfif>
										<!--- Edit Command --->
										<li><a href="#event.buildLink(prc.xehEntryEditor)#/contentID/#entry.getContentID()#"><i class="icon-edit icon-large"></i> Edit</a></li>
										</cfif>
										<cfif prc.oAuthor.checkPermission("ENTRIES_ADMIN,TOOLS_EXPORT")>
										<!--- Export --->
										<li class="dropdown-submenu pull-left">
											<a href="##"><i class="icon-download icon-large"></i> Export</a>
											<ul class="dropdown-menu text-left">
												<li><a href="#event.buildLink(linkto=prc.xehEntryExport)#/contentID/#entry.getContentID()#.json" target="_blank"><i class="icon-code"></i> as JSON</a></li>
												<li><a href="#event.buildLink(linkto=prc.xehEntryExport)#/contentID/#entry.getContentID()#.xml" target="_blank"><i class="icon-sitemap"></i> as XML</a></li>
											</ul>
										</li>
										</cfif>
										<!--- History Command --->
										<li><a href="#event.buildLink(prc.xehEntryHistory)#/contentID/#entry.getContentID()#"><i class="icon-time icon-large"></i> History</a></li>
										<!--- View in Site --->
										<li><a href="#prc.CBHelper.linkEntry(entry)#" target="_blank"><i class="icon-eye-open icon-large"></i> Open In Site</a></li>
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
			<div class="body<cfif len(rc.searchEntries)> selected</cfif>">
				<!--- Search Form --->
				#html.startForm(name="authorSearchForm",action=prc.xehEntrySearch)#
					#html.textField(label="Search:",name="searchEntries",class="input-block-level",size="16",title="Search all entries",value=event.getValue("searchEntries",""))#
					<button type="submit" class="btn btn-danger">Search</button>
					<button class="btn" onclick="return to('#event.buildLink(prc.xehEntries)#')">Clear</button>				
				#html.endForm()#
			</div>
		</div>	
		
		<!--- Filter Box --->
		<div class="small_box">
			<div class="header">
				<i class="icon-filter"></i> Filters
			</div>
			<div class="body<cfif prc.isFiltering> selected</cfif>">
				#html.startForm(name="entryFilterForm",action=prc.xehEntrySearch)#
				<!--- Authors --->
				<label for="fAuthors">Authors: </label>
				<select name="fAuthors" id="fAuthors" class="input-block-level">
					<option value="all" <cfif rc.fAuthors eq "all">selected="selected"</cfif>>All Authors</option>
					<cfloop array="#prc.authors#" index="author">
					<option value="#author.getAuthorID()#" <cfif rc.fAuthors eq author.getAuthorID()>selected="selected"</cfif>>#author.getName()#</option>
					</cfloop>
				</select>
				<!--- Categories --->
				<label for="fCategories">Categories: </label>
				<select name="fCategories" id="fCategories" class="input-block-level">
					<option value="all" <cfif rc.fCategories eq "all">selected="selected"</cfif>>All Categories</option>
					<option value="none" <cfif rc.fCategories eq "none">selected="selected"</cfif>>Uncategorized</option>
					<cfloop array="#prc.categories#" index="category">
					<option value="#category.getCategoryID()#" <cfif rc.fCategories eq category.getCategoryID()>selected="selected"</cfif>>#category.getCategory()#</option>
					</cfloop>
				</select>
				<!--- Status --->
				<label for="fStatus">Entry Status: </label>
				<select name="fStatus" id="fStatus" class="input-block-level">
					<option value="any"   <cfif rc.fStatus eq "any">selected="selected"</cfif>>Any Status</option>
					<option value="true"  <cfif rc.fStatus eq "true">selected="selected"</cfif>>Published</option>
					<option value="false" <cfif rc.fStatus eq "false">selected="selected"</cfif>>Draft</option>				
				</select>
					
				<button type="submit" class="btn btn-danger">Apply Filters</button>
				<button class="btn" onclick="return to('#event.buildLink(prc.xehEntries)#')">Reset</button>				
				
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
					<li><i class="icon-lightbulb"></i> Right click on a row to activate quick look!</li>
					<li><i class="icon-lightbulb"></i> Sorting is only done within your paging window</li>
					<li><i class="icon-lightbulb"></i> Quick Filtering is only for viewed results</li>
				</ul>
			</div>
		</div>
	</div>    
</div>
<!--- Clone Dialog --->
<cfif prc.oAuthor.checkPermission("ENTRIES_EDITOR,ENTRIES_ADMIN")>
<div id="cloneDialog" class="modal hide fade">
	<div id="modalContent">
	    <div class="modal-header">
	        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
	        <h3><i class="icon-copy"></i> Entry Cloning</h3>
	    </div>
        #html.startForm(name="cloneForm", action=prc.xehEntryClone)#
        <div class="modal-body">
			<p>By default, all internal links are updated for you as part of the cloning process.</p>
		
			#html.hiddenField(name="contentID")#
			#html.textfield(name="title", label="Please enter the new entry title:", class="input-block-level", required="required", size="50")#
			<label for="entryStatus">Publish entry?</label>
			<small>By default all cloned entries are published as drafts.</small><br>
			#html.select(options="true,false", name="entryStatus", selectedValue="false", class="input-block-level")#
			
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
<cfif prc.oAuthor.checkPermission("ENTRIES_ADMIN,TOOLS_IMPORT")>
<div id="importDialog" class="modal hide fade">
	<div id="modalContent">
	    <div class="modal-header">
	        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
	        <h3><i class="icon-copy"></i> Import Entries</h3>
	    </div>
        #html.startForm(name="importForm", action=prc.xehEntryImport, class="form-vertical", multipart=true)#
        <div class="modal-body">
			<p>Choose the ContentBox <strong>JSON</strong> entries file to import. The creator of the entry is matched via their <strong>username</strong> and 
			entry overrides are matched via their <strong>slug</strong>.
			If the importer cannot find the username from the import file in your installation, then it will ignore the record.</p>
			
			#html.fileField(name="importFile", required=true, wrapper="div class=controls")#
			
			<label for="overrideContent">Override blog entries?</label>
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