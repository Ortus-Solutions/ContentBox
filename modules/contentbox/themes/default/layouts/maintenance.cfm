<cfparam name="args.sidebar" default="true">
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