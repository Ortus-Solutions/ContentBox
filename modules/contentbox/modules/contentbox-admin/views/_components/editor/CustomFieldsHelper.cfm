<cfoutput>
<script type="application/javascript">
'use strict';
function customFieldsModel(){
	return {
		init(){
			window.addCustomField = this.addCustomField;
		},
		customFields : #toJSON( prc.oContent.getCustomFields().map( ( field ) => arguments.field.getMemento() ) )#,
		customFieldTemplate : { "key" : "", "value" : "", "relatedContent" : "#prc.oContent.getContentID()#" },
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
		cleanCustomFields(){
			this.customFields.forEach( ( item, index ) => {
				if( !item.key.trim() ){
					this.customFields.splice( index, 1 );
				}
			} );
		},
		removeCustomField( field ){
			let fieldIndex = this.customFields.findIndex( item => item.key.trim() == field.key.trim() );
			if( fieldIndex > -1 ){
				this.customFields.splice( fieldIndex, 1 );
			}
		},
		isTemplatedField : field => window.assignedTemplate
									&& window.assignedTemplate.definition.customFields
									&& window.assignedTemplate.definition.customFields.value.some( item => item.name == field.key.trim() )
	}
}
</script>
</cfoutput>