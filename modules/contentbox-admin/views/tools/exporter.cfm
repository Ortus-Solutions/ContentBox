<cfoutput>
#html.startForm( name="exporterForm", action=prc.xehExport, novalidate="novalidate")#     
<div class="row-fluid">

    <!--- main content --->
    <div class="span12" id="main-content">
        <div class="box">
            <!--- Body Header --->
            <div class="header">
                <i class="icon-exchange icon-large"></i>
                Export Tools
            </div>
            <!--- Body --->
            <div class="body">
                <!--- messageBox --->
                #getPlugin("MessageBox").renderit()#
                <div class="hero-unit">
                    <p>What, you thought exporting content would be hard? Sorry to disappoint! ;)</p>
                    <div class="control-group">
                        <div class="controls row-fluid">
                            <div class="span6 well well-small text-center alert-success">
                                <h2>Option ##1: Everything!</h2>
                                <small>No mess, no fuss, just a full and beautiful export of your ContentBox site. </small><br />
                                <label class="btn btn-success btn-toggle radio" for="export_everything">
                                    #html.radioButton(name="export_type",id="export_everything",checked=true,value="everything")# Export Everything
                                </label>
                            </div>
                            <div class="span6 well well-small text-center">
                                <h2>Option ##2: Mr. Picky</h2>
                                <small>For the more discriminating, select only the bits that you want to export.</small><br />
                                <label class="btn btn-toggle radio clearfix" for="export_selective">
                                    #html.radioButton(name="export_type",id="export_selective",value="selective")# 
                                    Export a-la-carte
                                </label>
                            </div>
                        </div>
                    </div>
                </div>
                <fieldset style="display:none;" id="selective_controls" class="well">
                    <div class="row-fluid">
                        <div class="span3">
                            <h4><i class="icon-file-alt icon-large"></i> Pages</h4>
                            <small class="muted">Export site pages with comments</small>
                        </div>
                        <div class="span9">
                            <div class="controls checkbox-spacer">
                                <label for="export_pages" class="checkbox">#html.checkbox(name="export_pages",checked=true)# All Pages (with comments)</label>
                            </div>
                        </div>
                    </div>
                    <hr>
                    <div class="row-fluid">
                        <div class="span3">
                            <h4><i class="icon-quote-left icon-large"></i> Entries</h4>
                            <small class="muted">Export blog entries with comments</small>
                        </div>
                        <div class="span9">
                            <div class="controls checkbox-spacer">
                                <label for="export_entries" class="checkbox">#html.checkbox(name="export_entries",checked=true)# All Entries (with comments)</label>
                            </div>
                        </div>
                    </div>
                    <hr>
                    <div class="row-fluid">
                        <div class="span3">
                            <h4><i class="icon-tags icon-large"></i> Categories</h4>
                            <small class="muted">Export categories</small>
                        </div>
                        <div class="span9">
                            <div class="controls checkbox-spacer">
                                <label for="export_categories" class="checkbox">#html.checkbox(name="export_categories",checked=true)# All Categories</label>
                            </div>
                        </div>
                    </div>
                    <hr>
                    <div class="row-fluid">
                        <div class="span3">
                            <h4><i class="icon-hdd icon-large"></i> Content Store</h4>
                            <small class="muted">Export the Content Store</small>
                        </div>
                        <div class="span9">
                            <div class="controls checkbox-spacer">
                                <label for="export_contentstore" class="checkbox">#html.checkbox(name="export_contentstore",checked=true)# All Content Store</label>
                            </div>
                        </div>
                    </div>
                    <hr>
                    <div class="row-fluid">
                        <div class="span3">
                            <h4><i class="icon-sort-by-attributes-alt icon-large"></i> Menus</h4>
                            <small class="muted">Export menus</small>
                        </div>
                        <div class="span9">
                            <div class="controls checkbox-spacer">
                                <label for="export_menus" class="checkbox">#html.checkbox(name="export_menus",checked=true)# All Menus</label>
                            </div>
                        </div>
                    </div>
                    <hr>
                    <div class="row-fluid">
                        <div class="span3">
                            <h4><i class="icon-user icon-large"></i> Authors</h4>
                            <small class="muted">Export all site authors</small>
                        </div>
                        <div class="span9">
                            <div class="controls checkbox-spacer">
                                <label for="export_authors" class="checkbox">#html.checkbox(name="export_authors",checked=true)# All Authors</label>
                            </div>
                        </div>
                    </div>
                    <hr>
                    <div class="row-fluid">
                        <div class="span3">
                            <h4><i class="icon-lock icon-large"></i> Permission</h4>
                            <small class="muted">Export all author permissions</small>
                        </div>
                        <div class="span9">
                            <div class="controls checkbox-spacer">
                                <label for="export_permissions" class="checkbox">#html.checkbox(name="export_permissions",checked=true)# All Permissions</label>
                            </div>
                        </div>
                    </div>
                    <hr>
                    <div class="row-fluid">
                        <div class="span3">
                            <h4><i class="icon-group icon-large"></i> Roles</h4>
                            <small class="muted">Export all author roles</small>
                        </div>
                        <div class="span9">
                            <div class="controls checkbox-spacer">
                                <label for="export_roles" class="checkbox">#html.checkbox(name="export_roles",checked=true)# All Roles</label>
                            </div>
                        </div>
                    </div>
                    <hr>
                    <div class="row-fluid">
                        <div class="span3">
                            <h4><i class="icon-road icon-large"></i> Security Rules</h4>
                            <small class="muted">Export configured site security rules</small>
                        </div>
                        <div class="span9">
                            <div class="controls checkbox-spacer">
                                <label for="export_securityrules" class="checkbox">#html.checkbox(name="export_securityrules",checked=true)# All Security Rules</label>
                            </div>
                        </div>
                    </div>
                    <hr>
                    <div class="row-fluid">
                        <div class="span3">
                            <h4><i class="icon-wrench icon-large"></i> Settings</h4>
                            <small class="muted">Export all site settings</small>
                        </div>
                        <div class="span9">
                            <div class="controls checkbox-spacer">
                                <label for="export_settings" class="checkbox">#html.checkbox(name="export_settings",checked=true)# All Settings</label>
                            </div>
                        </div>
                    </div>
                    <hr>
                    <div class="row-fluid">
                        <div class="span3">
                            <h4><i class="icon-th icon-large"></i> Media Library</h4>
                            <small class="muted">Export all Media Library content</small>
                        </div>
                        <div class="span9">
                            <div class="controls checkbox-spacer">
                                <label for="export_medialibrary" class="checkbox">#html.checkbox(name="export_medialibrary",checked=true)# All Media Library</label>
                            </div>
                        </div>
                    </div>
                    <hr>
                    <div class="row-fluid">
                        <div class="span3">
                            <h4><i class="icon-envelope icon-large"></i> Email Templates</h4>
                            <label class="checkbox" for="toggle_emailtemplates">
                                #html.checkbox(name="toggle_emailtemplates",checked=true,data={togglegroup="export_emailtemplates"})# Toggle All
                            </label>
                            <small class="muted clearfix">Export email templates, all or a-la-carte</small>
                        </div>
                        <div class="span9">
                            <div class="controls checkbox-spacer">
                                <div class="row-fluid">
                                    <cfloop query="prc.emailTemplates">
                                        <div class="span6">
                                            <cfset name = prc.emailTemplates.name>
                                            <label for="export_emailtemplates_#name#" class="checkbox">#html.checkbox(name="export_emailtemplates",id="export_emailtemplates_#name#",value="#name#",checked=true,data={alacarte=true})# #name#</label>
                                        </div>
                                        <cfif currentRow MOD 2 eq 0>
                                            </div>
                                            <div class="row-fluid">
                                        </cfif>
                                    </cfloop>
                                </div>
                            </div>
                        </div>
                    </div>
                    <hr>
                    <div class="row-fluid">
                        <div class="span3">
                            <h4><i class="icon-bolt icon-large"></i> Modules</h4>
                            <label class="checkbox" for="toggle_modules">
                                #html.checkbox(name="toggle_modules",checked=true,data={togglegroup="export_modules"})# Toggle All
                            </label>
                            <small class="muted clearfix">Export modules, all or a-la-carte</small>
                        </div>
                        <div class="span9">
                            <div class="controls checkbox-spacer">
                                <div class="row-fluid">
                                    <cfset mcounter = 1>
                                    <cfloop array="#prc.modules#" index="module">
                                        <div class="span6">
                                            <cfset name = module.getName()>
                                            <label for="export_modules_#name#" class="checkbox">#html.checkbox(name="export_modules",id="export_modules_#name#",value="#name#",checked=true,data={alacarte=true})# #module.getTitle()#</label>
                                        </div>
                                        <cfif mcounter MOD 2 eq 0>
                                            </div>
                                            <div class="row-fluid">
                                        </cfif>
                                        <cfset mcounter++>
                                    </cfloop>
                                </div>
                            </div>
                        </div>
                    </div>
                    <hr>
                    <div class="row-fluid">
                        <div class="span3">
                            <h4><i class="icon-picture icon-large"></i> Layouts</h4>
                            <label class="checkbox" for="toggle_layouts">
                                #html.checkbox(name="toggle_layouts",checked=true,data={togglegroup="export_layouts"})# Toggle All
                            </label>
                            <small class="muted clearfix">Export layouts, all or a-la-carte</small>
                        </div>
                        <div class="span9">
                            <div class="controls checkbox-spacer">
                                <div class="row-fluid">
                                    <cfloop query="prc.layouts">
                                        <div class="span6">
                                            <cfset name = prc.layouts.name>
                                            <label for="export_layouts_#name#" class="checkbox">#html.checkbox(name="export_layouts",id="export_layouts_#name#",value="#prc.layouts.name#",checked=true,data={alacarte=true})# #name#</label>
                                        </div>
                                        <cfif currentRow MOD 2 eq 0>
                                            </div>
                                            <div class="row-fluid">
                                        </cfif>
                                    </cfloop>
                                </div>
                            </div>
                        </div>
                    </div>
                    <hr>
                    <div class="row-fluid">
                        <div class="span3">
                            <h4><i class="icon-magic icon-large"></i> Widgets</h4>
                            <label class="checkbox" for="toggle_widgets">
                                #html.checkbox(name="toggle_widgets",checked=true,data={togglegroup="export_widgets"})# Toggle All
                            </label>
                            <small class="muted clearfix">Export core widgets, all or a-la-carte. For layout or module widgets, please export the necessary layout and/or modules.</small>
                        </div>
                        <div class="span9">
                            <div class="controls checkbox-spacer">
                                <div class="row-fluid">
                                    <cfset counter = 1>
                                    <cfloop query="prc.widgets">
                                        <cfif prc.widgets.widgettype eq "Core">
                                            <div class="span6">
                                                <cfset p = prc.widgets.plugin>
                                                <cfset name = prc.widgets.name>
                                                <label for="export_widgets_#name#" class="checkbox">#html.checkbox(name="export_widgets",id="export_widgets_#name#",value="#name#",checked=true,data={alacarte=true})# #p.getPluginName()#</label>
                                            </div>
                                            <cfif counter MOD 2 eq 0>
                                                </div>
                                                <div class="row-fluid">
                                            </cfif>
                                            <cfset counter++>
                                        </cfif>
                                    </cfloop>
                                </div>
                            </div>
                        </div>
                    </div>
                    <hr>
                </fieldset>


                <!--- Submit Button --->
                <div class="actionBar" id="uploadBar">
                    #html.button( type="button", value="<i class='icon-search'></i> Preview Export", class="btn btn-normal btn-large", onclick="return previewExport()" )#
                    #html.button( type="button", value="<i class='icon-download' id='export-icon'></i> Start Export", class="btn btn-danger btn-large", 
                                   onclick="doExport()" )#
                </div>
                
                <!--- Loader --->
                <div class="loaders" id="uploadBarLoader">
                    <i class="icon-spinner icon-spin icon-large icon-4x"></i><br/>
                   <h2> Doing some awesome exporting action, please wait...</h2><br>
                </div>


            </div>
        </div>
    </div>

</div>
#html.endForm()#

<div id="exportPreviewDialog" class="modal hide fade">
    <div id="modalContent">
        <div class="modal-header">
            <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
            <h4><i class="icon-exchange"></i> Export Preview</h4>
        </div>
        <div class="modal-body" id="previewBody"></div>
    </div>
</div>
</cfoutput>