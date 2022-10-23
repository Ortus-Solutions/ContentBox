import tippy from "tippy.js";
// Magic: $tooltip
Alpine.magic( 'tooltip', el => message => {
	let instance = tippy(el, { content: message, trigger: 'manual' })

	instance.show()

	setTimeout(() => {
		instance.hide()

		setTimeout(() => instance.destroy(), 150)
	}, 2000)
})

// Directive: x-tooltip
Alpine.directive('tooltip', (el, { expression }, { evaluate }) => {
	// Attempt to evaluate any javascript
	var evaluated;
	if( /[~`#$%\^&*+=\-\[\]\\';/{}|\\":<>\?]/g.test( expression ) ){
		evaluated = evaluate( expression );
	}
	if( evaluated ){
		expression = evaluated;
	}
	tippy(el, { content: expression })
})