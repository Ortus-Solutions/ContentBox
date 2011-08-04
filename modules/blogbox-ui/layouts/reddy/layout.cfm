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
		<cfif bb.isEntryView()>#bb.getCurrentEntry().getTitle()# - </cfif>
		#bb.siteName()# - #bb.siteTagLine()#
	</title>
	<!--- Met Tags --->
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
	<meta name="generator" 	 content="BlogBox powered by ColdBox" />
	<meta name="robots" 	 content="index,follow" />
	
	<!--- Meta per page or index --->
	<cfif bb.isEntryView() AND len(bb.getCurrentEntry().getHTMLDescription())>
		<meta name="description" content="#bb.getCurrentEntry().getHTMLDescription()#" />
	<cfelse>
		<meta name="description" content="#bb.siteDescription()#" />
	</cfif>
	<cfif bb.isEntryView() AND len(bb.getCurrentEntry().getHTMLKeywords())>
		<meta name="keywords" 	 content="#bb.getCurrentEntry().getHTMLKeywords()#" />
	<cfelse>
		<meta name="keywords" 	 content="#bb.siteKeywords()#" />
	</cfif>
	
	<!--- Base HREF For SES URLs based on ColdBox--->
	<base href="#getSetting('htmlBaseURL')#/" />
	
	<!--- RSS Stuff --->
	<link rel="alternate" type="application/rss+xml" title="Recent Updates" href="#bb.linkRSS()#" />	
	<cfif bb.isEntryView()>
		<link rel="alternate" type="application/rss+xml" title="Entry's Recent Comments" href="#bb.linkRSS(comments=true,entry=bb.getCurrentEntry())#" />
	</cfif>
	
	<!--- styles --->
	<link href="#bb.layoutRoot()#/includes/css/style.css" rel="stylesheet" type="text/css" />
	
	<!--- javascript --->
	<script type="text/javascript" src="#bb.layoutRoot()#/includes/js/jquery.tools.min.js"></script>
	<script type="text/javascript" src="#bb.layoutRoot()#/includes/js/default.js"></script>
	
	<!--- Custom HTML --->
	#bb.customHTML('beforeHeadEnd')#
	<!--- BlogBoxEvent --->
	#bb.event("bbui_beforeHeadEnd")#
</head>
<body>
	<!--- Custom HTML --->
	#bb.customHTML('afterBodyStart')#
	<!--- BlogBoxEvent --->
	#bb.event("bbui_afterBodyStart")#
	
	<!-- header -->
    <div id="header">
	    <div id="menu">
			<div id="menu_list"> 
				<a href="#bb.linkHome()#" title="Go Home!">Home</a>
				<img src="#bb.layoutRoot()#/includes/images/splitter.gif" class="splitter" alt="" />
				<!---<a href="##">About Us</a>--->
	        </div>
	    </div>
	</div>
	<!--- Logo --->
	<div id="logo">
		<div id="slogan">#bb.siteName()#</div>
	    <div id="logo_text">
	    	<strong>#bb.siteTagLine()#</strong>
			<br/><br/>
			#bb.siteDescription()#
		</div>
	</div>
	<!--- end Header --->
		
	<!--- Main --->
    <div id="main">#renderView()#</div>
	<!--- main --->
	    
	<!--- footer --->
	<div id="footer">
		<div id="left_footer">&copy; Copyright #dateformat(now(),"yyyy")# <a href="http://www.ortussolutions.com"><strong>BlogBox</strong></a></div>
		<div id="right_footer">
			<!-- Please do not change or delete this link. Read the license! Thanks. :-) -->
			Design by <a href="http://www.realitysoftware.ca"><strong>Reality Software</strong></a> &
			<a href="http://www.ortussolutions.com"><strong>Ortus Solutions, Corp</strong></a>
		</div>
	</div>
	<!--- end Footer --->
		
	<!--- Custom HTML --->
	#bb.customHTML('beforeBodyEnd')#
	<!--- BlogBoxEvent --->
	#bb.event("bbui_beforeBodyEnd")#	
</body>
</html>
</cfoutput>