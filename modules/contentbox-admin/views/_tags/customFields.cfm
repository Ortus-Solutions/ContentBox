<cfoutput>
#html.startFieldSet(legend='<i class="icon-hdd icon-large"></i> Custom Fields:')#
	<p>
		You can add as many name-value pairs of custom fields (metadata) to this #args.fieldType# that can later be used by your layout themes, widgets, events, etc via 
		the CB Helper -> 
		<code>cb.quickCustomFields() or cb.getCustomField(key,[defaultValue])</code>
	</p>
	<!--- CustomFields Holder --->
	<div id="customFields">
		<!--- Counter Of How Many Custom Fields --->
		#html.hiddenField(name="customFieldsCount",value=arrayLen( args.customFields ))#
		<!--- Add CustomField --->
		<button class="btn  dynamicAdd" title="Add Custom Field" id="addCustomFieldButton" onclick="return false;"><i class="icon-plus-sign"></i> Add</button>
		<!--- Render out Fields --->
		<cfloop array="#args.customFields#" index="cField" >
			<p class="margin0">
				<label class="inline">Key: </label>
				#html.textField(name="CustomFieldKeys",class="textfield inline customFieldKey",size="18",maxsize="255",value=cField.getKey())#
				<label class="inline">Value: </label> 
				#html.textField(name="CustomFieldValues",class="textfield inline customFieldValue",size="60",value=cField.getValue())#
				<button class="btn  dynamicRemove" onclick="return false;"><i class="icon-remove-sign icon-large"></i></button>
			</p>
		</cfloop>
		<!--- Remove All Custom Fields --->
		<button id="removeCustomFieldsButton" class="btn" onclick="return cleanCustomFields()"><i class="icon-remove-sign"></i> Remove All</button>
	</div>
#html.endFieldset()#

<!--- CustomFields Template --->
<p id="customFieldsTemplate" class="margin0" style="display:none">
	<label class="inline">Key: </label> 
	#html.textField(name="CustomFieldKeys",class="textfield inline customFieldKey",size="18",maxsize="255")#
	<label class="inline">Value: </label> 
	#html.textField(name="CustomFieldValues",class="textfield inline customFieldValue",size="60")#
	<button class="btn  dynamicRemove" onclick="return false;"><i class="icon-remove-sign icon-large"></i></button>
</p>	

<!--- Custom JS --->
<script type="text/javascript">
$(document).ready(function() {
	// Dynamic Add
	$(".dynamicAdd").click(function() {
		addDynamicItem($(this));
		return false;
	});
	// Removal Dynamic
	$(".dynamicRemove").click(function() {
		$container = $(this).parent().parent();
		$(this).parent().remove();
		idCustomFields();
		return false;
	});
	$removeCustomFieldsButton = $("##removeCustomFieldsButton");
	$customFields = $("##customFields");
	$customFieldsCount = $("##customFieldsCount");
	<cfif arrayLen(args.customFields)>
	idCustomFields()
	</cfif>
});
function cleanCustomFields(){
	$("##customFields p").remove();
	$customFieldsCount.val(0);
	return false;
}
function addDynamicItem(_this, inData){
	var $trigger  = _this;
	// turn on the duplicate template on the requested trigger
	$("##customFieldsTemplate").clone(true).attr("id","").insertBefore( $removeCustomFieldsButton ).toggle();
	// populate inputs
	$trigger.prev().find("input").each(function(index){
		var $this = $(this);
		if (inData != null) {
			$this.val(inData[index]);
		}
		$this.tooltip(toolTipSettings);
	});
	idCustomFields();
}
function idCustomFields(){
	$customFieldsCount.val( $customFields.find("input.customFieldKey").size() );
	$customFields.find("input.customFieldKey").each(function(index){
		var $this = $(this);
		$this.attr("name","CustomFieldKeys_"+index).attr("id","CustomFieldKeys_"+index);
	});
	$customFields.find("input.customFieldValue").each(function(index){
		var $this = $(this);
		$this.attr("name","CustomFieldValues_"+index).attr("id","CustomFieldValues_"+index);
	});
}
</script>
</cfoutput>