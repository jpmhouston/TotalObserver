# TotalObserver

[![Version](https://img.shields.io/cocoapods/v/TotalObserver.svg?style=flat)](http://cocoapods.org/pods/TotalObserver)
[![License](https://img.shields.io/cocoapods/l/TotalObserver.svg?style=flat)](http://cocoapods.org/pods/TotalObserver)
[![Platform](https://img.shields.io/cocoapods/p/TotalObserver.svg?style=flat)](http://cocoapods.org/pods/TotalObserver)

A simplified Objective-C API for using NSNotifications and KVO with consistent terminology and useful convenience features.

Uses blocks exclusively, but unlike NSNotification's blocks API, allows removal using matching parameters instead of requiring storage of an observation object. Supports automatic removal when either observer or observee is deallocated. Can optionally omit the “to_” prefix on all the category methods.

Extensible to other styles of observers, an included example is a wrapper for UIControl event actions.

TotalObserver's feature set is heavily influenced by [MAKVONotificationCenter](http://github.com/mikeash/MAKVONotificationCenter), and also adapts its rock-solid solution for automatic removal.

Written in Objective-C but tested to verify it's usable from Swift.

Pull requests welcome.

## Usage

Import using either `#import <TotalObserver/TotalObserver.h>` or `@import TotalObserver;`.

There are 2 general styles of observing methods, one where you pass in an observer (often self), and another where you omit the observer for brevity when its unnecessary. In both cases, the final block parameter is called when the observation is triggered.

You can do nothing and observation is removed automatically when either your observer or the observed object is deallocated. No need to add remove code to `dealloc`, no need to keep the `TOObservation` result from the observe method.

If you want to explicitly remove an observation, you can keep the observe method's result after all and call `remove` on it. But you can also use a `stopObserving` class method, which (like `-[NSNotificationCenter removeObserver:name:object:]`) you call with a repeat of that the same parameters as you the passed to `observe`, and the correct observation will be found and removed.

```objective-c
TOObservation *o1 = [self to_observeForChanges:object toKeyPath:@"name" withBlock:^(id obj, TOKVOObservation *obs) {
    NSLog(@"observed change to object's name parameter!");
}];

TOObservation *o2 = [object to_observeChangesToKeyPath:@"flag" withBlock:^(TOKVOObservation *obs) {
    NSLog(@"observed change to object's flag parameter!");
}];

TOObservation *o3 = [self to_observeForNotifications:object named:@"Banana" withBlock:^(id obj, TONotificationObservation *obs) {
    NSLog(@"observed object posting Banana notification");
}];

TOObservation *o4 = [object to_observeNotificationsNamed:@"Seaweed" withBlock:^(TONotificationObservation *obs) {
    NSLog(@"observed object posting Seaweed notification");
}];

...

[self to_stopObservingForChanges:object toKeyPath:@"name"];
[o4 remove];
```

When you've provided an observer object, that object is passed back as the first parameter to your block. You can use this to avoid having to make your own weak self pointer. You specialize the type of that parameter in your block definition to the expected type and avoid unnecessary casting.

```objective-c
[self to_observeForChanges:object toKeyPath:@"name" withBlock:^(ViewController *obj, TOKVOObservation *obs) {
    [obj handleNameChange];
}];
```

The second parameter the block is an observation object, the same as the `observe` method's result. Not ony can you call `remove` on this object, but it has accessors for all observation details, such as the notification object or the change dictionary:

```objective-c
[self to_observeForChanges:object toKeyPath:@"name" withBlock:^(id obj, TOKVOObservation *obs) {
    NSLog(@"%@ %@ %d %@ %@", obs.changeDict, obs.keyPath, (int)obs.kind, obs.oldValue, obs.changedValue);
}];

[self to_observeForNotifications:object named:@"Cheesecake" withBlock:^(id obj, TONotificationObservation *obs) {
    NSLog(@"%@ %@ %@", obs.notification, obs.postedObject, obs.userInfo);
}];
```

There are additional methods which:
- accept KVO option parameters
- observe multiple KVO keypaths at once
- observe a `NSNotification` posted by any object
- observe an object's own KVO changes or notifications
- call the observation block on a specific NSOperationQueue or GCD queue

TotalObserver can be easily extended to other flavor of observations. For example, I've added capability to observe UIControl event actions:

```objective-c
[self to_observeControlForPress:self.button withBlock:^(id obj, TOControlObservation *obs) {
}];
[self.field to_observeEvents:UIControlEventEditingDidBegin withBlock:^(TOControlObservation *obs) {
}];
```

## Installation

TotalObserver is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "TotalObserver"
```

Alternately, you can enable shorthand methods that leave the `to_` prefix off the catgory method names (inspired by MagicalRecord) by instead adding to your Podfile:

```ruby
pod "TotalObserver/Shorthand"
```

and also, somewhere in your app's launching process, such as a `+load` method or your app delegate's `application:didFinishLaunching...` method, add this class method call:

```objective-c
[TOObservation setupShorthandMethods];
```

Read the comments in "TotalObserverShorthand.h" for more details.

#### Running Example

If using `pod try` or manually cloning the source to try out the Example app, first cd into its directory and execute `pod install`, then as directed open `TotalObserver.xcworkspace` and not the `.xcodeproj` file.


## Author

Pierre Houston, jpmhouston@gmail.com

## License

TotalObserver is available under the MIT license. See the LICENSE file for more info.
