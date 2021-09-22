<cfoutput>
<script>
"use strict";
function categoriesCrud(){
	return {
		// Properties
		categories 		: [],
		pagination  	: { maxRows : 0, offset : 0, page : 1, totalPages : 1, totalRecords : 0 },
		baseUrl 		: "#encodeForJavaScript( event.buildLink( prc.xehCategories ) )#",
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
		categoryForm 		: {
			categoryID 	: "",
			category 	: "",
			slug 		: "",
			isPublic 	: true
		},
		selectedCategories : [],

		init(){
			this.searchCategories();
		},

		closeEditor(){
			this.isEditorOpen = false;
			this.resetCategoryForm();
		},

		editCategory( cat ){
			this.categoryForm = cat || this.resetCategoryForm();
			this.isEditorOpen = true;
		},

		saveCategory() {
			this.errorMessages = "";
			this.isSubmitting = true;
			fetch( `${this.baseUrl}/save`, {
				method 	: 'POST',
                body 	: JSON.stringify( this.categoryForm )
            })
			.then( r => r.json() )
			.then( ( response ) => {
				this.isSubmitting = false;
				if( response.error ){
					this.errorMessages = response.messages.join( "<br>" )
				} else {
					this.searchCategories();
					this.closeEditor();
				}
			})
			.catch( error => {
				this.globalAlert.type = "danger";
				this.globalAlert.message = error.toString();
				console.log( error );
			} );
		},

		resetCategoryForm(){
			return this.categoryForm = {
				categoryID 	: "",
				category 	: "",
				slug 		: "",
				isPublic 	: true
			};
		},

		searchCategories(){
			this.isLoading = true;
			fetch( `${this.baseUrl}/search?search=${this.searchQuery}&isPublic=${this.isPublicFilter}` )
				.then( r => r.json() )
				.then( ( response ) => {
					this.categories = response.data;
					this.pagination = response.pagination;
					this.isLoading = false;
				})
				.catch( error => {
					this.globalAlert.type = "danger";
					this.globalAlert.message = error.toString();
					console.log( error );
				} );
		},

		deleteCategory( categoryID, index ){
			this.globalAlert.message = "";
			if( confirm( "Are you sure?" ) ){
				fetch( `${this.baseUrl}/remove`, {
					method : "post",
					body : JSON.stringify( { categoryID : categoryID } )
				})
					.then( r => r.json() )
					.then( ( response ) => {
						if( !response.error ){
							this.categories.splice( index, 1 );
							this.globalAlert.type = "info";
							this.globalAlert.message = response.messages.join( "<br>" );
							this.searchCategories();
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
			if( this.selectedCategories.length ){
				this.deleteCategory( this.selectedCategories );
			} else {
				alert( "Please select something to delete!" );
			}
		},

		exportSelected(){
			if( this.selectedCategories.length ){
				window.open( `${this.baseUrl}/exportAll/categoryID/${this.selectedCategories}`);
			} else {
				alert( "Please select something to export!" );
			}
		},

		selectAll( toggle ){
			if( toggle ){
				this.categories.forEach( ( cat ) => this.selectedCategories.push( cat.categoryID ) );
			} else {
				this.selectedCategories = [];
			}
		}

	};
}
</script>
</cfoutput>