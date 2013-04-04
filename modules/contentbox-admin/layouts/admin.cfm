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
					<span id="div-search" class="navbarSlot">
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
					
					<!--- Quick Post --->
					<cfif prc.oAuthor.checkPermission("ENTRIES_ADMIN") AND !prc.cbSettings.cb_site_disable_blog>
					<span class="navbarSlot">
						<a href="javascript:showQuickPost()" title="Quick Post"><i class="icon-edit"></i></a>
					</span>
					</cfif>
					
					<!--- Admin Actions --->
					<cfif prc.oAuthor.checkPermission("RELOAD_MODULES")>
					<span class="navbarSlot">
						<!---Loader Status --->
						<span id="adminActionLoaderStatus"></span>
						<!---Icon --->	
						<a href="javascript:null" title="Admin Actions" id="adminActionsButton"><i id="adminActionsIcon" class="icon-cog"></i></a>
						<!---Actions Panel --->
						<div id="adminActionsPanel" class="navbarPanels" style="display:none;">
							<p class="label label-info">Admin Actions</p>
							<ul>
								<cfloop array="#prc.xehAdminActionData#" index="thisAction">
								<li><i class="icon-caret-right"></i> <a href="javascript:adminAction( '#thisAction.value#', '#event.buildLink(prc.xehAdminAction)#')">#thisAction.name#</a></li>
								</cfloop>
							</ul>
						</div>
					</span>
					</cfif>
					
					<!--- Quick Links --->
					<span class="navbarSlot">
						<!--- User Icon --->
						<a href="javascript:null" id="quickLinksButton"><i id="quickLinksIcon" class="icon-user"></i> #prc.oAuthor.getName()#</a>
						<!--- Quick Links --->
						<div id="quickLinksPanel" class="navbarPanels" style="display:none;">
							<p class="label label-info">Quick Links</p>
							
							<ul>
							<cfif prc.oAuthor.checkPermission("PAGES_ADMIN") OR prc.oAuthor.checkPermission("PAGES_EDITOR")>
								<li><i class="icon-file-alt"></i> <a href="#event.buildLink( prc.xehPagesEditor )#">Create New Page</a></li>
							</cfif>
							</ul>
							<cfif !prc.cbSettings.cb_site_disable_blog AND ( prc.oAuthor.checkPermission("ENTRIES_ADMIN") OR prc.oAuthor.checkPermission("ENTRIES_EDITOR") )>
								<li><i class="icon-quote-left"></i> <a href="#event.buildLink( prc.xehBlogEditor )#">Create New Entry</a></li>
							</cfif>
							<cfif prc.oAuthor.checkPermission("AUTHOR_ADMIN")>
								<li><i class="icon-group"></i> <a href="#event.buildLink( prc.xehAuthorEditor )#">Create New User</a></li>
							</cfif>
							<cfif prc.oAuthor.checkPermission("SYSTEM_SAVE_CONFIGURATION")>
								<li><i class="icon-wrench"></i> <a href="#event.buildLink( prc.xehSettings )#">ContentBox Settings</a></li>
							</cfif>
							
							<li><i class="icon-camera"></i> <a href="#event.buildLink(linkto=prc.xehAuthorEditor,querystring="authorID="&prc.oAuthor.getAuthorID())#">My Profile</a></li>
							<li><i class="icon-off"></i> <a href="#event.buildLink( prc.xehDoLogout )#">Logout</a></li>
						</div>
					</span>
					
					<!--- cbadmin event --->
					#announceInterception("cbadmin_onTopBar")#
				</span>
			  	
			  	<!--- site tag line --->
				<span class="navbarSlot">
					<i class="icon-desktop icon-large"></i> 
					&nbsp;<a href="#event.buildLink(prc.cbEntryPoint)#" target="_blank" title="Open the site">#prc.cbSettings.cb_site_name#</a>
				</span>
				
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