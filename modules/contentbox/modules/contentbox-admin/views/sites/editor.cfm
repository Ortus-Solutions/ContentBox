<cfoutput>
	<div class="row">
		<div class="col-md-12" id="main-content-slot">

			<div class="panel panel-default">

				<!--- Heading --->
				<div class="panel-heading">

					<!--- Top Actions --->
					<div class="float-right mt10">
						<!--- Back button --->
						<a
							class="btn btn-sm btn-default"
							href="#event.buildLink( prc.xehSitesManager )#"
							title="Back to listing"
						>
							<i class="fas fa-chevron-left"></i> Cancel
						</a>
					</div>

					<!--- Title --->
					<div class="size16 p10 flex gap-x-2">

						<i class="fas fa-globe"></i>

						<span>
							#prc.site.isLoaded() ? prc.site.getSlug() : 'Create Site'#
						</span>

						<!--- Published Marker --->
						<cfif prc.site.isLoaded()>
							<cfif prc.site.getIsActive()>
								<span class="label label-success">Published</span>
							<cfelse>
								<span class="label label-danger">Disabled</span>
							</cfif>
						</cfif>
					</div>

				</div>

				<div class="panel-body">

					<!--- Messageboxes --->
					#cbMessageBox().renderit()#

					<!--- Form --->
					#html.startForm(
						name 		: "siteForm",
						action 		: prc.xehSiteSave,
						novalidate 	: "novalidate",
						class 		: "form-vertical"
					)#
						#html.startFieldset( legend="Site Details" )#

							#html.hiddenField( name="siteID", bind=prc.site )#

							#html.textField(
								name    		= "name",
								bind    		= prc.site,
								label   		= "*Name:",
								required		= "required",
								size    		= "255",
								class   		= "form-control",
								title 			= "The human readable name",
								placeholder = "My Awesome Site",
								wrapper 		= "div class=controls",
								labelClass 		= "control-label",
								groupWrapper 	= "div class=form-group"
							)#

							<div class="form-group">
								#html.label(
									class   = "control-label",
									field   = "slug",
									content = "*Unique Slug:"
								)#

								<cfif prc.site.isLoaded()>
									<div class="alert alert-warning">
										The slug cannot be changed once the site has been created.
									</div>
								<cfelse>
									<div class="alert alert-danger">
										The slug cannot be changed once the site has been created. Choose wisely!
									</div>
								</cfif>

								#html.textField(
									name    		= "slug",
									bind    		= prc.site,
									required		= "required",
									size    		= "255",
									title 			= "The internal unique identifier for the site",
									class   		= "form-control",
									wrapper 		= "div class=controls",
									placeholder = "my-awesome-site",
									disabled 		= prc.site.isLoaded() ? true : false
								)#
							</div>

							#html.textField(
								name            = "tagline",
								bind    		= prc.site,
								label           = "Tag Line:",
								size    		= "255",
								class           = "form-control",
								title           = "A cool tag line that can appear anywhere in your site",
								wrapper         = "div class=controls",
								labelClass      = "control-label",
								groupWrapper    = "div class=form-group"
							)#

							#html.textarea(
								name            = "description",
								label           = "Description:",
								bind    		= prc.site,
								rows            = "3",
								class           = "form-control mde",
								title           = "Your site description, also used in the HTML description meta tag",
								wrapper         = "div class=controls",
								labelClass      = "control-label",
								groupWrapper    = "div class=form-group"
							)#

							#html.textarea(
								name            = "keywords",
								label           = "Keywords:",
								bind    		= prc.site,
								rows            = "3",
								class           = "form-control",
								title           = "A comma delimited list of keywords to be used in the HTML keywords meta tag",
								wrapper         = "div class=controls",
								labelClass      = "control-label",
								groupWrapper    = "div class=form-group"
							)#

						#html.endFieldset()#

						#html.startFieldset( legend="Site Detection" )#

							<p>
								Site detection is done against the incoming domain name found in the <code>cgi</code> scope.
								Below you can register the full name or a
								<a href="https://www.regextester.com/" placeholder="_blank">regular expression</a>
								to match.
							</p>

							#html.textField(
								name    		= "domainRegex",
								bind    		= prc.site,
								label   		= "*Domain Expressions:",
								required		= "required",
								size    		= "255",
								title 			= "A domain name or regular expression that will be used to match the incoming domain with.",
								class   		= "form-control",
								wrapper 		= "div class=controls",
								labelClass 		= "control-label",
								groupWrapper 	= "div class=form-group",
								placeholder 	= "mycoolsite\.com"
							)#

							<!--- Domain Name --->
							<div class="form-group">
								#html.label(
									class   = "control-label",
									field   = "domain",
									content = "*Domain Base URL:"
								)#

								<p>
									The domain base URL so we can construct URLs to this site.
								</p>

								<div class="input-group">
									<span class="input-group-addon">https://</span>
									<input
										name="domain"
										id="domain"
										type="text"
										class="form-control"
										value="#prc.site.getDomain()#"
										placeholder="mydomain.com"
									>
								</div>
							</div>

						#html.endFieldSet()#

						#html.startFieldset( legend="Site Features" )#

							<!--- HomePage --->
							<cfif prc.site.isLoaded()>
								<div class="form-group">
									<label class="control-label" for="homePage">Home Page:</label>
									<div class="controls">

										<p>
											Choose what to show on the homepage of your site:
										</p>

										<select name="homePage" id="homePage" class="form-control">
											<!--- Only show blog if this is a new site or the blog is enabled --->
											<cfif !prc.site.isLoaded() || prc.site.getIsBlogEnabled()>
												<option
													value="cbBlog"
													<cfif prc.site.getHomePage() eq "cbBlog">selected="selected"</cfif>
												>
													Latest Blog Entries
												</option>
											</cfif>

											<!--- The pages list --->
											<cfloop array="#prc.pages#" index="thisPage" >
												<option
													value="#thispage[ "slug" ]#"

													<cfif prc.site.getHomePage() eq thisPage[ "slug" ]>
														selected="selected"
													</cfif>
												>
													#thisPage[ "title" ]#
												</option>
											</cfloop>
										</select>
									</div>
								</div>
							</cfif>

							<!-- Theme -->
							<div class="form-group">
								<label class="control-label" for="activeTheme">
									Site Theme:
								</label>

								<p>
									Choose the theme the site will be using for rendering content.
								</p>

								<div class="controls">
									<select
										name="activeTheme"
										id="activeTheme"
										class="form-control"
									>
									<cfloop collection="#prc.themes#" item="themeKey">
										<option
											value="#themeKey#"

											<cfif prc.site.getActiveTheme() eq themeKey>
												selected="selected"
											</cfif>
										>
											#prc.themes[ themeKey ].themeName#
										</option>
									</cfloop>
									</select>
								</div>
							</div>

							<!--- Blog Enabled --->
							<div class="form-group">
								#html.label(
									class   = "control-label",
									field   = "isBlogEnabled",
									content = "Enable Blog:"
								)#

								<p>
									Every ContentBox site can have a blog enabled by default.
								</p>

								<div class="controls">
									#html.checkbox(
										name    = "isBlogEnabled_toggle",
										data	= { toggle: 'toggle', match: 'isBlogEnabled' },
										checked	= prc.site.getIsBlogEnabled()
									)#
									#html.hiddenField(
										name	= "isBlogEnabled",
										value 	= prc.site.getIsBlogEnabled()
									)#
								</div>
							</div>

							<!--- Sitemap --->
							<div class="form-group">
								#html.label(
									class   = "control-label",
									field   = "isSitemapEnabled",
									content = "Enable Sitemap Features:"
								)#

								<p>
									If enabled, you will be able to access the site map via <code>/sitemap</code> and can even add format extensions, e.g: <code>sitemap.json, sitemap.xml, sitemap.txt</code>
								</p>

								<div class="controls">
									#html.checkbox(
										name    = "isSitemapEnabled_toggle",
										data	= { toggle: 'toggle', match: 'isSitemapEnabled' },
										checked	= prc.site.getIsSitemapEnabled()
									)#
									#html.hiddenField(
										name	= "isSitemapEnabled",
										value 	= prc.site.getIsSitemapEnabled()
									)#
								</div>
							</div>

							<!--- Site Admin Bar --->
							<div class="form-group">
								#html.label(
									class   = "control-label",
									field   = "adminBar",
									content = "Enable Site Admin Bar:"
								)#

								<p>
									If enabled, logged in and with the right permissions, you will see a ContentBox Floating Admin Bar in your site to help you edit and manage content from the UI.
								</p>

								<div class="controls">
									#html.checkbox(
										name    = "adminBar_toggle",
										data	= { toggle: 'toggle', match: 'adminBar' },
										checked	= prc.site.getAdminBar()
									)#
									#html.hiddenField(
										name	= "adminBar",
										bind 	= prc.site
									)#
								</div>
							</div>

							<!--- Site SSL --->
							<div class="form-group">
								#html.label(
									class 	: "control-label",
									field 	: "isSSL",
									content : "Site Force SSL (Secure Sockets Layer):"
								)#

								<p>
									You can force SSL encryption for the entire site. If a non-secure request is made ContentBox will relocate it and enforce SSL.
									Make sure your server has a valid SSL Certificate.
								</p>

								<div class="controls">
									#html.checkbox(
										name    = "isSSL_toggle",
										data	= { toggle: 'toggle', match: 'isSSL' },
										checked	= prc.site.getIsSSL()
									)#
									#html.hiddenField(
										name	= "isSSL",
										bind 	= prc.site
									)#
								</div>
							</div>

							<!--- Powered by Header --->
							<div class="form-group">
								#html.label(
									class   = "control-label",
									field   = "poweredByHeader",
									content = "Send ContentBox Identity Header:"
								)#

								<p>
									ContentBox will emit an indentiy header <code>x-powered-by:contentbox</code> if enabled.
								</p>

								<div class="controls">
									#html.checkbox(
										name    = "poweredByHeader_toggle",
										data	= { toggle: 'toggle', match: 'poweredByHeader' },
										checked	= prc.site.getPoweredByHeader()
									)#
									#html.hiddenField(
										name	= "poweredByHeader",
										bind 	= prc.site
									)#
								</div>
							</div>


							<!--- Site Disable/Enable --->
							<cfif prc.site.getSlug() neq "default">
								<div class="form-group alert alert-danger">
									#html.label(
										class   = "control-label",
										field   = "isActive",
										content = "Site Enabled:"
									)#

									<p>
										ContentBox can disable a site from being served by disabling it. Diabling a site does not delete or unpublish any items. It is a nice toggle switch.
									</p>

									<div class="controls">
										#html.checkbox(
											name    = "isActive_toggle",
											data	= { toggle: 'toggle', match: 'isActive' },
											checked	= prc.site.getIsActive()
										)#
										#html.hiddenField(
											name	= "isActive",
											bind 	= prc.site
										)#
									</div>
								</div>
							</cfif>

						#html.endFieldSet()#

						<!--- Action Bar --->
						<div class="form-actions">
							<button
								class="btn btn-default"
								onclick="return to( '#event.buildLink( prc.xehSitesManager )#' )"
							>
								Cancel
							</button>
							<button
								type="submit"
								class="btn btn-danger"
							>
								Save
							</button>
						</div>

					#html.endForm()#
				</div>
			 </div>
		</div>
	</div>
</cfoutput>