<cfoutput>
<div class="row">
    <div class="col-md-8" id="main-content-slot">

    	<div class="panel panel-default">

            <div class="panel-heading">

                <h3 class="panel-title">
                	#getModel( "Avatar@cb" ).renderAvatar( email=prc.author.getEmail(), size="30" )#
					#prc.author.getName()#
                </h3>

                <div class="actions">

                    <!--- Back To Inbox --->
                    #announceInterception( "cbadmin_onAuthorEditorActions" )#

					<!--- Back button --->
					<p class="text-center">
						<cfif prc.oCurrentAuthor.checkPermission( "AUTHOR_ADMIN" )>
							<button class="btn btn-sm btn-info" onclick="return to('#event.buildLink( prc.xehAuthors )#')">
								<i class="fa fa-reply"></i> Back To Listing
							</button>
						<cfelse>
							<button class="btn btn-sm btn-info" onclick="return to('#event.buildLink( prc.xehDashboard )#')">
								<i class="fa fa-reply"></i> Back To Dashboard
							</button>
						</cfif>
					</p>
                </div>
            </div>

            <div class="panel-body">

            	<!--- Messageboxes --->
            	#getModel( "messagebox@cbMessagebox" ).renderIt()#

            	<!--- Vertical Nav --->
                <div class="tab-wrapper tab-left tab-primary">

                    <!--- Documentation Navigation Bar --->
                    <ul class="nav nav-tabs">

                    	<li class="active">
                    		<a href="##details" data-toggle="tab"><i class="fa fa-eye"></i> Details</a>
                    	</li>
						<li>
							<a href="##change-password" data-toggle="tab"><i class="fa fa-key"></i> Password</a>
						</li>
						<li>
							<a href="##twofactor"  data-toggle="tab"><i class="fa fa-mobile fa-lg"></i> Two Factor</a>
						</li>
						<li>
							<a href="##preferences" data-toggle="tab"><i class="fa fa-briefcase"></i> Preferences</a></li>
						<li>
							<a href="##permissions" onclick="loadPermissions();" data-toggle="tab"><i class="fa fa-lock"></i> Permissions</a>
						</li>
						<cfif prc.oCurrentAuthor.checkPermission( "ENTRIES_ADMIN,ENTRIES_EDITOR,PAGES_ADMIN,PAGES_EDITOR,CONTENTSTORE_ADMIN,CONTENTSTORE_EDITOR" )>
						<li>
							<a href="##latestEdits" data-toggle="tab"><i class="fa fa-clock-o"></i> Latest Edits</a>
						</li>
						<li>
							<a href="##latestDrafts" data-toggle="tab"><i class="fa fa-pencil"></i> Latest Drafts</a>
						</li>
						</cfif>

						<!--- cbadmin Event --->
    					#announceInterception( "cbadmin_onAuthorEditorNav" )#
                    </ul>

                    <!--- Tab Content --->
                    <div class="tab-content">
                    	<!--- Author Details --->
                    	#renderView( view="authors/editor/details" )#

						<!--- Change Password --->
						#renderView( view="authors/editor/password" )#

						<!--- Two Factor--->
                    	#renderView( view="authors/editor/twoFactor" )#

						<!--- Preferences --->
						#renderView( view="authors/editor/preferences" )#

						<!--- Permissions --->
						#renderView( view="authors/editor/permissions" )#

						<cfif prc.oCurrentAuthor.checkPermission( "ENTRIES_ADMIN,ENTRIES_EDITOR,PAGES_ADMIN,PAGES_EDITOR,CONTENTSTORE_ADMIN,CONTENTSTORE_EDITOR" )>
							<!--- Latest Edits --->
							#renderView( view="authors/editor/edits" )#

							<!--- Latest Drafts --->
							#renderView( view="authors/editor/drafts" )#
						</cfif>

						<!--- cbadmin Event --->
						#announceInterception( "cbadmin_onAuthorEditorContent" )#
                   	</div>
                   	<!--- End Tab Content--->
                </div>
            </div>
 		</div>
    </div>

    <!--- ****************************************************************************** --->
    <!--- SIDEBAR --->
    <!--- ****************************************************************************** --->

    #renderView( view="authors/editor/sidebar" )#
</div>
</cfoutput>
