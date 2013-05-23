<cfoutput>
	#html.startForm(name="widgetArgsForm_#prc.widget.name#", class="form-vertical")#
	#html.startFieldSet(legend="Widget Arguments")#
	<!--- instructions --->
	<cfif arrayLen( prc.md.parameters )> 
		<p>Please fill out the arguments for this widget:</p>
	<cfelse>
		<p>There are no arguments for this widget!</p>
	</cfif>
	<!--- Iterate and present arguments --->
	<cfloop from="1" to="#arrayLen( prc.md.parameters )#" index="x">
		<cfscript>
    		thisArg = prc.md.parameters[ x ];
    		requiredText = "";
    		requiredValidator = "";
    		// Verify attributes
    		if( !structKeyExists(thisArg,"required") ){ thisArg.required = false; }
    		if( !structKeyExists(thisArg,"hint") ){ thisArg.hint = ""; }
    		if( !structKeyExists(thisArg,"type") ){ thisArg.type = "any"; }
    		if( !structKeyExists(thisArg,"default") ){ thisArg.default = ""; }
    		thisArg.value = structKeyExists( prc.vals, thisArg.name ) ? prc.vals[ thisArg.name ] == "" ? thisArg.default : prc.vals[ thisArg.name ] : thisArg.default;
    		// required stuff
    		if( thisarg.required ){
    			requiredText = "<span class='textRed'>Required</span>";
    			requiredValidator = "required";
    		}
		</cfscript>
		<!--- control group --->
		<div class="control-group">
			<!--- label --->
		    #html.label( field=thisArg.name, content="#thisArg.name# (Type=#thisArg.type#) #requiredText#", class="control-label" )#
		    <div class="controls">
				<!--- argument hint --->
		        <cfif len( thisArg.hint )><small>#thisArg.hint#</small><br/></cfif>
        		<!---Boolean?--->
        		<cfif thisArg.type eq "boolean">
        			#html.select( name=thisArg.name, options="true,false", selectedValue=thisArg.value, class="input-block-level" )#
        		<!--- Default --->
        		<cfelse>
        			#html.textfield( name=thisArg.name, size="35", class="input-block-level", required=requiredValidator, title=thisArg.hint, value=thisArg.value )#
        		</cfif>
		    </div>
		</div>
	</cfloop>
	<!--- hidden usage fields --->
	#html.hiddenfield( name="widgetName", id="widgetName", value=prc.widget.name )#
	#html.hiddenfield( name="widgetDisplayName", id="widgetDisplayName", value=prc.widget.plugin.getPluginName() )#
	#html.hiddenfield( name="widgetType", value=prc.widget.widgetType )#
	#html.hiddenfield( name="widgetUDF", value=prc.widget.udf )#
	#html.endFieldSet()#
	#html.endForm()#
</cfoutput>