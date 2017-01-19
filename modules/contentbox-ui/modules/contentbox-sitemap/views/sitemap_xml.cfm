<cfoutput>
<?xml version="1.0" encoding="UTF-8"?>
<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">
	<url>
		<loc>#prc.linkHome#</loc>
	</url>  
	<cfloop array="#prc.pageResults.pages#" index="content">
	<url>
		<loc>#prc.siteBaseURL##content.getslug()#</loc>
		<lastmod>#dateFormat( content.getModifiedDate(), "yyyy-mm-dd" )#</lastmod>
		<cfif len( content.getFeaturedImageURL() )>
      		<image:image>
       			<image:loc>#prc.siteBaseURL##content.getFeaturedImageURL()#</image:loc>
    		</image:image>
      	</cfif>
	</url>
	</cfloop>
	<cfif !prc.disableBlog>				
		<!---<li><a href="#cb.linkBlog()#">#prc.cbSettings.cb_site_blog_entrypoint#</a></li>--->
		<cfloop array="#prc.entryResults.entries#" index="content">
	   		<url>
	      		<loc>#prc.siteBaseURL##prc.blogEntryPoint##content.getslug()#</loc>
	      		<lastmod>#dateFormat( content.getModifiedDate(), "yyyy-mm-dd" )#</lastmod>
		      	<cfif len( content.getFeaturedImageURL() )>
		      		<image:image>
		       			<image:loc>#prc.siteBaseURL##content.getFeaturedImageURL()#</image:loc>
		    		</image:image>
		      	</cfif>
	   		</url>
		</cfloop>
	</cfif>
</urlset> 	
</cfoutput>