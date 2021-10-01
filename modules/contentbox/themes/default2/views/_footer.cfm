<cfoutput>
<footer id="footer">
	<div class="bg-dark bg-lighten-xs py-4">
		<div class="container">
			#cb.themeSetting( 'footerBox' )#
		</div>
	</div>
	<div class="bg-dark bg-darken-xs py-4">
		<div class="container">
			<small class="text-white text-center">Copyright &copy; #cb.siteName()#.  All rights reserved.</br>
			Powered by ContentBox v#cb.getContentBoxVersion()#</small>
			<!--- contentboxEvent --->
			#cb.event( "cbui_footer" )#
		</div>
	</div>
</footer>
</cfoutput>