component extends="coldbox.system.testing.BaseTestCase"{

	function setup(){
		super.setup();
		update = getMockBox().prepareMock( getInstance("root.ant.patches.1-0-3.Update") );
		permService = getInstance("permissionService@cb");
		roleService = getMockBox().prepareMock( getInstance("roleService@cb") ).$("save");

		update.$property("roleService","variables",roleService);
	}

	function testUpdateEditor(){
		try{
			transaction action="begin"{

				update.updatePermissions();

				r = update.updateEditor();

				assertFalse( r.hasPermission( permService.findWhere({permission="PAGES_ADMIN"}) ) );
				assertFalse( r.hasPermission( permService.findWhere({permission="ENTRIES_ADMIN"}) ) );

				assertTrue( r.hasPermission( permService.findWhere({permission="PAGES_EDITOR"}) ) );
				assertTrue( r.hasPermission( permService.findWhere({permission="ENTRIES_EDITOR"}) ) );

				// clear it
				ormClearSession();
				transaction action="rollback";
			}
		}
		catch(Any e){
			ormClearSession();
			transaction action="rollback"{};
			fail(e);
		}

	}

}