<cfoutput>
<div class="row">

	<div class="col-md-12">
		<h1 class="h1">
			<i class="fas fa-photo-video"></i> Media Manager
		</h1>
	</div>

</div>

<div class="row">
	<div class="col-md-12">

    	<!--- messageBox --->
		#cbMessageBox().renderit()#

		<!--- FileBrowser Viewlet --->
		#runEvent(
			event          = prc.xehFileBrowser,
			eventArguments = prc.fbArgs
		)#
	</div>
</div>
</cfoutput>