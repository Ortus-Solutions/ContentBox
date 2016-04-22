<cfoutput>
<!--- URL Rewrites --->
#html.startFieldset( legend=cb.r( "tab.rewrites@installer" ) )#
<p>
	#cb.r( "tab.rewrites.intro@installer" )#
	<a href="http://httpd.apache.org/docs/current/mod/mod_rewrite.html">Apache mod_rewrite</a>,
	<a href="http://www.tuckey.org/urlrewrite/">Tuckey URL Rewrite</a> #cb.r( "common.or@installer" )# 
	<a href="http://www.iis.net/download/urlrewrite">IIS 7 Rewrite</a> #cb.r( "common.or@installer" )#
	<a href="http://www.nginx.org">Nginx</a>.
	#cb.r( "tab.rewrites.intro2@installer" )#
</p>

<div class="alert alert-info">
	#cb.r( "tab.rewrites.alert@installer" )#
</div>

<!--- Rewrites --->
<div class="form-group">
	#html.label( 
		class   = "control-label",
		field   = "fullrewrite",
		content = cb.r( "tab.rewrites.enable@installer" ) 
	)#
	<div class="controls">
		<label>
			#html.radioButton( 
				name 	= "fullrewrite",
				value 	= true 
			)# 
			#cb.r( "common.yes@installer" )#
		</label>
		#html.select( 
			options = "commandbox,contentbox_express,mod_rewrite,iis7",
			name    = "rewrite_engine",
			class   = "input-sm"
		)#
		<br/>
		<label>
			#html.radioButton( 
				name 	= "fullrewrite",
				checked = true,
				value 	= false 
			)# 
			#cb.r( "common.no@installer" )#     
		</label>
	</div>
</div>
#html.endFieldSet()#

<!--- Action Bar --->
<div class="form-actions">
	<a href="javascript:prevStep()" class="btn btn-primary">
		<i class="fa fa-chevron-left"></i> #cb.r( "tab.previous@installer" )#
	</a>
	#html.button( 
		type 	= "submit",
		name 	= "submit",
		value 	= "<i class='fa fa-check'></i> #cb.r( 'tab.start@installer' )#",
		class 	= "btn btn-danger",
		title 	= cb.r( 'tab.start.title@installer' ) 
	)#
</div>
</cfoutput>