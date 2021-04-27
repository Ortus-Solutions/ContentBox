<cfoutput>
<div id="widget-container">

	<!--- Filter --->
	<div class="well well-sm">

		<!--- Filter --->
		<div class="form-group m0">
			<div class="input-group input-group-sm m0">
				<input
					name="widgetFilter"
					id="widgetFilter"
					type="text"
					class="form-control rounded"
					placeholder="Quick Filter"
					aria-describedby="sizing-addon3"
				>
				<span
					class="input-group-addon cursor-pointer"
					id="sizing-addon3"
					title="Clear Search"
					onclick="clearFilter()"
				>
					<i class="far fa-times-circle fa-lg"></i>
				</span>
			</div>
		</div>

	</div>

	<div class="tab-wrapper tab-left tab-primary">

		<!--- Navigation Bar --->
		<ul class="nav nav-tabs" id="widget-sidebar">
			<!--- All Tab --->
			<li class="active">
				<a href="##widget-store" class="current" data-toggle="tab">
					<span class="categoryName">
						All
					</span>
					<span class="badge badge-info">#prc.widgets.recordcount#</span>
				</a>
			</li>
			<!--- Category Tabs with Counts --->
			<cfloop query="prc.categories">
				<cfif len( prc.categories.category )>
					<li>
						<a href="##widget-store" data-toggle="tab">
							<span class="categoryName">
								#prc.categories.category#
							</span>
							<span class="badge badge-info ml10">
								#duplicate(prc.widgets).filter( function( thisWidget ){
									return thisWidget.category eq prc.categories.category;
								}).recordcount#
							</span>
						</a>
					</li>
				</cfif>
			</cfloop>
		</ul>

		<!--- Array to hold all the error messages when generating widgets,output at the bottom of the list, not in the middle --->
		<cfset aWidgetErrors = []>

		<!--- Tab Content --->
		<div class="tab-content">
			<div class="widget-store full tab-pane active">

				<!--- Row --->
				<div class="row">

					<!--- Widgets --->
					<cfloop query="prc.widgets">
						<cfscript>
							widgetName 		= prc.widgets.name;
							widgetSelector 	= prc.widgets.name;
							category 		= prc.widgets.category;
							switch( prc.widgets.widgettype ) {
								case 'module':
										widgetName &= "@" & prc.widgets.module;
										break;
								case 'layout':
									widgetName = "~" & widgetName;
									break;
							}

							// Try to get the widget object
							try{
								oWidget = prc.widgetService.getWidget(
									name = widgetName,
									type = prc.widgets.widgetType
								);
							} catch( Any e ){
								log.error( 'Error Building #prc.widgets.toString()#. #e.message# #e.detail#', e );
								arrayAppend( aWidgetErrors, "<div class='alert alert-danger m10'>Error building '#prc.widgets.name#' widget: #e.message# <p><a data-toggle='collapse' data-target='##Widget_Error_#prc.widgets.name#'>Toggle Full Error</a></p><div id='Widget_Error_#prc.widgets.name#' class='collapse'>#e.detail#</div></div>" );
								continue;
							}

							iconName = prc.widgets.icon;
							if( args.cols eq 2 ) {
								extraClasses = "half ";
								extraClasses &= currentRow mod 2==0 ? "spacer" : "";
								extraClasses = "third ";
								extraClasses &= currentRow mod 3!=1 ? "spacer" : "";
							}
							else {
								extraClasses = "third ";
								extraClasses &= currentRow mod 3!=1 ? "spacer" : "";
							}
						</cfscript>
						<cfset hasProtocol = reFindNoCase( "\b(?:https?):?", oWidget.getAuthorURL() )>
						<cfset widgetURL = hasProtocol ? oWidget.getAuthorURL() : "http://" & oWidget.getAuthorURL()>
						<cfset widgetCursor = args.mode eq "edit" ? "" : "widget-selector ">

						<div class="col-md-6">
							<div
								class="#widgetCursor#panel panel-info"
								name="#widgetName#"
								category="#category#"
								type="#prc.widgets.widgettype#"
								displayname="#oWidget.getName()#"
								iconName="#iconName#"
							>
								<cfif isSimpleValue( oWidget )>
									<div class="alert alert-danger">
										Error loading widget: #widgetName#
										<br>
										<p>Debugging:</p>
										#prc.widgets.debug#
									</div>
								<cfelse>
									<div class="panel-heading">
										<cfif args.mode eq "edit">
											<div class="btn-group btn-group-sm actions">
												<!---read docs--->
												<a data-toggle="tooltip" data-container="body" data-placement="left" title="Read Widget Documentation" class="btn btn-sm btn-info" href="javascript:openRemoteModal('#event.buildLink(prc.xehWidgetDocs)#',{widget:'#urlEncodedFormat(widgetName)#',type:'#urlEncodedFormat(prc.widgets.widgettype)#'} )">
													<i class="fa fa-book fa-lg"></i>
												</a>
												<cfif prc.oCurrentAuthor.checkPermission( "WIDGET_ADMIN" )>
													<!--- Test --->
													<a title="Test Widget" data-container="body" class="btn btn-sm btn-info"
														href="javascript:testWidgetCode( '#widgetName#', '#prc.widgets.widgetType#' )">
														<i class="fa fa-bolt fa-lg"></i>
													</a>
													<!---only allow deletion of custom widgets--->
													<cfif prc.widgets.widgettype eq "custom">
														<!--- Delete Command --->
														<a title="Delete Widget" data-container="body"  href="javascript:remove('#JSStringFormat(widgetName)#')" class="confirmIt btn btn-sm btn-danger" data-title="Delete #widgetName#?">
															<i class="far fa-trash-alt fa-lg"></i>
														</a>
													</cfif>
												</cfif>
											</div> <!--- end btn group --->
										</cfif>
										<h3 class="panel-title p5">
											#oWidget.getName()#
										</h3>
									</div>

									<div class="panel-body mt5" style="min-height: 90px">
										<div class="row">
											<div class="col-md-4 text-center"><i class="fa fa-#iconName# fa-lg fa-4x"></i></div>
											<div class="col-md-8">#oWidget.getDescription()#</div>
										</div>
									</div>

									<div class="panel-footer">
										v#oWidget.getVersion()#
										By <a href="#widgetURL#" target="_blank">#oWidget.getAuthor()#</a>
										<span class="pull-right label label-primary">#prc.widgets.widgettype#</span>
									</div>
								</cfif>
							</div>
							<!--- end widget-content --->
						</div>
					</cfloop>

				</div>
				<!--- End Row --->

				<!--- Errors --->
				<div class="row">
					<cfloop array="#aWidgetErrors#" index="widgetError" >
						#widgetError#
					</cfloop>
				</div>

				<!--- No Records --->
				<div id="widgetCountAlert" class="alert alert-warning" style="display:none;">
					Sorry, no widgets matched your search!
				</div>
			</div>
		</div>
	</div>
</div>
</cfoutput>