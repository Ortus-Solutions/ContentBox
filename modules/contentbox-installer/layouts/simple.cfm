<cfoutput>
#html.doctype()#
<html>
<!--============================Head============================-->
<head>
	<!--- utf --->
	<meta charset="utf-8"/>
	<!--- Responsive --->
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<!--- Robots --->
	<meta name="robots" content="noindex,nofollow" />
	<!--- SES HTML Base --->
	<base href="#getSetting('htmlBaseURL')#" />
	<!--- Title --->
    <title>ContentBox Installer</title>
	<!--- Favicon --->
	<link href="#prc.assetRoot#/includes/images/favicon.ico" rel="shortcut icon" type="image/x-icon" />
	<!--- StyleSheets --->
	<link href="#prc.assetRoot#/includes/css/style.css"					rel="stylesheet"/>
	<link href="#prc.assetRoot#/includes/css/bootstrap.css" 			rel="stylesheet"/>
	<link href="#prc.assetRoot#/includes/css/contentbox.css" 			rel="stylesheet"/>
	<link href="#prc.assetRoot#/includes/css/bootstrap-responsive.css" 	rel="stylesheet"/>
	<link href="#prc.assetRoot#/includes/css/font-awesome.min.css"		rel="stylesheet"/>
	<!--- JS --->
	<script src="#prc.assetRoot#/includes/js/jquery.min.js"></script>
	<script src="#prc.assetRoot#/includes/js/bootstrap.min.js"></script>
	<script src="#prc.assetRoot#/includes/js/jquery.tools.min.js"></script>
	<script src="#prc.assetRoot#/includes/js/contentbox.js"></script>
</head>
<body>
	<!--- NavBar --->
	<div class="navbar navbar-fixed-top navbar-inverse" id="adminMenuTopNav">
	    <div class="navbar-inner">
	    	<div class="container">
	    		<!--- Logo --->
				<img src="#prc.assetRoot#/includes/images/ContentBox_30.png" id="logo" title="ContentBox Modular CMS"/>
				<!--- Brand, future multi-site switcher --->
				<a class="brand">
					ContentBox Installer
				</a>
			</div> <!---end container --->
	    </div> <!--- end navbar-inner --->
    </div> <!---end navbar --->

	<!--- Container --->
	<div class="container-fluid margin10">
		#renderView()#
	</div>

	<footer id="footer" class="clearfix">
		<div class="pull-right" id="footerLogo">
			<a href="http://www.gocontentbox.org" target="_blank"><img src="#prc.assetRoot#/includes/images/ContentBox_90.png" alt="Logo" /></a>
		</div>
		Copyright (C) #dateformat(now(),"yyyy")# 
		<a href="http://www.ortussolutions.com">Ortus Solutions, Corp</a>.<br/>
		<a href="http://www.ortussolutions.com">Need Professional Support, Architecture, Design, or Development?</a>
	</footer>
	
</body>
<!--End Body-->
</html>
</cfoutput>