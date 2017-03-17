<cfoutput>
<!--- latest edits --->
<table 
	name="contentTable-#args.viewletID#" 
	id="contentTable-#args.viewletID#" 
	class="table table-hover table-condensed table-striped" 
	width="100%"
>
	<thead>
		<tr>
			<th>Title</th>

			<th width="175">Date</th>
			
			<cfif args.showPublishedStatus>
			<th width="50" class="text-center">
				<i class="fa fa-globe fa-lg" title="Published"></i>
			</th>
			</cfif>

			<cfif args.showHits>
			<th width="40" class="text-center">
				<i class="fa fa-signal fa-lg" title="Hits"></i>
			</th>
			</cfif>

			<th width="100" class="text-center">Actions</th>
		</tr>
	</thead>
	<tbody>
		<cfloop array="#args.aContent#" index="thisContent">
		<tr id="contentID-#thisContent.getContentID()#" data-contentID="#thisContent.getContentID()#"
			<cfif args.colorCodings>
				<cfif thisContent.isExpired()>
					class="danger"
				<cfelseif thisContent.isPublishedInFuture()>
					class="success"
				<cfelseif !thisContent.isContentPublished()>
					class="warning"
				</cfif>
			</cfif>
		>
			<!--- ***************************************************************************** --->
			<!--- 								CONTENT NAME + TYPE								--->
			<!--- ***************************************************************************** --->
			<td>
				<!--- Editor --->
	    		<cfif thisContent.getContentType() eq "page">
					<a href="#event.buildLink( prc.xehPagesEditor )#/contentID/#thisContent.getContentID()#" title="Edit Page">#thisContent.getTitle()#</a>
					<br>
					<span class="label label-default">#thisContent.getContentType()#</span>
				<cfelseif thisContent.getContentType() eq "contentStore">
					<a href="#event.buildLink( prc.xehContentStoreEditor )#/contentID/#thisContent.getContentID()#" title="Edit ContentStore">#thisContent.getTitle()#</a>
					<br>
					<span class="label label-info">#thisContent.getContentType()#</span>
				<cfelse>
					<a href="#event.buildLink( prc.xehBlogEditor )#/contentID/#thisContent.getContentID()#" title="Edit Entry">#thisContent.getTitle()#</a>
					<br>
					<span class="label label-primary">#thisContent.getContentType()#</span>
				</cfif>
			</td>

			<!--- ***************************************************************************** --->
			<!--- 								AUTHOR + CREATE DATE							--->
			<!--- ***************************************************************************** --->
			<td>
				<cfif args.showAuthor>
					#getModel( "Avatar@cb" ).renderAvatar( 
						email 	= thisContent.getAuthorEmail(), 
						size 	= "20" ,
						class 	= "gravatar img-circle"
					)#
					<a href="mailto:#thisContent.getAuthorEmail()#">#thisContent.getAuthorName()#</a>
					<br>
				</cfif>
				#thisContent.getActiveContent().getDisplayCreatedDate()#
			</td>
			
			<!--- ***************************************************************************** --->
			<!--- 								PUBLISHED STATUS								--->
			<!--- ***************************************************************************** --->
			<cfif args.showPublishedStatus>
			<td class="text-center">
				<cfif thisContent.isExpired()>
					<i 	class="fa fa-clock-o fa-lg textRed" 
						title="Content has expired on (#thisContent.getDisplayExpireDate()#)"></i>
					<span class="hidden">expired</span>
				<cfelseif thisContent.isPublishedInFuture()>
					<i 	class="fa fa-fighter-jet fa-lg textBlue" 
						title="Content Publishes in the future (#thisContent.getDisplayPublishedDate()#)"></i>
					<span class="hidden">published in future</span>
				<cfelseif thisContent.isContentPublished()>
					<i 	class="fa fa-check fa-lg textGreen" 
						title="Content Published"></i>
					<span class="hidden">published in future</span>
				<cfelse>
					<i 	class="fa fa-times fa-lg textRed" 
						title="Content Draft"></i>
					<span class="hidden">draft</span>
				</cfif>
			</td>
			</cfif>
			
			<!--- ***************************************************************************** --->
			<!--- 								HITS 											--->
			<!--- ***************************************************************************** --->
			<cfif args.showHits>
			<td class="text-center">
				<span class="badge badge-info">#thisContent.getNumberOfHits()#</span>
			</td>
			</cfif>
			
			<!--- ***************************************************************************** --->
			<!--- 								ACTIONS											--->
			<!--- ***************************************************************************** --->
			<td class="text-center">
				<!--- Content Actions --->
				<div class="btn-group btn-xs">
					<!--- View in Site --->
					<cfif listFindNoCase( "page,entry", thisContent.getContentType() )>
						<a 	class="btn btn-info btn-sm" 
							href="#prc.CBHelper.linkContent( thisContent )#" 
							target="_blank" 
							title="View in Site"
						>
							<i class="fa fa-eye fa-lg"></i>
						</a>
					<cfelse>
						<a 	class="btn btn-primary btn-sm" 
							href="#event.buildLink( prc.xehContentStoreEditor )#/contentID/#thisContent.getContentID()#" 
							title="Edit Page"
						>
							<i class="fa fa-edit fa-lg"></i>
						</a>
					</cfif>
			    </div>
			</td>
		</tr>
		</cfloop>
	</tbody>
</table>
<cfif !arrayLen( args.aContent )>
	<div class="alert alert-info">
	No Records Found
	</div>											
</cfif>
</cfoutput>
