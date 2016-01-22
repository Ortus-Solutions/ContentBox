<cfoutput>
#html.anchor(name="recentComments" )#
<div class="buttonBar"></div>		
<div class="filterBar">
	<h3><i class="fa fa-comments"></i> #$r( "dashboard.latestComments.head@admin" )#</h3>
</div>	
<!--- Info Bar --->
<cfif !prc.cbSettings.cb_comments_enabled>
	<div class="alert alert-danger">
		<i class="fa fa-exclamation-triangle fa-2x pull-left"></i>
		#$r( "dashboard.latestComments.alert@admin" )#
	</div>
</cfif>
<!--- Render Viewlet --->	
#prc.commentsViewlet#
</cfoutput>