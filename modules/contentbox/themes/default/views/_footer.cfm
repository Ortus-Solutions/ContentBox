<cfoutput>
<footer id="footer">
	<div class="container">
		#cb.themeSetting( 'footerBox' )#
		<p class="text-muted">Copyright &copy; #cb.siteName()#.  All rights reserved.</p>
		<p class="text-muted">Powered by ContentBox v#cb.getContentBoxVersion()#</p>
		<!--- contentboxEvent --->
		#cb.event( "cbui_footer" )#
	</div>
</footer>
</cfoutput>