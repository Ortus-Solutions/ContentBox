<cfoutput>
#html.anchor(name="recentComments" )#
<div class="buttonBar"></div>				
<div class="filterBar">
	<h3><i class="icon-comments"></i> Recent Comments</h3>
</div>	
<!--- Info Bar --->
<cfif NOT prc.cbSettings.cb_comments_enabled>
	<div class="alert alert-info">
		<i class="icon-exclamation-sign fa-2x pull-left"></i>
		Comments are currently disabled site-wide!
	</div>
</cfif>			
#prc.commentsViewlet#
</cfoutput>