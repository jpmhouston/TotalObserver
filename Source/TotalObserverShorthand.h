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

#import "TOObservation.h"
#import "TOObservation+Shorthand.h"
#import "TOKVOObservation.h"
#import "NSObject+TotalObserverKVO.h"
#import "NSObject+TotalObserverKVOShorthand.h"
#import "TONotificationObservation.h"
#import "NSObject+TotalObserverNotifications.h"
#import "NSObject+TotalObserverNotificationsShorthand.h"
#import "TOAppGroupObservation.h"
#import "NSObject+TotalObserverAppGroup.h"
#import "NSObject+TotalObserverAppGroupShorthand.h"
#if TARGET_OS_IPHONE
#import "TOUIControlObservation.h"
#import "NSObject+TotalObserverUIControl.h"
#import "NSObject+TotalObserverUIControlShorthand.h"
#import "UIControl+TotalObserver.h"
#import "UIControl+TotalObserverShorthand.h"
#endif

#define TO_IMPORTED_SHORTHAND_UMBRELLA_HEADER 1
