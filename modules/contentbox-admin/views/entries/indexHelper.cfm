<cfoutput>
<script type="text/javascript">
$(document).ready(function() {
	// global ids
	$entryForm = $("##entryForm");
	$entries	  = $("##entries");
	// filters and sorters
	$entries.tablesorter();
	$("##entryFilter").keyup(function(){
		$.uiTableFilter( $("##entries"), this.value );
	});
	// quick look
	$entries.find("tr").bind("contextmenu",function(e) {
	    if (e.which === 3) {
	    	if($(this).attr('data-contentID') != null) {
				openRemoteModal('#event.buildLink(prc.xehEntryQuickLook)#/contentID/' + $(this).attr('data-contentID'));
				e.preventDefault();
			}
	    }
	});
    // add click listener to info panel buttons
    $( '.infoPanelButton' ).click( function( e ){
        handlePanelClick( e, this, '.contentInfoPanel', '.actionsPanel', toggleInfoPanel );
    });
    // add click listener to actions panel buttons
    $( '.actionsPanelButton' ).click( function( e ){
        handlePanelClick( e, this, '.actionsPanel', '.contentInfoPanel', toggleActionsPanel );
    });
    // add click listener to body to hide info and action panels
    $( 'body' ).click( function( e ){
       var target = $( e.target ),
           ipIgnore = [],
           apIgnore = [],
           ipTarget = target.closest( '.contentInfoPanel' ),
           apTarget = target.closest( '.actionsPanel' )
       // if click occurs within visible element, add to ignore list
       if( ipTarget.length ) {
           ipIgnore.push( ipTarget[ 0 ].id );
       }
       // hideInfoPanels( ipIgnore );
       if( apTarget.length ) {
           apIgnore.push( apTarget[ 0 ].id );
       }
       // run global hide methods
       hidePanels( '.contentInfoPanel', ipIgnore );
       hidePanels( '.actionsPanel', apIgnore );
    });
});
/*
 * Consolidated way to show selected panel and hide others
 * @e {Event} the click event
 * @el {HTMLElement} the button which was clicked
 * @selector {String} the selector class of the target element
 * @antiselector {String} the selector class of hideable elements
 * @handler {Function} the function to execute
 */
function handlePanelClick( e, el, selector, antiselector, handler ) {
    // prevent default event
    e.preventDefault();
    // stop propagation so click doesn't bubble to body
    e.stopPropagation();
    var button = $( el ),
        row = button.closest( 'tr' ),
        childPanel = row.find( selector ),
        contentID = row.attr( 'data-contentID' );
    // if we find a contentID, toggle that panel
    if( contentID != null ) {
        handler.call( this, contentID );
        //toggleActionsPanel( contentID );
        // hide other panels
        hidePanels( selector, [ childPanel[ 0 ].id ] );
        hidePanels( antiselector );
    }
}
/*
 * Hides panels which match the passed selector
 * @selector {String} the selector class of panels to hide
 * @ignore {Array} array of ids of elements to ignore when hiding elements
 */
function hidePanels( selector, ignore ) {
    var ignore = !ignore ? [] : ignore;
    $( selector ).each(function() {
        var me = this;
        if( $.inArray( me.id, ignore )==-1 ) {
            $( this ).slideUp({
                duration: 200
            })
        }
    });
}
function toggleActionsPanel(contentID){
	$("##entryActions_" + contentID).slideToggle({
        duration:200
    });
	return false;
}
function toggleInfoPanel(contentID){
	$("##infoPanel_" + contentID).slideToggle({
        duration:200
    });
	return false;
}
function remove(contentID){
	if( contentID != null ){
		$('##delete_'+contentID).attr('src','#prc.cbRoot#/includes/images/ajax-spinner.gif');
		checkByValue('contentID',contentID);		
	}
	$entryForm.submit();
}
function bulkChangeStatus(status, contentID){
	$entryForm.attr("action","#event.buildlink(linkTo=prc.xehEntryBulkStatus)#");
	$entryForm.find("##contentStatus").val( status );
	if( contentID != null ){
		$('##status_'+recordID).attr('src','#prc.cbRoot#/includes/images/ajax-spinner.gif');
		checkByValue('contentID',contentID);	
	}
	$entryForm.submit();
}
</script>
</cfoutput>