component accessors="true"{

	/**
	* Take some nasty HQL array reports to nicer array of struct reports
	* @hqlData The nasty HQL query report
	* @columnNames The name of the columns (array) to inflate the structure of columns into, make sure they match the report or KABOOM!
	*/
	array function arrayReportToStruct(required array hqlData,required array columnNames){
		var newData = [];
		// iterate rows
		for(row in arguments.hqlData){
			// get columns
			var cols = arrayLen( row );
			var newRow = {};
			for(var x=1; x LTE cols; x++){
				newRow[ arguments.columnNames[x] ] = row[x];
			}
			arrayAppend( newData, newRow );
		}
		return newData;
	}			
			
} 