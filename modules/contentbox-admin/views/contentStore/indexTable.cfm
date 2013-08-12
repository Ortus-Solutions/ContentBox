<cfoutput>
<!--- content --->
<table name="content" id="content" class="tablesorter table table-hover" width="98%">
	<thead>
		<tr>
			<th id="checkboxHolder" class="{sorter:false}" width="20"><input type="checkbox" onClick="checkAll(this.checked,'contentID')"/></th>
			<th>Name</th>
			<th>Slug/Categories</th>
			<th width="40" class="center"><i class="icon-globe icon-large" title="Published Status"></i></th>
			<th width="100" class="center {sorter:false}">Actions</th>
		</tr>
	</thead>
	
	<tbody>
		<cfloop array="#prc.content#" index="content">
		<tr data-contentID="#content.getContentID()#" 
			<cfif content.isExpired()>
				class="expired"
			<cfelseif content.isPublishedInFuture()>
				class="futurePublished"
			<cfelseif !content.isContentPublished()>
				class="selected"
			</cfif>>
			<!--- check box --->
			<td>
				<input type="checkbox" name="contentID" id="contentID" value="#content.getContentID()#" />
			</td>
			<td>
				<cfif prc.oAuthor.checkPermission("CONTENTSTORE_EDITOR") OR prc.oAuthor.checkPermission("CONTENTSTORE_ADMIN")>
					<a href="#event.buildLink(prc.xehContentStoreEditor)#/contentID/#content.getContentID()#" title="Edit content">#content.getTitle()#</a>
				<cfelse>
					#content.getTitle()#
				</cfif>
				<br>
				#content.getDescription()#
			</td>
			<td>
				#content.getSlug()#
				<br/><small><i class="icon-tag"></i> #content.getCategoriesList()#</small>
			</td>
			<td class="center">
				<cfif content.isExpired()>
					<i class="icon-time icon-large textRed" title="Content has expired on ( (#content.getDisplayExpireDate()#))"></i>
					<span class="hidden">expired</span>
				<cfelseif content.isPublishedInFuture()>
					<i class="icon-fighter-jet icon-large textBlue" title="Content Publishes in the future (#content.getDisplayPublishedDate()#)"></i>
					<span class="hidden">published in future</span>
				<cfelseif content.isContentPublished()>
					<i class="icon-ok icon-large textGreen" title="Content Published!"></i>
					<span class="hidden">published</span>
				<cfelse>
					<i class="icon-remove icon-large textRed" title="Content Draft!"></i>
					<span class="hidden">draft</span>
				</cfif>
			</td>
			<td class="center">
				<!---Info Panel --->
				<a 	class="btn popovers" 
					data-contentID="#content.getContentID()#"
					data-toggle="popover"><i class="icon-info-sign icon-large"></i></a>
				<!---Info Panel --->
				<div id="infoPanel_#content.getContentID()#" class="hide">
					<!---Creator --->
					<i class="icon-user"></i>
					Created by <a href="mailto:#content.getCreatorEmail()#">#content.getCreatorName()#</a> on 
					#content.getDisplayCreatedDate()#
					</br>
					<!--- Last Edit --->
					<i class="icon-calendar"></i> 
					Last edit by <a href="mailto:#content.getAuthorEmail()#">#content.getAuthorName()#</a> on 
					#content.getActiveContent().getDisplayCreatedDate()#
				</div>
				
				<!--- content Actions --->
				<div class="btn-group">
			    	<a class="btn dropdown-toggle" data-toggle="dropdown" href="##" title="Content Actions">
						<i class="icon-cogs icon-large"></i>
					</a>
			    	<ul class="dropdown-menu text-left pull-right">
			    		<cfif prc.oAuthor.checkPermission("CONTENTSTORE_EDITOR,CONTENTSTORE_ADMIN")>
						<!--- Clone Command --->
						<li><a href="javascript:openCloneDialog('#content.getContentID()#','#URLEncodedFormat(content.getTitle())#')"><i class="icon-copy icon-large"></i> Clone</a></li>
						<cfif prc.oAuthor.checkPermission("CONTENTSTORE_ADMIN")>
						<!--- Delete Command --->
						<li>
							<a href="javascript:remove('#content.getContentID()#')" class="confirmIt" data-title="Delete Content?"><i id="delete_#content.getContentID()#" class="icon-trash icon-large" ></i> Delete</a>
						</li>
						</cfif>
						<!--- Edit Command --->
						<li><a href="#event.buildLink(prc.xehContentEditor)#/contentID/#content.getContentID()#"><i class="icon-edit icon-large"></i> Edit</a></li>
						</cfif>
						<cfif prc.oAuthor.checkPermission("CONTENTSTORE_ADMIN,TOOLS_EXPORT")>
						<!--- Export --->
						<li class="dropdown-submenu pull-left">
							<a href="##"><i class="icon-download icon-large"></i> Export</a>
							<ul class="dropdown-menu text-left">
								<li><a href="#event.buildLink(linkto=prc.xehContentExport)#/contentID/#content.getContentID()#.json" target="_blank"><i class="icon-code"></i> as JSON</a></li>
								<li><a href="#event.buildLink(linkto=prc.xehContentExport)#/contentID/#content.getContentID()#.xml" target="_blank"><i class="icon-sitemap"></i> as XML</a></li>
							</ul>
						</li>
						</cfif>
						<!--- History Command --->
						<li><a href="#event.buildLink(prc.xehContentHistory)#/contentID/#content.getContentID()#"><i class="icon-time icon-large"></i> History</a></li>
			    	</ul>
			    </div>
				
			</td>
		</tr>
		</cfloop>
	</tbody>
</table>

<!--- Paging --->
<cfif !rc.showAll>
#prc.pagingPlugin.renderit(foundRows=prc.contentCount, link=prc.pagingLink, asList=true)#
<cfelse>
<span class="label label-info">Total Records: #prc.contentCount#</span>
</cfif>

</cfoutput>