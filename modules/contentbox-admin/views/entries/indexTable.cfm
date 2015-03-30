<cfoutput>
<!--- entries --->
<table name="entries" id="entries" class="tablesorter table table-hover" width="98%">
	<thead>
		<tr>
			<th id="checkboxHolder" class="{sorter:false}" width="20"><input type="checkbox" onClick="checkAll(this.checked,'contentID')"/></th>
			<th>Name</th>
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
				<cfif prc.oAuthor.checkPermission( "ENTRIES_EDITOR,ENTRIES_ADMIN" )>
					<a href="#event.buildLink(prc.xehBlogEditor)#/contentID/#entry.getContentID()#" title="Edit Entry">#entry.getTitle()#</a>
				<cfelse>
					#entry.getTitle()#
				</cfif>
				<!--- password protect --->
				<cfif entry.isPasswordProtected()>
					<i class="icon-lock"></i>
				</cfif>
				<br/><small><i class="icon-tag"></i> #entry.getCategoriesList()#</small>
			</td>
			<td class="center">
				<cfif entry.isExpired()>
					<i class="icon-time icon-large textRed" title="Entry has expired on ( (#entry.getDisplayExpireDate()#))"></i>
					<span class="hidden">expired</span>
				<cfelseif entry.isPublishedInFuture()>
					<i class="icon-fighter-jet icon-large textBlue" title="Entry Publishes in the future (#entry.getDisplayPublishedDate()#)"></i>
					<span class="hidden">published in future</span>
				<cfelseif entry.isContentPublished()>
					<i class="icon-ok icon-large textGreen" title="Entry Published!"></i>
					<span class="hidden">published</span>
				<cfelse>
					<i class="icon-remove icon-large textRed" title="Entry Draft!"></i>
					<span class="hidden">draft</span>
				</cfif>
			</td>
			<td class="center"><span class="badge badge-info">#entry.getNumberOfHits()#</span></td>
			<td class="center"><span class="badge badge-info">#entry.getNumberOfComments()#</span></td>
			<td class="center">
				<!---Info Panel --->
				<a 	class="btn popovers" 
					data-contentID="#entry.getContentID()#"
					data-toggle="popover"><i class="icon-info-sign icon-large"></i></a>
				<!---Info Panel --->
				<div id="infoPanel_#entry.getContentID()#" class="hide">
					<!---Creator --->
					<i class="icon-user"></i>
					Created by <a href="mailto:#entry.getCreatorEmail()#">#entry.getCreatorName()#</a> on 
					#entry.getDisplayCreatedDate()#
					</br>
					<!--- Last Edit --->
					<i class="icon-calendar"></i> 
					Last edit by <a href="mailto:#entry.getAuthorEmail()#">#entry.getAuthorName()#</a> on 
					#entry.getActiveContent().getDisplayCreatedDate()#
					</br>
					<!--- comments icon --->
					<cfif entry.getallowComments()>
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
			    	<ul class="dropdown-menu text-left pull-right">
			    		<cfif prc.oAuthor.checkPermission("ENTRIES_EDITOR,ENTRIES_ADMIN")>
						<!--- Clone Command --->
						<li><a href="javascript:openCloneDialog('#entry.getContentID()#','#URLEncodedFormat(entry.getTitle())#')"><i class="icon-copy icon-large"></i> Clone</a></li>
						<cfif prc.oAuthor.checkPermission("ENTRIES_ADMIN")>
						<!--- Delete Command --->
						<li>
							<a href="javascript:remove('#entry.getContentID()#')" class="confirmIt" data-title="Delete Entry?"><i id="delete_#entry.getContentID()#" class="icon-trash icon-large" ></i> Delete</a>
						</li>
						</cfif>
						<!--- Edit Command --->
						<li><a href="#event.buildLink(prc.xehEntryEditor)#/contentID/#entry.getContentID()#"><i class="icon-edit icon-large"></i> Edit</a></li>
						</cfif>
						<cfif prc.oAuthor.checkPermission("ENTRIES_ADMIN,TOOLS_EXPORT")>
						<!--- Export --->
						<li class="dropdown-submenu pull-left">
							<a href="##"><i class="icon-download icon-large"></i> Export</a>
							<ul class="dropdown-menu text-left">
								<li><a href="#event.buildLink(linkto=prc.xehEntryExport)#/contentID/#entry.getContentID()#.json" target="_blank"><i class="icon-code"></i> as JSON</a></li>
								<li><a href="#event.buildLink(linkto=prc.xehEntryExport)#/contentID/#entry.getContentID()#.xml" target="_blank"><i class="icon-sitemap"></i> as XML</a></li>
							</ul>
						</li>
						</cfif>
						<!--- History Command --->
						<li><a href="#event.buildLink(prc.xehEntryHistory)#/contentID/#entry.getContentID()#"><i class="icon-time icon-large"></i> History</a></li>
						<!-- Reset hits --->
						<li><a href="javascript:resetHits( '#entry.getContentID()#' )"><i class="icon-refresh icon-large"></i> Reset Hits</a></li>
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
<cfif !rc.showAll>
#prc.pagingPlugin.renderit(foundRows=prc.entriesCount, link=prc.pagingLink, asList=true)#
<cfelse>
<span class="label label-info">Total Records: #prc.entriesCount#</span>
</cfif>

</cfoutput>