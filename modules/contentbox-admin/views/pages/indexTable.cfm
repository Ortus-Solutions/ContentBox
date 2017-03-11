<cfoutput>
<!--- Location Bar --->
<cfif structKeyExists( rc, "parent" ) AND len( rc.parent )>
	<div class="breadcrumb">
	  	<a href="javascript:contentDrilldown()"><i class="fa fa-home"></i></a> 
	  	#getModel( "PageBreadcrumbVisitor@contentbox-admin" ).visit( prc.page )#
	</div>
</cfif>

<!--- Hidden Elements --->
#html.hiddenField( name="parent", value=event.getValue( "parent","" ) )#

<!--- pages --->
<table id="pages" name="pages" class="table table-striped table-hover table-condensed" cellspacing="0" width="100%">
    <thead>
        <tr>
            <th id="checkboxHolder" class="{sorter:false} text-center" width="15">
            	<input type="checkbox" onClick="checkAll( this.checked, 'contentID' )"/>
            </th>
			<th>
				Name
			</th>
			<th width="40" class="text-center">
				<i class="fa fa-th-list fa-lg" title="Show in Menu"></i>
			</th>
			<th width="40" class="text-center">
				<i class="fa fa-globe fa-lg" title="Published"></i>
			</th>
			<th width="40" class="text-center">
				<i class="fa fa-signal fa-lg" title="Hits"></i>
			</th>
			<th width="115" class="text-center {sorter:false}">
				Actions
			</th>
        </tr>
    </thead>
    <tbody>
        <cfloop array="#prc.pages#" index="page">
			<tr id="contentID-#page.getContentID()#" data-contentID="#page.getContentID()#"
				<cfif page.isExpired()>
					class="danger"
				<cfelseif page.isPublishedInFuture()>
					class="success"
				<cfelseif !page.isContentPublished()>
					class="warning"
				<cfelseif page.getNumberOfActiveVersions() eq 0 >
					class="danger" title="No active content versions found, please publish one."
				</cfif>
				<!--- double click drill down --->
				<cfif page.getNumberOfChildren()>ondblclick="contentDrilldown( '#page.getContentID()#' )"</cfif>
			>
				<!--- check box --->
				<td class="text-center">
					<input type="checkbox" name="contentID" id="contentID" value="#page.getContentID()#" />
				</td>
				<td>
					<!--- Children Dig Deeper --->
					<cfif page.getNumberOfChildren()>
						<a href="javascript:contentDrilldown( '#page.getContentID()#' )" class="hand-cursor" title="View Child Pages (#page.getNumberOfChildren()#)"><i class="fa fa-plus-square text"></i></a>
					<cfelse>
						<i class="fa fa-circle-thin"></i>
					</cfif>
					<!--- Title --->
					<cfif prc.oAuthor.checkPermission( "PAGES_EDITOR,PAGES_ADMIN" )>
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
						<i class="fa fa-lock" title="Password Protected Content"></i>
					</cfif>
					<!--- ssl protected --->
					<cfif page.getSSLOnly()>
						<i class="fa fa-shield" title="SSL Enabled"></i>
					</cfif>
					<!--- Home page?--->
					<cfif page.getSlug() eq prc.cbSettings.cb_site_homepage>
						<i class="fa fa-home text-danger" title="Current Homepage"></i>
					</cfif>
				</td>
				<td class="text-center">
					<cfif page.getShowInMenu()>
						<i class="fa fa-check fa-lg textGreen"></i>
						<span class="hidden">yes</span>
					<cfelse>
						<i class="fa fa-times fa-lg textRed"></i>
						<span class="hidden">no</span>
					</cfif>
				</td>
				<td class="text-center">
					<cfif page.isExpired()>
						<i class="fa fa-clock-o fa-lg textRed" title="Page has expired on ( (#page.getDisplayExpireDate()#))"></i>
						<span class="hidden">expired</span>
					<cfelseif page.isPublishedInFuture()>
						<i class="fa fa-fighter-jet fa-lg textBlue" title="Page Publishes in the future (#page.getDisplayPublishedDate()#)"></i>
						<span class="hidden">published in future</span>
					<cfelseif page.isContentPublished()>
						<i class="fa fa-check fa-lg textGreen" title="Page Published"></i>
						<span class="hidden">published in future</span>
					<cfelse>
						<i class="fa fa-times fa-lg textRed" title="Page Draft"></i>
						<span class="hidden">draft</span>
					</cfif>
				</td>
				<td class="text-center"><span class="badge badge-info">#page.getNumberOfHits()#</span></td>
				<td class="text-center">
					<!---Info Panel --->
					<a 	class="btn btn-info btn-sm popovers" 
						data-contentID="#page.getContentID()#"
						data-toggle="popover"><i class="fa fa-info-circle fa-lg"></i></a>
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
					<div class="btn-group btn-group-sm">
				    	<a class="btn btn-primary dropdown-toggle" data-toggle="dropdown" href="##" title="Page Actions">
							<i class="fa fa-cogs fa fa-large"></i>
						</a>
				    	<ul class="dropdown-menu text-left pull-right">
				    		<cfif prc.oAuthor.checkPermission( "PAGES_EDITOR,PAGES_ADMIN" )>
							<!--- Clone Command --->
							<li><a href="javascript:openCloneDialog('#page.getContentID()#','#URLEncodedFormat(page.getTitle())#')"><i class="fa fa-copy fa fa-large"></i> Clone</a></li>
							<!--- Create Child --->
							<li><a href="#event.buildLink(prc.xehPageEditor)#/parentID/#page.getContentID()#"><i class="fa fa-sitemap fa fa-large"></i> Create Child</a></li>
							<cfif prc.oAuthor.checkPermission( "PAGES_ADMIN" )>
							<!--- Delete Command --->
							<li><a href="javascript:remove('#page.getContentID()#')" class="confirmIt"
							  data-title="<i class='fa fa-trash-o'></i> Delete Page?" data-message="This will delete the page and all of its sub-pages, are you sure?"><i id="delete_#page.getContentID()#" class="fa fa-trash-o fa-lg"></i> Delete</a></li>
							</cfif>
							<!--- Edit Command --->
							<li><a href="#event.buildLink(prc.xehPageEditor)#/contentID/#page.getContentID()#"><i class="fa fa-edit fa-lg"></i> Edit</a></li>
							</cfif>
							<cfif prc.oAuthor.checkPermission( "PAGES_ADMIN,TOOLS_EXPORT" )>
							<!--- Export --->
							<li><a href="#event.buildLink(linkto=prc.xehPageExport)#/contentID/#page.getContentID()#.json" target="_blank"><i class="fa fa-download"></i> Export as JSON</a></li>
							<li><a href="#event.buildLink(linkto=prc.xehPageExport)#/contentID/#page.getContentID()#.xml" target="_blank"><i class="fa fa-download"></i> Export as XML</a></li>
							</cfif>
							<!--- History Command --->
							<li><a href="#event.buildLink(prc.xehPageHistory)#/contentID/#page.getContentID()#"><i class="fa fa-clock-o fa-lg"></i> History</a></li>
							<!--- Reset hits --->
							<li><a href="javascript:resetHits( '#page.getContentID()#' )"><i class="fa fa-refresh fa-lg"></i> Reset Hits</a></li>
							<!--- View in Site --->
							<li><a href="#prc.CBHelper.linkPage(page)#" target="_blank"><i class="fa fa-eye fa-lg"></i> Open In Site</a></li>
				    	</ul>
				    </div>	
				    
				    <!--- Drag Handle --->
					<a href="##" onclick="return false;" class="dragHandle btn btn-default btn-sm" title="Click and drag to change menu order" style="padding:5px 15px"><i class="fa fa-arrows-v"></i> </a>
				</td>
			</tr>
		</cfloop>
    </tbody>
</table>
</cfoutput>