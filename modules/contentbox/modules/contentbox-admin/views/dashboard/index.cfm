<cfoutput>
<div class="row">
    <div class="col-md-12">
        <h1 class="h1">
        	<i class="fas fa-tv"></i> #prc.cbSettings.cb_dashboard_welcome_title#
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
		<cfif prc.oCurrentAuthor.checkPermission( "SYSTEM_TAB" ) and prc.installerCheck>
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

		<div class="tab-wrapper tab-primary">
			<ul class="nav nav-tabs" id="dashboardTabs">
				<cfif prc.oCurrentAuthor.checkPermission( "ENTRIES_ADMIN,ENTRIES_EDITOR,PAGES_ADMIN,PAGES_EDITOR,CONTENTSTORE_ADMIN,CONTENTSTORE_EDITOR" )>
					<li>
						<a href="##contentReports" data-toggle="tab">
							<i class="fas fa-box"></i> <span class="hidden-xs">#$r( "dashboard.index.nav-tabs.head1@admin" )#</span>
						</a>
					</li>
				</cfif>
				<cfif prc.oCurrentAuthor.checkPermission( "COMMENTS_ADMIN" )>
					<li>
						<a href="##latestComments" data-toggle="tab">
							<i class="far fa-comments"></i> <span class="hidden-xs">#$r( "dashboard.index.nav-tabs.head2@admin" )#</span>
						</a>
					</li>
				</cfif>
				<li>
					<a href="##latestNews" data-toggle="tab">
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
				<cfif prc.oCurrentAuthor.checkPermission( "ENTRIES_ADMIN,ENTRIES_EDITOR,PAGES_ADMIN,PAGES_EDITOR,CONTENTSTORE_ADMIN,CONTENTSTORE_EDITOR" )>
					<div class="tab-pane" id="contentReports">
						<div class="m5" id="latestSystemEdits">
							<i class="fas fa-spin fa-circle-notch fa-lg fa-2x"></i>
						</div>
						<div class="m5" id="futurePublished">
							<i class="fas fa-spin fa-circle-notch fa-lg fa-2x"></i>
						</div>
						<div class="m5" id="expiredContent">
							<i class="fas fa-spin fa-circle-notch fa-lg fa-2x"></i>
						</div>
						<div class="m5" id="latestUserDrafts">
							<i class="fas fa-spin fa-circle-notch fa-lg fa-2x"></i>
						</div>
					</div>
				</cfif>
				<!--- ****************************************************************************************** --->
				<!--- LATEST COMMENTS --->
				<!--- ****************************************************************************************** --->
				<cfif prc.oCurrentAuthor.checkPermission( "COMMENTS_ADMIN" )>
					<div class="tab-pane" id="latestComments">
						<i class="fas fa-spin fa-circle-notch fa-lg fa-2x"></i>
					</div>
				</cfif>
				<!--- ****************************************************************************************** --->
				<!--- LATEST NEWS TAB --->
				<!--- ****************************************************************************************** --->
				<div class="tab-pane" id="latestNews">
					<i class="fas fa-spin fa-circle-notch fa-lg fa-2x"></i>
				</div>
				<!--- cbadmin Event --->
				#announce( "cbadmin_postDashboardTabContent" )#
			</div>
		</div>

		<!--- Event --->
		#announce( "cbadmin_postDashboardContent" )#
    </div>
    <div class="col-md-4">
        <!--- Event --->
		#announce( "cbadmin_preDashboardSideBar" )#

		<!---Latest Snapshot --->
		<cfif prc.oCurrentAuthor.checkPermission( "ENTRIES_ADMIN,ENTRIES_EDITOR,PAGES_ADMIN,PAGES_EDITOR,CONTENTSTORE_ADMIN,CONTENTSTORE_EDITOR,COMMENTS_ADMIN" )>
			<div id="latestSnapshot">
				<i class="fas fa-spin fa-circle-notch fa-lg fa-2x"></i>
			</div>
		</cfif>

		<!--- Latest Logins --->
		<cfif prc.oCurrentAuthor.checkPermission( "SYSTEM_AUTH_LOGS" )>
			<div class="panel panel-primary">
			    <div class="panel-heading">
					<h3 class="panel-title">
						<i class="fas fa-users fa-lg"></i> #$r( "dashboard.index.latestLogins@admin" )#
					</h3>
			    </div>
			    <div class="panel-body">
					<div id="latestLogins">
						<i class="fas fa-spin fa-circle-notch fa-lg -2x"></i>
					</div>
			    </div>
			</div>
		</cfif>

		<!--- Info Box --->
		<div class="panel panel-primary">
		    <div class="panel-heading">
				<h3 class="panel-title">
					<i class="fab fa-medrt fa-lg"></i> #$r( "dashboard.index.needHelp@admin" )#
				</h3>
		    </div>
		    <div class="panel-body">
		    	#renderview( view = "_tags/needhelp", prePostExempt = true )#
		    </div>
		</div>
		<!--- Event --->
		#announce( "cbadmin_postDashboardSideBar" )#
    </div>
</div>
</cfoutput>