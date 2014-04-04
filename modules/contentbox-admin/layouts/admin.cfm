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
			    #prc.cbroot#/includes/css/bootstrap-modal.css,
			    #prc.cbroot#/includes/css/bootstrap-datepicker.css,
          #prc.cbroot#/includes/css/bootstrap-fileupload.css,
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
			    #prc.cbroot#/includes/js/metadata.pack.js,
			    #prc.cbroot#/includes/js/jquery.uitablefilter.js,
			    #prc.cbroot#/includes/js/jquery.tablednd_0_5.js,
			    #prc.cbroot#/includes/js/tablesorter.min.js,
			    #prc.cbroot#/includes/js/bootstrap-modalmanager.js,
			    #prc.cbroot#/includes/js/bootstrap-modal.js,
			    #prc.cbroot#/includes/js/bootstrap-datepicker.js,
          #prc.cbroot#/includes/js/bootstrap-fileupload.js,
			    #prc.cbroot#/includes/js/jwerty.js,
			    #prc.cbroot#/includes/js/jquery.validate.js,
			    #prc.cbroot#/includes/js/jquery.validate.bootstrap.js,
			    #prc.cbroot#/includes/js/jquery.cookie.js,
			    #( len( prc.adminThemeService.getCurrentTheme().getJS() ) ? prc.adminThemeService.getCurrentTheme().getJS() & ',' : '')#
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
<body data-showsidebar="#lcase( yesNoFormat( prc.oAuthor.getPreference( "sidebarState", true ) ) )#">
	<!--- cbadmin Event --->
	#announceInterception("cbadmin_afterBodyStart")#
	<div id="wrapper">
		<!--- NavBar --->
		<div class="navbar navbar-fixed-top navbar-inverse" id="adminMenuTopNav">
		    <div class="navbar-inner">
		    	<div class="container">
		    		
					<!--- Responsive --->
					<a class="btn btn-navbar" data-toggle="collapse" data-target=".nav-collapse">
						<span class="icon-bar"></span>
						<span class="icon-bar"></span>
					</a>
					
					<!--- Logo --->
					<img src="#prc.cbroot#/includes/images/ContentBox_30.png" id="logo" title="ContentBox Modular CMS"/>
					
					<!--- Brand, future multi-site switcher --->
					<a class="brand" data-keybinding="ctrl+shift+d" title="ctrl+shift+D" href="#event.buildLink( prc.xehDashboard )#">
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
							<li title="Open Site" data-placement="left"><a href="#event.buildLink( prc.cbEntryPoint )#" target="_blank"><i class="icon-home icon-large"></i></a></li>
							
							<!--- New Quick Links --->
					    	<cfif prc.oAuthor.checkPermission( "PAGES_ADMIN,PAGES_EDITOR,ENTRIES_ADMIN,ENTRIES_EDITOR,AUTHOR_ADMIN,MEDIAMANAGER_ADMIN" )>
					    	<li class="dropdown" title="Create New..." data-placement="left">
					    		<a data-toggle="dropdown" class="dropdown-toggle" href="##"><i class="icon-plus icon-large"></i></a>
								<ul class="dropdown-menu">
									<cfif prc.oAuthor.checkPermission( "PAGES_ADMIN,PAGES_EDITOR" )>
										<li>
											<a data-keybinding="ctrl+shift+p" href="#event.buildLink( prc.xehPagesEditor )#" title="ctrl+shift+P">
												<i class="icon-file-alt"></i> New Page
											</a>
										</li>
									</cfif>
									<cfif !prc.cbSettings.cb_site_disable_blog AND prc.oAuthor.checkPermission( "ENTRIES_ADMIN,ENTRIES_EDITOR" )>
										<li>
											<a data-keybinding="ctrl+shift+b" href="#event.buildLink( prc.xehBlogEditor )#" title="ctrl+shift+B">
												<i class="icon-quote-left"></i> New Entry
											</a>
										</li>
									</cfif>
									<cfif prc.oAuthor.checkPermission( "AUTHOR_ADMIN" )>
										<li>
											<a data-keybinding="ctrl+shift+u" href="#event.buildLink( prc.xehAuthorEditor )#" title="ctrl+shift+U">
												<i class="icon-user"></i> New User
											</a>
										</li>
									</cfif>
									<cfif prc.oAuthor.checkPermission( "MEDIAMANAGER_ADMIN" )>
										<li>
											<a data-keybinding="ctrl+shift+m" href="#event.buildLink( prc.xehMediaManager )#" title="ctrl+shift+M">
												<i class="icon-th"></i> New Media
											</a>
										</li>
									</cfif>
									<cfif prc.oAuthor.checkPermission( "MENUS_ADMIN" )>
										<li>
											<a data-keybinding="ctrl+shift+m" href="#event.buildLink( prc.xehMenuManager )#" title="ctrl+shift+U">
												<i class="icon-list"></i> New Menu
											</a>
										</li>
									</cfif>
								</ul>
							</li>
							</cfif>
							
							<!---Quick Post --->
							<cfif prc.oAuthor.checkPermission( "ENTRIES_EDITOR" ) AND !prc.cbSettings.cb_site_disable_blog>
								<li title="Quick Post (ctrl+shift+Q)" data-placement="left"><a href="javascript:showQuickPost()" data-keybinding="ctrl+shift+Q"><i class="icon-edit icon-large"></i></a></li>
							</cfif>
							
							<!---Admin Actions --->
							<cfif prc.oAuthor.checkPermission( "RELOAD_MODULES" )>
							<li class="dropdown" title="Admin Actions" data-placement="left">
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
							<cfif prc.oAuthor.checkPermission("GLOBAL_SEARCH")>
							<span class="navbar-search pull-left" id="div-search" title="ctrl+shift+s" data-placement="right"/>
								<!---Search Results --->
								<span id="div-search-results"></span>
								<!---Search Inputs --->
								<input type="hidden" value="#event.buildLink( prc.xehSearchGlobal )#" id="nav-search-url">
								<input type="text" placeholder="Global Search" name="nav-search" id="nav-search" autocomplete="off" class="search-query"/>
							</span>
							</cfif>
							
							<!--- cbadmin event --->
							#announceInterception("cbadmin_onTopBar")#
				    	</ul>
						
						<!--- Right NavBar --->
						<ul class="nav pull-right" id="nav-header-menu">
							<li class="divider-vertical"></li>
							<!--- Header Generated Menu --->
							#prc.adminMenuService.generateHeaderMenu()#
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
		<div id="main-container" class="container-fluid clearfix">					
			<!--- cbadmin event --->
			#announceInterception("cbadmin_beforeContent")#
			<!--- Main Content --->
			#renderView()#
			<!--- cbadmin event --->
			#announceInterception("cbadmin_afterContent")#
		</div>

		<div class="push"></div>

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
	<div id="modal" class="modal hide fade">
	    <div class="modal-header">
	        <h3>Loading...</h3>
	    </div>
		<div id="remoteModelContent" class="modal-body">
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