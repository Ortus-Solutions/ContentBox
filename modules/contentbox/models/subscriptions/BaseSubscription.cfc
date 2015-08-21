/**
********************************************************************************
ContentBox - A Modular Content Platform
Copyright 2012 by Luis Majano and Ortus Solutions, Corp
www.ortussolutions.com
********************************************************************************
Apache License, Version 2.0

Copyright Since [2012] [Luis Majano and Ortus Solutions,Corp]

Licensed under the Apache License, Version 2.0 (the "License" );
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
********************************************************************************
* I am an Abstract Subscription Entity
*/
component persistent="true" entityname="cbSubscription" table="cb_subscriptions" cachename="cbSubscription" cacheuse="read-write" {

    // PROPERTIES
    property name="subscriptionID" fieldtype="id" generator="native" setter="false";
    property name="subscriptionToken" notnull="true";
    property name="type" ormtype="string" notnull="true";
    property name="createdDate" notnull="true" ormtype="timestamp" update="false" default="" index="idx_createdDate";

    // M20 -> Content loaded as a proxy
    property name="subscriber" notnull="true" cfc="contentbox.models.subscriptions.Subscriber" fieldtype="many-to-one" fkcolumn="FK_subscriberID" lazy="true" index="idx_subscriber" inverse="true" orderBy="subscriberEmail";
    /************************************** CONSTRUCTOR *********************************************/

    /**
    * constructor
    */
    function init(){
        createdDate = now();
    }
    /************************************** PUBLIC *********************************************/
}