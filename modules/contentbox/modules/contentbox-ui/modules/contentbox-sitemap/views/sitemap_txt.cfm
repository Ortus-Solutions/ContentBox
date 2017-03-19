<cfoutput><!---
--->#prc.linkHome##chr( 10 )#<!---
---><cfloop array="#prc.aPages#" index="content"><!---
--->#prc.siteBaseURL##content[ 'slug' ]#
</cfloop><!---
---><cfif !prc.disableBlog><!---
--->#prc.siteBaseURL##prc.blogEntryPoint#
<cfloop array="#prc.aEntries#" index="content"><!---
--->#prc.siteBaseURL##prc.blogEntryPoint##content[ 'slug' ]#
</cfloop><!---
---></cfif>
</cfoutput>