<cfoutput>
<!--============================Sidebar============================-->
<div class="sidebar">
	<!--- Info Box --->
	<div class="small_box">
		<div class="header">
			<img src="#prc.bbroot#/includes/images/settings.png" alt="info" width="24" height="24" />Layout Uploader
		</div>
		<div class="body">
			#html.startForm(name="layoutUploadForm",action=rc.xehlayoutupload,multipart=true,novalidate="novalidate")#
	
				#html.fileField(name="fileLayout",label="Upload Layout (.zip): ", class="textfield",required="required")#		
				
				<div class="actionBar" id="uploadBar">
					#html.submitButton(value="Upload & Install",class="buttonred")#
				</div>
				
				<!--- Loader --->
				<div class="loaders" id="uploadBarLoader">
					<img src="#prc.bbRoot#/includes/images/ajax-loader-blue.gif" alt="loader"/>
				</div>
			#html.endForm()#
		</div>
	</div>		
</div>
<!--End sidebar-->	
<!--============================Main Column============================-->
<div class="main_column">
	<div class="box">
		<!--- Body Header --->
		<div class="header">
			<img src="#prc.bbroot#/includes/images/layouts.png" alt="layouts"/>
			Layouts
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
				<div class="buttonBar">
					<button class="button2" onclick="return to('#event.buildLink(rc.xehFlushRegistry)#')" title="Rescan layouts directory and rebuild registry">Rebuild Registry</button>
				</div>
				<!--- Filter Bar --->
				<div class="filterBar">
					<div>
						#html.label(field="layoutFilter",content="Quick Filter:",class="inline")#
						#html.textField(name="layoutFilter",size="30",class="textfield")#
					</div>
				</div>
			</div>
			
			<img src="#prc.bbRoot#/includes/images/asterisk_orange.png" alt="active" title="Currently Active Layout"/>
			<strong>Currently Active Layout</strong>
			
			<!--- layouts --->
			<table name="layouts" id="layouts" class="tablesorter" width="98%">
				<thead>
					<tr>
						<th width="300">Layout</th>
						<th>Info</th>
						<th width="75" class="center {sorter:false}">Actions</th>
					</tr>
				</thead>				
				<tbody>
					<cfloop query="rc.layouts">
					<tr <cfif prc.bbSettings.bb_site_layout eq rc.layouts.name>class="selected"</cfif>>
						<td>
							<cfif prc.bbSettings.bb_site_layout eq rc.layouts.name>
								<img src="#prc.bbRoot#/includes/images/asterisk_orange.png" alt="active" />
							</cfif>
							<strong>#rc.layouts.layoutName#</strong>
							<br/>	
							Version #rc.layouts.version# by 
							<a href="#rc.layouts.authorURL#" title="#rc.layouts.AuthorURL#" target="_blank">#rc.layouts.Author#</a>
							<cfif len(rc.layouts.forgeBoxSlug)>
							<br/>
							ForgeBox URL: <a href="#rc.forgeBoxEntryURL & "/"#" target="_blank">#rc.layouts.forgeBoxSlug#</a>
							</cfif>		
							<br/>
							<!--- Button Bar --->
							<button class="button2"   onclick="openRemoteModal('#event.buildLink(rc.xehPreview)#')"  title="Preview this layout">Preview</button>
							<button class="buttonred" onclick="return to('#event.buildLink(rc.xehActivate)#?layoutname=#rc.layouts.name#')" title="Activate this layout">Activate</button>		
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
							Layout located in <em title="#rc.layoutsPath#/#rc.layouts.name#">blogbox-ui/layouts/#rc.layouts.name#</em>
						</td>
						<td class="center">
							<!--- Update Check --->
							<a title="Check For Updates" href="##"><img src="#prc.bbRoot#/includes/images/download_black.png" alt="download" /></a>
							&nbsp;
							<!--- Delete Command --->
							<a title="Delete layout" href="javascript:remove('#JSStringFormat(rc.layouts.name)#')" 
							   class="confirmIt" data-title="Delete layout?" data-message="This will permanently remove all layout associated files!"><img src="#prc.bbroot#/includes/images/delete.png" border="0" alt="delete"/></a>
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