this.datasources[ "contentbox" ] = {
	class: 'org.hsqldb.jdbcDriver',
	bundleName: 'org.hsqldb.hsqldb',
	bundleVersion: '2.4.0',
	connectionString: 'jdbc:hsqldb:file:contentboxDB/contentbox',
	blob: true,
	clob: true,
	storage: true
};
this.datasource = "contentbox";