<cfoutput>
<!DOCTYPE html>
<html>
<head>
	<!--- utf --->
	<meta charset="utf-8"/>
	<!--- Responsive --->
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<!--- SES --->
	<base href="#event.getHTMLBaseURL()#" />
	<!--- Title --->
    <title>#prc.fbSettings.title#</title>
	<!--- JQuery --->
	<cfset addAsset( "#prc.fbModRoot#/includes/javascript/jquery.min.js" )>
</head>
<body>#renderView()#</body>
</html>
</cfoutput>