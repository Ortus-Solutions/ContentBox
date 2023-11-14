# Development Notes

## Setup Environment

To setup your development environment, install [NodeJS](https://nodejs.org/en/) and run in the root of the project: `box recipe workbench/setup.boxr` to install all Coldbox, CommandBox and NPM dependencies.  If not you will have to run these manually to install and compile assets:

## Asset Compilation

All assets for this project are compiled using [Coldbox Elixir](https://www.npmjs.com/package/coldbox-elixir) ( NPM/Webpack ).  Developers modifying Javascript or SCSS/CSS assets should use the files located in `modules/contentbox/modules/contentbox-admin/resources`.

Files in `modules/contentbox-admin/includes/` will be overwritten on compilation.  Please use the `elixir-module.js` files in the ContentBox Modules to configure additional asset compilation.  To compile the initial development JS and CSS assets, once you have run the setup task, simply run `npm run build-dev` - which will compile the ContentBox and Theme assets for the first time.


There are three NPM scripts you may use:

`npm run install` - Installs all dependencies on the root and default theme
`npm run dev`  - a one-time compilation of development assets ( source maps and not minified )
`npm run watch`  - compiles the development assets and then watches for changes to any of the files.  Automatically recompiles when changes are made
`npm run prod` - compiles the production ( packed, minified ) assets for release.
`npm run build-dev` - compiles the development assets for both the ContentBox modules and the default theme.
`npm run build-prod` - compiles the production assets for both the ContentBox modules and the default theme.

# Default Theme Compilation

If you are conducting work on the default theme, located in `modules/contentbox/themes/default`, that has it's own, separate, `webpack-config.js`.  to run in watch mode during theme development, you will need to change  your working directory to the theme root and run `npm run watch` from there.

## CSS/SCSS

The directory `modules/contentbox/modules/contentbox-admin/resources/scss` contains all of the SCSS theme files.  Global variables used may be set in `_globals.scss`.

- `theme` - The ContentBox admin theme sass includes directory
- `_globals.scss` - Used for global variables
- `contentbox.scss` - ContentBox Admin additions ontop of the contributed theme
- `theme.scsss` - The root theme css

### Vendor CSS

Vendor CSS files are added into `modules/contentbox/modules/contentbox-admin/resources/vendor/css`. These are css files not included in npm files.

### Output

Once build a `rev-manifest.json` file will be placed in the `modules/contentbox/modules/contentbox-admin/includes` directory which includes the compiled assets and paths.  These are brought in to the layout via the `HTMLHelper` `elixirPath` method like so:

`#html.elixirPath( fileName='modules/contentbox/modules/contentbox-admin/includes/css/my-compiled-file.css', manifestRoot="#prc.cbroot#/includes" )#`

Note the use of `manifestRoot` - which tells Elixir to look in the contentbox admin includes directory, rather than the root of the site.

## Javascript Assets

Webpack compiles the following files directly in to their equivalents in the `modules/contentbox/modules/contentbox-admin/includes/js` directory

- `admin.js`
- `app.js`

In addition vendor libraries are compiled in to a separate `bootstrap.js` file which is loaded before the custom JS.  A list of these dependencies may be found in `modules/contentbox/modules/contentbox-admin/elixir-module.js`

## Vendor Libaries

JavaScript libraries not managed by NPM will be placed under the `modules/contentbox/modules/contentbox-admin/resources/vendor/js` folder and optimized by our build process into their appropriate global libraries.  These should be added to the `elixir-module.js` bootstrap mix of javascript resources, if added.  Ideally all libraries should be sourced from NPM


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

## Cleanup and Re-compilation

> **Warning:** The following module directories are cleared on npm compilation and should not be used for development:

- `modules/contentbox-admin/includes/css`
- `modules/contentbox-admin/includes/js`
- `modules/contentbox-admin/includes/plugins`
- `modules/contentbox-admin/includes/fonts`
- `modules/contentbox-admin/modules/contentbox-ckeditor/includes`
- `modules/contentbox-admin/modules/contentbox-markdowneditor/includes`
- `modules/contentbox/themes/default/includes/js`
- `modules/contentbox/themes/default/includes/css`
- `modules/contentbox/themes/default/includes/bootswatch`
