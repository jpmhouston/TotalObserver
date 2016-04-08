//
//  TotalObserver.h
//  TotalObserver
//
//  Created by Pierre Houston on 2015-12-07.
//  Copyright © 2015 Pierre Houston. All rights reserved.
//

#import <Foundation/Foundation.h>

//! Project version number for TotalObserver.
FOUNDATION_EXPORT double TotalObserverVersionNumber;

//! Project version string for TotalObserver.
FOUNDATION_EXPORT const unsigned char TotalObserverVersionString[];

#import "TOObservation.h"
#import "TOKVOObservation.h"
#import "NSObject+TotalObserverKVO.h"
#import "TONotificationObservation.h"
#import "NSObject+TotalObserverNotifications.h"
#import "TOAppGroupObservation.h"
#import "NSObject+TotalObserverAppGroup.h"
#if TARGET_OS_IPHONE
#import "TOUIControlObservation.h"
#import "NSObject+TotalObserverUIControl.h"
#import "UIControl+TotalObserver.h"
#endif
