<img src="https://www.contentboxcms.org/__media/ContentBox_300.png" class="img-thumbnail"/>

## Current Stable Version: 3.1.0

This package will deliver stable updates to your ContentBox Modular CMS installations.  We always recommend that you restart your servers after performing any automated patching.

> Please make sure you always backup your code and data before performing any auto-update procedures.  Sometimes things do go wrong :)

You can find much more information about this releases in our Jira Tracking instance: https://ortussolutions.atlassian.net/projects/CONTENTBOX/summary or the official ContentBox page: https://www.ortussolutions.com/products/contentbox

## License
Apache License, Version 2.0.

## Important Links

Source Code
- https://github.com/Ortus-Solutions/ContentBox

Bug Tracking/Agile Boards
- https://ortussolutions.atlassian.net/browse/CONTENTBOX/summary

Documentation
- https://contentbox.ortusbooks.com

Blog
- https://www.ortussolutions.com/blog

## System Requirements
- Lucee 4.5+
- ColdFusion 10+


## Release Notes - ContentBox Modular CMS - Version 3.1.0
            
<h2>        Bug
</h2>
<ul>
<li>[<a href='https://ortussolutions.atlassian.net/browse/CONTENTBOX-762'>CONTENTBOX-762</a>] -         If admin is in SSL mode, then previews should trigger ssl as well 
</li>
<li>[<a href='https://ortussolutions.atlassian.net/browse/CONTENTBOX-766'>CONTENTBOX-766</a>] -         BaseWidget not providing a default logging class &#39;log&#39; as it did in ContentBox 2
</li>
<li>[<a href='https://ortussolutions.atlassian.net/browse/CONTENTBOX-767'>CONTENTBOX-767</a>] -         Admin Layout - loop through jsFullAppendList uses the wrong src base
</li>
<li>[<a href='https://ortussolutions.atlassian.net/browse/CONTENTBOX-771'>CONTENTBOX-771</a>] -         background color indicators for drafts, published future and expired content is not showing up
</li>
<li>[<a href='https://ortussolutions.atlassian.net/browse/CONTENTBOX-776'>CONTENTBOX-776</a>] -         PermissionService, RoleService missing date util injection
</li>
<li>[<a href='https://ortussolutions.atlassian.net/browse/CONTENTBOX-777'>CONTENTBOX-777</a>] -         exclude pages,entries on author mementos, they are not treated for export/import
</li>
<li>[<a href='https://ortussolutions.atlassian.net/browse/CONTENTBOX-778'>CONTENTBOX-778</a>] -         Importer not importing correct custom modules if coming from windows
</li>
<li>[<a href='https://ortussolutions.atlassian.net/browse/CONTENTBOX-780'>CONTENTBOX-780</a>] -         Blog excerpt not rendering ContentStore objects
</li>
<li>[<a href='https://ortussolutions.atlassian.net/browse/CONTENTBOX-800'>CONTENTBOX-800</a>] -         Adobe Compilation error due to ColdBox 4.3 updates
</li>
<li>[<a href='https://ortussolutions.atlassian.net/browse/CONTENTBOX-803'>CONTENTBOX-803</a>] -         Cascading issue on deletion of one-to-one relationship between base content and its stats
</li>
<li>[<a href='https://ortussolutions.atlassian.net/browse/CONTENTBOX-808'>CONTENTBOX-808</a>] -         Incorrect title on snapshots data table
</li>
<li>[<a href='https://ortussolutions.atlassian.net/browse/CONTENTBOX-809'>CONTENTBOX-809</a>] -         i18n properties out of sync with the US file
</li>
<li>[<a href='https://ortussolutions.atlassian.net/browse/CONTENTBOX-815'>CONTENTBOX-815</a>] -         Installer doesn&#39;t work without rewrites
</li>
<li>[<a href='https://ortussolutions.atlassian.net/browse/CONTENTBOX-816'>CONTENTBOX-816</a>] -         Blog Paging in front end works correctly but display is incorrect
</li>
<li>[<a href='https://ortussolutions.atlassian.net/browse/CONTENTBOX-817'>CONTENTBOX-817</a>] -         Blog Paging uses Javascript:null which errors in Firefox
</li>
<li>[<a href='https://ortussolutions.atlassian.net/browse/CONTENTBOX-818'>CONTENTBOX-818</a>] -         Blog Pagination - If you hit a page over total it shows up blank
</li>
</ul>
            
<h2>        New Feature
</h2>
<ul>
<li>[<a href='https://ortussolutions.atlassian.net/browse/CONTENTBOX-514'>CONTENTBOX-514</a>] -         Content Subscriptions
</li>
<li>[<a href='https://ortussolutions.atlassian.net/browse/CONTENTBOX-760'>CONTENTBOX-760</a>] -         Update express editions to use latest JDK
</li>
<li>[<a href='https://ortussolutions.atlassian.net/browse/CONTENTBOX-761'>CONTENTBOX-761</a>] -         Update lucee to latest stable in 4.5 series for Express/War Editions
</li>
<li>[<a href='https://ortussolutions.atlassian.net/browse/CONTENTBOX-765'>CONTENTBOX-765</a>] -         New CBHelper method: renderCaptcha() to easily render the img tag
</li>
<li>[<a href='https://ortussolutions.atlassian.net/browse/CONTENTBOX-783'>CONTENTBOX-783</a>] -         Static Site Generator
</li>
<li>[<a href='https://ortussolutions.atlassian.net/browse/CONTENTBOX-796'>CONTENTBOX-796</a>] -         prc.oCurrentAuthor is now set and available globally by the UI prepare request interceptor
</li>
<li>[<a href='https://ortussolutions.atlassian.net/browse/CONTENTBOX-801'>CONTENTBOX-801</a>] -         Travis integration
</li>
<li>[<a href='https://ortussolutions.atlassian.net/browse/CONTENTBOX-802'>CONTENTBOX-802</a>] -         edge case exception when a content object has no active content versions on ACF
</li>
<li>[<a href='https://ortussolutions.atlassian.net/browse/CONTENTBOX-805'>CONTENTBOX-805</a>] -         new cbhelper seo method: getContentTitle() that retrieves the content title according to discovery rules
</li>
<li>[<a href='https://ortussolutions.atlassian.net/browse/CONTENTBOX-806'>CONTENTBOX-806</a>] -         new cbhelper seo method: getContentDescription() that retrieves the metadata according to discover rules
</li>
<li>[<a href='https://ortussolutions.atlassian.net/browse/CONTENTBOX-807'>CONTENTBOX-807</a>] -         new cbhelper seo method: getContentKeywords() that retrieves the metadata according to discover rules
</li>
</ul>
        
