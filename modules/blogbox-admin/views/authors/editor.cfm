<cfoutput>
<!--============================Sidebar============================-->
<div class="sidebar">
	<!--- Info Box --->
	<div class="small_box">
		<div class="header">
			<img src="#prc.bbroot#/includes/images/settings.png" alt="info" width="24" height="24" />Author Actions
		</div>
		<div class="body">
			<!--- Back button --->
			<p class="center">
				<button class="button" onclick="return to('#event.buildLink(rc.xehAuthors)#')"> <img src="#prc.bbroot#/includes/images/go-back.png" alt="help"/> Back To Authors</button>
			</p>			
		</div>
	</div>	
	<!--- User Details --->
	<cfif rc.author.isLoaded()>
	<div class="small_box">
		<div class="header">
			<img src="#prc.bbroot#/includes/images/users_icon.png" alt="info" width="24" height="24" />Author Details
		</div>
		<div class="body">
			<!--- Info --->
			<div class="floatLeft">
				#getMyPlugin(plugin="Avatar",module="blogbox").renderAvatar(email=rc.author.getEmail(),size="40")#
			</div>	
			<div id="authorDetails">
				<a title="Email Me!" href="mailto:#rc.author.getEmail()#">#rc.author.getName()#</a>
			</div>
				
			<!--- Persisted Info --->
			<table class="tablelisting" width="100%">
				<tr>
					<th width="75" class="textRight">Last Login</th>
					<td>
						#rc.author.getDisplayLastLogin()#
					</td>
				</tr>
				<tr>
					<th width="75" class="textRight">Created Date</th>
					<td>
						#rc.author.getDisplayCreatedDate()#
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
			<img src="#prc.bbroot#/includes/images/user-admin.png" alt="sofa" width="30" height="30" />
			<cfif rc.author.isLoaded()>Edit #rc.author.getName()#<cfelse>Create Author</cfif>
		</div>
		<!--- Body --->
		<div class="body">
			#getPlugin("MessageBox").renderIt()#
			
			<!--- AuthorForm --->
			#html.startForm(name="authorForm",action=rc.xehAuthorSave,novalidate="novalidate")#
				#html.startFieldset(legend="Author Details")#
				#html.hiddenField(name="authorID",bind=rc.author)#
				<!--- Fields --->
				#html.textField(name="firstName",bind=rc.author,label="First Name:",required="required",size="50",class="textfield")#
				#html.textField(name="lastName",bind=rc.author,label="Last Name:",required="required",size="50",class="textfield")#
				#html.inputField(name="email",type="email",bind=rc.author,label="Email:",required="required",size="50",class="textfield")#
				#html.textField(name="username",bind=rc.author,label="Username:",required="required",size="50",class="textfield")#
				<cfif NOT rc.author.isLoaded()>
				#html.textField(name="password",bind=rc.author,label="Password:",required="required",size="50",class="textfield")#
				</cfif>
				#html.select(label="Active User:",name="isActive",options="yes,no",style="width:200px",bind=rc.author)#
				
				<!--- Action Bar --->
				<div class="actionBar">
					<button class="button" onclick="return to('#event.buildLink(rc.xehAuthors)#')">Cancel</button> or 
					<input type="submit" value="Save" class="buttonred">
				</div>
				#html.endFieldSet()#
			#html.endForm()#
			
			<!--- Change Password --->
			<cfif rc.author.isLoaded()>
			#html.startForm(name="authorPasswordForm",action=rc.xehAuthorChangePassword,novalidate="novalidate")#
				#html.startFieldset(legend="Change Password")#
				#html.hiddenField(name="authorID",bind=rc.author)#
				<!--- Fields --->
				#html.textField(name="password",label="Password:",required="required",size="50",class="textfield")#
				#html.textField(name="password_confirm",label="Confirm Password:",required="required",size="50",class="textfield")#
				
				<!--- Action Bar --->
				<div class="actionBar">
					<button class="button" onclick="return to('#event.buildLink(rc.xehAuthors)#')">Cancel</button> or 
					<input type="submit" value="Change Password" class="buttonred">
				</div>
				#html.endFieldSet()#
			#html.endForm()#
			
			<!--- My Entries --->
			#html.startFieldset(legend="Author Entries")#
				<!--- Entries Pager Viewlet --->
				#rc.pagerViewlet#
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
	<cfif rc.author.isLoaded()>
	$.tools.validator.fn("[name=password_confirm]", "Passwords need to match", function(el, value) {
		return (value==$("[name=password]").val()) ? true : false;
	});
	</cfif>
});
</script>
</cfoutput>