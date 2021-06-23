<cfoutput>
<!--- Admin Info --->
#html.startFieldset()#

<!--- Instructions --->
<div class="mt10 mb20">
    #cb.r( "tab.admin.instructions@installer" )#
</div>

<!--- Fields --->
#html.textField(
    name              = "firstName",
    label             = "*#cb.r( "tab.admin.fname@installer" )#",
    required          = "required",
    size              = "100",
    class             = "form-control",
    wrapper           = "div class=controls",
    labelClass        = "control-label",
    groupWrapper      = "div class=form-group"
)#

#html.textField(
    name              = "lastName",
    label             = "*#cb.r( "tab.admin.lname@installer" )#",
    required          = "required",
    size              = "100",
    class             = "form-control",
    wrapper           = "div class=controls",
    labelClass        = "control-label",
    groupWrapper      = "div class=form-group"
)#

#html.inputField(
    name              = "email",
    type              = "email",
    label             = "*#cb.r( "tab.admin.email@installer" )#",
    required          = "required",
    size              = "100",
    class             = "form-control",
    wrapper           = "div class=controls",
    labelClass        = "control-label",
    groupWrapper      = "div class=form-group"
)#

#html.textField(
    name              = "username",
    label             = "*#cb.r( "tab.admin.username@installer" )#",
    required          = "required",
    size              = "100",
    class             = "form-control",
    wrapper           = "div class=controls",
    labelClass        = "control-label",
    groupWrapper      = "div class=form-group"
)#

#html.passwordField(
    name              = "password",
    label             = "*#cb.r( "tab.admin.password@installer" )#",
    required          = "required",
    size              = "100",
    class             = "form-control pwcheck",
    wrapper           = "div class=controls",
    labelClass        = "control-label",
    groupWrapper      = "div class=form-group"
)#

#html.passwordField(
    name              = "password_confirm",
    label             = "*#cb.r( "tab.admin.password_confirm@installer" )#",
    required          = "required",
    size              = "100",
    class             = "form-control passwordmatch",
    wrapper           = "div class=controls",
    labelClass        = "control-label",
    groupWrapper      = "div class=form-group"
)#

<!--- Show Rules --->
<div id="passwordRules" class="well well-sm" data-min-length="8">
    <span class="badge" id="pw_rule_lower">abc</span>
    <span class="badge" id="pw_rule_upper">ABC</span>
    <span class="badge" id="pw_rule_digit">123</span>
    <span class="badge" id="pw_rule_special">!@$</span>
    <span class="badge" id="pw_rule_count">0</span>
    <p class="help-block">At least 8 characters including upper and lower case letters, numbers, and symbols.</p>
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