<h2>        Improvement
</h2>
<ul>
<li>[<a href='https://ortussolutions.atlassian.net/browse/CONTENTBOX-573'>CONTENTBOX-573</a>] -         Auto-fill Name/E-mail and skip captcha on comments if logged in
</li>
<li>[<a href='https://ortussolutions.atlassian.net/browse/CONTENTBOX-641'>CONTENTBOX-641</a>] -         Add image resizing/cropping to filebrowser
</li>
<li>[<a href='https://ortussolutions.atlassian.net/browse/CONTENTBOX-740'>CONTENTBOX-740</a>] -         Update site maintenance feature to have admin still view site but it&#39;s down for everyone else
</li>
<li>[<a href='https://ortussolutions.atlassian.net/browse/CONTENTBOX-756'>CONTENTBOX-756</a>] -         SEO Convention for passing title, keywords, description to theme from modules
</li>
<li>[<a href='https://ortussolutions.atlassian.net/browse/CONTENTBOX-759'>CONTENTBOX-759</a>] -         Convention for Module Based Security Rules
</li>
<li>[<a href='https://ortussolutions.atlassian.net/browse/CONTENTBOX-768'>CONTENTBOX-768</a>] -         Admin Layout - loop through jsFullAppendList and cssFullAppendList expects no extension
</li>
<li>[<a href='https://ortussolutions.atlassian.net/browse/CONTENTBOX-779'>CONTENTBOX-779</a>] -         CBHelper now accounts for ssl via request context on all link building operations
</li>
<li>[<a href='https://ortussolutions.atlassian.net/browse/CONTENTBOX-785'>CONTENTBOX-785</a>] -         cbhelper isprintFormat not accounting for html formats
</li>
<li>[<a href='https://ortussolutions.atlassian.net/browse/CONTENTBOX-797'>CONTENTBOX-797</a>] -         CommentForm widget standardizes to default bootstrap themes
</li>
<li>[<a href='https://ortussolutions.atlassian.net/browse/CONTENTBOX-798'>CONTENTBOX-798</a>] -         Search Form Widget standardized to bootstrap
</li>
<li>[<a href='https://ortussolutions.atlassian.net/browse/CONTENTBOX-799'>CONTENTBOX-799</a>] -         Updated all box dependencies to latest releases
</li>
<li>[<a href='https://ortussolutions.atlassian.net/browse/CONTENTBOX-804'>CONTENTBOX-804</a>] -         Update mobile detector to latest incoming script
</li>
<li>[<a href='https://ortussolutions.atlassian.net/browse/CONTENTBOX-811'>CONTENTBOX-811</a>] -         Add more documentation options for theme elements and groups
</li>
<li>[<a href='https://ortussolutions.atlassian.net/browse/CONTENTBOX-819'>CONTENTBOX-819</a>] -         Filebrowser - Download a folder gives confusing error message
</li>
<li>[<a href='https://ortussolutions.atlassian.net/browse/CONTENTBOX-820'>CONTENTBOX-820</a>] -         FileBrowser - Right click doesn&#39;t select object when showing Context Menu
</li>
<li>[<a href='https://ortussolutions.atlassian.net/browse/CONTENTBOX-821'>CONTENTBOX-821</a>] -         FileBrowser - Format the timestamp in the status bar to be more user friendly
</li>
<li>[<a href='https://ortussolutions.atlassian.net/browse/CONTENTBOX-822'>CONTENTBOX-822</a>] -         FileBrowser - Make Location Breadcrumbs clickable
</li>
<li>[<a href='https://ortussolutions.atlassian.net/browse/CONTENTBOX-823'>CONTENTBOX-823</a>] -         FileBrowser - Excluded Items not removed from Item count in Status Bar
</li>
<li>[<a href='https://ortussolutions.atlassian.net/browse/CONTENTBOX-824'>CONTENTBOX-824</a>] -         FileBrowser - In grid view - the selection area isn&#39;t the full thumb square
</li>
<li>[<a href='https://ortussolutions.atlassian.net/browse/CONTENTBOX-825'>CONTENTBOX-825</a>] -         FileBrowser - Update Message to include Settings
</li>
<li>[<a href='https://ortussolutions.atlassian.net/browse/CONTENTBOX-828'>CONTENTBOX-828</a>] -         Widgets - Widgets loaded from Themes are still marked as Layouts
</li>
</ul>
                                        

---
 
###THE DAILY BREAD
 > "I am the way, and the truth, and the life; no one comes to the Father, but by me (JESUS)" Jn 14:1-12