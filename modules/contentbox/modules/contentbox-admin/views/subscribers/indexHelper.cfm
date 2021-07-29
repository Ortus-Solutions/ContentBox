<cfoutput>
<script>
<cfif prc.commentSubscriptionCount>
document.addEventListener( "DOMContentLoaded", () => {
    Morris.Donut( {
        element     : 'commentchart',
        data        : #serializeJSON( prc.topCommentSubscriptions )#,
        colors      : [
            '##f1c40f','##2dcc70','##e84c3d','##0099FF','##993399','##FF9900'
        ],
        formatter   : function ( x ) {
            var pluralized = x > 1 ? 's' : '';
            return x + " Subscriber" + pluralized;
        }
    } );
} );
</cfif>
</script>
</cfoutput>