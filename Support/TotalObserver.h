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

#import <TotalObserver/TOObservation.h>
#import <TotalObserver/TOKVOObservation.h>
#import <TotalObserver/NSObject+TotalObserverKVO.h>
#import <TotalObserver/TONotificationObservation.h>
#import <TotalObserver/NSObject+TotalObserverNotifications.h>
#import <TotalObserver/TOAppGroupObservation.h>
#import <TotalObserver/TOAppGroupNotificationManager.h>
#import <TotalObserver/NSObject+TotalObserverAppGroup.h>
#if TARGET_OS_IPHONE
#import <TotalObserver/TOUIControlObservation.h>
#import <TotalObserver/NSObject+TotalObserverUIControl.h>
#import <TotalObserver/UIControl+TotalObserver.h>
#endif
