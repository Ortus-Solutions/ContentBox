<cfoutput>
<!--- Content --->
<span class="floatRight"><button class="btn btn-mini btn-danger" onclick="closeSearchBox()" title="close search panel"><i class="icon-minus-sign"></i></button></span>
<h2><i class="icon-tasks"></i> Content ( #prc.minContentCount# of #prc.results.count# )<h2>
<ul>
<cfloop array="#prc.results.content#" index="thisContent">
	<cfif thisContent.getContentType() eq "contentStore">
		<li>
			<a title="#thisContent.getSlug()#" href="#event.buildLink( prc.xehContentStoreEditor )#/contentID/#thisContent.getContentID()#">#thisContent.getTitle()#</a> (#thisContent.getContentType()#)
		</li>
	<cfelseif thisContent.getContentType() eq "page">
		<li>
			<a title="#thisContent.getSlug()#" href="#event.buildLink( prc.xehPagesEditor )#/contentID/#thisContent.getContentID()#">#thisContent.getTitle()#</a> (#thisContent.getContentType()#)
		</li>
	<cfelse>
		<li>
			<a title="#thisContent.getSlug()#" href="#event.buildLink( prc.xehBlogEditor )#/contentID/#thisContent.getContentID()#">#thisContent.getTitle()#</a> (#thisContent.getContentType()#)
		</li>
	</cfif>
</cfloop>
<cfif !arrayLen( prc.results.content )>
	<li><em>No Results</em></li>
</cfif>
</ul>

<!--- Users --->
<h2><i class="icon-user"></i> Users ( #prc.minAuthorCount# of #prc.authors.count# )<h2>
<ul>
<cfloop array="#prc.authors.authors#" index="thisAuthor">
	<li>
		<a title="#thisAuthor.getEmail()#" href="#event.buildLInk( linkTo=prc.xehAuthorEditor, queryString="authorID=#thisAUthor.getAUthorID()#" )#">#thisAuthor.getName()#</a> (#thisAuthor.getRole().getRole()#)
	</li>
</cfloop>
<cfif !arrayLen( prc.authors.authors )>
	<li><em>No Results</em></li>
</cfif>
</ul>
</cfoutput>