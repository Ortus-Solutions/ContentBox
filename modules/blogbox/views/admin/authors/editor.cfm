<cfoutput>
<cfform action="#event.buildLink(rc.xehAuthorSave)#" method="POST"	name="newPostForm">
	<input type="hidden" name="authorID" id="authorID" value="#rc.author.getauthorID()#" />
	<h1>Author Editor</h1>
	
	<p>First Name:<br/>
	<cfinput name="firstName" type="text" required="true" validateat="onSubmit" 
			 maxlength="100" size="50" message="Please enter a first name." 
			 value="#rc.author.getFirstName()#"/>
	</p>
	
	<p>Last Name:<br/>
	<cfinput name="lastname" type="text" required="true" validateat="onSubmit" 
			 maxlength="100" size="50" message="Please enter a last name." 
			 value="#rc.author.getLastName()#"/>
	</p>
	
	<p>Email:<br/>
	<cfinput name="email" type="text" required="true" validateat="onSubmit" 
			 maxlength="255" size="50" message="Please enter an email address." 
			 value="#rc.author.getEmail()#"/>
	</p>
	
	<p>Username:<br/>
	<cfinput name="username" type="text" required="true" validateat="onSubmit" 
			 maxlength="100" size="50" message="Please enter a username." 
			 value="#rc.author.getUsername()#"/>
	</p>
	
	<p>Password<br/>
	<cfinput name="password" type="text" required="true" validateat="onSubmit" 
			 maxlength="100" size="50" message="Please enter a password." 
			 value="#rc.author.getPassword()#"/>
	</p>
	
	<p>isActive</p>
	#html.select(name="isActive",options="yes,no")#
	
	<cfif len(rc.author.getAuthorID())>
	<p>
		Last Login: #rc.author.getDisplayLastLogin()#
	</p>
	<p>
		Created Date: #rc.author.getDisplayCreatedDate()#
	</p>
	<p>
		Updated Date: #rc.author.getDisplayUpdatedDate()#
	</p>
	</cfif>
	
	<hr/>
	
	<p>
		<a href="#event.buildLink(rc.xehAuthors)#">Cancel</a> or
		<input type="submit" value="Save">
	</p>
</cfform>
</cfoutput>