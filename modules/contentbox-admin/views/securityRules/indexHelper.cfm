<cfoutput>
<script type="text/javascript">
$(document).ready(function() {
	$importDialog = $( "##importDialog" );
	$ruleForm = $( "##ruleForm" );
	$rulesTable = $ruleForm.find( "##rulesTable" );
	$ruleForm.find( "##rules" ).dataTable( {
		"paging": false,
		"info": false,
		"searching": false,
	    "columnDefs": [
	        { 
	            "orderable": false, 
	            "targets": '{sorter:false}' 
	        }
	    ],
	    "order": []
	} );
	$ruleForm.find( "##ruleFilter" ).keyup(function(){
		$.uiTableFilter( $( "##rules" ), this.value );
	} );
	<cfif prc.oAuthor.checkPermission( "SECURITYRULES_ADMIN" )>
	$ruleForm.find( "##rules" ).tableDnD( {
		onDragClass: "selected",
		onDragStart : function(table,row){
			$(row).css( "cursor","grab" );
			$(row).css( "cursor","-moz-grabbing" );
			$(row).css( "cursor","-webkit-grabbing" );
		},
		onDrop: function(table, row){
			$(row).css( "cursor","progress" );
			var newRulesOrder  =  $(table).tableDnDSerialize();
			var rows = table.tBodies[0].rows;
			$.post('#event.buildLink(prc.xehRuleOrder)#',{newRulesOrder:newRulesOrder},function(){
				for (var i = 0; i < rows.length; i++) {
					var oID = '##' + rows[i].id + '_order';
					$(oID).html(i+1);
				}
				$(row).css( "cursor","move" );
			} );
		}
	} );
	</cfif>
} );
<cfif prc.oAuthor.checkPermission( "SECURITYRULES_ADMIN,TOOLS_IMPORT" )>
function importContent(){
	// local id's
	var $importForm = $( "##importForm" );
	// open modal for cloning options
	openModal( $importDialog, 500, 350 );
	// form validator and data
	$importForm.validate( { 
		submitHandler: function(form){
           	$importForm.find( "##importButtonBar" ).slideUp();
			$importForm.find( "##importBarLoader" ).slideDown();
			form.submit();
        }
	} );
	// close button
	$importForm.find( "##closeButton" ).click(function(e){
		closeModal( $importDialog ); return false;
	} );
	// clone button
	$importForm.find( "##importButton" ).click(function(e){
		$importForm.submit();
	} );
}
function remove(recordID){
	if( recordID != null ){
		$( "##delete_"+ recordID).removeClass( "icon-remove-sign" ).addClass( "fa fa-spinner fa-spin" );
		$( "##ruleID" ).val( recordID );
	}
	//Submit Form
	$ruleForm.submit();
}
</cfif>
</script>
</cfoutput>