$( document ).ready( function(){
    
    /**
    * Dashboard Morris Chargs
    **/
    if( typeof( aTopContent ) !== 'undefined' ){
        Morris.Donut( {
            element     : 'top-visited-chart',
            data        : aTopContent,
            colors      : [
                '#f1c40f','#2dcc70','#e84c3d','#0099FF','#993399','#FF9900'
            ]
        } );
    }

    if( typeof( aTopCommented ) !== 'undefined' ){
        Morris.Donut( {
            element     : 'top-commented-chart',
            data        : aTopCommented,
            colors      : [
                '#f1c40f','#2dcc70','#e84c3d','#0099FF','#993399','#FF9900'
            ]
        } );
    }

    if( typeof( topCommentSubscriptions ) !== 'undefined' ){
        Morris.Donut( {
            element     : 'commentchart',
            data        : topCommentSubscriptions,
            colors      : [
                '#f1c40f','#2dcc70','#e84c3d','#0099FF','#993399','#FF9900'
            ],
            formatter   : function ( x ) { 
                var pluralized = x > 1 ? 's' : '';
                return x + " Subscriber" + pluralized;
            }
        } );
    }

});	