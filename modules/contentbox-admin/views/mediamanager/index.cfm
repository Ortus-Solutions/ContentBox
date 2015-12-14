<cfoutput>
<div class="row">
	<div class="col-md-12">
		<h1 class="h1">
			<i class="fa fa-picture-o"></i> Media Manager 
		</h1>
		<span class="label label-warning">#rc.library#</span>

		<cfif prc.oAuthor.checkPermission( "MEDIAMANAGER_LIBRARY_SWITCHER" )>
			<div class="pull-right">
				<div class="btn-group btn-group-sm">
				    <a class="btn btn-primary dropdown-toggle" data-toggle="dropdown" href="##">
				    	<i class="fa fa-exchange"></i> Switch Library
				    	<span class="caret"></span>
				    </a>
					<ul class="dropdown-menu pull-right">
						<cfloop array="#prc.libraryOptions#" index="thisCollection">
						<li><a href="javascript:switchLibrary( '#thisCollection.value#' )">#thisCollection.name#</a>	
						</cfloop>
					</ul>
			    </div>
			</div>
	    </cfif>
	    
	</div>
</div>
<div class="row">
	<div class="col-md-12">
		    
    	<!--- messageBox --->
		#getModel( "messagebox@cbMessagebox" ).renderit()#

		<!--- FileBrowser Viewlet --->
		#runEvent(event=prc.xehFileBrowser,eventArguments=prc.fbArgs)#
	</div>
</div>
</cfoutput>