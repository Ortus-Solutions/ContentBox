const fs = require('fs-extra');

module.exports = function(mix) {
	elixir.config.mergeConfig(
		{
			plugins: [
				{
					apply: (compiler) => compiler.hooks.afterEmit.tap(
											'AfterEmitPlugin',
											() => fs.copySync(
													'node_modules/jquery/dist/jquery.min.js',
													'modules/contentbox/modules/contentbox-admin/modules/contentbox-filebrowser/includes/js/jquery.min.js'
												)
										)
				}
			]
    	}
	);
};
