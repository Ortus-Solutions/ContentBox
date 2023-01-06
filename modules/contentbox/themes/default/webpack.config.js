const elixir = require("coldbox-elixir");
const fs = require( "fs-extra" );
const path = require( "path" );
const webpack = require("webpack");

module.exports = elixir(function(mix) {
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
                jQuery         :"jquery"
            } )
		]
	});

	var bootswatchDir = "node_modules/bootswatch";
	var swatchesDir = "includes/bootswatch";

	mix.sass( "theme.scss" );
	mix.js( "theme.js" );

	fs.emptyDirSync( swatchesDir );
	fs.readdirSync(bootswatchDir).forEach( element => {
		if( element.indexOf( "." ) === -1 ){
			fs.copySync( path.join(bootswatchDir, element ), path.join( swatchesDir, element ), { overwrite : true } );
		}
    });
	fs.copySync( path.join( swatchesDir, 'flatly' ), path.join( swatchesDir, 'green' ) );
});