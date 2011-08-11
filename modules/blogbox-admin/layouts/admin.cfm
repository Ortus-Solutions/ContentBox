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
    <title>BlogBox Administrator - #prc.bbSettings.bb_site_name#</title> 
	<!--- Favicon --->
	<link href="#prc.bbroot#/includes/images/favicon.ico" rel="shortcut icon" type="image/x-icon" />
	<!--- StyleSheets --->
	<link href="#prc.bbroot#/includes/css/style.css"	 	rel="stylesheet" type="text/css"/>
	<link href="#prc.bbroot#/includes/css/teal.css" 		rel="stylesheet" type="text/css"/>
	<link href="#prc.bbroot#/includes/css/invalid.css" 	rel="stylesheet" type="text/css"/>
    <link href="#prc.bbroot#/includes/css/sort.css"	 	rel="stylesheet" type="text/css"/>
	<!--- loop around the cssAppendList, to add page specific css --->
	<cfloop list="#event.getValue("cssAppendList","")#" index="css">
		<cfset addAsset("#prc.bbroot#/includes/css/#css#.css")>
	</cfloop>
	<cfloop list="#event.getValue("cssFullAppendList","")#" index="css">
		<cfset addAsset("#css#.css")>
	</cfloop>
	        
	<!--- JS --->
	<script type="text/javascript" src="#prc.bbroot#/includes/js/jquery.tools.min.js"></script>
	<script type="text/javascript" src="#prc.bbroot#/includes/js/metadata.pack.js"></script>
	<script type="text/javascript" src="#prc.bbroot#/includes/js/jquery.uitablefilter.js"></script>
	<script type="text/javascript" src="#prc.bbroot#/includes/js/tablesorter.min.js"></script>
	<script type="text/javascript" src="#prc.bbroot#/includes/js/blogbox.js"></script>
	<script type="text/javascript" src="#prc.bbroot#/includes/ckeditor/ckeditor.js"></script>
	<script type="text/javascript" src="#prc.bbroot#/includes/ckeditor/adapters/jquery.js"></script>
	<!--- loop around the jsAppendList, to add page specific js --->
	<cfloop list="#event.getValue("jsAppendList", "")#" index="js">
		<cfset addAsset("#prc.bbroot#/includes/javascript/#js#.js")>
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
			  		Bienvenido <span id="header_top_authorName">#prc.oAuthor.getName()#</span> &nbsp;
					<!--- Log Out --->
					<a href="#event.buildLink(prc.xehDoLogout)#" class="confirmIt" title="Get outta here!"
						data-title="Log Out" data-message="Really log out of this beautiful application?"><button class="buttonsmall">Log Out</button></a>
					<!--- View Blog --->
					<a href="#event.buildLink(prc.bbSiteEntryPoint)#" target="_blank" title="View your awesome blog!"><button class="buttonsmall">View Blog</button></a>
					<!--- QUick Post --->
					<button class="buttonsmall" id="btnQuickPost" title="Create a new quick post" onclick="showQuickPost()">Quick Post</button>
					<!--- bbadmin event --->
					#announceInterception("bbadmin_onTopBar")#
				</span>
			  	<!--- site tag line --->
				#prc.bbSettings.bb_site_name# - #prc.bbSettings.bb_site_tagline#
				<!--- bbadmin event --->
				#announceInterception("bbadmin_onTagline")#
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
	      
			<!--=========Main Navigation=========-->
			<ul id="main_nav">
				<!--- bbadmin event --->
				#announceInterception("bbadmin_beforeMainNav")#
				<!--- Dashboard Nav --->
				<li> 
					<a href="##" title="BlogBox Dashboard" <cfif prc.tabDashboard>class="current"</cfif>>Dashboard</a>
					<ul>
						<li><a href="#event.buildLink(prc.xehDashboard)#" <cfif event.getValue("tabDashboard_home",false,true)> class="current"</cfif>>Home</a></li>
						<!--- bbadmin event --->
						#announceInterception("bbadmin_dashboardTab")#
					</ul>
				</li>
				<!--- Entries Nav --->
				<li>
					<a href="##" title="Blog Entries" <cfif prc.tabEntries>class="current"</cfif>>Entries</a>
					<ul>
						<li>
							<a href="#event.buildLink(prc.xehEntries)#" <cfif event.getValue("tabEntries_viewAll",false,true)> class="current"</cfif>
							   title="View All Blog Entries">Inbox</a>
						</li>
						<li>
							<a href="#event.buildLink(prc.xehBlogEditor)#" <cfif event.getValue("tabEntries_editor",false,true)> class="current"</cfif>
							   title="Create a new blog entry">Create New</a>
						</li>
						<li>
							<a href="#event.buildLink(prc.xehCategories)#" <cfif event.getValue("tabEntries_categories",false,true)> class="current"</cfif>
							   title="Manage Blog Entry Categories">Categories</a>
						</li>
						<!--- bbadmin event --->
						#announceInterception("bbadmin_entriesTab")#
					</ul>
				</li>
				<!--- Pages Nav --->
				<li>
					<a href="##" title="Blog Pages" <cfif prc.tabPages>class="current"</cfif>>Pages</a>
					<ul>
						<li>
							<a href="#event.buildLink(prc.xehPages)#" <cfif event.getValue("tabPages_viewAll",false,true)> class="current"</cfif>
							   title="View All Blog Entries">Inbox</a>
						</li>
						<li>
							<a href="#event.buildLink(prc.xehPagesEditor)#" <cfif event.getValue("tabPages_editor",false,true)> class="current"</cfif>
							   title="Create a new blog entry">Create New</a>
						</li>
						<!--- bbadmin event --->
						#announceInterception("bbadmin_pagesTab")#
					</ul>
				</li>
				<!--- Comments Nav --->
				<li>
					<a href="##" title="Comments" <cfif prc.tabComments>class="current"</cfif>>Comments</a>
					<ul>
						<li>
							<a href="#event.buildLink(prc.xehComments)#" <cfif event.getValue("tabComments_inbox",false,true)> class="current"</cfif>
							   title="View All Incoming Comments">Inbox</a>
						</li>
						<li>
							<a href="#event.buildLink(prc.xehCommentsettings)#" <cfif event.getValue("tabComments_settings",false,true)> class="current"</cfif>
							   title="Configure the BlogBox Commenting System">Settings</a>
						</li>
						<!--- bbadmin event --->
						#announceInterception("bbadmin_commentsTab")#
					</ul>
				</li>
				<!--- Look & Feel Nav --->
				<li>
					<a href="##" title="Site appearance, widgets, custom HTML and more" <cfif prc.tabSite>class="current"</cfif>>Look & Feel</a>
					<ul>
						<li>
							<a href="#event.buildLink(prc.xehLayouts)#" <cfif event.getValue("tabSite_layouts",false,true)> class="current"</cfif>
							   title="Manage Site Layouts">Manage Layouts</a>
						</li>
						<li>
							<a href="#event.buildLink(prc.xehWidgets)#" <cfif event.getValue("tabSite_widgets",false,true)> class="current"</cfif>
							   title="Manager your UI widgets">Manage Widgets</a>
						</li>
						<li>
							<a href="#event.buildLink(prc.xehCustomHTML)#" <cfif event.getValue("tabSite_customHTML",false,true)> class="current"</cfif>
							   title="Easy custom HTML for your site">Custom HTML</a>
						</li>
						<!--- bbadmin event --->
						#announceInterception("bbadmin_siteTab")#
					</ul>
				</li>
				<!--- Authors Nav --->
				<li>
					<a href="##" title="Authors" <cfif prc.tabAuthors>class="current"</cfif>>Authors</a>
					<ul>
						<li>
							<a href="#event.buildLink(prc.xehAuthors)#" <cfif event.getValue("tabAuthors_viewAll",false,true)>class="current"</cfif>
							   title="View All Authors">View All</a>
						</li>
						<li>
							<a href="#event.buildLink(prc.xehAuthorEditor)#" 
							   <cfif event.getValue("tabAuthors_editor",false,true) AND prc.oAuthor.getAuthorID() NEQ event.getValue("authorID","")>class="current"</cfif>
							   title="Create a new author">Create New</a>
						</li>
						<li>
							<a href="#event.buildLink(linkto=prc.xehAuthorEditor,querystring="authorID="&prc.oAuthor.getAuthorID())#"
							   <cfif event.getValue("tabAuthors_editor",false,true) AND prc.oAuthor.getAuthorID() eq event.getValue("authorID","")>class="current"</cfif>
							   title="Manage your profile">My Profile</a>
						</li>
						<!--- bbadmin event --->
						#announceInterception("bbadmin_authorsTab")#
					</ul>
				</li>
				<!--- Tools Nav --->
				<li>
					<a href="##" title="Tools" <cfif prc.tabTools>class="current"</cfif>>Tools</a>
					<ul>
						<li>
							<a href="#event.buildLink(prc.xehToolsImport)#" <cfif event.getValue("tabTools_import",false,true)> class="current"</cfif>
							   title="Import your database from other blogs">Import</a>
						</li>
						<!--- bbadmin event --->
						#announceInterception("bbadmin_toolsTab")#
					</ul>
				</li>
				<!--- System Nav --->
				<li>
					<a href="##" title="System" <cfif prc.tabSystem>class="current"</cfif>>System</a>
					<ul>
						<li>
							<a href="#event.buildLink(prc.xehSettings)#" <cfif event.getValue("tabSystem_Settings",false,true)> class="current"</cfif>
							   title="Manage BlogBox Global Configuration">BlogBox Settings</a>
						</li>
						<li>
							<a href="#event.buildLink(prc.xehRawSettings)#" <cfif event.getValue("tabSystem_rawSettings",false,true)> class="current"</cfif>
							   title="Manage The Raw Settings Table">Raw Settings</a>
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
			<img src="#prc.bbroot#/includes/images/ajax-loader-blue.gif" alt="loader" />
		</div>
	</div>
	<!--- ============================ end Confirmit ============================ --->
	
	<!--- ============================ QuickPost ============================ --->
	#runEvent(event="blogbox-admin:entries.quickPost",prePostExempt=true)#
	<!--- ============================ end QuickPost ============================ --->
	
	
	<!--- bbadmin Event --->
	#announceInterception("bbadmin_beforeBodyEnd")#
</body>
<!--End Body-->
</html>
</cfoutput>