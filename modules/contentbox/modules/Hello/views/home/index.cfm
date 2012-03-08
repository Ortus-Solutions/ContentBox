<cfoutput>
<!--============================Sidebar============================-->
<div class="sidebar">

	<!--- Info Box --->
	<div class="small_box expose">
		<div class="header">
			<img src="#prc.cbroot#/includes/images/info.png" alt="info" width="24" height="24" />Need Help?
		</div>
		<div class="body">
			<a href="http://www.ortussolutions.com" target="_blank" title="The Gurus behind ColdBox and ContentBox">
			<div class="center"><img src="#prc.cbroot#/includes/images/ortus-top-logo.png" alt="Ortus Solutions" border="0" /></a><br/></div>

			<p><strong>Ortus Solutions</strong> is the company behind anything ColdBox and ContentBox. Need professional support, architecture analysis,
			code reviews, custom development or anything ColdFusion, ColdBox, ContentBox related?
			<a href="mailto:help@ortussolutions.com">Contact us</a>, we are here
			to help!</p>
		</div>
	</div>

</div>
<!--End sidebar-->
<!--============================Main Column============================-->
<div class="main_column">
	<div class="box">
		<!--- Body Header --->
		<div class="header">
			<img src="#prc.cbroot#/includes/images/ortus_circle_small.gif" alt="ortus" width="30" height="30" title="Ortus Solutions, Corp" />
			Hello Module
		</div>
		<!--- Body --->
		<div class="body" id="mainBody">

			<!--- Logo --->
			<div class="center">
				<img src="#prc.cbroot#/includes/images/ContentBox_300.png" alt="logo"/><br/>
				v.#getModuleSettings('contentbox').version# <br/>
				(Codename: <a href="#getModuleSettings("contentbox").settings.codenameLink#" target="_blank">#getModuleSettings("contentbox").settings.codename#</a>)
				<br/><br/>
			</div>

			<p>
				Hi and welcome to the Hello module, ContentBox says <strong>Hello Buddy!</strong>, what you expected more?
			</p>


		</div>
	</div>
</div>
</cfoutput>