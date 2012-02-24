<cfoutput>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<!--
Author: Reality Software
Website: http://www.realitysoftware.ca
Note: This is a free template released under the Creative Commons Attribution 3.0 license, 
which means you can use it in any way you want provided you keep the link to the author intact.
-->
<head>
	<!--- Site Title --->
	<title>
		<cfif cb.isEntryView()>
			#cb.getCurrentEntry().getTitle()#
		<cfelse>
			#cb.siteName()# - #cb.siteTagLine()#
		</cfif>
	</title>
	<!--- Met Tags --->
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
	<meta name="generator" 	 content="ContentBox powered by ColdBox" />
	<meta name="robots" 	 content="index,follow" />
	
	<!--- Meta Description By Entry or By Site --->
	<cfif cb.isEntryView() AND len(cb.getCurrentEntry().getHTMLDescription())>
		<meta name="description" content="#cb.getCurrentEntry().getHTMLDescription()#" />
	<cfelse>
		<meta name="description" content="#cb.siteDescription()#" />
	</cfif>
	<!--- Meta Keywords By Entry or By Site --->
	<cfif cb.isEntryView() AND len(cb.getCurrentEntry().getHTMLKeywords())>
		<meta name="keywords" 	 content="#cb.getCurrentEntry().getHTMLKeywords()#" />
	<cfelse>
		<meta name="keywords" 	 content="#cb.siteKeywords()#" />
	</cfif>
	
	<!--- Base HREF for SES enabled URLs --->
	<base href="#cb.siteBaseURL()#/" />
	
	<!--- RSS Links --->
	<link rel="alternate" type="application/rss+xml" title="Recent Blog Updates" href="#cb.linkRSS()#" />
	<link rel="alternate" type="application/rss+xml" title="Recent Blog Comment Updates" href="#cb.linkRSS(comments=true)#" />
	<link rel="alternate" type="application/rss+xml" title="Recent Page Updates" href="#cb.linkPageRSS()#" />
	<link rel="alternate" type="application/rss+xml" title="Recent Page Comment Updates" href="#cb.linkPageRSS(comments=true)#" />	
	<link rel="alternate" type="application/rss+xml" title="Recent Content Updates" href="#cb.linkSiteRSS()#" />
	<link rel="alternate" type="application/rss+xml" title="Recent Content Comment Updates" href="#cb.linkSiteRSS(comments=true)#" />	
	<!--- RSS Discovery If In View Mode --->
	<cfif cb.isEntryView()>
		<link rel="alternate" type="application/rss+xml" title="Blog Entry's Recent Comments" href="#cb.linkRSS(comments=true,entry=cb.getCurrentEntry())#" />
	</cfif>
	
	<!--- styles --->
	<link href="#cb.layoutRoot()#/includes/css/style.css" rel="stylesheet" type="text/css" />
	
	<!--- javascript --->
	<script type="text/javascript" src="#cb.layoutRoot()#/includes/js/jquery.tools.min.js"></script>
	<script type="text/javascript" src="#cb.layoutRoot()#/includes/js/default.js"></script>
	
	<!--- ContentBoxEvent --->
	#cb.event("cbui_beforeHeadEnd")#
</head>
<body>
	<!--- ContentBoxEvent --->
	#cb.event("cbui_afterBodyStart")#
	
	<!-- header -->
    <div id="header">
	    <div id="menu">
			<div id="menu_list"> 
				#cb.quickView("_topMenu")#
	        </div>
	    </div>
	</div>
	<!--- Logo --->
	<div id="logo">
		<div id="slogan">#cb.siteName()#</div>
	    <div id="logo_text">
	    	<strong>#cb.siteTagLine()#</strong>
			<br/><br/>
			#cb.siteDescription()#
		</div>
	</div>
		
	<!--- Main --->
    <div id="main">#cb.mainView()#</div>
	    
	<!--- footer --->
	<div id="footer">
		<div id="left_footer">&copy; Copyright #dateformat(now(),"yyyy")# <a href="http://www.ortussolutions.com"><strong>ContentBox</strong></a></div>
		<div id="right_footer">
			<!-- Please do not change or delete this link. Read the license! Thanks. :-) -->
			Design by <a href="http://www.realitysoftware.ca"><strong>Reality Software</strong></a> &
			<a href="http://www.ortussolutions.com"><strong>Ortus Solutions, Corp</strong></a>
		</div>
	</div>
	<!--- end Footer --->
		
	<!--- ContentBoxEvent --->
	#cb.event("cbui_beforeBodyEnd")#	
</body>
</html>
</cfoutput>