<cfoutput>
<cfif prc.oAuthor.checkPermission( "EDITORS_CUSTOM_FIELDS" )>
	<div class="panel panel-primary">
	    <div class="panel-heading">
	        <h3 class="panel-title"><i class="fa fa-hdd"></i> #$r( "_tags.customFields.title@admin" )#</h3>
	    </div>
	    <div class="panel-body">
	        <p>
				#$r( "_tags.customFields.info@admin" )# -> 
				<code>cb.quickCustomFields() or cb.getCustomField(key,[defaultValue])</code>
			</p>
			<!--- CustomFields Holder --->
			<div id="customFields">
				<!--- Counter Of How Many Custom Fields --->
				#html.hiddenField(name="customFieldsCount",value=arrayLen( args.customFields ))#
				<div>
					<!--- Add CustomField --->
					<button class="btn btn-sm btn-primary dynamicAdd" title="#$r( "_tags.customFields.button.add.title@admin" )#" id="addCustomFieldButton" onclick="return false;">
						<i class="fa fa-plus"></i> #$r( "_tags.customFields.button.add.text@admin" )#
					</button>
					<!--- Remove All Custom Fields --->
					<button id="removeCustomFieldsButton" class="btn btn-sm btn-danger" onclick="return cleanCustomFields()">
						<i class="fa fa-trash-o"></i> #$r( "_tags.customFields.button.remove.text@admin" )#
					</button>
				</div>
				<!--- Render out Fields --->
				<cfloop array="#args.customFields#" index="cField" >
					<div class="margin0 template">
						<div class="form-group form-inline">
							<label class="inline control-label">Key: </label>
							#html.textField(
								name="CustomFieldKeys",
								class="form-control customFieldKey",
								maxsize="255",
								value=cField.getKey()
							)#
						
							<label class="inline control-label">Value: </label> 
							#html.textField(
								name="CustomFieldValues",
								class="form-control customFieldValue",
								value=cField.getValue()
							)#
							
							<button class="btn btn-danger dynamicRemove" onclick="return false;"><i class="fa fa-trash-o fa-lg"></i></button>
						
						</div>
					</div>
				</cfloop>
				<div id="beacon"></div>
			</div>
	    </div>
	</div>
	<!--- CustomFields Template --->
	<div id="customFieldsTemplate" class="margin0 template" style="display:none;">
		<div class="form-group form-inline">
			<label class="inline control-label">#$r( "_tags.customFields.key@admin" )#: </label>
			#html.textField(
				name="CustomFieldKeys",
				class="form-control customFieldKey",
				maxsize="255"
			)#
		
			<label class="inline control-label">Value: </label> 
			#html.textField(
				name="CustomFieldValues",
				class="form-control customFieldValue"
			)#

			<button class="btn btn-danger dynamicRemove" onclick="return false;">
				<i class="fa fa-trash-o"></i>
			</button>
		</div>
	</div>	
	<!--- Custom JS --->
	<script type="text/javascript">
		$(document).ready(function() {
			// Dynamic Add
			$( ".dynamicAdd" ).click(function() {
				addDynamicItem($(this));
				return false;
			} );
			// Removal Dynamic
			$( ".dynamicRemove" ).click(function() {
				$container = $(this).parent().parent();
				$(this).closest( '.template' ).remove();
				idCustomFields();
				return false;
			} );
			$beacon = $( "##beacon" );
			$removeCustomFieldsButton = $( "##removeCustomFieldsButton" );
			$customFields = $( "##customFields" );
			$customFieldsCount = $( "##customFieldsCount" );
			<cfif arrayLen(args.customFields)>
			idCustomFields()
			</cfif>
		} );
		function cleanCustomFields(){
			$( "##customFields div.template" ).remove();
			$customFieldsCount.val(0);
			return false;
		}
		function addDynamicItem(_this, inData){
			var $trigger  = _this;
			// turn on the duplicate template on the requested trigger
			$( "##customFieldsTemplate" ).clone(true).attr( "id","" ).insertBefore( $beacon ).show();
			// populate inputs
			$trigger.prev().find( "input" ).each(function(index){
				var $this = $(this);
				if (inData != null) {
					$this.val(inData[index]);
				}
				$this.tooltip(toolTipSettings);
			} );
			idCustomFields();
		}
		function idCustomFields(){
			$customFieldsCount.val( $customFields.find( "input.customFieldKey" ).size() );
			$customFields.find( "input.customFieldKey" ).each(function(index){
				var $this = $(this);
				$this.attr( "name","CustomFieldKeys_"+index).attr( "id","CustomFieldKeys_"+index);
			} );
			$customFields.find( "input.customFieldValue" ).each(function(index){
				var $this = $(this);
				$this.attr( "name","CustomFieldValues_"+index).attr( "id","CustomFieldValues_"+index);
			} );
		}
	</script>
</cfif>
</cfoutput>