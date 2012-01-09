<cfoutput>
<div class="box clear">
	<div class="header">
		<img src="#prc.assetRoot#/includes/images/help.png" alt="help" width="30" height="30" />Install Wizard Finished
	</div>
	<div class="body_vertical_nav clearfix">
		<!--- Tabs --->
		<ul class="vertical_nav">
			<li class="active"><a href="##introduction">Completed</a></li>
		</ul>
		<!--- Tab Content --->
		<div class="main_column">
			<div class="panes_vertical">
				
				<!--- Panel 1 --->
				<div>
					<h1>ContentBox Has Been Installed & Configured!</h1>
					<p>
						Hip Hip, Hooray! Your ContentBox is now installed and configured according to your wishes!  
						You can now log in to your administrator or view your beautiful masterpiece. I hope
						you remember the credentials you created!
					</p>
					
					<br/>
					<h2>
						I am excited, are you? Let's get started!
					</h2>
					
					<p>
						<a href="#event.buildLink(prc.xehSite)#">
							<input name="site" type="button" class="button2" id="start" value="Visit Site">
						</a>
						&nbsp;
						<a href="#event.buildLink(prc.xehAdmin)#">
							<input name="admin" type="button" class="buttonred" id="start" value="Visit Administrator">
						</a>
					</p>
				</div>
				<!--- end panel 1 --->
				
			</div>
			<!--- end panes vertical --->
		</div>
		<!--- end main column --->
	</div>
	<!--- end body content --->
</div>
<!--- end content box --->
</cfoutput>