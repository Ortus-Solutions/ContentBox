<cfoutput>
<footer id="footer" class="clearfix hidden-phone padding10">
	<!--- cbadmin event --->
	#announceInterception( "cbadmin_loginFooter" )#
	<div class="footer-content text-center">
    	Copyright (C) #dateformat(now(),"yyyy" )# 
    	<a href="http://www.ortussolutions.com">Ortus Solutions, Corp</a>.<br/>
    	<a href="http://www.ortussolutions.com">#$r( "_tags.footer.proSupport@admin" )#</a>
    </div>
</footer>
</cfoutput>