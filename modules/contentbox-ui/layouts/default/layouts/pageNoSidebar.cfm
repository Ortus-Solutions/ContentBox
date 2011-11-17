<cfoutput>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
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
	
	<!--- Meta per page or index --->
	<cfif cb.isEntryView() AND len(cb.getCurrentEntry().getHTMLDescription())>
		<meta name="description" content="#cb.getCurrentEntry().getHTMLDescription()#" />
	<cfelse>
		<meta name="description" content="#cb.siteDescription()#" />
	</cfif>
	<cfif cb.isEntryView() AND len(cb.getCurrentEntry().getHTMLKeywords())>
		<meta name="keywords" 	 content="#cb.getCurrentEntry().getHTMLKeywords()#" />
	<cfelse>
		<meta name="keywords" 	 content="#cb.siteKeywords()#" />
	</cfif>
	
	<!--- Base HREF For SES URLs based on ColdBox--->
	<base href="#getSetting('htmlBaseURL')#/" />
	
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
	
	<!--- Main Content --->
	<div class="main">
		
		<!--- blok_Header --->
		<div class="blok_header">	    
			<!--- Header --->
			<div class="header">				
				<!--- Logo Title --->
				<div class="logo">
					<div id="logoTitle">#cb.siteName()#</div>
				</div>
				
				<!--- Search Box --->
		      	<div class="search">
			        <form id="searchForm" name="searchForm" method="post" action="#cb.linkSearch()#">
			          <label>
			          	<span><input name="q" type="text" class="keywords" id="textfield" maxlength="50" value="Search..." onclick="this.value=''"/></span>
			            <input name="b" type="image" src="#cb.layoutRoot()#/includes/images/search.gif" class="button" />
			          </label>
			        </form>
			    </div>
		      	
				<!--- Spacer --->
				<div class="clr"><br/></div>
				
				<!--- Top Menu Bar --->
				<div class="menu">
					#cb.quickView('_menu')#
					<div id="tagline">#cb.siteTagLine()#</div>
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
					<!--- ContentBoxEvent --->
					#cb.event("cbui_beforeContent")#
					
					<!--- Content --->
					<div class="fullWidth">#renderView()#</div>
					
					<!--- Separator --->
					<div class="clr"></div>

					<!--- ContentBoxEvent --->
					#cb.event("cbui_afterContent")#
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
        <cfloop array="#cb.getCurrentCategories()#" index="category">
		<li><a href="#cb.linkCategory(category)#">#category.getCategory()# (#category.getNumberOfEntries()#)</a></li>
		</cfloop>
      </ul>
    </div>
    <div class="left">
      #cb.widget("Meta")#
    </div>
    <div class="left">
      <h2>RSS Feeds</h2>
      <ul>
        <li><a href="#cb.linkRSS()#">Recent Site Updates</a></li>
        <li><a href="#cb.linkRSS(comments=true)#">Recent Site Comments</a></li>
      </ul>
    </div>
    <div class="clr"></div>
  </div>
  <div class="clr"></div>
</div>
		
	<!--- footer --->
	<div class="footer">
		<div class="footer_resize">
			<p class="leftt">Powered by <a href="http://www.ortussolutions.com">ContentBox<a/></p>
			<p class="right">(DT) <a href="http://www.dreamtemplate.com" title="Awesome Templates!"><strong>Website Templates</strong></a></p>
			<div class="clr"></div>
		</div>
		<!--- ContentBoxEvent --->
		#cb.event("cbui_footer")#
		<div class="clr"></div>
	</div> 
	<!--- end footer --->
		
	<!--- ContentBoxEvent --->
	#cb.event("cbui_beforeBodyEnd")#	
</body>
</html>
</cfoutput>