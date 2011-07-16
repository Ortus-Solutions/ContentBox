<cfoutput>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<!--============================Head============================-->
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<!--- Robots --->
	<meta name="robots" content="noindex,nofollow" />	
	<!--- SES --->
	<base href="#getSetting('htmlBaseURL')#" />
	<!--- Title --->
    <title>BlogBox Administrator - Login</title> 
	<!--- Favicon --->
	<link href="#prc.bbroot#/includes/images/favicon.ico" rel="shortcut icon" type="image/x-icon" />
	<!--- StyleSheets --->
	<link href="#prc.bbroot#/includes/css/style.css"	rel="stylesheet" type="text/css"/>
	<link href="#prc.bbroot#/includes/css/teal.css" 	rel="stylesheet" type="text/css"/>
	<link href="#prc.bbroot#/includes/css/invalid.css" 	rel="stylesheet" type="text/css"/>
            
	<!--- JS --->
	<script type="text/javascript" src="#prc.bbroot#/includes/js/jquery.tools.min.js"></script>
	<script type="text/javascript" src="#prc.bbroot#/includes/js/blogbox.js"></script>
	
	<!--- bbadmin Event --->
	#announceInterception("bbadmin_beforeLoginHeadEnd")#
</head>
<!--============================Body============================-->
<body>
	<!--- bbadmin Event --->
	#announceInterception("bbadmin_afterLoginBodyStart")#
	<!--==================== Header =======================-->
	<div id="header_bg">
	
		<!--============Header Wrapper============-->
		<div class="wrapper">
	       
			<!--=======Top Header area======-->
			<div id="header_top">
				<span class="fr"><br/></span>
			  A Sweet Blogging Platform
			</div>
			<!--End Header top Area=-->
	    
			<!--=========Header Area including search field and logo=========-->
			<div id="logo">
				<img src="#prc.bbroot#/includes/images/ColdBoxLogoSquare_125.png" height="120" border="0" alt="logo" title="ColdBox Platform Rulez!"/>
			</div>
			
			<div id="header_main" class="clearfix">
	           	<h1>BlogBox Admin <span>v.#getModuleSettings('blogbox-admin').version#</span></h1>
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
			<!--- bbadmin event --->
			#announceInterception("bbadmin_beforeLoginContent")#
			<!--- Main Content --->
			#renderView()#		
			<!--- bbadmin event --->
			#announceInterception("bbadmin_afterLoginContent")#
		</div>
	</div>
	
	<!--============================Footer============================-->
	<div id="footer">
		<!--- bbadmin event --->
		#announceInterception("bbadmin_loginFooter")#
		<div class="wrapper">
		Copyright (C) #dateformat(now(),"yyyy")# <a href="http://www.ortussolutions.com">Ortus Solutions, Corp</a>  . All Rights Reserved.<br/>
		<a href="http://www.ortussolutions.com">Need Professional ColdFusion/ColdBox Support, Architecture, Design, or Development?</a>
		</div>
	</div>
	<!--End Footer-->
	
	<!--- bbadmin Event --->
	#announceInterception("bbadmin_beforeLoginBodyEnd")#
</body>
<!--End Body-->
</html>
</cfoutput>