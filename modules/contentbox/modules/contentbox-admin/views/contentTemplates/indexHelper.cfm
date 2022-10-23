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
			searchOptions   : {
				sortOrder : "contentType ASC, name ASC"
			},
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
			formTemplate 	: {
					site        : "#cb.site().getId()#",
					name 	    : "",
					description : "",
					contentType : "",
					definition  : {},
					contentType : "Page"
			},
			availableTypes  : [
				"Page",
				"Entry",
				"ContentStore"
			],
			templateForm : null,
			templateFields  : null,
			selectedTemplates : [],
			init(){
				var self = this;
				this.templateForm = this.newTemplateForm();
				this.templateFields = Object.keys( this.globalData.templateSchema )
										.map( templateKey => (
											{
												"key" : templateKey,
												"label" : this.globalData.templateSchema[ templateKey ].label,
												"excludeTypes" : this.globalData.templateSchema[ templateKey ].excludeTypes,
												"sortOrder" :  this.globalData.templateSchema[ templateKey ].sortOrder || Object.keys( this.globalData.templateSchema ).length
											}
										) );
				this.templateFields.sort( ( a, b ) => a.sortOrder - b.sortOrder );
				Object.keys( this.globalData.templateSchema )
						.filter( key => this.globalData.templateSchema[ key ].options && !this.globalData[ this.globalData.templateSchema.options ] )
						.forEach( key => this.globalData[ this.globalData.templateSchema.options ] = [] );
				this.searchTemplates();
				let hashAction = window.location.hash ? window.location.hash.substring( 1, 7 ) : "";
				if( hashAction == 'create' ){
					var hashParts = window.location.hash.split( '-' );
					var self = this;
					this.$nextTick( () => {
						self.editTemplate();
						if( hashParts.length > 1 ){
							self.$nextTick( () => self.templateForm.contentType = hashParts[ hashParts.length - 1 ] );
						}
					} );
				}
			},
			availableTemplates(){
				return this.templates.filter( item => item.contentType == this.templateForm.contentType ).map( item => ( { id : item.templateID, label : item.name } ) );
			},
			availableFields(){
				return this.templateFields ? this.templateFields.filter( field => !field.excludeTypes || field.excludeTypes.indexOf( this.templateForm.contentType ) == -1 ) : [];
			},
			selectedFields(){
				return Object.keys( this.templateForm.definition ).filter( key => this.globalData.templateSchema[ key ] ).sort( ( a, b ) =>  this.globalData.templateSchema[ a ].sortOrder - this.globalData.templateSchema[ b ].sortOrder );
			},
			isSelectedField( key ){
				return this.selectedFields().indexOf( key ) > -1;
			},
			fieldOptions( key ){
				let options = this.globalData[ this.globalData.templateSchema[ key ].options ];
				if( !options ){
					options = typeof this[ this.globalData.templateSchema[ key ].options ] === "function"
								? this[ this.globalData.templateSchema[ key ].options ]()
								: this[ this.globalData.templateSchema[ key ].options ]
				}
				return options.map(
					item => ( {
							id : item.id || item,
							label : item.label || item
						} )
				);
			},
			hasGlobalTemplateForType( type ){
				return this.templates.some( t => t.isGlobal && t.contentType == type );
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
				return Object.keys( this.templateForm.definition )
								.filter( key => self.globalData.templateSchema[ key ] )
								.sort( ( a, b ) => self.globalData.templateSchema[ a ].sortOrder - self.globalData.templateSchema[ b ].sortOrder )
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
				window.scrollTo( 0, 0 );
				this.templateForm = this.newTemplateForm();
			},
			editTemplate( cat ){
				this.templateForm = cat || this.newTemplateForm();
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
						var errors = response.messages;
						if( errors.length && errors[ 0 ].indexOf( "Validation" ) > -1 ){
							Object.entries( response.data )
										.map( validation => validation[ 1 ] )
										.reduce(
											( acc, messages ) => {
												messages.forEach( m => acc.push( m.message ) );
												return acc;
											},
										[] ).forEach( m => errors.push( m ) );

						}
						this.errorMessages = errors.join( "<br>" );
						window.scrollTo( 0, 0 );
					} else {
						this.searchTemplates();
						this.closeEditor();
					}
				})
				.catch( error => {
					this.isSubmitting = false;
					this.globalAlert.type = "danger";
					this.globalAlert.message = error.toString();
					console.log( error );
				} );
			},
			duplicateTemplate( template ){
				var self = this;
				this.$confirm( "Are you sure you wish to duplicate this template?" ).then(
					function(){
						var templateIndex = self.templates.findIndex( item => item.templateID == template.templateID );
						var clone = { ...template };
						delete clone.templateID;
						delete clone.creator;
						delete clone.modifiedDate;
						delete clone.createdDate;
						delete clone.isGlobal;
						delete clone.assignedContentItems;
						clone.name = 'Copy of ' + clone.name;
						fetch( self.baseAPIUrl + '?includes=creator,creator.fullName,modifiedDate',
						{
							method 	: 'POST',
							body 	: JSON.stringify( clone ),
							headers : {
								"Authorization" : `Bearer ${self.authentication.access_token}`
							}
						})
						.then( r => r.json() )
						.then( ( response ) => {
							self.isSubmitting = false;
							if( response.error ){
								self.errorMessages = response.messages.join( "<br>" )
							} else {
								self.templates.splice( templateIndex + 1, 0, response.data );
							}
						})
						.catch( error => {
							self.globalAlert.type = "danger";
							self.globalAlert.message = error.toString();
							console.log( error );
						} );
					}
				)
			},
			newTemplateForm(){
				return { ...this.formTemplate };
			},
			sortBy( field, direction ){
				if( !direction ) direction = 'ASC';
				this.searchOptions.sortOrder = `${field} ${direction}`;
				this.searchTemplates();
			},
			resetSearchOptions(){
				this.searchQuery = "";
				this.searchOptions = {
					sortOrder : "contentType ASC, name ASC"
				}
				this.searchTemplates();
			},
			searchTemplates(){
				this.isLoading = true;
				fetch(
					this.baseAPIUrl + '?' + new URLSearchParams({
						...this.searchOptions,
						includes : "creator,creator.fullName,modifiedDate",
						search : this.searchQuery
					})
					)
					.then( r => r.json() )
					.then( ( response ) => {
						this.templates = response.data;
						this.pagination = response.pagination;
						this.isLoading = false;
						window.scrollTo( 0, 0 );
					})
					.catch( error => {
						this.globalAlert.type = "danger";
						this.globalAlert.message = error.toString();
						console.log( error );
					} );
			},
			toggleGlobal( template ){
				if( template.isGlobal ){
					var templateIndex = self.templates.findIndex( t => t.templateID == template.templateID );
					fetch( `${self.baseAPIUrl}/${template.templateID}`, {
						method : "PATCH",
						headers : {
							"Authorization" : `Bearer ${self.authentication.access_token}`
						},
						body : JSON.stringify( { isGlobal : false } )
					}).then( r => r.json() )
					.then( ( response ) => {
						if( response.error ){
							self.displayAPIResponseErrors( response );
						} else {
							self.templates[ templateIndex ].isGlobal = false;
						}
					})
					.catch( error => {
						self.globalAlert.type = "danger";
						self.globalAlert.message = error.toString();
						console.log( error );
					} );
				} else {
					this.assignAsGlobal( template )
				}
			},
			assignAsGlobal( template ){
				var globalIndex = this.templates.findIndex( t => t.contentType == template.contentType && t.isGlobal );
				var templateIndex = this.templates.findIndex( t => t.templateID == template.templateID );
				if( globalIndex > -1 ){
					var confirmationMessage = `Template ${this.templates[ globalIndex ].name} is already assigned as the global template for content type ${template.contentType}. Are you sure you wish to change this?`;
				} else {
					var confirmationMessage = `Assigning this template as the global template will apply this template to all new content items with a type of ${template.contentType}. Are you sure you wish to do this?`;
				}

				var self = this;

				var assign = () => {
					fetch( `${self.baseAPIUrl}/${template.templateID}`, {
						method : "PATCH",
						headers : {
							"Authorization" : `Bearer ${self.authentication.access_token}`
						},
						body : JSON.stringify( { isGlobal : true } )
					}).then( r => r.json() )
					.then( ( response ) => {
						if( response.error ){
							self.displayAPIResponseErrors( response );
						} else {
							self.templates[ templateIndex ].isGlobal = true;
						}
					})
					.catch( error => {
						self.globalAlert.type = "danger";
						self.globalAlert.message = error.toString();
						console.log( error );
					} );

				};

				this.$confirm( confirmationMessage, { acceptText : 'Yes, proceed.' } )
					.then( () => {
						if( globalIndex > -1 ){
							fetch( `${self.baseAPIUrl}/${self.templates[ globalIndex ].templateID}`, {
								method : "PATCH",
								headers : {
									"Authorization" : `Bearer ${self.authentication.access_token}`
								},
								body : JSON.stringify( { isGlobal : false } )
							}).then( r => r.json() )
							  .then( response => {
								if( response.error ){
									self.displayAPIResponseErrors( response );
								} else {
									self.templates[ globalIndex ].isGlobal=false;
									assign();
								}
							  })
						} else {
							assign();
						}
					} );

			},
			deleteTemplate( templateID, index ){
				this.globalAlert.message = "";
				let template = this.templates[ index ];
				let confirmationMessage = `Are you sure you wish to delete the template "${template.name}"?`;
				if( template.assignedContentItems ){
					confirmationMessage += ' All content items assigned to this template will be detached.';
				}
				var self = this;
				this.$confirm( confirmationMessage, { acceptText : "Yes, Delete" } ).then( () => {
					fetch( `${self.baseAPIUrl}/${templateID}`, {
						method : "DELETE",
						headers : {
							"Authorization" : `Bearer ${self.authentication.access_token}`
						}
					})
						.then( r => r.json() )
						.then( ( response ) => {
							if( !response.error ){
								self.templates.splice( index, 1 );
								self.globalAlert.type = "info";
								self.globalAlert.message = response.messages.join( "<br>" );
							} else {
								self.globalAlert.type = "danger";
								self.globalAlert.message = response.messages.join( "<br>" );
							}
						})
						.catch( error => {
							self.globalAlert.type = "danger";
							self.globalAlert.message = error.toString();
							console.log( error );
						} );
				})
			},
			displayAPIResponseErrors( response ){
				var errors = response.messages;
				if( errors.length && errors[ 0 ].indexOf( "Validation" ) > -1 ){
					Object.entries( response.data )
								.map( validation => validation[ 1 ] )
								.reduce(
									( acc, messages ) => {
										messages.forEach( m => acc.push( m.message ) );
										return acc;
									},
								[] ).forEach( m => errors.push( m ) );

				}
				this.errorMessages = errors.join( "<br>" );
				window.scrollTo( 0, 0 );
			},
			deleteSelected(){
				if( this.selectedTemplates.length ){
					this.selectedTemplates.forEach(
						(item, index ) => {
							this.deleteTemplate( item, this.templates.findIndex( t => t.templateID == item ) );
						}
					)
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