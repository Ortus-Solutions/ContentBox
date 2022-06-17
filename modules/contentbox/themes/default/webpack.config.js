const elixir = require("coldbox-elixir");
const fs = require( "fs-extra" );
const path = require( "path" );

module.exports = elixir(function(mix) {
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