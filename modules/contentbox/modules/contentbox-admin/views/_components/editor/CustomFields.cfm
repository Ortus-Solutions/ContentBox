<cfoutput>
<cfif prc.oCurrentAuthor.hasPermission( "EDITORS_CUSTOM_FIELDS" )>
<p>
	You can add as many name-value pairs of custom fields (metadata) to this #args.fieldType# that can later be used by your layout themes, widgets, events, etc via
	the CB Helper:
	<code>cb.quickCustomFields() or cb.getCustomField( key, [defaultValue] )</code>
</p>
<!--- CustomFields Holder --->
<div id="customFields" x-data="customFieldsModel()">
	<input type="hidden" name="customFieldsCount" :value="customFields.length"/>
	<div @add-custom-field.window="addCustomField">
		<!--- Add CustomField --->
		<button type="button" class="btn btn-sm btn-primary" title="Add Custom Field" id="addCustomFieldButton" @click="addCustomField">
			<i class="fa fa-plus fa-lg"></i> Add
		</button>
		<!--- Remove All Custom Fields --->
		<button type="button" id="removeCustomFieldsButton" class="btn btn-sm btn-danger" @click="cleanCustomFields">
			<i class="fa fa-trash fa-lg"></i> Remove All
		</button>
	</div>

	<template x-for="( field, index ) in customFields">
		<div class="m0 template">
			<div :class="[ 'form-group form-inline', isTemplatedField( field ) ? 'template-required' : null ]">
				<label class="inline control-label">Key: </label>

				<input
					type="text"
					:name="`CustomFieldKeys_${index}`"
					class="form-control customFieldKey"
					maxsize="255"
					size="30"
					x-model="field.key"
				/>


				<label class="inline control-label">Value: </label>
				<input
					type="text"
					:name="`CustomFieldValues_${index}`"
					class="form-control customFieldValue"
					size="30"
					x-model="field.value"
				/>

				<button type="button" class="btn btn-danger dynamicRemove" onclick="removeCustomField( field )" :disabled="isTemplatedField( field ) ? true : null"><i class="fa fa-trash"></i></button>

			</div>
		</div>
	</template>
	<div id="beacon"></div>
</div>
</cfif>
</cfoutput>
