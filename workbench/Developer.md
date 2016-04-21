# Development Notes:

## Asset Compilation

All assets for this project are compiled using Grunt and managed via Bower.  Developers modifying Javascript or SCSS/CSS assets should use the files located in `workbench/devincludes`.  Files in `modules/contentbox-admin/includes/` will be overwritten on compilation.  Please use `Gruntfile.js` to configure your asset distributions.

## Setup
To setup your development environment, install [NodeJS](https://nodejs.org/en/) and then run:

```
cd workbench
## Install Bower and Grunt-cli globally
npm install -g bower
npm install -g grunt-cli
## Install Node assets
npm install
## Install Bower assets
bower install
```

To start Grunt compilation, run `Grunt` from the workbench directory.  Directories and relevant files, along with the `Gruntfile.js`, itself, will be watched for changes, which will recompile relevant assets.

## CSS/SCSS

The directory `workbench/devincludes/scss` contains all of the SCSS theme files.  Global variables used may be set in `_globals.scss`.  

### Bower CSS
All needed CSS from bower libraries are added via the `cssmin` task.

### Vendor CSS
Vendor CSS files are added into `workbench/devincludes/vendor/css`.

### Output
The build process will produce a `modules/contentbox-admin/includes/css/contentbox.min.css` according to the theme, vendor CSS, and bower CSS.


## Javascript Assets

**ContentBox Libraries**

All JS files in the `workbench/devincludes/js` are the core ContentBox JavaScript libraries.  They will all be minified and sent to a `contentbox-pre.js` library.

**Global Libraries**

Two global libraries are created in ContentBox:

* `contentbox-pre.js` : Loaded in the `<head>` section
* `contentbox-post.js` : Loaded after the `<body>` section

> Tip: Please look in the `Gruntfile.js` for determination of the libraries loading pre and post.

## Vendor Libaries ##

JavaScript libraries not managed by Bower will be placed under the `workbench/devincludes/vendor/js` folder and optimized by our build process into their appropriate global libraries.


## Runtime Assets

To load an asset at Runtime, please use the `prc.jsAppendList, prc.jsFullAppendList` and `prc.cssAppendList, prc.cssFullAppendList` variables in your handlers.

> **Note**: No extensions are required for each list.

The `Full` lists are absolute or http locations, while the normal append lists are are relative to the module's css/js folder: `/includes/js|css`:

```
// relative
prc.cssAppendList = "../plugins/morris/css/morris";       
prc.jsAppendList  = "../plugins/morris/js/raphael-min,../plugins/morris/js/morris.min";

// full
prc.jsFullList = "https://cdnjs.cloudflare.com/ajax/libs/mocha/2.4.5/mocha.min"
prc.cssFullList = "https://cdnjs.cloudflare.com/ajax/libs/mocha/2.4.5/mocha"

```


**Plugins**

Plugins which are used only for specific handler/actions, should be deployed as plugins.  See the Grunt `copy:plugins` task array for examples.


## Cleanup and Re-compilation

> **Warning:** The following module directories are cleared on initial Grunt Startup and should not be used for development:

- `modules/contentbox-admin/includes/css`
- `modules/contentbox-admin/includes/js`
- `modules/contentbox-admin/includes/plugins`
- `modules/contentbox-admin/includes/fonts`


