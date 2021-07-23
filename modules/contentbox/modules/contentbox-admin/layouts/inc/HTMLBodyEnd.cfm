<!-- dynamic assets -->
<cfoutput>
    <!--- ********************************************************************* --->
    <!---                           A-LA-CARTE                                  --->
    <!--- ********************************************************************* --->
    <cfloop list="#event.getValue( "jsAppendList", "", true )#" index="js">
        <script src="#prc.cbroot#/includes/js/#js#.js"></script>
    </cfloop>
    <cfloop list="#event.getValue( "jsFullAppendList", "", true )#" index="js">
        <script src="#js#"></script>
    </cfloop>
    <!--- ********************************************************************* --->
    <!---        Fonts - Brought in last to prevent blocking issues             --->
    <!--- ********************************************************************* --->
    <link href='//fonts.googleapis.com/css?family=Source+Sans+Pro:300,400,600,700,900,300italic,400italic,600italic,700italic,900italic' rel='stylesheet' type='text/css'>
    <link href='//fonts.googleapis.com/css?family=Open+Sans:400,700' rel='stylesheet' type='text/css'>
    <!--- ********************************************************************* --->
    <!---                           EVENTS                                      --->
    <!--- ********************************************************************* --->
    <cfif event.getCurrentLayout() EQ "simple">
        #announce( "cbadmin_beforeLoginBodyEnd" )#
    <cfelse>
	    #announce( "cbadmin_beforeBodyEnd" )#
	</cfif>
</cfoutput>
