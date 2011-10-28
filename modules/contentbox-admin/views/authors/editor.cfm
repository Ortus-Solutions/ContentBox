<cfoutput>
<!--============================Sidebar============================-->
<div class="sidebar">
	<!--- Info Box --->
	<div class="small_box">
		<div class="header">
			<img src="#prc.cbroot#/includes/images/settings.png" alt="info" width="24" height="24" />Author Actions
		</div>
		<div class="body">
			<!--- Back button --->
			<p class="center">
				<button class="button" onclick="return to('#event.buildLink(prc.xehAuthors)#')"> <img src="#prc.cbroot#/includes/images/go-back.png" alt="help"/> Back To Authors</button>
			</p>			
		</div>
	</div>	
	<!--- User Details --->
	<cfif prc.author.isLoaded()>
	<div class="small_box">
		<div class="header">
			<img src="#prc.cbroot#/includes/images/users_icon.png" alt="info" width="24" height="24" />Author Details
		</div>
		<div class="body">
			<!--- Info --->
			<div class="floatLeft">
				#getMyPlugin(plugin="Avatar",module="contentbox").renderAvatar(email=prc.author.getEmail(),size="40")#
			</div>	
			<div id="authorDetails">
				<a title="Email Me!" href="mailto:#prc.author.getEmail()#">#prc.author.getName()#</a>
			</div>
				
			<!--- Persisted Info --->
			<table class="tablelisting" width="100%">
				<tr>
					<th width="75" class="textRight">Last Login</th>
					<td>
						#prc.author.getDisplayLastLogin()#
					</td>
				</tr>
				<tr>
					<th width="75" class="textRight">Created Date</th>
					<td>
						#prc.author.getDisplayCreatedDate()#
					</td>
				</tr>						
			</table>			
		</div>
	</div>			
	</cfif>
</div>
<!--End sidebar-->	
<!--============================Main Column============================-->
<div class="main_column">
	<div class="box">
		<!--- Body Header --->
		<div class="header">
			<img src="#prc.cbroot#/includes/images/user-admin.png" alt="sofa" width="30" height="30" />
			<cfif prc.author.isLoaded()>Edit #prc.author.getName()#<cfelse>Create Author</cfif>
		</div>
		<!--- Body --->
		<div class="body">
			#getPlugin("MessageBox").renderIt()#
			
			<!--- AuthorForm --->
			#html.startForm(name="authorForm",action=prc.xehAuthorsave,novalidate="novalidate")#
				#html.startFieldset(legend="Author Details")#
				#html.hiddenField(name="authorID",bind=prc.author)#
				<!--- Fields --->
				#html.textField(name="firstName",bind=prc.author,label="First Name:",required="required",size="50",class="textfield")#
				#html.textField(name="lastName",bind=prc.author,label="Last Name:",required="required",size="50",class="textfield")#
				#html.inputField(name="email",type="email",bind=prc.author,label="Email:",required="required",size="50",class="textfield")#
				#html.textField(name="username",bind=prc.author,label="Username:",required="required",size="50",class="textfield")#
				<cfif NOT prc.author.isLoaded()>
				#html.textField(name="password",bind=prc.author,label="Password:",required="required",size="50",class="textfield")#
				</cfif>
				#html.select(label="Active User:",name="isActive",options="yes,no",style="width:200px",bind=prc.author)#
				
				<!--- Action Bar --->
				<div class="actionBar">
					<button class="button" onclick="return to('#event.buildLink(prc.xehAuthors)#')">Cancel</button> or 
					<input type="submit" value="Save" class="buttonred">
				</div>
				#html.endFieldSet()#
			#html.endForm()#
			
			<!--- Change Password --->
			<cfif prc.author.isLoaded()>
			#html.startForm(name="authorPasswordForm",action=prc.xehAuthorChangePassword,novalidate="novalidate")#
				#html.startFieldset(legend="Change Password")#
				#html.hiddenField(name="authorID",bind=prc.author)#
				<!--- Fields --->
				#html.textField(name="password",label="Password:",required="required",size="50",class="textfield")#
				#html.textField(name="password_confirm",label="Confirm Password:",required="required",size="50",class="textfield")#
				
				<!--- Action Bar --->
				<div class="actionBar">
					<button class="button" onclick="return to('#event.buildLink(prc.xehAuthors)#')">Cancel</button> or 
					<input type="submit" value="Change Password" class="buttonred">
				</div>
				#html.endFieldSet()#
			#html.endForm()#
			
			<!--- My Entries --->
			#html.startFieldset(legend="Author Entries")#
				<!--- Entries Pager Viewlet --->
				#prc.entryViewlet#
			#html.endFieldSet()#
			
			<!--- My Pages --->
			#html.startFieldset(legend="Author Pages")#
				<!--- Pages Pager Viewlet --->
				#prc.pageViewlet#
			#html.endFieldSet()#
			
			</cfif>
		</div>	<!--- body --->
	</div> <!--- main box --->
</div> <!--- main column --->
<!--- Custom JS --->
<script type="text/javascript">
$(document).ready(function() {
	$("##entries").tablesorter();
	// form validators
	$("##authorForm").validator({grouped:true});
	$("##authorPasswordForm").validator({grouped:true});
	<cfif prc.author.isLoaded()>
	$.tools.validator.fn("[name=password_confirm]", "Passwords need to match", function(el, value) {
		return (value==$("[name=password]").val()) ? true : false;
	});
	</cfif>
});
</script>
</cfoutput>