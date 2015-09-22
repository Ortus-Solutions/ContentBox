<cfoutput>
<footer id="footer">
	<div class="container">
		#cb.themeSetting('footerBox')#
		<p class="text-muted">Copyright &copy; 2013 #cb.siteName()#.  All rights reserved.</p>
		<!--- contentboxEvent --->
		#cb.event("cbui_footer")#
	</div>
</footer>
</cfoutput>