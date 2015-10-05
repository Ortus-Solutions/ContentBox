<cfoutput>
<div class="row">
    <div class="col-md-12">
        <h1 class="h1">
            <i class="fa fa-wrench fa-lg"></i>
            ContentBox Settings
        </h1>
    </div>
</div>
<div class="row">
    <div class="col-md-12">
        #getModel( "messagebox@cbMessagebox" ).renderit()#
    </div>
</div>
<div class="row">
    <div class="col-md-12">
        #html.startForm(name="settingsForm", action=prc.xehSaveSettings, novalidate="novalidate" )#
            #html.anchor(name="top" )#
            <div class="panel panel-default">
                <div class="panel-body">
                    <!--- Vertical Nav --->
                    <div class="tab-wrapper tab-left tab-primary">
                        <!--- Tabs --->
                        <ul class="nav nav-tabs">
                            <li class="active">
                                <a href="##site_options" data-toggle="tab"><i class="fa fa-cog fa-lg"></i> Site Options</a>
                            </li>
                            <li>
                                <a href="##dashboard_options" data-toggle="tab"><i class="fa fa-desktop fa-lg"></i> Admin Options</a>
                            </li>
                            <li>
                                <a href="##security_options" data-toggle="tab"><i class="fa fa-lock fa-lg"></i> Security Options</a>
                            </li>
                            <li>
                                <a href="##content_options" data-toggle="tab"><i class="fa fa-file fa-lg"></i> Content Options</a>
                            </li>
                            <li>
                                <a href="##editor_options" data-toggle="tab"><i class="fa fa-edit fa-lg"></i> Editor Options</a>
                            </li>
                            <li>
                                <a href="##mediamanager" data-toggle="tab"><i class="fa fa-th fa-lg"></i> Media Manager</a>
                            </li>
                            <li>
                                <a href="##gravatars" data-toggle="tab"><i class="fa fa-user fa-lg"></i> Gravatars</a>
                            </li>
                            <li>
                                <a href="##notifications" data-toggle="tab"><i class="fa fa-bullhorn fa-lg"></i> Notifications</a>
                            </li>
                            <li>
                                <a href="##email_server" data-toggle="tab"><i class="fa fa-envelope fa-lg"></i> Mail Server</a>
                            </li>
                            <li>
                                <a href="##search_options" data-toggle="tab"><i class="fa fa-search fa-lg"></i> Search Options</a>
                            </li>
                            <li>
                                <a href="##rss_options" data-toggle="tab"><i class="fa fa-rss fa-lg"></i> RSS</a>
                            </li>
                            <!--- cbadmin Event --->
                            #announceInterception( "cbadmin_onSettingsNav" )#
                        </ul>
                        <!--- End Tabs --->
                        <!--- Tab Content --->
                        <div class="tab-content">
                            <!--- ********************************************************************* --->
                            <!---                           SITE OPTIONS                                --->
                            <!--- ********************************************************************* --->
                            
                            <div class="tab-pane active" id="site_options">
                                #renderView( "settings/sections/siteOptions" )#
                            </div>

                            <!--- ********************************************************************* --->
                            <!---                           ADMIN OPTIONS                               --->
                            <!--- ********************************************************************* --->
                            
                            <div class="tab-pane" id="dashboard_options">
                                #renderView( "settings/sections/adminOptions" )#
                            </div>

                            <!--- ********************************************************************* --->
                            <!---                           SECURITY OPTIONS                               --->
                            <!--- ********************************************************************* --->
                            
                            <div class="tab-pane" id="security_options">
                                #renderView( "settings/sections/securityOptions" )#
                            </div>
                            
                            <!--- ********************************************************************* --->
                            <!---                           CONTENT OPTIONS                             --->
                            <!--- ********************************************************************* --->
                            
                            <div class="tab-pane" id="content_options">
                                #renderView( "settings/sections/contentOptions" )#
                            </div>
                            
                            <!--- ********************************************************************* --->
                            <!---                           EDITOR OPTIONS                              --->
                            <!--- ********************************************************************* --->
                            
                            <div class="tab-pane" id="editor_options">
                                #renderView( "settings/sections/editorOptions" )#
                            </div>
                            
                            <!--- ********************************************************************* --->
                            <!---                           MEDIA MANAGER                                --->
                            <!--- ********************************************************************* --->
                            
                            <div class="tab-pane" id="mediamanager">
                                #renderView( "settings/sections/mediaManager" )#
                            </div>
                            
                            <!--- ********************************************************************* --->
                            <!---                           GRAVATARS                                   --->
                            <!--- ********************************************************************* --->
                            
                            <div class="tab-pane" id="gravatars">
                                #renderView( "settings/sections/gravatars" )#
                            </div>

                            <!--- ********************************************************************* --->
                            <!---                           Notifications                               --->
                            <!--- ********************************************************************* --->
                            
                            <div class="tab-pane" id="notifications">
                                #renderView( "settings/sections/notifications" )#
                            </div>
                            
                            <!--- ********************************************************************* --->
                            <!---                           EMAIL SERVER                                --->
                            <!--- ********************************************************************* --->
                            
                            <div class="tab-pane" id="email_server">
                                #renderView( "settings/sections/mailServer" )#
                            </div>

                            <!--- ********************************************************************* --->
                            <!---                           SEARCH OPTIONS                              --->
                            <!--- ********************************************************************* --->
                            
                            <div class="tab-pane" id="search_options">
                                #renderView( "settings/sections/searchOptions" )#
                            </div>

                            <!--- ********************************************************************* --->
                            <!---                           RSS OPTIONS                                 --->
                            <!--- ********************************************************************* --->

                            <div class="tab-pane" id="rss_options">
                                #renderView( "settings/sections/rss" )#
                            </div>

                            <!--- cbadmin Event --->
                            #announceInterception( "cbadmin_onSettingsContent" )#

                            <!--- Button Bar --->
                            <div class="form-actions">
                                #html.submitButton(value="Save Settings", class="btn btn-danger" )#
                            </div>
                        </div>
                        <!--- End Tab Content --->
                    </div>
                    <!--- End Vertical Nav --->
                </div>
            </div>
        #html.endForm()#
    </div>
</div>
</cfoutput>