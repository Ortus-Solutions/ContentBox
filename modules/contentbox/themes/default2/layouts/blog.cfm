<cfoutput>
	<!--- Global Layout Arguments --->
	<cfparam name="args.print" 		default="false" />
	<cfparam name="args.sidebar" 	default="true" />

	<!DOCTYPE html>
	<html lang="en">
		<head>
			<link rel="stylesheet" href="#cb.themeRoot()#/includes/css/App.css" />
			
			<!--- ContentBoxEvent --->
			#cb.event( "cbui_beforeHeadEnd" )#
		</head>

		<body>
			<!--- ContentBoxEvent --->
			#cb.event( "cbui_afterBodyStart" )#

			<!--- ContentBoxEvent --->
			#cb.event( "cbui_beforeContent" )#

			<!--- Main View --->
			#cb.mainView( args=args )#

			<!--- ContentBoxEvent --->
			#cb.event( "cbui_afterContent" )#

			<!--- ContentBoxEvent --->
			#cb.event( "cbui_beforeBodyEnd" )#
		</body>
	</html>
</cfoutput>