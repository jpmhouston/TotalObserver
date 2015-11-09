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
//  - also either: in at least one .m file, import <TotalObserver/SetupShorthand.h> (**-see below)
//    or: call [TOObservation setupShorthandMethods] somewhere, such as application:didFinishLaunching
//
//  ** SetupShorthand.h HEADER NOT WORKING YET BECAUSE I HAVEN'T FIGURED OUT HOW TO INCLUDE IT
//     IN THE MODULE MAP BUT NOT IN THE MODULAR UMBRELLA HEADER

#import <TotalObserver/TOObservation.h>
#import <TotalObserver/TOObservation+Shorthand.h>
#import <TotalObserver/NSObject+TotalObserver.h>
#import <TotalObserver/NSObject+TotalObserverShorthand.h>
#if TARGET_OS_IPHONE
#import <TotalObserver/UIControl+TotalObserver.h>
#import <TotalObserver/UIControl+TotalObserverShorthand.h>
#endif
