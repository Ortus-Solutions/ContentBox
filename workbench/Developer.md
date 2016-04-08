# Development Notes:

Asset Compilation
-----------------

All assets for this project are compiled using Grunt.  Developers modifying Javascript or SCSS/CSS assets should use the files located in `workbench/devincludes`.  Files in `modules/contentbox-admin/includes/` will be overwritten on compilation.  Please use Gruntfile.js to configure your asset distributions.

To setup your development environment, install NPM and then run:

```
cd workbench
npm install -g bower
npm install
bower install
```

To start Grunt compilation, run `Grunt` from the workbench directory.  Directories and relevant files, along with the `Gruntfile.js`, itself, will be watched for changes, which will recompile relevant assets.

**Todo**:
* Copy/Concat/Minify into a single css file for the assets
* Copy `fonts` from the grunt file dynamically instead of manually
* Cleanup on plugins
* Linting on the custom JS files for standards (jshint)
* Cache busting and auto injector on the CFML includes

The following conventions have been applied:

CSS/SCSS
--------

The directory `workbench/devincludes/scss` contains all of the SCSS theme files.  Only two files are compiled to the production CSS:  `theme.scss` ( The Spacelab theme and dependencies ), and `contentbox.scss` ( The application customizations ).  Global variables used may be set in `_globals.scss`


Javascript Assets
-----------------

**Global Libraries**

Two global libraries of OSS and Theme Javascript are compiled by Grunt: `preLib.js`, which is brought in to the `<head>` of the layout and `postLib.js`, which is brought in before the body end.  PreLib is intended for only files which would cause page load to throw errors.   To speed up page load times, please add any new assets to the `postLib` compilation and ensure that they are protected from errors during the page load (e.g. within a `$( document ).ready()` function.).  The long-term goal is to eliminate the use of in-view Javascript and load necessary assets at runtime.  Ideally, this would result in the elimination of the `preLib` requirement.

**Runtime Assets**

To load an asset at Runtime, please use the `prc.jsAppendList` and `prc.cssAppendList` variables in your handlers, which are relative to the module `/includes/js|css` directories, like so:

```
prc.cssAppendList = "../plugins/morris/css/morris";       
prc.jsAppendList  = "../plugins/morris/js/raphael-min,../plugins/morris/js/morris.min";  
```

**Vendor Libraries**

All the JS/CSS libraries that are not in bower and will be copied by Grunt to their appropriate destinations:
* `contentbox-admin/includes/js`
* `contentbox-admin/includes/css`

All JS files in the `workbench/devincludes/js` directory will be optimized by Grunt and deployed, recursively, to the `contentbox-admin/includes/js` directory.  For libraries, which should be compiled in to that directory for loading at runtime, please use the `workbench/devincludes/vendor` directory or add them to the `preLib` or `postLib` compilations, if used globaly.

**Plugins**

Plugins which do not have SCSS support, or which are used only for specific handler/actions, should be deployed as plugins.  See the Grunt `copy:plugins` task array for examples.


Cleanup and Re-compilation
-----------------------------

**Warning:** The following module directories are cleared on initial Grunt Startup and should not be used for development:

- `modules/contentbox-admin/includes/css`
- `modules/contentbox-admin/includes/js`
- `modules/contentbox-admin/includes/plugins`
- `modules/contentbox-admin/includes/fonts`


Old Theme Usage
---------------
These are the order and libaries used in the admin before our upgrade. Recorded here for compatibility:


