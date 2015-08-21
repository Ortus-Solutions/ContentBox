<!--- 
/**
********************************************************************************
ContentBox - A Modular Content Platform
Copyright 2012 by Luis Majano and Ortus Solutions, Corp
www.ortussolutions.com
********************************************************************************
Apache License, Version 2.0

Copyright Since [2012] [Luis Majano and Ortus Solutions,Corp] 

Licensed under the Apache License, Version 2.0 (the "License" );
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
<cfparam name="args.sidebar" default="true">
<cfoutput>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<!--- Page Includes --->
	#cb.quickView( "_pageIncludes" )#
	
	<!--- ContentBoxEvent --->
	#cb.event( "cbui_beforeHeadEnd" )#
</head>
<body>
	<!--- ContentBoxEvent --->
	#cb.event( "cbui_afterBodyStart" )#
	
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
		      	#cb.quickView( "_search" )#
		      	
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
					#cb.event( "cbui_beforeContent" )#
					
					<!--- SideBar: That's right, I can render any layout views by using quickView() or coldbo'x render methods --->
					<!--- Also uses an args scope for nested layouts: see pageNoSidebar layout --->
					<cfif structKeyExists(args,"sidebar" ) and args.sidebar>
						<!--- Content --->
						<div class="left">#cb.mainView()#</div>
						<!--- Sidebar --->
						<div class="right">#cb.quickView(view='_pagesidebar')#</div> 	
					<cfelse>
						<!--- Content --->
						<div class="fullWidth">#renderView()#</div>
					</cfif>
					
					<!--- Separator --->
					<div class="clr"></div>

					<!--- ContentBoxEvent --->
					#cb.event( "cbui_afterContent" )#
				</div>
			</div>
			<!--- Separator --->
			<div class="clr"></div>
		</div>
		
	</div>
	<!--- end main --->
		
	<!--- footer --->
	#cb.quickView(view="_footer" )#
	<!--- end footer --->
		
	<!--- ContentBoxEvent --->
	#cb.event( "cbui_beforeBodyEnd" )#	
</body>
</html>
</cfoutput>