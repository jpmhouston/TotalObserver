//
//  TotalObserverShorthand.h
//  TotalObserver
//
//  Created by Pierre Houston on 2015-11-04.
//  Copyright (c) 2015 Pierre Houston. All rights reserved.
//
//  To use shorthand method names that omit the "to_" prefix:
//  - in your podfile use: pod 'TotalObserver/Shorthand' instead of just pod 'TotalObserver'
//  - either: use module import directive as normal: @import TotalObserver;
//    or: import <TotalObserver/TotalObserverShorthand.h> instead of the normal umbrealla header
//  - then call [TOObservation setupShorthandMethods] somewhere, such as your app delegate's
//    application:didFinishLaunching..
//    or: **if you can setup your project to access this pod's private headers** then in
//    at least one .m file, instead include <TotalObserver/ShorthandAutosetup.h>
//

#import <TotalObserver/TOObservation.h>
#import <TotalObserver/TOObservation+Shorthand.h>
#import <TotalObserver/TOKVOObservation.h>
#import <TotalObserver/NSObject+TotalObserverKVO.h>
#import <TotalObserver/NSObject+TotalObserverKVOShorthand.h>
#import <TotalObserver/TONotificationObservation.h>
#import <TotalObserver/NSObject+TotalObserverNotifications.h>
#import <TotalObserver/NSObject+TotalObserverNotificationsShorthand.h>
#import <TotalObserver/TOAppGroupObservation.h>
#import <TotalObserver/NSObject+TotalObserverAppGroup.h>
#import <TotalObserver/NSObject+TotalObserverAppGroupShorthand.h>
#if TARGET_OS_IPHONE
#import <TotalObserver/TOUIControlObservation.h>
#import <TotalObserver/NSObject+TotalObserverUIControl.h>
#import <TotalObserver/NSObject+TotalObserverUIControlShorthand.h>
#import <TotalObserver/UIControl+TotalObserver.h>
#import <TotalObserver/UIControl+TotalObserverShorthand.h>
#endif

#define TO_IMPORTED_SHORTHAND_UMBRELLA_HEADER 1
