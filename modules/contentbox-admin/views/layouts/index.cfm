<cfoutput>
<!--============================Sidebar============================-->
<div class="sidebar">
	<!--- Install Box --->
	<cfif prc.oAuthor.checkPermission("LAYOUT_ADMIN")>
	<div class="small_box">
		<div class="header">
			<img src="#prc.cbroot#/includes/images/settings.png" alt="info" width="24" height="24" />Layout Theme Uploader
		</div>
		<div class="body">
			#html.startForm(name="layoutUploadForm",action=rc.xehlayoutupload,multipart=true,novalidate="novalidate")#
	
				#html.fileField(name="fileLayout",label="Upload Layout (.zip): ", class="textfield",required="required")#		
				
				<div class="actionBar" id="uploadBar">
					#html.submitButton(value="Upload & Install",class="buttonred")#
				</div>
				
				<!--- Loader --->
				<div class="loaders" id="uploadBarLoader">
					<img src="#prc.cbRoot#/includes/images/ajax-loader-blue.gif" alt="loader"/>
				</div>
			#html.endForm()#
		</div>		
	</div>	
	</cfif>
	<!--- Help Box--->
	<div class="small_box" id="help_tips">
		<div class="header">
			<img src="#prc.cbroot#/includes/images/help.png" alt="info" width="24" height="24" />Help Tips
		</div>
		<div class="body">
			<ul class="tipList">
				<li>Previews only show the index page of the layout</li>
			</ul>
		</div>
	</div>			
</div>
<!--End sidebar-->	
<!--============================Main Column============================-->
<div class="main_column">
	<div class="box">
		<!--- Body Header --->
		<div class="header">
			<img src="#prc.cbroot#/includes/images/layouts.png" alt="layouts"/>
			Layout Themes
		</div>
		<!--- Body --->
		<div class="body">
			
			<!--- MessageBox --->
			#getPlugin("MessageBox").renderit()#
			
			<!--- CategoryForm --->
			#html.startForm(name="layoutForm",action=rc.xehlayoutRemove)#
			#html.hiddenField(name="layoutName")#
			
			<!--- Content Bar --->
			<div class="contentBar">
				<!--- Flush Cache Button --->
				<cfif prc.oAuthor.checkPermission("LAYOUT_ADMIN")>
				<div class="buttonBar">
					<button class="button2" onclick="return to('#event.buildLink(rc.xehFlushRegistry)#')" title="Rescan layouts directory and rebuild registry">Rebuild Registry</button>
				</div>
				</cfif>
				<!--- Filter Bar --->
				<div class="filterBar">
					<div>
						#html.label(field="layoutFilter",content="Quick Filter:",class="inline")#
						#html.textField(name="layoutFilter",size="30",class="textfield")#
					</div>
				</div>
			</div>
			
			<img src="#prc.cbRoot#/includes/images/asterisk_orange.png" alt="active" title="Currently Active Layout"/>
			<strong>Active Layout Theme</strong>
			
			<!--- layouts --->
			<table name="layouts" id="layouts" class="tablesorter" width="98%">
				<thead>
					<tr>
						<th width="200">Theme Info</th>
						<th width="300">Description</th>
						<th>Included Layouts</th>
						<th width="55" class="center {sorter:false}">Actions</th>
					</tr>
				</thead>				
				<tbody>
					<cfloop query="rc.layouts">
					<tr>
						<td>
							<cfif prc.cbSettings.cb_site_layout eq rc.layouts.name>
								<img src="#prc.cbRoot#/includes/images/asterisk_orange.png" alt="active" />
							</cfif>
							<strong>#rc.layouts.layoutName#</strong>
							<br/>	
							Version #rc.layouts.version# by 
							<a href="#rc.layouts.authorURL#" title="#rc.layouts.AuthorURL#" target="_blank">#rc.layouts.Author#</a>
							<br/>
							<!--- Button Bar --->
							<cfif prc.oAuthor.checkPermission("LAYOUT_ADMIN")>
								<button class="button2"   onclick="popup('#event.buildLink(rc.xehPreview)#/l/#rc.layouts.name#/h/#hash(prc.oAuthor.getAuthorID())#');return false;"  title="Preview this layout">Preview</button>
								<button class="buttonred" onclick="return to('#event.buildLink(rc.xehActivate)#?layoutname=#rc.layouts.name#')" title="Activate this layout">Activate</button>
							</cfif>		
						</td>
						<td>
							<cfif len( rc.layouts.screenShotURL )>
								<!--- image --->
								<a href="#rc.layouts.screenShotURL#" target="_blank" title="Open screenshot">
								<img src="#rc.layouts.screenShotURL#"  alt="screenshot" width="300" border="0"/>
								</a>
								<br/>
							</cfif>
							<!--- description --->
							#rc.layouts.description#<br/>
							<div class="contentBar">
								Theme located in <em title="#rc.layoutsPath#/#rc.layouts.name#">contentbox-ui/layouts/#rc.layouts.name#</em>
							</div>
						</td>
						<td>
							<ul>
							<cfloop list="#rc.layouts.layouts#" index="thisLayout">
								<li>#thisLayout#</li>
							</cfloop>
							</ul>
						</td>
						<td class="center">
							<cfif prc.oAuthor.checkPermission("LAYOUT_ADMIN")>
							<!--- Update Check --->
							<a title="Check For Updates" href="##"><img src="#prc.cbRoot#/includes/images/download_black.png" alt="download" /></a>
							&nbsp;
							<!--- Delete Command --->
							<a title="Delete layout" href="javascript:remove('#JSStringFormat(rc.layouts.name)#')" 
							   class="confirmIt" data-title="Delete layout?" data-message="This will permanently remove all layout associated files!"><img src="#prc.cbroot#/includes/images/delete.png" border="0" alt="delete"/></a>
							</cfif>
						</td>
					</tr>
					</cfloop>
				</tbody>
			</table>
			
			#html.endForm()#
		
		</div>	
	</div>
</div>
<!--- Custom JS --->
<script type="text/javascript">
$(document).ready(function() {
	$uploadForm = $("##layoutUploadForm");
	$layoutForm = $("##layoutForm");
	// table sorting + filtering
	$("##layouts").tablesorter();
	$("##layoutFilter").keyup(function(){
		$.uiTableFilter( $("##layouts"), this.value );
	});
	// form validator
	$uploadForm.validator({position:'top left',onSuccess:function(e,els){ activateLoaders(); }});	
});
function activateLoaders(){
	$("##uploadBar").slideToggle();
	$("##uploadBarLoader").slideToggle();
}
function remove(layoutName){
	$layoutForm.find("##layoutName").val( layoutName );
	$layoutForm.submit();
}
</script>
</cfoutput>