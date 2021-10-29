<cfparam name="args.sidebar" default="false" />

<cfoutput>
	<!DOCTYPE html>
	<html lang="en">
		<head>
			<!--- Page Includes --->
			#cb.quickView( "_pageIncludes" )#

			<!--- ContentBoxEvent --->
			#cb.event( "cbui_beforeHeadEnd" )#
		</head>
		
		<body>
			<!--- ContentBoxEvent --->
			#cb.event( "cbui_afterBodyStart" )#

			#cb.quickView( "_header" )#

			<!--- ContentBoxEvent --->
			#cb.event( "cbui_beforeContent" )#

			<!--- Main View --->
			#cb.mainView( args=args )#

			<!--- ContentBoxEvent --->
			#cb.event( "cbui_afterContent" )#

			#cb.quickView( "_footer" )#

			<button onclick="topFunction()" title="Back to top" class="btn btn-primary hidden" id="goToTop"> <span class="visually-hidden">Back to top</span>&uarr;</button>

			<!--- ContentBoxEvent --->
			#cb.event( "cbui_beforeBodyEnd" )#
		</body>
	</html>
</cfoutput>