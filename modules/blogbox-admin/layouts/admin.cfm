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
    <title>BlogBox Administrator</title> 
	<!--- Favicon --->
	<link href="#rc.bbroot#/includes/images/favicon.ico" rel="shortcut icon" type="image/x-icon" />
	<!--- StyleSheets --->
	<link href="#rc.bbroot#/includes/css/style.css"	 	rel="stylesheet" type="text/css"/>
	<link href="#rc.bbroot#/includes/css/teal.css" 		rel="stylesheet" type="text/css"/>
	<link href="#rc.bbroot#/includes/css/invalid.css" 	rel="stylesheet" type="text/css"/>
    <link href="#rc.bbroot#/includes/css/sort.css"	 	rel="stylesheet" type="text/css"/>
	<!--- loop around the cssAppendList, to add page specific css --->
	<cfloop list="#event.getValue("cssAppendList","")#" index="css">
		<cfset addAsset("#rc.bbroot#/includes/css/#css#.css")>
	</cfloop>
	<cfloop list="#event.getValue("cssFullAppendList","")#" index="css">
		<cfset addAsset("#css#.css")>
	</cfloop>
	        
	<!--- JS --->
	<script type="text/javascript" src="#rc.bbroot#/includes/js/jquery.tools.min.js"></script>
	<script type="text/javascript" src="#rc.bbroot#/includes/js/metadata.pack.js"></script>
	<script type="text/javascript" src="#rc.bbroot#/includes/js/jquery.uitablefilter.js"></script>
	<script type="text/javascript" src="#rc.bbroot#/includes/js/tablesorter.min.js"></script>
	<script type="text/javascript" src="#rc.bbroot#/includes/js/blogbox.js"></script>
	<!--- loop around the jsAppendList, to add page specific js --->
	<cfloop list="#event.getValue("jsAppendList", "")#" index="js">
		<cfset addAsset("#rc.bbroot#/includes/javascript/#js#.js")>
	</cfloop>
	<cfloop list="#event.getValue("jsFullAppendList", "")#" index="js">
		<cfset addAsset("#js#.js")>
	</cfloop>

	<!--- bbadmin Event --->
	#announceInterception("bbadmin_beforeHeadEnd")#
