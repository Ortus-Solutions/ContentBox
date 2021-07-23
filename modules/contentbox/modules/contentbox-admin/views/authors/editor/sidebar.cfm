<cfoutput>
<div class="col-md-4">

    	<div class="panel panel-primary">

			<div class="panel-body">

				<!--- Big Profile Picture --->
				<div class="text-center mb20">
					#getInstance( "Avatar@contentbox" ).renderAvatar(
						email = prc.author.getEmail(),
						size  = "100",
						class = "img img-circle mb10"
					)#

					<div class="mt10 mb10">
						<span class="label label-default size16">
							#prc.author.getFullName()#
						</span>
					</div>
				</div>

				<!--- Password Reset --->
				<cfif prc.author.getIsPasswordReset()>
					<div class="alert alert-warning">
						<i class="fa fa-exclamation-triangle fa-lg"></i>
						This user has been marked for password reset upon login.
					</div>
				</cfif>

				<!--- Persisted Info --->
				<table class="table table-hover table-striped-removed mt10">
					<tr>
						<th width="125" class="text-right">Last Login</th>
						<td>
							#prc.author.getDisplayLastLogin()#
						</td>
					</tr>

					<tr>
						<th class="text-right">Created On</th>
						<td>
							#prc.author.getDisplayCreatedDate()#
						</td>
					</tr>

					<tr>
						<th class="text-right">Modified On</th>
						<td>
							#prc.author.getDisplayModifiedDate()#
						</td>
					</tr>

					<tr>
						<th class="text-right">Two-Factor</th>
						<td>
							#YesNoFormat( prc.author.getIs2FactorAuth() )#
						</td>
					</tr>

					<tr>
						<th class="text-right">Role</th>
						<td>
							#prc.author.getRole().getRole()#
						</td>
					</tr>

					<tr>
						<th class="text-right">Entries</th>
						<td>
							#prc.author.getNumberOfEntries()#
						</td>
					</tr>

					<tr>
						<th class="text-right">Pages</th>
						<td>
							#prc.author.getNumberOfPages()#
						</td>
					</tr>

					<tr>
						<th class="text-right">Content Store</th>
						<td>
							#prc.author.getNumberOfContentStore()#
						</td>
					</tr>
				</table>

				<!---Gravatar info --->
				<cfif prc.cbSettings.cb_gravatar_display>
				<div class="well well-sm rounded">
					<i class="fa fa-info-circle fa-lg"></i>
					To change your avatar
					<a
						href="http://www.gravatar.com/site/signup/#URLEncodedFormat( prc.author.getEmail() )#"
						target="_blank">
						sign up to Gravatar.com
					</a>
					and follow the on-screen instructions to add a Gravatar for
					<code>#prc.author.getEmail()#</code>
				</div>
				</cfif>
			</div>
		</div>

		<!--- cbadmin Event --->
		#announce( "cbadmin_onAuthorEditorSidebar" )#
    </div>
</cfoutput>