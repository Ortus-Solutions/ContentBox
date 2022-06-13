const elixir = require("coldbox-elixir");
const webpack = require("webpack");

module.exports = elixir(function(mix) {
	elixir.config.mergeConfig({
		resolve: {
			alias: {
			  jQuery : "jquery",
			  History : "History"
			}
		},
		plugins : [
			new webpack.ProvidePlugin( {
				$              : "jquery",
				jquery         : "jquery",
				"window.jQuery": "jquery",
				jQuery         :"jquery",
				_              : "lodash",
				History        : "history"
			} )
		]
	} );

	mix.module( 'modules/contentbox/modules/contentbox-admin', { folderName: '', fileName: 'elixir-module.js' } );
});