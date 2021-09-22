<cfoutput>
<cfif prc.oCurrentAuthor.checkPermission( "EDITORS_CUSTOM_FIELDS" )>
<p>
	You can add as many name-value pairs of custom fields (metadata) to this #args.fieldType# that can later be used by your layout themes, widgets, events, etc via
	the CB Helper:
	<code>cb.quickCustomFields() or cb.getCustomField( key, [defaultValue] )</code>
</p>
<!--- CustomFields Holder --->
<div id="customFields">
	<!--- Counter Of How Many Custom Fields --->
	#html.hiddenField( name="customFieldsCount", value=arrayLen( args.customFields ))#

	<div>
		<!--- Add CustomField --->
		<button class="btn btn-sm btn-primary dynamicAdd" title="Add Custom Field" id="addCustomFieldButton" onclick="return false;">
			<i class="fa fa-plus fa-lg"></i> Add
		</button>
		<!--- Remove All Custom Fields --->
		<button id="removeCustomFieldsButton" class="btn btn-sm btn-danger" onclick="return cleanCustomFields()">
			<i class="far fa-trash-alt fa-lg"></i> Remove All
		</button>
	</div>

	<p>&nbsp;</p>

	<!--- Render out Fields --->
	<cfloop array="#args.customFields#" index="cField" >
		<div class="m0 template">
			<div class="form-group form-inline">
				<label class="inline control-label">Key: </label>
				#html.textField(
					name="CustomFieldKeys",
					class="form-control customFieldKey",
					maxsize="255",
					size="30",
					value=cField.getKey()
				)#

				<label class="inline control-label">Value: </label>
				#html.textField(
					name="CustomFieldValues",
					class="form-control customFieldValue",
					size="30",
					value=cField.getValue()
				)#

				<button class="btn btn-danger dynamicRemove" onclick="return false;"><i class="far fa-trash-alt"></i></button>

			</div>
		</div>
	</cfloop>
	<div id="beacon"></div>
</div>
<!--- CustomFields Template --->
<div id="customFieldsTemplate" class="m0 template" style="display:none;">
	<div class="form-group form-inline">
		<label class="inline control-label">Key: </label>
		#html.textField(
			name="CustomFieldKeys",
			class="form-control customFieldKey",
			maxsize="255",
			size="30"
		)#

		<label class="inline control-label">Value: </label>
		#html.textField(
			name="CustomFieldValues",
			class="form-control customFieldValue",
			size="30"
		)#

		<button class="btn btn-danger dynamicRemove" onclick="return false;">
			<i class="far fa-trash-alt"></i>
		</button>
	</div>
</div>
<!--- Custom JS --->
<script>
document.addEventListener( "DOMContentLoaded", () => {
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