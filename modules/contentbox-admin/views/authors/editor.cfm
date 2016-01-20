﻿<cfoutput>

<div class="row">
    <div class="col-md-12">
        <h1 class="h1">
        	<i class="fa fa-user fa-lg"></i>
			<cfif prc.author.isLoaded()>Editing #prc.author.getName()#<cfelse>Create Author</cfif>
        </h1>
    </div>
</div>

<div class="row">
    <div class="<cfif prc.author.isLoaded()>col-md-8<cfelse>col-md-12</cfif>">
    	#getModel( "messagebox@cbMessagebox" ).renderIt()#
    	<div class="panel panel-default">
            <div class="panel-heading">
                <h3 class="panel-title">&nbsp;</h3>
                <div class="actions">
                    <!--- Back To Inbox --->
                    #announceInterception( "cbadmin_onAuthorEditorActions" )#
					<!--- Back button --->
					<p class="text-center">
						<cfif prc.oAuthor.checkPermission( "AUTHOR_ADMIN" )>
							<button class="btn btn-sm btn-info" onclick="return to('#event.buildLink( prc.xehAuthors )#')"><i class="fa fa-reply"></i> Back To Listing</button>
						<cfelse>
							<button class="btn btn-sm btn-info" onclick="return to('#event.buildLink( prc.xehDashboard )#')"><i class="fa fa-reply"></i> Back To Dashboard</button>
						</cfif>
					</p>
                </div>
            </div>
            <div class="panel-body">
            	<!--- Vertical Nav --->
                <div class="tab-wrapper tab-left tab-primary">
                    <!--- Documentation Navigation Bar --->
                    <ul class="nav nav-tabs">
                    	<li class="active">
                    		<a href="##userDetails" data-toggle="tab"><i class="fa fa-eye"></i> Details</a>
                    	</li>
						<cfif prc.author.isLoaded()>
							<li>
								<a href="##password" data-toggle="tab"><i class="fa fa-key"></i> Change Password</a>
							</li>
							<li>
								<a href="##preferences" data-toggle="tab"><i class="fa fa-briefcase"></i> Preferences</a></li>
							<li>
								<a href="##permissionsTab" onclick="loadPermissions();" data-toggle="tab"><i class="fa fa-lock"></i> Permissions</a>
							</li>
							<li>
								<a href="##latestEdits" data-toggle="tab"><i class="fa fa-clock-o"></i> Latest Edits</a>
							</li>
						</cfif>
						<!--- cbadmin Event --->
    					#announceInterception( "cbadmin_onAuthorEditorNav" )#
                    </ul>
                    <!--- Tab Content --->
                    <div class="tab-content">
                    	<!--- Author Details --->
						<div class="tab-pane active" id="userDetails">
							<!--- AuthorForm --->
							#html.startForm(
								name="authorForm",
								action=prc.xehAuthorsave,
								novalidate="novalidate", 
								class="form-vertical"
							)#
								#html.startFieldset( legend="User Details" )#
								#html.hiddenField( name="authorID",bind=prc.author )#
								<!--- Fields --->
								#html.textField(
									name="firstName",
									bind=prc.author,
									label="*First Name:",
									required="required",
									size="50",
									class="form-control",
									wrapper="div class=controls",
									labelClass="control-label",
									groupWrapper="div class=form-group"
								)#
								#html.textField(name="lastName",
									bind=prc.author,
									label="*Last Name:",
									required="required",
									size="50",
									class="form-control",
									wrapper="div class=controls",
									labelClass="control-label",
									groupWrapper="div class=form-group"
								)#
								#html.inputField(
									name="email",
									type="email",
									bind=prc.author,
									label="*Email:",
									required="required",
									size="50",
									class="form-control",
									wrapper="div class=controls",
									labelClass="control-label",
									groupWrapper="div class=form-group"
								)#
								#html.textField(
									name="username",
									bind=prc.author,
									label="*Username:",
									required="required",
									size="50",
									class="form-control username",
									wrapper="div class=controls",
									labelClass="control-label",
									groupWrapper="div class=form-group"
								)#
								<cfif NOT prc.author.isLoaded()>
									#html.passwordField(
										name="password",
										bind=prc.author,
										label="*Password:",
										required="required",
										size="50",
										class="form-control",
										wrapper="div class=controls",
										labelClass="control-label",
										groupWrapper="div class=form-group"
									)#
								</cfif>

								<!--- Active --->
								<cfif prc.oAuthor.checkPermission( "AUTHOR_ADMIN" )>
									#html.select(
										label="Active User:",
										name="isActive",
										options="yes,no",
										style="width:200px",
										bind=prc.author,
										class="form-control input-sm",
										wrapper="div class=controls",
										labelClass="control-label",
										groupWrapper="div class=form-group"
									)#
									<!--- Roles --->
									#html.select(
										label="User Role:",
										name="roleID",
										options=prc.roles,
										column="roleID",
										nameColumn="role",
										bind=prc.author.getRole(),
										style="width:200px",
										class="form-control input-sm",
										wrapper="div class=controls",
										labelClass="control-label",
										groupWrapper="div class=form-group"
									)#
								<cfelse>
									<label>Active User: </label> <span class="textRed">#prc.author.getIsActive()#</span><br/>
									<label>User Role: </label> <span class="textRed">#prc.author.getRole().getRole()#</span><br/>
								</cfif>
								
								<!--- Biography --->
								#html.textarea(name="biography",
									label="Biography or Notes About The User:",
									bind=prc.author,
									rows="10",
									class="form-control",
									wrapper="div class=controls",
									labelClass="control-label",
									groupWrapper="div class=form-group"
								)#

								#html.endFieldSet()#
								
								<!--- Action Bar --->
								<cfif prc.oAuthor.checkPermission( "AUTHOR_ADMIN" ) OR prc.author.getAuthorID() EQ prc.oAuthor.getAuthorID()>
								<div class="form-actions">
									<input type="submit" value="Save Details" class="btn btn-danger">
								</div>
								</cfif>
								
							#html.endForm()#
						</div>

						<cfif prc.author.isLoaded()>
							<!--- Change Password --->
							<div class="tab-pane" id="password">
							#html.startForm(name="authorPasswordForm",action=prc.xehAuthorChangePassword,novalidate="novalidate",class="form-vertical" )#
								#html.startFieldset(legend="Change Password" )#
								#html.hiddenField(name="authorID",bind=prc.author)#
								<!--- Fields --->
								#html.passwordField(name="password",label="Password:",required="required",size="50",class="form-control",wrapper="div class=controls",labelClass="control-label",groupWrapper="div class=form-group" )#
								#html.passwordField(name="password_confirm",label="Confirm Password:",required="required",size="50",class="form-control",wrapper="div class=controls",labelClass="control-label",groupWrapper="div class=form-group" )#
								#html.endFieldSet()#
								
								<!--- Action Bar --->
								<cfif prc.oAuthor.checkPermission( "AUTHOR_ADMIN" ) OR prc.author.getAuthorID() EQ prc.oAuthor.getAuthorID()>
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

							<!--- Latest Edits --->
							<cfif prc.oAuthor.checkPermission( "ENTRIES_ADMIN,ENTRIES_EDITOR,PAGES_ADMIN,PAGES_EDITOR,CONTENTSTORE_ADMIN,CONTENTSTORE_EDITOR" )>
								<div class="tab-pane" id="latestEdits">
									#html.startFieldset( legend="Latest Edits" )#
										<!--- latest edits --->
										<table name="latestEditsTable" id="latestEditsTable" class="table table-hover table-condensed table-striped" width="100%">
											<thead>
												<tr>
													<th>Title</th>
													<th>Date</th>
													<th width="125">Type</th>
													<th width="50" class="text-center"><i class="fa fa-globe fa-lg" title="Published"></i></th>
													<th width="100" class="text-center">Actions</th>
												</tr>
											</thead>
											<tbody>
												<cfloop array="#prc.latestEdits#" index="thisContent">
												<tr id="contentID-#thisContent.getContentID()#" data-contentID="#thisContent.getContentID()#"
													<cfif thisContent.isExpired()>
														class="danger"
													<cfelseif thisContent.isPublishedInFuture()>
														class="success"
													<cfelseif !thisContent.isContentPublished()>
														class="warning"
													</cfif>>
													<td>#thisContent.getTitle()#</td>
													<td>#thisContent.getActiveContent().getDisplayCreatedDate()#</td>
													<td>#thisContent.getContentType()#</td>
													<td class="text-center">
														<cfif thisContent.isExpired()>
															<i class="fa fa-clock-o fa-lg textRed" title="Content has expired on ( (#thisContent.getDisplayExpireDate()#))"></i>
															<span class="hidden">expired</span>
														<cfelseif thisContent.isPublishedInFuture()>
															<i class="fa fa-fighter-jet fa-lg textBlue" title="Content Publishes in the future (#thisContent.getDisplayPublishedDate()#)"></i>
															<span class="hidden">published in future</span>
														<cfelseif thisContent.isContentPublished()>
															<i class="fa fa-check fa-lg textGreen" title="Content Published"></i>
															<span class="hidden">published in future</span>
														<cfelse>
															<i class="fa fa-times fa-lg textRed" title="Content Draft"></i>
															<span class="hidden">draft</span>
														</cfif>
													</td>
													<td class="text-center">
													<!--- Content Actions --->
													<div class="btn-group btn-xs">
												    	<!--- Editor --->
											    		<cfif thisContent.getContentType() == "page">
															<a class="btn btn-info btn-sm" href="#event.buildLink( prc.xehPagesEditor )#/contentID/#thisContent.getContentID()#" title="Edit Page"><i class="fa fa-edit fa-lg"></i></a>
														<cfelseif thisContent.getContentType() == "contentStore">
															<a class="btn btn-info btn-sm" href="#event.buildLink( prc.xehContentStoreEditor )#/contentID/#thisContent.getContentID()#" title="Edit ContentStore"><i class="fa fa-edit fa-lg"></i></a>
														<cfelse>
															<a class="btn btn-info btn-sm" href="#event.buildLink( prc.xehBlogEditor )#/contentID/#thisContent.getContentID()#" title="Edit Entry"><i class="fa fa-edit fa-lg"></i></a>
														</cfif>
														<!--- View in Site --->
														<cfif listFindNoCase( "page,entry", thisContent.getContentType() )>
															<cfif thisContent.getContentType() == "page">
																<a class="btn btn-info btn-sm" href="#prc.CBHelper.linkPage( thisContent )#" target="_blank" title="View in Site"><i class="fa fa-eye fa-lg"></i></a>
															<cfelse>
																<a class="btn btn-info btn-sm" href="#prc.CBHelper.linkEntry( thisContent )#" target="_blank" title="View in Site"><i class="fa fa-eye fa-lg"></i></a>
															</cfif>
														</cfif>
												    </div>
												</td>
												</tr>
												</cfloop>
											</tbody>
										</table>
										<cfif !arrayLen( prc.latestEdits )>
											<div class="alert alert-info">
											No Records Found
											</div>											
										</cfif>
									#html.endFieldSet()#
								</div>
							</cfif>

						</cfif>
						<!--- cbadmin Event --->
						#announceInterception( "cbadmin_onAuthorEditorContent" )#
                   	</div>
                   	<!--- End Tab Content--->
                </div>
            </div>
 		</div>
    </div>

    <cfif prc.author.isLoaded()>
    <div class="col-md-4">
    	<div class="panel panel-primary">
			<div class="panel-heading">
				<h3 class="panel-title"><i class="fa fa-eye"></i> Details</h3>
			</div>
			<div class="panel-body">
				<div class="pull-left margin10">
					#getModel( "Avatar@cb" ).renderAvatar( email=prc.author.getEmail(), size="40" )#
				</div>
				<div class="margin10">
					<a title="Email Me!" href="mailto:#prc.author.getEmail()#">#prc.author.getName()#</a>
				</div>
				
				<!--- Persisted Info --->
				<table class="table table-condensed table-hover table-striped" width="100%">
					<tr>
						<th width="105" class="textRight">Last Login</th>
						<td>
							#prc.author.getDisplayLastLogin()#
						</td>
					</tr>
					<tr>
						<th width="105" class="textRight">Created Date</th>
						<td>
							#prc.author.getDisplayCreatedDate()#
						</td>
					</tr>
					<tr>
						<th width="105" class="textRight">Role</th>
						<td>
							#prc.author.getRole().getRole()#
						</td>
					</tr>
				</table>
				
				<p></p>
				
				<!---Gravatar info --->
				<cfif prc.cbSettings.cb_gravatar_display>
				<div class="bg-helper bg-info clearfix">
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
	</cfif>
</div>
</cfoutput>