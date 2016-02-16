<cfoutput>
    <cfset udfName = "udf#args.menuItem.getMenuItemID()#_#getTickCount()#">
    <script>
        function #udfName#Callback() {
            (#args.menuItem.getJS()#).call();
        }
    </script>
    <a onclick="#udfName#Callback()" class="#args.menuItem.getURLClass()#" #args.menuItem.getAttributesAsString()#>#args.menuItem.getLabel()#</a>
</cfoutput>