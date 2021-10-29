// When the user scrolls down 20px from the top of the document, show the button
var mybutton = null;

window.onscroll = function() { scrollFunction() };

window.onload = function () {
    mybutton = document.getElementById("goToTop");
};

function showSearch(q) {
    document.getElementById( 'q' ).classList.remove( 'hidden' )
    document.getElementById( 'q' ).classList.add( 'show' );
}

function hideSearch(q) {
    document.getElementById( 'q' ).classList.remove( 'show' )
    document.getElementById( 'q' ).classList.add( 'hidden' )
}

function scrollFunction() {
if ( document.body.scrollTop > 20 || document.documentElement.scrollTop > 20 && mybutton != null ) {
    mybutton.classList.remove( "hidden" );
    mybutton.classList.add( "show")
    } else {
        mybutton.classList.remove( "show" );
        mybutton.classList.add( "hidden" );	
    }
}

// When the user clicks on the button, scroll to the top of the document
function topFunction() {
    document.body.scrollTop = 0;
    document.documentElement.scrollTop = 0;
}