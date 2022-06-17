const fs = require('fs-extra');

module.exports = function(mix) {
    fs.copy( "node_modules/simplemde/dist", "modules/contentbox/modules/contentbox-admin/modules/contentbox-markdowneditor/includes/simplemde", { overwrite : true } );
};
