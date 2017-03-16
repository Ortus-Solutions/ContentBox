﻿<cfoutput>
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
			data-showsidebar="#lcase( yesNoFormat( prc.oAuthor.getPreference( "sidebarState", true ) ) )#"
			data-preferenceURL="#event.buildLink( prc.xehSavePreference )#"
	>

		<!--- cbadmin Event --->
		#announceInterception( "cbadmin_afterBodyStart" )#

		<!--- ************************************************************************************************--->
		<!---                               MAIN CONTAINER					                                      --->
		<!--- ************************************************************************************************--->
		<section id="container" class="#prc.sideMenuClass#">

			<!--- ************************************************************************************************--->
			<!---                               TOP HEADER					                                      --->
			<!--- ************************************************************************************************--->
			<header id="header">

				<!--Branding-->
				<div class="brand text-center">
					<a data-keybinding="ctrl+shift+d"  href="#event.buildLink( prc.xehDashboard )#" class="logo" title="Dashboard ctrl+shift+d" data-placement="left auto">
						<img src="#prc.cbRoot#/includes/images/ContentBox_90.png"/>
					</a>
				</div>

				<!-- Toggle Navigation Button -->
				<div class="toggle-navigation toggle-left">
					<a onclick="null" class="btn btn-default options toggle" id="toggle-left" data-toggle="tooltip" data-placement="right" title="Toggle Navigation (ctrl+shift+n)" data-keybinding="ctrl+shift+n">
						<i class="fa fa-bars"></i>
					</a>
				</div>

				<!---Search --->
				<cfif prc.oAuthor.checkPermission( "GLOBAL_SEARCH" )>
				<span class="navbar-search hidden-xs" id="div-search" title="ctrl+shift+s or \" data-toggle="tooltip" data-placement="right"/>
					<!---Search Results --->
					<span id="div-search-results"></span>
					<!---Search Inputs --->
					<input type="hidden" value="#event.buildLink( prc.xehSearchGlobal )#" id="nav-search-url">
					<input type="text" placeholder="Global Search" name="nav-search" id="nav-search" autocomplete="off" class="search-query" size="30"/>
				</span>
				</cfif>

				<!-- User Nav -->
				<div class="user-nav">
					<ul>
						<!--- View Site --->
						<li class="" data-placement="right auto" title="Visit Site">
							<a class="btn btn-default options toggle" href="#event.buildLink( linkTo=prc.cbEntryPoint, ssl=prc.cbSettings.cb_site_ssl )#" target="_blank">
								<i class="fa fa-home"></i>
							</a>
						</li>
						<!--- New Quick Links --->
						<cfif prc.oAuthor.checkPermission( "PAGES_ADMIN,PAGES_EDITOR,ENTRIES_ADMIN,ENTRIES_EDITOR,AUTHOR_ADMIN,MEDIAMANAGER_ADMIN" )>
						<li class="dropdown settings" title="Create New..." data-name="create-new" data-placement="right auto">
							<button data-toggle="dropdown" class="dropdown-toggle btn btn-default options toggle" onclick="javascript:void( null )">
								<i class="fa fa-plus"></i>
							</button>
							<ul class="dropdown-menu">
								<cfif prc.oAuthor.checkPermission( "PAGES_ADMIN,PAGES_EDITOR" )>
									<li>
										<a data-keybinding="ctrl+shift+p" href="#event.buildLink( prc.xehPagesEditor )#" title="ctrl+shift+p">
											<i class="fa fa-file-o"></i> New Page
										</a>
									</li>
								</cfif>
								<cfif !prc.cbSettings.cb_site_disable_blog AND prc.oAuthor.checkPermission( "ENTRIES_ADMIN,ENTRIES_EDITOR" )>
									<li>
										<a data-keybinding="ctrl+shift+b" href="#event.buildLink( prc.xehBlogEditor )#" title="ctrl+shift+b">
											<i class="fa fa-quote-left"></i> New Entry
										</a>
									</li>
								</cfif>
								<cfif prc.oAuthor.checkPermission( "CONTENTSTORE_ADMIN,CONTENTSTORE_EDITOR" )>
									<li>
										<a data-keybinding="ctrl+shift+t" href="#event.buildLink( prc.xehContentStoreEditor )#" title="ctrl+shift+t">
											<i class="fa fa-hdd-o"></i> New Content Store
										</a>
									</li>
								</cfif>
								<cfif prc.oAuthor.checkPermission( "AUTHOR_ADMIN" )>
									<li>
										<a data-keybinding="ctrl+shift+a" href="#event.buildLink( prc.xehAuthorEditor )#" title="ctrl+shift+a">
											<i class="fa fa-user"></i> New User
										</a>
									</li>
								</cfif>
								<cfif prc.oAuthor.checkPermission( "MEDIAMANAGER_ADMIN" )>
									<li>
										<a data-keybinding="ctrl+shift+m" href="#event.buildLink( prc.xehMediaManager )#" title="ctrl+shift+m">
											<i class="fa fa-picture-o"></i> New Media
										</a>
									</li>
								</cfif>
								<cfif prc.oAuthor.checkPermission( "MENUS_ADMIN" )>
									<li>
										<a data-keybinding="ctrl+shift+v" href="#event.buildLink( prc.xehMenuManager )#" title="ctrl+shift+v">
											<i class="fa fa-list"></i> New Menu
										</a>
									</li>
								</cfif>
							</ul>
						</li>
						</cfif>
						
						<!--- Utils --->
						#prc.adminMenuService.generateUtilsMenu()#
						
						<!--- Support Menu --->
						<span class="hidden-xs hidden-sm">
							#prc.adminMenuService.generateSupportMenu()#
						</span>

						<!--- FullScreen --->
						<li class="hidden-xs hidden-sm" data-placement="right auto" title="Fullscreen">
							<a class="btn btn-default options toggle" href="javascript:void( 0 )" onclick="toggleFullScreen()">
								<i class="fa fa-arrows-alt"></i>
							</a>
						</li>
						
						<!--- Profile --->
						<li class="profile-photo hidden-xs">
							#getModel( "Avatar@cb" ).renderAvatar( email=prc.oAuthor.getEmail(), size="35", class="img-circle" )#
						</li>
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
				<h5 class="sidebar-header">#$r( "global.navigation@admin" )#</h5>
				<!--- Main Generated Menu --->
				#prc.adminMenuService.generateMenu()#
			</nav>
			
			<!--- ************************************************************************************************--->
			<!---                               MAIN CONTENT					                                  --->
			<!--- ************************************************************************************************--->
			<section class="main-content-wrapper" id="main-content-wrapper">
				<section id="main-content">
					<!--- cbadmin event --->
					#announceInterception( "cbadmin_beforeContent" )#
					
					<!--- Side Bar Trigger --->
					<div 	class="pull-right" 
							id="main-content-sidebar-trigger"
							style="display: none;"
					>
						<button type="button" 
								class="btn btn-primary btn-xs"
								title="Toggle Right Sidebar (ctrl+shift+e)"
								data-keybinding="ctrl+shift+e"
								onclick="toggleSidebar()"
						><i class="fa fa-minus-square-o"></i> Sidebar</button>
					</div>

					<!--- Main Content --->
					#renderView()#
					<!--- cbadmin event --->
					#announceInterception( "cbadmin_afterContent" )#
				</section>
			</section>

			<!--- ************************************************************************************************--->
			<!---                               FOOTER						                                      --->
			<!--- ************************************************************************************************--->
			#renderView( view="_tags/footer", module="contentbox-admin" )#
		</section>  

		<!--- ************************************************************************************************--->
		<!---                               RIGHT SIDEBAR                                         			  --->
		<!--- ************************************************************************************************--->
		<div class="sidebarRight">
			<div id="rightside-navigation">
				<div class="sidebar-heading"><i class="fa fa-bullhorn"></i> Notifications</div>
					<div class="sidebar-title">system</div>
					<div class="list-contacts">
						<cfif prc.oAuthor.checkPermission( "SYSTEM_TAB" ) AND prc.installerCheck.installer>
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
														<i class="fa fa-trash-o"></i> Delete Installer
													</a>
												</li>
											</ul>
										</span>
									</h4>
									<p>The installer module still exists! Please delete it from your server as leaving it online is a security risk.</p>
								</div>
							</div>
						</cfif>
						<cfif prc.oAuthor.checkPermission( "SYSTEM_TAB" ) AND prc.installerCheck.dsncreator>
							<div class="list-item">
								<div class="list-item-image">
									<i class="fa fa-warning img-circle"></i>
								</div>
								<div class="list-item-content">
									<h4>
										DSN Creator Module
										<span class="actions dropdown pull-right">
											<button class="fa fa-cog dropdown-toggle" data-toggle="dropdown"></button>
											<ul class="dropdown-menu dropdown-menu-right" role="menu">
												<li role="presentation">
													<a role="menuitem" href="javascript:void(0);" tabindex="-1" onclick="deleteDSNCreator()">
														<i class="fa fa-trash-o"></i> Delete DSN Creator
													</a>
												</li>
											</ul>
										</span>
									</h4>
									<p>The DSN creator module still exists! Please delete it from your server as leaving it online is a security risk.</p>
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
		<div id="confirmIt" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="confirmItTitle" aria-hidden="true">
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
							<button class="btn" data-dismiss="modal" aria-hidden="true"><i class="icon-remove"></i> Cancel</button>
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