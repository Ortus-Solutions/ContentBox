<cfoutput>
#html.startForm(name="settingsForm",action=rc.xehSaveHTML)#		
<!--============================Sidebar============================-->
<div class="sidebar">
	<!--- Saerch Box --->
	<div class="small_box">
		<div class="header">
			<img src="#prc.bbroot#/includes/images/settings.png" alt="info" width="24" height="24" />Actions
		</div>
		<div class="body">
			<div class="actionBar">
				#html.submitButton(value="Save Custom HTML",class="buttonred",title="Save the Custom HTML settings")#
			</div>
		</div>
	</div>	
</div>
<!--End sidebar-->	
<!--============================Main Column============================-->
<div class="main_column" id="main_column">
	<div class="box">
		<!--- Body Header --->
		<div class="header">
			<img src="#prc.bbroot#/includes/images/html_32.png" alt="customHTML" />
			Custom HTML
		</div>
		<!--- Body --->
		<div class="body">	
		
		<!--- messageBox --->
		#getPlugin("MessageBox").renderit()#
		
		<p>
			These custom HTML options can be used in any layout to easily add any type of HTML assets, snippets, custom css, js, you name it!
			Just call it with the appropriate slug in your BlogBox layout and you are ready to roll with custom HTML in your layouts.
		</p>
		
		<!--- Info --->
		<div class="infoBar">
			<img src="#prc.bbRoot#/includes/images/info.png" alt="info" />
			Any blogbox setting can be used for custom HTML or custom output via the UI BBHelper -> 
			 <em>##bb.setting(slug)##</em>;
		</div>
		
		<!--- Usage --->
		<div class="infoBar">
			<img src="#prc.bbRoot#/includes/images/info.png" alt="info" />
			To render the Custom HTML snippets use the following in your layouts -> 
			 <em>##bb.customHTML(slug)##</em>;
		</div>
		
		<!--- Before Head End  --->
		<label for="bb_html_beforeHeadEnd">Before Head End:</label>
		<small>Slug: beforeHeadEnd</small><br/>
		#html.textarea(name="bb_html_beforeHeadEnd",value=prc.bbSettings.bb_html_beforeHeadEnd,rows=10)#
		<!--- After Body Start --->
		<label for="bb_html_beforeHeadEnd">After Body Start:</label>
		<small>Slug: afterBodyStart</small><br/>
		#html.textarea(name="bb_html_afterBodyStart",value=prc.bbSettings.bb_html_afterBodyStart,rows=10)#
		<!--- Before Body End --->
		<label for="bb_html_beforeBodyEnd">Before Body End:</label>
		<small>Slug: beforeBodyEnd</small><br/>
		#html.textarea(name="bb_html_beforeBodyEnd",value=prc.bbSettings.bb_html_beforeBodyEnd,rows=10)#
		<!--- Before SideBar --->
		<label for="bb_html_beforeSideBar">Before Side Bar::</label>
		<small>Slug: beforeSideBar</small><br/>
		#html.textarea(name="bb_html_beforeSideBar",value=prc.bbSettings.bb_html_beforeSideBar,rows=10)#
		<!--- After SideBar --->
		<label for="bb_html_afterSideBar">After Side Bar::</label>
		<small>Slug: afterSideBar</small><br/>
		#html.textarea(name="bb_html_afterSideBar",value=prc.bbSettings.bb_html_afterSideBar,rows=10)#
		
		</div>
	</div>
</div>		
#html.endForm()#

<script type="text/javascript">
$(document).ready(function() {
	// form validators
	$("##commentSettingsForm").validator({grouped:true});
});
</script>
</cfoutput>