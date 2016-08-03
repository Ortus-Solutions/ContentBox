<script>
function onSubmitHandler() {
    var checkboxes = document.getElementsByName( 'keysToRemove' );
    var checked = [];
    for( var i=0; i < checkboxes.length; i++ ) {
        if( checkboxes[ i ].checked ) {
            checked.push( checkboxes[ i ] );
        }
    }
    if( !checked.length ) {
        alert( 'Please select at least one subscription to remove before submitting' );
        return false;
    }
    var confirmation = confirm( 'Are you sure you want to remove these subscriptions?' );
    if( confirmation ) {
        return true;
    }
    return false;
}
</script>