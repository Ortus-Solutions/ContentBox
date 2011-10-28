<cfoutput>
<!--- SideBar --->
<div id="sidebar">
	#html.href(href="#cb.linkHome()#",text=html.button(class="button2",value="Go Home!"))#
</div>

<!--- content --->
<div id="text" >
	<h1>Page Not Found</h1>
	<div class="infoBar">
	The page you requested: #cb.getMissingPage()# 
	<br/>
	Does not exist. Please check your info and try again!
	</div>	
	<br/><br/>
</div>
</cfoutput>