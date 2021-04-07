# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

----

## [2.1.0] => 2020-SEP-09

### Added

* Github changelog publishing
* More cfformating goodness
* Changelog standards
* New `csrfField()` to generate a self linking field and JS but forces a new token and adds a block of javascript to the document, synchronized with the `rotateTimeout` setting, that will reload the page if the token expires.

### Fixed

* Null checks on `defaultValue` in case it's passed as an empty string

----

## [2.0.1] => 2020-APR-06

* Deactivate the verifier by default

----

## [2.0.0] => 2020-APR-02

### Features

* Migrated to all new ColdBox 5/6 standards
* Added an auto-verifier interceptor (see readme)
* Added `cbStorages` dependency to allow for distributed caching of tokens
* Ability to auto expire tokens
* Ability to rotate tokens
* Ability to generate input fields
* Ability to verify tokens from headers
* Ability to have an endpoint for csfr generation for authenticated users 
* Automatic listeners for `cbauth` to rotate tokens via login/logout methods

### Compat

* All methods signatures have changed, please see the readme for the updated methods

----

## [1.1.0]

* Travis updates
* Build updates
* DocBox migration

----

## [1.0.1]

* production ignore lists
* Unloading of helpers

----

## [1.0.0]

* Create first module version
