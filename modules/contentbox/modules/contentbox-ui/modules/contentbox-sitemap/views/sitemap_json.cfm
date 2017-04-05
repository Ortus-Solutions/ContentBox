<cfoutput>[
	{"loc": "#prc.linkHome#" }
	<cfloop array="#prc.aPages#" index="content">
	,{ 
		"loc": "#prc.siteBaseURL##content[ 'slug' ]#",
		"lastmod": "#dateFormat( content[ 'modifiedDate' ], "yyyy-mm-dd" )#"
		<cfif len( content.get( "featuredImageURL" ) )>
		,"image": {
			"loc": "#prc.siteBaseURL & reReplace( content.get( "featuredImageURL" ), "^/", "" )#"
		}
		</cfif> 
	}
	</cfloop>
	<cfif !prc.disableBlog>				
		,{ "loc": "#prc.siteBaseURL##prc.blogEntryPoint#" }
		<cfloop array="#prc.aEntries#" index="content">
	   		,{ 
	   			"loc": "#prc.siteBaseURL##prc.blogEntryPoint##content[ 'slug' ]#",
	   			"lastmod": "#dateFormat( content[ 'modifiedDate' ], "yyyy-mm-dd" )#"
		      	<cfif len( content.get( "featuredImageURL" ) )>
		      		, "image": {
		      			"loc": "#prc.siteBaseURL & reReplace( content.get( "featuredImageURL" ), "^/", "" )#"	
		      		}
		      	</cfif>
	   		}
		</cfloop>
	</cfif>
]
</cfoutput>