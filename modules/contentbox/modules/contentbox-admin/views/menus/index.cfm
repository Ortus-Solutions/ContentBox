<cfoutput>
<div class="row">
    <div class="col-md-12">
        <h1 class="h1">
			<i class="fas fa-bars fa-lg"></i> Menu Manager
			<span id="menusCountContainer"></span>
        </h1>
    </div>
</div>

<div class="row">
    <div class="col-md-12">
        <!--- MessageBox --->
        #cbMessageBox().renderit()#

        <!---Import Log --->
        <cfif flash.exists( "importLog" )>
            <div class="consoleLog">#flash.get( "importLog" )#</div>
        </cfif>
    </div>
</div>

<div class="row">
    <div class="col-md-12">
        #html.startForm( name="menuForm", action=prc.xehMenuRemove )#
            #html.hiddenField( name="menuID", value="" )#
            <div class="panel panel-default">
                <div class="panel-heading">
                    <div class="row">

						<div class="col-md-6 col-xs-4">
                            <div class="form-group form-inline no-margin">
                                #html.textField(
                                    name        = "menuSearch",
                                    class       = "form-control rounded quicksearch",
                                    placeholder = "Quick Search"
                                )#
                            </div>
						</div>

                        <div class="col-md-6 col-xs-8">
                            <div class="text-right">
                                <cfif prc.oCurrentAuthor.checkPermission( "MENUS_ADMIN,TOOLS_IMPORT,TOOLS_EXPORT" )>
                                    <div class="btn-group">
                                        <button class="btn dropdown-toggle btn-info" data-toggle="dropdown">
                                            Bulk Actions <span class="caret"></span>
										</button>
                                        <ul class="dropdown-menu">
                                            <cfif prc.oCurrentAuthor.checkPermission( "MENUS_ADMIN" )>
                                                <li>
                                                    <a href="javascript:bulkRemove()" class="confirmIt" data-title="<i class='far fa-trash-alt'></i> Delete Selected Menu?" data-message="This will delete the menu, are you sure?"><i class="far fa-trash-alt"></i> Delete Selected</a>
                                                </li>
                                            </cfif>
                                            <cfif prc.oCurrentAuthor.checkPermission( "MENUS_ADMIN,TOOLS_IMPORT" )>
                                                <li><a href="javascript:importContent()"><i class="fas fa-file-import fa-lg"></i> Import</a></li>
                                            </cfif>
                                            <cfif prc.oCurrentAuthor.checkPermission( "MENUS_ADMIN,TOOLS_EXPORT" )>
												<li>
													<a href="#event.buildLink (to=prc.xehMenuExportAll )#.json" target="_blank">
														<i class="fas fa-file-export fa-lg"></i> Export All
													</a>
												</li>
												<li>
													<a href="javascript:exportSelected( '#event.buildLink( prc.xehMenuExportAll )#' )">
														<i class="fas fa-file-export fa-lg"></i> Export Selected
													</a>
												</li>
											</cfif>
                                            <li><a href="javascript:contentShowAll()"><i class="fas fa-list"></i> Show All</a></li>
                                        </ul>
                                    </div>
                                </cfif>
                                <button class="btn btn-primary" onclick="return to('#event.buildLink( to=prc.xehMenuEditor)#' );">Create Menu</button>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="panel-body">
                    <!--- entries container --->
                    <div id="menuTableContainer">
						<p class="text-center">
							<i id="contentLoader" class="fa fa-spinner fa-spin fa-lg icon-4x"></i>
						</p>
                    </div>
                </div>
            </div>
        #html.endForm()#
    </div>
</div>

<!--- Import --->
<cfif prc.oCurrentAuthor.checkPermission( "MENUS_ADMIN,TOOLS_IMPORT" )>
    #renderView(
		view 			= "_tags/dialog/import",
		args 			= {
            title       : "Import Menus",
            contentArea : "menu",
            action      : prc.xehMenuImport,
            contentInfo : "Choose the ContentBox <strong>JSON</strong> menu file to import."
		},
		prePostExempt 	= true
	)#
</cfif>
</cfoutput>