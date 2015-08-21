<cfoutput>
<fieldset>
    <legend><i class="fa fa-user fa-lg"></i> Gravatars</legend>
    <p>An avatar is an image that follows you from site to site appearing beside your name when you comment on avatar enabled sites.(<a href="http://www.gravatar.com/" target="_blank">http://www.gravatar.com/</a>)</p>

    <!--- Gravatars  --->
    <div class="form-group">
        #html.label(
            class="control-label",
            field="cb_gravatar_display",
            content="Show Avatars:"
        )#
        <div class="controls">
            #html.radioButton(
                name="cb_gravatar_display",
                checked=prc.cbSettings.cb_comments_urltranslations,
                value=true
            )# Yes
            #html.radioButton(
                name="cb_gravatar_display",
                checked=not prc.cbSettings.cb_comments_urltranslations,
                value=false
            )# No
        </div>
    </div>
    <!--- Avatar Rating --->
    <div class="form-group">
        <label class="control-label" for="cb_gravatar_rating">Maximum Avatar Rating:</label>
        <div class="controls">
            <select name="cb_gravatar_rating" id="cb_gravatar_rating" class="form-control input-sm">
                <option value="G"  <cfif prc.cbSettings.cb_gravatar_rating eq "G">selected="selected"</cfif>>G - Suitable for all audiences</option>
                <option value="PG" <cfif prc.cbSettings.cb_gravatar_rating eq "PG">selected="selected"</cfif>>PG - Possibly offensive, usually for audiences 13 and above</option>
                <option value="R"  <cfif prc.cbSettings.cb_gravatar_rating eq "R">selected="selected"</cfif>>R - Intended for adult audiences above 17</option>
                <option value="X"  <cfif prc.cbSettings.cb_gravatar_rating eq "X">selected="selected"</cfif>>X - Even more mature than above</option>
            </select>
        </div>
    </div>
    
    <!---Gravatar info --->
    <div class="alert alert-info clearfix">
        <i class="fa fa-info-circle fa-lg"></i>
        To change or create avatars <a href="http://www.gravatar.com/site/signup" target="_blank">sign up to Gravatar.com</a>
        and follow the on-screen instructions.
    </div>
    
</fieldset>
</cfoutput>