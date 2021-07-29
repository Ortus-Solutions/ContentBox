<cfoutput>
<script>
document.addEventListener( "DOMContentLoaded", () => {
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
} );
</script>
</cfoutput>