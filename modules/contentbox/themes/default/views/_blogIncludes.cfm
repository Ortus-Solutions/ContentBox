<cfoutput>
<title>
<!--- Site Title --->	
<cfif cb.isEntryView()>
	#cb.getCurrentEntry().getTitle()#
<cfelse>
	#cb.siteName()# - #cb.siteTagLine()#
</cfif>
</title>

<!--- ********************************************************************************* --->
<!--- 					META TAGS														--->
<!--- ********************************************************************************* --->
<meta name="generator" 	 	content="ContentBox powered by ColdBox" />
<meta name="robots" 	 	content="index,follow" />
<meta name="viewport" 		content="width=device-width, initial-scale=1">
<meta charset="utf-8" /> 

<!--- Meta per page or index --->
<cfif cb.isEntryView() AND len( cb.getCurrentEntry().getHTMLDescription() )>
	<meta name="description" content="#cb.getCurrentEntry().getHTMLDescription()#" />
<cfelse>
	<meta name="description" content="#HTMLEditFormat( cb.siteDescription() )#" />
</cfif>
<cfif cb.isEntryView() AND len(cb.getCurrentEntry().getHTMLKeywords())>
	<meta name="keywords" 	 content="#cb.getCurrentEntry().getHTMLKeywords()#" />
<cfelse>
	<meta name="keywords" 	 content="#cb.siteKeywords()#" />
</cfif>

<!--- Base HREF for SES enabled URLs --->
<base href="#cb.siteBaseURL()#" />

<!--- ********************************************************************************* --->
<!--- 					RSS DISCOVERY													--->
<!--- ********************************************************************************* --->
<cfif cb.themeSetting( "rssDiscovery", true )>
	<link rel="alternate" type="application/rss+xml" title="Recent Blog Updates" href="#cb.linkRSS()#" />
	<link rel="alternate" type="application/rss+xml" title="Recent Blog Comment Updates" href="#cb.linkRSS(comments=true)#" />
	<link rel="alternate" type="application/rss+xml" title="Recent Page Updates" href="#cb.linkPageRSS()#" />
	<link rel="alternate" type="application/rss+xml" title="Recent Page Comment Updates" href="#cb.linkPageRSS(comments=true)#" />	
	<link rel="alternate" type="application/rss+xml" title="Recent Content Updates" href="#cb.linkSiteRSS()#" />
	<link rel="alternate" type="application/rss+xml" title="Recent Content Comment Updates" href="#cb.linkSiteRSS(comments=true)#" />
	<cfif cb.isEntryView()>
		<link rel="alternate" type="application/rss+xml" title="Entry's Recent Comments" href="#cb.linkRSS( comments=true, entry=cb.getCurrentEntry() )#" />
	</cfif>
</cfif>

<!--- ********************************************************************************* --->
<!--- 					CSS 															--->
<!--- ********************************************************************************* --->

<!--- Swatch and Skin --->
<link rel="stylesheet" href="#cb.themeRoot()#/includes/css/bootstrap/swatches/#lcase( cb.themeSetting( 'cbBootswatchTheme', 'green' ))#/bootstrap.min.css?v=1" />
<link rel="stylesheet" href="#cb.themeRoot()#/includes/css/bootstrap/swatches/#lcase( cb.themeSetting( 'cbBootswatchTheme', 'green' ))#/skin.css?v=1" />

<!-- injector:css -->
<link rel="stylesheet" href="#cb.themeRoot()#/includes/css/218c7e65.theme.min.css">
<!-- endinjector -->

<!--- ********************************************************************************* --->
<!--- 					JAVASCRIPT														--->
<!--- ********************************************************************************* --->
<!-- injector:js -->
<script src="#cb.themeRoot()#/includes/js/11af6283.theme.min.js"></script>
<!-- endinjector -->
</cfoutput>