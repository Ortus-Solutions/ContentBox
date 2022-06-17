const fs = require( "fs-extra" );
const path = require( "path" );

module.exports = function(mix) {

	var moduleDeps = [
		"node_modules/ckeditor/plugins",
		"node_modules/ckeditor/adapters",
		"node_modules/ckeditor/lang",
		"node_modules/ckeditor/ckeditor.js",
		"node_modules/ckeditor/styles.js",
		"node_modules/ckeditor/contents.css"
	];

	var destination = "modules/contentbox/modules/contentbox-admin/modules/contentbox-ckeditor/includes/ckeditor";

	fs.rmdirSync( destination, { recursive :true } );

	moduleDeps.forEach( src => fs.copySync( src, `${destination}/${src.split( '/' ).pop()}`, { overwrite : true } ) );

	fs.copySync( "node_modules/ckeditor/skins/moono-lisa", `${destination}/skins/moono-lisa` );

	var localPluginsDir = "modules/contentbox/modules/contentbox-admin/resources/assets/plugins/ckeditor/plugins";

	fs.readdirSync(localPluginsDir).forEach( element => {
		fs.copySync( path.join(localPluginsDir, element ), path.join( destination + '/plugins', element ), { overwrite : true } );
    });

	fs.copySync( "modules/contentbox/modules/contentbox-admin/resources/assets/plugins/ckeditor/config.js", path.join( destination, 'config.js' ), { overwrite: true } );

};
