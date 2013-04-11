<cfoutput>
<!--============================Sidebar============================-->
<div class="sidebar">
	<!--- Saerch Box --->
	<div class="small_box">
		<div class="header">
			<i class="icon-search"></i> Search
		</div>
		<div class="body<cfif len(rc.searchPages)> selected</cfif>">
			<!--- Search Form --->
			#html.startForm(name="authorSearchForm",action=prc.xehPageSearch)#
				#html.textField(label="Search:",name="searchPages",class="textfield",size="16",title="Search all pages",value=event.getValue("searchPages",""))#
				<input type="submit" value="Search" class="btn btn-danger" />
				<button class="btn" onclick="return to('#event.buildLink(prc.xehPages)#')">Clear</button>
			#html.endForm()#
		</div>
	</div>

	<!--- Filter Box --->
	<div class="small_box">
		<div class="header">
			<i class="icon-filter"></i> Filters
		</div>
		<div class="body<cfif prc.isFiltering> selected</cfif>">
			#html.startForm(name="pageFilterForm",action=prc.xehPageSearch)#
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
			<label for="fStatus">Page Status: </label>
			<select name="fStatus" id="fStatus" style="width:200px">
				<option value="any"   <cfif rc.fStatus eq "any">selected="selected"</cfif>>Any Status</option>
				<option value="true"  <cfif rc.fStatus eq "true">selected="selected"</cfif>>Published</option>
				<option value="false" <cfif rc.fStatus eq "false">selected="selected"</cfif>>Draft</option>
			</select>

			<div class="actionBar">
				<input type="submit" value="Apply Filters" class="btn btn-danger" />
				<button class="btn" onclick="return to('#event.buildLink(prc.xehPages)#')">Reset</button>
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
				<li title="Click Me!" onclick="exposeIt('##pages')">Right click on a row to activate quick look!</li>
				<li title="Click Me!" onclick="exposeIt('##main_column')">Sorting is only done within your paging window</li>
				<li title="Click Me!" onclick="exposeIt('##contentBar')">Quick Filtering is only for viewed results</li>
				<li>Cloning does not copy comments or version history</li>
				<li>You can quickly order the pages by dragging the rows</li>
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
			<i class="icon-file-alt icon-large"></i>
			Pages
			<cfif len(rc.searchPages)><span class="badge">Search: #rc.searchPages#</span></cfif>
			<cfif prc.isFiltering> <span class="badge">Filtered View</span></cfif>
		</div>
		<!--- Body --->
		<div class="body">

			<!--- MessageBox --->
			#getPlugin("MessageBox").renderit()#

			<!--- pageForm --->
			#html.startForm(name="pageForm",action=prc.xehPageRemove)#
			#html.hiddenField(name="contentStatus",value="")#
			#html.hiddenField(name="contentID",value="")#
			#html.hiddenField(name="parent",value=event.getValue("parent",""))#

			<!--- Info Bar --->
			<cfif NOT prc.cbSettings.cb_comments_enabled>
				<div class="alert alert-info">
					<i class="icon-exclamation-sign icon-large"></i>
					Comments are currently disabled site-wide!
				</div>
			</cfif>

			<!--- Content Bar --->
			<div class="contentBar" id="contentBar">

				<!--- Create Butons --->
				<cfif prc.oAuthor.checkPermission("PAGES_ADMIN") or prc.oAuthor.checkPermission("PAGES_EDITOR")>
				<div class="buttonBar">
					<button class="btn btn-primary" onclick="return bulkChangeStatus('publish')" title="Bulk Publish Content">Publish</button>
					<button class="btn btn-primary" onclick="return bulkChangeStatus('draft')" title="Bulk Draft Content">Draft</button>
					<button class="btn btn-danger" onclick="return to('#event.buildLink(linkTo=prc.xehPageEditor)#/parentID/#event.getValue('parent','')#');">Create Page</button>
				</div>
				</cfif>

				<!--- Filter Bar --->
				<div class="filterBar">
					<div>
						#html.label(field="pageFilter",content="Quick Filter:",class="inline")#
						#html.textField(name="pageFilter",size="30",class="textfield")#
					</div>
				</div>
			</div>

			<!--- Paging --->
			#prc.pagingPlugin.renderit(prc.pagesCount,prc.pagingLink)#

			<!--- Location Bar --->
			<cfif structKeyExists(rc, "parent") AND len( rc.parent )>
			<div class="alert alert-info">
			  <a href="#event.buildLink(prc.xehPages)#"><i class="icon-home icon-large"></i></a> 
			  #getMyPlugin(plugin="PageBreadcrumbVisitor",module="contentbox-admin").visit(prc.page, event.buildLink(prc.xehPages))#
			</div>
			</cfif>

			<!--- pages --->
			<table name="pages" id="pages" class="tablesorter" width="98%">
				<thead>
					<tr>
						<th id="checkboxHolder" class="{sorter:false}" width="20"><input type="checkbox" onClick="checkAll(this.checked,'contentID')"/></th>
						<th>Name</th>
						<th width="150">Categories</th>
						<th width="40" class="center"><i class="icon-th-list icon-large" title="Show in Menu"></i></th>
						<th width="40" class="center"><i class="icon-globe icon-large" title="Published"></i></th>
						<th width="40" class="center"><i class="icon-signal icon-large" title="Hits"></i></th>
						<th width="100" class="center {sorter:false}">Actions</th>
					</tr>
				</thead>

				<tbody>
					<cfloop array="#prc.pages#" index="page">
					<tr id="contentID-#page.getContentID()#" data-contentID="#page.getContentID()#"
						<cfif page.isExpired()>
							class="expired"
						<cfelseif page.isPublishedInFuture()>
							class="futurePublished"
						<cfelseif !page.isContentPublished()>
							class="selected"
						</cfif>
						<cfif page.getNumberOfChildren()>ondblclick="to('#event.buildLink(prc.xehPages)#/parent/#page.getContentID()#')"</cfif>>
						<!--- check box --->
						<td>
							<input type="checkbox" name="contentID" id="contentID" value="#page.getContentID()#" />
						</td>
						<td>
							<!--- Children Dig Deeper --->
							<cfif page.getNumberOfChildren()>
								<a href="#event.buildLink(prc.xehPages)#/parent/#page.getContentID()#" class="hand-cursor" title="View Child Pages (#page.getNumberOfChildren()#)"><i class="icon-plus-sign icon-large"></i></a>
							<cfelse>
								<i class="icon-circle-blank icon-large"></i>
							</cfif>
							<!--- Title --->
							<cfif prc.oAuthor.checkPermission("PAGES_EDITOR") OR prc.oAuthor.checkPermission("PAGES_ADMIN")>
								<a href="#event.buildLink(prc.xehPageEditor)#/contentID/#page.getContentID()#" title="Edit #page.getTitle()#">#page.getTitle()#</a>
							<cfelse>
								#page.getTitle()#
							</cfif>
						</td>
						<td>#page.getCategoriesList()#</td>
						<td class="center">
							<cfif page.getShowInMenu()>
								<i class="icon-ok icon-large textGreen" title="Shows in menu"></i>
							<cfelse>
								<i class="icon-remove icon-large textRed" title="Not in menu"></i>
							</cfif>
						</td>
						<td class="center">
							<cfif page.isExpired()>
								<i class="icon-time icon-large textRed" title="Page has expired on ( (#page.getDisplayExpireDate()#))"></i>
								<span class="hidden">expired</span>
							<cfelseif page.isPublishedInFuture()>
								<i class="icon-fighter-jet icon-large textBlue" title="Page Publishes in the future (#page.getDisplayPublishedDate()#)"></i>
								<span class="hidden">published in future</span>
							<cfelseif page.isContentPublished()>
								<i class="icon-ok icon-large textGreen" title="Page Published"></i>
								<span class="hidden">published in future</span>
							<cfelse>
								<i class="icon-remove icon-large textRed" title="Page Draft"></i>
								<span class="hidden">draft</span>
							</cfif>
						</td>
						<td class="center"><span class="badge badge-info">#page.getHits()#</span></td>
						<td class="center">
							<!---Info Panel --->
							<button class="btn  infoPanelButton" title="Page Info" ><i class="icon-info-sign icon-large"></i></button>
							<!---Info Panel --->
							<div id="infoPanel_#page.getContentID()#" class="contentInfoPanel">
								<i class="icon-calendar"></i>
								Last edit by <a href="mailto:#page.getAuthorEmail()#">#page.getAuthorName()#</a> on 
								#page.getActiveContent().getDisplayCreatedDate()#
								</br>
								<!--- password protect --->
								<cfif page.isPasswordProtected()>
									<i class="icon-lock"></i> Password Protected
								<cfelse>
									<i class="icon-unlock"></i> Public Page
								</cfif>
								<br/>
								<!--- comments icon --->
								<cfif page.getallowComments()>
									<i class="icon-comments"></i> Open Comments
								<cfelse>
									<i class="icon-warning-sign"></i> Closed Comments
								</cfif>
								<!---Layouts --->
								<br/>
								<i class="icon-picture"></i> Layout: <strong>#page.getLayout()#</strong>
								<br/>
								<i class="icon-tablet"></i> Mobile Layout: <strong>#page.getMobileLayout()#</strong>
							</div>
							
							<!---Page Actions --->
							<button class="btn  actionsPanelButton" title="Page Actions" ><i class="icon-cogs icon-large"></i></button>
							<!---Page Actions Panel --->
							<div id="pageActions_#page.getContentID()#" class="actionsPanel">
								<cfif prc.oAuthor.checkPermission("PAGES_EDITOR") OR prc.oAuthor.checkPermission("PAGES_ADMIN")>
								<!--- Clone Command --->
								<a href="javascript:openCloneDialog('#page.getContentID()#','#URLEncodedFormat(page.getTitle())#')"><i class="icon-copy icon-large"></i> Clone</a>
								<br/>
								<!--- Create Child --->
								<a href="#event.buildLink(prc.xehPageEditor)#/parentID/#page.getContentID()#"><i class="icon-sitemap icon-large"></i> Create Child</a>
								<br/>
								</cfif>
								<!--- History Command --->
								<a href="#event.buildLink(prc.xehPageHistory)#/contentID/#page.getContentID()#"><i class="icon-time icon-large"></i> History</a>
								<br/>
								<cfif prc.oAuthor.checkPermission("PAGES_ADMIN")>
								<!--- Delete Command --->
								<a href="javascript:remove('#page.getContentID()#')" class="confirmIt"
								  data-title="Delete Page?" data-message="This will delete the page and all of its sub-pages, are you sure?"><i id="delete_#page.getContentID()#" class="icon-remove-sign icon-large"/> Delete</i></a>
								<br/>
								</cfif>
								<!--- View in Site --->
								<a href="#prc.CBHelper.linkPage(page)#" target="_blank"><i class="icon-eye-open icon-large"></i> View Page</a>
							</div>
							</td>
					</tr>
					</cfloop>
				</tbody>
			</table>

			<!--- Paging --->
			#prc.pagingPlugin.renderit(prc.pagesCount,prc.pagingLink)#

			#html.endForm()#
		</div>
	</div>
