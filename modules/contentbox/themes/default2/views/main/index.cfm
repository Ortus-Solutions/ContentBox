<cfoutput>
	<div class="jumbotron mt-sm-5 p-4">
		<div class="row">
			<div class="col-lg-5 col-md-6">
				<p class="text-center">
					<img src="includes/images/ColdBoxLogo2015_300.png" class="m-2 mt-2" alt="logo"/>
					<a class="btn btn-primary" href="https://coldbox.ortusbooks.com" target="_blank" title="Read our ColdBox Manual" rel="tooltip">
						<strong>Read ColdBox Docs</strong>
					</a>
				</p>
			</div>

			<div class="col-lg-7 col-md-6">
				<h1 class="display-3">
					#prc.welcomeMessage#
				</h1>
				<div class="badge badge-info mb-2">
					<strong>#getColdBoxSetting( "version" )# (#getColdBoxSetting( "suffix" )#)</strong>
				</div>
				<p class="lead">
					Welcome to modern ColdFusion (CFML) development.  You can now start building your application with ease, we already did the hard work
					for you.
				</p>
			</div>
		</div>
	</div>

	<div class="row">
		<div class="col-lg-9">

			<section id="eventHandlers">
			<div class="pb-2 mt-4 mb-2 border-bottom">
				<h2>
					Registered Event Handlers
				</h2>
			</div>
			<p>
				You can click on the following event handlers to execute their default action
				<span class="badge badge-danger">index()</span>
			</p>
			<ul>
				<cfloop list="#getSetting("RegisteredHandlers")#" index="handler">
				<li><a href="#event.buildLink( handler )#">#handler#</a></li>
				</cfloop>
			</ul>
			</section>

			<cfif structCount( getSetting("Modules") )>
				<section id="modules">
				<div class="pb-2 mt-4 mb-2 border-bottom">
					<h2>
						Registered Modules
					</h2>
				</div>
				<p>Below are your application's loaded modules, click on them to visit them.</p>
				<ul>
					<cfloop collection="#getSetting("Modules")#" item="thisModule">
					<li><a href="#event.buildLink( getModuleConfig( thisModule ).inheritedEntryPoint )#">#thisModule#</a></li>
					</cfloop>
				</ul>
				</section>
			</cfif>

			<section id="test-harness">
			<div class="pb-2 mt-4 mb-2">
				<h2>
					Application Test Harness
				</h2>
			</div>

			<table class="table table-striped">
				<thead>
					<th>File/Folder</th>
					<th>Description</th>
				</thead>
				<tbody>
					<tr>
						<td>
							<em>specs</em>
						</td>
						<td>Where all your bdd, module, unit and integration tests go</td>
					</tr>
					<tr>
						<td>
							<em>results</em>
						</td>
						<td>Where automated test results go</td>
					</tr>
					<tr>
						<td>
							<em>resources</em>
						</td>
						<td>
							Test resources like fixtures, itegrations, etc.
						</td>
					</tr>
					<tr>
						<td>
							<em>Application.cfc</em>
						</td>
						<td>A unique Application.cfc for your testing harness, please spice up as needed.</td>
					</tr>
					<tr>
						<td>
							<em>test.xml</em>
						</td>
						<td>A script for executing all application tests via TestBox ANT</td>
					</tr>
					<tr>
						<td>
							<a href="#getSetting( "appMapping" )#/tests/runner.cfm">
								#getSetting( "appMapping" )#runner.cfm
							</a>
						</td>
						<td>A TestBox runner so you can execute your tests.</td>
					</tr>
					<tr>
						<td>
							<a href="#getSetting( "appMapping" )#/tests/index.cfm">
								#getSetting( "appMapping" )#index.cfm
							</a>
						</td>
						<td>A TestBox browser, so you can browse and execute specs</td>
					</tr>
				</tbody>
			</table>
			</section>

			<section id="urlActions">
			<div class="pb-2 mt-4 mb-2 border-bottom">
				   <h2>ColdBox URL Actions</h2>
			   </div>
			<p>ColdBox can use some very important URL actions to interact with your application. You can also use CommandBox <code>coldbox reinit</code> and reinit from the CLI. You can try them out below:</p>
			<table class="table table-striped">
				<thead>
					<th>URL Action</th>
					<th>Description</th>
					<th>Execute</th>
				</thead>
				<tbody>
					<tr>
						<td>
							<em>?fwreinit=1</em><br/>
							<em>?fwreinit={ReinitPassword}</em>
						</td>
						<td>Reinitialize the Application</td>
						<td>
							<a class="btn btn-info" href="index.cfm?fwreinit=1">Execute</a>
						</td>
					</tr>
				</tbody>
			</table>
			</section>

			<section id="customize">
			<div class="pb-2 mt-4 mb-2 border-bottom">
				<h2>Customizing your Application</h2>
			</div>
			<p>
				You can now start editing your application and building great ColdBox enabled apps. Important files & locations:
			</p>
			<ol>
				<li>
					<code>/config/CacheBox.cfc</code>: Your CacheBox Configuration file
				</li>
				<li>
					<code>/config/ColdBox.cfc</code>: Your application configuration file
				</li>
				<li>
					<code>/config/Routes.cfc</code>: Your URL Router
				</li>
				<li>
					<code>/config/WireBox.cfc</code>: Your WireBox Binder
				</li>
				<li>
					<code>/handlers</code>: Your controller event handlers
				</li>
				<li>
					<code>/interceptors</code>: Global interceptors
				</li>
				<li>
					<code>/includes</code>: Assets, Helpers, i18n, templates and more.
				</li>
				<li>
					<code>/layouts</code>:Your application skin layouts
				</li>
				<li>
					<code>/lib</code>: Where Jar files can be integrated
				</li>
				<li>
					<code>/models</code>: Your model layer
				</li>
				<li>
					<code>/modules</code>: Your CommandBox managed modules
				</li>
				<li>
					<code>/modules_app</code>: Your application modules
				</li>
				<li>
					<code>/tests</code>: Your BDD testing harness (Just DO IT!!)
				</li>
				<li>
					<code>/views</code>: Your application views
				</li>
			</ol>
			</section>
		</div>

		<!---Side Bar --->
		<div class="col-lg-3">
			<div class="card card-block">
				<ul class="card-body nav flex-column bg-light">
					<li class="nav-item"><strong>Important Links</strong></li>
					<li class="nav-item">
						<a class="nav-link" href="https://www.coldbox.org" target="_blank">ColdBox Site</a>
					</li>
					<li class="nav-item">
						<a class="nav-link" href="https://www.ortussolutions.com/blog" target="_blank">Blog</a>
					</li>
					<li class="nav-item">
						<a class="nav-link" href="https://ortussolutions.atlassian.net/browse/COLDBOX" target="_blank">Issue Tracker</a>
					</li>
					<li class="nav-item">
						<a class="nav-link" href="https://github.com/ColdBox/coldbox-platform" target="_blank">Source Code</a>
					</li>
					<li class="nav-item">
						<a class="nav-link" href="https://coldbox.ortusbooks.com" target="_blank">Manual</a>
					</li>
					<li class="nav-item">
						<a class="nav-link" href="https://apidocs.coldbox.org" target="_blank">Quick API Docs</a>
					</li>
					<li class="nav-item">
						<a class="nav-link" href="https://forgebox.io" rel="tooltip" title="Community for interceptors, modules, etc." target="_blank">ForgeBox</a>
					</li>
					<li class="nav-item">
						<a class="nav-link" href="https://www.ortussolutions.com/services/training" target="_blank">Training</a>
					</li>
					<li class="nav-item"><strong>Support</strong></li>
					<li class="nav-item">
						<a class="nav-link" href="https://groups.google.com/group/coldbox">Mailing List</a>
					</li>
					<li class="nav-item">
						<a class="nav-link" href="https://www.coldbox.org/support/overview">Community Support</a>
					</li>
					<li class="nav-item">
						<a class="nav-link" href="https://www.ortussolutions.com/services">Professional Support</a>
					</li>
				</ul>
			</div>
		</div>
	</div>
	</cfoutput>