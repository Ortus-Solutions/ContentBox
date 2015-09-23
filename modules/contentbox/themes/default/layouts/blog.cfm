<cfoutput>
<!DOCTYPE html>
<html lang="en">
<head>
	<!--- Site Title --->
	<title>
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

	<!--- Font Awesome --->
	<link rel="stylesheet" href="#cb.themeRoot()#/includes/css/font-awesome/font-awesome.min.css?v=1" />
	<link rel="stylesheet" href="#cb.themeRoot()#/includes/css/font-awesome/font-awesome-ie7.min.css?v=1" />

	<!-- Global Theme CSS --->
	<link rel="stylesheet" href="#cb.themeRoot()#/includes/css/main.css?v=1" />

	<!--- ********************************************************************************* --->
	<!--- 					JAVASCRIPT														--->
	<!--- ********************************************************************************* --->
	<script type="text/javascript" src="#cb.themeRoot()#/bower_components/jquery/dist/jquery.min.js"></script>
	<script type="text/javascript" src="#cb.themeRoot()#/bower_components/bootstrap/dist/js/bootstrap.min.js"></script>

	<!--- ContentBoxEvent --->
	#cb.event("cbui_beforeHeadEnd")#
</head>
<body>
	<!--- ContentBoxEvent --->
	#cb.event("cbui_afterBodyStart")#
	
	#cb.quickView(view='_header')#
	<section id="body-main">
		<div class="container">
			<div class="row">
				<div class="col-sm-12">
					<!--- ContentBoxEvent --->
					#cb.event("cbui_beforeContent")#

					<!--- Content --->
					#renderview()#

					<!--- ContentBoxEvent --->
					#cb.event("cbui_afterContent")#
				</div>
			</div>

			
			</div>
	</section>
	#cb.quickView(view='_footer')#
</body>

<!-- Placed at the end of the document so the pages load faster -->
<script type="text/javascript" src="#cb.themeRoot()#/bower_components/jquery/dist/jquery.min.js"></script>
<script type="text/javascript" src="#cb.themeRoot()#/bower_components/bootstrap/dist/js/bootstrap.min.js"></script>
</html>
</cfoutput>