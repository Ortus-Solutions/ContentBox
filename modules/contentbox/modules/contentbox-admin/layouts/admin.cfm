<cfoutput>
<!DOCTYPE html>
<!--[if lt IE 7]>      <html class="no-js lt-ie9 lt-ie8 lt-ie7"> <![endif]-->
<!--[if IE 7]>         <html class="no-js lt-ie9 lt-ie8"> <![endif]-->
<!--[if IE 8]>         <html class="no-js lt-ie9"> <![endif]-->
<!--[if gt IE 8]><!-->
<html class="no-js">
<!--<![endif]-->
	<!--- ************************************************************************************************--->
	<!---                               TOP ASSETS					                                      --->
	<!--- ************************************************************************************************--->
	<cfinclude template="inc/HTMLHead.cfm"/>

	<!--- ************************************************************************************************--->
	<!---                               BODY START					                                      --->
	<!--- ************************************************************************************************--->
	<body 	class="off-canvas"
			data-showsidebar="#lcase( yesNoFormat( prc.oCurrentAuthor.getPreference( "sidebarState", true ) ) )#"
			data-preferenceURL="#event.buildLink( prc.xehSavePreference )#"
	>

		<!--- cbadmin Event --->
		#announce( "cbadmin_afterBodyStart" )#

		<!--- ************************************************************************************************--->
		<!---                               MAIN CONTAINER					                                      --->
		<!--- ************************************************************************************************--->
		<div id="container" class="#prc.sideMenuClass# layout-wrapper">

			<!--- ************************************************************************************************--->
			<!---                               TOP HEADER					                                      --->
			<!--- ************************************************************************************************--->
			<header id="header" class="header-default">
				<div>
					<!--Branding-->
					<div class="brand">
						<a
							data-keybinding="ctrl+shift+d"
							href="#event.buildLink( prc.xehDashboard )#"
							class="logo"
							title="Dashboard ctrl+shift+d"
							data-placement="left auto"
						>
							<svg id="cbLogo" data-name="CB Logo" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 355.25 60" aria-labelledby="cbLogoTitle">
								<title id="cbLogoTitle">ContentBox</title>
								<g id="cbLogoText" class="cb-logo-text">
									<g>
										<path class="cb-text-content" d="m88.63,20.57c-2.5,0-4.29.79-5.39,2.38-1.1,1.59-1.65,4.19-1.65,7.82,0,3.15.53,5.36,1.58,6.65s2.87,1.93,5.46,1.93h9.9v4.99h-10.2c-2.25,0-4.02-.19-5.3-.58-1.29-.38-2.5-1.03-3.63-1.94-1.47-1.17-2.57-2.69-3.3-4.57-.73-1.88-1.1-4.12-1.1-6.74,0-5.07,1.1-8.81,3.29-11.22,2.2-2.41,5.6-3.62,10.21-3.62h10.02v4.89h-9.9Z"/>
										<path class="cb-text-content" d="m101.1,29.71c0-4.92,1.18-8.59,3.54-10.99,2.36-2.4,5.94-3.61,10.76-3.61s8.45,1.22,10.78,3.65c2.33,2.43,3.5,6.18,3.5,11.25s-1.17,8.82-3.5,11.27c-2.33,2.44-5.93,3.66-10.78,3.66s-8.52-1.23-10.83-3.68c-2.31-2.46-3.47-6.3-3.47-11.54Zm14.3-9.69c-2.58,0-4.51.81-5.79,2.42-1.28,1.61-1.92,4.05-1.92,7.31,0,3.53.62,6.12,1.86,7.77,1.24,1.64,3.19,2.47,5.85,2.47s4.57-.82,5.83-2.45c1.27-1.63,1.9-4.14,1.9-7.53s-.63-5.92-1.9-7.54c-1.27-1.62-3.21-2.44-5.83-2.44Z"/>
										<path class="cb-text-content" d="m133.81,15.67h7.62l11.74,20.58-.29-20.58h6.16v28.66h-7l-12.32-21.68.27,21.68h-6.18V15.67Z"/>
										<path class="cb-text-content" d="m171.12,20.7h-9.26v-4.99h24.8v4.99h-9.3v23.63h-6.24v-23.63Z"/>
										<path class="cb-text-content" d="m201.39,20.66c-2.18,0-3.83.55-4.94,1.64s-1.72,2.76-1.84,5.01l16.67.02v4.99h-16.71c.01,2.5.54,4.29,1.59,5.38s2.79,1.64,5.23,1.64h9.89v4.99h-10.18c-2.25,0-4.01-.19-5.3-.58-1.29-.38-2.49-1.03-3.62-1.94-1.47-1.17-2.57-2.69-3.3-4.57-.73-1.88-1.1-4.12-1.1-6.74,0-5.07,1.1-8.81,3.29-11.22,2.19-2.41,5.6-3.62,10.21-3.62h10.01v4.99h-9.89Z"/>
										<path class="cb-text-content" d="m216.56,15.67h7.62l11.74,20.58-.29-20.58h6.16v28.66h-7l-12.32-21.68.27,21.68h-6.18V15.67Z"/>
										<path class="cb-text-content" d="m253.87,20.7h-9.26v-4.99h24.8v4.99h-9.3v23.63h-6.24v-23.63Z"/>
									</g>
									<g>
										<path class="cb-text-box" d="m287.51,44.33h-15.77V15.67h14.72c1.86,0,3.37.1,4.53.31,1.16.21,2.1.54,2.82.99,1.05.66,1.85,1.52,2.41,2.57.55,1.05.83,2.25.83,3.59,0,1.6-.34,2.95-1.03,4.06-.69,1.11-1.77,2.04-3.24,2.8,1.48.62,2.58,1.47,3.28,2.52.71,1.06,1.06,2.39,1.06,3.99,0,2.68-.78,4.65-2.34,5.92-1.56,1.27-3.98,1.9-7.27,1.9Zm-9.75-23.51v6.63h8.81c1.36,0,2.37-.27,3-.81.64-.54.96-1.37.96-2.5s-.32-1.98-.96-2.51c-.64-.53-1.64-.8-3-.8h-8.81Zm8.91,18.44c1.38,0,2.38-.27,3-.81.62-.54.94-1.39.94-2.54s-.32-2.03-.95-2.57c-.63-.55-1.63-.82-2.99-.82h-8.91v6.74h8.91Z"/>
										<path class="cb-text-box" d="m300.02,29.71c0-4.92,1.18-8.59,3.54-10.99,2.36-2.4,5.94-3.61,10.76-3.61s8.45,1.22,10.78,3.65c2.33,2.43,3.5,6.18,3.5,11.25s-1.17,8.82-3.5,11.27c-2.33,2.44-5.93,3.66-10.78,3.66s-8.52-1.23-10.83-3.68c-2.31-2.46-3.47-6.3-3.47-11.54Zm14.3-9.69c-2.58,0-4.51.81-5.79,2.42-1.28,1.61-1.92,4.05-1.92,7.31,0,3.53.62,6.12,1.86,7.77,1.24,1.64,3.19,2.47,5.85,2.47s4.57-.82,5.83-2.45c1.27-1.63,1.9-4.14,1.9-7.53s-.63-5.92-1.9-7.54c-1.27-1.62-3.21-2.44-5.83-2.44Z"/>
										<path class="cb-text-box" d="m338.48,30l-9.69-14.33h7.06l5.91,9.04,5.87-9.04h6.96l-9.22,13.92,9.88,14.74h-7.21l-6.02-9.98-6.39,9.98h-7.15l10.02-14.33Z"/>
									</g>
								</g>
								<g id="cbLogoIcon" class="cb-logo-icon">
									<rect class="cb-icon-bg" width="60" height="60" rx="5.43" ry="5.43"/>
									<g>
										<path class="cb-swirl" d="m43.2,17.87c-4.31-3.47-14.24-5.79-21.72,1.73-8.16,10.14-4.56,25.31,10.9,26.83,8.54-.25,12.72-3.85,12.72-3.85.89-.17-11.2,11.37-26.07,2.41-6.89-4.99-8.7-12.55-7.52-18.63,1.23-6,5.62-10.82,8.11-12.3,11.11-6.8,21.68.46,23.58,3.8Z"/>
										<path class="cb-swirl" d="m38.39,17.11s6.55,1.99,7.22,11.66c.72,9.72-10.52,14.62-17.15,12.29-6.42-1.77-9.68-10.31-8.96-15.55-.59.93-1.52,8.41,1.39,13.1,3.72,6,16.31,10.69,24.8.89,6.21-7.73,1.18-17.41-.21-18.25-.63-1.31-4.94-3.89-7.1-4.14Z"/>
										<path class="cb-swirl" d="m22.54,24.33s6.89-7.39,14.2-1.56c6.72,6.34,1.61,14.24-1.18,15.25-2.32,1.69-7.44,1.65-7.44,1.65,1.61.68,11.32,1.9,14.24-7.23,2.28-8.79-5.45-13.9-9.76-13.99-5.87-.04-8.79,3-10.06,5.87Z"/>
									</g>
								</g>
							</svg>
						</a>
					</div>

					<!-- Site Switcher -->
					<span
						class="form-inline ml10 mt10"
						id="div-siteswitcher"
						data-toggle="tooltip"
						data-placement="right"
						title="Site Switcher"
					>
						<i class="fa fa-chevron-down cb-select-arrow"></i>
						<select
							name="siteSwitcher"
							id="siteSwitcher"
							class="form-control input-sm rounded-sm appearance-none"
							onChange="to( '#event.buildLink( prc.xehChangeSite )#/siteID/' + this.value )"
							style="width: 175px;"
						>
							<cfloop array="#prc.allSites#" index="thisSite">
								<option
									value="#thisSite[ 'siteID' ]#"
									<cfif thisSite[ 'siteID' ] eq prc.oCurrentSite.getsiteID()>selected="selected"</cfif>
								>
									#thisSite[ 'name' ]#
								</option>
							</cfloop>
						</select>
					</span>

					<!---Search --->
					<cfif prc.oCurrentAuthor.hasPermission( "GLOBAL_SEARCH" )>
					<span
						class="navbar-search mt10 hidden-sm hidden-xs"
						id="div-search"
						title="Press 'Ctrl + Shift + S' to focus"
						data-toggle="tooltip"
						data-placement="left"
					>
						<!---Search Results --->
						<span id="div-search-results"></span>
						<!---Search Inputs --->
						<input
							type="hidden"
							value="#event.buildLink( prc.xehSearchGlobal )#"
							id="nav-search-url">
						<input
							type="text"
							placeholder="Global Search"
							name="nav-search"
							id="nav-search"
							autocomplete="off"
							class="search-query"
							size="20" />
					</span>
					</cfif>
				</div>

				<!-- User Nav -->
				<div class="user-nav">
					<ul>
						<!--- View Site --->
						<li data-placement="right auto" title="Visit Site">
							<a
								class="btn options toggle btn-more"
								href="#prc.cbHelper.siteRoot()#"
								target="_blank"
							>
								<i class="fa fa-home"></i>
							</a>
						</li>

						<!--- New Quick Links --->
						<cfif prc.oCurrentAuthor.hasPermission( "PAGES_ADMIN,PAGES_EDITOR,ENTRIES_ADMIN,ENTRIES_EDITOR,AUTHOR_ADMIN,MEDIAMANAGER_ADMIN" )>
							<li class="dropdown settings" title="Create New..." data-name="create-new" data-placement="right auto">
								<button
									data-toggle="dropdown"
									class="dropdown-toggle btn btn-more options toggle"
									onclick="javascript:void( null )"
								>
									<i class="fa fa-plus"></i>
								</button>
								<ul class="dropdown-menu">
									<cfif prc.oCurrentAuthor.hasPermission( "PAGES_ADMIN,PAGES_EDITOR" )>
										<li>
											<a data-keybinding="ctrl+shift+p" href="#event.buildLink( prc.xehPagesEditor )#" title="ctrl+shift+p">
												<i class="fa fa-file-alt fa-lg width25"></i> New Page
											</a>
										</li>
									</cfif>
									<cfif prc.oCurrentSite.getIsBlogEnabled() AND prc.oCurrentAuthor.hasPermission( "ENTRIES_ADMIN,ENTRIES_EDITOR" )>
										<li>
											<a data-keybinding="ctrl+shift+b" href="#event.buildLink( prc.xehEntriesEditor )#" title="ctrl+shift+b">
												<i class="fa fa-blog fa-lg width25"></i> New Entry
											</a>
										</li>
									</cfif>
									<cfif prc.oCurrentAuthor.hasPermission( "CONTENTSTORE_ADMIN,CONTENTSTORE_EDITOR" )>
										<li>
											<a data-keybinding="ctrl+shift+t" href="#event.buildLink( prc.xehContentStoreEditor )#" title="ctrl+shift+t">
												<i class="fa fa-hdd fa-lg width25"></i> New Content Store
											</a>
										</li>
									</cfif>
									<cfif prc.oCurrentAuthor.hasPermission( "AUTHOR_ADMIN" )>
										<li>
											<a data-keybinding="ctrl+shift+a" href="#event.buildLink( prc.xehAuthorNew )#" title="ctrl+shift+a">
												<i class="fa fa-user fa-lg width25"></i> New User
											</a>
										</li>
									</cfif>
									<cfif prc.oCurrentAuthor.hasPermission( "MEDIAMANAGER_ADMIN" )>
										<li>
											<a data-keybinding="ctrl+shift+m" href="#event.buildLink( prc.xehMediaManager )#" title="ctrl+shift+m">
												<i class="fa fa-photo-video fa-lg width25"></i> New Media
											</a>
										</li>
									</cfif>
									<cfif prc.oCurrentAuthor.hasPermission( "MENUS_ADMIN" )>
										<li>
											<a data-keybinding="ctrl+shift+v" href="#event.buildLink( prc.xehMenuManager )#" title="ctrl+shift+v">
												<i class="fa fa-list fa-lg width25"></i> New Menu
											</a>
										</li>
									</cfif>
								</ul>
							</li>
						</cfif>

						<!--- Utils --->
						#prc.adminMenuService.generateUtilsMenu()#

						<!--- Profile --->
						#prc.adminMenuService.generateProfileMenu()#

						<!--- Notifications :
						TODO: Enable once done
						<li class="dropdown messages">
							<span class="badge badge-danager animated bounceIn" id="new-messages">5</span>
							<div class="toggle-navigation toggle-right">
								<button type="button" class="btn btn-default" id="toggle-right">
									<i class="fa fa-bullhorn"></i>
								</button>
							</div>
						</li>
						--->
					</ul>
				</div>
				
			</header>

			<!--- ************************************************************************************************--->
			<!---                               MAIN NAVBAR					                                      --->
			<!--- ************************************************************************************************--->
			<nav class="sidebar sidebar-left" id="main-navbar">
				<!-- Toggle Navigation Button -->
				<button
					class="btn options toggle sidebar-left-toggle"
					id="toggle-left"
					data-toggle="tooltip"
					data-placement="right"
					title="Toggle Navigation (ctrl+shift+n)"
					data-keybinding="ctrl+shift+n"
				>
					#cbAdminComponent( "ui/Icon", { name : "Bars3" } )#
				</button>
				<!--- Main Generated Menu --->
				#prc.adminMenuService.generateMenu()#
			</nav>

			<!--- ************************************************************************************************--->
			<!---                               MAIN CONTENT					                                  --->
			<!--- ************************************************************************************************--->
			<main class="main-content-wrapper" id="main-content-wrapper">
				<section id="main-content">
					<!--- cbadmin event --->
					#announce( "cbadmin_beforeContent" )#

					<!--- Side Bar Trigger --->
					<div
						class="pull-right"
						id="main-content-sidebar-trigger"
						style="display: none;"
					>
						<button type="button"
								class="btn btn-primary btn-sm"
								title="Toggle Right Sidebar (ctrl+shift+e)"
								data-keybinding="ctrl+shift+e"
								onclick="toggleSidebar()"
							>
							<i class="fa fa-minus-square"></i> Sidebar
						</button>
					</div>

					<!--- Main Content --->
					#view()#
					<!--- cbadmin event --->
					#announce( "cbadmin_afterContent" )#
				</section>
			</main>

			<!--- ************************************************************************************************--->
			<!---                               FOOTER						                                      --->
			<!--- ************************************************************************************************--->
			#view( view="_tags/footer", module="contentbox-admin" )#
		</div>

		<!--- ************************************************************************************************--->
		<!---                               RIGHT SIDEBAR                                         			  --->
		<!--- ************************************************************************************************--->
		<div class="sidebarRight">
			<div id="rightside-navigation">
				<div class="sidebar-heading"><i class="fa fa-bullhorn"></i> Notifications</div>
					<div class="sidebar-title">system</div>
					<div class="list-contacts">
						<cfif prc.oCurrentAuthor.hasPermission( "SYSTEM_TAB" ) AND prc.installerCheck>
							<div class="list-item">
								<div class="list-item-image">
									<i class="fa fa-warning img-circle"></i>
								</div>
								<div class="list-item-content">
									<h4>
										Installer Module
										<span class="actions dropdown pull-right">
											<button class="fa fa-cog dropdown-toggle" data-toggle="dropdown"></button>
											<ul class="dropdown-menu dropdown-menu-right" role="menu">
												<li role="presentation">
													<a role="menuitem" href="javascript:void(0);" tabindex="-1" onclick="deleteInstaller()">
														<i class="fa fa-trash"></i> Delete Installer
													</a>
												</li>
											</ul>
										</span>
									</h4>
									<p>The installer module still exists! Please delete it from your server as leaving it online is a security risk.</p>
								</div>
							</div>
						</cfif>
					</div>
				</div>
			</div>
		</div>
		<!--sidebar right end-->

		<!--- ************************************************************************************************--->
		<!---                               CONFIRM IT MODAL TEMPLATE                                         --->
		<!--- ************************************************************************************************--->
		<div
			id="confirmIt"
			class="modal fade"
			tabindex="-1"
			role="dialog"
			aria-labelledby="confirmItTitle"
			aria-hidden="true"
		>
			<div class="modal-dialog" role="document">
				<div class="modal-content">
					<!--header-->
					<div class="modal-header">
						<!--if dismissable-->
						<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
						<h4 class="modal-title" id="confirmItTitle">Are you sure?</h4>
					</div>

					<!--body-->
					<div class="modal-body">
						<p id="confirmItMessage">Are you sure you want to perform this action?</p>
					</div>

					<!-- footer -->
					<div class="modal-footer">
						<span id="confirmItLoader" style="display:none"><i class="fa fa-spinner fa-spin fa-2x"></i></span>
						<span id="confirmItButtons">
							<button class="btn btn-default" data-dismiss="modal" aria-hidden="true"><i class="icon-remove"></i> Cancel</button>
							<button class="btn btn-danger" data-action="confirm"><i class="icon-check"></i>  Confirm </button>
						</span>
					</div>
				</div> <!--- end modal-content --->
			</div> <!--- end modal-dialog --->
		</div>

		<!--- ************************************************************************************************--->
		<!---                               REMOTE MODAL TEMPLATE                                             --->
		<!--- ************************************************************************************************--->
		<div class="modal fade" tabindex="-1" role="dialog" aria-labelledby="remoteModal" aria-hidden="true" id="modal">
			 <div class="modal-dialog modal-lg" role="document" >
				<div class="modal-content">
					<div class="modal-header">
						<h3>Loading...</h3>
					</div>
					<div class="modal-body" id="remoteModelContent">
						<i class="fa fa-spinner fa fa-spin fa-lg icon-4x"></i>
					</div>
				</div>
			</div>
		</div>

		<!--- ************************************************************************************************--->
		<!---                               BODY END VIEW                                                     --->
		<!--- ************************************************************************************************--->
		<cfinclude template="inc/HTMLBodyEnd.cfm"/>

	</body>
</html>
</cfoutput>
