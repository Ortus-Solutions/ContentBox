<cfoutput>
<!--============================Sidebar============================-->
<div class="sidebar">
	<!--- Saerch Box --->
	<div class="small_box">
		<div class="header">
			<img src="#prc.bbroot#/includes/images/search.png" alt="info" width="24" height="24" />Search
		</div>
		<div class="body<cfif len(rc.searchEntries)> selected</cfif>">
			<!--- Search Form --->
			#html.startForm(name="authorSearchForm",action=rc.xehEntrySearch)#
				#html.textField(label="Search:",name="searchEntries",class="textfield",size="16",title="Search all entries",value=event.getValue("searchEntries",""))#
				<input type="submit" value="Search" class="buttonred" />
				<button class="button" onclick="return to('#event.buildLink(prc.xehEntries)#')">Clear</button>				
			#html.endForm()#
		</div>
	</div>	
	
	<!--- Filter Box --->
	<div class="small_box">
		<div class="header">
			<img src="#prc.bbroot#/includes/images/filter.png" alt="info" width="24" height="24" />Filters
		</div>
		<div class="body<cfif rc.isFiltering> selected</cfif>">
			#html.startForm(name="entryFilterForm",action=rc.xehEntrySearch)#
			<!--- Authors --->
			<label for="fAuthors">Authors: </label>
			<select name="fAuthors" id="fAuthors" style="width:200px">
				<option value="all" <cfif rc.fAuthors eq "all">selected="selected"</cfif>>All Authors</option>
				<cfloop array="#rc.authors#" index="author">
				<option value="#author.getAuthorID()#" <cfif rc.fAuthors eq author.getAuthorID()>selected="selected"</cfif>>#author.getName()#</option>
				</cfloop>
			</select>
			<!--- Categories --->
			<label for="fCategories">Categories: </label>
			<select name="fCategories" id="fCategories" style="width:200px">
				<option value="all" <cfif rc.fCategories eq "all">selected="selected"</cfif>>All Categories</option>
				<option value="none" <cfif rc.fCategories eq "none">selected="selected"</cfif>>Uncategorized</option>
				<cfloop array="#rc.categories#" index="category">
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
			<img src="#prc.bbroot#/includes/images/help.png" alt="info" width="24" height="24" />Help Tips
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
			<img src="#prc.bbroot#/includes/images/blog.png" alt="sofa" width="30" height="30" />
			Blog Entries (#rc.entriesCount#)
			<cfif len(rc.searchEntries)> > Search: #event.getValue("searchEntries")#</cfif>
			<cfif rc.isFiltering> > Filtered View</cfif>
		</div>
		<!--- Body --->
		<div class="body">
			
			<!--- MessageBox --->
			#getPlugin("MessageBox").renderit()#
			
			<!--- entryForm --->
			#html.startForm(name="entryForm",action=rc.xehEntryRemove)#
			<input type="hidden" name="entryID" id="entryID" value="" />
			
			<!--- Info Bar --->
			<cfif NOT prc.bbSettings.bb_comments_enabled>
				<div class="infoBar">
					<img src="#prc.bbRoot#/includes/images/info.png" alt="comments" />
					Comments are currently disabled site-wide!
				</div>
			</cfif>
			
			<!--- Content Bar --->
			<div class="contentBar" id="contentBar">
				
				<!--- Create Butons --->
				<div class="buttonBar">
					<button class="button2" onclick="return to('#event.buildLink(rc.xehEntryEditor)#');" title="Create new entry">Create Entry</button>
				</div>
				
				<!--- Filter Bar --->
				<div class="filterBar">
					<div>
						#html.label(field="entryFilter",content="Quick Filter:",class="inline")#
						#html.textField(name="entryFilter",size="30",class="textfield")#
					</div>
				</div>
			</div>
			
			<!--- Paging --->
			#rc.pagingPlugin.renderit(rc.entriesCount,rc.pagingLink)#
		
			<!--- entries --->
			<table name="entries" id="entries" class="tablesorter" width="98%">
				<thead>
					<tr>
						<th>Name</th>
						<th>Author</th>			
						<th>Categories</th>
						<th width="125">Dates</th>
						<th width="40" class="center"><img src="#prc.bbRoot#/includes/images/publish.png" alt="publish"/></th>
						<th width="40" class="center"><img src="#prc.bbRoot#/includes/images/glasses.png" alt="hits"/></th>
						<th width="40" class="center"><img src="#prc.bbRoot#/includes/images/comments.png" alt="comments"/></th>
						<th width="70" class="center {sorter:false}">Actions</th>
					</tr>
				</thead>
				
				<tbody>
					<cfloop array="#rc.entries#" index="entry">
					<tr data-entryID="#entry.getEntryID()#" <cfif NOT entry.getIsPublished()>class="selected"</cfif>>
						<td>
							<a href="#event.buildLink(prc.xehBlogEditor)#/entryID/#entry.getEntryID()#" title="Edit Entry">#entry.getTitle()#</a><br/>
							<!--- password protect --->
							<cfif entry.isPasswordProtected()>
								<img src="#prc.bbRoot#/includes/images/lock.png" alt="locked" title="Entry is password protected"/>
							<cfelse>
								<img src="#prc.bbRoot#/includes/images/lock_off.png" alt="locked" title="Entry is public"/>
							</cfif>
							&nbsp;
							<!--- comments icon --->
							<cfif entry.getallowComments()>
								<img src="#prc.bbRoot#/includes/images/comments.png" alt="locked" title="Commenting is Open!"/>
							<cfelse>
								<img src="#prc.bbRoot#/includes/images/comments_off.png" alt="locked" title="Commenting is Closed!"/>
							</cfif>
						</td>
						<td>#entry.getAuthorName()#</td>
						<td>#entry.getCategoriesList()#</td>
						<td>
							<strong title="Published Date">P:</strong> #entry.getDisplayPublishedDate()#<br/>
							<strong title="Created Date">C:</strong> #entry.getDisplayCreatedDate()#
						</td>
						<td class="center">
							<cfif entry.getIsPublished()>
								<img src="#prc.bbRoot#/includes/images/button_ok.png" alt="published" title="Entry Published!" />
								<span class="hidden">published</span>
							<cfelse>
								<img src="#prc.bbRoot#/includes/images/button_cancel.png" alt="draft" title="Entry Draft!" />
								<span class="hidden">draft</span>
							</cfif>
						</td>
						<td class="center">#entry.getHits()#</td>
						<td class="center">#entry.getNumberOfComments()#</td>
						<td class="center">
							<!--- Edit Command --->
							<a href="#event.buildLink(rc.xehEntryEditor)#/entryID/#entry.getEntryID()#" title="Edit #entry.getTitle()#"><img src="#prc.bbroot#/includes/images/edit.png" alt="edit" border="0"/></a>
							&nbsp;
							<!--- View in Site --->
							<a href="#prc.bbHelper.linkEntry(entry)#" title="View Entry In Site" target="_blank"><img src="#prc.bbroot#/includes/images/eye.png" alt="edit" border="0"/></a>
							&nbsp;
							<!--- Delete Command --->
							<a title="Delete Entry" href="javascript:remove('#entry.getEntryID()#')" class="confirmIt" data-title="Delete Entry?"><img id="delete_#entry.getEntryID()#" src="#prc.bbroot#/includes/images/delete.png" border="0" alt="delete"/></a>
						</td>
					</tr>
					</cfloop>
				</tbody>
			</table>
			
			<!--- Paging --->
			#rc.pagingPlugin.renderit(rc.entriesCount,rc.pagingLink)#
		
			#html.endForm()#

		</div>	
	</div>
</div>

<script type="text/javascript">
$(document).ready(function() {
	$("##entries").tablesorter();
	$("##entryFilter").keyup(function(){
		$.uiTableFilter( $("##entries"), this.value );
	});
	// quick look
	$("##entries").find("tr").bind("contextmenu",function(e) {
	    if (e.which === 3) {
	    	if($(this).attr('data-entryID') != null) {
				openRemoteModal('#event.buildLink(rc.xehEntryQuickLook)#/entryID/' + $(this).attr('data-entryID'));
				e.preventDefault();
			}
	    }
	});

});
function remove(entryID){
	$("##entryID").val( entryID );
	$("##entryForm").submit();
}
</script>

</cfoutput>