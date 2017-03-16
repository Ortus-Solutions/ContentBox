<cfoutput>
<!--- Location Bar --->
<cfif structKeyExists( rc, "parent" ) AND len( rc.parent )>
<div class="breadcrumb">
  <a href="javascript:contentDrilldown()"><i class="fa fa-home fa-lg"></i></a>
  #getModel( "PageBreadcrumbVisitor@contentbox-admin" ).visit( prc.oParent )#
</div>
</cfif>

<!--- Hidden Elements --->
#html.hiddenField( name="parent", value=event.getValue( "parent", "" ) )#

<!--- content --->
<table name="content" id="content" class="table table-striped table-hover table-condensed" cellspacing="0" width="100%">
	<thead>
		<tr>
			<th id="checkboxHolder" class="{sorter:false} text-center" width="15"><input type="checkbox" onClick="checkAll(this.checked,'contentID')"/></th>
			<th>Name</th>
			<th>Slug/Categories</th>
			<th width="40" class="text-center"><i class="fa fa-globe fa-lg" title="Published Status"></i></th>
			<th width="115" class="text-center {sorter:false}">Actions</th>
		</tr>
	</thead>

	<tbody>
		<cfloop array="#prc.content#" index="content">
		<tr id="contentID-#content.getContentID()#"
			data-contentID="#content.getContentID()#"
			<!--- double click drill down --->
			<cfif content.getNumberOfChildren()>ondblclick="contentDrilldown( '#content.getContentID()#' )"</cfif>
			<!---Status bits --->
			<cfif content.isExpired()>
				class="danger"
			<cfelseif content.isPublishedInFuture()>
				class="success"
			<cfelseif !content.isContentPublished()>
				class="warning"
			<cfelseif content.getNumberOfActiveVersions() eq 0 >
				class="danger" title="No active content versions found, please publish one."
			</cfif>
		>
			<!--- check box --->
			<td class="text-center">
				<input type="checkbox" name="contentID" id="contentID" value="#content.getContentID()#" />
			</td>
			<td>
				<!--- Children Dig Deeper --->
				<cfif content.getNumberOfChildren()>
					<a href="javascript:contentDrilldown( '#content.getContentID()#' )" class="hand-cursor" title="View Children (#content.getNumberOfChildren()#)"><i class="fa fa-plus-square text"></i></a>
				<cfelse>
					<i class="fa fa-circle-thin"></i>
				</cfif>
				<!--- Title --->
				<cfif prc.oAuthor.checkPermission( "CONTENTSTORE_EDITOR,CONTENTSTORE_ADMIN" )>
					<a href="#event.buildLink(prc.xehContentStoreEditor)#/contentID/#content.getContentID()#" title="Edit content">#content.getTitle()#</a>
				<cfelse>
					#content.getTitle()#
				</cfif>
				<br>
				#content.getDescription()#
			</td>
			<td>
				<div class="label label-info">#content.getSlug()#</div>
				<br/><small><i class="fa fa-tag"></i> #content.getCategoriesList()#</small>
			</td>
			<td class="text-center">
				<cfif content.isExpired()>
					<i class="fa fa-clock-o fa-lg textRed" title="Content has expired on ( (#content.getDisplayExpireDate()#))"></i>
					<span class="hidden">expired</span>
				<cfelseif content.isPublishedInFuture()>
					<i class="fa fa-fighter-jet fa-lg textBlue" title="Content Publishes in the future (#content.getDisplayPublishedDate()#)"></i>
					<span class="hidden">published in future</span>
				<cfelseif content.isContentPublished()>
					<i class="fa fa-check fa-lg textGreen" title="Content Published!"></i>
					<span class="hidden">published</span>
				<cfelse>
					<i class="fa fa-times fa-lg textRed" title="Content Draft!"></i>
					<span class="hidden">draft</span>
				</cfif>
			</td>
			<td class="text-center">
				<!---Info Panel --->
				<a 	class="btn btn-sm btn-info popovers" 
					data-contentID="#content.getContentID()#"
					data-toggle="popover"><i class="fa fa-info-circle fa-lg"></i></a>
				<!---Info Panel --->
				<div id="infoPanel_#content.getContentID()#" class="hide">
					<!---Creator --->
					<i class="fa fa-user"></i>
					Created by <a href="mailto:#content.getCreatorEmail()#">#content.getCreatorName()#</a> on 
					#content.getDisplayCreatedDate()#
					</br>
					<!--- Last Edit --->
					<i class="fa fa-calendar"></i> 
					Last edit by <a href="mailto:#content.getAuthorEmail()#">#content.getAuthorName()#</a> on 
					#content.getActiveContent().getDisplayCreatedDate()#
				</div>
				<!--- content Actions --->
				<div class="btn-group btn-group-sm">
			    	<a class="btn btn-primary dropdown-toggle" data-toggle="dropdown" href="##" title="Content Actions">
						<i class="fa fa-cogs fa-lg"></i>
					</a>
			    	<ul class="dropdown-menu text-left pull-right">
			    		<cfif prc.oAuthor.checkPermission( "CONTENTSTORE_EDITOR,CONTENTSTORE_ADMIN" )>
						<!--- Clone Command --->
						<li><a href="javascript:openCloneDialog('#content.getContentID()#','#URLEncodedFormat(content.getTitle())#')"><i class="fa fa-copy fa-lg"></i> Clone</a></li>
						<!--- Create Child --->
						<li><a href="#event.buildLink(prc.xehContentEditor)#/parentID/#content.getContentID()#"><i class="fa fa-sitemap fa-lg"></i> Create Child</a></li>
						<cfif prc.oAuthor.checkPermission( "CONTENTSTORE_ADMIN" )>
						<!--- Delete Command --->
						<li>
							<a href="javascript:remove('#content.getContentID()#')" class="confirmIt" data-title="<i class='fa fa-trash-o'></i> Delete Content?"><i id="delete_#content.getContentID()#" class="fa fa-trash-o fa-lg" ></i> Delete</a>
						</li>
						</cfif>
						<!--- Edit Command --->
						<li><a href="#event.buildLink(prc.xehContentEditor)#/contentID/#content.getContentID()#"><i class="fa fa-edit fa-lg"></i> Edit</a></li>
						</cfif>
						<cfif prc.oAuthor.checkPermission( "CONTENTSTORE_ADMIN,TOOLS_EXPORT" )>
						<!--- Export --->
						<li><a href="#event.buildLink(linkto=prc.xehContentExport)#/contentID/#content.getContentID()#.json" target="_blank"><i class="fa fa-download"></i> Export as JSON</a></li>
						<li><a href="#event.buildLink(linkto=prc.xehContentExport)#/contentID/#content.getContentID()#.xml" target="_blank"><i class="fa fa-download"></i> Export as XML</a></li>
						</cfif>
						<!--- History Command --->
						<li><a href="#event.buildLink(prc.xehContentHistory)#/contentID/#content.getContentID()#"><i class="fa fa-clock-o fa-lg"></i> History</a></li>
			    	</ul>
			    </div>

			    <!--- Drag Handle --->
				<a 	href="##" 
					onclick="return false;" 
					class="dragHandle btn btn-default btn-sm" 
					title="Click and drag to change retrieval order" 
					style="padding:5px 15px"
				>
					<i class="fa fa-arrows-v"></i> 
				</a>

			</td>
		</tr>
		</cfloop>
	</tbody>
</table>
</cfoutput>