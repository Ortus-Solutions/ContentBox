<cfoutput>
<div class="row">
    <div class="col-md-12">
        <h1 class="h1"><i class="fa fa-picture-o fa-lg"></i> Installed Themes</h1>
    </div>
</div>

<div class="row">
    <div class="col-md-12">
       	<!--- MessageBox --->
		#getModel( "messagebox@cbMessagebox" ).renderit()#
    </div>
</div>

<div class="row">
	<div class="col-md-12">
		<div class="panel panel-default">
		    <div class="panel-body">

				<!--- Content Bar --->
				<div class="well well-sm">
					<!--- Rebuild Registry Button --->
					<cfif prc.oCurrentAuthor.checkPermission( "THEME_ADMIN" )>
						<div class="btn-group btn-sm pull-right">

							<button class="btn btn-sm btn-primary" onclick="return to('#event.buildLink(prc.xehFlushRegistry)#')" title="Rescan Themes directory and rebuild registry"><i class="fa fa-refresh"></i> Rebuild Registry</button>
						</div>
					</cfif>
					<!--- Filter Bar --->
					<div class="form-group form-inline no-margin">
						#html.textField(
							name="themeFilter",
							size="30",
							class="form-control",
							placeholder="Quick Filter"
						)#
					</div>
				</div>

				<!--- Theme Form --->
				#html.startForm( name="themeForm", action=prc.xehThemeRemove )#
					#html.hiddenField( name="themeName" )#
					<!--- themes --->
					<table name="themes" id="themes" class="table table-striped table-hover table-condensed" width="100%">
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
									<cfif prc.cbSettings.cb_site_theme eq themeName>
										<i class="fa fa-asterisk fa-lg text-warning" title="Active Theme"></i>
									</cfif>
									<strong>#thisTheme.themeName#</strong>
									<br/>
									Version #thisTheme.version# by
									<a href="#thisTheme.authorURL#" title="#thisTheme.AuthorURL#" target="_blank">#thisTheme.Author#</a>

									<p>&nbsp;</p>

									<!--- Button Bar --->
									<div class="btn-group">
										<cfif prc.oCurrentAuthor.checkPermission( "THEME_ADMIN" ) AND prc.activeTheme.name NEQ thisTheme.name>
											<button class="btn btn-success btn-sm" onclick="popup('#event.buildLink(prc.xehPreview)#/l/#thisTheme.name#/h/#hash(prc.oCurrentAuthor.getAuthorID())#');return false;">
												<i class="fa fa-eye"></i> Preview
											</button>
											<button class="btn btn-primary btn-sm" onclick="return to('#event.buildLink(prc.xehActivate)#?themeName=#thisTheme.name#')">
												<i class="fa fa-bolt"></i> Activate
											</button>
										</cfif>

										<!--- Delete Command --->
										<cfif prc.oCurrentAuthor.checkPermission( "THEME_ADMIN" ) AND thisTheme.name neq prc.activeTheme.name>
											<a href="javascript:remove('#JSStringFormat(thisTheme.name)#')"
											   class="confirmIt btn btn-sm btn-danger" data-title="<i class='fa fa-trash-o'></i> Delete Theme?" data-message="This will permanently remove all theme associated files!">
											   <i class="fa fa-trash-o fa-lg"></i> Remove
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