</head>
<!--============================Body============================-->
<body>
	<!--- bbadmin Event --->
	#announceInterception("bbadmin_afterBodyStart")#
	<!--==================== Header =======================-->
	<div id="header_bg">
	
		<!--============Header Wrapper============-->
		<div class="wrapper">
	       
			<!--=======Top Header area======-->
			<div id="header_top">
				<span class="fr">
			  		Welcome back <strong>#prc.oAuthor.getName()#</strong> &nbsp;
					<!--- Log Out --->
					<a href="#event.buildLink(rc.xehDoLogout)#" class="confirmIt" 
						data-title="Log Out" data-message="Really log out of this beautiful application?"><button class="buttonsmall">Log Out</button></a>
					<!--- View Blog --->
					<a href="#event.buildLink(getModuleSettings("blogbox").entryPoint)#" target="_blank"><button class="buttonsmall">View Blog</button></a>
				</span>
			  A Sweet Blogging Platform
			</div>
			<!--End Header top Area=-->
	    
			<!--=========Header Area including search field and logo=========-->
			<div id="logo">
				<img src="#rc.bbroot#/includes/images/ColdBoxLogoSquare_125.png" height="120" border="0" alt="logo" title="ColdBox Platform Rulez!"/>
			</div>
			
			<div id="header_main" class="clearfix">
	           	<a href="#event.buildLink(rc.xehDashboard)#"><h1>BlogBox Admin <span>v.#getModuleSettings('blogbox-admin').version#</span></h1></a>
			</div>
			<!--End Search field and logo Header Area-->
	      
			<!--=========Main Navigation=========-->
			<ul id="main_nav">
				<!--- bbadmin event --->
				#announceInterception("bbadmin_beforeMainNav")#
				<!--- Dashboard Nav --->
				<li> 
					<a href="##" title="BlogBox Dashboard" class="current">Dashboard</a>
					<ul>
						<li><a href="#event.buildLink(rc.xehDashboard)#" <cfif event.getCurrentAction() eq "index"> class="current"</cfif>>Home</a></li>
						<!--- bbadmin event --->
						#announceInterception("bbadmin_dashboardTab")#
					</ul>
				</li>
				<!--- Entries Nav --->
				<li>
					<a href="##" title="Blog Entries" <cfif event.getCurrentHandler() eq "blogbox-admin:entries"> class="current"</cfif>>Entries</a>
					<ul>
						<li>
							<a href="#event.buildLink(rc.xehEntries)#" <cfif event.getCurrentAction() eq "indexs"> class="current"</cfif>
							   title="View All Entries">View All</a>
						</li>
						<li>
							<a href="#event.buildLink(rc.xehBlogEditor)#" <cfif event.getCurrentAction() eq "editor"> class="current"</cfif>
							   title="Create a new entry">Create New</a>
						</li>
						<li>
							<a href="#event.buildLink(rc.xehCategories)#"
							   title="Manage Categories">Categories</a>
						</li>
						<li>
							<a href="#event.buildLink(rc.xehCategories)#"
							   title="Manage Comments">Comments</a>
						</li>
						<!--- bbadmin event --->
						#announceInterception("bbadmin_entriesTab")#
					</ul>
				</li>
				<!--- Authors Nav --->
				<li>
					<a href="##" title="Authors" <cfif event.getCurrentHandler() eq "blogbox-admin:entries"> class="current"</cfif>>Authors</a>
					<ul>
						<li>
							<a href="#event.buildLink(rc.xehAuthors)#" <cfif event.getCurrentAction() eq "indexs"> class="current"</cfif>
							   title="View All Authors">View All</a>
						</li>
						<li>
							<a href="#event.buildLink(rc.xehAuthorEditor)#" <cfif event.getCurrentAction() eq "editor"> class="current"</cfif>
							   title="Create a new author">Create New</a>
						</li>
						<li>
							<a href="#event.buildLink(rc.xehAuthorsProfile)#"
							   title="Manage your profile">My Profile</a>
						</li>
						<!--- bbadmin event --->
						#announceInterception("bbadmin_authorsTab")#
					</ul>
				</li>
				<!--- System Nav --->
				<li>
					<a href="##" title="System" <cfif event.getCurrentHandler() eq "blogbox-admin:entries"> class="current"</cfif>>System</a>
					<ul>
						<li>
							<a href="#event.buildLink(rc.xehSettings)#" <cfif event.getCurrentAction() eq "indexs"> class="current"</cfif>
							   title="View All Authors">Settings</a>
						</li>
						<!--- bbadmin event --->
						#announceInterception("bbadmin_systemTab")#
					</ul>
				</li>
				<!--- bbadmin event --->
				#announceInterception("bbadmin_afterMainNav")#
			</ul>
			<!--End Main Navigation-->
	    
	  	</div>
	  <!--End Wrapper-->
	</div>
	<!--End Header-->
	
	<!--============================ Template Content Background ============================-->
	<div id="content_bg" class="clearfix">
		<!--============================ Main Content Area ============================-->
		<div class="content wrapper clearfix">
			<!--- bbadmin event --->
			#announceInterception("bbadmin_beforeContent")#
			<!--- Main Content --->
			#renderView()#		
			<!--- bbadmin event --->
			#announceInterception("bbadmin_afterContent")#
		</div>
	</div>
	
	<!--============================Footer============================-->
	<div id="footer">
		<!--- bbadmin event --->
		#announceInterception("bbadmin_footer")#
		<div class="wrapper">
		Copyright (C) #dateformat(now(),"yyyy")# <a href="http://www.ortussolutions.com">Ortus Solutions, Corp</a>  . All Rights Reserved.<br/>
		<a href="http://www.ortussolutions.com">Need Professional ColdFusion/ColdBox Support, Architecture, Design, or Development?</a>
		</div>
	</div>
	<!--End Footer-->
	
	<!--- ============================ confirm it modal dialog ============================ --->
	<div id="confirmIt"> 
		<div> 
			<h2 id="confirmItTitle">Are you sure?</h2> 
			<p id="confirmItMessage">Are you sure you want to perform this action?</p> 
			<hr />
			<p class="textRight">
				<button class="close button" 	data-action="cancel"> Cancel </button>
				<button class="close buttonred" data-action="confirm"> Confirm </button>
			</p>
		</div> 
	</div>
	<!--- ============================ end Confirmit ============================ --->
	
	<!--- ============================ Remote Modal Window ============================ --->
	<div id="remoteModal">
		<div id="remoteModelContent">
			<img src="#rc.bbroot#/includes/images/ajax-loader-blue.gif" alt="loader" />
		</div>
	</div>
	<!--- ============================ end Confirmit ============================ --->
	
	<!--- bbadmin Event --->
	#announceInterception("bbadmin_beforeBodyEnd")#
</body>
<!--End Body-->
</html>
</cfoutput>