<cfoutput>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<!--- Site Title --->
	<title>
		<cfif bb.isEntryView()>
			#bb.getCurrentEntry().getTitle()#
		<cfelse>
			#bb.siteName()# - #bb.siteTagLine()#
		</cfif>
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
	
	<!--- BlogBoxEvent --->
	#bb.event("bbui_beforeHeadEnd")#
</head>
<body>
	<!--- BlogBoxEvent --->
	#bb.event("bbui_afterBodyStart")#
	
	<!--- Main Content --->
	<div class="main">
		
		<!--- blok_Header --->
		<div class="blok_header">	    
			<!--- Header --->
			<div class="header">				
				<!--- Logo Title --->
				<div class="logo">
					<div id="logoTitle">#bb.siteName()#</div>
				</div>
				
				<!--- Search Box --->
		      	<div class="search">
			        <form id="searchForm" name="searchForm" method="post" action="#bb.linkSearch()#">
			          <label>
			          	<span><input name="q" type="text" class="keywords" id="textfield" maxlength="50" value="Search..." onclick="this.value=''"/></span>
			            <input name="b" type="image" src="#bb.layoutRoot()#/includes/images/search.gif" class="button" />
			          </label>
			        </form>
			    </div>
		      	
				<!--- Spacer --->
				<div class="clr"><br/></div>
				
				<!--- Top Menu Bar --->
				<div class="menu">
					#bb.quickView('_menu')#
					<div id="tagline">#bb.siteTagLine()#</div>
					<div class="clr"></div>
				</div>
				<!--- Spacer --->
				<div class="clr"></div>				
		    </div> 
			<!--- end header --->		
		    <div class="clr"></div>
		</div>
		<!--- end block_header --->

		<!--- body resize page --->
		<div class="body_resize">
			<div class="body">
				<div class="body_bg">
					<!--- BlogBoxEvent --->
					#bb.event("bbui_beforeContent")#
					<!--- Content --->
					#renderView()#
					<!--- BlogBoxEvent --->
					#bb.event("bbui_afterContent")#
				</div>
			</div>
			<!--- Separator --->
			<div class="clr"></div>
		</div>
		
	</div>
	<!--- end main --->
		
		
	<!--- bottom resize --->
	<div class="FBG">
  <div class="FBG_resize">
    <div class="left">
      <h2>Categories</h2>
      <ul>
        <cfloop array="#bb.getCurrentCategories()#" index="category">
		<li><a href="#bb.linkCategory(category)#">#category.getCategory()# (#category.getNumberOfEntries()#)</a></li>
		</cfloop>
      </ul>
    </div>
    <div class="left">
      <h2>Services</h2>
      <ul>
        <li><a href="##">First Service</a></li>
        <li> <a href="##">Second Service</a></li>
        <li> <a href="##">Another Service</a></li>
        <li> <a href="##">A Fourth Service</a></li>
      </ul>
    </div>
    <div class="left">
      <h2>RSS Feeds</h2>
      <ul>
        <li><a href="#bb.linkRSS()#">Recent Site Updates</a></li>
        <li><a href="#bb.linkRSS(comments=true)#">Recent Site Comments</a></li>
      </ul>
    </div>
    <div class="clr"></div>
  </div>
  <div class="clr"></div>
</div>
		
	<!--- footer --->
	<div class="footer">
		<div class="footer_resize">
			<p class="leftt">Powered by <a href="http://www.ortussolutions.com">BlogBox<a/></p>
			<p class="right">(DT) <a href="http://www.dreamtemplate.com" title="Awesome Templates!"><strong>Website Templates</strong></a></p>
			<div class="clr"></div>
		</div>
		<!--- BlogBoxEvent --->
		#bb.event("bbui_footer")#
		<div class="clr"></div>
	</div> 
	<!--- end footer --->
		
	<!--- BlogBoxEvent --->
	#bb.event("bbui_beforeBodyEnd")#	
</body>
</html>
</cfoutput>