<cfoutput>
<div class="row">
    <div class="col-md-12">
        <h1 class="h1">
            <i class="fa fa-road fa-lg"></i>
            Security Rule Editor
        </h1>
        <!--- messageBox --->
        #getModel( "messagebox@cbMessagebox" ).renderit()#
    </div>
</div> 
<div class="row">
    <div class="col-md-12">
        <div class="panel panel-default">
            <div class="panel-body">
                #html.startForm(
                    name="ruleEditForm",
                    action=prc.xehRuleSave,
                    novalidate="novalidate",
                    class="form-vertical"
                )#
                    <!--- ruleID --->
                    #html.hiddenField( name="ruleID",bind=prc.rule )#
                    <!--- fields --->
                    #html.startFieldset( legend="Rule Match" )#
                        <!--- Usage --->
                        <div class="alert alert-danger">
                            <i class="fa fa-exclamation-triangle fa-lg"></i>
                            Please remember that the secure and white lists are lists of 
                            <a href="http://www.regular-expressions.info/reference.html" target="_blank">regular expressions</a> that will match against an incoming
                            event pattern string or a routed URL string.  So remember the event pattern syntax: <em>[moduleName:][package.]handler[.action]</em> if you will
                            be using event type matching. If you are using URL matching then do NOT start your patterns with <strong>'/'</strong> as it is pre-pended for you.
                        </div>
                        <div class="form-group">
                            #html.label(
                                field="match",
                                content="Match Type:",
                                class="control-label"
                            )#
                            <div class="controls">
                                <small><strong>URL:</strong> matches the incoming routed URL, <strong>Event:</strong> matches the incoming event</small><br/>
                                #html.radioButton(
                                    name="match",
                                    value='url',
                                    bind=prc.rule
                                )# URL  
                                #html.radioButton(
                                    name="match",
                                    value='event',
                                    bind=prc.rule
                                )# Event
                            </div>
                        </div>
                        
                        #html.textField(
                            name="secureList",
                            label="*Secure List:",
                            bind=prc.rule,
                            required="required",
                            maxlength="255",
                            class="form-control",
                            size="100",
                            title="The list of regular expressions that if matched it will trigger security for this rule.",
                            wrapper="div class=controls",
                            labelClass="control-label",
                            groupWrapper="div class=form-group"
                        )#
                        #html.textField(
                            name="whiteList",
                            label="White List:",
                            bind=prc.rule,
                            maxlength="255",
                            class="form-control",
                            size="100",
                            title="The list of regular expressions that if matched it will allow them through for this rule.",
                            wrapper="div class=controls",
                            labelClass="control-label",
                            groupWrapper="div class=form-group"
                        )#
                    
                        #html.textField(
                            name="order",
                            label="Firing Order Index:",
                            bind=prc.rule,
                            size="5",
                            class="form-control",
                            wrapper="div class=controls",
                            labelClass="control-label",
                            groupWrapper="div class=form-group"
                        )#
                    
                    #html.endFieldset()#
                    
                    #html.startFieldset( legend="Security Roles & Permissions" )#
                        #html.textField(
                            name="permissions",
                            label="Permissions:",
                            bind=prc.rule,
                            maxlength="500",
                            class="form-control",
                            size="100",
                            title="The list of security permissions needed to access the secured content of this rule.",
                            wrapper="div class=controls",
                            labelClass="control-label",
                            groupWrapper="div class=form-group"
                        )#
                        #html.textField(
                            name="roles",
                            label="Roles:",
                            bind=prc.rule,
                            maxlength="500",
                            class="form-control",
                            size="100",
                            title="The list of security roles needed to access the secured content of this rule.",
                            wrapper="div class=controls",
                            labelClass="control-label",
                            groupWrapper="div class=form-group"
                        )#
                    #html.endFieldset()#
                    
                    #html.startFieldset( legend="Relocation Data" )#
                        <div class="form-group">
                            #html.label(
                                field="useSSL",
                                content="Redirect using SSL:",
                                class="control-label"
                            )#
                            <div class="controls">
                                #html.radioButton(
                                    name="useSSL",
                                    value=true,
                                    bind=prc.rule
                                )# Yes  
                                #html.radioButton(
                                    name="useSSL",
                                    value=false,
                                    bind=prc.rule
                                )# No  
                            </div>
                        </div>
                                            
                        #html.textField(
                            name="redirect",
                            label="*Redirect Pattern:",
                            required="required",
                            bind=prc.rule,
                            maxlength="255",
                            class="form-control",
                            size="100",
                            title="The URL pattern to redirect to if user does not have access to this rule.",
                            wrapper="div class=controls",
                            labelClass="control-label",
                            groupWrapper="div class=form-group"
                        )#
                        
                        #html.select(
                            name="messageType",
                            label="Relocation Message Type:",
                            bind=prc.rule,
                            options="Info,Warn,Error,Fatal,Debug",
                            class="form-control input-lg",
                            title="The message type of the relocation",
                            wrapper="div class=controls",
                            labelClass="control-label",
                            groupWrapper="div class=form-group"
                        )#

                        #html.textField(
                            name="message",
                            label="Relocation Message:",
                            bind=prc.rule,
                            maxlength="255",
                            class="form-control",
                            size="100",
                            title="The message to show the user upon relocation",
                            wrapper="div class=controls",
                            labelClass="control-label",
                            groupWrapper="div class=form-group"
                        )#
                    #html.endFieldset()#
                    
                    <!--- Action Bar --->
                    <div class="form-actions">
                        <button class="btn" onclick="return to('#event.buildLink(prc.xehSecurityRules)#')">Cancel</button>
                        &nbsp;<button type="submit" class="btn btn-danger">Save</button>
                    </div>
                #html.endForm()#
            </div>
        </div>
    </div>
</div>
</cfoutput>