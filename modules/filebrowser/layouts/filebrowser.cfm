<cfoutput>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<meta name="robots" content="noindex,nofollow" />	
	<!--- SES --->
	<base href="#getSetting('htmlBaseURL')#" />
	<!--- Title --->
    <title>#prc.fbSettings.title#</title> 
	<!--- JQuery --->
	<cfset addAsset("#prc.fbModRoot#/includes/javascript/jquery-1.4.4.min.js")>
</head>
<body>#renderView()#</body>
</html>
</cfoutput>