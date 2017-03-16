<cfoutput>
<div class="row">
    <div class="col-md-12">
        <h1 class="h1">
        	<i class="fa fa-dashboard fa-lgr"></i> #prc.cbSettings.cb_dashboard_welcome_title#
        </h1>
    </div>
</div>

<div class="row">
    <div class="col-md-8">
    	<!--- Dashboard welcome body --->
		<p class="lead">#prc.cbSettings.cb_dashboard_welcome_body#</p>

		<!--- Messagebox --->
		#getModel( "messagebox@cbMessagebox" ).renderit()#
		
		<!--- Event --->
		#announceInterception( "cbadmin_preDashboardContent" )#
		
		<!--- Installer Checks --->
		<cfif prc.oAuthor.checkPermission( "SYSTEM_TAB" )>
		<cfif prc.installerCheck.installer>
			<div class="alert alert-danger" id="installerCheck">
				<button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
				<i class="fa fa-exclamation-triangle fa-2x"></i>
				#$r( "dashboard.index.installer.notice@admin" )#
				<button class="btn btn-danger btn-sm" onclick="deleteInstaller()">#$r( "dashboard.index.installer.delete@admin" )#</button>
			</div>
		</cfif>
		<cfif prc.installerCheck.dsncreator>
			<div class="alert alert-danger" id="dsnCreatorCheck">
				<button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
				<i class="fa fa-exclamation-triangle fa-2x"></i>
				#$r( "dashboard.index.creator.notice@admin" )#
				<button class="btn btn-danger btn-sm" onclick="deleteDSNCreator()">#$r( "dashboard.index.creator.delete@admin" )#</button>
			</div>
		</cfif>
		</cfif>
		
		<div class="tab-wrapper tab-primary">
			<ul class="nav nav-tabs" id="dashboardTabs">
				<cfif prc.oAuthor.checkPermission( "ENTRIES_ADMIN,ENTRIES_EDITOR,PAGES_ADMIN,PAGES_EDITOR,CONTENTSTORE_ADMIN,CONTENTSTORE_EDITOR" )>
					<li>
						<a href="##contentReports" data-toggle="tab">
							<i class="fa fa-dashboard"></i> <span class="hidden-xs">#$r( "dashboard.index.nav-tabs.head1@admin" )#</span>
						</a>
					</li>
				</cfif>
				<cfif prc.oAuthor.checkPermission( "COMMENTS_ADMIN" )>
					<li>
						<a href="##latestComments" data-toggle="tab">
							<i class="fa fa-comments"></i> <span class="hidden-xs">#$r( "dashboard.index.nav-tabs.head2@admin" )#</span>
						</a>
					</li>
				</cfif>
				<li>
					<a href="##latestNews" data-toggle="tab">
						<i class="fa fa-rss"></i> <span class="hidden-xs">#$r( "dashboard.index.nav-tabs.head3@admin" )#</span>
					</a>
				</li>
				<!--- cbadmin Event --->
				#announceInterception( "cbadmin_onDashboardTabNav" )#
			</ul>
			<div class="tab-content">
				<!--- cbadmin Event --->
				#announceInterception( "cbadmin_preDashboardTabContent" )#
				<!--- ****************************************************************************************** --->
				<!--- LATEST SYSTEM EDITS + LATEST MY DRAFTS --->
				<!--- ****************************************************************************************** --->
				<cfif prc.oAuthor.checkPermission( "ENTRIES_ADMIN,ENTRIES_EDITOR,PAGES_ADMIN,PAGES_EDITOR,CONTENTSTORE_ADMIN,CONTENTSTORE_EDITOR" )>
					<div class="tab-pane" id="contentReports">
						<div class="" id="latestSystemEdits">
							<i class="fa fa-spin fa-spinner fa-lg fa-2x"></i>
						</div>
						<div class="" id="futurePublished">
							<i class="fa fa-spin fa-spinner fa-lg fa-2x"></i>
						</div>
						<div class="" id="expiredContent">
							<i class="fa fa-spin fa-spinner fa-lg fa-2x"></i>
						</div>
						<div class="" id="latestUserDrafts">
							<i class="fa fa-spin fa-spinner fa-lg fa-2x"></i>
						</div>
					</div>
				</cfif>
				<!--- ****************************************************************************************** --->
				<!--- LATEST COMMENTS --->
				<!--- ****************************************************************************************** --->
				<cfif prc.oAuthor.checkPermission( "COMMENTS_ADMIN" )>
					<div class="tab-pane" id="latestComments">
						<i class="fa fa-spin fa-spinner fa-lg fa-2x"></i>
					</div>
				</cfif>
				<!--- ****************************************************************************************** --->
				<!--- LATEST NEWS TAB --->
				<!--- ****************************************************************************************** --->
				<div class="tab-pane" id="latestNews">
					<i class="fa fa-spin fa-spinner fa-lg fa-2x"></i>
				</div>
				<!--- cbadmin Event --->
				#announceInterception( "cbadmin_postDashboardTabContent" )#
			</div>
		</div>
		
		<!--- Event --->
		#announceInterception( "cbadmin_postDashboardContent" )#
    </div>
    <div class="col-md-4">
        <!--- Event --->
		#announceInterception( "cbadmin_preDashboardSideBar" )#
		
		<!---Latest Snapshot --->
		<cfif prc.oAuthor.checkPermission( "ENTRIES_ADMIN,ENTRIES_EDITOR,PAGES_ADMIN,PAGES_EDITOR,CONTENTSTORE_ADMIN,CONTENTSTORE_EDITOR,COMMENTS_ADMIN" )>
			<div id="latestSnapshot">
				<i class="fa fa-spin fa-spinner fa-lg fa-2x"></i>
			</div>	
		</cfif>

		<!--- Latest Logins --->
		<cfif prc.oAuthor.checkPermission( "SYSTEM_AUTH_LOGS" )>
			<div class="panel panel-primary">
			    <div class="panel-heading">
			        <h3 class="panel-title"><i class="fa fa-bar-chart-o"></i> #$r( "dashboard.index.latestLogins@admin" )#</h3>
			    </div>
			    <div class="panel-body">
			    	<div id="latestLogins"><i class="fa fa-spin fa-spinner fa-lg -2x"></i></div>
			    </div>
			</div>
		</cfif> 

		<!--- Info Box --->
		<div class="panel panel-primary">
		    <div class="panel-heading">
		        <h3 class="panel-title"><i class="fa fa-medkit"></i> #$r( "dashboard.index.needHelp@admin" )#</h3>
		    </div>
		    <div class="panel-body">
		    	#renderview(view="_tags/needhelp", module="contentbox-admin" )#
		    </div>
		</div>
		<!--- Event --->
		#announceInterception( "cbadmin_postDashboardSideBar" )#
    </div>
</div>
</cfoutput>