<cfoutput>
<script type="text/javascript">
$(document).ready(function() {
	// global ids
	$pageForm 		= $("##pageForm");
	$pages	  		= $("##pages");
	$cloneDialog 	= $("##cloneDialog");
	$importDialog 	= $("##importDialog");
	// sorting and filtering
	$("##pages").tablesorter();
	$("##pageFilter").keyup(function(){
		$.uiTableFilter( $pages, this.value );
	});
	// quick look
	$pages.find("tr").bind("contextmenu",function(e) {
	    if (e.which === 3) {
	    	if($(this).attr('data-contentID') != null) {
				openRemoteModal('#event.buildLink(prc.xehPageQuickLook)#/contentID/' + $(this).attr('data-contentID'));
				e.preventDefault();
			}
	    }
	});
	// Popovers
	$(".popovers").popover({
		html : true,
		content : function(){
			return getInfoPanelContent( $(this).attr( "data-contentID" ) );
		},
		trigger : 'hover',
		placement : 'left',
		title : '<i class="icon-info-sign"></i> Quick Info',
		delay : { show: 200, hide: 500 }
	});
	<cfif prc.oAuthor.checkPermission("PAGES_ADMIN")>
	$pages.tableDnD({
		onDragClass: "selected",
		onDragStart : function(table,row){
			$(row).css("cursor","grab");
			$(row).css("cursor","-moz-grabbing");
			$(row).css("cursor","-webkit-grabbing");
		},
		onDrop: function(table, row){
			$(row).css("cursor","progress");
			var newRulesOrder  =  $(table).tableDnDSerialize();
			var rows = table.tBodies[0].rows;
			$.post('#event.buildLink(prc.xehPageOrder)#',{newRulesOrder:newRulesOrder},function(){
				for (var i = 0; i < rows.length; i++) {
					var oID = '##' + rows[i].id + '_order';
					$(oID).html(i+1);
				}
				$(row).css("cursor","move");
			});
		}
	});
	</cfif>
});
function getInfoPanelContent(contentID){
	return $("##infoPanel_" + contentID).html();
}
<cfif prc.oAuthor.checkPermission("PAGES_ADMIN")>
function remove(contentID){
	if( contentID != null ){
		$("##delete_"+ contentID).removeClass( "icon-remove-sign" ).addClass( "icon-spinner icon-spin" );
		checkByValue('contentID',contentID);		
	}
	$pageForm.submit();
}
function bulkChangeStatus(status, contentID){
	$pageForm.attr("action","#event.buildlink(linkTo=prc.xehPageBulkStatus)#");
	$pageForm.find("##contentStatus").val( status );
	if( contentID != null ){
		$("##status_"+ recordID).removeClass( "icon-remove-sign" ).addClass( "icon-spinner icon-spin" );
		checkByValue('contentID',contentID);	
	}
	$pageForm.submit();
}
function importContent(){
	// local id's
	var $importForm = $("##importForm");
	// open modal for cloning options
	openModal( $importDialog, 500, 350 );
	// form validator and data
	$importForm.validate({ 
		submitHandler: function(form){
           	$importForm.find("##importButtonBar").slideUp();
			$importForm.find("##importBarLoader").slideDown();
			form.submit();
        }
	});
	// close button
	$importForm.find("##closeButton").click(function(e){
		closeModal( $importDialog ); return false;
	});
	// clone button
	$importForm.find("##importButton").click(function(e){
		$importForm.submit();
	});
}
</cfif>
<cfif prc.oAuthor.checkPermission("PAGES_EDITOR") OR prc.oAuthor.checkPermission("PAGES_ADMIN")>
function openCloneDialog(contentID, title){
	// local id's
	var $cloneForm = $("##cloneForm");
	// open modal for cloning options
	openModal( $cloneDialog, 500, 300 );
	// form validator and data
	$cloneForm.validate({ 
		submitHandler: function(form){
           	$cloneForm.find("##cloneButtonBar").slideUp();
			$cloneForm.find("##clonerBarLoader").slideDown();
			form.submit();
        }
	});
	$cloneForm.find("##contentID").val( contentID );
	$cloneForm.find("##title").val( title ).focus();
	// close button
	$cloneForm.find("##closeButton").click(function(e){
		closeModal( $cloneDialog ); return false;
	});
	// clone button
	$cloneForm.find("##cloneButton").click(function(e){
		$cloneForm.submit();
	});
}
</cfif>
</script>
</cfoutput>