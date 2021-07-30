<cfscript>
function getCodeCSS( right, left, index ){
	var codeCSS = "";
	var leftHash = "";
	var rightHash = "";

	// if right is not defined, then it is removed content
	if( !arrayIsDefined( left, index ) AND arrayIsDefined( right, index )){
		codeCSS = " ins";
	}
	// if both defined, then compare
	else if( arrayIsDefined( right, index ) AND arrayIsDefined( left, index ) ){
		leftHash 	= hash( trim( reReplace( left[ index ], "\s", "", "all" ) ) );
		rightHash 	= hash( trim( reReplace( right[ index ], "\s", "", "all" ) ) );
		// do hashes match?
		if( rightHash neq leftHash ){
			codeCSS = " upd";
		}
	}
	// compare removals
	else if( !arrayIsDefined( right, index ) ){
		codeCSS = " del";
	}

	return codeCSS;
}
</cfscript>