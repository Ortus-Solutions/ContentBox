const elixir = require("coldbox-elixir");

module.exports = elixir(function(mix) {
	mix.module( 'modules/contentbox/modules/contentbox-admin', { folderName: '', fileName: 'elixir-module.js' } );
});