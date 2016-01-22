<cfoutput>
<div class="modal-header">
  <table style="width:100%">
    <tr>
      <td width="30%">
        <h3 style="margin: 9px 0;"><i class="fa fa-eye fa-lg"></i>&nbsp; <span class="header-title">Responsive Previews</span></h3>
      </td>
      <td width="40%" align="center" nowrap>
        <div class="btn-group" style="width:250px">
          <button href="javascript:void( 0 )" onclick="setPreviewSize( this); return false;" class="btn btn-primary active"><i class="fa fa-2x fa-desktop"></i></button>
          <button href="javascript:void( 0 )" onclick="setPreviewSize( this, 768 ); return false;" class="btn btn-primary"><i class="fa fa-2x fa-tablet"></i></button>
          <button href="javascript:void( 0 )" onclick="setPreviewSize( this, 1024 ); return false;" class="btn btn-primary"><i class="fa fa-2x fa-tablet fa-rotate-90"></i></button>
          <button href="javascript:void( 0 )" onclick="setPreviewSize( this, 320 ); return false;" class="btn btn-primary"><i class="fa fa-2x fa-mobile"></i></button>
          <button href="javascript:void( 0 )" onclick="setPreviewSize( this, 568 ); return false;" class="btn btn-primary"><i class="fa fa-2x fa-mobile fa-rotate-90"></i></button>
        </div>
      </td>
      <td width="30%">
          <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
      </td>
    </tr>
  </table>
</div>
<div class="modal-body">
	<!---hidden form for preview submit, has to be a form as content can be quite large
		so get operations do not work.
	 --->
	#html.startForm( name="previewForm", action=prc.xehPreview, target="previewFrame", class="hidden" )#
		#html.hiddenField( name="h", value=prc.h )#
		#html.hiddenField( name="content", value=urlEncodedFormat( rc.content ) )#
		#html.hiddenField( name="contentType", value=rc.contentType )#
		#html.hiddenField( name="layout", value=rc.layout )#
		#html.hiddenField( name="title", value=rc.title )#
		#html.hiddenField( name="slug", value=rc.slug )#
		#html.hiddenField( name="markup", value=rc.markup )#
		#html.hiddenField( name="parentPage", value=rc.parentPage )#
	#html.endForm()#
	<!--- hidden iframe for preview --->
	<iframe id="previewFrame" name="previewFrame" width="100%" scrolling="auto" style="border: 1px solid ##eaeaea"></iframe>
</div>
</cfoutput>