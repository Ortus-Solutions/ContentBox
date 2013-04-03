<cfoutput>
<!--- Content --->
<span class="floatRight"><button class="buttonsmall" onclick="closeSearchBox()" title="close search panel"><i class="icon-minus-sign"></i></button></span>
<h2>Content ( #prc.minContentCount# of #prc.results.count# )<h2>
<ul>
<cfloop array="#prc.results.content#" index="thisContent">
	<li><a title="#thisContent.getSlug()#" href="#linkEditContent( thisContent )#">#thisContent.getTitle()#</a> (#thisContent.getContentType()#)</li>
</cfloop>
<cfif !arrayLen( prc.results.content )>
	<li><em>No Results</em></li>
</cfif>
</ul>

<!---Custom HTML --->
<h2>CustomHTML ( #prc.minCustomHTMLCount# of #prc.customHTML.count# )<h2>
<ul>
<cfloop array="#prc.customHTML.entries#" index="thisEntry">
	<li><a title="#thisEntry.getSlug()#" href="#event.buildLInk(linkTo=prc.xehCustomHTMLEditor, queryString="contentID=#thisEntry.getContentID()#" )#">#thisEntry.getTitle()#</a></li>
</cfloop>
<cfif !arrayLen( prc.customHTML.entries )>
	<li><em>No Results</em></li>
</cfif>
</ul>

<!--- Users --->
<h2>Users ( #prc.minAuthorCount# of #prc.authors.count# )<h2>
<ul>
<cfloop array="#prc.authors.authors#" index="thisAuthor">
	<li><a title="#thisAuthor.getEmail()#" href="#event.buildLInk(linkTo=prc.xehAuthorEditor, queryString="authorID=#thisAUthor.getAUthorID()#" )#">#thisAuthor.getName()#</a> (#thisAuthor.getRole().getRole()#)</li>
</cfloop>
<cfif !arrayLen( prc.authors.authors )>
	<li><em>No Results</em></li>
</cfif>
</ul>
	
</cfoutput>