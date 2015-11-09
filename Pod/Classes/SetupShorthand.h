//
//  SetupShorthand.h
//  TotalObserver
//
//  Created by Pierre Houston on 2015-11-04.
//  Copyright (c) 2015 Pierre Houston. All rights reserved.
//
//  To use shorthand method names that omit the "to_" prefix without adding any lines of code
//  (other than imports statements):
//  - in your podfile use: pod 'TotalObserver/Shorthand' instead of just pod 'TotalObserver'
//  - either: use module import directive as normal: @import TotalObserver;
//    or: import <TotalObserver/TotalObserverShorthand.h> instead of the normal umbrealla header
//  - also, in at least one .m file, import <TotalObserver/SetupShorthand.h>
//
//  NOT WORKING YET BECAUSE I HAVEN'T FIGURED OUT HOW TO INCLUDE THIS IN THE MODULE MAP
//  BUT NOT IN THE MODULAR UMBRELLA HEADER

#define TO_CATENATE(x, y) x ## y
#define TO_AUTOSETUP_CLASS TO_CATENATE(TOObservationAutosetup_, __COUNTER__)
@interface TO_AUTOSETUP_CLASS : NSObject
@end
@implementation TO_AUTOSETUP_CLASS
+ (void)load { if (self == [TO_AUTOSETUP_CLASS class]) [TOObservation setupShorthandMethods]; }
@end
