<cfoutput>
<div class="row-fluid">
	<!--- main content --->
	<div class="span9" id="main-content">
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
				<div class="tabbable tabs-left">
					<!--- User Navigation Bar --->
					<ul class="nav nav-tabs">
						<li class="active"><a href="##userDetails" data-toggle="tab"><i class="icon-eye-open"></i> Details</a></li>
						<cfif prc.author.isLoaded()>
							<li><a href="##password" data-toggle="tab"><i class="icon-key"></i> Change Password</a></li>
							<li><a href="##preferences" data-toggle="tab"><i class="icon-briefcase"></i> Preferences</a></li>
							<li><a href="##permissionsTab" onclick="loadPermissions();" data-toggle="tab"><i class="icon-lock"></i> Permissions</a></li>
							<cfif prc.oAuthor.checkPermission( "ENTRIES_ADMIN,ENTRIES_EDITOR" )>
							<li><a href="##entries" data-toggle="tab"><i class="icon-quote-left"></i> Entries</a></li>
							</cfif>
							<cfif prc.oAuthor.checkPermission( "PAGES_ADMIN,PAGES_EDITOR" )>
							<li><a href="##pages" data-toggle="tab"><i class="icon-pencil"></i> Pages</a></li>
							</cfif>
							<cfif prc.oAuthor.checkPermission( "CONTENTSTORE_ADMIN,CONTENTSTORE_EDITOR" )>
							<li><a href="##contentstore" data-toggle="tab"><i class="icon-pencil"></i> Content Store</a></li>
							</cfif>
						</cfif>
						<!--- cbadmin Event --->
    					#announceInterception("cbadmin_onAuthorEditorNav")#
					</ul>
					<!--- Tab Content --->
					<div class="tab-content">
						<!--- Author Details --->
						<div class="tab-pane active" id="userDetails">
							<!--- AuthorForm --->
							#html.startForm(name="authorForm",action=prc.xehAuthorsave,novalidate="novalidate", class="form-vertical")#
								#html.startFieldset(legend="User Details")#
								#html.hiddenField(name="authorID",bind=prc.author)#
								<!--- Fields --->
								#html.textField(name="firstName",bind=prc.author,label="*First Name:",required="required",size="50",class="textfield",wrapper="div class=controls",labelClass="control-label",groupWrapper="div class=control-group")#
								#html.textField(name="lastName",bind=prc.author,label="*Last Name:",required="required",size="50",class="textfield",wrapper="div class=controls",labelClass="control-label",groupWrapper="div class=control-group")#
								#html.inputField(name="email",type="email",bind=prc.author,label="*Email:",required="required",size="50",class="textfield",wrapper="div class=controls",labelClass="control-label",groupWrapper="div class=control-group")#
								#html.textField(name="username",bind=prc.author,label="*Username:",required="required",size="50",class="textfield username",wrapper="div class=controls",labelClass="control-label",groupWrapper="div class=control-group")#
								<cfif NOT prc.author.isLoaded()>
								#html.passwordField(name="password",bind=prc.author,label="*Password:",required="required",size="50",class="textfield",wrapper="div class=controls",labelClass="control-label",groupWrapper="div class=control-group")#
								</cfif>

								<!--- Active --->
								<cfif prc.oAuthor.checkPermission("AUTHOR_ADMIN")>
								#html.select(label="Active User:",name="isActive",options="yes,no",style="width:200px",bind=prc.author,wrapper="div class=controls",labelClass="control-label",groupWrapper="div class=control-group")#
								<!--- Roles --->
								#html.select(label="User Role:",name="roleID",options=prc.roles,column="roleID",nameColumn="role",bind=prc.author.getRole(),style="width:200px",wrapper="div class=controls",labelClass="control-label",groupWrapper="div class=control-group")#
								<cfelse>
									<label>Active User: </label> <span class="textRed">#prc.author.getIsActive()#</span><br/>
									<label>User Role: </label> <span class="textRed">#prc.author.getRole().getRole()#</span><br/>
								</cfif>
								
								<!--- Biography --->
								#html.textarea(name="biography",label="Biography or Notes About The User:",bind=prc.author,rows="10",wrapper="div class=controls",labelClass="control-label",groupWrapper="div class=control-group")#

								#html.endFieldSet()#
								
								<!--- Action Bar --->
								<cfif prc.oAuthor.checkPermission("AUTHOR_ADMIN") OR prc.author.getAuthorID() EQ prc.oAuthor.getAuthorID()>
								<div class="form-actions">
									<input type="submit" value="Save Details" class="btn btn-danger">
								</div>
								</cfif>
								
							#html.endForm()#
						</div>

						<cfif prc.author.isLoaded()>
						<!--- Change Password --->
						<div class="tab-pane" id="password">
						#html.startForm(name="authorPasswordForm",action=prc.xehAuthorChangePassword,novalidate="novalidate",class="form-vertical")#
							#html.startFieldset(legend="Change Password")#
							#html.hiddenField(name="authorID",bind=prc.author)#
							<!--- Fields --->
							#html.passwordField(name="password",label="Password:",required="required",size="50",class="textfield",wrapper="div class=controls",labelClass="control-label",groupWrapper="div class=control-group")#
							#html.passwordField(name="password_confirm",label="Confirm Password:",required="required",size="50",class="textfield",wrapper="div class=controls",labelClass="control-label",groupWrapper="div class=control-group")#
							#html.endFieldSet()#
							
							<!--- Action Bar --->
							<cfif prc.oAuthor.checkPermission("AUTHOR_ADMIN") OR prc.author.getAuthorID() EQ prc.oAuthor.getAuthorID()>
							<div class="form-actions">
								<input type="submit" value="Change Password" class="btn btn-danger">
							</div>
							</cfif>
						#html.endForm()#
						</div>
						
						<!--- Preferences --->
						<div class="tab-pane" id="preferences">#prc.preferencesViewlet#</div>

						<!--- Permissions --->
						<div class="tab-pane" id="permissionsTab"></div>

						<!--- My Entries --->
						<cfif prc.oAuthor.checkPermission( "ENTRIES_ADMIN,ENTRIES_EDITOR" )>
						<div class="tab-pane" id="entries">
						#html.startFieldset(legend="User Entries")#
							#prc.entryViewlet#
						#html.endFieldSet()#
						</div>
						</cfif>

						<!--- My Pages --->
						<cfif prc.oAuthor.checkPermission( "PAGES_ADMIN,PAGES_EDITOR" )>
						<div class="tab-pane" id="pages">
						#html.startFieldset(legend="User Pages")#
							#prc.pageViewlet#
						#html.endFieldSet()#
						</div>
						</cfif>
						
						<!--- My ContentStore --->
						<cfif prc.oAuthor.checkPermission( "CONTENTSTORE_ADMIN,CONTENTSTORE_EDITOR" )>
						<div class="tab-pane" id="contentstore">
						#html.startFieldset(legend="User Content Store")#
							#prc.contentStoreViewlet#
						#html.endFieldSet()#
						</div>
						</cfif>
						</cfif>

						<!--- cbadmin Event --->
						#announceInterception("cbadmin_onAuthorEditorContent")#
					</div>
					<!--- End Tab Content --->
				</div>
				<!--- End Vertical Nav --->
			</div>	
            <!--- End Body --->
		</div> 
        <!--- main box --->
	</div>

	<!--- main sidebar --->
	<div class="span3" id="main-sidebar">
		<!--- Info Box --->
		<div class="small_box">
			<div class="header">
				<i class="icon-cogs"></i> Actions
			</div>
			<div class="body">
				#announceInterception("cbadmin_onAuthorEditorActions")#
				<!--- Back button --->
				<p class="center">
					<button class="btn" onclick="return to('#event.buildLink(prc.xehAuthors)#')"><i class="icon-reply"></i> Back To Listing</button>
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
				<div class="pull-left margin10">
					#getMyPlugin(plugin="Avatar",module="contentbox").renderAvatar(email=prc.author.getEmail(),size="40")#
				</div>
				<div class="margin10">
					<a title="Email Me!" href="mailto:#prc.author.getEmail()#">#prc.author.getName()#</a>
				</div>
				
				<!--- Persisted Info --->
				<table class="table table-condensed table-hover table-striped" width="100%">
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
					<tr>
						<th width="75" class="textRight">Role</th>
						<td>
							#prc.author.getRole().getRole()#
						</td>
					</tr>
				</table>
				
				<p></p>
				<!---Gravatar info --->
				<div class="alert alert-info clearfix">
					<i class="icon-info-sign icon-large"></i>
					To change your avatar <a href="http://www.gravatar.com/site/signup/#URLEncodedFormat( prc.author.getEmail() )#" target="_blank">sign up to Gravatar.com</a>
					and follow the on-screen instructions to add a Gravatar for #prc.author.getEmail()#
				</div>
	
			</div>
		</div>
		</cfif>
		
		<!--- cbadmin Event --->
		#announceInterception("cbadmin_onAuthorEditorSidebar")#
	</div>
</div>
</cfoutput>