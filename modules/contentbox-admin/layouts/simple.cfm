<cfoutput>
#html.doctype()#
<!--============================Head============================-->
<head>
	<!--- charset --->
	<meta charset="utf-8"/>
	<!--- Robots --->
	<meta name="robots" content="noindex,nofollow" />
	<!--- SES --->
	<base href="#getSetting('htmlBaseURL')#" />
	<!--- Title --->
    <title>ContentBox Administrator - Login</title>
	<!--- Favicon --->
	<link href="#prc.cbroot#/includes/images/favicon.ico" rel="shortcut icon" type="image/x-icon" />
	<!--- StyleSheets --->
	#cb.minify(assets="#prc.cbroot#/includes/css/style.css,
			    #prc.cbroot#/includes/css/teal.css,
			    #prc.cbroot#/includes/css/sort.css,
			    #prc.cbroot#/includes/css/bootstrap.css,
			    #prc.cbroot#/includes/css/bootstrap-responsive.css,
			    #prc.cbroot#/includes/css/font-awesome.min.css,
			    #prc.cbroot#/includes/css/contentbox.css",
			   location="#prc.cbroot#/includes/cache")#
	<!--- JS --->
	#cb.minify(assets="#prc.cbroot#/includes/js/jquery.min.js,
			    #prc.cbroot#/includes/js/bootstrap.min.js,
			    #prc.cbroot#/includes/js/jquery.tools.min.js,
			    #prc.cbroot#/includes/js/contentbox.js",
			   location="#prc.cbroot#/includes/cache")#
	<!--- cbadmin Event --->
	#announceInterception("cbadmin_beforeLoginHeadEnd")#
</head>
<!--============================Body============================-->
<body>
	<!--- cbadmin Event --->
	#announceInterception("cbadmin_afterLoginBodyStart")#
	
	<!--- NavBar --->
	<div class="navbar navbar-fixed-top navbar-inverse" id="adminMenuTopNav">
	    <div class="navbar-inner">
	    	<div class="container">
	    		<!--- Logo --->
				<img src="#prc.cbroot#/includes/images/ContentBox_30.png" id="logo" title="ContentBox Modular CMS"/>
				
				<!--- Brand, future multi-site switcher --->
				<a class="brand">
					ContentBox Administrator
				</a>
			</div> <!---end container --->
	    </div> <!--- end navbar-inner --->
    </div> <!---end navbar --->

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

	<!--- Footer --->
	#renderView(view="_tags/footer", module="contentbox-admin")#

	<!--- cbadmin Event --->
	#announceInterception("cbadmin_beforeLoginBodyEnd")#
</body>
</html>
</cfoutput>