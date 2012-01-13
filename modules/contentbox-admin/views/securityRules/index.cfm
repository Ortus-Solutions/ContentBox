<cfoutput>
<!--============================Sidebar============================-->
<div class="sidebar">
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
			Please remember that the security rules are fired in the order shown. Be careful with security rules as with much power comes great responsibility!
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
<script type="text/javascript">
$(document).ready(function() {
	$ruleForm = $("##ruleForm");
	$rulesTable = $ruleForm.find("##rulesTable");
	$ruleForm.find("##rules").tablesorter();
	$ruleForm.find("##ruleFilter").keyup(function(){
		$.uiTableFilter( $("##rules"), this.value );
	});
});
function remove(recordID){
	if( recordID != null ){
		$('##delete_'+recordID).attr('src','#prc.cbRoot#/includes/images/ajax-spinner.gif');
		$("##ruleID").val( recordID );
	}
	//Submit Form
	$ruleForm.submit();
}
<cfif prc.oAuthor.checkPermission("SECURITYRULES_ADMIN")>
function changeOrder(ruleID,order,direction){
	// img change
	$('##order'+direction+'_'+ruleID).attr('src','#prc.cbRoot#/includes/images/ajax-spinner.gif');
	// change order
	$.post('#event.buildLink(prc.xehRuleOrder)#',{ruleID:ruleID,order:order},function(){
		hideAllTooltips(); 
		// reload table 
		$rulesTable.load('#event.buildLink(prc.xehSecurityRules)#',{ajax:true});
		// activate
		activateTooltips();
	});
}
</cfif>
</script>
</cfoutput>