<cfoutput>
<script language="javascript">
$( document ).ready( function(){
	// Validate hidden tabs
	$.validator.setDefaults( {
		errorPlacement: function(error, element) {
		    error.appendTo( element.closest( "div.controls" ) );
		}
	});

	var $installerForm = $( "##installerForm" )
	// form validators
	$installerForm.validate( {
	        invalidHandler: function(e, validator){
	            if(validator.errorList.length)
	            $('##tabs a[href="##' + jQuery(validator.errorList[0].element).closest(".tab-pane").attr('id') + '"]').tab('show')
	        }
    	} );
	
	// password validator
	$.validator.addMethod( 'passwordmatch', function( value, element ){
        return ( value == $( "[name=password]" ).val() ) ? true : false;
    }, '#cb.r( "validation.passwordmatch@installer" )#' );
    
	$.validator.addMethod("pwcheck", function(value) {

		var LOWER = /[a-z]/,
		    UPPER = /[A-Z]/,
		    DIGIT = /[0-9]/,
		    DIGITS = /[0-9].*[0-9]/,
		    SPECIAL = /[^a-zA-Z0-9]/;
		
		var lower = LOWER.test(value),
		    upper = UPPER.test(value),
		    digit = DIGIT.test(value),
		    digits = DIGITS.test(value),
		    special = SPECIAL.test(value);

	return lower // has a lowercase letter
	   && upper // has an uppercase letter
	   && digit // has at least one digit
	   && special // has special chars
           && value.length > 7 // at least 8 chars
	}, 'Password should be at least 8 characters long and should contain at least 1 digit, 1 uppercase, 1 lowercase and 1 special chars' );

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
