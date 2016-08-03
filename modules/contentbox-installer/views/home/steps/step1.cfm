<cfoutput>
<!--- Admin Info --->
#html.startFieldset( legend=cb.r( "tab.admin@installer" ) )#
<p>
    #cb.r( "tab.admin.instructions@installer" )#
</p>
<!--- Fields --->
#html.textField(
    name="firstName",
    label=cb.r( "tab.admin.fname@installer" ),
    required="required",
    size="100",
    class="form-control",
    wrapper="div class=controls",
    labelClass="control-label",
    groupWrapper="div class=form-group"
)#
#html.textField(
    name="lastName",
    label=cb.r( "tab.admin.lname@installer" ),
    required="required",
    size="100",
    class="form-control",
    wrapper="div class=controls",
    labelClass="control-label",
    groupWrapper="div class=form-group"
)#
#html.inputField(
    name="email",
    type="email",
    label=cb.r( "tab.admin.email@installer" ),
    required="required",
    size="100",
    class="form-control",
    wrapper="div class=controls",
    labelClass="control-label",
    groupWrapper="div class=form-group"
)#
#html.textField(
    name="username",
    label=cb.r( "tab.admin.username@installer" ),
    required="required",
    size="100",
    class="form-control",
    wrapper="div class=controls",
    labelClass="control-label",
    groupWrapper="div class=form-group"
)#
#html.passwordField(
    name="password",
    label=cb.r( "tab.admin.password@installer" ),
    required="required",
    size="100",
    class="form-control pwcheck",
    wrapper="div class=controls",
    labelClass="control-label",
    groupWrapper="div class=form-group"
)#
#html.passwordField(
    name="password_confirm",
    label=cb.r( "tab.admin.password_confirm@installer" ),
    required="required",
    size="100",
    class="form-control passwordmatch",
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
