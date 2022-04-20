<cfoutput>
	<script>
	"use strict";
	function templatesCrud(){
		return {
			// Properties
			templates 		: null,
			pagination  	: { maxRows : 0, offset : 0, page : 1, totalPages : 1, totalRecords : 0 },
			baseAPIUrl 		: "/cbapi/v1/content-templates",
			baseURL         : window.location.pathname,
			searchQuery 	: "",
			isPublicFilter 	: "",
			isLoading 		: false,
			isEditorOpen 	: false,
			isSubmitting 	: false,
			globalAlert 	: {
				type : "info",
				message : ""
			},
			activeSite      : "#cb.site().getId()#",
			globalData      : #cb.toJSON( prc.globalData )#,
			authentication  : #cb.toJSON( prc.jwtTokens )#,
			errorMessages 	: "",
			templateForm 	: {
					site        : "#cb.site().getId()#",
					name 	    : "",
					description : "",
					contentType : "",
					definition  : {}
			},
			templateFields  : null,
			selectedTemplates : [],
			init(){
				var self = this;
				this.templateFields = Object.keys( this.globalData.templateSchema ).map( templateKey => ( { "key" : templateKey, "label" : this.globalData.templateSchema[ templateKey ].label } ) );
				Object.keys( this.globalData.templateSchema )
						.filter( key => this.globalData.templateSchema[ key ].options && !this.globalData[ this.globalData.templateSchema.options ] )
						.forEach( key => this.globalData[ this.globalData.templateSchema.options ] = [] );
				this.searchTemplates();
			},
			selectedFields(){
				return Object.keys( this.templateForm.definition ).sort( ( a, b ) => Object.keys( this.templateFields ).indexOf( a ) - Object.keys( this.templateFields ).indexOf( b ) );
			},
			isSelectedField( key ){
				return this.selectedFields().indexOf( key ) > -1;
			},
			fieldOptions( key ){
				return this.globalData[ this.globalData.templateSchema[ key ].options ].map(
					item => ( {
							id : item.id || item,
							label : item.label || item
						} )
				);
			},
			typeaheadOptionSearch( e ){
				var key = e.target.name;
				var searchTerm = e.target.value;
				var endpoint = new URL( window.location.protocol + "//" + window.location.hostname + this.globalData.templateSchema[ key ].search.replace( ':siteId', this.activeSite ) );
				endpoint.searchParams.append( "search", searchTerm );
				fetch(
					endpoint,
					{
						headers : {
							"Authorization" : `Bearer ${this.authentication.access_token}`
						}
					}
				).then( r => r.json() )
				.then( response => this.globalData[ this.globalData.templateSchema[ key ].options ] = response.data.map( item => ( { "id" : item[ this.globalData.templateSchema[ key ].optionId ], "label" : item[ this.globalData.templateSchema[ key ].optionLabel ] } )  ) )
				.catch( error => {
					this.globalAlert.type = "danger";
					this.globalAlert.message = error.toString();
					console.log( error );
				} );

			},
			selectedDefinitions(){
				var self = this;
				console.log( Object.keys( this.templateForm.definition )
								.sort( ( a, b ) => Object.keys( this.templateFields ).indexOf( a ) - Object.keys( this.templateFields ).indexOf( b ) )
								.reduce( (acc, key) => { acc[ key ] = self.globalData.templateSchema[ key ]; return acc; }, {} ) );
				return Object.keys( this.templateForm.definition )
								.sort( ( a, b ) => Object.keys( this.templateFields ).indexOf( a ) - Object.keys( this.templateFields ).indexOf( b ) )
								.reduce( (acc, key) => { acc[ key ] = self.globalData.templateSchema[ key ]; return acc; }, {} );
			},
			addFieldToTemplate( e ){
				var key = e.target.name;
				var checked = e.target.checked;
				if( checked && this.selectedFields().indexOf( key ) == -1 ){
					var fieldValue = typeof this.globalData.templateSchema[ key ].default !== 'undefined'
									? this.globalData.templateSchema[ key ].default
									: (
										this.globalData.templateSchema[ key ].type == 'array' || this.globalData.templateSchema[ key ].multiple
										? []
										: null
									);
					this.templateForm.definition[ key ] = { "value" : fieldValue };
					if( key == 'customFields' ){
						this.appendSchemaItem( key );
					}
				} else if( !checked ) {
					delete this.templateForm.definition[ key ];
				}
			},
			appendSchemaItem( key ){
				let subSchema = Object.keys( this.globalData.templateSchema[ key ].schema ).reduce( (acc, key )=>{ acc[ key ] = ""; return acc }, {} );
				this.templateForm.definition[ key ].value.push( subSchema );
			},
			removeSchemaItem( key, index ){
				this.templateForm.definition[ key ].value.splice( index, 1 );
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
				var apiUrl = this.templateForm.templateID ? `${this.baseAPIUrl}/${this.templateForm.templateID}` : this.baseAPIUrl;
				fetch( apiUrl,
				{
					method 	: this.templateForm.templateID ? 'PUT' : 'POST',
					body 	: JSON.stringify( this.templateForm ),
					headers : {
						"Authorization" : `Bearer ${this.authentication.access_token}`
					}
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
					contentType : "Page",
					name        : "",
					description : "",
					definition  : {}
				};
			},

			searchTemplates(){
				this.isLoading = true;
				fetch( `${this.baseAPIUrl}?includes=creator,creator.fullName,modifiedDate&search=${this.searchQuery}` )
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
					fetch( `${this.baseAPIUrl}/${templateID}`, {
						method : "DELETE",
						headers : {
							"Authorization" : `Bearer ${this.authentication.access_token}`
						}
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
					window.open( `#event.buildLink( prc.xehExportAll )#/templateID/${this.selectedTemplates.join(',')}.json`);
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