//
//  TotalObserver.h
//  TotalObserver
//
//  Created by Pierre Houston on 2015-12-07.
//  Copyright © 2015 Bananameter Labs. All rights reserved.
//

#import <Foundation/Foundation.h>

//! Project version number for TotalObserver.
FOUNDATION_EXPORT double TotalObserverVersionNumber;

//! Project version string for TotalObserver.
FOUNDATION_EXPORT const unsigned char TotalObserverVersionString[];

#import <TotalObserver/TOObservation.h>
#import <TotalObserver/NSObject+TotalObserver.h>
#if TARGET_OS_IPHONE
#import <TotalObserver/UIControl+TotalObserver.h>
#endif