```js
CSS
<!-- Bootstrap core CSS -->
"#prc.cbroot#/includes/spacelab/plugins/bootstrap/css/bootstrap.min.css"
<!-- fonts from font awesome -->
"#prc.cbroot#/includes/spacelab/css/font-awesome.min.css"
<!-- css animate -->
"#prc.cbroot#/includes/spacelab/css/animate.css"
<!-- Switchery -->
"#prc.cbroot#/includes/spacelab/plugins/switchery/switchery.min.css"
<!-- spacelab theme-->
"#prc.cbroot#/includes/spacelab/css/main.css"
<!-- datatables -->
"#prc.cbroot#/includes/spacelab/plugins/dataTables/css/dataTables.css"
<!-- morris -->
"#prc.cbroot#/includes/spacelab/plugins/morris/css/morris.css"
<!-- toastr -->
"#prc.cbroot#/includes/css/toastr.min.css"
<!-- file upload -->
"#prc.cbroot#/includes/css/bootstrap-fileupload.css"
<!-- modal -->
"#prc.cbroot#/includes/css/bootstrap-modal-bs3patch.css"
"#prc.cbroot#/includes/css/bootstrap-modal.css"
<!-- datepicker -->
"#prc.cbroot#/includes/css/bootstrap-datepicker.css"
<!-- clockpicker -->
"#prc.cbroot#/includes/spacelab/plugins/clockpicker/bootstrap-clockpicker.min.css"
<!-- custom contentbox css -->
"#prc.cbroot#/includes/css/contentbox.css"

<!--- ********************************************************************* --->
<!---                           JAVASCRIPT                                  --->
<!--- ********************************************************************* --->

<!-- jquery main -->
"#prc.cbroot#/includes/spacelab/js/jquery.min.js"
<!-- cookie helper -->
"#prc.cbroot#/includes/js/jquery.cookie.js"
<!-- validation -->
"#prc.cbroot#/includes/spacelab/plugins/validation/js/jquery.validate.min.js"
<!-- bootstrap js -->
"#prc.cbroot#/includes/spacelab/plugins/bootstrap/js/bootstrap.min.js"
<!-- modernizr for feature detection -->
"#prc.cbroot#/includes/spacelab/js/modernizr.min.js"
<!-- spacelab js -->
#prc.cbroot#/includes/spacelab/js/application.js"


<!-- modal -->
"#prc.cbroot#/includes/js/bootstrap-modalmanager.js"
"#prc.cbroot#/includes/js/bootstrap-modal.js"
<!-- datepicker -->
"#prc.cbroot#/includes/js/bootstrap-datepicker.js"
<!-- Navigation -->
#prc.cbroot#/includes/spacelab/plugins/navgoco/jquery.navgoco.min.js"
#prc.cbroot#/includes/spacelab/plugins/switchery/switchery.min.js"
<!-- morris graphs -->
#prc.cbroot#/includes/spacelab/plugins/morris/js/raphael-min.js"
#prc.cbroot#/includes/spacelab/plugins/morris/js/morris.min.js"
<!-- clock picker -->
"#prc.cbroot#/includes/spacelab/plugins/clockpicker/bootstrap-clockpicker.min.js"
<!-- file upload -->
"#prc.cbroot#/includes/js/bootstrap-fileupload.js"
<!-- jwerty -->
"#prc.cbroot#/includes/js/jwerty.js"
<!-- datatables -->
"#prc.cbroot#/includes/spacelab/plugins/dataTables/js/jquery.dataTables.js"
"#prc.cbroot#/includes/spacelab/plugins/dataTables/js/dataTables.bootstrap.js"
<!-- table filter -->
"#prc.cbroot#/includes/js/jquery.uitablefilter.js"
<!-- div filter -->
"#prc.cbroot#/includes/js/jquery.uidivfilter.js"
<!-- drag and drop -->
"#prc.cbroot#/includes/js/jquery.tablednd_0_7.js"
<!-- toastr -->
"#prc.cbroot#/includes/js/toastr.min.js"

<!-- main ContentBox scripts -->
"#prc.cbroot#/includes/js/contentbox.js"

<!--- CKEditor Separate --->
"#prc.cbroot#/includes/ckeditor/ckeditor.js"
"#prc.cbroot#/includes/ckeditor/adapters/jquery.js"

```



