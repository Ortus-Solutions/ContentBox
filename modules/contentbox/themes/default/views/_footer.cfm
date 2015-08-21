<cfoutput>
<!--- bottom resize --->
<div class="FBG">
	<div class="FBG_resize">
		<div class="left">
		  <h2>Categories</h2>
		  #cb.widget(name="Categories" )#
		</div>
		<div class="left">
		  #cb.widget( "Meta" )#
		</div>
		<div class="left">
		  <h2>RSS Feeds</h2>
		  <ul>
		    <li><a href="#cb.linkSiteRSS()#">Recent Content Updates</a></li>
		    <li><a href="#cb.linkSiteRSS(comments=true)#">Recent Content Comments</a></li>
			<li><a href="#cb.linkRSS()#">Recent Blog Updates</a></li>
			<li><a href="#cb.linkRSS(comments=true)#">Recent Blog Comments</a></li>
			<li><a href="#cb.linkPageRSS()#">Recent Page Updates</a></li>
			<li><a href="#cb.linkPageRSS(comments=true)#">Recent Page Comments</a></li>
		  </ul>
		</div>
		<div class="clr"></div>
	</div>
	<div class="clr"></div>
</div>
<div class="footer">
	<!--- contentboxEvent --->
	#cb.event( "cbui_footer" )#
	<div class="clr"></div>
</div> 
#cb.themeSetting( "googleAnalyticsAPI","" )#
</cfoutput>