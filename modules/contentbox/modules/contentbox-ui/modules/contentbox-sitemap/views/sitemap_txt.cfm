<cfoutput>
#prc.linkHome##chr(10)#
<cfloop array="#prc.pageResults.pages#" index="content">
#prc.siteBaseURL##content.getslug()#
</cfloop>
<cfif !prc.disableBlog>				
#prc.siteBaseURL##prc.blogEntryPoint#
<cfloop array="#prc.entryResults.entries#" index="content">
#prc.siteBaseURL##prc.blogEntryPoint##content.getslug()#
</cfloop>
</cfif>
</cfoutput>