<cfoutput>
<div class="row">
    <div class="col-md-12">

		<div class="pull-right">
	    	<button class="btn btn-success btn-sm"
	    			onclick="popup( '#event.buildLink( prc.xehPreview )#/l/#encodeForJavaScript( prc.activeTheme.name )#/h/#hash( prc.oCurrentAuthor.getAuthorID() )#');return false;">
				<i class="far fa-eye"></i> Preview
			</button>
		</div>

        <h1 class="h1"><i class="fa fa-picture-o fa-lg"></i> #encodeForHTML( prc.activeTheme.themeName )#</h1>
    </div>
</div>

<div class="row">
	<div class="col-md-12">
		<div class="panel panel-default">
		    <div class="panel-body">

		    	<!--- MessageBox --->
				#getInstance( "messagebox@cbMessagebox" ).renderit()#

				<!---screenshot --->
				<div id="theme-screenshot" class="pull-right">
					<cfif len( prc.activeTheme.screenShotURL )>
						<a href="#encodeForHTMLAttribute( prc.activeTheme.screenShotURL )#" target="_blank">
							<img src="#encodeForHTMLAttribute( prc.activeTheme.screenShotURL )#" alt="screenshot" height="200" border="0" class="img-screenshot img-thumbnail"/>
						</a>
						<br/>
					</cfif>
				</div>

				<!---Description --->
				<blockquote id="theme-description">#encodeForHTML( prc.activeTheme.description )#</blockquote>
				<!---Author --->
				<div id="theme-author">
					<i class="fa fa-user"></i>
					<strong>Author: </strong> <a href="#encodeForHTMLAttribute( prc.activeTheme.authorURL )#" title="#encodeForHTMLAttribute( prc.activeTheme.AuthorURL )#" target="_blank">#encodeForHTML( prc.activeTheme.Author )#</a>
				</div>
				<!--- Version --->
				<div id="theme-version>">
					<i class="fas fa-history"></i>
					<strong>Version: </strong>
					#encodeForHTML( prc.activeTheme.version )#
				</div>
				<!--- ForgeBox Slug --->
				<div id="theme-forgebox>">
					<i class="fa fa-cloud-download"></i>
					<strong>ForgeBox Slug: </strong>
					<cfif len( prc.activeTheme.forgeboxSlug )>
						<a href="http://www.coldbox.org/forgebox/view/#encodeForHTMLAttribute( prc.activeTheme.forgeboxSlug )#">#encodeForHTMLAttribute( prc.activeTheme.forgeboxSlug )#</a>
					<cfelse>
						<em>None</em>
					</cfif>
				</div>
				<!---Interceptions --->
				<div id="theme-interceptions">
					<i class="fa fa-bullhorn"></i>
					<strong>Registered Interceptions: </strong>
					<cfif len( prc.activeTheme.customInterceptionPoints )>
						#encodeForHTML( prc.activeTheme.customInterceptionPoints )#
					<cfelse>
						<em>None</em>
					</cfif>
				</div>
				<!---Widgets --->
				<div id="theme-widgets">
					<i class="fa fa-magic"></i>
					<strong>Theme Widgets: </strong>
					<cfif len( prc.activeTheme.widgets )>
						#encodeForHTML( prc.activeTheme.widgets )#
					<cfelse>
						<em>None</em>
					</cfif>
				</div>
				<!---Modules --->
				<div id="theme-modules">
					<i class="fa fa-bolt"></i>
					<strong>Theme Modules: </strong>
					<cfif len( prc.activeTheme.modules )>
						#encodeForHTML( prc.activeTheme.modules )#
					<cfelse>
						<em>None</em>
					</cfif>
				</div>

				<!--- Announce display Event --->
				#announce( "cbadmin_onThemeInfo", { theme=prc.activeTheme } )#

				<!---Theme Settings --->
				<cfif prc.activeTheme.settings.len()>
					<h1>Theme Settings:</h1>
					#html.startForm( action=prc.xehSaveSettings, name="layoutSettingsForm" )#
						#html.hiddenField( name="themeName", value=encodeForHTMLAttribute( prc.activeTheme.name ) )#

						<!--- Build out theme settings --->
						#prc.themeService.buildSettingsForm( prc.activeTheme )#

						<!--- Announce display Event --->
						#announce( "cbadmin_onThemeSettings", { theme=prc.activeTheme } )#

						<div class="form-group">
							#html.submitButton( value="Save Settings", class="btn btn-danger" )#
						</div>

                    #html.endForm()#
				</cfif>

		    </div>
		</div>
	</div>
</div>
</cfoutput>