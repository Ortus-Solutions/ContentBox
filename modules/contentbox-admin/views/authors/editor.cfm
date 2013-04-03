<cfoutput>
<!--============================Sidebar============================-->
<div class="sidebar">
	<!--- Info Box --->
	<div class="small_box">
		<div class="header">
			<i class="icon-cogs"></i> Actions
		</div>
		<div class="body">
			<!--- Back button --->
			<p class="center">
				<button class="button" onclick="return to('#event.buildLink(prc.xehAuthors)#')"> Back To Authors</button>
			</p>
		</div>
	</div>
	<!--- User Details --->
	<cfif prc.author.isLoaded()>
	<div class="small_box">
		<div class="header">
			<i class="icon-eye-open"></i> Details
		</div>
		<div class="body">
			<!--- Info --->
			<div class="floatLeft">
				#getMyPlugin(plugin="Avatar",module="contentbox").renderAvatar(email=prc.author.getEmail(),size="40")#
			</div>
			<div id="userDetails">
				<a title="Email Me!" href="mailto:#prc.author.getEmail()#">#prc.author.getName()#</a>
			</div>

			<!--- Persisted Info --->
			<br/>
			<table class="tablelisting" width="100%">
				<tr>
					<th width="75" class="textRight">Last Login</th>
					<td>
						#prc.author.getDisplayLastLogin()#
					</td>
				</tr>
				<tr>
					<th width="75" class="textRight">Created Date</th>
					<td>
						#prc.author.getDisplayCreatedDate()#
					</td>
				</tr>
			</table>
		</div>
	</div>
	</cfif>
</div>
<!--End sidebar-->
<!--============================Main Column============================-->
<div class="main_column">
	<div class="box">
		<!--- Body Header --->
		<div class="header">
			<i class="icon-user icon-large"></i>
			<cfif prc.author.isLoaded()>Editing #prc.author.getName()#<cfelse>Create Author</cfif>
		</div>
		<!--- Body --->
		<div class="body">
			#getPlugin("MessageBox").renderIt()#

			<!--- Vertical Nav --->
			<div class="body_vertical_nav clearfix">
				<!--- User Navigation Bar --->
				<ul class="vertical_nav">
					<li class="active"><a href="##userDetails"><i class="icon-eye-open"></i> Details</a></li>
					<cfif prc.author.isLoaded()>
					<li><a href="##password"><i class="icon-lock"></i> Change Password</a></li>
					<li><a href="##preferences"><i class="icon-briefcase"></i> Preferences</a></li>
					<li><a href="##permissions" onclick="loadPermissions()"><i class="icon-star"></i> Permissions</a></li>
					<li><a href="##entries"><i class="icon-quote-left"></i> User Entries</a></li>
					<li><a href="##pages"><i class="icon-pencil"></i> User Pages</a></li>
					</cfif>
				</ul>
				<!--- Tab Content --->
				<div class="main_column">
					<div class="panes_vertical">
						<!--- Author Details --->
						<div>
							<!--- AuthorForm --->
							#html.startForm(name="authorForm",action=prc.xehAuthorsave,novalidate="novalidate")#
								#html.startFieldset(legend="User Details")#
								#html.hiddenField(name="authorID",bind=prc.author)#
								<!--- Fields --->
								#html.textField(name="firstName",bind=prc.author,label="*First Name:",required="required",size="50",class="textfield")#
								#html.textField(name="lastName",bind=prc.author,label="*Last Name:",required="required",size="50",class="textfield")#
								#html.inputField(name="email",type="email",bind=prc.author,label="*Email:",required="required",size="50",class="textfield")#
								#html.textField(name="username",bind=prc.author,label="*Username:",required="required",size="50",class="textfield")#
								<cfif NOT prc.author.isLoaded()>
								#html.passwordField(name="password",bind=prc.author,label="*Password:",required="required",size="50",class="textfield")#
								</cfif>

								<!--- Active --->
								<cfif prc.oAuthor.checkPermission("AUTHOR_ADMIN")>
								#html.select(label="Active User:",name="isActive",options="yes,no",style="width:200px",bind=prc.author)#
								<!--- Roles --->
								#html.select(label="User Role:",name="roleID",options=prc.roles,column="roleID",nameColumn="role",bind=prc.author.getRole(),style="width:200px")#
								<cfelse>
									<label>Active User: </label> <span class="textRed">#prc.author.getIsActive()#</span><br/>
									<label>User Role: </label> <span class="textRed">#prc.author.getRole().getRole()#</span><br/>
								</cfif>
								
								<!--- Biography --->
								#html.textarea(name="biography",label="Biography or Notes About The User:",bind=prc.author,rows="10")#

								<!--- Action Bar --->
								<cfif prc.oAuthor.checkPermission("AUTHOR_ADMIN") OR prc.author.getAuthorID() EQ prc.oAuthor.getAuthorID()>
								<div class="actionBar">
									<input type="submit" value="Save Details" class="buttonred">
								</div>
								</cfif>
								#html.endFieldSet()#
							#html.endForm()#
						</div>

						<cfif prc.author.isLoaded()>
						<!--- Change Password --->
						<div>
						#html.startForm(name="authorPasswordForm",action=prc.xehAuthorChangePassword,novalidate="novalidate")#
							#html.startFieldset(legend="Change Password")#
							#html.hiddenField(name="authorID",bind=prc.author)#
							<!--- Fields --->
							#html.passwordField(name="password",label="Password:",required="required",size="50",class="textfield")#
							#html.passwordField(name="password_confirm",label="Confirm Password:",required="required",size="50",class="textfield")#

							<!--- Action Bar --->
							<cfif prc.oAuthor.checkPermission("AUTHOR_ADMIN") OR prc.author.getAuthorID() EQ prc.oAuthor.getAuthorID()>
							<div class="actionBar">
								<input type="submit" value="Change Password" class="buttonred">
							</div>
							</cfif>

							#html.endFieldSet()#
						#html.endForm()#
						</div>
						
						<!--- Preferences --->
						<div>#prc.preferencesViewlet#</div>

						<!--- Permissions --->
						<div id="permissionsTab"></div>

						<!--- My Entries --->
						<div>
						#html.startFieldset(legend="User Entries")#
							<!--- Entries Pager Viewlet --->
							#prc.entryViewlet#
						#html.endFieldSet()#
						</div>

						<!--- My Pages --->
						<div>
						#html.startFieldset(legend="User Pages")#
							<!--- Pages Pager Viewlet --->
							#prc.pageViewlet#
						#html.endFieldSet()#
						</div>
						</cfif>

					</div>
					<!--- end panes_vertical --->
				</div>
				<!--- end panes content --->
			</div>
			<!--- end vertical nav --->

		</div>	<!--- body --->
	</div> <!--- main box --->
</div> <!--- main column --->
</cfoutput>