<cfoutput>
<script>
"use strict";
document.addEventListener( "DOMContentLoaded", () => {
	let $siteForm = $( "##siteForm" );
	// form validators
	$siteForm.validate();
} );

function domainAliases() {
	return {
		fields: #prc.site.getDomainAliasesAsJSON()#,

		get domainAliases() {
			return JSON.stringify( this.fields );
		},

		addDomainAlias() {
			this.fields.push( {
				domain: 'mydomain.com',
				domainRegex: 'mydomain\\.com'
			} );
		},

		removeDomainAlias( index ) {
			this.fields.splice( index, 1 );
		},

		moveUp( index ) {
			if( index <= this.fields.length - 1 && index > 0 ){
				this.arrayMove( this.fields, index, index-1 );
			}
		},

		moveDown( index ) {
			if( index < this.fields.length - 1 && index >= 0 ){
				this.arrayMove( this.fields, index, index+1 );
			}
		},

		arrayMove( target, fromIndex, toIndex ) {
			target.splice( toIndex, 0, ...target.splice( fromIndex, 1 ) );
		}
	}
}
</script>
</cfoutput>
