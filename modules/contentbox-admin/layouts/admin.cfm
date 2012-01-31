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
    <title>ContentBox Administrator - #prc.cbSettings.cb_site_name#</title>
	<!--- Favicon --->
	<link href="#prc.cbroot#/includes/images/favicon.ico" rel="shortcut icon" type="image/x-icon" />
	<!--- StyleSheets --->
	<link href="#prc.cbroot#/includes/css/style.css"	rel="stylesheet" type="text/css"/>
	<link href="#prc.cbroot#/includes/css/teal.css" 	rel="stylesheet" type="text/css"/>
	<link href="#prc.cbroot#/includes/css/invalid.css" 	rel="stylesheet" type="text/css"/>
    <link href="#prc.cbroot#/includes/css/sort.css"	 	rel="stylesheet" type="text/css"/>
	<!--- loop around the cssAppendList, to add page specific css --->
	<cfloop list="#event.getValue("cssAppendList","")#" index="css">
		<cfset addAsset("#prc.cbroot#/includes/css/#css#.css")>
	</cfloop>
	<cfloop list="#event.getValue("cssFullAppendList","")#" index="css">
		<cfset addAsset("#css#.css")>
	</cfloop>

	<!--- JS --->
	<script type="text/javascript" src="#prc.cbroot#/includes/js/jquery.tools.min.js"></script>
	<script type="text/javascript" src="#prc.cbroot#/includes/js/metadata.pack.js"></script>
	<script type="text/javascript" src="#prc.cbroot#/includes/js/jquery.uitablefilter.js"></script>
	<script type="text/javascript" src="#prc.cbroot#/includes/js/jquery.tablednd_0_5.js"></script>
	<script type="text/javascript" src="#prc.cbroot#/includes/js/tablesorter.min.js"></script>
	<script type="text/javascript" src="#prc.cbroot#/includes/js/contentbox.js"></script>
	<script type="text/javascript" src="#prc.cbroot#/includes/ckeditor/ckeditor.js"></script>
	<script type="text/javascript" src="#prc.cbroot#/includes/ckeditor/adapters/jquery.js"></script>
	<!--- loop around the jsAppendList, to add page specific js --->
	<cfloop list="#event.getValue("jsAppendList", "")#" index="js">
		<cfset addAsset("#prc.cbroot#/includes/javascript/#js#.js")>
	</cfloop>
	<cfloop list="#event.getValue("jsFullAppendList", "")#" index="js">
		<cfset addAsset("#js#.js")>
	</cfloop>

	<!--- cbadmin Event --->
	#announceInterception("cbadmin_beforeHeadEnd")#
