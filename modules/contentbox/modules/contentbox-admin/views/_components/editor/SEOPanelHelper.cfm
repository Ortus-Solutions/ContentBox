<cfoutput>
<script>
	"use strict";
	function relocationsCrud(){
		return {
			// Properties
			contentId : "#prc.oContent.getContentID()#",
			isLoading : true,
			isSaving  : false,
			baseUrl   : "/cbapi/v1/sites/#prc.oContent.getSite().getSlug()#/relocations",
			relocations : [],
			showForm : false,
			globalAlert : {},
			formData : {
				"slug" 				: "",
				"relatedContent" 	: "#prc.oContent.getContentID()#",
				"site" 				: "#prc.oContent.getSite().getSiteID()#"
			},
			authentication  : #toJson( prc.jwtTokens )#,

			init(){
				this.fetchContentRelocations();
			},

			fetchContentRelocations(){
				if( !this.contentId ) return;
				fetch(
					`${this.baseUrl}?contentID=${this.contentId}`,
					{
						headers : {
							"Authorization" : `Bearer ${this.authentication.access_token}`
						}
					}

				)
				.then( r => r.json() )
				.then( ( response ) => {
					if( !response.error ){
						this.relocations = response.data;
						this.pagination = response.pagination;
						this.isLoading = false;
					} else {
						throwAjaxResponseError( response )
					}
				})
				.catch( error => {
					this.globalAlert.type = "danger";
					this.globalAlert.message = error.toString();
					console.log( error );
				} );
			},

			createRelocation( slug ){
				this.formData.slug = "";
				this.showForm = true;
			},

			cancelRelocation( slug ){
				this.formData.slug = "";
				this.showForm = false;
			},

			saveRelocation(){
				this.isSaving = true;
				var self = this;
				fetch(
						`${this.baseUrl}`,
						{
							method : "POST",
							body : JSON.stringify( this.formData ),
							headers : {
								"Authorization" : `Bearer ${this.authentication.access_token}`
							}
						}

					)
					.then( r => r.json() )
					.then( function( response ){
						self.isSaving = false;
						if( !response.error ){
							self.showForm = false;
							self.formData.slug = "";
							self.relocations.push( response.data )
						} else {
							self.throwAjaxResponseError( response )
						}
					} )
					.catch( error => {
						self.isSaving = false;
						self.globalAlert.type = "danger";
						self.globalAlert.message = error.toString();
					} );
			},

			deleteRelocation( id ){
				var self = this;
				var index = this.relocations.findIndex( item => item.relocationID == id );
				if( confirm( "Are you sure you wish to delete this redirect?" ) ){
					this.relocations[ index ].isProcessing = true;
					fetch(
						`${this.baseUrl}/${id}`,
						{
							method : "DELETE",
							headers : {
								"Authorization" : `Bearer ${this.authentication.access_token}`
							}
						}

					)
					.then( r => r.json() )
					.then( response => {
						if( !response.error ){
							self.relocations.splice( index, 1 );
						} else {
							self.relocations[ index ].isProcessing = false;
							self.throwAjaxResponseError( response )
						}
					} )
					.catch( error => {
						self.globalAlert.type = "danger";
						self.globalAlert.message = error.toString();
					} );
				}
			},

			throwAjaxResponseError( r ){
				var errors = r.messages;
				console.log( r.messages );
				Object.keys( r.data ).forEach( key => r.data[ key ].forEach( message => errors.push( message ) ) )
				throw Error( errors.join( ',' ) );
			}
		};
	}
</script>
</cfoutput>
