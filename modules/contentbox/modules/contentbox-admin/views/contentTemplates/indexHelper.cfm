<cfoutput>
	<script>
	"use strict";
	function templatesCrud(){
		return {
			// Properties
			templates 		: null,
			pagination  	: { maxRows : 0, offset : 0, page : 1, totalPages : 1, totalRecords : 0 },
			baseUrl 		: "#encodeForJavaScript( event.buildLink( prc.xehTemplates ) )#",
			searchQuery 	: "",
			isPublicFilter 	: "",
			isLoading 		: false,
			isEditorOpen 	: false,
			isSubmitting 	: false,
			globalAlert 	: {
				type : "info",
				message : ""
			},
			errorMessages 	: "",
			templateForm 		: {
				templateID 	: "",
				template 	: "",
				slug 		: "",
				isPublic 	: true
			},
			selectedTemplates : [],

			init(){
				this.searchTemplates();
			},

			closeEditor(){
				this.isEditorOpen = false;
				this.resetTemplateForm();
			},

			editTemplate( cat ){
				this.templateForm = cat || this.resetTemplateForm();
				this.isEditorOpen = true;
			},

			saveTemplate() {
				this.errorMessages = "";
				this.isSubmitting = true;
				fetch( `${this.baseUrl}/save`, {
					method 	: 'POST',
					body 	: JSON.stringify( this.templateForm )
				})
				.then( r => r.json() )
				.then( ( response ) => {
					this.isSubmitting = false;
					if( response.error ){
						this.errorMessages = response.messages.join( "<br>" )
					} else {
						this.searchTemplates();
						this.closeEditor();
					}
				})
				.catch( error => {
					this.globalAlert.type = "danger";
					this.globalAlert.message = error.toString();
					console.log( error );
				} );
			},

			resetTemplateForm(){
				return this.templateForm = {
					templateID 	: "",
					template 	: "",
					slug 		: "",
					isPublic 	: true
				};
			},

			searchTemplates(){
				this.isLoading = true;
				fetch( `${this.baseUrl}/search?search=${this.searchQuery}&isPublic=${this.isPublicFilter}` )
					.then( r => r.json() )
					.then( ( response ) => {
						this.templates = response.data;
						this.pagination = response.pagination;
						this.isLoading = false;
					})
					.catch( error => {
						this.globalAlert.type = "danger";
						this.globalAlert.message = error.toString();
						console.log( error );
					} );
			},

			deleteTemplate( templateID, index ){
				this.globalAlert.message = "";
				if( confirm( "Are you sure?" ) ){
					fetch( `${this.baseUrl}/remove`, {
						method : "post",
						body : JSON.stringify( { templateID : templateID } )
					})
						.then( r => r.json() )
						.then( ( response ) => {
							if( !response.error ){
								this.templates.splice( index, 1 );
								this.globalAlert.type = "info";
								this.globalAlert.message = response.messages.join( "<br>" );
								this.searchTemplates();
							} else {
								this.globalAlert.type = "danger";
								this.globalAlert.message = response.messages.join( "<br>" );
							}
						})
						.catch( error => {
							this.globalAlert.type = "danger";
							this.globalAlert.message = error.toString();
							console.log( error );
						} );
				}
			},

			deleteSelected(){
				if( this.selectedTemplates.length ){
					this.deleteTemplate( this.selectedTemplates );
				} else {
					alert( "Please select something to delete!" );
				}
			},

			exportSelected(){
				if( this.selectedTemplates.length ){
					window.open( `${this.baseUrl}/exportAll/templateID/${this.selectedTemplates}`);
				} else {
					alert( "Please select something to export!" );
				}
			},

			selectAll( toggle ){
				if( toggle ){
					this.templates.forEach( ( cat ) => this.selectedTemplates.push( cat.templateID ) );
				} else {
					this.selectedTemplates = [];
				}
			}

		};
	}
	</script>
	</cfoutput>