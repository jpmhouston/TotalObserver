//
//  NSObject+TotalObserverAppGroupShorthand.h
//  TotalObserver
//
//  Created by Pierre Houston on 2016-01-07.
//  Copyright © 2016 Pierre Houston. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TOAppGroupObservation.h"

#if __has_feature(nullability)
NS_ASSUME_NONNULL_BEGIN
#endif

@interface NSObject (TotalObserverAppGroupShorthand)

- (TOAppGroupObservation *)observeAppGroupNotificationsNamed:(NSString *)name withBlock:(TOObjObservationBlock)block;
- (TOAppGroupObservation *)observeNotificationsForAppGroup:(NSString *)groupIdentifier named:(NSString *)name withBlock:(TOObjObservationBlock)block;

- (TOAppGroupObservation *)observeAppGroupNotificationsNamed:(NSString *)name onQueue:(NSOperationQueue *)queue withBlock:(TOObjObservationBlock)block;
- (TOAppGroupObservation *)observeNotificationsForAppGroup:(NSString *)groupIdentifier named:(NSString *)name onQueue:(NSOperationQueue *)queue withBlock:(TOObjObservationBlock)block;

- (TOAppGroupObservation *)observeAppGroupNotificationsNamed:(NSString *)name onGCDQueue:(dispatch_queue_t)queue withBlock:(TOObjObservationBlock)block;
- (TOAppGroupObservation *)observeNotificationsForAppGroup:(NSString *)groupIdentifier named:(NSString *)name onGCDQueue:(dispatch_queue_t)queue withBlock:(TOObjObservationBlock)block;

- (BOOL)stopObservingAppGroupNotificationsNamed:(NSString *)name;
- (BOOL)stopObservingNotificationsForAppGroup:(NSString *)groupIdentifier named:(NSString *)name;

- (void)postWithinAppGroupNotificationNamed:(NSString *)name;
- (void)postWithinNotificationToAppGroup:(NSString *)groupIdentifier named:(NSString *)name;

@end

#if __has_feature(nullability)
NS_ASSUME_NONNULL_END
#endif

