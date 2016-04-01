require.config({
    /**
    *  All of the libraries in the paths below will be packaged by RJS Optimizer
    *  in to the modules/includes/js directory 
    *  Note: paths are relative to the compiling cwd - see Gruntfile.js
    **/
    paths:{
        require: "../../node_modules/requirejs/require"
        ,underscore: "../../bower_components/underscore/underscore-min"
        ,moment: "../../bower_components/moment/min/moment-with-locales.min"
        ,jquery: "../../bower_components/jquery/dist/jquery.min"
        ,bootstrap: "../../bower_components/bootstrap-sass/assets/javascripts/bootstrap.min"
        ,html5shiv: "../../bower_components/html5shiv/dist/html5shiv.min"
        ,"es6-shim": "../../bower_components/es6-shim/es6-shim.min"
        ,modernizr: "../../bower_components/modernizr/lib/build"
        ,switchery: "../../bower_components/switchery/dist/switchery.min"
        ,scrollify: "../../bower_components/Scrollify/jquery.scrollify.min"
        ,toastr: "../../bower_components/toastr/toastr.min"
        ,navgoco: "../../bower_components/navgoco/src/jquery.navgoco.min"
        ,"bootstrap-confirmation": "../../bower_components/Bootstrap-Confirmation/bootstrap-confirmation"
        ,"bootstrap-contextmenu": "../../bower_components/bootstrap-contextmenu/bootstrap-contextmenu"
        ,"jquery-cookie": "../../bower_components/jquery.cookie/jquery.cookie"
        ,"jquery-nestable": "../../bower_components/jquery-nestable/jquery.nestable"
        ,"jquery-tablednd": "../../bower_components/TableDnD/dist/jquery.tablednd.min"
        ,"jquery-validation": "../../bower_components/jquery-validation/dist/jquery.validate.min"
        ,jwerty: "../../bower_components/jwerty/jwerty"
        ,"jquery-metadata": "../../bower_components/jquery.metadata/jquery.metadata"
        ,"lz-string": "../../bower_components/lz-string/libs/lz-string.min"
        ,respond: "../../bower_components/respond/dest/respond.min"
        ,raphael: "../../bower_components/raphael/raphael-min" 
        ,i18n: "../../bower_components/jquery-i18n-properties/jquery.i18n.properties.min"
    }
    
    /**
    * Shim config for window globals
    * Specify any upstream dependencies and the global variables exported
    **/
    ,shim:{
        underscore:{
            exports:"_"
        }
        ,moment:{
            exports:"moment"
        }
        ,jquery:{
            exports:["jQuery","$"]
        }
        ,jwerty:{
            exports:"jwerty"
        }
        ,bootstrap:{ 
            exports:"Bootstrap", 
            deps:[ "jquery" ] 
        }
        ,html5shiv:{
            exports:"html5shiv"
        }
        ,"es6-shim":{
            exports:"es6-shim"
        }
        ,navgoco:{
            exports:"navgoco",
            deps:[ "jquery" ]
        }
        ,scrollify:{
            deps: [ "jquery" ]
        }
        ,"bootstrap-confirmation":{
            deps: [ "jquery", "bootstrap" ]
        }
        ,"bootstrap-contextmenu":{
            deps: [ "jquery", "bootstrap" ]
        }
        ,"jquery-nestable":{
            deps: [ "jquery" ]
        }
        ,"jquery-tablednd":{
            deps: [ "jquery" ]
        }
        ,"jquery-metadata":{
            deps: [ "jquery" ]
        }
        ,"jquery-cookie":{
            deps: [ "jquery" ]
        }
        ,"raphael":{
            exports: "Raphael"
        }
        ,"morris":{
            deps: [ "jquery","raphael" ]
        }
    }

    /**
    * Any items in the deps array will be pre-compiled in to the Relax module includes/js/globals.js file and will be available immediately on every request
    **/
    ,deps:["bootstrap","html5shiv","underscore","moment","scrollify","switchery","navgoco","raphael","jwerty"]
});