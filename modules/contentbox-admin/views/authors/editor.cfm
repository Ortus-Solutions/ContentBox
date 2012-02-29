<cfoutput>
<!--============================Sidebar============================-->
<div class="sidebar">
	<!--- Info Box --->
	<div class="small_box">
		<div class="header">
			<img src="#prc.cbroot#/includes/images/settings.png" alt="info" width="24" height="24" />Actions
		</div>
		<div class="body">
			<!--- Back button --->
			<p class="center">
				<button class="button" onclick="return to('#event.buildLink(prc.xehAuthors)#')"> <img src="#prc.cbroot#/includes/images/go-back.png" alt="help"/> Back To Authors</button>
			</p>
		</div>
	</div>
	<!--- User Details --->
	<cfif prc.author.isLoaded()>
	<div class="small_box">
		<div class="header">
			<img src="#prc.cbroot#/includes/images/users_icon.png" alt="info" width="24" height="24" />Details
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
			<img src="#prc.cbroot#/includes/images/user-admin.png" alt="sofa" width="30" height="30" />
			<cfif prc.author.isLoaded()>Editing #prc.author.getName()#<cfelse>Create Author</cfif>
		</div>
		<!--- Body --->
		<div class="body">
			#getPlugin("MessageBox").renderIt()#

			<!--- Vertical Nav --->
			<div class="body_vertical_nav clearfix">
				<!--- User Navigation Bar --->
				<ul class="vertical_nav">
					<li class="active"><a href="##userDetails"><img src="#prc.cbRoot#/includes/images/settings_black.png" alt="modifiers"/> User Details</a></li>
					<cfif prc.author.isLoaded()>
					<li><a href="##password"><img src="#prc.cbRoot#/includes/images/credit-card.png" alt="modifiers"/> Change Password</a></li>
					<li><a href="##permissions" onclick="loadPermissions()"><img src="#prc.cbRoot#/includes/images/lock.png" alt="modifiers"/> Permissions</a></li>
					<li><a href="##entries"><img src="#prc.cbRoot#/includes/images/page.png" alt="modifiers"/> Author Entries</a></li>
					<li><a href="##pages"><img src="#prc.cbRoot#/includes/images/library.png" alt="modifiers"/> Author Pages</a></li>
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

								<!--- Action Bar --->
								<cfif prc.oAuthor.checkPermission("AUTHOR_ADMIN") OR prc.author.getAuthorID() EQ prc.oAuthor.getAuthorID()>
								<div class="actionBar">
									<button class="button" onclick="return to('#event.buildLink(prc.xehAuthors)#')">Cancel</button> or
									<input type="submit" value="Save" class="buttonred">
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
								<button class="button" onclick="return to('#event.buildLink(prc.xehAuthors)#')">Cancel</button> or
								<input type="submit" value="Change Password" class="buttonred">
							</div>
							</cfif>

							#html.endFieldSet()#
						#html.endForm()#
						</div>

						<!--- Permissions --->
						<div id="permissionsTab"></div>

						<!--- My Entries --->
						<div>
						#html.startFieldset(legend="Author Entries")#
							<!--- Entries Pager Viewlet --->
							#prc.entryViewlet#
						#html.endFieldSet()#
						</div>

						<!--- My Pages --->
						<div>
						#html.startFieldset(legend="Author Pages")#
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