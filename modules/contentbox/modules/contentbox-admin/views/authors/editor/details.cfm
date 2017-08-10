<cfoutput>
<div class="tab-pane active" id="details" style="min-height: 400px">
	<!--- AuthorForm --->
	#html.startForm(
		name 		= "authorForm",
		action 		= prc.xehAuthorsave,
		novalidate 	= "novalidate",
		class 		= "form-vertical"
	)#
		#html.startFieldset( legend="User Details" )#
		#html.hiddenField( name="authorID", bind=prc.author )#

		#html.textField(
			name    		= "firstName",
			bind    		= prc.author,
			label   		= "*First Name:",
			required		= "required",
			size    		= "50",
			class   		= "form-control",
			wrapper 		= "div class=controls",
			labelClass 		= "control-label",
			groupWrapper 	= "div class=form-group"
		)#

		#html.textField(
			name    		= "lastName",
			bind    		= prc.author,
			label   		= "*Last Name:",
			required		= "required",
			size    		= "50",
			class   		= "form-control",
			wrapper 		= "div class=controls",
			labelClass 		= "control-label",
			groupWrapper 	= "div class=form-group"
		)#

		#html.inputField(
			name    		= "email",
			type    		= "email",
			bind    		= prc.author,
			label   		= "*Email:",
			required		= "required",
			size    		= "50",
			class   		= "form-control",
			wrapper 		= "div class=controls",
			labelClass 		= "control-label",
			groupWrapper 	= "div class=form-group"
		)#

		#html.textField(
			name    		= "username",
			bind    		= prc.author,
			label   		= "*Username:",
			required		= "required",
			size    		= "50",
			class   		= "form-control username",
			wrapper 		= "div class=controls",
			labelClass		= "control-label",
			groupWrapper	= "div class=form-group"
		)#

		<!--- Active --->
		<cfif prc.oCurrentAuthor.checkPermission( "AUTHOR_ADMIN" )>
			<div class="form-group">
				#html.label(
					class   = "control-label",
					field   = "isActive",
					content = "Active User:"
				)#

				<div class="controls">
					#html.checkbox(
						name    = "isActive_toggle",
						data	= { toggle: 'toggle', match: 'isActive' },
						checked = prc.author.getIsActive()
					)#
					#html.hiddenField(
						name	= "isActive",
						bind 	= prc.author
					)#
				</div>
			</div>

			<!--- Roles --->
			#html.select(
				label     		= "User Role:",
				name      		= "roleID",
				options   		= prc.roles,
				column    		= "roleID",
				nameColumn		= "role",
				bind      		= prc.author.getRole(),
				style     		= "width:200px",
				class     		= "form-control input-sm",
				wrapper   		= "div class=controls",
				labelClass		= "control-label",
				groupWrapper 	= "div class=form-group"
			)#
		<cfelse>
			<label>Active User: </label> 
			<span class="label label-info">#prc.author.getIsActive()#</span><br/>
			<label>User Role: </label> 
			<span class="label label-info">#prc.author.getRole().getRole()#</span><br/>
		</cfif>

		<!--- Biography --->
		#html.textarea(
			name   			= "biography",
			label  			= "Biography or Notes About The User:",
			bind   			= prc.author,
			rows   			= "10",
			class  			= "form-control",
			wrapper			= "div class=controls",
			labelClass  	= "control-label",
			groupWrapper	= "div class=form-group"
		)#

		#html.endFieldSet()#

		<!--- Action Bar --->
		<cfif prc.oCurrentAuthor.checkPermission( "AUTHOR_ADMIN" ) OR prc.author.getAuthorID() EQ prc.oCurrentAuthor.getAuthorID()>
		<div class="form-actions">
			<input type="submit" value="Save Details" class="btn btn-danger">
		</div>
		</cfif>

	#html.endForm()#
</div>
</cfoutput>