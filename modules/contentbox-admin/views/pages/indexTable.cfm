<cfoutput>
<!--- Location Bar --->
<cfif structKeyExists(rc, "parent") AND len( rc.parent )>
<div class="breadcrumb">
  <a href="javascript:contentDrilldown()"><i class="icon-home icon-large"></i></a> 
  #getMyPlugin(plugin="PageBreadcrumbVisitor", module="contentbox-admin").visit( prc.page )#
</div>
</cfif>

<!--- Hidden Elements --->
#html.hiddenField(name="parent", value=event.getValue("parent",""))#

<!--- pages --->
<table name="pages" id="pages" class="tablesorter table table-hover" width="98%">
	<thead>
		<tr>
			<th id="checkboxHolder" class="{sorter:false}" width="10"><input type="checkbox" onClick="checkAll(this.checked,'contentID')"/></th>
			<th>Name</th>
			<th width="40" class="center"><i class="icon-th-list icon-large" title="Show in Menu"></i></th>
			<th width="40" class="center"><i class="icon-globe icon-large" title="Published"></i></th>
			<th width="135" class="center {sorter:false}">Actions</th>
		</tr>
	</thead>

	<tbody>
		<cfloop array="#prc.pages#" index="page">
		<tr id="contentID-#page.getContentID()#" data-contentID="#page.getContentID()#"
			<cfif page.isExpired()>
				class="error"
			<cfelseif page.isPublishedInFuture()>
				class="success"
			<cfelseif !page.isContentPublished()>
				class="warning"
			</cfif>
			<!--- double click drill down --->
			<cfif page.getNumberOfChildren()>ondblclick="contentDrilldown( '#page.getContentID()#' )"</cfif>>
			<!--- check box --->
			<td>
				<input type="checkbox" name="contentID" id="contentID" value="#page.getContentID()#" />
			</td>
			<td>
				<!--- Home Page --->
				<cfif prc.cbSettings.cb_site_homepage eq page.getSlug()>
					<i class="icon-home" title="Current Homepage"></i>
				</cfif>
				<!--- Children Dig Deeper --->
				<cfif page.getNumberOfChildren()>
					<a href="javascript:contentDrilldown( '#page.getContentID()#' )" class="hand-cursor" title="View Child Pages (#page.getNumberOfChildren()#)"><i class="icon-plus-sign icon-large text"></i></a>
				<cfelse>
					<i class="icon-circle-blank icon-large"></i>
				</cfif>
				<!--- Title --->
				<cfif prc.oAuthor.checkPermission("PAGES_EDITOR,PAGES_ADMIN")>
					<a href="#event.buildLink(prc.xehPageEditor)#/contentID/#page.getContentID()#" title="Edit #page.getTitle()#">#page.getTitle()#</a>
				<cfelse>
					#page.getTitle()#
				</cfif>
				<!--- Search Label --->
				<cfif len( rc.searchPages ) or prc.isFiltering>
					<br/><span class="label label-success">#page.getSlug()#</span>
				</cfif>
				<!--- password protected --->
				<cfif page.isPasswordProtected()>
					<i class="icon-lock" title="Password Protected"></i>
				</cfif>
				<!--- ssl protected --->
				<cfif page.getSSLOnly()>
					<i class="icon-shield" title="SSL Enabled"></i>
				</cfif>
			</td>
			<td class="center">
				<cfif page.getShowInMenu()>
					<i class="icon-ok icon-large textGreen"></i>
				<cfelse>
					<i class="icon-remove icon-large textRed"></i>
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
			<td class="center">
				<!---Info Panel --->
				<a 	class="btn popovers" 
					data-contentID="#page.getContentID()#"
					data-toggle="popover"><i class="icon-info-sign icon-large"></i></a>
				<!---Info Panel --->
				<div id="infoPanel_#page.getContentID()#" class="hide">
					<!--- creator --->
					<i class="icon-user"></i>
					Created by <a href="mailto:#page.getCreatorEmail()#">#page.getCreatorName()#</a> on 
					#page.getDisplayCreatedDate()#
					</br>
					<!--- last edit --->
					<i class="icon-calendar"></i>
					Last edit by <a href="mailto:#page.getAuthorEmail()#">#page.getAuthorName()#</a> on 
					#page.getActiveContent().getDisplayCreatedDate()#
					</br>
					<!--- Categories --->
					<i class="icon-tag"></i> #page.getCategoriesList()#<br/>
					<!--- comments icon --->
					<cfif page.getallowComments()>
						<i class="icon-comments"></i> Open Comments
					<cfelse>
						<i class="icon-warning-sign"></i> Closed Comments
					</cfif>
					<!---Layouts --->
					<br/>
					<i class="icon-picture"></i> Layout: <strong>#page.getLayout()#</strong>
					<cfif len( page.getMobileLayout() )>
					<br/>
					<i class="icon-tablet"></i> Mobile Layout: <strong>#page.getMobileLayout()#</strong>
					</cfif>
					<br>
					<i class="icon-signal icon-large" title="Hits"></i> Hits: <strong>#page.getNumberOfHits()#</strong>
				</div>
				
				<!--- Page Actions --->
				<div class="btn-group">
			    	<a class="btn dropdown-toggle" data-toggle="dropdown" href="##" title="Page Actions">
						<i class="icon-cogs icon-large"></i>
					</a>
			    	<ul class="dropdown-menu text-left pull-right">
			    		<cfif prc.oAuthor.checkPermission("PAGES_EDITOR,PAGES_ADMIN")>
						<!--- Clone Command --->
						<li><a href="javascript:openCloneDialog('#page.getContentID()#','#URLEncodedFormat(page.getTitle())#')"><i class="icon-copy icon-large"></i> Clone</a></li>
						<!--- Create Child --->
						<li><a href="#event.buildLink(prc.xehPageEditor)#/parentID/#page.getContentID()#"><i class="icon-sitemap icon-large"></i> Create Child</a></li>
						<cfif prc.oAuthor.checkPermission("PAGES_ADMIN")>
						<!--- Delete Command --->
						<li><a href="javascript:remove('#page.getContentID()#')" class="confirmIt"
						  data-title="Delete Page?" data-message="This will delete the page and all of its sub-pages, are you sure?"><i id="delete_#page.getContentID()#" class="icon-trash icon-large"></i> Delete</a></li>
						</cfif>
						<!--- Edit Command --->
						<li><a href="#event.buildLink(prc.xehPageEditor)#/contentID/#page.getContentID()#"><i class="icon-edit icon-large"></i> Edit</a></li>
						</cfif>
						<cfif prc.oAuthor.checkPermission("PAGES_ADMIN,TOOLS_EXPORT")>
						<!--- Export --->
						<li class="dropdown-submenu pull-left">
							<a href="##"><i class="icon-download icon-large"></i> Export</a>
							<ul class="dropdown-menu text-left">
								<li><a href="#event.buildLink(linkto=prc.xehPageExport)#/contentID/#page.getContentID()#.json" target="_blank"><i class="icon-code"></i> as JSON</a></li>
								<li><a href="#event.buildLink(linkto=prc.xehPageExport)#/contentID/#page.getContentID()#.xml" target="_blank"><i class="icon-sitemap"></i> as XML</a></li>
							</ul>
						</li>
						</cfif>
						<!--- History Command --->
						<li><a href="#event.buildLink(prc.xehPageHistory)#/contentID/#page.getContentID()#"><i class="icon-time icon-large"></i> History</a></li>
						<!--- View in Site --->
						<li><a href="#prc.CBHelper.linkPage(page)#" target="_blank"><i class="icon-eye-open icon-large"></i> Open In Site</a></li>
			    	</ul>
			    </div>
			    <!--- Drag Handle --->
				<a href="##" onclick="return false;" class="dragHandle btn btn-default" title="Click and drag to change menu order"><i class="icon-move"></i></a>
				</td>
		</tr>
		</cfloop>
	</tbody>
</table>

<!--- Paging --->
<cfif !rc.showAll>
#prc.pagingPlugin.renderit(foundRows=prc.pagesCount, link=prc.pagingLink, asList=true)#
<cfelse>
<span class="label label-info">Total Records: #prc.pagesCount#</span>
</cfif>

</cfoutput>