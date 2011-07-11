<cfoutput>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<!--- base HREF for SES --->
	<base href="#getSetting('htmlbaseURL')#"/>
	<!--- TITLE --->
	<title>BlogBox</title>
	<!--- FAVICON --->
	<link href="#rc.bbroot#/includes/images/favicon.ico" rel="shortcut icon" type="image/x-icon" />
	<!--- ASSETS --->
	<!--=========Stylesheets=========-->
	<link href="#rc.bbroot#/includes/css/style.css"	 	rel="stylesheet" type="text/css"/>
	<link href="#rc.bbroot#/includes/css/teal.css" 		rel="stylesheet" type="text/css"/>
	<link href="#rc.bbroot#/includes/css/invalid.css" 	rel="stylesheet" type="text/css"/>
	<!--- loop around the cssAppendList, to add page specific css --->
	<cfloop list="#event.getValue("cssAppendList","")#" index="css">
		<cfset addAsset("#rc.bbroot#/includes/css/#css#.css")>
	</cfloop>
	<cfloop list="#event.getValue("cssFullAppendList","")#" index="css">
		<cfset addAsset("#css#.css")>
	</cfloop>
	        
	<!--========= JAVASCRIPT -->
	<script type="text/javascript" src="#rc.bbroot#/includes/js/jquery.latest.min.js"></script> <!--Import jquery tools-->
	<script type="text/javascript" src="#rc.bbroot#/includes/js/jquery.tools.min.js"></script> <!--Import jquery tools-->
	<script type="text/javascript" src="#rc.bbroot#/includes/js/blogbox.js"></script>
	<!--- loop around the jsAppendList, to add page specific js --->
	<cfloop list="#event.getValue("jsAppendList", "")#" index="js">
		<cfset addAsset("#rc.bbroot#/includes/js/#js#.js")>
	</cfloop>
	<cfloop list="#event.getValue("jsFullAppendList", "")#" index="js">
		<cfset addAsset("#js#.js")>
	</cfloop>
</head>
<body>
<!--============================ Template Content Background ============================-->
<div>
	<!--============================ Main Content Area ============================-->
	<div class="content wrapper clearfix">
		#renderView()#
	</div>
</div>
</body>
</html>
</cfoutput>