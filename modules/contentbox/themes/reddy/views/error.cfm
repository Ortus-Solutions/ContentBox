﻿<cfoutput>
<!--- SideBar --->
<div id="sidebar">
	#html.href(href="#cb.linkHome()#",text=html.button(class="button2",value="Go Home!"))#
</div>

<!--- content --->
<div id="text" >
	<!--- This page is rendered whenever an error ocurrs in your blog --->
	<div class="infoBar">
	Ohh man! Something really went wrong with your request.  The administrator has been adviced, so do not worry!
	Please try your request again!
	</div>
	
	<div class="contentBar">
		<strong>Fault Action:</strong> #prc.faultAction#
	</div>
	
	<div class="contentBar">
		<strong>Error Information:</strong> <br/>
		#prc.exception.message# #prc.exception.detail#
	</div>
	
	<cfif getDebugMode()>
	<div class="contentBar">
		<strong>More Information:</strong> <br/>
		#prc.exception.stackTrace#
	</div>
	</cfif>
	
</div>
</cfoutput>