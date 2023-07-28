const elixir = require( "coldbox-elixir" );

module.exports = elixir( function( mix ) {
	mix.module( "modules/contentbox/modules/contentbox-admin", { folderName: "", fileName: "elixir-module.js" } );
	mix.module( "modules/contentbox/modules/contentbox-admin/modules/contentbox-filebrowser", { folderName: "", fileName: "elixir-module.js" } );
	mix.module( "modules/contentbox/modules/contentbox-admin/modules/contentbox-ckeditor", { folderName: "", fileName: "elixir-module.js" } );
	mix.module( "modules/contentbox/modules/contentbox-admin/modules/contentbox-markdowneditor", { folderName: "", fileName: "elixir-module.js" } );
} );
