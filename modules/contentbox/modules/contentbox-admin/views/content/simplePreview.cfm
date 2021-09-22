<cfoutput>
<div class="modal-dialog modal-lg" role="document" >

  	<div class="modal-content">

		<div class="modal-header">

			<table width="100">
				<tr>
					<td width="30%">
						<h3>
							<i class="far fa-eye fa-lg"></i>&nbsp;
							<span class="header-title">Responsive Previews</span>
						</h3>
					</td>
					<td width="40%" align="center" nowrap>
						<div class="btn-group">
							<button
								href="javascript:void(0)"
								onclick="setPreviewSize( this ); return false;"
								class="btn btn-primary active"
							>
								<i class="fa fa-2x fa-desktop"></i>
							</button>
							<button
								href="javascript:void(0)"
								onclick="setPreviewSize( this, 768 ); return false;"
								class="btn btn-primary"
							>
								<i class="fa fa-2x fa-tablet"></i>
							</button>
							<button
								href="javascript:void(0)"
								onclick="setPreviewSize( this, 1024 ); return false;"
								class="btn btn-primary"
							>
								<i class="fa fa-2x fa-tablet fa-rotate-90"></i>
							</button>
							<button
								href="javascript:void(0)"
								onclick="setPreviewSize( this, 320 ); return false;"
								class="btn btn-primary"
							>
								<i class="fa fa-2x fa-mobile"></i>
							</button>
							<button
								href="javascript:void(0)"
								onclick="setPreviewSize( this, 568 ); return false;"
								class="btn btn-primary"
							>
								<i class="fa fa-2x fa-mobile fa-rotate-90"></i>
							</button>
						</div>
					</td>
					<td width="30%">
						<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
					</td>
				</tr>
			</table>
		</div>

		<div class="modal-body">
			#prc.preview#
		</div>
	</div>

</div>
</cfoutput>
