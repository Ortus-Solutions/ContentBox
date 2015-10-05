<cfoutput>
<div class="row">
    <div class="col-md-12">
        <h1 class="h1"><i class="fa fa-bolt"></i> Auto Updates</h1>
    </div>
</div>
<div class="row">
    <div class="col-md-8">
        <div class="panel panel-default">
            <div class="panel-body">
                #getModel( "messagebox@cbMessagebox" ).renderit()#
                
                <p>You can patch ContentBox in order to receive the latest bugfixes and enhancements from here.  We do encourage you
                to make backups when doing auto-udpates.</p>
                <!---Begin Accordion--->
                <div id="accordion" class="panel-group accordion">
                    <!---Begin Check--->
                    <div class="panel panel-default">
                        <div class="panel-heading">
                            <a class="accordion-toggle" data-toggle="collapse" data-parent="##accordion" href="##check">
                                <i class="fa fa-globe fa-lg"></i> Check For Updates
                            </a>
                        </div>
                        <div id="check" class="panel-collapse collapse in">
                            <div class="panel-body">
                                <!--- Update Form --->
                                #html.startForm(name="updateCheckForm",novalidate="novalidate" )#
                                    <p>Select your update channel so we can check if there are any new releases available for you.</p>
                                    
                                    #html.radioButton(name="channel",id="stable",value=prc.updateSlugStable,checked="false",checked=true)#
                                    <label for="stable" class="inline">Stable Release</label> : Official ContentBox releases.
                                    <br/>
                                    
                                    #html.radioButton(name="channel",id="beta",value=prc.updateSlugBeta,checked="false" )#
                                    <label for="beta" class="inline">Bleeding Edge Release</label> : Beta releases can be done at your own risk as it is still in development.
                                    
                                    <br/><br/>
                                    #html.button(value="Check For Updates",class="btn btn-danger",onclick="return checkForUpdates()" )#
                                #html.endForm()#    
                            </div>
                        </div>
                    </div>
                    <!---End Check--->
                    
                    <!---Begin Download--->
                    <div class="panel panel-default">
                        <div class="panel-heading">
                            <a class="accordion-toggle collapsed" data-toggle="collapse" data-parent="##accordion" href="##download">
                                <i class="fa fa-download fa-lg"></i> Download Update
                            </a>
                        </div>
                        <div id="download" class="panel-collapse collapse">
                            <div class="panel-body">
                                <!--- Update Form --->
                                #html.startForm(
                                    name="updateNowForm",
                                    action=prc.xehInstallUpdate,
                                    novalidate="novalidate",
                                    class="form-vertical"
                                )#
                                    <p>You can apply an update by selecting the download URL of the update archive.</p>
                                    
                                    #html.inputfield(
                                        type="url",
                                        required="required",
                                        name="downloadURL",
                                        label="Download URL:", 
                                        class="form-control",
                                        size="75",
                                        wrapper="div class=controls",
                                        labelClass="control-label",
                                        groupWrapper="div class=form-group"
                                    )#
                                    #html.submitButton(value="Install Update", class="btn btn-danger" )#   
                                #html.endForm()#    
                            </div>
                        </div>
                    </div>
                    <!---End Download--->
                        
                    <!---Begin Upload--->
                    <div class="panel panel-default">
                        <div class="panel-heading">
                            <a class="accordion-toggle collapsed" data-toggle="collapse" data-parent="##accordion" href="##upload">
                                <i class="fa fa-upload fa-lg"></i> Upload Update
                            </a>
                        </div>
                        <div id="upload" class="panel-collapse collapse">
                            <div class="panel-body">
                                <!--- Upload Form --->
                                #html.startForm(
                                    name="uploadNowForm",
                                    action=prc.xehUploadUpdate,
                                    multipart=true,
                                    novalidate="novalidate",
                                    class="form-vertical"
                                )#
                                    <p>You can also apply an update by uploading the update archive.</p>
                                    #getModel( "BootstrapFileUpload@contentbox-admin" ).renderIt( 
                                        name    = "filePatch", 
                                        label   = "Upload Patch:",
                                        required= true
                                    )#
                                    #html.submitButton(value="Upload & Install Update",class="btn btn-danger" )#
                                #html.endForm()#    
                            </div>
                        </div>
                    </div>
                    <!---End Check--->
                </div>
                <!---End Accordion--->  
                
                <!--- Logs --->
                <cfif len(prc.installLog)>
                    <hr/>
                    <h3>Installation Log</h3>
                    <div class="consoleLog">#prc.installLog#</div>
                    #html.button(value="Clear Log",class="btn btn-primary",onclick="to ('#event.buildLink(prc.xehAutoUpdater)#/index/clearlogs/true')" )#
                </cfif>
            </div>
        </div>
    </div>
    <div class="col-md-4">
        <div class="panel panel-primary">
            <div class="panel-heading">
                <h3 class="panel-title"><i class="fa fa-info-circle"></i> Components Installed</h3>
            </div>
            <div class="panel-body">
                <table name="settings" id="settings" class="table table-striped table-hover" width="98%">
                    <thead>
                        <tr class="info">
                            <th>Module</th> 
                            <th width="100" class="text-center">Version</th>
                        </tr>
                    </thead>
                    
                    <tbody>
                        <tr>
                            <th>
                                ContentBox Core <br/>
                                (Codename: <a href="#getModuleSettings( "contentbox" ).codenameLink#" target="_blank">#getModuleSettings( "contentbox" ).codename#</a>)
                            </th>
                            <th class="text-center">v.#getModuleConfig('contentbox').version#</th>
                        </tr>
                        <tr>
                            <th>ContentBox Admin</th>
                            <th class="text-center">v.#getModuleConfig('contentbox-admin').version#</th>
                        </tr>
                        <tr>
                            <th>ContentBox UI</th>
                            <th class="text-center">v.#getModuleConfig('contentbox-ui').version#</th>
                        </tr>
                        <tr>
                            <th>ColdBox Platform</th>
                            <th class="text-center">v.#getSetting( "Version",1)#</th>
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>
        <div class="panel panel-primary">
            <div class="panel-heading">
                <h3 class="panel-title"><i class="fa fa-medkit"></i> Need Help?</h3>
            </div>
            <div class="panel-body">
                <!--- need help --->
                #renderView(view="_tags/needhelp", module="contentbox-admin" )#
            </div>
        </div>
    </div>
</div>
</cfoutput>