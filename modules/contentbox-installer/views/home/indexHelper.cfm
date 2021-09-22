<cfoutput>
<script language="javascript">
document.addEventListener( "DOMContentLoaded", () => {
	// Validate hidden tabs
	$.validator.setDefaults( {
		errorPlacement : function( error, element ){
		    error.appendTo( element.closest( "div.controls" ) );
		}
	});

	var $installerForm = $( "##installerForm" );
	// form validators
	$installerForm.validate( {
        invalidHandler : function( e, validator ){
        	var firstErrorTab = jQuery( validator.errorList[ 0 ].element ).closest( ".tab-pane" ).attr( 'id');
        	if( validator.errorList.length ){
            	$( '##tabs a[href="##' + firstErrorTab + '"]' ).tab( 'show' )
        	}
        }
	} );

	// password validator
	$.validator.addMethod(
		'passwordmatch',
		function( value, element ){
        	return ( value == $( "[name=password]" ).val() ) ? true : false;
    	},
    	'#cb.r( "validation.passwordmatch@installer" )#'
    );

	$.validator.addMethod(
		"pwcheck",
		passwordValidator,
		'#cb.r( "validation.passwordcheck@installer" )#'
	);

	// Password change rules
	$( "##password" ).keyup( passwordMeter );

} );

function nextStep(){
    var $tabs = $( '.tab-wrapper li' );
	$tabs.filter( '.active' ).next( 'li' ).find( 'a[data-toggle="tab"]' ).tab( 'show' );
}

function prevStep(){
    var $tabs = $('.tab-wrapper li');
	$tabs.filter( '.active' ).prev( 'li' ).find( 'a[data-toggle="tab"]' ).tab( 'show' );
}
</script>
</cfoutput>
