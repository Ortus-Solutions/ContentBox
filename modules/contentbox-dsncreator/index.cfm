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
	<!--- Responsive --->
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<!--- Title --->
    <title>ContentBox Datasource Wizard</title>
	<!--- Favicon --->
	<link href="#assetRoot#/includes/images/favicon.ico" rel="shortcut icon" type="image/x-icon" />
	<!--- StyleSheets --->
	<link href="#assetRoot#/includes/css/bootstrap.css" 			rel="stylesheet"/>
	<link href="#assetRoot#/includes/css/contentbox.css" 			rel="stylesheet"/>
	<link href="#assetRoot#/includes/css/bootstrap-responsive.css" 	rel="stylesheet"/>
	<link href="#assetRoot#/includes/css/font-awesome.min.css"		rel="stylesheet"/>
	<!--- JS --->
	<script src="#assetRoot#/includes/js/jquery.min.js"></script>
	<script src="#assetRoot#/includes/js/bootstrap.min.js"></script>
	<script src="#assetRoot#/includes/js/jquery.validate.js"></script>
	<script src="#assetRoot#/includes/js/jquery.validate.bootstrap.js"></script>
	<script src="#assetRoot#/includes/js/contentbox.js"></script>
</head>
<!--============================Body============================-->
<body>
	<!--- NavBar --->
	<div class="navbar navbar-fixed-top navbar-inverse" id="adminMenuTopNav">
	    <div class="navbar-inner">
	    	<div class="container">
	    		<!--- Logo --->
				<img src="#assetRoot#/includes/images/ContentBox_30.png" id="logo" title="ContentBox Modular CMS"/>
				<!--- Brand, future multi-site switcher --->
				<a class="brand">
					ContentBox Datasource Wizard
				</a>
			</div> <!---end container --->
	    </div> <!--- end navbar-inner --->
    </div> <!---end navbar --->

	<!--- Container --->
	<div class="container-fluid margin10">
		<div class="row-fluid" style="padding-bottom:100px">
			<cfinclude template="views/index.cfm">
		</div>
	</div>

	<footer id="footer" class="clearfix">
		<div class="pull-right" id="footerLogo">
			<a href="http://www.gocontentbox.org" target="_blank"><img src="#assetRoot#/includes/images/ContentBox_90.png" alt="Logo" /></a>
		</div>
		
		Copyright (C) #dateformat(now(),"yyyy")# 
		<a href="http://www.ortussolutions.com">Ortus Solutions, Corp</a>.<br/>
		<a href="http://www.ortussolutions.com">Need Professional Support, Architecture, Design, or Development?</a>
	</footer>

</body>
<!--End Body-->
</html>
</cfoutput>