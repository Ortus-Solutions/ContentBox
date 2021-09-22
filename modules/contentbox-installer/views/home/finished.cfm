<cfoutput>
<div class="panel panel-primary">
    <div class="panel-heading">
        <h3 class="panel-title">
			<i class="fa fa-lightbulb-o"></i> #cb.r( "finished.title@installer" )#
		</h3>
    </div>
    <div class="panel-body">
        <div class="jumbotron">
			#cb.r( "finished.message@installer" )#
			<!--- Info Panel --->
			<div class="alert alert-danger">
				<i class="fa fa-warning"></i>
				<strong>#cb.r( "finished.warning@installer" )# <br/>
				<em>/{installed_location}/modules/contentbox-installer</em><br/>
			</div>
			<hr>

			<p class="text-center">
				<a
					href="#event.buildLink( prc.xehSite )#"
					class="btn btn-primary btn-lg"
				>
					#cb.r( "finished.visit_site@installer" )#
				</a>
				<a
					href="#event.buildLink( prc.xehAdmin )#"
					class="btn btn-danger btn-lg"
				>
					#cb.r( "finished.visit_admin@installer" )#
				</a>
			</p>
		</div>
    </div>
</div>
</cfoutput>