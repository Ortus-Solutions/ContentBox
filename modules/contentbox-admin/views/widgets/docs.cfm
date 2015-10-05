﻿<cfoutput>
<div class="modal-header">
    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
    <h4>
        <img width="25" src="#prc.cbroot#/includes/images/widgets/#prc.icon#" /> #prc.oWidget.getName()# Widget (#prc.widgetType#)
    </h4>
</div>
<div class="modal-body">
	<div id="widget-detail">
		<div class="row">
			<div class="col-md-9">
				<ul>
            		<li><strong>Version:</strong> #prc.oWidget.getVersion()# </li>
            		<li><strong>ForgeBox Slug:</strong> #prc.oWidget.getForgeBoxSlug()# </li>
            		<li><strong>Description:</strong> #prc.oWidget.getDescription()#</li>
            	</ul>
                <cfloop array="#prc.metadata#" index="method">
            		<div class="rendermethod" id="#method.name#" <cfif method.name neq "renderIt">style="display:none;"</cfif>>
                    	<h3>#method.name#()</h3>
                    	<ul>
                    		<li><strong>Hint: </strong> <cfif structKeyExists( method, "hint" )>#method.hint#<cfelse>N/A</cfif></li>
                    		<li><strong>Arguments: </strong>
                    			<cfif ArrayLen( method.parameters )>
                                    <br /><br />
                    				<table class="table-bordered table table-hover table-condensed table-striped" width="100%">
                    					<thead>
                    						<tr class="info">
        	            						<th>Argument</th>
        	            						<th>Type</th>
        	            						<th>Required</th>
        	            						<th>Default Value</th>
        	            						<th>Hint</th>
        	            					</tr>
        								</thead>
                    				<tbody>
                    					<cfloop array="#method.parameters#" index="i">
                    					<tr>
                    						<td>#i.name#</td>
                    						<td><cfif structKeyExists( i, "type" )>#i.type#<cfelse>Any</cfif></td>
                    						<td><cfif structKeyExists( i, "required" )>#i.required#<cfelse>true</cfif></td>
                    						<td><cfif structKeyExists( i, "default" )>#i.default#</cfif></td>
                    						<td><cfif structKeyExists( i, "hint" )>#i.hint#</cfif></td>
                    					</tr>
                    					</cfloop>
                    				</tbody>
                    				</table>
                    			<cfelse>
                    				No arguments defined
                    			</cfif>
                    		</li>
                    	</ul>
                	</div>
            	</cfloop>
        	</div>
			<div class="col-md-3" id="widget-arguments">
        	    <fieldset>
        	        <legend>Public Methods</legend>
                    <p>Select from the public methods in this widget to see method hints and arguments.</p>
                    <div class="form-group">
                        <div class="controls">
                	    	<label for="renderMethodSelect" class="control-label"><strong>Select a Method:</strong></label>
                    		<select name="renderMethodSelect" id="renderMethodSelect" class="form-control input-sm">
                    		    <cfloop array="#prc.metadata#" index="method">
                					<option value="#method.name#" <cfif method.name eq "renderIt">selected=true</cfif>>#method.name#()</option>
                				</cfloop>
                    		</select>
                        </div>
                    </div>
                </fieldset>
            </div>
        </div>
    </div>
</div>
<div class="modal-footer">
    <div class="widget-footer-left">
        &nbsp;
    </div>
    <div class="widget-footer-right">
        <button class="btn" onclick="closeRemoteModal()"> Close </button>
    </div>
</div>
</cfoutput>