﻿<cfoutput>
#html.doctype()#
<!--============================Head============================-->
<head>
	<!--- charset --->
	<meta charset="utf-8"/>
	<!--- Responsive --->
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<!--- Robots --->
	<meta name="robots" content="noindex,nofollow" />
	<!--- SES --->
	<base href="#cb.siteBaseURL()#"/>
	<!--- Title --->
    <title>ContentBox Modular CMS - #cb.r( "common.login@security" )#</title>
	<!--- Favicon --->
	<link href="#prc.cbroot#/includes/images/favicon.ico" rel="shortcut icon" type="image/x-icon" />
	<!--- For non-Retina iPhone, iPod Touch, and Android 2.2+ devices: --->
	<link href="#prc.cbroot#/includes/images/ContentBox-Circle-57.png" rel="apple-touch-icon"/>
	<!--- For first-generation iPad: --->
	<link href="#prc.cbroot#/includes/images/ContentBox-Circle-72.png" rel="apple-touch-icon" sizes="72x72"/>
	<!--- For iPhone 4 with high-resolution Retina display: --->
	<link href="#prc.cbroot#/includes/images/ContentBox-Circle-114.png" rel="apple-touch-icon" sizes="114x114"/>
	<!--- StyleSheets --->
	#cb.minify(assets="#prc.cbroot#/includes/css/bootstrap.css,
			    #( len( prc.adminThemeService.getCurrentTheme().getCSS() ) ? prc.adminThemeService.getCurrentTheme().getCSS() & ',' : '')#
			    #prc.cbroot#/includes/css/bootstrap-responsive.css,
			    #prc.cbroot#/includes/css/font-awesome.min.css",
			   location="#prc.cbroot#/includes/cache")#
	<!--- JS --->
	#cb.minify(assets="#prc.cbroot#/includes/js/jquery.min.js,
			    #prc.cbroot#/includes/js/bootstrap.min.js,
			    #prc.cbroot#/includes/js/jquery.validate.js,
			    #prc.cbroot#/includes/js/jquery.validate.bootstrap.js,
			    #prc.cbroot#/includes/js/jwerty.js,
			    #( len( prc.adminThemeService.getCurrentTheme().getJS() ) ? prc.adminThemeService.getCurrentTheme().getJS() & ',' : '')#
			    #prc.cbroot#/includes/js/contentbox.js",
			   location="#prc.cbroot#/includes/cache")#
	<!--- cbadmin Event --->
	#announceInterception("cbadmin_beforeLoginHeadEnd")#
</head>
<body>
	<!--- cbadmin Event --->
	#announceInterception("cbadmin_afterLoginBodyStart")#
	
	<div id="wrapper">
		<!--- NavBar --->
		<div class="navbar navbar-fixed-top navbar-inverse" id="adminMenuTopNav">
		    <div class="navbar-inner">
		    	<div class="container">
		    		<!--- Logo --->
					<img src="#prc.cbroot#/includes/images/ContentBox_30.png" id="logo" title="ContentBox Modular CMS"/>
					<!--- Brand, future multi-site switcher --->
					<a class="brand">
						ContentBox Modular CMS
					</a>
					<!--- i18n navbar --->
					<ul class="nav pull-right">
						<li class="dropdown">
							<a href="##" class="dropdown-toggle" data-toggle="dropdown" role="button">
								<i class="icon-globe"></i> #cb.r( "lang.localize@cbcore" )# <b class="caret"></b>
								<ul role="menu" class="dropdown-menu">
									<cfloop array="#prc.langs#" index="thisLang">
									<li><a href="#prc.xehLang#/#thisLang#">#cb.r( "lang.#listFirst( thisLang, "_" )#@cbcore" )#</a></li>
									</cfloop>
								</ul>
							</a>
						</li>
					</ul>
				</div> <!---end container --->
		    </div> <!--- end navbar-inner --->
	    </div> <!---end navbar --->
		
		<!--- Container --->
		<div id="simple-container" class="container-fluid">
			<!--- cbadmin event --->
			#announceInterception("cbadmin_beforeLoginContent")#
			<!--- Main Content --->
			#renderView()#
			<!--- cbadmin event --->
			#announceInterception("cbadmin_afterLoginContent")#
		</div>
	
		<div class="push"></div>

	</div>
	<!--- Footer --->
	#renderView(view="_tags/footer", module="contentbox-admin")#
	<!--- cbadmin Event --->
	#announceInterception("cbadmin_beforeLoginBodyEnd")#
</body>
</html>
</cfoutput>