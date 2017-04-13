<cfoutput>
<script>
$(document).ready(function() {
	// form validators
	$( "##commentSettingsForm" ).validate( {
        rules: {
            cb_comments_moderation_expiration: {
                digits: true,
                required: true,
                min: 0
            }
        },
        messages: {
            cb_comments_moderation_expiration: 'Please enter a vaild integer greater than or equal to 0'
        }
    } );
    // toggle checkboxes
	$( '.tab-content' ).find( 'input[data-toggle="toggle"]' ).change( function() {
		var inputMatch = $( this ).data( 'match' );
		$( "##" + inputMatch ).val( $( this ).prop( 'checked' ) );
	});
} );
</script>
</cfoutput>