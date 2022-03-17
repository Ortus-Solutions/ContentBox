component {

	/**
	 * Configure the ColdBox Scheduler
	 */
	function configure(){
		/**
		 * --------------------------------------------------------------------------
		 * Configuration Methods
		 * --------------------------------------------------------------------------
		 * From here you can set global configurations for the scheduler
		 * - setTimezone( ) : change the timezone for ALL tasks
		 * - setExecutor( executorObject ) : change the executor if needed
		 */



		/**
		 * --------------------------------------------------------------------------
		 * Register Scheduled Tasks
		 * --------------------------------------------------------------------------
		 * You register tasks with the task() method and get back a ColdBoxScheduledTask object
		 * that you can use to register your tasks configurations.
		 */

		// Deletes all moderated comments that have expired in the inbox
		task( "comment-expirations" )
			.call( function(){
				getInstance( "siteService@contentbox" )
					.getAll()
					.each( function( thisSite ){
						var commentExpirationDays = getInstance( "settingService@contentbox" ).getSiteSetting(
							arguments.thisSite.getSlug(),
							"cb_comments_moderation_expiration"
						);

						if ( commentExpirationDays > 0 ) {
							log.info( "Starting to expire comments on site: #arguments.thisSite.getSlug()#..." );

							// now we have the green light to find and kill any old, moderated comments
							getInstance( "commentService@contentbox" ).deleteUnApproved(
								expirationDays = commentExpirationDays
							);

							log.info(
								"Moderated comments expired for site (#arguments.thisSite.getSlug()#) using (#commentExpirationDays#) days for expiration!"
							);
						} else {
							log.info(
								"Comment expiration not enabled for site (#arguments.thisSite.getSlug()#), skipping."
							);
						}
					} );
			} )
			.everyHour()
			// Don't start it immediately, wait an hour. Especially so tests can pass if enabled in tests.
			.delay( 1, "hours" )
			.onOneServer();
	}

	/**
	 * Called before the scheduler is going to be shutdown
	 */
	function onShutdown(){
	}

	/**
	 * Called after the scheduler has registered all schedules
	 */
	function onStartup(){
		log.info( "√ ContentBox Core Scheduler started successfully!" );
	}

	/**
	 * Called whenever ANY task fails
	 *
	 * @task      The task that got executed
	 * @exception The ColdFusion exception object
	 */
	function onAnyTaskError( required task, required exception ){
		log.error(
			"The task (#arguments.task.getname()#) failed to executed. Caused by: #exception.message & exception.detail#",
			exception.stacktrace
		);
	}

	/**
	 * Called whenever ANY task succeeds
	 *
	 * @task   The task that got executed
	 * @result The result (if any) that the task produced
	 */
	function onAnyTaskSuccess( required task, result ){
		log.info(
			"Task (#arguments.task.getName()#) completed succesfully in #arguments.task.getStats().lastExecutionTime# ms",
			arguments.task.getStats()
		);
	}

	/**
	 * Called before ANY task runs
	 *
	 * @task The task about to be executed
	 */
	function beforeAnyTask( required task ){
		log.info( "Starting to execute task (#arguments.task.getName()#)..." );
	}

	/**
	 * Called after ANY task runs
	 *
	 * @task   The task that got executed
	 * @result The result (if any) that the task produced
	 */
	function afterAnyTask( required task, result ){
	}

}
