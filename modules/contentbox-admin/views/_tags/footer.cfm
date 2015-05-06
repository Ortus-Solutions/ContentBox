<cfoutput>
<footer id="footer" class="clearfix hidden-phone">
	<!--- cbadmin event --->
	#announceInterception("cbadmin_loginFooter")#
	<div class="pull-right" id="footerLogo">
		<a href="http://www.gocontentbox.org" target="_blank"><img src="#prc.cbroot#/includes/images/ContentBox_90.png" alt="Logo" /></a>
	</div>
	<div class="footer-content">
    	Copyright (C) #dateformat(now(),"yyyy")# 
    	<a href="http://www.ortussolutions.com">Ortus Solutions, Corp</a>.<br/>
    	<a href="http://www.ortussolutions.com">Need Professional Support, Architecture, Design, or Development?</a>
    </div>
</footer>
</cfoutput>