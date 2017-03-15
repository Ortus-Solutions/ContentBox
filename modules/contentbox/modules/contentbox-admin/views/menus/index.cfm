<cfoutput>
<div class="row">
    <div class="col-md-12">
        <h1 class="h1">
            <i class="fa fa-sort-amount-desc"></i> Menu Manager
        </h1>
    </div>
</div>
<div class="row">
    <div class="col-md-12">
        <!--- MessageBox --->
        #getModel( "messagebox@cbMessagebox" ).renderit()#
        
        <!---Import Log --->
        <cfif flash.exists( "importLog" )>
            <div class="consoleLog">#flash.get( "importLog" )#</div>
        </cfif>
    </div>
</div>
<div class="row">
    <div class="col-md-12">
        #html.startForm( name="menuForm",action=prc.xehMenuRemove )#
            #html.hiddenField( name="menuID",value="" )#
            <div class="panel panel-default">
                <div class="panel-heading">
                    <div class="row">
                        <div class="col-md-6">
                            <div class="form-group form-inline no-margin">
                                #html.textField( 
                                    name="menuSearch",
                                    class="form-control",
                                    placeholder="Quick Search"
                                )#
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="pull-right">
                                <cfif prc.oAuthor.checkPermission( "MENUS_ADMIN,TOOLS_IMPORT,TOOLS_EXPORT" )>
                                    <div class="btn-group btn-group-sm">
                                        <a class="btn btn-info dropdown-toggle" data-toggle="dropdown" href="##">
                                            Bulk Actions <span class="caret"></span>
                                        </a>
                                        <ul class="dropdown-menu">
                                            <cfif prc.oAuthor.checkPermission( "MENUS_ADMIN" )>
                                                <li>
                                                    <a href="javascript:bulkRemove()" class="confirmIt" data-title="<i class='fa fa-trash-o'></i> Delete Selected Menu?" data-message="This will delete the menu, are you sure?"><i class="fa fa-trash-o"></i> Delete Selected</a>
                                                </li>
                                            </cfif>
                                            <cfif prc.oAuthor.checkPermission( "MENUS_ADMIN,TOOLS_IMPORT" )>
                                                <li><a href="javascript:importContent()"><i class="fa fa-upload"></i> Import</a></li>
                                            </cfif>
                                            <cfif prc.oAuthor.checkPermission( "MENUS_ADMIN,TOOLS_EXPORT" )>
												<li><a href="#event.buildLink (linkto=prc.xehMenuExportAll )#.json" target="_blank"><i class="fa fa-download"></i> Export All as JSON</a></li>
												<li><a href="#event.buildLink( linkto=prc.xehMenuExportAll )#.xml" target="_blank"><i class="fa fa-download"></i> Export All as XML</a></li>
											</cfif>
                                            <li><a href="javascript:contentShowAll()"><i class="fa fa-list"></i> Show All</a></li>
                                        </ul>
                                    </div>
                                </cfif>
                                <button class="btn btn-sm btn-primary" onclick="return to('#event.buildLink( linkTo=prc.xehMenuEditor)#' );">Create Menu</button>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="panel-body">
                    <!--- entries container --->
                    <div id="menuTableContainer">
                        <p class="text-center"><i id="contentLoader" class="fa fa-spinner fa-spin fa-lg icon-4x"></i></p>
                    </div>
                </div>
            </div>
        #html.endForm()#
    </div>
</div>
<cfif prc.oAuthor.checkPermission( "MENUS_ADMIN,TOOLS_IMPORT" )>
    <cfscript>
        dialogArgs = {
            title = "Import Menus",
            contentArea = "menu",
            action = prc.xehMenuImport,
            contentInfo = "Choose the ContentBox <strong>JSON</strong> menu file to import."
        };
    </cfscript>
    #renderView( view="_tags/dialog/import", args=dialogArgs )#
</cfif>
</cfoutput>