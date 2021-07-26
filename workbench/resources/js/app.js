var app = function() {

	var init = function() {
		tooltips();
		toggleMenuLeft();
		toggleMenuRight();
		switcheryToggle();
		menu();
		togglePanel();
		closePanel();
	};

	var tooltips = function() {
		$( "#toggle-left" ).tooltip( { delay: 100 } );
	};

	var togglePanel = function() {
		$( ".actions > .fa-chevron-down" ).click( function() {
			$( this ).parent().parent().next().slideToggle( "fast" );
			$( this ).toggleClass( "fa-chevron-down fa-chevron-up" );
		} );
	};

	var toggleMenuLeft = function() {
		$( "#toggle-left" ).bind( "click", function( e ) {
			$( "body" ).removeClass( "off-canvas-open" );
			var bodyEl = $( "#container" );
			( $( window ).width() > 767 ) ? $( bodyEl ).toggleClass( "sidebar-mini" ): $( bodyEl ).toggleClass( "sidebar-opened" );
		} );
	};

	var toggleMenuRight = function() {
		$( "#toggle-right" ).click( function(){
			$( ".off-canvas" ).toggleClass( "off-canvas-open" );
		} );
	};

	var switcheryToggle = function() {
		var elems = Array.prototype.slice.call( document.querySelectorAll( ".js-switch" ) );
		elems.forEach( function( html ) {
			var switchery = new Switchery( html, { size: "small" } );
		} );
	};

	var closePanel = function() {
		$( ".actions > .fa-times" ).click( function() {
			$( this ).parent().parent().parent().fadeOut();
		} );

	};

	var menu = function() {
		var subMenu = $( ".sidebar .nav" );
		$( subMenu ).navgoco( {
			caretHtml : false,
			accordion : true,
			slide     : {
				duration : 400,
				easing   : "swing"
			}
		} );

	};
	//End functions

	//morris pie chart
	var morrisPie = function() {

		Morris.Donut( {
			element : "donut-example",
			data    : [
				{
					label : "Chrome",
					value : 73
				},
				{
					label : "Firefox",
					value : 71
				},
				{
					label : "Safari",
					value : 69
				},
				{
					label : "Internet Explorer",
					value : 40
				},
				{
					label : "Opera",
					value : 20
				},
				{
					label : "Android Browser",
					value : 10
				}

			],
			colors : [
				"#1abc9c",
				"#293949",
				"#e84c3d",
				"#3598db",
				"#2dcc70",
				"#f1c40f"
			]
		} );
	};

	// Sliders
	var sliders = function() {
		$( ".slider-span" ).slider();
	};

	// return functions
	return {
		init      : init,
		sliders   : sliders,
		morrisPie : morrisPie
	};
}();

$( () => {
	app.init();
	// Collapsed nav if <=768 by default
	var bodyEl = $( "#container" );
	if ( $( window ).width() <= 768 && !$( bodyEl ).hasClass( "sidebar-mini" ) ){
		$( "body" ).removeClass( "off-canvas-open" );
		$( bodyEl ).toggleClass( "sidebar-mini" );
	}
} );