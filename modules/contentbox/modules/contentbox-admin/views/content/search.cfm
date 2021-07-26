<cfoutput>
<!--- Content --->
<span class="float-right">
	<button class="btn btn-xs btn-danger" onclick="closeSearchBox()" title="close search panel">
		<i class="fa fa-times"></i>
	</button>
</span>

<cfif !len( prc.context ) || listFindNoCase( prc.contentTypes, prc.context )>
<h2>
	<i class="fa fa-newspaper-o"></i> Content ( #prc.minContentCount# of #prc.results.count# )
<h2>
<ul class="list-group">
<cfloop array="#prc.results.content#" index="thisContent">
	<li class="list-group-item">
		<a 	href="#cb.linkContent( thisContent )#"
			target="_blank"
			<cfif thisContent.getContentType() eq "contentStore">
			disabled="true"
			onclick="return false"
			class="btn btn-xs pull-left mr5"
			<cfelse>
			title="Open in Site"
			class="btn btn-primary btn-xs pull-left mr5"
			</cfif>
		>
			<i class="fa fa-external-link"></i>
		</a>
		<cfif thisContent.getContentType() eq "contentStore">
			<a 	title="Edit Content"
				href="#event.buildLink( prc.xehContentStoreEditor )#/contentID/#thisContent.getContentID()#"
			>
				#thisContent.getTitle()#
			</a>
		<cfelseif thisContent.getContentType() eq "page">
			<a 	title="Edit Page "
				href="#event.buildLink( prc.xehPagesEditor )#/contentID/#thisContent.getContentID()#"
			>
				#thisContent.getTitle()#
			</a>
		<cfelse>
			<a 	title="Edit Entry"
				href="#event.buildLink( prc.xehEntriesEditor )#/contentID/#thisContent.getContentID()#"
			>
				#thisContent.getTitle()#
			</a>
		</cfif>
		<span class="label label-info pull-right">#thisContent.getContentType()#</span>
	</li>
</cfloop>
<cfif !arrayLen( prc.results.content )>
	<li class="list-group-item list-group-item-warning"><em>No Results</em></li>
</cfif>
</ul>
</cfif>

<!--- Users --->
<cfif !len( prc.context ) || listFindNoCase( "author", prc.context )>
<h2>
	<i class="fa fa-user"></i> Users ( #prc.minAuthorCount# of #prc.authors.count# )
<h2>
<ul class="list-group">
<cfloop array="#prc.authors.authors#" index="thisAuthor">
	<li class="list-group-item">
		<span class="pull-left mr5">
			#getInstance( "Avatar@contentbox" ).renderAvatar( email=thisAuthor.getEmail(), size="30" )#
		</span>
		<span class="label label-info pull-right">#thisAuthor.getRole().getRole()#</span>
		<a 	title="#thisAuthor.getEmail()#"
			href="#event.buildLInk( to=prc.xehAuthorEditor, queryString="authorID=#thisAUthor.getAUthorID()#" )#"
		>
			#thisauthor.getFullName()#
		</a>
		<br>
		#thisAuthor.getEmail()#
	</li>
</cfloop>
<cfif !arrayLen( prc.authors.authors )>
	<li class="list-group-item list-group-item-warning"><em>No Results</em></li>
</cfif>
</ul>
</cfif>

<!--- Custom Content --->
#announce( "onGlobalSearchDisplay" )#
</cfoutput>