<cfoutput>
    <div class="row-fluid">    
        <!--- main content --->    
        <div class="span12" id="main-content">    
            <div class="box">
                <!--- Body Header --->
                <div class="header">
                    <i class="icon-sort-by-attributes-alt icon-large"></i>
                    Menu Manager
                </div>
                <!--- Body --->
                <div class="body">
                    
                    <!--- MessageBox --->
                    #getPlugin( "MessageBox" ).renderit()#
                    
                    <!---Import Log --->
                    <cfif flash.exists( "importLog" )>
                        <div class="consoleLog">#flash.get( "importLog" )#</div>
                    </cfif>
                    
                    <!--- menuForm --->
                    #html.startForm( name="menuForm",action=prc.xehMenuRemove )#
                    #html.hiddenField( name="menuID",value="" )#
                    
                    <!--- Content Bar --->
                    <div class="well well-small" id="contentBar">
                        <!--- Create Butons --->
                        <div class="buttonBar">
                            <cfif prc.oAuthor.checkPermission( "MENUS_ADMIN,TOOLS_IMPORT,TOOLS_EXPORT" )>
                                <div class="btn-group">
                                    <a class="btn dropdown-toggle" data-toggle="dropdown" href="##">
                                        Global Actions <span class="caret"></span>
                                    </a>
                                    <ul class="dropdown-menu">
                                        <cfif prc.oAuthor.checkPermission( "MENUS_ADMIN" )>
                                            <li>
                                                <a href="javascript:bulkRemove()" class="confirmIt" data-title="Delete Selected Menu?" data-message="This will delete the menu, are you sure?"><i class="icon-trash"></i> Delete Selected</a>
                                            </li>
                                        </cfif>
                                        <cfif prc.oAuthor.checkPermission("MENUS_ADMIN,TOOLS_IMPORT")>
                                            <li><a href="javascript:importContent()"><i class="icon-upload-alt"></i> Import</a></li>
                                        </cfif>
                                        <cfif prc.oAuthor.checkPermission("MENUS_ADMIN,TOOLS_EXPORT")>
                                            <li class="dropdown-submenu">
                                                <a href="##"><i class="icon-download icon-large"></i> Export All</a>
                                                <ul class="dropdown-menu text-left">
                                                    <li><a href="#event.buildLink( linkto=prc.xehMenuExportAll )#.json" target="_blank"><i class="icon-code"></i> as JSON</a></li>
                                                    <li><a href="#event.buildLink( linkto=prc.xehMenuExportAll )#.xml" target="_blank"><i class="icon-sitemap"></i> as XML</a></li>
                                                </ul>
                                            </li>
                                        </cfif>
                                        <li><a href="javascript:contentShowAll()"><i class="icon-list"></i> Show All</a></li>
                                    </ul>
                                </div>
                            </cfif>
                            <button class="btn btn-danger" onclick="return to('#event.buildLink( linkTo=prc.xehMenuEditor)#' );">Create Menu</button>
                        </div>
                        
                        <!--- Filter Bar --->
                        <div class="filterBar">
                            <div>
                                #html.label( field="menuSearch",content="Quick Search:",class="inline" )#
                                #html.textField( name="menuSearch", class="textfield", size="30" )#
                            </div>
                        </div>
                    </div>
                    
                    <!--- menu container --->
                    <div id="menuTableContainer">
                        <p class="text-center"><i id="contentLoader" class="icon-spinner icon-spin icon-large icon-4x"></i></p>
                    </div>                
                    #html.endForm()#
                </div>  
            </div>
        </div>
    </div>
    <cfif prc.oAuthor.checkPermission("MENUS_ADMIN,TOOLS_IMPORT")>
        <div id="importDialog" class="modal hide fade">
            <div id="modalContent">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                    <h3><i class="icon-copy"></i> Import Menus</h3>
                </div>
                #html.startForm(name="importForm", action=prc.xehMenuImport, class="form-vertical", multipart=true)#
                <div class="modal-body">
                    <p>Choose the ContentBox <strong>JSON</strong> menu file to import.</p>
                    #getMyPlugin( plugin="BootstrapFileUpload", module="contentbox" ).renderIt( 
                        name="importFile", 
                        required=true
                    )#
                    
                    <label for="overrideContent">Override menus?</label>
                    <small>By default all menus that exist are not overwritten.</small><br>
                    #html.select(options="true,false", name="overrideContent", selectedValue="false", class="input-block-level",wrapper="div class=controls",labelClass="control-label",groupWrapper="div class=control-group")#
                    
                    <!---Notice --->
                    <div class="alert alert-info">
                        <i class="icon-info-sign icon-large"></i> Please note that import is an expensive process, so please be patient when importing.
                    </div>
                </div>
                <div class="modal-footer">
                    <!--- Button Bar --->
                    <div id="importButtonBar">
                        <button class="btn" id="closeButton"> Cancel </button>
                        <button class="btn btn-danger" id="importButton"> Import </button>
                    </div>
                    <!--- Loader --->
                    <div class="center loaders" id="importBarLoader">
                        <i class="icon-spinner icon-spin icon-large icon-2x"></i>
                        <br>Please wait, doing some hardcore importing action...
                    </div>
                </div>
                #html.endForm()#
            </div>
        </div>
    </cfif>
</cfoutput>