<cfoutput>
<head>
    <!--- charset --->
    <meta charset="utf-8" />
    <!--- IE Stuff --->
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <!--- Robots --->
    <meta name="robots" content="noindex,nofollow" />
    <!--- SES --->
    <base href="#cb.siteBaseURL()#" />
    <!--- Title --->
    <cfif structKeyExists( prc, 'cb_site_name' )>
        <title>#prc.cbSettings.cb_site_name# - ContentBox Administrator</title>        
    </cfif>
    <!--- Description --->
    <meta name="description" content="ContentBox Modular CMS - Admin">
    <!--- Viewport for scaling --->
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no" />
    <!--- ********************************************************************* --->
    <!---                           FAVICONS                                    --->
    <!--- ********************************************************************* --->
    <!--- Favicon --->
    <link href="#prc.cbroot#/includes/images/favicon.ico" rel="shortcut icon" type="image/x-icon" />
    <!--- For non-Retina iPhone, iPod Touch, and Android 2.2+ devices: --->
    <link href="#prc.cbroot#/includes/images/ContentBox-Circle-57.png" rel="apple-touch-icon"/>
    <!--- For first-generation iPad: --->
    <link href="#prc.cbroot#/includes/images/ContentBox-Circle-72.png" rel="apple-touch-icon" sizes="72x72"/>
    <!--- For iPhone 4 with high-resolution Retina display: --->
    <link href="#prc.cbroot#/includes/images/ContentBox-Circle-114.png" rel="apple-touch-icon" sizes="114x114"/>
    <!-- Favicon -->
    <link href="#prc.cbroot#/includes/images/favicon.ico" rel="shortcut icon" type="image/x-icon" />
    <!--- ********************************************************************* --->
    <!---                           CSS                                           --->
    <!--- ********************************************************************* --->
    <link rel="stylesheet" href="#prc.cbroot#/includes/css/contentbox.min.css">

    <!--- ********************************************************************* --->
    <!---                           A-LA-CARTE                                  --->
    <!--- ********************************************************************* --->
    <cfloop list="#event.getValue( "cssAppendList", "", true )#" index="css">
        <cfset addAsset( "#prc.cbroot#/includes/css/#css#.css" )>
    </cfloop>
    <cfloop list="#event.getValue( "cssFullAppendList", "", true )#" index="css">
        <cfset addAsset( "#css#" )>
    </cfloop>
    <!--- ********************************************************************* --->
    <!---                           IE SUPPORT                                  --->
    <!--- ********************************************************************* --->
    <!-- HTML5 shim and Respond.js IE8 support of HTML5 elements and media queries -->
    <!--[if lt IE 9]>
    <script src="#prc.cbroot#/includes/js/html5shiv.min.js"></script>
    <script src="#prc.cbroot#/includes/js/respond.min.js"></script>
    <![endif]-->
    <!--- ********************************************************************* --->
    <!---                           EVENTS                                      --->
    <!--- ********************************************************************* --->
    <!--- cbadmin Events --->
    <cfif event.getCurrentLayout() EQ 'simple'>
        #announceInterception( "cbadmin_beforeLoginHeadEnd" )#
    <cfelse>
        #announceInterception( "cbadmin_beforeHeadEnd" )#
    </cfif>
    <!--- ********************************************************************* --->
    <!---                            JS LIBRARIES FOR IN-PAGE JS                --->
    <!--- ********************************************************************* --->
    <!---  Blocking JS - Libraries required for in-page JS --->
    <cfif getSetting( "environment" ) eq "development">
        <script type="application/javascript" src="#prc.cbroot#/includes/js/contentbox-pre.js"></script>
        <script type="application/javascript" src="#prc.cbroot#/includes/js/contentbox-app.js"></script>
    <cfelse>
        <script type="application/javascript" src="#prc.cbroot#/includes/js/contentbox-pre.min.js"></script>
        <script type="application/javascript" src="#prc.cbroot#/includes/js/contentbox-app.min.js"></script>
    </cfif>
</head>
</cfoutput>