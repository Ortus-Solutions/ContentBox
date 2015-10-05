<cfoutput>
<div class="row-fluid">
	<!--- main content --->
	<div class="span9" id="main-content">
		<div class="box">
			<!--- Body Header --->
			<div class="header">
				<i class="icon-beaker"></i>
				Hello Module
			</div>
			<!--- Body --->
			<div class="body" id="mainBody">

				<!--- Logo --->
				<div class="center">
					<img src="#prc.cbroot#/includes/images/ContentBox_300.png" alt="logo"/><br/>
					v.#getModuleConfig('contentbox').version# <br/>
					(Codename: <a href="#getModuleSettings( "contentbox" ).codenameLink#" target="_blank">#getModuleSettings( "contentbox" ).codename#</a>)
					<br/><br/>
				</div>

				<p>
					Hi and welcome to the Hello module, ContentBox says <strong>Hello Buddy!</strong>, what you expected more?
				</p>


			</div>
		</div>
	</div>

	<div class="span3" id="main-sidebar">
		<!--- Info Box --->
		<div class="small_box">
			<div class="header">
				<i class="icon-medkit"></i> Need Help?
			</div>
			<div class="body">
				#renderView(view="_tags/needhelp", module="contentbox-admin" )#
			</div>
		</div>	
	</div>

</div>
</cfoutput>