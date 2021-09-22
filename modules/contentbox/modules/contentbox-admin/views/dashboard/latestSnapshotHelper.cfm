<cfoutput>
<script>
( () => {
    <cfif prc.aTopContentTotalHits gt 0>
        Morris.Donut( {
            element     : 'top-visited-chart',
            data        : #prc.aTopContent#,
            colors      : [
                '##f1c40f','##2dcc70','##e84c3d','##0099FF','##993399','##FF9900'
            ]
        } );
    </cfif>

    <cfif prc.aTopCommentedTotalHits gt 0>
        Morris.Donut( {
            element     : 'top-commented-chart',
            data        : #prc.aTopCommented#,
            colors      : [
                '##f1c40f','##2dcc70','##e84c3d','##0099FF','##993399','##FF9900'
            ]
        } );
    </cfif>
} )();
</script>
</cfoutput>