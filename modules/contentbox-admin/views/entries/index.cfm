<cfoutput>
<!--============================Sidebar============================-->
<div class="sidebar">
	<!--- Saerch Box --->
	<div class="small_box">
		<div class="header">
			<img src="#prc.cbroot#/includes/images/search.png" alt="info" width="24" height="24" />Search
		</div>
		<div class="body<cfif len(rc.searchEntries)> selected</cfif>">
			<!--- Search Form --->
			#html.startForm(name="authorSearchForm",action=prc.xehEntrySearch)#
				#html.textField(label="Search:",name="searchEntries",class="textfield",size="16",title="Search all entries",value=event.getValue("searchEntries",""))#
				<input type="submit" value="Search" class="buttonred" />
				<button class="button" onclick="return to('#event.buildLink(prc.xehEntries)#')">Clear</button>				
			#html.endForm()#
		</div>
	</div>	
	
	<!--- Filter Box --->
	<div class="small_box">
		<div class="header">
			<img src="#prc.cbroot#/includes/images/filter.png" alt="info" width="24" height="24" />Filters
		</div>
		<div class="body<cfif rc.isFiltering> selected</cfif>">
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
				<input type="submit" value="Apply Filters" class="buttonred" />
				<button class="button" onclick="return to('#event.buildLink(prc.xehEntries)#')">Reset</button>				
			</div>
			
			#html.endForm()#
		</div>
	</div>	
	
	<!--- Help Box--->
	<div class="small_box" id="help_tips">
		<div class="header">
			<img src="#prc.cbroot#/includes/images/help.png" alt="info" width="24" height="24" />Help Tips
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
			<img src="#prc.cbroot#/includes/images/blog.png" alt="sofa" width="30" height="30" />
			Blog Entries (#prc.entriesCount#)
			<cfif len(rc.searchEntries)> > Search: #event.getValue("searchEntries")#</cfif>
			<cfif rc.isFiltering> > Filtered View</cfif>
		</div>
		<!--- Body --->
		<div class="body">
			
			<!--- MessageBox --->
			#getPlugin("MessageBox").renderit()#
			
			<!--- entryForm --->
			#html.startForm(name="entryForm",action=prc.xehEntryRemove)#
			<input type="hidden" name="contentID" id="contentID" value="" />
			
			<!--- Info Bar --->
			<cfif NOT prc.cbSettings.cb_comments_enabled>
				<div class="infoBar">
					<img src="#prc.cbRoot#/includes/images/info.png" alt="comments" />
					Comments are currently disabled site-wide!
				</div>
			</cfif>
			
			<!--- Content Bar --->
			<div class="contentBar" id="contentBar">
				
				<!--- Create Butons --->
				<cfif prc.oAuthor.checkPermission("ENTRIES_ADMIN") OR prc.oAuthor.checkPermission("ENTRIES_EDITOR")>
				<div class="buttonBar">
					<button class="button2" onclick="return to('#event.buildLink(prc.xehEntryEditor)#');" title="Create new entry">Create Entry</button>
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
						<th>Name</th>
						<th width="150">Categories</th>
						<th width="125">Dates</th>
						<th width="40" class="center"><img src="#prc.cbRoot#/includes/images/publish.png" alt="publish"/></th>
						<th width="40" class="center"><img src="#prc.cbRoot#/includes/images/glasses.png" alt="hits"/></th>
						<th width="40" class="center"><img src="#prc.cbRoot#/includes/images/comments.png" alt="comments"/></th>
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
						<td>
							<cfif prc.oAuthor.checkPermission("ENTRIES_EDITOR") OR prc.oAuthor.checkPermission("ENTRIES_ADMIN")>
								<a href="#event.buildLink(prc.xehBlogEditor)#/contentID/#entry.getContentID()#" title="Edit Entry">#entry.getTitle()#</a>
							<cfelse>
								#entry.getTitle()#
							</cfif>
							<br/>
							Last edit by <a href="mailto:#entry.getAuthorEmail()#">#entry.getAuthorName()#</a></br>
							<!--- password protect --->
							<cfif entry.isPasswordProtected()>
								<img src="#prc.cbRoot#/includes/images/lock.png" alt="locked" title="Entry is password protected"/>
							<cfelse>
								<img src="#prc.cbRoot#/includes/images/lock_off.png" alt="locked" title="Entry is public"/>
							</cfif>
							&nbsp;
							<!--- comments icon --->
							<cfif entry.getallowComments()>
								<img src="#prc.cbRoot#/includes/images/comments.png" alt="locked" title="Commenting is Open!"/>
							<cfelse>
								<img src="#prc.cbRoot#/includes/images/comments_off.png" alt="locked" title="Commenting is Closed!"/>
							</cfif>
						</td>
						<td>#entry.getCategoriesList()#</td>
						<td>
							<strong title="Published Date">P:</strong> #entry.getDisplayPublishedDate()#<br/>
							<strong title="Expire Date">E:</strong> #entry.getDisplayExpireDate()#<br/>
							<strong title="Created Date">C:</strong> #entry.getDisplayCreatedDate()#
						</td>
						<td class="center">
							<cfif entry.isExpired()>
								<img src="#prc.cbRoot#/includes/images/button_cancel.png" alt="expired" title="Entry has expired!" />
								<span class="hidden">expired</span>
							<cfelseif entry.isPublishedInFuture()>
								<img src="#prc.cbRoot#/includes/images/information.png" alt="published" title="Entry Publishes in the future!" />
								<span class="hidden">published in future</span>
							<cfelseif entry.isContentPublished()>
								<img src="#prc.cbRoot#/includes/images/button_ok.png" alt="published" title="Entry Published!" />
								<span class="hidden">published in future</span>
							<cfelse>
								<img src="#prc.cbRoot#/includes/images/button_cancel.png" alt="draft" title="Entry Draft!" />
								<span class="hidden">draft</span>
							</cfif>
						</td>
						<td class="center">#entry.getHits()#</td>
						<td class="center">#entry.getNumberOfComments()#</td>
						<td class="center">
							<cfif prc.oAuthor.checkPermission("ENTRIES_EDITOR") OR prc.oAuthor.checkPermission("ENTRIES_ADMIN")>
							<!--- Edit Command --->
							<a href="#event.buildLink(prc.xehEntryEditor)#/contentID/#entry.getContentID()#" title="Edit #entry.getTitle()#"><img src="#prc.cbroot#/includes/images/edit.png" alt="edit" border="0"/></a>
							&nbsp;
							</cfif>
							<!--- History Command --->
							<a href="#event.buildLink(prc.xehEntryHistory)#/contentID/#entry.getContentID()#" title="Version History"><img src="#prc.cbroot#/includes/images/old-versions.png" alt="versions" border="0"/></a>
							&nbsp;
							<cfif prc.oAuthor.checkPermission("ENTRIES_ADMIN")>
							<!--- Delete Command --->
							<a title="Delete Entry" href="javascript:remove('#entry.getContentID()#')" class="confirmIt" data-title="Delete Entry?"><img id="delete_#entry.getContentID()#" src="#prc.cbroot#/includes/images/delete.png" border="0" alt="delete"/></a>
							&nbsp;
							</cfif>
							<!--- View in Site --->
							<a href="#prc.CBHelper.linkEntry(entry)#" title="View Entry In Site" target="_blank"><img src="#prc.cbroot#/includes/images/eye.png" alt="edit" border="0"/></a>
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