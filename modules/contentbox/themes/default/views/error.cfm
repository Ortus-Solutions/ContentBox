<cfoutput>
<div class="body-header-jumbotron jumbotron">
	<div class="container text-center">
		<h1>
			<i class="fa fa-exclamation-triangle"></i> 
			Houston we have a problem!
		</h1>

		<div class="form-group">
			<strong>Fault Action:</strong> <code>#prc.faultAction#</code>
		</div>

		<!--- Dev Debugging --->
		<cfif getSetting( "environment" ) eq "development">
			
			<div class="form-group">
				<pre>
				#prc.exception.message# #prc.exception.detail#
				</pre>
			</div>

			<div class="form-group">
				<strong>More Information:</strong> <br/>
				<pre>
					#prc.exception.stackTrace#
				</pre>
			</div>

		</cfif>
		
		<p>
			<a class="btn btn-primary btn-lg" href="#cb.linkHome()#" role="button">Go Home</a>
		</p>
	</div>
</div>
</cfoutput>