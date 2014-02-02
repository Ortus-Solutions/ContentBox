<cfoutput>
#html.startForm(name="settingsForm", action=prc.xehSaveSettings, novalidate="novalidate")#
#html.anchor(name="top")#
<!--============================Main Column============================-->
<div class="main" id="main_column">
	<div class="box">
		<!--- Body Header --->
		<div class="header">
			<i class="icon-wrench icon-large"></i>
			ContentBox Settings
		</div>
		<!--- Body --->
		<div class="body">

    		<!--- messageBox --->
    		#getPlugin("MessageBox").renderit()#
    
    		<p>From here you can manage all of the major ContentBox configuration options.</p>
    
    		<!--- Vertical Nav --->
    		<div class="tabbable tabs-left">
    			<!--- Documentation Navigation Bar --->
    			<ul class="nav nav-tabs">
    				<li class="active"><a href="##site_options" data-toggle="tab"><i class="icon-cog icon-large"></i> Site Options</a></li>
    				<li><a href="##dashboard_options" data-toggle="tab"><i class="icon-desktop icon-large"></i> Admin Options</a></li>
    				<li><a href="##content_options" data-toggle="tab"><i class="icon-file-alt icon-large"></i> Content Options</a></li>
    				<li><a href="##editor_options" data-toggle="tab"><i class="icon-edit icon-large"></i> Editor Options</a></li>
    				<li><a href="##mediamanager" data-toggle="tab"><i class="icon-th icon-large"></i> Media Manager</a></li>
    				<li><a href="##gravatars" data-toggle="tab"><i class="icon-user icon-large"></i> Gravatars</a></li>
    				<li><a href="##notifications" data-toggle="tab"><i class="icon-bullhorn icon-large"></i> Notifications</a></li>
                    <li><a href="##email_server" data-toggle="tab"><i class="icon-envelope-alt icon-large"></i> Mail Server</a></li>
    				<li><a href="##search_options" data-toggle="tab"><i class="icon-search icon-large"></i> Search Options</a></li>
    				<li><a href="##rss_options" data-toggle="tab"><i class="icon-rss icon-large"></i> RSS</a></li>
    				<!--- cbadmin Event --->
    				#announceInterception("cbadmin_onSettingsNav")#
    			</ul>
				<!--- Documentation Panes --->
    			<!--- Tab Content --->
    			<div class="tab-content">
    				

                    <!--- ********************************************************************* --->
                    <!---                           SITE OPTIONS                                --->
                    <!--- ********************************************************************* --->
                    
    				<div class="tab-pane active" id="site_options">
    					<fieldset>
    					<legend><i class="icon-cog icon-large"></i> <strong>Site Options</strong></legend>
    					 	<!--- Site Name  --->
    						#html.textField(name="cb_site_name",label="Site Name:",value=prc.cbSettings.cb_site_name,class="textfield width98",title="The global name of this ContentBox installation",wrapper="div class=controls",labelClass="control-label",groupWrapper="div class=control-group")#
    						<!--- Tag Line --->
    						#html.textField(name="cb_site_tagline",label="Site Tag Line:",value=prc.cbSettings.cb_site_tagline,class="textfield width98",title="A cool tag line that can appear anywhere in your site",wrapper="div class=controls",labelClass="control-label",groupWrapper="div class=control-group")#
    						<!--- Description --->
    						#html.textarea(name="cb_site_description",label="Site Description:",value=prc.cbSettings.cb_site_description,rows="3",title="Your site description, also used in the HTML description meta tag",wrapper="div class=controls",labelClass="control-label",groupWrapper="div class=control-group")#
    						<!--- Keywords --->
                            <div class="control-group">
                                <label class="control-label" for="cb_site_keywords">Site Keywords:</label>
                                <div class="controls">
                                    <small>Used in the meta tags of your site.</small><br/>
    								#html.textarea(name="cb_site_keywords",value=prc.cbSettings.cb_site_keywords,rows="3",title="A comma delimited list of keywords to be used in the HTML keywords meta tag")#
                                </div>
                            </div>
    						<!--- HomePage --->
							<div class="control-group">
                                <label class="control-label" for="cb_site_homepage">Home Page Displays:</label>
                                <div class="controls">
                                    <small>Choose the latest blog entries or a ContentBox page.</small><br/>
            						<select name="cb_site_homepage" id="cb_site_homepage" class="width98">
            							<option value="cbBlog" <cfif prc.cbSettings.cb_site_homepage eq "cbBlog">selected="selected"</cfif>>Latest Blog Entries</option>
            							<cfloop array="#prc.pages#" index="thisPage" >
            							<option value="#thispage.getSlug()#" <cfif prc.cbSettings.cb_site_homepage eq thisPage.getSlug()>selected="selected"</cfif>>#thisPage.getSlug()#</option>
            							</cfloop>
            						</select>
                                </div>
                            </div>	
    						<!--- Site SSL --->
							<div class="control-group">
                                #html.label(class="control-label",field="cb_site_ssl",content="Site Force SSL (Secure Sockets Layer):")#
                                <div class="controls">
                                    <small>You can enable SSL encryption for the entire site.</small><br/>
            						#html.radioButton(name="cb_site_ssl",checked=prc.cbSettings.cb_site_ssl,value=true)# Yes
            						#html.radioButton(name="cb_site_ssl",checked=not prc.cbSettings.cb_site_ssl,value=false)# No
                                </div>
                            </div>	

                            <!--- Powered by Header --->
                            <div class="control-group">
                                #html.label(class="control-label",field="cb_site_poweredby",content="Send ContentBox Identity Header:")#
                                <div class="controls">
                                    <small>ContentBox will emit an indentiy header 'x-powered-by:contentbox' if enabled.</small><br/>
                                    #html.radioButton(name="cb_site_poweredby",checked=prc.cbSettings.cb_site_poweredby,value=true)# Yes
                                    #html.radioButton(name="cb_site_poweredby",checked=not prc.cbSettings.cb_site_poweredby,value=false)# No
                                </div>
                            </div>

    					</fieldset>
    					<!---Blog Entries --->
    					<fieldset>
    					<legend><i class="icon-quote-left icon-large"></i> <strong>Blog Options</strong></legend>
    						<!--- Disable Blog --->
							<div class="control-group">
                                #html.label(class="control-label",field="cb_site_disable_blog",content="Disable Blog:")#
                                <div class="controls">
                                    <small>You can disable the Blog in this entire ContentBox. This does not delete data, it just disables blog features. Also
    							   	remember to change the <strong>Home Page</strong> above to a real page and not the blog.</small><br/>
    								#html.radioButton(name="cb_site_disable_blog",checked=prc.cbSettings.cb_site_disable_blog,value=true)# Yes
    								#html.radioButton(name="cb_site_disable_blog",checked=not prc.cbSettings.cb_site_disable_blog,value=false)# No
                                </div>
                            </div>	
    						<!--- Entry Point --->
							<div class="control-group">
                                #html.label(class="control-label",field="cb_site_blog_entrypoint",content="Blog Entry Point:")#
                                <div class="controls">
                                    <small>Choose the entry point in the URL to trigger the blog engine. The usual defaul entry point pattern is 
    								<strong>blog</strong>. Do not use symbols or slashes (/ \)<br/></small>
                                    <code>#prc.cb.linkHome()#</code> #html.textField(name="cb_site_blog_entrypoint", value=prc.cbSettings.cb_site_blog_entrypoint, class="textfield")#
                                </div>
                            </div>	
    					</fieldset>
    					<!--- Site Maintenance --->
    					<fieldset>
    					<legend><i class="icon-ambulance icon-large"></i> <strong>Site Maintenance</strong></legend>
    					 	<p>You can put your entire site in maintenance mode if you are doing upgrades or anything funky!</p>
    						<!--- Site maintenance --->
							<div class="control-group">
                                #html.label(class="control-label",field="cb_site_maintenance",content="Site Maintenance:")#
                                <div class="controls">
                                    #html.radioButton(name="cb_site_maintenance",checked=prc.cbSettings.cb_site_maintenance,value=true)# Yes
    								#html.radioButton(name="cb_site_maintenance",checked=not prc.cbSettings.cb_site_maintenance,value=false)# No
                                </div>
                            </div>
    						<!--- Maintenance Message --->
							<div class="control-group">
                                #html.label(class="control-label",field="cb_site_maintenance_message",content="Offline Message: ")#
                                <div class="controls">
                                    <small>The message to show users once the site is in maintenance mode, HTML is ok.</small><br/>
    								#html.textarea(name="cb_site_maintenance_message",value=prc.cbSettings.cb_site_maintenance_message,rows="3",title="Make it meaningful?")#
                                </div>
                            </div>
    					</fieldset>
    				</div>

    				<!--- ********************************************************************* --->
                    <!---                           ADMIN OPTIONS                               --->
                    <!--- ********************************************************************* --->
                    
    				<div class="tab-pane" id="dashboard_options">
    					<fieldset>
    						<legend><i class="icon-desktop icon-large"></i> <strong>Admin Options</strong></legend>
    					 	<!--- Admin SSL --->
							<div class="control-group">
                                #html.label(class="control-label",field="cb_admin_ssl",content="Admin Force SSL (Secure Sockets Layer):")#
                                <div class="controls">
                                    <small>You can enable SSL encryption for the administrator module.</small><br/>
    								#html.radioButton(name="cb_admin_ssl",checked=prc.cbSettings.cb_admin_ssl,value=true)# Yes
    								#html.radioButton(name="cb_admin_ssl",checked=not prc.cbSettings.cb_admin_ssl,value=false)# No
                                </div>
                            </div>
							<!--- Default Themes --->
							<div class="control-group">
                                <label class="control-label" for="cb_admin_theme">Default Admin Theme:</label>
                                <div class="controls">
                                    <small>Choose the theme to use for the ContentBox administrator</small><br/>
            						#html.select(name="cb_admin_theme", 
            							 options=prc.adminThemes,
            							 column="name",
            							 nameColumn="displayName",
            							 selectedValue=prc.cbSettings.cb_admin_theme)#
                                </div>
                            </div>	
    					</fieldset>
    					<fieldset>
    						<legend><i class="icon-dashboard icon-large"></i>  Dashboard Options</legend>
    						
                            <!--- Tag Line --->
                            #html.textField( name="cb_dashboard_welcome_title", label="Welcome Title:", value=prc.cbSettings.cb_dashboard_welcome_title, class="textfield width98", wrapper="div class=controls", labelClass="control-label", groupWrapper="div class=control-group")#
                            <!--- Description --->
                            #html.textarea(name="cb_dashboard_welcome_body", label="Welcome Body:", value=prc.cbSettings.cb_dashboard_welcome_body,rows="3", wrapper="div class=controls", labelClass="control-label", groupWrapper="div class=control-group")#
                            
    						<!--- Dashboard Feed --->
							<div class="control-group">
                                <label class="control-label" for="cb_dashboard_newsfeed">News Feed</label>
                                <div class="controls">
                                    <small>The RSS feed to present in the dashboard. Leave blank if you don't want any news to display.</small><br/>
    								#html.textField(name="cb_dashboard_newsfeed", value=prc.cbSettings.cb_dashboard_newsfeed, class="textfield width98", title="The RSS feed to present in the dashboard")#
                                </div>
                            </div>
    						<!--- Recent Feed Count --->
							<div class="control-group">
                                <label class="control-label" for="cb_dashboard_newsfeed_count">News Feed Count</label>
                                <div class="controls">
                                    <select name="cb_dashboard_newsfeed_count" id="cb_dashboard_newsfeed_count">
            							<cfloop from="5" to="50" step="5" index="i">
            								<option value="#i#" <cfif i eq prc.cbSettings.cb_dashboard_newsfeed_count>selected="selected"</cfif>>#i#</option>
            							</cfloop>
            						</select>
                                </div>
                            </div>
    						<!--- Recent Entries --->
							<div class="control-group">
                                <label class="control-label" for="cb_dashboard_recentEntries">Recent Entries Count</label>
                                <div class="controls">
                                    <select name="cb_dashboard_recentEntries" id="cb_dashboard_recentEntries">
            							<cfloop from="5" to="50" step="5" index="i">
            								<option value="#i#" <cfif i eq prc.cbSettings.cb_dashboard_recentEntries>selected="selected"</cfif>>#i#</option>
            							</cfloop>
            						</select>
                                </div>
                            </div>    
    						<!--- Recent Pages --->
							<div class="control-group">
                                <label class="control-label" for="cb_dashboard_recentPages">Recent Pages Count</label>
                                <div class="controls">
                                    <select name="cb_dashboard_recentPages" id="cb_dashboard_recentPages">
            							<cfloop from="5" to="50" step="5" index="i">
            								<option value="#i#" <cfif i eq prc.cbSettings.cb_dashboard_recentPages>selected="selected"</cfif>>#i#</option>
            							</cfloop>
            						</select>
                                </div>
                            </div>
							<!--- Recent ContentStore --->
							<div class="control-group">
                                <label class="control-label" for="cb_dashboard_recentContentStore">Recent Content Store Count</label>
                                <div class="controls">
                                    <select name="cb_dashboard_recentContentStore" id="cb_dashboard_recentContentStore">
            							<cfloop from="5" to="50" step="5" index="i">
            								<option value="#i#" <cfif i eq prc.cbSettings.cb_dashboard_recentContentStore>selected="selected"</cfif>>#i#</option>
            							</cfloop>
            						</select>
                                </div>
                            </div>  
    						<!--- Recent Comments--->
							<div class="control-group">
                                <label class="control-label" for="cb_dashboard_recentComments">Recent Comments Count</label>
                                <div class="controls">
                                    <select name="cb_dashboard_recentComments" id="cb_dashboard_recentComments">
            							<cfloop from="5" to="50" step="5" index="i">
            								<option value="#i#" <cfif i eq prc.cbSettings.cb_dashboard_recentComments>selected="selected"</cfif>>#i#</option>
            							</cfloop>
            						</select>
                                </div>
                            </div>
    					</fieldset>
    					<fieldset>
        					<legend><i class="icon-copy icon-large"></i>  Paging Options</legend>
        
        					<!--- Quick Search --->
							<div class="control-group">
                                <label class="control-label" for="cb_admin_quicksearch_max">Max Quick Search Count:</label>
                                <div class="controls">
                                    <small>The number of results to show in the global search results panel.</small><br/>
                					<select name="cb_admin_quicksearch_max" id="cb_admin_quicksearch_max">
                						<cfloop from="5" to="50" step="5" index="i">
                							<option value="#i#" <cfif i eq prc.cbSettings.cb_admin_quicksearch_max>selected="selected"</cfif>>#i#</option>
                						</cfloop>
                					</select>
                                </div>
                            </div>
        					<!--- Max Blog Post --->
							<div class="control-group">
                                <label class="control-label" for="cb_paging_maxentries">Max Home Page Blog Entries:</label>
                                <div class="controls">
                                    <small>The number of entries to show on the blog before paging is done.</small><br/>
                					<select name="cb_paging_maxentries" id="cb_paging_maxentries">
                						<cfloop from="5" to="50" step="5" index="i">
                							<option value="#i#" <cfif i eq prc.cbSettings.cb_paging_maxentries>selected="selected"</cfif>>#i#</option>
                						</cfloop>
                					</select>
                                </div>
                            </div>
        					<!--- Max Rows --->
							<div class="control-group">
                                <label class="control-label" for="cb_paging_maxrows">Paging Max Rows</label>
                                <div class="controls">
                                    <small>The max rows to use in the administrator.</small><br/>
                					<select name="cb_paging_maxrows" id="cb_paging_maxrows">
                						<cfloop from="5" to="50" step="5" index="i">
                							<option value="#i#" <cfif i eq prc.cbSettings.cb_paging_maxrows>selected="selected"</cfif>>#i#</option>
                						</cfloop>
                					</select>
                                </div>
                            </div>
        					<!--- Max Band Gap --->
							<div class="control-group">
                                <label class="control-label" for="cb_paging_bandgap">Paging Band Gap</label>
                                <div class="controls">
                                    <small>The paging bandgap to use in the administrator.</small><br/>
                					<select name="cb_paging_bandgap" id="cb_paging_bandgap">
                						<cfloop from="1" to="10" index="i">
                							<option value="#i#" <cfif i eq prc.cbSettings.cb_paging_bandgap>selected="selected"</cfif>>#i#</option>
                						</cfloop>
                					</select>
                                </div>
                            </div>
    					</fieldset>
					</div>
    				
                    <!--- ********************************************************************* --->
                    <!---                           CONTENT OPTIONS                             --->
                    <!--- ********************************************************************* --->
                    
    				<div class="tab-pane" id="content_options">
    					<fieldset>
    						<legend><i class="icon-file-alt icon-large"></i>  Content Options</legend>
    
    						<!--- Content Max Versions --->
							<div class="control-group">
                                <label class="control-label" for="cb_versions_max_history">Content Max Versions To Keep:</label>
                                <div class="controls">
                                    <small>The number of versions to keep before older versions are removed.</small><br/>
            						<select name="cb_versions_max_history" id="cb_versions_max_history">
            							<cfloop from="10" to="1000" step="10" index="i">
            								<option value="#i#" <cfif i eq prc.cbSettings.cb_versions_max_history>selected="selected"</cfif>>#i#</option>
            							</cfloop>
            							<option value="" <cfif prc.cbSettings.cb_versions_max_history eq "">selected="selected"</cfif>>Unlimited</option>
            						</select>
                                </div>
                            </div>
    						<!--- Commit Mandatory --->
							<div class="control-group">
                                #html.label(class="control-label",field="cb_versions_commit_mandatory",content="Mandatory commit changelog:")#
                                <div class="controls">
                                    <small>When enabled a commit changelog will have to be entered before any content revision is saved.</small><br/>
            						#html.radioButton(name="cb_versions_commit_mandatory",checked=prc.cbSettings.cb_versions_commit_mandatory,value=true)# Yes
            						#html.radioButton(name="cb_versions_commit_mandatory",checked=not prc.cbSettings.cb_versions_commit_mandatory,value=false)# No
                                </div>
                            </div>
							<!--- Page Excerpts --->
							<div class="control-group">
                                #html.label(class="control-label",field="cb_page_excerpts",content="Allow Page Excerpts:")#
                                <div class="controls">
                                    <small>Enable/Disabled page excerpt summaries.</small><br/>
            						#html.radioButton(name="cb_page_excerpts",checked=prc.cbSettings.cb_page_excerpts,value=true)# Yes
            						#html.radioButton(name="cb_page_excerpts",checked=not prc.cbSettings.cb_page_excerpts,value=false)# No
                                </div>
                            </div>
							<!--- UI Exports --->
							<div class="control-group">
                                #html.label(class="control-label",field="cb_content_uiexport",content="Allow UI content export display:")#
                                <div class="controls">
                                    <small>Enable/Disabled the ability to export pages/blog/etc from the UI via format extensions like pdf,doc,print.</small><br/>
            						#html.radioButton(name="cb_content_uiexport",checked=prc.cbSettings.cb_content_uiexport,value=true)# Yes
            						#html.radioButton(name="cb_content_uiexport",checked=not prc.cbSettings.cb_content_uiexport,value=false)# No
                                </div>
                            </div>
    					</fieldset>
    					<fieldset>
    						<legend><i class="icon-hdd icon-large"></i>  Content Caching</legend>
    
    						<!--- Content Caching --->
							<div class="control-group">
                                #html.label(class="control-label",field="cb_content_caching",content="Activate Page rendered content caching:")#
                                <div class="controls">
                                    <small>Page content will be cached once it has been translated and rendered</small><br/>
    								#html.radioButton(name="cb_content_caching",checked=prc.cbSettings.cb_content_caching,value=true)# Yes
    								#html.radioButton(name="cb_content_caching",checked=not prc.cbSettings.cb_content_caching,value=false)# No
                                </div>
                            </div>
    						<!--- Entry Caching --->
							<div class="control-group">
                                #html.label(class="control-label",field="cb_entry_caching",content="Activate Blog Entry rendered content caching:")#
                                <div class="controls">
                                    <small>Blog entry content will be cached once it has been translated and rendered</small><br/>
            						#html.radioButton(name="cb_entry_caching",checked=prc.cbSettings.cb_entry_caching,value=true)# Yes
            						#html.radioButton(name="cb_entry_caching",checked=not prc.cbSettings.cb_entry_caching,value=false)# No
                                </div>
                            </div>
    						<!--- Custom HTML Caching --->
							<div class="control-group">
                                #html.label(class="control-label",field="cb_contentstore_caching",content="Activate ContentStore rendered content caching:")#
                                <div class="controls">
                                    <small>ContentStore content will be cached once it has been translated and rendered</small><br/>
    								#html.radioButton(name="cb_contentstore_caching",checked=prc.cbSettings.cb_contentstore_caching,value=true)# Yes
    								#html.radioButton(name="cb_contentstore_caching",checked=not prc.cbSettings.cb_contentstore_caching,value=false)# No
                                </div>
                            </div>

                            <!--- Content 203 Header --->
                            <div class="control-group">
                                #html.label(class="control-label",field="cb_content_cachingHeader",content="Send 203 Caching Header:")#
                                <div class="controls">
                                    <small>ContentBox will emit a 203 cache header to indicate that a page is resolved with caching.</small><br/>
                                    #html.radioButton(name="cb_content_cachingHeader",checked=prc.cbSettings.cb_content_cachingHeader,value=true)# Yes
                                    #html.radioButton(name="cb_content_cachingHeader",checked=not prc.cbSettings.cb_content_cachingHeader,value=false)# No
                                </div>
                            </div>

    						<!--- Content Cache Name --->
							<div class="control-group">
                                <label class="control-label" for="cb_content_cacheName">Content Cache Provider:</label>
                                <div class="controls">
                                    <small>Choose the CacheBox provider to cache rendered content (blog,page,contentStore) into.</small><br/>
    								#html.select(name="cb_content_cacheName",options=prc.cacheNames,selectedValue=prc.cbSettings.cb_content_cacheName)#
                                </div>
                            </div>
    						<!--- Content Cache Timeouts --->
							<div class="control-group">
                                <label class="control-label" for="cb_content_cachingTimeout">Content Cache Timeouts:</label>
                                <div class="controls">
                                    <small>The number of minutes a rendered content (blog,page,contentStore) is cached for.</small><br/>
            						<select name="cb_content_cachingTimeout" id="cb_content_cachingTimeout">
            							<cfloop from="5" to="100" step="5" index="i">
            								<option value="#i#" <cfif i eq prc.cbSettings.cb_content_cachingTimeout>selected="selected"</cfif>>#i#</option>
            							</cfloop>
            						</select>
                                </div>
                            </div>
    						<!--- Content Last Access Timeouts --->
							<div class="control-group">
                                <label class="control-label" for="cb_rss_cachingTimeoutIdle">Content Cache Idle Timeouts:</label>
                                <div class="controls">
                                    <small>The number of idle minutes allowed for cached rendered content (blog,page,contentStore) to live if not used. Usually this is less than the timeout you selected above</small><br/>
            						<select name="cb_content_cachingTimeoutIdle" id="cb_content_cachingTimeoutIdle">
            							<cfloop from="5" to="100" step="5" index="i">
            								<option value="#i#" <cfif i eq prc.cbSettings.cb_content_cachingTimeoutIdle>selected="selected"</cfif>>#i#</option>
            							</cfloop>
            						</select>
                                </div>
                            </div>
    					</fieldset>
    				</div>
    				
                    <!--- ********************************************************************* --->
                    <!---                           EDITOR OPTIONS                              --->
                    <!--- ********************************************************************* --->
                    
    				<div class="tab-pane" id="editor_options">
    					<fieldset>
    					<legend><i class="icon-edit icon-large"></i> <strong>Editor Options</strong></legend>
    					 	<!--- Default Editor --->
							<div class="control-group">
                                <label class="control-label" for="cb_editors_default">Default Editor:</label>
                                <div class="controls">
                                    <small>Choose the default editor that all users will use for pages, blogs, custom HTML, etc.</small><br/>
            						#html.select(name="cb_editors_default", 
            							 options=prc.editors,
            							 column="name",
            							 nameColumn="displayName",
            							 selectedValue=prc.cbSettings.cb_editors_default)#
                                </div>
                            </div>	
    						
    						
    						<!--- Default Markup --->
							<div class="control-group">
                                <label class="control-label" for="cb_editors_markup">Default Markup:</label>
                                <div class="controls">
                                    <small>Choose the default markup to use for content objects.</small><br/>
            						#html.select(name="cb_editors_markup", 
            							 options=prc.markups,
            							 selectedValue=prc.cbSettings.cb_editors_markup)#
                                </div>
                            </div>	
    						
    						
    							 
    						<!--- CKEditor  --->
							<div class="control-group">
                                #html.label(class="control-label",field="cb_editors_ckeditor_toolbar",content="CKEditor Standard Toolbar: ")#
                                <div class="controls">
                                    <small>The CKEditor toolbar elements. You can find a list of valid configuration items in <a href="http://docs.ckeditor.com/##!/guide/dev_configuration" target="_blank">CKEditor's documentation</a>.
            						<strong>Please make a backup before editing, just in case.</strong></small><br/>
            						#html.textarea(name="cb_editors_ckeditor_toolbar",value=prc.cbSettings.cb_editors_ckeditor_toolbar,rows="10")#
                                </div>
                            </div>
    						<!--- CKEditor Excerpt --->
							<div class="control-group">
                                #html.label(class="control-label",field="cb_editors_ckeditor_excerpt_toolbar",content="CKEditor Excerpt Toolbar: ")#
                                <div class="controls">
                                    <small>The CKEditor excerpt toolbar elements. You can find a list of valid configuration items in <a href="http://docs.ckeditor.com/##!/guide/dev_configuration" target="_blank">CKEditor's documentation</a>.
            						<strong>Please make a backup before editing, just in case.</strong></small><br/>
            						#html.textarea(name="cb_editors_ckeditor_excerpt_toolbar",value=prc.cbSettings.cb_editors_ckeditor_excerpt_toolbar,rows="10")#
                                </div>
                            </div>	
    						
    						
    						<!--- CKEditor Extra Plugins --->
							<div class="control-group">
                                #html.label(class="control-label",field="cb_editors_ckeditor_extraplugins",content="CKEditor Extra Plugins: ")#
                                <div class="controls">
                                    <small>The CKEditor extra plugins to load. You can find a list of valid configuration items in <a href="http://docs.ckeditor.com/##!/guide/dev_configuration" target="_blank">CKEditor's documentation</a>.
    								<strong>Please make a backup before editing, just in case.</strong></small><br/>
    								#html.textarea(name="cb_editors_ckeditor_extraplugins",value=prc.cbSettings.cb_editors_ckeditor_extraplugins,rows="3")#
                                </div>
                            </div>
    					</fieldset>
    				</div>
    				
                    <!--- ********************************************************************* --->
                    <!---                           MEDIA MANAGER                                --->
                    <!--- ********************************************************************* --->
                    
    				<div class="tab-pane" id="mediamanager">
    					<fieldset>
    					<legend><i class="icon-th icon-large"></i> <strong>Media Manager</strong></legend>
    						<p>From here you can control the media manager settings.</p>
    
    						<!--- Location --->
							<div class="control-group">
                                #html.label(class="control-label",field="",content="Directory Root: ")#
                                <div class="controls">
                                    <small>The relative path or ColdFusion mapping in your server that will be the expanded root of your media manager.</small></br>
    								#html.textField(name="cb_media_directoryRoot",required="required",value=prc.cbSettings.cb_media_directoryRoot,class="textfield width98",title="The directory root of all your media files, make sure it is web accessible please")#
                                </div>
                            </div>
    						<!---Media Providers --->
							<div class="control-group">
                                #html.label(class="control-label",field="",content="Media Providers: ")#
                                <div class="controls">
                                    <small>Media providers are used to deliver your media files securely and with greater flexibility as you can place your entire media root outside of the webroot.</small><br/>
        							<cfloop array="#prc.mediaProviders#" index="thisProvider">
            						<div class="alert alert-info">
            							<label class="control-label" class="radio inline">
            								#html.radioButton(name="cb_media_provider", checked=(prc.cbSettings.cb_media_provider eq thisProvider.name), value=thisProvider.name)#
            								<strong>#thisProvider.displayName#</strong>
            							</label><br/>
            							#thisProvider.description# <br/>
            						</div>
            						</cfloop>
                                </div>
                            </div>
    						<!--- Media Provider Caching --->
							<div class="control-group">
                                #html.label(class="control-label",field="cb_media_provider_caching",content="Provider Caching Headers:")#
                                <div class="controls">
                                    <small>If enabled, the media provider system will issue caching headers for all assets. 
            						You can use the <em>cbcache=true</em> URL param to issue no caching headers on any asset.</small><br/>
            						#html.radioButton(name="cb_media_provider_caching",checked=prc.cbSettings.cb_media_provider_caching,value=true)# Yes
            						#html.radioButton(name="cb_media_provider_caching",checked=not prc.cbSettings.cb_media_provider_caching,value=false)# No
                                </div>
                            </div>
    					</fieldset>
    					<fieldset>
    					<legend><i class="icon-cog icon-large"></i> <strong>FileBrowser Options</strong></legend>
    						
    						<!--- Create Folders --->
							<div class="control-group">
                                #html.label(class="control-label",field="cb_media_createFolders",content="Allow Creation of Folders:")#
                                <div class="controls">
                                    #html.radioButton(name="cb_media_createFolders",checked=prc.cbSettings.cb_media_createFolders,value=true)# Yes
    								#html.radioButton(name="cb_media_createFolders",checked=not prc.cbSettings.cb_media_createFolders,value=false)# No
                                </div>
                            </div>
    						<!--- Delete --->
							<div class="control-group">
                                #html.label(class="control-label",field="cb_media_allowDelete",content="Allow Deletes:")#
                                <div class="controls">
                                    #html.radioButton(name="cb_media_allowDelete",checked=prc.cbSettings.cb_media_allowDelete,value=true)# Yes
    								#html.radioButton(name="cb_media_allowDelete",checked=not prc.cbSettings.cb_media_allowDelete,value=false)# No
                                </div>
                            </div>
    						<!--- Downloads --->
							<div class="control-group">
                                #html.label(class="control-label",field="cb_media_allowDownloads",content="Allow Downloads:")#
                                <div class="controls">
                                    #html.radioButton(name="cb_media_allowDownloads",checked=prc.cbSettings.cb_media_allowDownloads,value=true)# Yes
    								#html.radioButton(name="cb_media_allowDownloads",checked=not prc.cbSettings.cb_media_allowDownloads,value=false)# No
                                </div>
                            </div>
    						<!--- Uploads --->
							<div class="control-group">
                                #html.label(class="control-label",field="cb_media_allowUploads",content="Allow Uploads:")#
                                <div class="controls">
                                    #html.radioButton(name="cb_media_allowUploads",checked=prc.cbSettings.cb_media_allowUploads,value=true)# Yes
    								#html.radioButton(name="cb_media_allowUploads",checked=not prc.cbSettings.cb_media_allowUploads,value=false)# No
                                </div>
                            </div>
    						<!--- Mime Types --->
							<div class="control-group">
                                #html.label(class="control-label",field="cb_media_acceptMimeTypes",content="Accepted Upload File Mime Types")#
                                <div class="controls">
                                    <small>The allowed mime types the <em>CFFile Upload & HTML5 uploads</em> will allow (<a href="http://help.adobe.com/en_US/ColdFusion/9.0/CFMLRef/WSc3ff6d0ea77859461172e0811cbec22c24-738f.html" target="_blank">See Reference</a>).</small></br>
    								#html.textField(name="cb_media_acceptMimeTypes",value=prc.cbSettings.cb_media_acceptMimeTypes,class="textfield width98",title="The accepted mime types of the CFFile upload action. Blank means all files are accepted.")#
                                </div>
                            </div>
    						<!--- size limits --->
    						#html.textField(name="cb_media_html5uploads_maxFileSize",label="HTML5 Uploads - Size Limit (mb):",required="required",value=prc.cbSettings.cb_media_html5uploads_maxFileSize,class="textfield width98",title="The size limit of the HTML5 uploads.",wrapper="div class=controls",labelClass="control-label",groupWrapper="div class=control-group")#
    						#html.textField(name="cb_media_html5uploads_maxFiles",label="HTML5 Uploads - Max Simultaneous Uploads:",required="required",value=prc.cbSettings.cb_media_html5uploads_maxFiles,class="textfield width98",title="The maximum simultaneous HTML5 uploads.",wrapper="div class=controls",labelClass="control-label",groupWrapper="div class=control-group")#
    						<!--- Quick View --->
    						#html.inputField(type="numeric",name="cb_media_quickViewWidth",label="Quick View Image Width: (pixels)",value=prc.cbSettings.cb_media_quickViewWidth,class="textfield width98",title="The width in pixels of the quick view dialog",wrapper="div class=controls",labelClass="control-label",groupWrapper="div class=control-group")#
    						
    					</fieldset>
    					<!--- Uplodify --->
    					<fieldset>
    					<legend><i class="icon-upload-alt icon-large"></i> <strong>Uploadify Integration</strong></legend>
    						<p>From here you control the <a href="http://www.uploadify.com/" target="_blank">Uploadify</a> integration settings.</p>
    
    						<!--- descrip[tion] --->
    						#html.textField(name="cb_media_uplodify_fileDesc",label="File Description Dialog:",required="required",value=prc.cbSettings.cb_media_uplodify_fileDesc,class="textfield width98",title="The text used in the selection dialog window",wrapper="div class=controls",labelClass="control-label",groupWrapper="div class=control-group")#
    						<!--- file extensions --->
    						#html.textField(name="cb_media_uplodify_fileExt",label="File Extensions To Show:",required="required",value=prc.cbSettings.cb_media_uplodify_fileExt,class="textfield width98",title="The extensions to show in the selection dialog window",wrapper="div class=controls",labelClass="control-label",groupWrapper="div class=control-group")#
    						<!--- multi --->
							<div class="control-group">
                                #html.label(class="control-label",field="cb_media_uploadify_allowMulti",content="Allow Multiple Uploads:")#
                                <div class="controls">
                                    #html.radioButton(name="cb_media_uploadify_allowMulti",checked=prc.cbSettings.cb_media_uploadify_allowMulti,value=true)# Yes
    								#html.radioButton(name="cb_media_uploadify_allowMulti",checked=not prc.cbSettings.cb_media_uploadify_allowMulti,value=false)# No
                                </div>
                            </div>
    						<!--- size limit --->
    						#html.textField(name="cb_media_uploadify_sizeLimit",label="Size Limit in bytes (0=no limit):",required="required",value=prc.cbSettings.cb_media_uploadify_sizeLimit,class="textfield width98",title="The size limit of the uploads. 0 Means no limit",wrapper="div class=controls",labelClass="control-label",groupWrapper="div class=control-group")#
    						<!--- Custom JSON Options --->
    						<div class="control-group">
                                #html.label(class="control-label",field="cb_media_uploadify_customOptions",content="Custom JSON Options: ")#
                                <div class="controls">
                                    <small>The following must be valid JSON name value pairs of custom <a href="http://www.uploadify.com/documentation/" target="_blank">uploadify settings</a>.</small><br/>
    								#html.textarea(name="cb_media_uploadify_customOptions",value=prc.cbSettings.cb_media_uploadify_customOptions,rows="2",title="Please remember this must be a valid JSON name value pairs")#
                                </div>
                            </div>
    					</fieldset>
    				</div>
    				
                    <!--- ********************************************************************* --->
                    <!---                           GRAVATARS                                   --->
                    <!--- ********************************************************************* --->
                    
    				<div class="tab-pane" id="gravatars">
    					<fieldset>
    					<legend><i class="icon-user icon-large"></i> <strong>Gravatars</strong></legend>
    						<p>An avatar is an image that follows you from site to site appearing beside your name when you comment on avatar enabled sites.(<a href="http://www.gravatar.com/" target="_blank">http://www.gravatar.com/</a>)</p>
    
    						<!--- Gravatars  --->
							<div class="control-group">
                                #html.label(class="control-label",field="cb_gravatar_display",content="Show Avatars:")#
                                <div class="controls">
                                    #html.radioButton(name="cb_gravatar_display",checked=prc.cbSettings.cb_comments_urltranslations,value=true)# Yes
    								#html.radioButton(name="cb_gravatar_display",checked=not prc.cbSettings.cb_comments_urltranslations,value=false)# No
                                </div>
                            </div>
    						<!--- Avatar Rating --->
							<div class="control-group">
                                <label class="control-label" for="cb_gravatar_rating">Maximum Avatar Rating:</label>
                                <div class="controls">
                                    <select name="cb_gravatar_rating" id="cb_gravatar_rating">
            							<option value="G"  <cfif prc.cbSettings.cb_gravatar_rating eq "G">selected="selected"</cfif>>G - Suitable for all audiences</option>
            							<option value="PG" <cfif prc.cbSettings.cb_gravatar_rating eq "PG">selected="selected"</cfif>>PG - Possibly offensive, usually for audiences 13 and above</option>
            							<option value="R"  <cfif prc.cbSettings.cb_gravatar_rating eq "R">selected="selected"</cfif>>R - Intended for adult audiences above 17</option>
            							<option value="X"  <cfif prc.cbSettings.cb_gravatar_rating eq "X">selected="selected"</cfif>>X - Even more mature than above</option>
            						</select>
                                </div>
                            </div>
							
							<!---Gravatar info --->
							<div class="alert alert-info clearfix">
								<i class="icon-info-sign icon-large"></i>
								To change or create avatars <a href="http://www.gravatar.com/site/signup" target="_blank">sign up to Gravatar.com</a>
								and follow the on-screen instructions.
							</div>
							
    					</fieldset>
    				</div>

                    <!--- ********************************************************************* --->
    				<!---                           Notifications                               --->
                    <!--- ********************************************************************* --->
    				
                    <div class="tab-pane" id="notifications">
    					<fieldset>
    					<legend><i class="icon-envelope-alt icon-large"></i> <strong>Notifications</strong></legend>
    						<!--- Site Email --->
							<div class="control-group">
                                #html.label(class="control-label",field="cb_site_email",content="Administrator Email:")#
                                <div class="controls">
                                    <small>The email(s) that receives all notifications from ContentBox.  To specify multiple addresses, separate the addresses with commas.</small><br/>
    								#html.inputField(name="cb_site_email",value=prc.cbSettings.cb_site_email,class="textfield width98",required="required",title="The email that receives all notifications")#
                                </div>
                            </div>
    						<!--- Outgoing Email --->
							<div class="control-group">
                                #html.label(class="control-label",field="cb_site_outgoingEmail",content="Outgoing Email:")#
                                <div class="controls">
                                    <small>The email address that sends all emails out of ContentBox.</small><br/>
    								#html.inputField(name="cb_site_outgoingEmail",required="required",value=prc.cbSettings.cb_site_outgoingEmail,class="textfield width98",title="The email that sends all email notifications out",type="email")#
                                </div>
                            </div>
    						<!--- Notification on User Create --->
							<div class="control-group">
                                #html.label(class="control-label", field="cb_notify_author", content="<i class='icon-user'></i> Send a notification when a user has been created or removed:")#
                                <div class="controls">
                                    #html.radioButton( name="cb_notify_author", checked=prc.cbSettings.cb_notify_author, value=true)# Yes
    								#html.radioButton( name="cb_notify_author", checked=not prc.cbSettings.cb_notify_author, value=false)# No
                                </div>
                            </div>    
    						<!--- Notification on Entry Create --->
							<div class="control-group">
                                #html.label(class="control-label", field="cb_notify_entry", content="<i class='icon-quote-left'></i> Send a notification when a blog entry has been created or removed:")#
                                <div class="controls">
                                    #html.radioButton( name="cb_notify_entry", checked=prc.cbSettings.cb_notify_entry, value=true)# Yes
    								#html.radioButton( name="cb_notify_entry", checked=not prc.cbSettings.cb_notify_entry, value=false)# No
                                </div>
                            </div>
    						<!--- Notification on Page Create --->
							<div class="control-group">
                                #html.label(class="control-label", field="cb_notify_page", content="<i class='icon-file-alt'></i> Send a notification when a page has been created or removed:")#
                                <div class="controls">
                                    #html.radioButton( name="cb_notify_page", checked=prc.cbSettings.cb_notify_page, value=true)# Yes
    								#html.radioButton( name="cb_notify_page", checked=not prc.cbSettings.cb_notify_page, value=false)# No
                                </div>
                            </div>
                            <!--- Notification on ContentStore Create --->
                            <div class="control-group">
                                #html.label(class="control-label", field="cb_notify_contentstore", content="<i class='icon-hdd'></i> Send a notification when a content store object has been created or removed:")#
                                <div class="controls">
                                    #html.radioButton( name="cb_notify_contentstore", checked=prc.cbSettings.cb_notify_contentstore, value=true )# Yes
                                    #html.radioButton( name="cb_notify_contentstore", checked=not prc.cbSettings.cb_notify_contentstore, value=false )# No
                                </div>
                            </div>
    					</fieldset>
    				</div>
                    
                    <!--- ********************************************************************* --->
                    <!---                           EMAIL SERVER                                --->
                    <!--- ********************************************************************* --->
                    
                    <div class="tab-pane" id="email_server">
                        <!--- Mail Server Settings --->
                        <fieldset>
                        <legend><i class="icon-laptop icon-large"></i> <strong>Mail Server</strong></legend>
                            <p>By default ContentBox will use the mail settings in your application server.  You can override those settings by completing
                               the settings below</p>
                            <!--- Mail Server --->
                            <div class="control-group">
                                #html.label(class="control-label",field="cb_site_mail_server",content="Mail Server:")#
                                <div class="controls">
                                    <small>Optional mail server to use or it defaults to the settings in the ColdFusion Administrator</small><br/>
                                    #html.textField(name="cb_site_mail_server",value=prc.cbSettings.cb_site_mail_server,class="textfield width98",title="The complete mail server URL to use.")#
                                </div>
                            </div>
                            <!--- Mail Username --->
                            <div class="control-group">
                                #html.label(class="control-label",field="cb_site_mail_username",content="Mail Server Username:")#
                                <div class="controls">
                                    <small>Optional mail server username or it defaults to the settings in the ColdFusion Administrator</small><br/>
                                    #html.textField(name="cb_site_mail_username",value=prc.cbSettings.cb_site_mail_username,class="textfield width98",title="The optional mail server username to use.")#
                                </div>
                            </div>
                            <!--- Mail Password --->
                            <div class="control-group">
                                #html.label(class="control-label",field="cb_site_mail_password",content="Mail Server Password:")#
                                <div class="controls">
                                    <small>Optional mail server password to use or it defaults to the settings in the ColdFusion Administrator</small><br/>
                                    #html.passwordField(name="cb_site_mail_password",value=prc.cbSettings.cb_site_mail_password,class="textfield width98",title="The optional mail server password to use.")#
                                </div>
                            </div>
                            <!--- SMTP Port --->
                            <div class="control-group">
                                #html.label(class="control-label",field="cb_site_mail_smtp",content="Mail SMTP Port:")#
                                <div class="controls">
                                    <small>The SMTP mail port to use, defaults to port 25.</small><br/>
                                    #html.inputfield(type="numeric",name="cb_site_mail_smtp",value=prc.cbSettings.cb_site_mail_smtp,class="textfield",size="5",title="The mail SMPT port to use.")#
                                </div>
                            </div>
                            <!--- TLS --->
                            <div class="control-group">
                                #html.label(class="control-label",field="cb_site_mail_tls",content="Use TLS:")#
                                <div class="controls">
                                    <small>Whether to use TLS when sending mail or not.</small><br/>
                                    #html.radioButton(name="cb_site_mail_tls",checked=prc.cbSettings.cb_site_mail_tls,value=true)# Yes
                                    #html.radioButton(name="cb_site_mail_tls",checked=not prc.cbSettings.cb_site_mail_tls,value=false)# No
                                </div>
                            </div>
                            <!--- SSL --->
                            <div class="control-group">
                                #html.label(class="control-label",field="cb_site_mail_ssl",content="Use SSL:")#
                                <div class="controls">
                                    <small>Whether to use SSL when sending mail or not.</small><br/>
                                    #html.radioButton(name="cb_site_mail_ssl",checked=prc.cbSettings.cb_site_mail_ssl,value=true)# Yes
                                    #html.radioButton(name="cb_site_mail_ssl",checked=not prc.cbSettings.cb_site_mail_ssl,value=false)# No
                                </div>
                            </div>
                            <!--- Test Connection --->
                            <hr/>
                            <div id="emailTestDiv"></div>
                            <button id="emailTestButton" class="btn btn-primary" title="Send a test email with these settings" onclick="return emailTest()"><i class="icon-spinner icon-large" id="iTest"></i> Test Connection</button>
                        </fieldset>
    
    
                    </div>

    				<!--- ********************************************************************* --->
                    <!---                           SEARCH OPTIONS                              --->
                    <!--- ********************************************************************* --->
                    
    				<div class="tab-pane" id="search_options">
    					<fieldset>
    						<legend><i class="icon-search icon-large"></i>  Search Options</legend>
    
    						<!--- Max Search Results --->
							<div class="control-group">
                                <label class="control-label" for="cb_search_maxResults">Max Search Results:</label>
                                <div class="controls">
                                    <small>The number of search results to show before paging kicks in.</small><br/>
            						<select name="cb_search_maxResults" id="cb_search_maxResults">
                							<cfloop from="5" to="50" step="5" index="i">
            								<option value="#i#" <cfif i eq prc.cbSettings.cb_search_maxResults>selected="selected"</cfif>>#i#</option>
            							</cfloop>
            						</select>
                                </div>
                            </div>
    						<!--- Search Adapter --->
							<div class="control-group">
                                #html.label(class="control-label",field="cb_search_adapter",content="Search Adapter: ")#
                                <div class="controls">
                                    <small>The ContentBox search engine adapter class (instantiation path) to use. You can create your own search engine adapters as
            						long as they implement <em>contentbox.model.search.ISearchAdapter</em>. You can choose from our core adapters or
            						enter your own CFC instantiation path below.</small><br/>
            
            						<ul>
            							<li><a href="javascript:chooseAdapter('contentbox.model.search.DBSearch')">ORM Database Search (contentbox.model.search.DBSearch)</a></li>
            						</ul>
            
            						#html.textField(name="cb_search_adapter",size="60",class="textfield",value=prc.cbSettings.cb_search_adapter,required="required",title="Please remember this must be a valid ColdFusion instantiation path")#
                                </div>
                            </div>
    					</fieldset>
    				</div>

    				<!--- ********************************************************************* --->
                    <!---                           RSS OPTIONS                                 --->
                    <!--- ********************************************************************* --->

    				<div class="tab-pane" id="rss_options">
    					<fieldset>
    						<legend><i class="icon-rss icon-large"></i>  RSS Options</legend>
    
    						<!--- Max RSS Entries --->
							<div class="control-group">
                                <label class="control-label" for="cb_rss_maxEntries">Max RSS Content Items:</label>
                                <div class="controls">
                                    <small>The number of recent content items to show on the syndication feeds.</small><br/>
            						<select name="cb_rss_maxEntries" id="cb_rss_maxEntries">
            							<cfloop from="5" to="50" step="5" index="i">
            								<option value="#i#" <cfif i eq prc.cbSettings.cb_rss_maxEntries>selected="selected"</cfif>>#i#</option>
            							</cfloop>
            						</select>
                                </div>
                            </div>    
    						<!--- Max RSS Comments --->
							<div class="control-group">
                                <label class="control-label" for="cb_rss_maxComments">Max RSS Content Comments:</label>
                                <div class="controls">
                                    <small>The number of recent comments to show on the syndication feeds.</small><br/>
            						<select name="cb_rss_maxComments" id="cb_rss_maxComments">
            							<cfloop from="5" to="50" step="5" index="i">
            								<option value="#i#" <cfif i eq prc.cbSettings.cb_rss_maxComments>selected="selected"</cfif>>#i#</option>
            							</cfloop>
            						</select>
                                </div>
                            </div>
    					</fieldset>
    					<fieldset>
    						<legend><i class="icon-hdd icon-large"></i>  RSS Caching</legend>
    
    						<!--- RSS Caching --->
							<div class="control-group">
                                #html.label(class="control-label",field="cb_rss_caching",content="Activate RSS feed caching:")#
                                <div class="controls">
                                    #html.radioButton(name="cb_rss_caching",checked=prc.cbSettings.cb_rss_caching,value=true)# Yes
    								#html.radioButton(name="cb_rss_caching",checked=not prc.cbSettings.cb_rss_caching,value=false)# No
                                </div>
                            </div>
    						<!--- RSS Cache Name --->
							<div class="control-group">
                                <label class="control-label" for="cb_rss_cacheName">Feed Cache Provider:</label>
                                <div class="controls">
                                    <small>Choose the CacheBox provider to cache feeds into.</small><br/>
    								#html.select(name="cb_rss_cacheName",options=prc.cacheNames,selectedValue=prc.cbSettings.cb_rss_cacheName)#
                                </div>
                            </div>
    						<!--- Rss Cache Timeouts --->
							<div class="control-group">
                                <label class="control-label" for="cb_rss_cachingTimeout">Feed Cache Timeouts:</label>
                                <div class="controls">
                                    <small>The number of minutes a feed XML is cached per permutation of feed type.</small><br/>
            						<select name="cb_rss_cachingTimeout" id="cb_rss_cachingTimeout">
            							<cfloop from="5" to="100" step="5" index="i">
            								<option value="#i#" <cfif i eq prc.cbSettings.cb_rss_cachingTimeout>selected="selected"</cfif>>#i#</option>
            							</cfloop>
            						</select>
                                </div>
                            </div>
    						<!--- Rss Cache Last Access Timeouts --->
							<div class="control-group">
                                <label class="control-label" for="cb_rss_cachingTimeoutIdle">Feed Cache Idle Timeouts:</label>
                                <div class="controls">
                                    <small>The number of idle minutes allowed for cached RSS feeds to live. Usually this is less than the timeout you selected above</small><br/>
            						<select name="cb_rss_cachingTimeoutIdle" id="cb_rss_cachingTimeoutIdle">
            							<cfloop from="5" to="100" step="5" index="i">
            								<option value="#i#" <cfif i eq prc.cbSettings.cb_rss_cachingTimeoutIdle>selected="selected"</cfif>>#i#</option>
            							</cfloop>
            						</select>
                                </div>
                            </div>
    					</fieldset>
    				</div>

					<!--- cbadmin Event --->
					#announceInterception("cbadmin_onSettingsContent")#

					<!--- Button Bar --->
        			<div class="form-actions">
        				#html.submitButton(value="Save Settings", class="btn btn-danger")#
        			</div>
				</div>
				<!--- End Tab Content --->
			</div>
			<!--- End Vertical Nav --->
		</div>
        <!--- End Body --->
	</div>
</div>
#html.endForm()#
</cfoutput>