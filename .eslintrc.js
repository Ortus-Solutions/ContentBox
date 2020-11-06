module.exports = {
	root: true,

	parserOptions: {
		parser: "babel-eslint",
		sourceType: "module"
	},

	env: {
		"browser": true,
		"es6" : true
	},

	extends: [
		"prettier",
		// Uncomment any of the lines below to choose desired strictness,
		// but leave only one uncommented!
		// See https://eslint.vuejs.org/rules/#available-rules
		// "plugin:vue/essential" // Priority A: Essential (Error Prevention)
		"plugin:vue/strongly-recommended" // Priority B: Strongly Recommended (Improving Readability)
		// "plugin:vue/recommended" // Priority C: Recommended (Minimizing Arbitrary Choices and Cognitive Overhead)
	],

	// required to lint *.vue files
	plugins: [
		"vue"
	],

	globals: {
		"ga": true, // Google Analytics
		"cordova": true,
		"__statics": true,
		"process": true,
		"Capacitor": true,
		"chrome": true
	},

	// add your custom rules here
	rules: {
		"array-bracket-spacing": ["error", "always", {
			"singleValue": true,
			"arraysInArrays": true,
			"objectsInArrays": true
		}],
		"array-bracket-newline" : [ "error", {
			"multiline" : true
		} ],
		"array-element-newline" : [ "error",
			{ "multiline": true, "minItems": 2 }
		],
		"camelcase" : [ "error" , {
			"properties" : "always"
		}],
		"indent": ["error", "tab", {
			ignoredNodes: ["TemplateLiteral"]
		}],
		"keyword-spacing": ["error", { "after": true, "before": true }],
		"key-spacing": ["error", {
			"singleLine": {
				"beforeColon": false,
				"afterColon": true
			},
			"multiLine": {
				"beforeColon": true,
				"afterColon": true,
				"align": "colon"
			}
		}],
		"no-trailing-spaces": ["error", {
			"skipBlankLines": false,
			"ignoreComments": false
		}],
		"no-fallthrough" : "error",
		// allow debugger during development only
		"no-debugger": process.env.NODE_ENV === "production" ? "error" : "off",
		"object-curly-newline" : [ "error", { "multiline" : true } ],
		"object-curly-spacing": ["error", "always", {
			"objectsInObjects": true,
			"arraysInObjects": true
		}],
		"object-property-newline" : [ "error", { "allowAllPropertiesOnSameLine" : true } ],
		"prefer-promise-reject-errors": "off",
		"quotes" : [ "error", "double" ],
		"semi": ["error", "always"],
		"space-in-parens": ["error", "always"],
		"space-before-function-paren": ["error", {
			"anonymous": "never",
			"named": "never",
			"asyncArrow": "never"
		}],
		"vue/html-indent": ["error", "tab"],
		"vue/html-self-closing": [ "error", {
			"html": {
				"void": "any",
				"normal": "always",
				"component": "always"
			}
		} ]
	}
}