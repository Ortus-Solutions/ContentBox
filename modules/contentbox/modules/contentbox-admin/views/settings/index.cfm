<cfoutput>
<div class="row">
    <div class="col-md-12">
        <h1 class="h1">
            <i class="fa fa-sliders fa-lg"></i>
            ContentBox Settings
        </h1>
    </div>
</div>

<div class="row">
    <div class="col-md-12">
        #cbMessageBox().renderit()#
    </div>
</div>

<div class="row">
    <div class="col-md-12">
            #html.anchor( name="top" )#
            <div class="panel panel-default">

                <div class="panel-body">

                    <!--- Vertical Nav --->
                    <div class="tabs tabs-left">
                        <!--- Tabs --->
                        <ul class="nav nav-tabs">
                            <li class="nav-item active">
								<a href="##site_options" data-toggle="tab" class="nav-link">
									<i class="fa fa-globe fa-lg"></i> All Sites
								</a>
							</li>
                            <li class="nav-item">
								<a href="##dashboard_options" data-toggle="tab" class="nav-link">
									<i class="fa fa-desktop fa-lg"></i> Administrator
								</a>
                            </li>
                            <li class="nav-item">
								<a href="##security_options" data-toggle="tab" class="nav-link">
									<i class="fa fa-key fa-lg"></i> Security
								</a>
                            </li>
                            <li class="nav-item">
								<a href="##login_options" data-toggle="tab" class="nav-link">
									<i class="fa fa-sign-in fa-lg"></i> Login
								</a>
                            </li>
                            <li class="nav-item">
								<a href="##content_options" data-toggle="tab" class="nav-link">
									<i class="fa fa-archivees fa-lg"></i> Content
								</a>
                            </li>
                            <li class="nav-item">
								<a href="##editor_options" data-toggle="tab" class="nav-link">
									<i class="fa fa-pen fa-lg"></i> Editor Options
								</a>
                            </li>
                            <li class="nav-item">
								<a href="##mediamanager" data-toggle="tab" class="nav-link">
									<i class="fa fa-photo-video fa-lg"></i> Media Manager
								</a>
                            </li>
                            <li class="nav-item">
								<a href="##gravatars" data-toggle="tab" class="nav-link">
									<i class="fa fa-portrait fa-lg"></i> Gravatars
								</a>
                            </li>
                            <li class="nav-item">
								<a href="##notifications" data-toggle="tab" class="nav-link">
									<i class="fa fa-bell fa-lg"></i> Notifications
								</a>
                            </li>
                            <li class="nav-item">
								<a href="##email_server" data-toggle="tab" class="nav-link">
									<i class="fa fa-envelope-open fa-lg"></i> Mail Server
								</a>
                            </li>
                            <li class="nav-item">
								<a href="##search_options" data-toggle="tab" class="nav-link">
									<i class="fa fa-searchengin fa-lg"></i> Search Options
								</a>
                            </li>
                            <li class="nav-item">
								<a href="##rss_options" data-toggle="tab" class="nav-link">
									<i class="fa fa-rss fa-lg"></i> RSS
								</a>
                            </li>
                            <!--- cbadmin Event --->
                            #announce( "cbadmin_onSettingsNav" )#
                        </ul>
                        <!--- End Tabs --->
                        <!--- Tab Content --->
                        <div class="tab-content">
                            <!--- ********************************************************************* --->
                            <!---                           SITE OPTIONS                                --->
                            <!--- ********************************************************************* --->

                            <div class="tab-pane active" id="site_options">
                                #view( view = "settings/sections/siteOptions", prePostExempt = true )#
							</div>

                            <!--- ********************************************************************* --->
                            <!---                           ADMIN OPTIONS                               --->
                            <!--- ********************************************************************* --->

                            <div class="tab-pane" id="dashboard_options">
                                #view( view = "settings/sections/adminOptions", prePostExempt = true )#
                            </div>

                            <!--- ********************************************************************* --->
                            <!---                           SECURITY OPTIONS                               --->
                            <!--- ********************************************************************* --->

                            <div class="tab-pane" id="security_options">
                                #view( view = "settings/sections/securityOptions", prePostExempt = true )#
                            </div>

                            <!--- ********************************************************************* --->
                            <!---                           LOGIN OPTIONS                               --->
                            <!--- ********************************************************************* --->

                            <div class="tab-pane" id="login_options">
                                #view( view = "settings/sections/loginOptions", prePostExempt = true )#
                            </div>

                            <!--- ********************************************************************* --->
                            <!---                           CONTENT OPTIONS                             --->
                            <!--- ********************************************************************* --->

                            <div class="tab-pane" id="content_options">
                                #view( view = "settings/sections/contentOptions", prePostExempt = true )#
                            </div>

                            <!--- ********************************************************************* --->
                            <!---                           EDITOR OPTIONS                              --->
                            <!--- ********************************************************************* --->

                            <div class="tab-pane" id="editor_options">
                                #view( view = "settings/sections/editorOptions", prePostExempt = true )#
                            </div>

                            <!--- ********************************************************************* --->
                            <!---                           MEDIA MANAGER                                --->
                            <!--- ********************************************************************* --->

                            <div class="tab-pane" id="mediamanager">
                                #view( view = "settings/sections/mediaManager", prePostExempt = true )#
                            </div>

                            <!--- ********************************************************************* --->
                            <!---                           GRAVATARS                                   --->
                            <!--- ********************************************************************* --->

                            <div class="tab-pane" id="gravatars">
                                #view( view = "settings/sections/gravatars", prePostExempt = true )#
                            </div>

                            <!--- ********************************************************************* --->
                            <!---                           Notifications                               --->
                            <!--- ********************************************************************* --->

                            <div class="tab-pane" id="notifications">
                                #view( view = "settings/sections/notifications", prePostExempt = true )#
                            </div>

                            <!--- ********************************************************************* --->
                            <!---                           EMAIL SERVER                                --->
                            <!--- ********************************************************************* --->

                            <div class="tab-pane" id="email_server">
                                #view( view = "settings/sections/mailServer", prePostExempt = true )#
                            </div>

                            <!--- ********************************************************************* --->
                            <!---                           SEARCH OPTIONS                              --->
                            <!--- ********************************************************************* --->

                            <div class="tab-pane" id="search_options">
                                #view( view = "settings/sections/searchOptions", prePostExempt = true )#
                            </div>

                            <!--- ********************************************************************* --->
                            <!---                           RSS OPTIONS                                 --->
                            <!--- ********************************************************************* --->

                            <div class="tab-pane" id="rss_options">
								#view( view = "settings/sections/rss", prePostExempt = true )#
                            </div>

                            <!--- cbadmin Event --->
                            #announce( "cbadmin_onSettingsContent" )#
                        </div>
                        <!--- End Tab Content --->
                    </div>
                    <!--- End Vertical Nav --->
                </div>
            </div>
    </div>
</div>
</cfoutput>
