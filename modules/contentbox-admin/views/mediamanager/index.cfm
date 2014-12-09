<cfoutput>
<div class="row-fluid">
	<div class="box clear">
		<!--- Body Header --->
		<div class="header">
			<i class="icon-th icon-large"></i>
			Media Manager <span class="label">#rc.library#</span>
			
			<cfif prc.oAuthor.checkPermission( "MEDIAMANAGER_LIBRARY_SWITCHER" )>
				<div class="btn-group pull-right">
				    <a class="btn btn-inverse dropdown-toggle" data-toggle="dropdown" href="##">
				    	<i class="icon-exchange"></i> Switch Library
				    	<span class="caret"></span>
				    </a>
					<ul class="dropdown-menu">
						<cfloop array="#prc.libraryOptions#" index="thisCollection">
						<li><a href="javascript:switchLibrary( '#thisCollection.value#' )">#thisCollection.name#</a>	
						</cfloop>
					</ul>
			    </div>
		    </cfif>
		</div>
		
		<!--- Body --->
		<div class="body">
			
			<!--- messageBox --->
			#getPlugin("MessageBox").renderit()#
	
			<!--- FileBrowser Viewlet --->
			#runEvent(event=prc.xehFileBrowser,eventArguments=prc.fbArgs)#
	
		</div>
	</div>
</div>
</cfoutput>