</div>
<cfif prc.oAuthor.checkPermission("PAGES_EDITOR") OR prc.oAuthor.checkPermission("PAGES_ADMIN")>
<div id="cloneDialog" class="modal">
	<div id="modalContent">
		<h2>Page Cloning</h2>
		<p>By default, all internal page links are updated for you as part of the cloning process.</p>
		#html.startForm(name="cloneForm", action=prc.xehPageClone)#
			#html.hiddenField(name="contentID")#
			#html.textfield(name="title", label="Please enter the new page title:", class="textfield", required="required", size="50")#
			<label for="pageStatus">Publish all pages in hierarchy?</label>
			<small>By default all cloned pages are published as drafts.</small><br>
			#html.select(options="true,false", name="pageStatus", selectedValue="false")#
			
			<div class="alert alert-info">Please note that cloning is an expensive process, so please be patient when cloning big hierarchical content trees.</div>
			<hr/>
			<!--- Button Bar --->
			<div id="bottomCenteredBar" class="textRight">
				<button class="btn btn-primary" id="cloneButton"> Clone </button>
				<button class="btn btn-danger" id="closeButton"> Cancel </button>
			</div>
			<!--- Loader --->
			<div class="center loaders" id="clonerBarLoader">
				<i class="icon-spinner icon-spin icon-large"></i>
				<br>Please wait, doing some hardcore cloning action...
			</div>
		#html.endForm()#
	</div>
</div>
</cfif>
</cfoutput>