<cfoutput>
<!--============================Sidebar============================-->
<div class="sidebar">
	<!--- Tools Box --->
	<div class="small_box">
		<div class="header">
			<img src="#prc.cbroot#/includes/images/tools_icon.png" alt="info" width="24" height="24" />
			Actions
		</div>
		<div class="body">
			<p>
				If you added new rules to your system, you MUST apply them in order for them to take
				effect immediately.  If not, they will take effect on application or module restart.
			</p>
			<!--- Action Bar --->
			<div class="actionBar center">
				<a href="#event.buildLink(prc.xehResetRules)#" class="confirmIt" 
						   data-title="Really Reset All Rules?"
						   data-message="We will remove all rules and re-create them to ContentBox factory defaults.">
					<button class="buttonred" onclick="return false">Reset Rules</button>
				</a>
				<a href="#event.buildLink(prc.xehApplyRules)#" class="confirmIt" 
						   data-title="Really Apply Rules?"
						   data-message="Please be aware that you could be locked out of application if your rules are not correct.">
					<button class="buttonred" onclick="return false">Apply Rules</button>
				</a>
			</div>
			
		</div>
	</div>	
	<!--- Saerch Box --->
	<div class="small_box">
		<div class="header">
			<img src="#prc.cbroot#/includes/images/help.png" alt="info" width="24" height="24" />Help
		</div>
		<div class="body">
			<ul class="tipList">
				<li>Security rules are used to secure ContentBox according to incoming events or URLs, much like a firewall.</li>
				<li>The order of the rules is extremely important as they fire and traverse as you see them on screen.</li>
				<li>If a security rule has no permissions or roles it means that only authentication is needed.</li>
			</ul>
		</div>
	</div>	
</div>
<!--End sidebar-->	
<!--============================Main Column============================-->
<div class="main_column" id="main_column">
	<div class="box">
		<!--- Body Header --->
		<div class="header">
			<img src="#prc.cbroot#/includes/images/securityRule.png" alt="securityRules" />
			Security Rules
		</div>
		<!--- Body --->
		<div class="body">	
		
		<!--- messageBox --->
		#getPlugin("MessageBox").renderit()#
		
		<!--- Usage --->
		<div class="infoBar">
			<img src="#prc.cbRoot#/includes/images/info.png" alt="info" />
			Please remember that the security rules are fired in the order shown. You can drag and drop
			the rows to the desired order of firing. Be careful with security rules as with much power comes great responsibility!
		</div>
		
		<!--- entryForm --->
		#html.startForm(name="ruleForm",action=prc.xehRemoveRule)#
			#html.hiddenField(name="ruleID")#
		
			<!--- Content Bar --->
			<div class="contentBar" id="contentBar">
				<!--- Create Butons --->
				<cfif prc.oAuthor.checkPermission("SECURITYRULES_ADMIN")>
				<div class="buttonBar">
					<button class="button2" onclick="return to('#event.buildLink(prc.xehEditorRule)#');" title="Create new rule">Create Rule</button>
				</div>
				</cfif>
				<!--- Filter Bar --->
				<div class="filterBar">
					<div>
						#html.label(field="ruleFilter",content="Quick Filter:",class="inline")#
						#html.textField(name="ruleFilter",size="30",class="textfield")#
					</div>
				</div>
			</div>
			
			<div id="rulesTable">#renderView("securityRules/rulesTable")#</div>
			
		#html.endForm()#
		
		</div>
	</div>
</div>		
</cfoutput>