<cfoutput>
<script>

var aFields = [
	{
		"domain": "#prc.site.getDomain()#",
		"domainRegex": "#replace( prc.site.getDomainRegex(), "\", "\\", "all" )#"
	},
	... #serializeJSON( prc.site.getDomainAliasesAsArray() )#
];
console.log( aFields );
document.addEventListener( "DOMContentLoaded", () => {
	$siteForm = $( "##siteForm" );
	// form validators
	$siteForm.validate();
} );

function handler() {
	return {
		fields: aFields,
		addNewField() {
			this.fields.push({
				domain: 'mydomain.com',
				domainRegex: 'mydomain\\.com'
			});
		},
		domainAliases(){
			return JSON.stringify( this.fields.filter( ( item, index ) => { return index != 0  }) ); //`${JSON.stringify( JSON.parse( JSON.stringify( this.fields ) ).splice(0, 1) ) }`;
		},
		removeField(index) {
			this.fields.splice(index, 1);
			this.domainAliases();
		},
		moveUp( index ) {
			if( index <= this.fields.length - 1 && index > 0 ){
				this.arrayMove( this.fields, index, index-1);
			}
		},
		moveDown( index ) {
			if( index < this.fields.length - 1 && index >= 0 ){
				this.arrayMove( this.fields, index, index+1);
			}
		},
		arrayMove(arr, fromIndex, toIndex) {
			var element = arr[fromIndex];
			arr.splice(fromIndex, 1);
			arr.splice(toIndex, 0, element);
		},
		saveForm(index) {
			alert(index);
			console.log(this.fields[index]);
			//You can process your form using fetch() or axios
			let web_api = '/contact';
			let response =  fetch(web_api, {
				method: "POST",
				body: JSON.stringify(this.fields[index]),
				headers: {
					"Content-Type": "application/json",
				},
				}).then((response) => {
				if (!response.ok) {
					throw new Error("There was an error processing the request");
				}
			});
		}
	}
}
</script>
<style>.vcenter-item{
    display: flex;
    align-items: center;
}</style>
</cfoutput>