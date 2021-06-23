<cfoutput>
	<div class="row">
    <div class="col-md-12">
        <h1 class="h1"><i class="fa fa-flask fa-lg"></i> Hello Module</h1>
    </div>
</div>

<div class="row">
	<div class="col-md-9">

		<div class="panel panel-default">
		    <div class="panel-body">

				<!--- Logo --->
				<div class="text-center">
					<img src="#prc.cbroot#/includes/images/ContentBox_300.png" alt="logo"/><br/>
					v.#getModuleConfig('contentbox').version# <br/>
					(Codename: <a href="#getModuleSettings( "contentbox" ).codenameLink#" target="_blank">#getModuleSettings( "contentbox" ).codename#</a>)
					<br/><br/>

					<p>
						Hi and welcome to the Hello module, ContentBox says <strong>Hello Buddy!</strong>, what you expected more?
					</p>

				</div>
			</div>
		</div>

	</div>
	<div class="col-md-3">
		<!--- Info Box --->
		<div class="panel panel-primary">
		    <div class="panel-heading">
		        <h3 class="panel-title"><i class="fab fa-medrt"></i> Need Help?</h3>
		    </div>
		    <div class="panel-body">
		    	#renderview(view="_tags/needhelp", module="contentbox-admin" )#
		    </div>
		</div>
	</div>
</div>
</cfoutput>