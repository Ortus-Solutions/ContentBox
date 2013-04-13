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
					<cfif prc.oAuthor.checkPermission("ENTRIES_ADMIN") OR prc.oAuthor.checkPermission("ENTRIES_EDITOR")>
					<div class="buttonBar">
						<div class="btn-group">
					    	<a class="btn btn-primary dropdown-toggle" data-toggle="dropdown" href="##">
								Global Actions <span class="caret"></span>
							</a>
					    	<ul class="dropdown-menu">
					    		<li><a href="javascript:bulkChangeStatus('publish')"><i class="icon-ok-sign"></i> Publish</a></li>
								<li><a href="javascript:bulkChangeStatus('draft')"><i class="icon-ban-circle"></i> Draft</a></li>
					    	</ul>
					    </div>
						<button class="btn btn-danger" onclick="return to('#event.buildLink(linkTo=prc.xehEntryEditor)#');">Create Entry</button>
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
				
				<!--- entries --->
				<table name="entries" id="entries" class="tablesorter table table-hover table-striped" width="98%">
					<thead>
						<tr>
							<th id="checkboxHolder" class="{sorter:false}" width="20"><input type="checkbox" onClick="checkAll(this.checked,'contentID')"/></th>
							<th>Name</th>
							<th width="150">Categories</th>
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
							</td>
							<td>#entry.getCategoriesList()#</td>
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
									<i class="icon-calendar"></i> 
									Last edit by <a href="mailto:#entry.getAuthorEmail()#">#entry.getAuthorName()#</a> on 
									#entry.getActiveContent().getDisplayCreatedDate()#
									</br>
									<!--- password protect --->
									<cfif entry.isPasswordProtected()>
										<i class="icon-lock"></i> Password Protected
									<cfelse>
										<i class="icon-unlock"></i> Public Entry
									</cfif>
									<br/>
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
							    	<ul class="dropdown-menu text-left">
							    		<cfif prc.oAuthor.checkPermission("ENTRIES_EDITOR") OR prc.oAuthor.checkPermission("ENTRIES_ADMIN")>
										<!--- Edit Command --->
										<li><a href="#event.buildLink(prc.xehEntryEditor)#/contentID/#entry.getContentID()#"><i class="icon-edit icon-large"></i> Edit</a></li>
										</cfif>
										<!--- History Command --->
										<li><a href="#event.buildLink(prc.xehEntryHistory)#/contentID/#entry.getContentID()#"><i class="icon-time icon-large"></i> History</a></li>
										<cfif prc.oAuthor.checkPermission("ENTRIES_ADMIN")>
										<!--- Delete Command --->
										<li>
											<a href="javascript:remove('#entry.getContentID()#')" class="confirmIt" data-title="Delete Entry?"><i id="delete_#entry.getContentID()#" class="icon-remove-sign icon-large" ></i> Delete</a>
										</li>
										</cfif>
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
</cfoutput>