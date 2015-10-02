<cfoutput>
<!--- Custom Javascript --->
<script type="text/javascript">
$(document).ready(function() {
	// Take height for iframe
    var height = $( "##modal" ).data( 'height' );
    $( "##previewFrame" ).attr( "height", height );
	// load source
	$( "##previewForm" ).submit();

  setModalSize = function(ele,w,h){
    var $frame = $("##previewFrame"),
        orig = {'width':$remoteModal.data('width'),'height': $remoteModal.data('height')},
        fOffset = {'width': $remoteModal.width() - $frame.width(), 'height':$remoteModal.height() - $frame.height()},
        modalSize = {'width': w  + fOffset.width, 'height': h  + fOffset.height},
        frameSize = {'height': h};

      //width is bigger than original size
      if(!w || modalSize.width > orig.width) {
        modalSize = {'width':orig.width, 'height':orig.height};
        frameSize = {'height': orig.height - fOffset.height};
      }
      //Heigh is bigger than original size
      if(modalSize.height > orig.height) {
        modalSize = {'width':w, 'height':orig.height};
        frameSize = {'height': orig.height - fOffset.height};
      }
      //Width & Height Not Defined
      if(!w && !h) {
        modalSize = {'width':orig.width, 'height':orig.height};
        frameSize = {'height': orig.height - fOffset.height};
      }

      //Toggle Quick Preview on Mobile View
      $remoteModal.find(".header-title").toggle(modalSize.width > 500);
      $(ele).siblings('.active').removeClass('active');
      $(ele).addClass('active');

      modalSize['margin-left'] = -modalSize.width/2;
      $frame.css(frameSize);
      $remoteModal.animate(modalSize,500);

  }

});

</script>
</cfoutput>
