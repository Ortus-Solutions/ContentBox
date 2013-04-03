<cfoutput>
<div class="box clear">
	<!--- Body Header --->
	<div class="header">
		<i class="icon-th icon-large"></i>
		Media Manager :
		#html.select(options=prc.libraryOptions, class="textbox", onchange="switchLibrary(this.value)")#
	</div>
	<!--- Body --->
	<div class="body">

		<!--- messageBox --->
		#getPlugin("MessageBox").renderit()#

		<!--- FileBrowser Viewlet --->
		#runEvent(event=prc.xehFileBrowser,eventArguments=prc.fbArgs)#

	</div>
</div>
</cfoutput>