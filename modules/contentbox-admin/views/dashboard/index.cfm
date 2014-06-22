<cfoutput>
<div class="row-fluid">
	<!--- main content --->
	<div class="span9" id="main-content">
		<div class="box">
			<!--- Body Header --->
			<div class="header">
				<i class="icon-dashboard icon-larger"></i>
				#prc.cbSettings.cb_dashboard_welcome_title#
			</div>
			<!--- Body --->
			<div class="body" id="mainBody">

				<!--- Dashboard welcome body --->
				#prc.cbSettings.cb_dashboard_welcome_body#

				<!--- Messagebox --->
				#getPlugin("MessageBox").renderit()#
				
				<!--- Event --->
				#announceInterception("cbadmin_preDashboardContent")#
				
				<!--- Installer Checks --->
				<cfif prc.oAuthor.checkPermission( "SYSTEM_TAB" )>
				<cfif prc.installerCheck.installer>
					<div class="alert alert-danger" id="installerCheck">
						<button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
						<i class="fa fa-exclamation-triangle fa-2x"></i>
						The installer module still exists! Please delete it from your server as leaving it online is a security risk.
						<button class="btn btn-danger btn-sm" onclick="deleteInstaller()">Delete Installer</button>
					</div>
				</cfif>
				<cfif prc.installerCheck.dsncreator>
					<div class="alert alert-danger" id="dsnCreatorCheck">
						<button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
						<i class="fa fa-exclamation-triangle fa-2x"></i>
						The DSN creator module still exists! Please delete it from your server as leaving it online is a security risk.
						<button class="btn btn-danger btn-sm" onclick="deleteDSNCreator()">Delete DSN Creator</button>
					</div>
				</cfif>
				</cfif>
				
				<div class="tabbable">
					<ul class="nav nav-tabs" id="dashboardTabs">
						<cfif prc.oAuthor.checkPermission( "ENTRIES_ADMIN,ENTRIES_EDITOR,PAGES_ADMIN,PAGES_EDITOR,CONTENTSTORE_ADMIN,CONTENTSTORE_EDITOR" )>
							<li><a href="##recentContentTab" data-toggle="tab"><i class="icon-pencil"></i> Recent Content</a></li>
						</cfif>
						<cfif prc.oAuthor.checkPermission( "COMMENTS_ADMIN" )>
							<li><a href="##latestComments" data-toggle="tab"><i class="icon-comments"></i> Recent Comments</a></li>
						</cfif>
						<li><a href="##latestNews" data-toggle="tab"><i class="icon-rss"></i> Recent News</a></li>
						<!--- cbadmin Event --->
						#announceInterception("cbadmin_onDashboardTabNav")#
					</ul>
					<div class="tab-content">
						<!--- cbadmin Event --->
						#announceInterception("cbadmin_preDashboardTabContent")#
						<cfif prc.oAuthor.checkPermission( "ENTRIES_ADMIN,ENTRIES_EDITOR,PAGES_ADMIN,PAGES_EDITOR,CONTENTSTORE_ADMIN,CONTENTSTORE_EDITOR" )>
							<div class="tab-pane" id="recentContentTab">
								<div class="well well-small" id="latestPages"><i class="icon-spin icon-spinner icon-large icon-2x"></i></div>
								<div class="well well-small" id="latestEntries"><i class="icon-spin icon-spinner icon-large icon-2x"></i></div>
								<div class="well well-small" id="latestContentStore"><i class="icon-spin icon-spinner icon-large icon-2x"></i></div>
							</div>
						</cfif>
						<cfif prc.oAuthor.checkPermission( "COMMENTS_ADMIN" )>
							<div class="well well-small tab-pane" id="latestComments"><i class="icon-spin icon-spinner icon-large icon-2x"></i></div>
						</cfif>
						<div class="well well-small tab-pane" id="latestNews"><i class="icon-spin icon-spinner icon-large icon-2x"></i></div>
						<!--- cbadmin Event --->
						#announceInterception("cbadmin_postDashboardTabContent")#
						<p>&nbsp;</p><p>&nbsp;</p>
					</div>
				</div>
				
				<!--- Event --->
				#announceInterception("cbadmin_postDashboardContent")#
				
			</div>
		</div>
	</div> <!--- end content span --->
	
	<div class="span3" id="main-sidebar">
		<!--- Event --->
		#announceInterception("cbadmin_preDashboardSideBar")#
		
		<!---Latest Snapshot --->
		<cfif prc.oAuthor.checkPermission( "ENTRIES_ADMIN,ENTRIES_EDITOR,PAGES_ADMIN,PAGES_EDITOR,CONTENTSTORE_ADMIN,CONTENTSTORE_EDITOR,COMMENTS_ADMIN" )>
		<div id="latestSnapshot"><i class="icon-spin icon-spinner icon-large icon-2x"></i></div>	
		</cfif>
		
		<!--- Info Box --->
		<div class="small_box">
			<div class="header">
				<i class="icon-medkit"></i> Need Help?
			</div>
			<div class="body">
				#renderview(view="_tags/needhelp", module="contentbox-admin")#
			</div>
		</div>	

		<!--- Help Box--->
		<cfif prc.oAuthor.checkPermission( "ENTRIES_ADMIN,ENTRIES_EDITOR,PAGES_ADMIN,PAGES_EDITOR,CONTENTSTORE_ADMIN,CONTENTSTORE_EDITOR,COMMENTS_ADMIN" )>
		<div class="small_box" id="help_tips">
			<div class="header">
				<i class="icon-question-sign"></i> Help Tips
			</div>
			<div class="body">
				<ul class="unstyled tipList">
					<li><i class="icon-lightbulb icon-large"></i> Right click on a row to activate quick look!</li>
					<li><i class="icon-lightbulb icon-large"></i> 'Quick Post' is a minimalistic editing machine</li>
					<li><i class="icon-lightbulb icon-large"></i> 'Create Entry' is a full blown editing machine</li>
				</ul>
			</div>
		</div>
		</cfif>	
		
		<!--- Event --->
		#announceInterception("cbadmin_postDashboardSideBar")#
	</div>
	<!--- End SideBar --->
	
</div> <!---end Row --->

</cfoutput>