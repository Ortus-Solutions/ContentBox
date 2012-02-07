<!--- 
/**
********************************************************************************
ContentBox - A Modular Content Platform
Copyright 2012 by Luis Majano and Ortus Solutions, Corp
www.gocontentbox.org | www.luismajano.com | www.ortussolutions.com
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
	
	<!--- Meta Description By Page or By Site --->
	<cfif cb.isEntryView() AND len(cb.getCurrentEntry().getHTMLDescription())>
		<meta name="description" content="#cb.getCurrentEntry().getHTMLDescription()#" />
	<cfelse>
		<meta name="description" content="#cb.siteDescription()#" />
	</cfif>
	<!--- Meta Keywords By Page or By Site --->
	<cfif cb.isEntryView() AND len(cb.getCurrentEntry().getHTMLKeywords())>
		<meta name="keywords" 	 content="#cb.getCurrentEntry().getHTMLKeywords()#" />
	<cfelse>
		<meta name="keywords" 	 content="#cb.siteKeywords()#" />
	</cfif>
	
	<!--- Base HREF for SES enabled URLs --->
	<base href="#cb.siteBaseURL()#/" />
	
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
				
				<!--- Custom Search Box --->
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
					
					<!--- SideBar: That's right, I can render any layout views by using quickView() or coldbo'x render methods --->
					<!--- Also uses an args scope for nested layouts: see pageNoSidebar layout --->
					<cfif structKeyExists(args,"sidebar") and args.sidebar>
						<!--- Content --->
						<div class="left">#renderView()#</div>
						<!--- Sidebar --->
						<div class="right">#cb.quickView(view='_pagesidebar')#</div> 	
					<cfelse>
						<!--- Content --->
						<div class="fullWidth">#renderView()#</div>
					</cfif>
					
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
			  #cb.widget(name="Categories")#
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