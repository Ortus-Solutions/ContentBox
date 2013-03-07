<cfoutput>
<cfsetting showdebugoutput="false">
<!--- Process Handler --->
<cfinclude template="handlers/process.cfm">
<!DOCTYPE html>
<html>
<!--============================Head============================-->
<head>
	<!--- utf --->
	<meta charset="utf-8"/>
	<!--- Robots --->
	<meta name="robots" content="noindex,nofollow" />
	<!--- Title --->
    <title>ContentBox Datasource Wizard</title>
	<!--- Favicon --->
	<link href="#assetRoot#/includes/images/favicon.ico" rel="shortcut icon" type="image/x-icon" />
	<!--- StyleSheets --->
	<link href="#assetRoot#/includes/css/style.css"	rel="stylesheet"/>
	<link href="#assetRoot#/includes/css/teal.css" 	rel="stylesheet"/>
	<!--- JS --->
	<script src="#assetRoot#/includes/js/jquery.min.js"></script>
	<script src="#assetRoot#/includes/js/jquery.tools.min.js"></script>
	<script src="#assetRoot#/includes/js/contentbox.js"></script>
</head>
<!--============================Body============================-->
<body>
	<!--==================== Header =======================-->
	<div id="header_bg">

		<!--============Header Wrapper============-->
		<div class="wrapper">

			<!--=======Top Header area======-->
			<div id="header_top">
				<span class="fr"><br/></span>
			  	<a href="http://www.gocontentbox.com">www.gocontentbox.com</a> |
				<a href="http://twitter.com/gocontentbox">twitter.com/gocontentbox</a> |
				<a href="http://www.ortussolutions.com">www.ortussolutions.com</a>
			</div>
			<!--End Header top Area=-->

			<!--=========Header Area including search field and logo=========-->
			<div id="logo">
				<img src="#assetRoot#/includes/images/ContentBox_90.png" border="0" alt="logo" title="ContentBox by ColdBox!"/>
			</div>

			<div id="header_main" class="clearfix">
	           	<h1>ContentBox Datsource Wizard</h1>
			</div>
			<!--End Search field and logo Header Area-->

	  	</div>
	  <!--End Wrapper-->
	</div>
	<!--End Header-->

	<!--============================ Template Content Background ============================-->
	<div id="content_bg" class="clearfix">
		<!--============================ Main Content Area ============================-->
		<div class="content wrapper clearfix">
			<cfinclude template="views/index.cfm">
		</div>
	</div>

	<!--============================Footer============================-->
	<div id="footer">
		<div class="wrapper">
		Copyright (C) #dateformat(now(),"yyyy")# <a href="http://www.ortussolutions.com">Ortus Solutions, Corp</a>  . All Rights Reserved.<br/>
		<a href="http://www.ortussolutions.com">Need Professional ColdFusion/ColdBox Support, Architecture, Design, or Development?</a>
		</div>
	</div>
	<!--End Footer-->

</body>
<!--End Body-->
</html>
</cfoutput>