</head>
<!--============================Body============================-->
<body>
	<!--- cbadmin Event --->
	#announceInterception("cbadmin_afterBodyStart")#
	<!--==================== Header =======================-->
	<div id="header_bg">

		<!--============Header Wrapper============-->
		<div class="wrapper">

			<!--=======Top Header area======-->
			<div id="header_top">
				<span class="fr">
					<!--- View Site --->
					<a href="#event.buildLink(prc.cbEntryPoint)#" target="_blank"><button class="buttonsmall">View Site</button></a>
					<cfif prc.oAuthor.checkPermission("ENTRIES_ADMIN")>
					<!--- Quick Post --->
					<button class="buttonsmall" onclick="showQuickPost()">Quick Post</button>
					</cfif>
					<!--- Quick Links --->
					<select name="quickLinks" id="quickLinks" onchange="quickLinks(this.value)">
						<option value="null">Quick Links</option>
						<cfif prc.oAuthor.checkPermission("PAGES_ADMIN")>
							<option value="#event.buildLink(prc.xehPagesEditor)#">Create New Page</option>
						</cfif>
						<cfif prc.oAuthor.checkPermission("ENTRIES_ADMIN")>
							<option value="#event.buildLink(prc.xehBlogEditor)#">Create New Entry</option>
						</cfif>
						<cfif prc.oAuthor.checkPermission("AUTHOR_ADMIN")>
							<option value="#event.buildLink(prc.xehAuthorEditor)#">Create New Author</option>
						</cfif>
						<option value="#event.buildLink(prc.xehSettings)#">ContentBox Settings</option>
						<option value="#event.buildLink(linkto=prc.xehAuthorEditor,querystring="authorID="&prc.oAuthor.getAuthorID())#">My Profile</option>
						<option value="#event.buildLink(prc.xehDashboard)#">Dashboard</option>
					</select>

					&nbsp;
			  		Bienvenido <span id="header_top_authorName">#prc.oAuthor.getName()#</span>
					&nbsp;

					<!--- Log Out --->
					<a href="#event.buildLink(prc.xehDoLogout)#" class="confirmIt"
						data-title="Log Out" data-message="Really log out of this beautiful application?"><button class="buttonsmall" onclick="return false;">Log Out</button></a>

					<!--- cbadmin event --->
					#announceInterception("cbadmin_onTopBar")#
				</span>
			  	<!--- site tag line --->
				#prc.cbSettings.cb_site_name# - #prc.cbSettings.cb_site_tagline#
				<!--- cbadmin event --->
				#announceInterception("cbadmin_onTagline")#
			</div>
			<!--End Header top Area=-->

			<!--=========Header Area including search field and logo=========-->
			<div id="logo">
				<img src="#prc.cbroot#/includes/images/ContentBox_125.gif" height="120" border="0" alt="logo"/>
			</div>

			<div id="header_main" class="clearfix">
	           	<h1>ContentBox Admin <span>v.#getModuleSettings('contentbox-admin').version#</span></h1>
			</div>
			<!--End Search field and logo Header Area-->

			<!--=========Main Navigation=========-->
			<ul id="main_nav">
				<!--- cbadmin event --->
				#announceInterception("cbadmin_beforeMainNav")#
				<!--- Dashboard Nav --->
				<li>
					<a href="##" title="ContentBox Dashboard" <cfif prc.tabDashboard>class="current"</cfif>>Dashboard</a>
					<ul>
						<li>
							<a href="#event.buildLink(prc.xehDashboard)#" <cfif event.getValue("tabDashboard_home",false,true)> class="current"</cfif>>Home</a>
						</li>
						<li>
							<a href="#event.buildLink(linkto=prc.xehAuthorEditor,querystring="authorID="&prc.oAuthor.getAuthorID())#"
							   title="Manage your profile">My Profile</a>
						</li>
						<li>
							<a href="#event.buildLink(prc.xehAbout)#" <cfif event.getValue("tabDashboard_about",false,true)> class="current"</cfif>>About</a>
						</li>
						<!--- cbadmin event --->
						#announceInterception("cbadmin_dashboardTab")#
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
							<a href="#event.buildLink(prc.xehCategories)#" <cfif event.getValue("tabEntries_categories",false,true)> class="current"</cfif>
							   title="Manage Blog Entry Categories">Categories</a>
						</li>
						<!--- cbadmin event --->
						#announceInterception("cbadmin_entriesTab")#
					</ul>
				</li>
				<!--- Content Nav --->
				<li>
					<a href="##" title="Site Content" <cfif prc.tabContent>class="current"</cfif>>Content</a>
					<ul>
						<li>
							<a href="#event.buildLink(prc.xehPages)#" <cfif event.getValue("tabContent_viewAll",false,true)> class="current"</cfif>
							   title="View All Blog Entries">Manage Pages</a>
						</li>
						<li>
							<a href="#event.buildLink(prc.xehCustomHTML)#" <cfif event.getValue("tabContent_customHTML",false,true)> class="current"</cfif>
							   title="Easy custom HTML for your site">Custom HTML</a>
						</li>
						<cfif prc.oAuthor.checkPermission("MEDIAMANAGER_ADMIN")>
						<li>
							<a href="#event.buildLink(prc.xehMediaManager)#" <cfif event.getValue("tabContent_mediaManager",false,true)> class="current"</cfif>
							   title="Manager your ContentBox Media">Media Manager</a>
						</li>
						</cfif>
						<!--- cbadmin event --->
						#announceInterception("cbadmin_pagesTab")#
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
							   title="Configure the ContentBox Commenting System">Settings</a>
						</li>
						<!--- cbadmin event --->
						#announceInterception("cbadmin_commentsTab")#
					</ul>
				</li>
				<!--- Look & Feel Nav --->
				<li>
					<a href="##" title="Site appearance, widgets, custom HTML and more" <cfif prc.tabSite>class="current"</cfif>>Look & Feel</a>
					<ul>
						<li>
							<a href="#event.buildLink(prc.xehLayouts)#" <cfif event.getValue("tabSite_layouts",false,true)> class="current"</cfif>
							   title="Manage Site Layouts">Layouts</a>
						</li>
						<li>
							<a href="#event.buildLink(prc.xehWidgets)#" <cfif event.getValue("tabSite_widgets",false,true)> class="current"</cfif>
							   title="Manager your UI widgets">Widgets</a>
						</li>
						<li>
							<a href="#event.buildLink(prc.xehGlobalHTML)#" <cfif event.getValue("tabSite_globalHTML",false,true)> class="current"</cfif>
							   title="Easy global HTML for your layouts">Global HTML</a>
						</li>
						<!--- cbadmin event --->
						#announceInterception("cbadmin_siteTab")#
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
							<a href="#event.buildLink(prc.xehPermissions)#" <cfif event.getValue("tabAuthors_Permissions",false,true)> class="current"</cfif>
							   title="Manage ContentBox Security Permissions">Permissions</a>
						</li>
						<li>
							<a href="#event.buildLink(prc.xehRoles)#" <cfif event.getValue("tabAuthors_Roles",false,true)> class="current"</cfif>
							   title="Manage ContentBox Security Roles">Roles</a>
						</li>
						<li>
							<a href="#event.buildLink(linkto=prc.xehAuthorEditor,querystring="authorID="&prc.oAuthor.getAuthorID())#"
							   <cfif event.getValue("tabAuthors_editor",false,true) AND prc.oAuthor.getAuthorID() eq event.getValue("authorID","")>class="current"</cfif>
							   title="Manage your profile">My Profile</a>
						</li>
						<!--- cbadmin event --->
						#announceInterception("cbadmin_authorsTab")#
					</ul>
				</li>
				<!--- Tools Nav --->
				<li>
					<a href="##" title="Tools" <cfif prc.tabTools>class="current"</cfif>>Tools</a>
					<ul>
						<cfif prc.oAuthor.checkPermission("TOOLS_IMPORT")>
						<li>
							<a href="#event.buildLink(prc.xehToolsImport)#" <cfif event.getValue("tabTools_import",false,true)> class="current"</cfif>
							   title="Import your database from other blogs">Import</a>
						</li>
						</cfif>
						<li>
							<a href="#event.buildLink(prc.xehApiDocs)#" <cfif event.getValue("tabTools_apidocs",false,true)> class="current"</cfif>
							   title="Inspect your ContentBox API">API Docs</a>
						</li>
						<!--- cbadmin event --->
						#announceInterception("cbadmin_toolsTab")#
					</ul>
				</li>
				<!--- System Nav --->
				<cfif prc.oAuthor.checkPermission("SYSTEM_TAB")>
				<li>
					<a href="##" title="System" <cfif prc.tabSystem>class="current"</cfif>>System</a>
					<ul>
						<li>
							<a href="#event.buildLink(prc.xehSettings)#" <cfif event.getValue("tabSystem_Settings",false,true)> class="current"</cfif>
							   title="Manage ContentBox Global Configuration">Settings</a>
						</li>
						<li>
							<a href="#event.buildLink(prc.xehSecurityRules)#" <cfif event.getValue("tabSystem_SecurityRules",false,true)> class="current"</cfif>
							   title="Manage ContentBox Security Rules">Security Rules</a>
						</li>
						<cfif prc.oAuthor.checkPermission("EMAIL_TEMPLATE_ADMIN")>
						<li>
							<a href="#event.buildLink(prc.xehEmailTemplates)#" <cfif event.getValue("tabSystem_emailtemplates",false,true)> class="current"</cfif>
							   title="Manage ContentBox Email Templates">Email Templates</a>
						</li>
						</cfif>
						<cfif prc.oAuthor.checkPermission("SYSTEM_RAW_SETTINGS")>
						<li>
							<a href="#event.buildLink(prc.xehRawSettings)#" <cfif event.getValue("tabSystem_rawSettings",false,true)> class="current"</cfif>
							   title="Manage The Raw Settings Geek Style">Geek Settings</a>
						</li>
						</cfif>
						<!--- cbadmin event --->
						#announceInterception("cbadmin_systemTab")#
					</ul>
				</li>
				</cfif>
				<!--- cbadmin event --->
				#announceInterception("cbadmin_afterMainNav")#
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
			<!--- cbadmin event --->
			#announceInterception("cbadmin_beforeContent")#
			<!--- Main Content --->
			#renderView()#
			<!--- cbadmin event --->
			#announceInterception("cbadmin_afterContent")#
		</div>
	</div>

	<!--============================Footer============================-->
	<div id="footer">
		<!--- cbadmin event --->
		#announceInterception("cbadmin_footer")#
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
			<img src="#prc.cbroot#/includes/images/ajax-loader-blue.gif" alt="loader" />
		</div>
	</div>
	<!--- ============================ end Confirmit ============================ --->

	<!--- ============================ QuickPost ============================ --->
	#runEvent(event="contentbox-admin:entries.quickPost",prePostExempt=true)#
	<!--- ============================ end QuickPost ============================ --->


	<!--- cbadmin Event --->
	#announceInterception("cbadmin_beforeBodyEnd")#
</body>
<!--End Body-->
</html>
</cfoutput>