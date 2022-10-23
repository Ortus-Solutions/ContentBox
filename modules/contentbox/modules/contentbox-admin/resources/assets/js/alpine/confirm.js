//$confirm
// import bootstrap from "bootstrap";

Alpine.magic('confirm', el => ( message, options ) => {
	return new Promise((resolve, reject) => {
		const modalOptions = {
			id : "modal-confirm",
			className : "modal",
			acceptText : "Accept",
			cancelText : "Cancel"

		};
		if( options ) Object.assign( modalOptions, options );
		const modalElem = document.createElement('div')
		modalElem.id = modalOptions.id
		modalElem.className = modalOptions.className
		modalElem.innerHTML = `
		  <div class="modal-dialog modal-dialog-centered modal-dialog-scrollable">
			<div class="modal-content">
			  <div class="modal-body fs-6">
				<p>${message || 'Are you sure?'}</p>
			  </div>    <!-- modal-body -->
			  <div class="modal-footer" style="border-top:0px">
			    <button id="modal-btn-cancel" type="button" class="btn btn-secondary">${modalOptions.cancelText}</button>
			    <button id="modal-btn-accept" type="button" class="btn btn-primary">${modalOptions.acceptText}</button>
			  </div>
		    </div>
		  </div>
		`;

		$( "body" ).append( modalElem );
		var myModal = $( modalElem ).modal( "show" );

		$( "#modal-btn-cancel,#modal-btn-accept", myModal ).on(
			"click",
			function( e ){
				myModal.modal( "hide" );
				$( modalElem ).remove();
				return (e.target.id == 'modal-btn-accept') ? resolve() : false;
			}
		);
	});
})

