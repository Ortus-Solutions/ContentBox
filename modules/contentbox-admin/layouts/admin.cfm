<cfoutput>
#html.doctype()#
<!--============================Head============================-->
<head>
	<meta charset="utf-8" />
	<!--- Robots --->
	<meta name="robots" content="noindex,nofollow" />
	<!--- SES --->
	<base href="#getSetting('htmlBaseURL')#" />
	<!--- Title --->
    <title>#prc.cbSettings.cb_site_name# - ContentBox Administrator</title>
	<!--- Favicon --->
	<link href="#prc.cbroot#/includes/images/favicon.ico" rel="shortcut icon" type="image/x-icon" />
	<!--- StyleSheets --->
	<link href="#prc.cbroot#/includes/css/style.css"			rel="stylesheet"/>
	<link href="#prc.cbroot#/includes/css/teal.css" 			rel="stylesheet"/>
	<link href="#prc.cbroot#/includes/css/sort.css"	 			rel="stylesheet"/>
	<link href="#prc.cbroot#/includes/css/font-awesome.min.css"	rel="stylesheet"/>
	<!--- loop around the cssAppendList, to add page specific css --->
	<cfloop list="#event.getValue("cssAppendList","")#" index="css">
		<cfset addAsset("#prc.cbroot#/includes/css/#css#.css")>
	</cfloop>
	<cfloop list="#event.getValue("cssFullAppendList","")#" index="css">
		<cfset addAsset("#css#.css")>
	</cfloop>
	<!--- JS --->
	<script src="#prc.cbroot#/includes/js/jquery.min.js"></script>
	<script src="#prc.cbroot#/includes/js/jquery.tools.min.js"></script>
	<script src="#prc.cbroot#/includes/js/metadata.pack.js"></script>
	<script src="#prc.cbroot#/includes/js/jquery.uitablefilter.js"></script>
	<script src="#prc.cbroot#/includes/js/jquery.uidivfilter.js"></script>
	<script src="#prc.cbroot#/includes/js/jquery.tablednd_0_5.js"></script>
	<script src="#prc.cbroot#/includes/js/tablesorter.min.js"></script>
	<script src="#prc.cbroot#/includes/js/contentbox.js"></script>
	<script src="#prc.cbroot#/includes/ckeditor/ckeditor.js"></script>
	<script src="#prc.cbroot#/includes/ckeditor/adapters/jquery.js"></script>
	<!--- loop around the jsAppendList, to add page specific js --->
	<cfloop list="#event.getValue("jsAppendList", "")#" index="js">
		<cfset addAsset("#prc.cbroot#/includes/js/#js#.js")>
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
					
					<!---Search --->
					<span id="div-search">
						<!---Search Results --->
						<span id="div-search-results">
							<span class="floatRight"><button class="buttonsmall" onclick="closeSearchBox()">close</button></span>
							<h2>Search Results</h2>
						</span>
						<!--- Inputs --->
						<i class="icon-search"></i> 
						<input type="hidden" value="#event.buildLink( prc.xehSearchGlobal )#" id="nav-search-url"/>
						<input type="text" placeholder="Global Search" name="nav-search" id="nav-search" autocomplete="off" size="15"/>
					</span>
					
					<!--- Admin Actions --->
					<cfif prc.oAuthor.checkPermission("RELOAD_MODULES")>
					<span id="adminActionBar">
						<span id="adminActionLoaderBar" style="display:none"><img src="#prc.cbRoot#/includes/images/ajax-loader-blue.gif" alt="loader"/></span>
						<span id="adminActionLoaderStatus"></span>
						<select name="adminActions" id="adminActions" onchange="adminAction(this.value, '#event.buildLink(prc.xehAdminAction)#')">
							<option value="null">Admin Actions</option>
							<option value="null">--------------</option>
							#html.options(values=prc.xehAdminActionData)#
						</select>
					</span>
					</cfif>
					<!--- Quick Links --->
					<span id="quickLinksBar">
					<select name="quickLinks" id="quickLinks" onchange="quickLinks(this.value)">
						<option value="null">Welcome #prc.oAuthor.getName()#</option>
						<option value="javascript:null">--------------</option>
						<cfif prc.oAuthor.checkPermission("PAGES_ADMIN") OR prc.oAuthor.checkPermission("PAGES_EDITOR")>
							<option value="#event.buildLink(prc.xehPagesEditor)#">Create New Page</option>
						</cfif>
						<cfif !prc.cbSettings.cb_site_disable_blog AND ( prc.oAuthor.checkPermission("ENTRIES_ADMIN") OR prc.oAuthor.checkPermission("ENTRIES_EDITOR") )>
							<option value="#event.buildLink(prc.xehBlogEditor)#">Create New Entry</option>
						</cfif>
						<cfif prc.oAuthor.checkPermission("AUTHOR_ADMIN")>
							<option value="#event.buildLink(prc.xehAuthorEditor)#">Create New Author</option>
						</cfif>
						<cfif prc.oAuthor.checkPermission("SYSTEM_SAVE_CONFIGURATION")>
						<option value="#event.buildLink(prc.xehSettings)#">ContentBox Settings</option>
						</cfif>
						<cfif prc.oAuthor.checkPermission("ENTRIES_ADMIN") AND !prc.cbSettings.cb_site_disable_blog>
							<option value="javascript:showQuickPost()">Quick Post</option>
						</cfif>
						<option value="javascript:null">--------------</option>
						<option value="#event.buildLink(linkto=prc.xehAuthorEditor,querystring="authorID="&prc.oAuthor.getAuthorID())#">My Profile</option>
						<option value="#event.buildLink(linkto=prc.xehDoLogout)#">Logout</option>
					</select>
					</span>
					<!--- cbadmin event --->
					#announceInterception("cbadmin_onTopBar")#
				</span>
			  	
			  	<!--- site tag line --->
				<i class="icon-desktop"></i> &nbsp;<a href="#event.buildLink(prc.cbEntryPoint)#" target="_blank" title="Open the site">#prc.cbSettings.cb_site_name#</a>
				
				<!--- cbadmin event --->
				#announceInterception("cbadmin_onTagline")#
			</div>
			<!--End Header top Area=-->
		
			<!--=========Header Area including search field and logo=========-->
			<div id="logo">
				<a href="#event.buildLink(prc.xehAbout)#">
					<img src="#prc.cbroot#/includes/images/ContentBox_90.png" border="0" alt="logo"/>
				</a>
			</div>
			<!--End Search field and logo Header Area-->
			<!--=========Main Navigation=========-->
			#prc.adminMenuService.generateMenu()#
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
		<a href="http://www.ortussolutions.com">Need Professional ColdFusion-ContentBox-ColdBox Support, Architecture, Design, or Development?</a>
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
</html>
</cfoutput>