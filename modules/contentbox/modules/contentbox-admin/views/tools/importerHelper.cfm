<cfoutput>
<script>
document.addEventListener( "DOMContentLoaded", () => {
	$importForm	 	= $( "##importerForm" );
	$importDialog 	= $( "##importDialog" );
	$tabs 			= $( "##import_tabs" );
	$button 		= $( "##import_button" );
	$validator 		= $importForm.validate();

	// form validation handler
	$importForm.submit( function( e ){
		var formvals 	= $importForm.collect();
		var active 		= formvals.importtype;
		$importForm.resetValidations();
		// add validations as needed based on active tab
		switch( active ) {
			case 'contentbox':
				addUploadValidations();
				// if overrideContent is visible, we are previewing; otherwise, regular upload
				$overrideContent = $( '##overrideContent' );
				if( !$overrideContent.is(':visible') ) {
					// if not already prepared, do some iframe tricker to upload the file in the background and process the results
					$( '##uploadIframe' ).remove();
					$( '<iframe name="uploadIframe" />' ).appendTo( 'body' ).attr( {
						id: 'uploadIframe'
					} );
					// get reference to newly created frame
					var hiddenUpload = $( '##uploadIframe' );
					$importForm.attr( 'action', "#event.buildLink( rc.xehCBPreImport )#" );
					$importForm.attr( 'target', 'uploadIframe' );
					// now handle the action and response with a load listener
					hiddenUpload.load(function() {
						var response = hiddenUpload.contents().find( 'body' ).html();
						openModal( $importDialog, 900 );
						$importDialog.find( '##modalContent' ).html( response );
					} );
					if ( $importForm.valid() ) {
						activateLoaders();
					}
				}
				else {
					$( '##overwrite' ).val( $overrideContent.val() );
					$importForm.attr( 'action', '#event.buildLink( rc.xehCBImport )#' );
					$importForm.attr( 'target', '' );
					$importDialog.find( "##importButtonBar" ).slideUp();
					$importDialog.find( "##importBarLoader" ).slideDown();
				}
				break;
			case 'database':
				addDatabaseValidations();
				$importForm.attr( 'action', '#event.buildLink( rc.xehDataImport )#' );
				break;
		}
		// check valid state
		if ( $importForm.valid() ) {
			activateLoaders();
		} else {
			e.preventDefault();
			removeValidations();
		}
	} );

	// handle export type selection
    $( 'input[name=importtype]' ).change( function(){
        $( 'input[name=importtype]' ).each( function(){
        	var parent = $( this ).parent();
            if( this.checked ) {
                parent.addClass( 'btn-success' );
                parent.parent().addClass( 'alert-success' );
            } else {
                parent.removeClass( 'btn-success' );
                parent.parent().removeClass( 'alert-success' );
            }
        } );
        var cbContent = $( '##contentbox-import' );
        var dbContent = $( '##database-import' );
        if( this.id == 'import-contentbox' ) {
        	dbContent.hide( 'fast' );
            cbContent.show( 'fast' );
        } else {
            cbContent.hide( 'fast' );
            dbContent.show( 'fast' );
        }
    } );

	// close button
	$importDialog.delegate( '##closeButton', 'click', function( e ){
		closeModal( $importDialog ); return false;
	} );
	// clone button
	$importDialog.delegate( '##importButton', 'click', function( e ){
		$importForm.submit();
	} );
} );
/**
 * Handy method to remove all validaitons from the form so that we can add them conditionally when switching tabs
 */
function removeValidations() {
	$importForm.find( '[name=dsn]' ).removeAttr( 'required' );
	$importForm.find( '[name=defaultPassword]' ).removeAttr( 'required' );
	$importForm.find( '[name=CBUpload]' ).removeAttr( 'required' );
}
/**
 * Adds validations for "upload" tab
 */
function addUploadValidations() {
	$importForm.find( '[name=CBUpload]' ).attr( 'required', 'required' );
}
/**
 * Add validations for "data" import tab
 */
function addDatabaseValidations() {
	$importForm.find( '[name=dsn]' ).attr( 'required', 'required' );
	$importForm.find( '[name=defaultPassword]' ).attr( 'required', 'required' );
}
/**
 * Little utility for showing progress bars
 */
function activateLoaders(){
	$( "##uploadBar" ).slideToggle();
	$( "##uploadBarLoader" ).slideToggle();
}
</script>
</cfoutput>