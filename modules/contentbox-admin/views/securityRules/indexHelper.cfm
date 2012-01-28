<cfoutput>
<script type="text/javascript">
$(document).ready(function() {
	$ruleForm = $("##ruleForm");
	$rulesTable = $ruleForm.find("##rulesTable");
	$ruleForm.find("##rules").tablesorter();
	$ruleForm.find("##ruleFilter").keyup(function(){
		$.uiTableFilter( $("##rules"), this.value );
	});
	<cfif prc.oAuthor.checkPermission("SECURITYRULES_ADMIN")>
	$ruleForm.find("##rules").tableDnD({
		onDrop: function(table, row){
			var newRulesOrder  =  $(table).tableDnDSerialize();
			var rows = table.tBodies[0].rows;
			$.post('#event.buildLink(prc.xehRuleOrderAll)#',{newRulesOrder:newRulesOrder},function(){
				for (var i = 0; i < rows.length; i++) {
					var oID = '##' + rows[i].id + '_order';
					$(oID).html(i+1);
				}
			});
		}
	});
	</cfif>
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