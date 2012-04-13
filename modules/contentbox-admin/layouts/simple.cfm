<cfoutput>
#html.doctype()#
<!--============================Head============================-->
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<!--- Robots --->
	<meta name="robots" content="noindex,nofollow" />
	<!--- SES --->
	<base href="#getSetting('htmlBaseURL')#" />
	<!--- Title --->
    <title>ContentBox Administrator - Login</title>
	<!--- Favicon --->
	<link href="#prc.cbroot#/includes/images/favicon.ico" rel="shortcut icon" type="image/x-icon" />
	<!--- StyleSheets --->
	<link href="#prc.cbroot#/includes/css/style.css"	rel="stylesheet" type="text/css"/>
	<link href="#prc.cbroot#/includes/css/teal.css" 	rel="stylesheet" type="text/css"/>

	<!--- JS --->
	<script type="text/javascript" src="#prc.cbroot#/includes/js/jquery.tools.min.js"></script>
	<script type="text/javascript" src="#prc.cbroot#/includes/js/contentbox.js"></script>

	<!--- cbadmin Event --->
	#announceInterception("cbadmin_beforeLoginHeadEnd")#
</head>
<!--============================Body============================-->
<body>
	<!--- cbadmin Event --->
	#announceInterception("cbadmin_afterLoginBodyStart")#
	<!--==================== Header =======================-->
	<div id="header_bg">

		<!--============Header Wrapper============-->
		<div class="wrapper">

			<!--=======Top Header area======-->
			<div id="header_top">
				<span class="fr"><br/>
				<!--- cbadmin event --->
				#announceInterception("cbadmin_onTopBar")#
				</span>
			  	<!--- cbadmin event --->
				#announceInterception("cbadmin_onTagline")#
			</div>
			<!--End Header top Area=-->

			<!--=========Header Area including search field and logo=========-->
			<div id="logo">
				<img src="#prc.cbroot#/includes/images/ContentBox_90.png" border="0" alt="logo" title="ContentBox by ColdBox!"/>
			</div>

			<div id="header_main" class="clearfix">
	           	<h1>ContentBox Admin</h1>
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
			<!--- cbadmin event --->
			#announceInterception("cbadmin_beforeLoginContent")#
			<!--- Main Content --->
			#renderView()#
			<!--- cbadmin event --->
			#announceInterception("cbadmin_afterLoginContent")#
		</div>
	</div>

	<!--============================Footer============================-->
	<div id="footer">
		<!--- cbadmin event --->
		#announceInterception("cbadmin_loginFooter")#
		<div class="wrapper">
		Copyright (C) #dateformat(now(),"yyyy")# <a href="http://www.ortussolutions.com">Ortus Solutions, Corp</a>  . All Rights Reserved.<br/>
		<a href="http://www.ortussolutions.com">Need Professional ColdFusion/ColdBox Support, Architecture, Design, or Development?</a>
		</div>
	</div>
	<!--End Footer-->

	<!--- cbadmin Event --->
	#announceInterception("cbadmin_beforeLoginBodyEnd")#
</body>
<!--End Body-->
</html>
</cfoutput>