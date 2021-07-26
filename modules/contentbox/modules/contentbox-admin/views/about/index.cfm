<cfoutput>
<div class="row">
    <div class="col-md-12">

    	<div class="text-center">
    		<img src="#prc.cbroot#/includes/images/ContentBox_300.png" alt="logo" class="m10" title="Modular CMS"/>
		    <h2><span class="label label-warning">#getModuleConfig('contentbox').version#</span></h2>
	        <blockquote class="clearfix">
				<strong>ContentBox</strong> #$r( "dashboard.about.blockquote1.1@admin" )# <a href="https://www.ortussolutions.com">Ortus Solutions</a> #$r( "dashboard.about.blockquote1.2@admin" )# <a href="http://www.coldbox.org">ColdBox Platform</a> #$r( "dashboard.about.blockquote1.3@admin" )#
				<small><a href="https://www.ortussolutions.com/products/contentbox">www.ortussolutions.com/products/contentbox</a></small>
			</blockquote>
		</div>

		<div class="panel panel-primary">
		    <div class="panel-heading">
				<h3 class="panel-title">
					<i class="fab fa-medrt fa-lg"></i> #$r( "dashboard.about.help.title@admin" )#
				</h3>
		    </div>
			<div class="panel-body">
				<!--- Need Help --->
				#renderView( view="_tags/needhelp", prePostExempt = true )#

				<h2>#$r( "dashboard.about.help.links@admin" )#</h2>
				<ul>
					<li>
						<a href="https://github.com/Ortus-Solutions/ContentBox" target="_blank">#$r( "dashboard.about.help.sourceCode@admin" )#</a>
					</li>
					<li>
						<a href="https://ortussolutions.atlassian.net/browse/CONTENTBOX" target="_blank">#$r( "dashboard.about.help.submitBugs@admin" )#</a>
					</li>
					<li>
						<a href="https://www.ortussolutions.com/services" target="_blank">#$r( "dashboard.about.help.services@admin" )#</a>
					</li>
				</ul>
		    </div>
		</div>

    </div>
</div>
</cfoutput>