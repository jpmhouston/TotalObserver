//
//  TotalObserver.h
//  TotalObserver
//
//  Created by Pierre Houston on 2015-10-15.
//  Copyright (c) 2015 Pierre Houston. All rights reserved.
//

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
