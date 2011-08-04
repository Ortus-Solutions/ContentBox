<cfoutput>
<!--============================Sidebar============================-->
<div class="sidebar">
	<!--- Info Box --->
	<div class="small_box">
		<div class="header">
			<img src="#prc.bbroot#/includes/images/settings.png" alt="info" width="24" height="24" />Widget Uploader
		</div>
		<div class="body">
			#html.startForm(name="widgetUploadForm",action=rc.xehWidgetupload,multipart=true,novalidate="novalidate")#
	
				#html.fileField(name="filePlugin",label="Upload Plugin: ", class="textfield",required="required")#		
				
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
			<img src="#prc.bbroot#/includes/images/widgets.png" alt="widgets"/>
			Widgets
		</div>
		<!--- Body --->
		<div class="body">
			
			<!--- MessageBox --->
			#getPlugin("MessageBox").renderit()#
			
			<!--- CategoryForm --->
			#html.startForm(name="widgetForm",action=rc.xehWidgetRemove)#
			#html.hiddenField(name="widgetFile")#
			
			<!--- Content Bar --->
			<div class="contentBar">
				<!--- Filter Bar --->
				<div class="filterBar">
					<div>
						#html.label(field="widgetFilter",content="Quick Filter:",class="inline")#
						#html.textField(name="widgetFilter",size="30",class="textfield")#
					</div>
				</div>
			</div>
			
			<!--- widgets --->
			<table name="widgets" id="widgets" class="tablesorter" width="98%">
				<thead>
					<tr>
						<th>Widget</th>
						<th>Description</th>
						<th width="75" class="center {sorter:false}">Actions</th>
					</tr>
				</thead>				
				<tbody>
					<cfloop query="rc.widgets">
					<cfset p = rc.widgets.plugin>
					<cfif isSimpleValue(p)>
						<tr class="selected">
							<td colspan="4">There is a problem creating widget: '#rc.widgets.name#', please check the application log files.</td>
						</tr>
					<cfelse>
					<tr>
						<td>
							<strong>#p.getPluginName()#</strong>
						</td>
						<td>
							#p.getPluginDescription()#<br/>
							Version #p.getPluginVersion()# | 
							By <a href="#p.getPluginAuthor()#" target="_blank" title="#p.getPluginAuthorURL()#">#p.getPluginAuthor()#</a> |
							Visit ForgeBox URL <a href="#rc.forgeBoxEntryURL & "/" & p.getForgeBoxSlug()#" target="_blank">#p.getForgeBoxSlug()#</a>
						</td>
						<td class="center">
							<!--- Documentation Icon --->
							<a title="Read Widget Documentation" href="javascript:openRemoteModal('#event.buildLink(rc.xehWidgetDocs)#',{widget:'#urlEncodedFormat(rc.widgets.name)#'})"><img src="#prc.bbRoot#/includes/images/docs_icon.png" alt="docs" /></a>
							&nbsp;
							<!--- Update Check --->
							<a title="Check For Updates" href="##"><img src="#prc.bbRoot#/includes/images/download_black.png" alt="download" /></a>
							&nbsp;
							<!--- Delete Command --->
							<a title="Delete Widget" href="javascript:remove('#JSStringFormat(rc.widgets.name)#')" class="confirmIt" data-title="Delete Widget?"><img src="#prc.bbroot#/includes/images/delete.png" border="0" alt="delete"/></a>
						</td>
					</tr>
					</cfif>
					</cfloop>
				</tbody>
			</table>
			
			<!--- help bars --->
			<div class="infoBar">
				<img src="#prc.bbRoot#/includes/images/info.png" alt="info" />Use the BB Helper in your layouts by using:
				 ##bb.widget("name",{arg1=val,arg2=val})##
			</div>
			<div class="infoBar">
				<img src="#prc.bbRoot#/includes/images/info.png" alt="info" />Get a widget in your layouts by using:
				 ##bb.getWidget("name")##
			</div>
			#html.endForm()#
		
		</div>	
	</div>
</div>
<!--- Custom JS --->
<script type="text/javascript">
$(document).ready(function() {
	$uploadForm = $("##widgetUploadForm");
	$widgetForm = $("##widgetForm");
	// table sorting + filtering
	$("##widgets").tablesorter();
	$("##widgetFilter").keyup(function(){
		$.uiTableFilter( $("##widgets"), this.value );
	});
	// form validator
	$uploadForm.validator({position:'top left',onSuccess:function(e,els){ activateLoaders(); }});	
});
function activateLoaders(){
	$("##uploadBar").slideToggle();
	$("##uploadBarLoader").slideToggle();
}
function remove(widgetFile){
	$widgetForm.find("##widgetFile").val( widgetFile );
	$widgetForm.submit();
}
</script>
</cfoutput>