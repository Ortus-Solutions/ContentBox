<cfoutput>
<div class="row">
    <div class="col-md-12">
        <h1 class="h1">
        	<i class="fa fa-tv"></i> #prc.cbSettings.cb_dashboard_welcome_title#
        </h1>
    </div>
</div>

<div class="row">
    <div class="col-md-8">
    	<!--- Dashboard welcome body --->
		<p class="lead">#prc.welcomeBody#</p>

		<!--- Messagebox --->
		#cbMessageBox().renderit()#

		<!--- Event --->
		#announce( "cbadmin_preDashboardContent" )#

		<!--- Installer Checks --->
		<cfif prc.oCurrentAuthor.hasPermission( "SYSTEM_TAB" ) and prc.installerCheck>
			<div class="alert alert-danger" id="installerCheck">
				<button
					type="button"
					class="close"
					data-dismiss="alert"
					aria-hidden="true"
					>
					&times;
				</button>
				<i class="fa fa-exclamation-triangle fa-2x"></i>
				#$r( "dashboard.index.installer.notice@admin" )#
				<button
					class="btn btn-danger btn-sm"
					onclick="deleteInstaller()"
				>
					#$r( "dashboard.index.installer.delete@admin" )#
				</button>
			</div>
		</cfif>

		<div class="panel">
			<div class="panel-body">
				<div class="tabs">
					<ul class="nav nav-tabs" id="dashboardTabs">
						<cfif prc.oCurrentAuthor.hasPermission( "ENTRIES_ADMIN,ENTRIES_EDITOR,PAGES_ADMIN,PAGES_EDITOR,CONTENTSTORE_ADMIN,CONTENTSTORE_EDITOR" )>
							<li class="nav-item">
								<a href="##contentReports" data-toggle="tab" class="nav-link">
									<i class="fa fa-archive"></i> <span class="hidden-xs">#$r( "dashboard.index.nav-tabs.head1@admin" )#</span>
								</a>
							</li>
						</cfif>
						<cfif prc.oCurrentAuthor.hasPermission( "COMMENTS_ADMIN" )>
							<li class="nav-item">
								<a href="##latestComments" data-toggle="tab" class="nav-link">
									<i class="fa fa-comments"></i> <span class="hidden-xs">#$r( "dashboard.index.nav-tabs.head2@admin" )#</span>
								</a>
							</li>
						</cfif>
						<li class="nav-item">
							<a href="##latestNews" data-toggle="tab" class="nav-link">
								<i class="fa fa-rss"></i> <span class="hidden-xs">#$r( "dashboard.index.nav-tabs.head3@admin" )#</span>
							</a>
						</li>
						<!--- cbadmin Event --->
						#announce( "cbadmin_onDashboardTabNav" )#
					</ul>
					<div class="tab-content">
						<!--- cbadmin Event --->
						#announce( "cbadmin_preDashboardTabContent" )#
						<!--- ****************************************************************************************** --->
						<!--- LATEST SYSTEM EDITS + LATEST MY DRAFTS --->
						<!--- ****************************************************************************************** --->
						<cfif prc.oCurrentAuthor.hasPermission( "ENTRIES_ADMIN,ENTRIES_EDITOR,PAGES_ADMIN,PAGES_EDITOR,CONTENTSTORE_ADMIN,CONTENTSTORE_EDITOR" )>
							<div class="tab-pane" id="contentReports">
								<div class="m5" id="latestSystemEdits">
									<div class="panel panel-primary">
										<div class="panel-heading">
											<h3 class="panel-title">
												<i class="fa fa-history"></i> Latest Edits
											</h3>
										</div>
										<div class="panel-body text-center">
											<i class="fa fa-spin fa-circle-o-notch fa-lg fa-2x text-muted"></i>
										</div>
									</div>
								</div>
								<div class="m5" id="futurePublished">
									<div class="panel panel-primary">
										<div class="panel-heading">
											<h3 class="panel-title">
												<i class="fa fa-space-shuttle"></i> Future Published Content
											</h3>
										</div>
										<div class="panel-body text-center">
											<i class="fa fa-spin fa-circle-o-notch fa-lg fa-2x text-muted"></i>
										</div>
									</div>
								</div>
								<div class="m5" id="expiredContent">
									<div class="panel panel-primary">
										<div class="panel-heading">
											<h3 class="panel-title">
												<i class="fa fa-file-archive" aria-hidden="true"></i> Expired Content
											</h3>
										</div>
										<div class="panel-body text-center">
											<i class="fa fa-spin fa-circle-o-notch fa-lg fa-2x text-muted"></i>
										</div>
									</div>
								</div>
								<div class="m5" id="latestUserDrafts">
									<div class="panel panel-primary">
										<div class="panel-heading">
											<h3 class="panel-title">
												<i class="fa fa-pencil-ruler"></i> My Latest Drafts
											</h3>
										</div>
										<div class="panel-body text-center">
											<i class="fa fa-spin fa-circle-o-notch fa-lg fa-2x text-muted"></i>
										</div>
									</div>
								</div>
							</div>
						</cfif>
						<!--- ****************************************************************************************** --->
						<!--- LATEST COMMENTS --->
						<!--- ****************************************************************************************** --->
						<cfif prc.oCurrentAuthor.hasPermission( "COMMENTS_ADMIN" )>
							<div class="tab-pane" id="latestComments">
								<i class="fa fa-spin fa-circle-o-notch fa-lg fa-2x text-muted"></i>
							</div>
						</cfif>
						<!--- ****************************************************************************************** --->
						<!--- LATEST NEWS TAB --->
						<!--- ****************************************************************************************** --->
						<div class="tab-pane" id="latestNews">
							<i class="fa fa-spin fa-circle-o-notch fa-lg fa-2x text-muted"></i>
						</div>
						<!--- cbadmin Event --->
						#announce( "cbadmin_postDashboardTabContent" )#
					</div>
				</div>
			</div>
		</div>

		<!--- Event --->
		#announce( "cbadmin_postDashboardContent" )#
    </div>
    <div class="col-md-4">
        <!--- Event --->
		#announce( "cbadmin_preDashboardSideBar" )#

		<!---Latest Snapshot --->
		<cfif prc.oCurrentAuthor.hasPermission( "ENTRIES_ADMIN,ENTRIES_EDITOR,PAGES_ADMIN,PAGES_EDITOR,CONTENTSTORE_ADMIN,CONTENTSTORE_EDITOR,COMMENTS_ADMIN" )>
			<div id="latestSnapshot">
				<div class="panel panel-primary">
					<div class="panel-heading">
						<h3 class="panel-title">
							<i class="fa fa-flag-checkered fa-lg"></i> Data Snapshots
						</h3>
					</div>
					<div class="panel-body text-center">
						<i class="fa fa-spin fa-circle-o-notch fa-lg fa-2x text-muted"></i>
					</div>
				</div>
			</div>
		</cfif>

		<!--- Latest Logins --->
		<cfif prc.oCurrentAuthor.hasPermission( "SYSTEM_AUTH_LOGS" )>
			<div class="panel panel-primary">
			    <div class="panel-heading">
					<h3 class="panel-title">
						<i class="fa fa-users fa-lg"></i> #$r( "dashboard.index.latestLogins@admin" )#
					</h3>
			    </div>
			    <div class="panel-body">
					<div id="latestLogins">
						<div class="text-center">
							<i class="fa fa-spin fa-circle-o-notch fa-lg fa-2x text-muted"></i>
						</div>
					</div>
			    </div>
			</div>
		</cfif>

		<!--- Info Box --->
		<div class="panel panel-primary">
		    <div class="panel-heading">
				<h3 class="panel-title">
					<i class="fa fa-medrt fa-lg"></i> #$r( "dashboard.index.needHelp@admin" )#
				</h3>
		    </div>
		    <div class="panel-body">
		    	#view( view = "_tags/needhelp", prePostExempt = true )#
		    </div>
		</div>
		<!--- Event --->
		#announce( "cbadmin_postDashboardSideBar" )#
    </div>
</div>
</cfoutput>
