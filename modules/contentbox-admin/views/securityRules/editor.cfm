<cfoutput>
#html.startForm(name="ruleEditForm",action=prc.xehRuleSave,novalidate="novalidate")#
<!--- ruleID --->
#html.hiddenField(name="ruleID",bind=prc.rule)#
	
<!--============================Sidebar============================-->
<div class="sidebar">
	<!--- Info Box --->
	<div class="small_box">
		<div class="header">
			<img src="#prc.cbroot#/includes/images/tools_icon.png" alt="info" width="24" height="24" />
			Actions
		</div>
		<div class="body">
				
			<!--- Action Bar --->
			<div class="actionBar center">
				<button class="button2" onclick="return to('#event.buildLink(prc.xehSecurityRules)#')">Cancel</button>
				&nbsp;<input type="submit" class="buttonred" value="Save">
			</div>
			
		</div>
	</div>		
</div>
<!--End sidebar-->	
<!--============================Main Column============================-->

<div class="main_column">
	<div class="box">
		<!--- Body Header --->
		<div class="header">
			<img src="#prc.cbroot#/includes/images/securityRule.png" alt="securityRule" width="30" height="30" />
			Security Rule Editor
		</div>
		<!--- Body --->
		<div class="body">
			
			<!--- MessageBox --->
			#getPlugin("MessageBox").renderit()#
		
			<!--- fields --->
			#html.startFieldset(legend="Security")#
				<!--- Usage --->
				<div class="infoBar">
					<img src="#prc.cbRoot#/includes/images/info.png" alt="info" />
					Please remember that the secure and white lists are lists of 
					<a href="http://www.regular-expressions.info/reference.html" target="_blank">regular expressions</a> that will match against an incoming
					event pattern string or a routed URL string.  So remember the event pattern syntax: <em>[moduleName:][package.]handler[.action]</em> if you will
					be using event type matching. If you are using URL matching then do NOT start your patterns with <strong>'/'</strong> as it is pre-pended for you.
				</div>
				#html.label(field="match",content="Match Type:")#
				<small><strong>URL:</strong> matches the incoming routed URL, <strong>Event:</strong> matches the incoming event</small><br/>
				#html.radioButton(name="match",value='url',bind=prc.rule)# URL	
				#html.radioButton(name="match",value='event',bind=prc.rule)# Event
				
				#html.textField(name="secureList",label="*Secure List:",bind=prc.rule,required="required",maxlength="255",class="textfield",size="100",title="The list of regular expressions that if matched it will trigger security for this rule.")#
				#html.textField(name="whiteList",label="White List:",bind=prc.rule,maxlength="255",class="textfield",size="100",title="The list of regular expressions that if matched it will allow them through for this rule.")#
			
				#html.textField(name="order",label="Firing Order Index:",bind=prc.rule,size="5")#
			
			#html.endFieldset()#
			
			#html.startFieldset(legend="Security Roles & Permissions")#
				#html.textField(name="permissions",label="Permissions:",bind=prc.rule,maxlength="500",class="textfield",size="100",title="The list of security permissions needed to access the secured content of this rule.")#
				#html.textField(name="roles",label="Roles:",bind=prc.rule,maxlength="500",class="textfield",size="100",title="The list of security roles needed to access the secured content of this rule.")#
			#html.endFieldset()#
			
			#html.startFieldset(legend="Relocation Data")#
				#html.label(field="useSSL",content="Redirect using SSL:")#
				#html.radioButton(name="useSSL",value=true,bind=prc.rule)# Yes 	
				#html.radioButton(name="useSSL",value=false,bind=prc.rule)# No 	
				#html.textField(name="redirect",label="*Redirect Pattern:",required="required",bind=prc.rule,maxlength="255",class="textfield",size="100",title="The URL pattern to redirect to if user does not have access to this rule.")#
			#html.endFieldset()#
			
		</div>	
	</div>
</div>	

#html.endForm()#
</cfoutput>