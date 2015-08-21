<cfoutput>
<style>
.checkbox-spacer {margin-top:5px;}
.btn-toggle.radio {padding-left:30px;}
</style>
<script>
$(document).ready(function() {
    // toggle all a-la-carte options based on parent selection
    $( 'input[data-togglegroup]' ).change(function(){
        var checked = this.checked;
        var selector = 'input[name=' + $( this ).data( 'togglegroup' ) + ']';
        $( selector ).prop( 'checked', checked );
    } );
    // check if parent needs to be toggled based on full selection/deselection of children
    $( 'input[data-alacarte' ).change(function() {
        var me = $( this );
        var checked = this.checked;
        var checkedCount = 0;
        var selector = 'input[name=' + me.prop( 'name' ) + ']';
        var parentSelector = 'input[data-togglegroup=' + me.prop( 'name' ) + ']';
        // first check if siblings are all the same
        var siblings = $( selector );
        var total = siblings.length;
        siblings.each(function(){
            // if checked status of the sibling matches the current action, increment count
            if( this.checked==checked ) {
                checkedCount++
            }
        } );
        // if sibling match count equals total number of togglegroup items, change parent to reflect state
        if( checkedCount==total ) {
            $( parentSelector ).prop( 'checked', checked );
        }
    } );
    // handle export type selection
    $( 'input[name=export_type]' ).change(function() {
        $( 'input[name=export_type]' ).each(function(){
            var parent = $( this ).parent();
            if( this.checked ) {
                parent.addClass( 'btn-success' );
                parent.parent().addClass( 'alert-success' );
            }
            else {
                parent.removeClass( 'btn-success' );
                parent.parent().removeClass( 'alert-success' );
            }
        } );
        var fieldset = $( '##selective_controls' );
        if( this.id == 'export_selective' ) {
            fieldset.show( 'fast' );
        }        
        else {
            fieldset.hide( 'fast' );
            fieldset.find( 'input[type=checkbox]' ).each(function(){
                $( this ).prop( 'checked', true );
            } )
        }
    } );
} );
function doExport(){
    if( confirm( 'Are you sure you want to begin the export?' ) ){
        activateLoaders();
        $( "##exporterForm" ).submit();
    }
}
function previewExport() {
    $.post( '#event.buildLink( prc.xehPreviewExport )#', $( "##exporterForm" ).serialize(), function( data, textStatus, jqXHR ){
        var target = $( '##exportPreviewDialog' );
        $( '##previewBody' ).html( data );
        openModal( target );
    } );
}
function activateLoaders(){
    $( "##uploadBar" ).slideToggle();
    $( "##uploadBarLoader" ).slideToggle();
}
</script>
</cfoutput>