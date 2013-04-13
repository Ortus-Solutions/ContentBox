<cfoutput>
<div class="row-fluid">
<div class="box">
	<div class="header">
		<i class="icon-lightbulb icon-large"></i> Install Wizard Finished
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
				<div class="hero-unit">
					<h1>ContentBox Has Been Installed & Configured!</h1>
					<hr>
					<p>
						Hip Hip, Hooray! Your ContentBox is now installed and configured according to your wishes!  
						You can now log in to your administrator or view your beautiful masterpiece. I hope
						you remember the credentials you created!
					</p>
					
					<!--- Info Panel --->
					<div class="alert alert-error">
						<i class="icon-warning-sign icon-large icon-4x pull-left"></i>
						<strong>Now that you are done, we recommend you remove these modules from disk, unless you plan to use them in the future: <br/>
						<em>/{installed_location}/modules/contentbox-installer</em><br/>
						<em>/{installed_location}/modules/contentbox-dsncreator</em></strong>
					</div>
					<hr>
					<h2>
						I am excited, are you? Let's get started!
					</h2>
					
					<p>
						<a href="#event.buildLink(prc.xehSite)#" class="btn btn-primary">Visit Site</a>
						<a href="#event.buildLink(prc.xehAdmin)#" class="btn btn-danger">Visit Administrator</a>
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
</div>
</cfoutput>