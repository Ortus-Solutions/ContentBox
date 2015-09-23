<cfoutput>
<title>
	<!--- Site Title --->
	<cfif cb.isPageView()>
		#cb.getCurrentPage().getTitle()#
	<cfelse>
		#cb.siteName()# - #cb.siteTagLine()#
	</cfif>
</title>
<!--- Meta Tags --->
<meta name="generator" 	 	content="ContentBox powered by ColdBox" />
<meta name="robots" 	 	content="index,follow" />
<meta name="viewport" 		content="width=device-width, initial-scale=1">
<meta charset="utf-8" /> 

<!--- Meta Description By Page or By Site --->
<cfif cb.isPageView() AND len( cb.getCurrentPage().getHTMLDescription() )>
	<meta name="description" content="#cb.getCurrentPage().getHTMLDescription()#" />
<cfelse>
	<meta name="description" content="#HTMLEditFormat( cb.siteDescription() )#" />
</cfif>

<!--- Meta Keywords By Page or By Site --->
<cfif cb.isPageView() AND len( cb.getCurrentPage().getHTMLKeywords() )>
	<meta name="keywords" 	 content="#cb.getCurrentPage().getHTMLKeywords()#" />
<cfelse>
	<meta name="keywords" 	 content="#cb.siteKeywords()#" />
</cfif>

<!--- Base HREF for SES enabled URLs --->
<base href="#cb.siteBaseURL()#" />

<!--- RSS Discovery If In View Mode --->
<cfif cb.isPageView() and cb.getCurrentPage().getAllowComments()>
	<link rel="alternate" type="application/rss+xml" title="Pages's Recent Comments" href="#cb.linkPageRSS( comments=true, page=cb.getCurrentPage() )#" />
</cfif>

<link rel="stylesheet" href="#cb.themeRoot()#/includes/css/bootstrap/swatches/#lcase(cb.themeSetting('cbBootswatchTheme','default'))#/skin.css?v=1" />
<!--- Bootstrap --->
<link rel="stylesheet" href="#cb.themeRoot()#/includes/css/bootstrap/swatches/#lcase(cb.themeSetting('cbBootswatchTheme','default'))#/bootstrap.min.css?v=1" />

<!--- Font Awesome --->
<link rel="stylesheet" href="#cb.themeRoot()#/includes/css/font-awesome/font-awesome.min.css?v=1" />
<link rel="stylesheet" href="#cb.themeRoot()#/includes/css/font-awesome/font-awesome-ie7.min.css?v=1" />

<!--- Include our unminified, unLESSified, non cached version of the stylesheet --->
<link rel="stylesheet" href="#cb.themeRoot()#/includes/css/main.css?v=1" />
</cfoutput>