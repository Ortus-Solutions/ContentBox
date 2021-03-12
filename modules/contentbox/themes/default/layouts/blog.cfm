<cfoutput>
<!--- Global Layout Arguments --->
<cfparam name="args.print" 		default="false">
<cfparam name="args.sidebar" 	default="true">
<!DOCTYPE html>
<html lang="en">
<head>
	<!--- Page Includes --->
	#cb.quickView( "_blogIncludes" )#

	<!--- ContentBoxEvent --->
	#cb.event( "cbui_beforeHeadEnd" )#
</head>
<body>
	<!--- ContentBoxEvent --->
	#cb.event( "cbui_afterBodyStart" )#

	<!--- Header --->
	#cb.quickView( '_header' )#

	<!--- ContentBoxEvent --->
	#cb.event( "cbui_beforeContent" )#

	<!--- Main View --->
	#cb.mainView( args=args )#

	<!--- ContentBoxEvent --->
	#cb.event( "cbui_afterContent" )#

	#cb.quickView( view='_footer' )#

	<!--- ContentBoxEvent --->
	#cb.event( "cbui_beforeBodyEnd" )#
</body>
</html>
</cfoutput>