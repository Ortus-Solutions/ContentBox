<cfoutput>
#html.doctype()#
<!--============================Head============================-->
<head>
	<!--- charset --->
	<meta charset="utf-8" />
	<!--- Responsive --->
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<!--- Robots --->
	<meta name="robots" content="noindex,nofollow" />
	<!--- SES --->
	<base href="#cb.siteBaseURL()#" />
	<!--- Title --->
    <title>#prc.cbSettings.cb_site_name# - ContentBox Administrator</title>
	<!--- Favicon --->
	<link href="#prc.cbroot#/includes/images/favicon.ico" rel="shortcut icon" type="image/x-icon" />
	<!--- StyleSheets --->
	#cb.minify(assets="#prc.cbroot#/includes/css/style.css,
			    #prc.cbroot#/includes/css/bootstrap.css,
			    #prc.cbroot#/includes/css/contentbox.css,
			    #prc.cbroot#/includes/css/bootstrap-responsive.css,
			    #prc.cbroot#/includes/css/font-awesome.min.css",			    
			   location="#prc.cbroot#/includes/cache")#
	<!--- loop around the cssAppendList, to add page specific css --->
	<cfloop list="#event.getValue("cssAppendList","")#" index="css">
		<cfset addAsset("#prc.cbroot#/includes/css/#css#.css")>
	</cfloop>
	<cfloop list="#event.getValue("cssFullAppendList","")#" index="css">
		<cfset addAsset("#css#.css")>
	</cfloop>
	<!--- JS --->
	#cb.minify(assets="#prc.cbroot#/includes/js/jquery.min.js,
			    #prc.cbroot#/includes/js/bootstrap.min.js,
			    #prc.cbroot#/includes/js/jquery.tools.min.js,
			    #prc.cbroot#/includes/js/metadata.pack.js,
			    #prc.cbroot#/includes/js/jquery.uitablefilter.js,
			    #prc.cbroot#/includes/js/jquery.uitablefilter.js,
			    #prc.cbroot#/includes/js/jquery.tablednd_0_5.js,
			    #prc.cbroot#/includes/js/tablesorter.min.js,
			    #prc.cbroot#/includes/js/contentbox.js",
			   location="#prc.cbroot#/includes/cache")#
	<!--- CKEditor Separate --->
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
	
	<!--- NavBar --->
	<div class="navbar navbar-fixed-top navbar-inverse" id="adminMenuTopNav">
	    <div class="navbar-inner">
	    	<div class="container">
	    		
				<!--- Responsive --->
				<a class="btn btn-navbar" data-toggle="collapse" data-target=".nav-collapse">
					<span class="icon-bar"></span>
					<span class="icon-bar"></span>
					<span class="icon-bar"></span>
				</a>
				
				<!--- Logo --->
				<img src="#prc.cbroot#/includes/images/ContentBox_30.png" id="logo" title="ContentBox Modular CMS"/>
				
				<!--- Brand, future multi-site switcher --->
				<a class="brand" href="#event.buildLink( prc.xehDashboard )#">
					#prc.cbSettings.cb_site_name#
				</a>
				
				<!--- cbadmin event --->
				#announceInterception("cbadmin_onTagline")#
		    	
				<!--- Main Menu bar --->
				<div class="nav-collapse collapse">
					<ul class="nav">
						<!--- Spacer --->
						<li class="divider-vertical"></li>
						
						<!--- View Site --->
						<li><a href="#event.buildLink( prc.cbEntryPoint )#" target="_blank"><i class="icon-home icon-large"></i></a></li>
						
						<!--- New Quick Links --->
				    	<li class="dropdown">
				    		<a data-toggle="dropdown" class="dropdown-toggle" href="##"><i class="icon-plus icon-large"></i></a>
							<ul class="dropdown-menu">
								<cfif prc.oAuthor.checkPermission("PAGES_ADMIN") OR prc.oAuthor.checkPermission("PAGES_EDITOR")>
									<li><a href="#event.buildLink( prc.xehPagesEditor )#"><i class="icon-file-alt"></i> New Page</a></li>
								</cfif>
								<cfif !prc.cbSettings.cb_site_disable_blog AND ( prc.oAuthor.checkPermission("ENTRIES_ADMIN") OR prc.oAuthor.checkPermission("ENTRIES_EDITOR") )>
									<li><a href="#event.buildLink( prc.xehBlogEditor )#"><i class="icon-quote-left"></i> New Entry</a></li>
								</cfif>
								<cfif prc.oAuthor.checkPermission("AUTHOR_ADMIN")>
									<li><a href="#event.buildLink( prc.xehAuthorEditor )#"><i class="icon-user"></i> New User</a></li>
								</cfif>
								<cfif prc.oAuthor.checkPermission("MEDIAMANAGER_ADMIN")>
									<li><a href="#event.buildLink( prc.xehMediaManager )#"><i class="icon-th"></i> New Media</a></li>
								</cfif>
							</ul>
						</li>
						
						<!---Quick Post --->
						<cfif prc.oAuthor.checkPermission("ENTRIES_EDITOR") AND !prc.cbSettings.cb_site_disable_blog>
							<li><a href="javascript:showQuickPost()"><i class="icon-edit icon-large"></i></a></li>
						</cfif>
						
						<!---Admin Actions --->
						<cfif prc.oAuthor.checkPermission("RELOAD_MODULES")>
						<li class="dropdown">
							<!---Loader Status --->
							<a data-toggle="dropdown" class="dropdown-toggle" href="##"><i id="adminActionsIcon" class="icon-cogs icon-large"></i></a>
							<ul class="dropdown-menu">
								<cfloop array="#prc.xehAdminActionData#" index="thisAction">
								<li><a href="javascript:adminAction( '#thisAction.value#', '#event.buildLink(prc.xehAdminAction)#')"><i class="icon-caret-right"></i>  #thisAction.name#</a></li>
								</cfloop>
							</ul>
						</li>
						</cfif>
						
						<!---Divider --->
						<li class="divider-vertical"></li>
						
						<!---Search --->
						<span class="navbar-search pull-left" id="div-search">
							<!---Search Results --->
							<span id="div-search-results"></span>
							<!---Search Inputs --->
							<input type="hidden" value="#event.buildLink( prc.xehSearchGlobal )#" id="nav-search-url"/>
							<input type="text" placeholder="Global Search" name="nav-search" id="nav-search" autocomplete="off" class="search-query"/>
						</span>
						
						<!--- cbadmin event --->
						#announceInterception("cbadmin_onTopBar")#
			    	</ul>
					
					<!--- Right NavBar --->
					<ul class="nav pull-right">
						<li class="divider-vertical"></li>
						<li class="dropdown">
							<a data-toggle="dropdown" class="dropdown-toggle" href="##"><i class="icon-info-sign"></i> About <b class="icon-caret-down"></b></a>
							<ul class="dropdown-menu">
								<li><a href="http://www.gocontentbox.org/services/support" target="_blank"><i class="icon-ambulance"></i> Professional Support</a></li>
								<li><a href="http://www.gocontentbox.org" target="_blank"><i class="icon-cloud"></i> ContentBox.org</a></li>
								<li><a href="http://www.gocontentbox.org/services/support" target="_blank"><i class="icon-book"></i> Documentation</a></li>
								<li><a href="https://groups.google.com/forum/?fromgroups##!forum/contentbox" target="_blank"><i class="icon-envelope"></i> Support Forums</a></li>
								<li class="divider"></li>
								<li><a href="https://www.twitter.com/gocontentbox" target="_blank"><i class="icon-twitter"></i> Twitter</a></li>
								<li><a href="https://www.facebook.com/gocontentbox" target="_blank"><i class="icon-facebook"></i> FaceBook</a></li>
								<li><a href="https://plus.google.com/u/0/111231811346031749369" target="_blank"><i class="icon-google-plus"></i> Google+</a></li>
								<li class="divider"></li>
								<li>
									<a href="#event.buildLink( prc.xehAutoUpdates )#"><i class="icon-download-alt"></i> Check For Updates</a>
									<a href="#event.buildLink( prc.xehAbout )#"><i class="icon-info-sign"></i> ContentBox v.#getModuleSettings('contentbox').version# <br>
									<span class="label label-warning">(Codename: #getModuleSettings("contentbox").settings.codename#)</span></a>
								</li>
							</ul>
						</li>
						<li class="dropdown">
							<a data-toggle="dropdown" class="dropdown-toggle" href="##"><i id="quickLinksIcon" class="icon-user"></i> #prc.oAuthor.getName()# <b class="icon-caret-down"></b></a>
							<ul class="dropdown-menu">
								<li><a href="#event.buildLink(linkto=prc.xehAuthorEditor,querystring="authorID="&prc.oAuthor.getAuthorID())#"><i class="icon-camera"></i> My Profile</a></li>
								<li><a href="#event.buildLink( prc.xehDoLogout )#"><i class="icon-off"></i> Logout</a></li>
							</ul>
						</li>
                    </ul>
				</div>
			</div> <!---end container --->
	    </div> <!--- end navbar-inner --->
    </div> <!---end navbar --->
		
	<!---Admin Notifier --->
	<span id="adminActionNotifier" class="alert hide"></span>
	<!--- Main Generated Menu --->
	#prc.adminMenuService.generateMenu()#
		
	<!---Container --->
	<div class="container-fluid clearfix">					
		<!--- cbadmin event --->
		#announceInterception("cbadmin_beforeContent")#
		<!--- Main Content --->
		#renderView()#
		<!--- cbadmin event --->
		#announceInterception("cbadmin_afterContent")#
	</div>
	
	<!--- Footer --->
	#renderView(view="_tags/footer", module="contentbox-admin")#
	
	<!--- ============================ confirm it modal dialog ============================ --->
	<div id="confirmIt" class="modal hide fade">
		<div class="modal-header">
			<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>	
			<h3 id="confirmItTitle">Are you sure?</h3>
		</div>
		
		<div class="modal-body">
			<p id="confirmItMessage">Are you sure you want to perform this action?</p>
		</div>
		
		<div class="modal-footer">
			<p class="text-center">
				<span id="confirmItLoader" class="hide"><i class="icon-spinner icon-spin icon-large icon-2x"></i></span>
				<span id="confirmItButtons">
					<button class="btn" data-dismiss="modal" aria-hidden="true"><i class="icon-remove"></i> Cancel</button>
					<button class="btn btn-danger" data-action="confirm"><i class="icon-check"></i>  Confirm </button>
				</span>
			</p>
		</div>
	</div>

	<!--- ============================ Remote Modal Window ============================ --->
	<div id="remoteModal">
		<div id="remoteModelContent">
			<i class="icon-spinner icon-spin icon-large icon-4x"></i>
		</div>
	</div>

	<!--- ============================ QuickPost ============================ --->
	#runEvent(event="contentbox-admin:entries.quickPost",prePostExempt=true)#
	
	<!--- cbadmin Event --->
	#announceInterception("cbadmin_beforeBodyEnd")#
</body>
</html>
</cfoutput>