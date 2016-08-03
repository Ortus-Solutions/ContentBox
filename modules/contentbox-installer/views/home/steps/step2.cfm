<cfoutput>
<!--- Site Info --->
#html.startFieldset( legend=cb.r( "tab.site@installer" ) )#
#cb.r( "tab.site.instructions@installer" )#

<!--- Populate With Sample Data --->
<div class="form-group">
    #html.label( 
        field="populatedata", 
        content=cb.r( "tab.site.sampledata@installer" ), 
        class="control-label" 
    )#
    <div class="controls">
        #html.radioButton( 
            name="populatedata", 
            checked=true, 
            value=true,
            autocomplete=false 
        )# #cb.r( "common.yes@installer" )#  

        #html.radioButton( 
            name="populatedata", 
            value=false, 
            autocomplete=false 
        )# #cb.r( "common.no@installer" )#  
    </div>
</div>
<!--- Site Name  --->
#html.textField( 
    name="siteName",
    label=cb.r( "tab.site.sitename@installer" ),
    class="form-control",
    size="100",
    title=cb.r( "tab.site.sitename.title@installer" ),
    required="required",
    wrapper="div class=controls",
    labelClass="control-label",
    groupWrapper="div class=form-group"
)#
<!--- Site Email --->
#html.inputField( 
    name="siteEmail",
    type="email",
    label=cb.r( "tab.site.admin@installer" ),
    class="form-control",
    size="100",
    title=cb.r( "tab.site.admin.title@installer" ),
    required="required",
    wrapper="div class=controls",
    labelClass="control-label",
    groupWrapper="div class=form-group"
)#
<!--- Outgoing Email --->
#html.inputField( 
    name="siteOutgoingEmail",
    type="email",
    label=cb.r( "tab.site.outgoing@installer" ),
    class="form-control",
    size="100",
    title=cb.r( "tab.site.outgoing.title@installer" ),
    required="required",
    wrapper="div class=controls",
    labelClass="control-label",
    groupWrapper="div class=form-group"
)#
<!--- Tag Line --->
#html.textField( 
    name="siteTagLine",
    label=cb.r( "tab.site.tagline@installer" ),
    class="form-control",
    size="100",
    title=cb.r( "tab.site.tagline.title@installer" ),
    required="required",
    wrapper="div class=controls",
    labelClass="control-label",
    groupWrapper="div class=form-group"
)#
<!--- Description --->
#html.textarea( 
    name="siteDescription",
    label=cb.r( "tab.site.description@installer" ),
    rows="3",
    class="form-control",
    title=cb.r( "tab.site.description.title@installer" ),
    wrapper="div class=controls",
    labelClass="control-label",
    groupWrapper="div class=form-group"
)#        
<!--- Keywords --->
#html.textarea( 
    name="siteKeywords",
    label=cb.r( "tab.site.keywords@installer" ),
    rows="3",
    class="form-control",
    title=cb.r( "tab.site.keywords.title@installer" ),
    wrapper="div class=controls",
    labelClass="control-label",
    groupWrapper="div class=form-group"
)#     
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