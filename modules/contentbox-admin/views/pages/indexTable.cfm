<cfoutput>
<!--- Location Bar --->
<cfif structKeyExists(rc, "parent") AND len( rc.parent )>
	<div class="breadcrumb">
	  	<a href="javascript:contentDrilldown()"><i class="fa fa-home"></i></a> 
	  	#getMyPlugin(plugin="PageBreadcrumbVisitor", module="contentbox-admin").visit( prc.page )#
	</div>
</cfif>

<!--- Hidden Elements --->
#html.hiddenField(name="parent", value=event.getValue("parent",""))#

<!--- pages --->
<table id="pages" name="pages" class="table table-striped table-bordered" cellspacing="0" width="100%">
    <thead>
        <tr>
            <th id="checkboxHolder" class="{sorter:false}" width="20">
            	<input type="checkbox" onClick="checkAll(this.checked,'contentID')"/>
            </th>
			<th>Name</th>
			<th width="40" class="center"><i class="fa fa-th-list icon-large" title="Show in Menu"></i></th>
			<th width="40" class="center"><i class="fa fa-globe icon-large" title="Published"></i></th>
			<th width="40" class="center"><i class="fa fa-signal icon-large" title="Hits"></i></th>
			<th width="100" class="center {sorter:false}">Actions</th>
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
					<!--- Children Dig Deeper --->
					<cfif page.getNumberOfChildren()>
						<a href="javascript:contentDrilldown( '#page.getContentID()#' )" class="hand-cursor" title="View Child Pages (#page.getNumberOfChildren()#)"><i class="fa fa-plus-sign icon-large text"></i></a>
					<cfelse>
						<i class="fa fa-circle-blank icon-large"></i>
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
						<i class="fa fa-lock"></i>
					</cfif>
				</td>
				<td class="center">
					<cfif page.getShowInMenu()>
						<i class="fa fa-check icon-large textGreen"></i>
					<cfelse>
						<i class="fa fa-remove icon-large textRed"></i>
					</cfif>
				</td>
				<td class="center">
					<cfif page.isExpired()>
						<i class="fa fa-time icon-large textRed" title="Page has expired on ( (#page.getDisplayExpireDate()#))"></i>
						<span class="hidden">expired</span>
					<cfelseif page.isPublishedInFuture()>
						<i class="fa fa-fighter-jet icon-large textBlue" title="Page Publishes in the future (#page.getDisplayPublishedDate()#)"></i>
						<span class="hidden">published in future</span>
					<cfelseif page.isContentPublished()>
						<i class="fa fa-check icon-large textGreen" title="Page Published"></i>
						<span class="hidden">published in future</span>
					<cfelse>
						<i class="fa fa-remove icon-large textRed" title="Page Draft"></i>
						<span class="hidden">draft</span>
					</cfif>
				</td>
				<td class="center"><span class="badge badge-info">#page.getHits()#</span></td>
				<td class="center">
					<!---Info Panel --->
					<a 	class="btn popovers" 
						data-contentID="#page.getContentID()#"
						data-toggle="popover"><i class="fa fa-info-circle icon-large"></i></a>
					<!---Info Panel --->
					<div id="infoPanel_#page.getContentID()#" class="hide">
						<!--- creator --->
						<i class="fa fa-user"></i>
						Created by <a href="mailto:#page.getCreatorEmail()#">#page.getCreatorName()#</a> on 
						#page.getDisplayCreatedDate()#
						</br>
						<!--- last edit --->
						<i class="fa fa-calendar"></i>
						Last edit by <a href="mailto:#page.getAuthorEmail()#">#page.getAuthorName()#</a> on 
						#page.getActiveContent().getDisplayCreatedDate()#
						</br>
						<!--- Categories --->
						<i class="fa fa-tag"></i> #page.getCategoriesList()#<br/>
						<!--- comments icon --->
						<cfif page.getallowComments()>
							<i class="fa fa-comments"></i> Open Comments
						<cfelse>
							<i class="fa fa-warning"></i> Closed Comments
						</cfif>
						<!---Layouts --->
						<br/>
						<i class="fa fa-picture-o"></i> Layout: <strong>#page.getLayout()#</strong>
						<cfif len( page.getMobileLayout() )>
						<br/>
						<i class="fa fa-tablet"></i> Mobile Layout: <strong>#page.getMobileLayout()#</strong>
						</cfif>
					</div>
					
					<!--- Page Actions --->
					<div class="btn-group">
				    	<a class="btn dropdown-toggle" data-toggle="dropdown" href="##" title="Page Actions">
							<i class="fa fa-cogs fa fa-large"></i>
						</a>
				    	<ul class="dropdown-menu text-left pull-right">
				    		<cfif prc.oAuthor.checkPermission("PAGES_EDITOR,PAGES_ADMIN")>
							<!--- Clone Command --->
							<li><a href="javascript:openCloneDialog('#page.getContentID()#','#URLEncodedFormat(page.getTitle())#')"><i class="fa fa-copy fa fa-large"></i> Clone</a></li>
							<!--- Create Child --->
							<li><a href="#event.buildLink(prc.xehPageEditor)#/parentID/#page.getContentID()#"><i class="fa fa-sitemap fa fa-large"></i> Create Child</a></li>
							<cfif prc.oAuthor.checkPermission("PAGES_ADMIN")>
							<!--- Delete Command --->
							<li><a href="javascript:remove('#page.getContentID()#')" class="confirmIt"
							  data-title="Delete Page?" data-message="This will delete the page and all of its sub-pages, are you sure?"><i id="delete_#page.getContentID()#" class="fa fa-trash-o icon-large"></i> Delete</a></li>
							</cfif>
							<!--- Edit Command --->
							<li><a href="#event.buildLink(prc.xehPageEditor)#/contentID/#page.getContentID()#"><i class="fa fa-edit icon-large"></i> Edit</a></li>
							</cfif>
							<cfif prc.oAuthor.checkPermission("PAGES_ADMIN,TOOLS_EXPORT")>
							<!--- Export --->
							<li class="dropdown-submenu pull-left">
								<a href="##"><i class="fa fa-download icon-large"></i> Export</a>
								<ul class="dropdown-menu text-left">
									<li><a href="#event.buildLink(linkto=prc.xehPageExport)#/contentID/#page.getContentID()#.json" target="_blank"><i class="fa fa-code"></i> as JSON</a></li>
									<li><a href="#event.buildLink(linkto=prc.xehPageExport)#/contentID/#page.getContentID()#.xml" target="_blank"><i class="fa fa-sitemap"></i> as XML</a></li>
								</ul>
							</li>
							</cfif>
							<!--- History Command --->
							<li><a href="#event.buildLink(prc.xehPageHistory)#/contentID/#page.getContentID()#"><i class="fa fa-clock-o icon-large"></i> History</a></li>
							<!--- View in Site --->
							<li><a href="#prc.CBHelper.linkPage(page)#" target="_blank"><i class="fa fa-eye icon-large"></i> Open In Site</a></li>
				    	</ul>
				    </div>	
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