<cfoutput>
<table name="entries" id="entries" class="tablesorter table table-hover" width="98%">
<thead>
	<tr>
		<th id="checkboxHolder" class="{sorter:false}" width="20"><input type="checkbox" onClick="checkAll(this.checked,'contentID')"/></th>
		<th>Title</th>
		<th width="300">Slug</th>
		<th>Author</th>
		<th width="40" class="center"><i class="icon-globe icon-large" title="Published"></i></th>
		<th width="90" class="center {sorter:false}">Actions</th>
	</tr>
</thead>

<tbody>
	<cfloop array="#prc.entries#" index="entry">
	<tr id="contentID-#entry.getContentID()#" data-contentID="#entry.getContentID()#"
		<cfif entry.isExpired()>
			class="error"
		<cfelseif entry.isPublishedInFuture()>
			class="success"
		<cfelseif !entry.isContentPublished()>
			class="warning"
		</cfif>>
		<!--- check box --->
		<td>
			<input type="checkbox" name="contentID" id="contentID" value="#entry.getContentID()#" />
		</td>
		<td>
			<cfif prc.oAuthor.checkPermission("CUSTOMHTML_ADMIN,CUSTOMHTML_EDITOR")>
				<a href="#event.buildLink(prc.xehEditorHTML)#/contentID/#entry.getContentID()#" title="Edit Content">#entry.getTitle()#</a>
			<cfelse>
				#entry.getTitle()#
			</cfif>
			<br>#entry.getDescription()#
		</td>
		<td>
			#entry.getSlug()#
		</td>
		<td>
			<cfif entry.hasCreator()>#entry.getCreatorName()#<cfelse><span class="label label-warning">none</span></cfif>
		</td>
		<td class="center">
			<cfif entry.isExpired()>
				<i class="icon-time icon-large textRed" title="Content has expired on ( (#entry.getDisplayExpireDate()#))"></i>
				<span class="hidden">expired</span>
			<cfelseif entry.isPublishedInFuture()>
				<i class="icon-fighter-jet icon-large textBlue" title="Content publishes in the future (#entry.getDisplayPublishedDate()#)"></i>
				<span class="hidden">published in future</span>
			<cfelseif entry.isContentPublished()>
				<i class="icon-ok icon-large textGreen" title="Published"></i>
				<span class="hidden">published in future</span>
			<cfelse>
				<i class="icon-remove icon-large textRed" title="Draft"></i>
				<span class="hidden">draft</span>
			</cfif>
		</td>
		<td class="center">
			
			<div class="btn-group">
		    	<a class="btn dropdown-toggle" data-toggle="dropdown" href="##" title="Actions">
					<i class="icon-cogs icon-large"></i>
				</a>
		    	<ul class="dropdown-menu text-left">
					<cfif prc.oAuthor.checkPermission("CUSTOMHTML_ADMIN,CUSTOMHTML_EDITOR")>
					<!--- Clone Command --->
					<li><a href="javascript:openCloneDialog('#entry.getContentID()#','#URLEncodedFormat(entry.getTitle())#')"><i class="icon-copy icon-large"></i> Clone</a></li>
					<!--- Edit Command --->
					<li><a href="#event.buildLink(prc.xehEditorHTML)#/contentID/#entry.getContentID()#" title="Edit Content"><i class="icon-edit icon-large"></i> Edit</a></li>
					</cfif>
					<cfif prc.oAuthor.checkPermission("CUSTOMHTML_ADMIN")>
					<!--- Delete Command --->
					<li><a title="Delete Content Permanently" href="javascript:remove('#entry.getContentID()#')" class="confirmIt" data-title="Delete Content?"><i id="delete_#entry.getContentID()#" class="icon-trash icon-large"></i> Delete</a></li>
					</cfif>
					<cfif prc.oAuthor.checkPermission("CUSTOMHTML_ADMIN,TOOLS_EXPORT")>
					<!--- Export --->
					<li class="dropdown-submenu">
						<a href="##"><i class="icon-download icon-large"></i> Export</a>
						<ul class="dropdown-menu text-left">
							<li><a href="#event.buildLink(linkto=prc.xehExportHTML)#/contentID/#entry.getContentID()#.json" target="_blank"><i class="icon-code"></i> as JSON</a></li>
							<li><a href="#event.buildLink(linkto=prc.xehExportHTML)#/contentID/#entry.getContentID()#.xml" target="_blank"><i class="icon-sitemap"></i> as XML</a></li>
						</ul>
					</li>
					</cfif>
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