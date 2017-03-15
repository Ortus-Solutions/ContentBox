<cfoutput>[
	{"loc": "#prc.linkHome#" }
	<cfloop array="#prc.pageResults.pages#" index="content">
	,{ 
		"loc": "#prc.siteBaseURL##content.getslug()#",
		"lastmod": "#dateFormat( content.getModifiedDate(), "yyyy-mm-dd" )#"
		<cfif len( content.getFeaturedImageURL() )>
		,"image": {
			"loc": "#prc.siteBaseURL##content.getFeaturedImageURL()#"
		}
		</cfif>	
	}
	</cfloop>
	<cfif !prc.disableBlog>				
		,{ "loc": "#prc.siteBaseURL##prc.blogEntryPoint#" }
		<cfloop array="#prc.entryResults.entries#" index="content">
	   		,{ 
	   			"loc": "#prc.siteBaseURL##prc.blogEntryPoint##content.getslug()#",
	   			"lastmod": "#dateFormat( content.getModifiedDate(), "yyyy-mm-dd" )#"
		      	<cfif len( content.getFeaturedImageURL() )>
		      		, "image": {
		      			"loc": "#prc.siteBaseURL##content.getFeaturedImageURL()#"	
		      		}
		      	</cfif>
	   		}
		</cfloop>
	</cfif>
]
</cfoutput>