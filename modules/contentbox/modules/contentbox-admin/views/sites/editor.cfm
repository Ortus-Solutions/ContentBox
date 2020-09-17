<cfoutput>
	<div class="row">
		<div class="col-md-12" id="main-content-slot">

			<div class="panel panel-default">

				<!--- Heading --->
				<div class="panel-heading">

					<!--- Top Actions --->
					<div class="floatRight mt10">
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
					<div class="size16 p10">
						<i class="fas fa-globe"></i>
						#prc.site.isLoaded() ? 'Update' : 'Create'# Site
					</div>

				</div>

				<div class="panel-body">

					<!--- Messageboxes --->
					#getInstance( "messagebox@cbMessagebox" ).renderIt()#

					<!--- Form --->
					#html.startForm(
						name 		: "siteForm",
						action 		: prc.xehSiteSave,
						novalidate 	: "novalidate",
						class 		: "form-vertical"
					)#
						#html.startFieldset( legend="Site Details" )#

							#html.hiddenField( name="siteId", bind=prc.site )#

							#html.textField(
								name    		= "name",
								bind    		= prc.site,
								label   		= "*Name:",
								required		= "required",
								size    		= "255",
								class   		= "form-control",
								title 			= "The human readable name",
								wrapper 		= "div class=controls",
								labelClass 		= "control-label",
								groupWrapper 	= "div class=form-group"
							)#

							#html.textField(
								name    		= "slug",
								bind    		= prc.site,
								label   		= "*Slug:",
								required		= "required",
								size    		= "255",
								title 			= "The internal unique identifier for the site",
								class   		= "form-control",
								wrapper 		= "div class=controls",
								labelClass 		= "control-label",
								groupWrapper 	= "div class=form-group",
								disabled 		= prc.site.getSlug() eq 'default' ? true : false
							)#

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
								Below you can register the full name or a regular expression to match.
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
								placeholder 	= "mycoolsite.com"
							)#

							<!--- Domain Name --->
							<div class="form-group">
								#html.label(
									class   = "control-label",
									field   = "domain",
									content = "*Qualified Domain:"
								)#

								<p>
									The actual domain name so we can construct URLs to this site.
								</p>

								<div class="input-group">
									<span class="input-group-addon">https://</span>
									<input
										name="domain"
										id="domain"
										type="text"
										class="form-control"
										value="#prc.site.getDomain()#">
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
													value="#thispage.getSlug()#"
													<cfif
													prc.site.getHomePage()
													eq
													thisPage.getSlug()>selected="selected"</cfif>
												>
													#thisPage.getSlug()#
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
										<option value="#themeKey#">
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