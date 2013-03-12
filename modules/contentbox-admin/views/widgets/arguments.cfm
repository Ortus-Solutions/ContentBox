<cfoutput>
	#html.startForm(name="widgetArgsForm_#prc.widget.name#")#
	#html.startFieldSet(legend="Widget Arguments")#
	<cfif arrayLen( prc.md.parameters )> 
		<p>Please fill out the arguments for this widget:</p>
	<cfelse>
		<p>There are no arguments for this widget!</p>
	</cfif>
	<cfloop from="1" to="#arrayLen( prc.md.parameters )#" index="x">
		<cfscript>
    		thisArg = prc.md.parameters[x];
    		requiredText = "";
    		requiredValidator = "";
    
    		if( !structKeyExists(thisArg,"required") ){ thisArg.required = false; }
    		if( !structKeyExists(thisArg,"hint") ){ thisArg.hint = ""; }
    		if( !structKeyExists(thisArg,"type") ){ thisArg.type = "any"; }
    		if( !structKeyExists(thisArg,"default") ){ thisArg.default = ""; }
    		thisArg.value = structKeyExists( prc.vals, thisArg.name ) ? prc.vals[ thisArg.name ]=="" ? thisArg.default : prc.vals[ thisArg.name ] : "";
    		// required stuff
    		if( thisarg.required ){
    			requiredText = "<span class='textRed'>Required</span>";
    			requiredValidator = "required";
    		}
		</cfscript>
		#html.label( field=thisArg.name, content="#thisArg.name# (Type=#thisArg.type#) #requiredText#" )#
		<cfif len( thisArg.hint )>
			<small>#thisArg.hint#</small><br/>
		</cfif>
		<!---Boolean?--->
		<cfif thisArg.type eq "boolean">
			#html.select( name=thisArg.name, options="true,false", selectedValue=thisArg.value )#
		<cfelse>
			#html.textfield( name=thisArg.name, size="35", class="textfield", required=requiredValidator, title=thisArg.hint, value=thisArg.value )#
		</cfif>
	</cfloop>
	#html.hiddenfield( name="widgetName", id="widgetName", value=prc.widget.name )#
	#html.hiddenfield( name="widgetDisplayName", id="widgetDisplayName", value=prc.widget.plugin.getPluginName() )#
	#html.hiddenfield( name="widgetType",value=prc.widget.widgetType )#
	#html.hiddenfield( name="widgetUDF",value=prc.widget.udf )#
	#html.endFieldSet()#
	#html.endForm()#
</cfoutput>