<cfoutput>
<script language="javascript">
$(document).ready(function() {
	// form validators
	$("##dsnForm").validator({grouped:true, position:"center right"});
});
function showDSNPanel(created){
	if( created ){
		$("##dsnPanelCreate").hide();
		$("##dsnPanelExists").fadeIn();
	}
	else{
		$("##dsnPanelExists").hide();
		$("##dsnPanelCreate").fadeIn();
	}
}
function verifyDSN(){
	$.ajax({
		url:'verify.cfm',
		data: { dsnName : $("##dsnName").val() },
		async:false,
		success: function(data){
			if( data.ERROR ){
				alert("Error verifying datasource: " + data.MESSAGES );
			}
			else{
				$("##verifyButton").fadeOut();
				$("##createButton").fadeIn();
				$("##dsnName").attr("readonly", true);
			}
		},
		dataType:"json"
	});
}
function verifyCFML(){
	$.ajax({
		url:'verifyCFML.cfm',
		data: { cfmlPassword : $("##cfpassword").val() },
		async:false,
		success: function(data){
			if( data.ERROR ){
				alert("Error verifying CFML Administrator password: " + data.MESSAGES );
			}
			else{
				$("##verifyCFMLButton").fadeOut();
				$("##createDSNButton").fadeIn();
			}
		},
		dataType:"json"
	});
}
</script>
</cfoutput>