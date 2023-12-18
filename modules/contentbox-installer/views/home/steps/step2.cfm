<cfoutput>
<!--- Site Info --->
#html.startFieldset()#

<!--- Instructions --->
<div class="mt10 mb20">
	#cb.r( "tab.site.instructions@installer" )#
</div>

<!--- Site Name  --->
#html.textField(
    name              = "siteName",
    label             = "*#cb.r( "tab.site.sitename@installer" )#",
    class             = "form-control",
    size              = "100",
    title             = cb.r( "tab.site.sitename.title@installer" ),
    required          = "required",
    wrapper           = "div class=controls",
    labelClass        = "control-label",
    groupWrapper      = "div class=form-group",
	value 			  = "Default Site"
)#

<!--- Site Slug --->
#html.textField(
    name              = "siteSlug",
    label             = "*#cb.r( "tab.site.slug@installer" )#",
    class             = "form-control",
    size              = "100",
    title             = cb.r( "tab.site.slug.title@installer" ),
    wrapper           = "div class=controls",
    labelClass        = "control-label",
    groupWrapper      = "div class=form-group",
	value 			  = "default"
)#

<!--- Tag Line --->
#html.textField(
    name              = "siteTagLine",
    label             = "#cb.r( "tab.site.tagline@installer" )#",
    class             = "form-control",
    size              = "100",
    title             = cb.r( "tab.site.tagline.title@installer" ),
    wrapper           = "div class=controls",
    labelClass        = "control-label",
    groupWrapper      = "div class=form-group"
)#

<!--- Description --->
#html.textarea(
    name              = "siteDescription",
    label             = cb.r( "tab.site.description@installer" ),
    rows              = "2",
    class             = "form-control",
    title             = cb.r( "tab.site.description.title@installer" ),
    wrapper           = "div class=controls",
    labelClass        = "control-label",
    groupWrapper      = "div class=form-group"
)#

<!--- Keywords --->
#html.textarea(
    name              = "siteKeywords",
    label             = cb.r( "tab.site.keywords@installer" ),
    rows              = "2",
    class             = "form-control",
    title             = cb.r( "tab.site.keywords.title@installer" ),
    wrapper           = "div class= controls",
    labelClass        = "control-label",
    groupWrapper      = "div class=form-group"
)#

<fieldset>
	<legend>Site Detection</legend>
</fieldset>

<p>
	Site detection is done against the incoming domain name found in the cgi scope. Below you can register the primary domain regular expression with the domain base url it represents alongside any domain aliases you might have.
</p>

<!--- Domain Expression --->
#html.textField(
    name              = "siteDomainExpression",
    label             = "*Domain Expression(s): ",
    class             = "form-control",
    size              = "100",
    title             = "A domain name or regular expression that will be used to match the incoming domain with.",
    wrapper           = "div class=controls",
    labelClass        = "control-label",
    groupWrapper      = "div class=form-group",
	required 		  = "required",
	value 		      = "127\.0\.0\.1"
)#

<div class="form-group">
	#html.label(
		class   = "control-label",
		field   = "domain",
		content = "*Domain Base URL:"
	)#
	<p>
		The domain base URL so we can construct URLs to this site.
	</p>

	<div class="input-group">
		<span class="input-group-addon">https://</span>
		<input
			name="siteDomain"
			type="text"
			class="form-control"
			placeholder="mydomain.com"
			required="required"
			value="127.0.0.1"
		>
	</div>
</div>


<!--- Site Options --->
<fieldset>
	<legend>Site Options:</legend>
</fieldset>

<!--- Info --->
<p>
	Below you can choose to populate your <strong>default</strong> site with sample blog entries, content store items, pages and more.
	You can also choose to create a <strong>development</strong> site which will run under the <code>localhost</code>
	domain.  This will allow you to have a <strong>production</strong> and <strong>development</strong> site all on the same ContentBox installation.
	You can also change the domain for this site later on in the administrator.
</p>

<!--- Populate With Sample Data --->
<div class="row">
	<div class="col-md-3 well well-sm rounded ml20 mt10 text-center">
		#html.label(
			field   = "populatedata",
			content = cb.r( "tab.site.sampledata@installer" ),
			class   = "control-label"
		)#
		<div class="controls">
			#html.checkbox(
				name    = "populatedata_toggle",
				data	= { toggle: 'toggle', match: 'populatedata' },
				checked = true
			)#
			#html.hiddenField(
				name	= "populatedata",
				value   = true
			)#
		</div>
	</div>

	<div class="col-md-3 well well-sm rounded ml20 mt10 text-center">
		#html.label(
			field   = "createDevSite",
			content = "Create Development Site",
			class   = "control-label"
		)#
		<div class="controls">
			#html.checkbox(
				name    = "createDevSite_toggle",
				data	= { toggle: 'toggle', match: 'createDevSite' },
				checked = true
			)#
			#html.hiddenField(
				name	= "createDevSite",
				value   = true
			)#
		</div>
	</div>
</div>

#html.endFieldSet()#

<!---Toolbar --->
<div class="form-actions">
    <a href="javascript:prevStep()" class="btn btn-primary">
        <i class="fa fa-chevron-left"></i> #cb.r( "tab.previous@installer" )#
    </a>
    <a href="javascript:nextStep()" class="btn btn-primary">
        #cb.r( "tab.next@installer" )# <i class="fa fa-chevron-right"></i>
    </a>
</div>
</cfoutput>
