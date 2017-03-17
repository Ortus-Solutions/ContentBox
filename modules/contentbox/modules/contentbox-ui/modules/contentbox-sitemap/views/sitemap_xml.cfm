<cfoutput><?xml version="1.0" encoding="UTF-8"?>
<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9"
		xmlns:image="http://www.google.com/schemas/sitemap-image/1.1">
	<url>
		<loc>#prc.linkHome#</loc>
	</url>  
	<cfloop array="#prc.aPages#" index="content">
	<url>
		<loc>#prc.siteBaseURL##content[ 'slug' ]#</loc>
		<lastmod>#dateFormat( content[ 'modifiedDate' ], "yyyy-mm-dd" )#</lastmod>
		<cfif len( content.get( "featuredImageURL" ) )>
      		<image:image>
       			<image:loc>#prc.siteBaseURL##content.get( "featuredImageURL" )#</image:loc>
    		</image:image>
      	</cfif>
	</url>
	</cfloop>
	<cfif !prc.disableBlog>				
		<url>
			<loc>#prc.siteBaseURL##prc.blogEntryPoint#</loc>
		</url>	
		<cfloop array="#prc.aEntries#" index="content">
	   		<url>
	      		<loc>#prc.siteBaseURL##prc.blogEntryPoint##content[ 'slug' ]#</loc>
	      		<lastmod>#dateFormat( content[ 'modifiedDate' ], "yyyy-mm-dd" )#</lastmod>
		      	<cfif len( content.get( "featuredImageURL" ) )>
		      		<image:image>
		       			<image:loc>#prc.siteBaseURL##content.get( "featuredImageURL" )#</image:loc>
		    		</image:image>
		      	</cfif>
	   		</url>
		</cfloop>
	</cfif>
</urlset> 	
</cfoutput>