<cfoutput>
<div class="row-fluid" id="main-content">
	<div class="box">
		<!--- Body Header --->
		<div class="header">
			<i class="icon-road icon-large"></i>
			Security Rule Editor
		</div>
		<!--- Body --->
		<div class="body">
			#html.startForm(name="ruleEditForm",action=prc.xehRuleSave,novalidate="novalidate",class="form-vertical")#
                <!--- ruleID --->
                #html.hiddenField(name="ruleID",bind=prc.rule)#
    			<!--- MessageBox --->
    			#getPlugin("MessageBox").renderit()#
    			
    			<!--- fields --->
    			#html.startFieldset(legend="<strong>Rule Match</strong>")#
    				<!--- Usage --->
    				<div class="alert alert-danger">
    					<i class="icon-warning-sign icon-large"></i>
    					Please remember that the secure and white lists are lists of 
    					<a href="http://www.regular-expressions.info/reference.html" target="_blank">regular expressions</a> that will match against an incoming
    					event pattern string or a routed URL string.  So remember the event pattern syntax: <em>[moduleName:][package.]handler[.action]</em> if you will
    					be using event type matching. If you are using URL matching then do NOT start your patterns with <strong>'/'</strong> as it is pre-pended for you.
    				</div>
                    <div class="control-group">
                        #html.label(field="match",content="Match Type:")#
                        <div class="controls">
                            <small><strong>URL:</strong> matches the incoming routed URL, <strong>Event:</strong> matches the incoming event</small><br/>
            				#html.radioButton(name="match",value='url',bind=prc.rule)# URL	
            				#html.radioButton(name="match",value='event',bind=prc.rule)# Event
                        </div>
                    </div>
    				
    				#html.textField(name="secureList",label="*Secure List:",bind=prc.rule,required="required",maxlength="255",class="textfield",size="100",title="The list of regular expressions that if matched it will trigger security for this rule.",wrapper="div class=controls",labelClass="control-label",groupWrapper="div class=control-group")#
    				#html.textField(name="whiteList",label="White List:",bind=prc.rule,maxlength="255",class="textfield",size="100",title="The list of regular expressions that if matched it will allow them through for this rule.",wrapper="div class=controls",labelClass="control-label",groupWrapper="div class=control-group")#
    			
    				#html.textField(name="order",label="Firing Order Index:",bind=prc.rule,size="5",wrapper="div class=controls",labelClass="control-label",groupWrapper="div class=control-group")#
    			
    			#html.endFieldset()#
    			
    			#html.startFieldset(legend="Security Roles & Permissions")#
    				#html.textField(name="permissions",label="Permissions:",bind=prc.rule,maxlength="500",class="textfield",size="100",title="The list of security permissions needed to access the secured content of this rule.",wrapper="div class=controls",labelClass="control-label",groupWrapper="div class=control-group")#
    				#html.textField(name="roles",label="Roles:",bind=prc.rule,maxlength="500",class="textfield",size="100",title="The list of security roles needed to access the secured content of this rule.",wrapper="div class=controls",labelClass="control-label",groupWrapper="div class=control-group")#
    			#html.endFieldset()#
    			
    			#html.startFieldset(legend="<strong>Relocation Data</strong>")#
    				<div class="control-group">
                        #html.label(field="useSSL",content="Redirect using SSL:")#
                        <div class="controls">
                            #html.radioButton(name="useSSL",value=true,bind=prc.rule)# Yes 	
    						#html.radioButton(name="useSSL",value=false,bind=prc.rule)# No 	
                        </div>
                    </div>
    				    				
    				#html.textField(name="redirect",label="*Redirect Pattern:",required="required",bind=prc.rule,maxlength="255",class="textfield",size="100",title="The URL pattern to redirect to if user does not have access to this rule.",wrapper="div class=controls",labelClass="control-label",groupWrapper="div class=control-group")#
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
</cfoutput>