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
//
//  instead of the last step, wanted to be able to this, however SetupShorthand.h etc isn't
//  working yet:
//  - in at least one .m file, also include <TotalObserver/SetupShorthand.h>
//    (if used module import syntax then its important to use #include and not #import)
//

#import <TotalObserver/TOObservation.h>
#import <TotalObserver/TOObservation+Shorthand.h>
#import <TotalObserver/NSObject+TotalObserver.h>
#import <TotalObserver/NSObject+TotalObserverShorthand.h>
#if TARGET_OS_IPHONE
#import <TotalObserver/UIControl+TotalObserver.h>
#import <TotalObserver/UIControl+TotalObserverShorthand.h>
#endif
