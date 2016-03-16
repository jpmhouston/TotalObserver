# Change Log

## [0.6.0](https://github.com/jpmhouston/TotalObserver/tree/0.6.0) (2016-03-16)

- Made app group notification convenience post methods return success or failure
- Filled in some missing headerdoc documentation
- Script to generate shorthand headers (though nothing invokes it automatically yet)
- Shorthand headers now include same headerdoc comments as the base header they're generated from
- Fixed version references in change log (this file)

## [0.5.1](https://github.com/jpmhouston/TotalObserver/tree/0.5.1) (2016-03-15)

- Moved some private declarations to some more new private headers
- Podspec and readme mention app group notifications

## [0.5.0](https://github.com/jpmhouston/TotalObserver/tree/0.5.0) (2016-03-14)

- Added a bunch of headerdoc documentation
- Fixed results from `to_observe` methods weren't marked `nullable`
- Renamed internal typedefs of observation blocks with and without the first `obj` parameter
- Renamed some internal `init` methods

## [0.4.0](https://github.com/jpmhouston/TotalObserver/tree/0.4.0) (2016-03-09)

- Renamed some files and reorganized source file heirarchy
- Added notifications across application groups:
	- based on Darwin notifications and shared directories
	- notifications are posted and subscribed to by name like `NSNotification`
	- each post can carry a payload object (currently anything plist-compatible)

## [0.3.0](https://github.com/jpmhouston/TotalObserver/tree/0.3.0) (2015-12-15)

- Outer project that builds framework for Carthage compatibility

[Full Changelog](https://github.com/jpmhouston/TotalObserver/compare/0.2.1...0.3.0)

## [0.2.1](https://github.com/jpmhouston/TotalObserver/tree/0.2.1) (2015-12-05)

- Fixed TOKVOObservation keyPath & keyPaths properties

[Full Changelog](https://github.com/jpmhouston/TotalObserver/compare/0.2.0...0.2.1)

## [0.2.0](https://github.com/jpmhouston/TotalObserver/tree/0.2.0) (2015-12-02)

- Fixes when observer == observee
- Added methods for more easily observing self
- Added methods for calling observer on a given dispatch queue
- Made UIControl observation objects include sender and event

[Full Changelog](https://github.com/jpmhouston/TotalObserver/compare/0.1.4...0.2.0)

## [0.1.4](https://github.com/jpmhouston/TotalObserver/tree/0.1.4) (2015-11-14)

- SetupShorthand.h now a private header
- Removed Pods from the example project

[Full Changelog](https://github.com/jpmhouston/TotalObserver/compare/0.1.3...0.1.4)

## [0.1.3](https://github.com/jpmhouston/TotalObserver/tree/0.1.3) (2015-11-12)

- Observation objects customize description instead of debugDescription
- Fixed UIControl shorthand methods not being generated
- Added some Swift tests
- Exercize Swift code in the example app
- Moved files from Pod/Classes up to Pod/
- Removed Pods directory

[Full Changelog](https://github.com/jpmhouston/TotalObserver/compare/0.1.2...0.1.3)

## [0.1.2](https://github.com/jpmhouston/TotalObserver/tree/0.1.2) (2015-11-09)

- Improved safety of my "nullable" macro
- Added test case exercizing block's object parameter
- Added optional shorthand methods that omit the "to_" prefix
- Created Shorthand subspec that adds the shorthand headers

[Full Changelog](https://github.com/jpmhouston/TotalObserver/compare/0.1.1...0.1.2)
 
## [0.1.1](https://github.com/jpmhouston/TotalObserver/tree/0.1.1) (2015-11-06)

- Fixed import syntax in some headers files
- Improved podspec summary & description
- Improved readme file

[Full Changelog](https://github.com/jpmhouston/TotalObserver/compare/0.1.0...0.1.1)

## [0.1.0](https://github.com/jpmhouston/TotalObserver/tree/0.1.0) (2015-11-04)

- First release
