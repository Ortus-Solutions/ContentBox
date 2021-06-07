<cfoutput>
<div class="row">
    <div class="col-md-12">
		<h1 class="h1">
			<i class="fas fa-swatchbook fa-lg"></i> Installed Themes (#structCount( prc.themes )#)
		</h1>
    </div>
</div>

<div class="row">
    <div class="col-md-12">
       	<!--- MessageBox --->
		#cbMessageBox().renderit()#
    </div>
</div>

<div class="row">
	<div class="col-md-12">

		<div class="panel panel-default">

			<div class="panel-heading">
				<div class="row">

					<div class="col-md-6 col-xs-4">
						<div class="form-group form-inline no-margin">
							#html.textField(
								name        = "themeFilter",
								class       = "form-control rounded quicksearch",
								placeholder = "Quick Search"
							)#
						</div>
					</div>

					<div class="col-md-6 col-xs-8">
						<!--- Rebuild Registry Button --->
						<cfif prc.oCurrentAuthor.checkPermission( "THEME_ADMIN" )>
							<div class="text-right">
								<button
									class="btn btn-primary"
									onclick="return to('#event.buildLink( prc.xehFlushRegistry )#')"
									title="Rescan Themes directory and rebuild registry"
								>
									<i class="fas fa-recycle"></i> Rebuild Registry
								</button>
							</div>
						</cfif>
					</div>
				</div>
			</div>

			<div class="panel-body">
				<!--- Theme Form --->
				#html.startForm( name="themeForm", action=prc.xehThemeRemove )#
					#html.hiddenField( name="themeName" )#
					<!--- themes --->
					<table name="themes" id="themes" class="table table-striped-removed table-hover " width="100%">
						<thead>
							<tr>
								<th width="300">Theme Info</th>
								<th>Description</th>
							</tr>
						</thead>
						<tbody>
							<cfloop collection="#prc.themes#" item="themeName">
								<cfset thisTheme = prc.themes[ themeName ]>
							<tr>
								<td>
									<cfif prc.oCurrentSite.getActiveTheme() eq themeName>
										<i class="fas fa-asterisk fa-lg text-orange" title="Active Theme"></i>
									</cfif>

									<strong>#thisTheme.themeName#</strong>

									<div>
										Version #thisTheme.version# by
										<a href="#thisTheme.authorURL#" title="#thisTheme.AuthorURL#" target="_blank">#thisTheme.Author#</a>
									</div>

									<p>&nbsp;</p>

									<!--- Button Bar --->
									<div class="btn-group">
										<cfif prc.oCurrentAuthor.checkPermission( "THEME_ADMIN" ) AND prc.activeTheme.name NEQ thisTheme.name>
											<button class="btn btn-success btn-sm" onclick="popup('#event.buildLink(prc.xehPreview)#/l/#thisTheme.name#/h/#hash(prc.oCurrentAuthor.getAuthorID())#');return false;">
												<i class="far fa-eye"></i> Preview
											</button>
											<button class="btn btn-primary btn-sm" onclick="return to('#event.buildLink(prc.xehActivate)#?themeName=#thisTheme.name#')">
												<i class="fa fa-bolt"></i> Activate
											</button>
										</cfif>

										<!--- Delete Command --->
										<cfif prc.oCurrentAuthor.checkPermission( "THEME_ADMIN" ) AND thisTheme.name neq prc.activeTheme.name>
											<a href="javascript:remove('#JSStringFormat(thisTheme.name)#')"
											   class="confirmIt btn btn-sm btn-danger" data-title="<i class='far fa-trash-alt'></i> Delete Theme?" data-message="This will permanently remove all theme associated files!">
											   <i class="far fa-trash-alt fa-lg"></i> Remove
											</a>
										</cfif>
									</div>

								</td>
								<td class="text-center">
									<cfif len( thisTheme.screenShotURL )>
										<!--- image --->
										<a href="#thisTheme.screenShotURL#" target="_blank">
											<img src="#thisTheme.screenShotURL#"  alt="screenshot" class="img-thumbnail" width="300" border="0"/>
										</a>
										<br/>
									</cfif>
									<!--- description --->
									<p>
										#thisTheme.description#
									</p>
								</td>
							</tr>
							</cfloop>
						</tbody>
					</table>
				#html.endForm()#

		    </div>
		</div>
	</div>
</div>
<div class="row-fluid">
	<div class="box">
		<!--- Body --->
		<div class="body">
			<!---Tabs --->
			<div class="panes tab-content"></div>
			<!--- end panes div --->
		</div>
		<!--- end div body --->
	</div>
	<!--- end div box --->
</div>
</cfoutput>
