﻿<!---
/**
********************************************************************************
ContentBox - A Modular Content Platform
Copyright 2012 by Luis Majano and Ortus Solutions, Corp
www.ortussolutions.com
********************************************************************************
Apache License, Version 2.0

Copyright Since [2012] [Luis Majano and Ortus Solutions,Corp]

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
********************************************************************************
*/
--->
<cfoutput>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<!--- Site Title --->
	<title>
		<cfif cb.isPageView()>
			#cb.getCurrentPage().getTitle()#
		<cfelse>
			#cb.siteName()# - #cb.siteTagLine()#
		</cfif>
	</title>

	<!--- Met Tags --->
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
	<meta name="generator" 	 content="ContentBox powered by ColdBox" />
	<meta name="robots" 	 content="index,follow" />

	<!--- Meta Description By Page or By Site --->
	<cfif cb.isPageView() AND len(cb.getCurrentPage().getHTMLDescription())>
		<meta name="description" content="#cb.getCurrentPage().getHTMLDescription()#" />
	<cfelse>
		<meta name="description" content="#HTMLEditFormat( cb.siteDescription() )#" />
	</cfif>
	<!--- Meta Keywords By Page or By Site --->
	<cfif cb.isPageView() AND len(cb.getCurrentPage().getHTMLKeywords())>
		<meta name="keywords" 	 content="#cb.getCurrentPage().getHTMLKeywords()#" />
	<cfelse>
		<meta name="keywords" 	 content="#cb.siteKeywords()#" />
	</cfif>

	<!--- Base HREF for SES enabled URLs --->
	<base href="#cb.siteBaseURL()#" />

	<!--- RSS Links --->
	<link rel="alternate" type="application/rss+xml" title="Recent Blog Updates" href="#cb.linkRSS()#" />
	<link rel="alternate" type="application/rss+xml" title="Recent Blog Comment Updates" href="#cb.linkRSS(comments=true)#" />
	<link rel="alternate" type="application/rss+xml" title="Recent Page Updates" href="#cb.linkPageRSS()#" />
	<link rel="alternate" type="application/rss+xml" title="Recent Page Comment Updates" href="#cb.linkPageRSS(comments=true)#" />
	<link rel="alternate" type="application/rss+xml" title="Recent Content Updates" href="#cb.linkSiteRSS()#" />
	<link rel="alternate" type="application/rss+xml" title="Recent Content Comment Updates" href="#cb.linkSiteRSS(comments=true)#" />
	<!--- RSS Discovery If In View Mode --->
	<cfif cb.isPageView()>
		<link rel="alternate" type="application/rss+xml" title="Pages's Recent Comments" href="#cb.linkPageRSS(comments=true,page=cb.getCurrentPage())#" />
	</cfif>

	<!--- styles --->
	<link href="#cb.themeRoot()#/includes/css/main.css" rel="stylesheet" type="text/css" />

	<!--- javascript --->
	<script type="text/javascript" src="#cb.themeRoot()#/includes/js/jquery.tools.min.js"></script>
	<script type="text/javascript" src="#cb.themeRoot()#/includes/js/Arial.font.js"></script>
	<script type="text/javascript" src="#cb.themeRoot()#/includes/js/default.js"></script>

	<!--- contentboxEvent --->
	#cb.event("cbui_beforeHeadEnd")#
</head>
<body>
	<!--- ContentBoxEvent --->
	#cb.event("cbui_afterBodyStart")#
	<div id="bg">
		<div class="wrap">

			<!-- logo -->
			<div id="header"><h1><a href="#cb.linkHome()#">#cb.siteName()#</a></h1></div>
			<!-- /logo -->

			<!-- menu -->
			<div id="mainmenu">
				#cb.quickView("_menu")#
			</div>
			<!-- /menu -->

			<!-- main -->
			<div id="main">
				#cb.mainView()#
			</div>
			<!-- /main -->

			<!-- side -->
			<div id="side">
				#cb.quickView("_pagesidebar")#
			</div>
			<!-- /side -->
		</div>

		<!-- footer -->
		#cb.quickView("_footer")#
		<!-- /footer -->
	</div>
	<!--- ContentBoxEvent --->
	#cb.event("cbui_beforeBodyEnd")#
</body>
</html>
</cfoutput>