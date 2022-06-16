const fs = require('fs-extra');
const webpack = require("webpack");

module.exports = function(mix) {

	var nodePath = "../../../../node_modules/";

	elixir.config.mergeConfig({
		module: {
			// Globally exposed variables
			rules: [
				{
					test: require.resolve("jquery"),
					loader: "expose-loader",
					options: {
					  exposes: ["$", "jQuery"],
					},
				}
			]
		},
		resolve: {
			alias: {
			  jQuery : "jquery"
			}
		},
        plugins: [
			// Variables only resolved/exposed globally within the compiled JS assets
			new webpack.ProvidePlugin( {
				$              : "jquery",
				jquery         : "jquery",
				"window.jQuery": "jquery",
				"window.$": "jquery",
				jQuery         :"jquery",
				_              : "lodash",
				Raphael        : "Raphael",
				jwerty         : "jwerty"
			} ),
            {
                apply: (compiler) => {
                  compiler.hooks.afterEmit.tap('AfterEmitPlugin', (compilation) => {
					// Copy manifests and vendor compilations over to the admin theme includes directory
                    fs.readJson( 'includes/rev-manifest.json', (err, manifest) => {
                        if( err ){
                            console.error( err );
                            return;
                        }
                        fs.copySync( manifest[ 'includes/js/vendor.js' ].substr(1), 'modules/contentbox/modules/contentbox-admin/includes/js/vendor.js' )
                        fs.copySync( manifest[ 'includes/js/runtime.js' ].substr(1), 'modules/contentbox/modules/contentbox-admin/includes/js/runtime.js' )
                    } );
					fs.copySync( 'includes/rev-manifest.json', 'modules/contentbox/modules/contentbox-admin/includes/rev-manifest.json' );
					// Clean up compiled root assets
					// fs.rmdir( 'includes/js', { recursive : true } );
					// fs.remove( 'includes/rev-manifest.json' );
                  });
                }
            }
        ]
    });

	mix.js(
		[
			// HTML5 shim detection
			"resources/assets/vendor/js/modernizr.min.js",
			// AlpineJS : Will replace majority of js files below
			nodePath + "alpinejs/dist/cdn.js",
			// Jquery
			nodePath + "jquery/dist/jquery.js",
			// Moment: Used by the Editors JS: Refactor in the future to JavaScript API
			nodePath + "moment/dist/moment.js",
			// For autosaving and js cookies on editors
			nodePath + "jquery.cookie/jquery.cookie.js",
			// Form validation
			nodePath + "jquery-validation/dist/jquery.validate.js",
			// Bootstrap js plugins
			nodePath + "bootstrap-sass/assets/javascripts/bootstrap.js",
			// String compression utility: Used by autosave features
			nodePath + "lz-string/libs/lz-string.min.js",
			// Global utility
			nodePath + "lodash/lodash.js",
			// Navigation History
			nodePath + "historyjs/scripts/bundled-uncompressed/html5/native.history.js",
			// Date picker
			nodePath + "bootstrap-datepicker/dist/js/bootstrap-datepicker.js",
			nodePath + "clockpicker/dist/bootstrap-clockpicker.js",
			// Theme navigation
			nodePath + "Navgoco/src/jquery.navgoco.js",
			// Theme navigation
			nodePath + "switchery-npm/index.js",
			// Charting Libraries
			nodePath + "raphael/raphael.js",
			nodePath + "morris.js/morris.js",
			// Data tables
			nodePath + "datatables/media/js/jquery.dataTables.js",
			nodePath + "datatables-bootstrap/js/dataTables.bootstrap.js",
			// Table drag and drop
			nodePath + "tablednd/dist/jquery.tablednd.js",
			// Toaster notifications
			nodePath + "toastr/toastr.js",
			// Drag & drop hierarchical list with mouse and touch compatibility
			nodePath + "jquery-nestable/jquery.nestable.js",
			// on/off Toggles
			nodePath + "bootstrap-toggle/js/bootstrap-toggle.js",
			// setting sliders
			nodePath + "bootstrap-slider/dist/bootstrap-slider.js",
			// MEDIAMANAGER: Context Menu used by media manager
			nodePath + "jquery-contextmenu/dist/jquery.contextMenu.js",
			// MEDIAMANAGER: Jcropping editor
			nodePath + "jcrop/dist/jcrop.js",
			// MEDIAMANAGER:  FileDrop used by media manager
			"resources/assets/vendor/js/jquery.filedrop.js",
			// Static Libraries
			"resources/assets/vendor/js/jquery.validate.bootstrap.js",
			// File Uploads components
			"resources/assets/vendor/js/bootstrap-fileupload.js",
			// Luis Majano's div and table filters
			"resources/assets/vendor/js/jquery.uidivfilter.js",
			"resources/assets/vendor/js/jquery.uitablefilter.js"
    	],
		{
			name: "bootstrap",
			entryDirectory: ""
    	}
	)
	.js( "admin.js" )
	.js( "app.js" )
    .sass( "contentbox.scss" )
    .sass( "filebrowser.scss" )
    .sass( "theme.scss" );

};
