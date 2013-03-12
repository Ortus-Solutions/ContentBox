<cfoutput>
<h2><img width="25" src="#prc.cbroot#/includes/images/widgets/#prc.icon#" /> #prc.oWidget.getPluginName()# Widget (#prc.widgetType#)</h2>
<div class="widget-detail" id="widget-detail">
    <div class="widget-preview <cfif arrayLen( prc.metadata ) lte 1>full</cfif>">
    	<ul style="margin-top:10px;">
    		<li><strong>Version:</strong> #prc.oWidget.getpluginVersion()# </li>
    		<li><strong>ForgeBox Slug:</strong> #prc.oWidget.getForgeBoxSlug()# </li>
    		<li><strong>Description:</strong> #prc.oWidget.getPluginDescription()#</li>
    	</ul>
        <cfloop array="#prc.metadata#" index="method">
    		<div class="rendermethod" id="#method.name#" <cfif method.name neq "renderIt">style="display:none;"</cfif>>
            	<h3>#method.name#()</h3>
            	<ul>
            		<li><strong>Hint: </strong> <cfif structKeyExists( method, "hint" )>#method.hint#<cfelse>N/A</cfif></li>
            		<li><strong>Arguments: </strong>
            			<cfif ArrayLen( method.parameters )>
            				<table class="tablelisting" width="100%">
            					<tr>
            						<th>Argument</th>
            						<th>Type</th>
            						<th>Required</th>
            						<th>Default Value</th>
            						<th>Hint</th>
            					</tr>
            				<cfloop array="#method.parameters#" index="i">
            					<tr>
            						<td>#i.name#</td>
            						<td><cfif structKeyExists( i, "type" )>#i.type#<cfelse>Any</cfif></td>
            						<td><cfif structKeyExists( i, "required" )>#i.required#<cfelse>true</cfif></td>
            						<td><cfif structKeyExists( i, "default" )>#i.default#</cfif></td>
            						<td><cfif structKeyExists( i, "hint" )>#i.hint#</cfif></td>
            					</tr>
            				</cfloop>
            				</table>
            			<cfelse>
            				No arguments defined
            			</cfif>	
            		</li>
            	</ul>
        	</div>
    	</cfloop>
	</div>
    <cfif arrayLen( prc.metadata ) gt 1>
    	<div class="widget-arguments" id="widget-arguments">
    	    <p>Select from the public methods in this widget to see method hints and arguments.</p>
    	    <fieldset>
    	        <legend>Public Methods</legend>
                <label for="renderMethodSelect"><strong>Select a Method:</strong></label>
        		<select name="renderMethodSelect" id="renderMethodSelect">
        		    <cfloop array="#prc.metadata#" index="method">
    					<option value="#method.name#" <cfif method.name eq "renderIt">selected=true</cfif>>#method.name#()</option>
    				</cfloop> 
        		</select>
            </fieldset>
        </div>
    </cfif>
</div>
<div class="widget-footer">
    <div class="widget-footer-left">
        &nbsp;
    </div>
    <div class="widget-footer-right">
        <button class="buttonred" onclick="closeRemoteModal()"> Close </button>
    </div>
</div>
</cfoutput>