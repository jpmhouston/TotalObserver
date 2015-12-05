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

You can do nothing and observation is removed automatically when either your observer or the observed object is deallocated. No need to add any code to `dealloc`! You usually can even skip keeping around the `TOObservation` result.

If you want to explicitly remove an observation, you can keep the result after all and call `remove` on it. But you can also use a `stopObserving` method, which (like `-[NSNotificationCenter removeObserver:name:object:]`) repeating the same parameters as the `observe` call, and the correct observation will be found and removed.

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

When you've provided an observer object, that object is passed back as the first parameter to your block. You can use this to avoid having to make your own weak pointer, especially if you specialize the type of that first parameter in your block definition to the correct type.

```objective-c
[self to_observeForChanges:object toKeyPath:@"name" withBlock:^(ViewController *obj, TOKVOObservation *obs) {
    [obj handleNameChange];
}];
```

The second parameter the block is an observation object, the same as the `observe` method's result. Not ony can you call `remove` on this object, but it has accessors for all observation details, such as the notification object or the change dictionary:

```objective-c
[self to_observeForChanges:object toKeyPath:@"name" withBlock:^(id obj, TOKVOObservation *obs) {
    NSLog(@"%@ %d %@ %@", obs.changeDict, (int)obs.kind, obs.oldValue, obs.changedValue);
}];

[self to_observeForNotifications:object named:@"Cheesecake" withBlock:^(id obj, TONotificationObservation *obs) {
    NSLog(@"%@ %@ %@", obs.notification, obs.postedObject, obs.userInfo);
}];
```

Currently I have another method to observe multiple keypaths at once (a feature `MAKVONotificationCenter` has but I do explicitly instead of with a trick, I might remove it since it adds to the combinatorial nightmare):

```objective-c
[object to_observeChangesToKeyPaths:@[@"name", @"flag"] withBlock:^(TOKVOObservation *obs) {
    if ([obs.keyPath isEqualToString:@"flag"]) // observe many keys at once, easily detect which one fired
    	;
}];
```

TotalObserver can be easily extended to other flavor of observers, I added a wrapper for UIControl event actions. Please add more and submit pull requests!

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
