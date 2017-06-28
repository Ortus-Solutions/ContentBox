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

    // captcha type
    $( 'input[name=cb_comments_captcha_type]' ).on( 'change', function() {
        $( '.recaptcha-settings' ).css( 'display', ( $( this ).val() == 'coldFusion' ? 'none' : '' ) );
    } );
} );
</script>
</cfoutput>