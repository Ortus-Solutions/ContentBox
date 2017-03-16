<cfscript>
	function getCodeCSS(right, left, index){
		var codeCSS = "";
		var leftHash = "";
		var rightHash = "";
		
		// if right is not defined, then it is removed content
		if( !arrayIsDefined( left, index ) AND arrayIsDefined( right, index )){
			codeCSS = " ins";
		}
		// if both defined, then compare
		else if( arrayIsDefined( right, index ) AND arrayIsDefined( left, index ) ){
			leftHash 	= hash( trim(left[ index ]) );
			rightHash 	= hash( trim(right[ index ]) );
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