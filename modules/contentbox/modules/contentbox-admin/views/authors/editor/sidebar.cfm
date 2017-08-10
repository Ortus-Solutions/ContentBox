<cfoutput>
<div class="col-md-4" id="main-content-sidebar">

    	<div class="panel panel-primary">

			<div class="panel-heading">
				<h3 class="panel-title"><i class="fa fa-camera-retro"></i> Snapshot</h3>
			</div>

			<div class="panel-body">

				<div class="text-center margin10" id="author_actions">
					<div class="btn-group" role="group" aria-label="...">
						<!--- <button type="button" class="btn btn-default">1</button> --->

						<!--- Export But --->
						<cfif prc.oCurrentAuthor.checkPermission( "AUTHOR_ADMIN,TOOLS_EXPORT" )>
						<div class="btn-group" role="group">
							<button type="button" class="btn btn-info dropdown-toggle" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
							  <i class="fa fa-gears"></i> Actions
							  <span class="caret"></span>
							</button>
							<ul class="dropdown-menu">
								<li>
									<a href="#event.buildLink( linkto=prc.xehPasswordReset )#/authorID/#prc.author.getAuthorID()#/editing/true"
										title="Issue a password reset for the user upon next login.">
										<i class="fa fa-lock"></i> Reset Password
									</a>
								</li>
							</ul>
						</div>

						<div class="btn-group" role="group">
							<button type="button" class="btn btn-info dropdown-toggle" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
							  <i class="fa fa-download"></i> Export
							  <span class="caret"></span>
							</button>
							<ul class="dropdown-menu">
								<li>
									<a href="#event.buildLink( linkto=prc.xehExport )#/authorID/#prc.author.getAuthorID()#.json" target="_blank">
										<i class="fa fa-download"></i> Export as JSON
									</a>
								</li>
								<li>
									<a href="#event.buildLink( linkto=prc.xehExport )#/authorID/#prc.author.getAuthorID()#.xml" target="_blank">
										<i class="fa fa-download"></i> Export as XML
									</a>
								</li>
							</ul>
						</div>
						</cfif>
					</div>
				</div>

				<!--- Persisted Info --->
				<table class="table table-condensed table-hover table-striped size12" width="100%">
					<tr>
						<th width="125" class="textRight">Last Login</th>
						<td>
							#prc.author.getDisplayLastLogin()#
						</td>
					</tr>

					<tr>
						<th class="textRight">Created On</th>
						<td>
							#prc.author.getDisplayCreatedDate()#
						</td>
					</tr>

					<tr>
						<th class="textRight">Last Update</th>
						<td>
							#prc.author.getDisplayModifiedDate()#
						</td>
					</tr>

					<tr>
						<th class="textRight">Two-Factor Auth</th>
						<td>
							#YesNoFormat( prc.author.getIs2FactorAuth() )#
						</td>
					</tr>

					<tr>
						<th class="textRight">Role</th>
						<td>
							#prc.author.getRole().getRole()#
						</td>
					</tr>

					<tr>
						<th class="textRight">Permission Groups</th>
						<td>
							#prc.author.getPermissionGroupsList()#
						</td>
					</tr>

					<tr>
						<th class="textRight">Entries</th>
						<td>
							#prc.author.getNumberOfEntries()#
						</td>
					</tr>

					<tr>
						<th class="textRight">Pages</th>
						<td>
							#prc.author.getNumberOfPages()#
						</td>
					</tr>

					<tr>
						<th class="textRight">Content Store</th>
						<td>
							#prc.author.getNumberOfContentStore()#
						</td>
					</tr>
				</table>

				<p></p>

				<!--- Password Reset --->
				<cfif prc.author.getIsPasswordReset()>
					<div class="alert alert-warning">
						<i class="fa fa-exclamation-triangle fa-lg"></i>
						This user has been marked for password reset upon login.
					</div>
				</cfif>


				<!---Gravatar info --->
				<cfif prc.cbSettings.cb_gravatar_display>
				<div class="well well-sm">
					<i class="fa fa-info-circle fa-lg"></i>
					To change your avatar <a href="http://www.gravatar.com/site/signup/#URLEncodedFormat( prc.author.getEmail() )#" target="_blank">sign up to Gravatar.com</a>
					and follow the on-screen instructions to add a Gravatar for #prc.author.getEmail()#
				</div>
				</cfif>
			</div>
		</div>
		<!--- cbadmin Event --->
		#announceInterception( "cbadmin_onAuthorEditorSidebar" )#
    </div>
</cfoutput>