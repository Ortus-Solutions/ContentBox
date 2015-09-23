<cfoutput>
<footer id="footer">
	<div class="container">
		#cb.themeSetting( 'footerBox' )#
		<p class="text-muted">Copyright &copy; #cb.siteName()#.  All rights reserved.</p>
		<!--- contentboxEvent --->
		#cb.event( "cbui_footer" )#
	</div>
</footer>
</cfoutput>