<cfoutput>
	<!--- Global Layout Arguments --->
	<cfparam name="args.print" 		default="false" />
	<cfparam name="args.sidebar" 	default="true" />

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

			<button onclick="topFunction()" title="Back to top" class="btn btn-primary hidden" id="goToTop"> <span class="visually-hidden">Back to top</span>&uarr;</button>
			
			<!--- ContentBoxEvent --->
			#cb.event( "cbui_afterContent" )#

			<!--- ContentBoxEvent --->
			#cb.event( "cbui_beforeBodyEnd" )#
		</body>
	</html>
</cfoutput>