<cfoutput>
<script type="application/javascript">
'use strict';
function customFieldsModel(){
	return {
		customFields : #toJSON( prc.oContent.getCustomFields().map( ( field ) => arguments.field.getMemento() ) )#,
		isTemplatedField : field => window.assignedTemplate
									&& window.assignedTemplate.definition.customFields
									&& window.assignedTemplate.definition.customFields.value.some( item => item.name == field.key.trim() ),
		customFieldTemplate : { "key" : "", "value" : "", "relatedContent" : "#prc.oContent.getContentID()#" },

		init(){
			window.addCustomField = this.addCustomField;
		},

		addCustomField( key, value ){
			// Alpine events
			if( key instanceof CustomEvent ){
				value = key.detail.value;
				key = key.detail.key;
			}
			// Ignore standard click/change events
			if( key instanceof Event ) key = null;
			let newField = { ...this.customFieldTemplate };
			if( key ) newField.key = key;
			if( value ) newField.value = value;
			this.customFields.push( newField );
		},

		removeAllCustomFields(){
			if( confirm( "Really delete all custom fields?" ) ){
				this.customFields = [];
			}
		},

		removeCustomField( field ){
			let fieldIndex = this.customFields.findIndex( item => item.key.trim() == field.key.trim() );
			if( fieldIndex > -1 ){
				this.customFields.splice( fieldIndex, 1 );
			}
		}
	}
}
</script>
</cfoutput>
