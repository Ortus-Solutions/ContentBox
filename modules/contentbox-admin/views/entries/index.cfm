<cfoutput>
<!--============================Sidebar============================-->
<div class="sidebar">
	<!--- Saerch Box --->
	<div class="small_box">
		<div class="header">
			<i class="icon-search"></i> Search
		</div>
		<div class="body<cfif len(rc.searchEntries)> selected</cfif>">
			<!--- Search Form --->
			#html.startForm(name="authorSearchForm",action=prc.xehEntrySearch)#
				#html.textField(label="Search:",name="searchEntries",class="textfield",size="16",title="Search all entries",value=event.getValue("searchEntries",""))#
				<input type="submit" value="Search" class="btn btn-danger" />
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
			<select name="fAuthors" id="fAuthors" style="width:200px">
				<option value="all" <cfif rc.fAuthors eq "all">selected="selected"</cfif>>All Authors</option>
				<cfloop array="#prc.authors#" index="author">
				<option value="#author.getAuthorID()#" <cfif rc.fAuthors eq author.getAuthorID()>selected="selected"</cfif>>#author.getName()#</option>
				</cfloop>
			</select>
			<!--- Categories --->
			<label for="fCategories">Categories: </label>
			<select name="fCategories" id="fCategories" style="width:200px">
				<option value="all" <cfif rc.fCategories eq "all">selected="selected"</cfif>>All Categories</option>
				<option value="none" <cfif rc.fCategories eq "none">selected="selected"</cfif>>Uncategorized</option>
				<cfloop array="#prc.categories#" index="category">
				<option value="#category.getCategoryID()#" <cfif rc.fCategories eq category.getCategoryID()>selected="selected"</cfif>>#category.getCategory()#</option>
				</cfloop>
			</select>
			<!--- Status --->
			<label for="fStatus">Entry Status: </label>
			<select name="fStatus" id="fStatus" style="width:200px">
				<option value="any"   <cfif rc.fStatus eq "any">selected="selected"</cfif>>Any Status</option>
				<option value="true"  <cfif rc.fStatus eq "true">selected="selected"</cfif>>Published</option>
				<option value="false" <cfif rc.fStatus eq "false">selected="selected"</cfif>>Draft</option>				
			</select>
				
			<div class="actionBar">
				<input type="submit" value="Apply Filters" class="btn btn-danger" />
				<button class="btn" onclick="return to('#event.buildLink(prc.xehEntries)#')">Reset</button>				
			</div>
			
			#html.endForm()#
		</div>
	</div>	
	
	<!--- Help Box--->
	<div class="small_box" id="help_tips">
		<div class="header">
			<i class="icon-question-sign"></i> Help Tips
		</div>
		<div class="body">
			<ul class="tipList">
				<li title="Click Me!" onclick="exposeIt('##entries')">Right click on a row to activate quick look!</li>
				<li title="Click Me!" onclick="exposeIt('##main_column')">Sorting is only done within your paging window</li>
				<li title="Click Me!" onclick="exposeIt('##contentBar')">Quick Filtering is only for viewed results</li>
			</ul>
		</div>
	</div>		
</div>
<!--End sidebar-->	
<!--============================Main Column============================-->
<div class="main_column" id="main_column">
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
					<button class="btn btn-primary" onclick="return bulkChangeStatus('publish')" title="Bulk Publish Content">Publish</button>
					<button class="btn btn-primary" onclick="return bulkChangeStatus('draft')" title="Bulk Draft Content">Draft</button>
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
			
			<!--- Paging --->
			#prc.pagingPlugin.renderit(prc.entriesCount,prc.pagingLink)#
		
			<!--- entries --->
			<table name="entries" id="entries" class="tablesorter" width="98%">
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
							<button class="btn  infoPanelButton" title="Entry Info" ><i class="icon-info-sign icon-large"></i></button>
							<!---Info Panel --->
							<div id="infoPanel_#entry.getContentID()#" class="contentInfoPanel">
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
							
							<!---Entry Actions --->
							<button class="btn  actionsPanelButton" title="Entry Actions" ><i class="icon-cogs icon-large"></i></button>
							<!---Entry Actions Panel --->
							<div id="entryActions_#entry.getContentID()#" class="actionsPanel">
								<cfif prc.oAuthor.checkPermission("ENTRIES_EDITOR") OR prc.oAuthor.checkPermission("ENTRIES_ADMIN")>
								<!--- Edit Command --->
								<a href="#event.buildLink(prc.xehEntryEditor)#/contentID/#entry.getContentID()#"><i class="icon-edit icon-large"></i> Edit</a>
								<br/>
								</cfif>
								<!--- History Command --->
								<a href="#event.buildLink(prc.xehEntryHistory)#/contentID/#entry.getContentID()#"><i class="icon-time icon-large"></i> History</a>
								<br/>
								<cfif prc.oAuthor.checkPermission("ENTRIES_ADMIN")>
								<!--- Delete Command --->
								<a href="javascript:remove('#entry.getContentID()#')" class="confirmIt" data-title="Delete Entry?"><i id="delete_#entry.getContentID()#" class="icon-remove-sign icon-large" ></i> Delete</a>
								<br/>
								</cfif>
								<!--- View in Site --->
								<a href="#prc.CBHelper.linkEntry(entry)#" target="_blank"><i class="icon-eye-open icon-large"></i> Open In Site</a>
							</div>
							
							</td>
					</tr>
					</cfloop>
				</tbody>
			</table>
			
			<!--- Paging --->
			#prc.pagingPlugin.renderit(prc.entriesCount,prc.pagingLink)#
		
			#html.endForm()#

		</div>	
	</div>
</div>
</cfoutput>