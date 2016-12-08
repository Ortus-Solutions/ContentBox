<cfoutput>
<!--- entries --->
<table name="entries" id="entries" class="table table-striped table-hover table-condensed" cellspacing="0" width="100%">
	<thead>
		<tr>
			<th id="checkboxHolder" class="{sorter:false} text-center" width="15"><input type="checkbox" onClick="checkAll(this.checked,'contentID')"/></th>
			<th>Name</th>
			<th width="40" class="text-center"><i class="fa fa-globe fa-lg" title="Published Status"></i></th>
			<th width="40" class="text-center"><i class="fa fa-signal fa-lg" title="Hits"></i></th>
			<th width="40" class="text-center"><i class="fa fa-comments fa-lg" title="Comments"></i></th>
			<th width="75" class="text-center {sorter:false}">Actions</th>
		</tr>
	</thead>
	
	<tbody>
		<cfloop array="#prc.entries#" index="entry">
		<tr data-contentID="#entry.getContentID()#" 
			<cfif entry.isExpired()>
				class="danger"
			<cfelseif entry.isPublishedInFuture()>
				class="success"
			<cfelseif !entry.isContentPublished()>
				class="warning"
			<cfelseif entry.getNumberOfActiveVersions() eq 0 >
				class="danger" title="No active content versions found, please publish one."
			</cfif>
		>
			<!--- check box --->
			<td class="text-center">
				<input type="checkbox" name="contentID" id="contentID" value="#entry.getContentID()#" />
			</td>
			<td>
				<cfif prc.oAuthor.checkPermission( "ENTRIES_EDITOR,ENTRIES_ADMIN" )>
					<a href="#event.buildLink(prc.xehBlogEditor)#/contentID/#entry.getContentID()#" title="Edit Entry">#entry.getTitle()#</a>
				<cfelse>
					#entry.getTitle()#
				</cfif>
				<!--- password protect --->
				<cfif entry.isPasswordProtected()>
					<i class="fa fa-lock" title="Password Protected Content"></i>
				</cfif>
				<br/><small><i class="fa fa-tag"></i> #entry.getCategoriesList()#</small>
			</td>
			<td class="text-center">
				<cfif entry.isExpired()>
					<i class="fa fa-clock-o fa-lg textRed" title="Entry has expired on ( (#entry.getDisplayExpireDate()#))"></i>
					<span class="hidden">expired</span>
				<cfelseif entry.isPublishedInFuture()>
					<i class="fa fa-fighter-jet fa-lg textBlue" title="Entry Publishes in the future (#entry.getDisplayPublishedDate()#)"></i>
					<span class="hidden">published in future</span>
				<cfelseif entry.isContentPublished()>
					<i class="fa fa-check fa-lg textGreen" title="Entry Published!"></i>
					<span class="hidden">published</span>
				<cfelse>
					<i class="fa fa-times fa-lg textRed" title="Entry Draft!"></i>
					<span class="hidden">draft</span>
				</cfif>
			</td>
			<td class="text-center"><span class="badge badge-info">#entry.getNumberOfHits()#</span></td>
			<td class="text-center"><span class="badge badge-info">#entry.getNumberOfComments()#</span></td>
			<td class="text-center">
				<!---Info Panel --->
				<a 	class="btn btn-sm btn-info popovers" 
					data-contentID="#entry.getContentID()#"
					data-toggle="popover"><i class="fa fa-info-circle fa-lg"></i></a>
				<!---Info Panel --->
				<div id="infoPanel_#entry.getContentID()#" class="hide">
					<!---Creator --->
					<i class="fa fa-user"></i>
					Created by <a href="mailto:#entry.getCreatorEmail()#">#entry.getCreatorName()#</a> on 
					#entry.getDisplayCreatedDate()#
					</br>
					<!--- Last Edit --->
					<i class="fa fa-calendar"></i> 
					Last edit by <a href="mailto:#entry.getAuthorEmail()#">#entry.getAuthorName()#</a> on 
					#entry.getActiveContent().getDisplayCreatedDate()#
					</br>
					<!--- comments icon --->
					<cfif entry.getallowComments()>
						<i class="fa fa-comments"></i> Open Comments
					<cfelse>
						<i class="fa fa-warning-sign"></i> Closed Comments
					</cfif>
				</div>
				
				<!--- Entry Actions --->
				<div class="btn-group btn-group-sm">
			    	<a class="btn btn-primary dropdown-toggle" data-toggle="dropdown" href="##" title="Entry Actions">
						<i class="fa fa-cogs fa-lg"></i>
					</a>
			    	<ul class="dropdown-menu text-left pull-right">
			    		<cfif prc.oAuthor.checkPermission( "ENTRIES_EDITOR,ENTRIES_ADMIN" )>
						<!--- Clone Command --->
						<li><a href="javascript:openCloneDialog('#entry.getContentID()#','#URLEncodedFormat(entry.getTitle())#')"><i class="fa fa-copy fa-lg"></i> Clone</a></li>
						<cfif prc.oAuthor.checkPermission( "ENTRIES_ADMIN" )>
						<!--- Delete Command --->
						<li>
							<a href="javascript:remove('#entry.getContentID()#')" class="confirmIt" data-title="<i class='fa fa-trash-o'></i> Delete Entry?"><i id="delete_#entry.getContentID()#" class="fa fa-trash-o fa-lg" ></i> Delete</a>
						</li>
						</cfif>
						<!--- Edit Command --->
						<li><a href="#event.buildLink(prc.xehEntryEditor)#/contentID/#entry.getContentID()#"><i class="fa fa-edit fa-lg"></i> Edit</a></li>
						</cfif>
						<cfif prc.oAuthor.checkPermission( "ENTRIES_ADMIN,TOOLS_EXPORT" )>
						<!--- Export --->
						<li><a href="#event.buildLink(linkto=prc.xehEntryExport)#/contentID/#entry.getContentID()#.json" target="_blank"><i class="fa fa-download"></i> Export as JSON</a></li>
						<li><a href="#event.buildLink(linkto=prc.xehEntryExport)#/contentID/#entry.getContentID()#.xml" target="_blank"><i class="fa fa-download"></i> Export as XML</a></li>
						</cfif>
						<!--- History Command --->
						<li><a href="#event.buildLink(prc.xehEntryHistory)#/contentID/#entry.getContentID()#"><i class="fa fa-clock-o fa-lg"></i> History</a></li>
						<!-- Reset hits --->
						<li><a href="javascript:resetHits( '#entry.getContentID()#' )"><i class="fa fa-refresh fa-lg"></i> Reset Hits</a></li>
						<!--- View in Site --->
						<li><a href="#prc.CBHelper.linkEntry(entry)#" target="_blank"><i class="fa fa-eye fa-lg"></i> Open In Site</a></li>
			    	</ul>
			    </div>
				
			</td>
		</tr>
		</cfloop>
	</tbody>
</table>

<!--- Paging --->
<cfif !rc.showAll>
#prc.oPaging.renderit(foundRows=prc.entriesCount, link=prc.pagingLink, asList=true)#
<cfelse>
<span class="label label-info">Total Records: #prc.entriesCount#</span>
</cfif>

</cfoutput>