//
//  NSObject+TotalObserverNotificationsShorthand.h
//  TotalObserver
//
//  Created by Pierre Houston on 2016-01-07.
//  Copyright © 2016 Pierre Houston. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TONotificationObservation.h"

#if __has_feature(nullability)
NS_ASSUME_NONNULL_BEGIN
#define TO_nullable nullable
#else
#define TO_nullable
#endif

@interface NSObject (TotalObserverNotificationsShorthand)

- (TONotificationObservation *)observeForNotifications:(id)object named:(NSString *)name withBlock:(TOObjObservationBlock)block;
- (TONotificationObservation *)observeAllNotificationsNamed:(NSString *)name withBlock:(TOObjObservationBlock)block;

- (TONotificationObservation *)observeForNotifications:(id)object named:(NSString *)name onQueue:(NSOperationQueue *)queue withBlock:(TOObjObservationBlock)block;
- (TONotificationObservation *)observeAllNotificationsNamed:(NSString *)name onQueue:(NSOperationQueue *)queue withBlock:(TOObjObservationBlock)block;

- (TONotificationObservation *)observeForNotifications:(id)object named:(NSString *)name onGCDQueue:(dispatch_queue_t)queue withBlock:(TOObjObservationBlock)block;
- (TONotificationObservation *)observeAllNotificationsNamed:(NSString *)name onGCDQueue:(dispatch_queue_t)queue withBlock:(TOObjObservationBlock)block;

- (BOOL)stopObservingForNotifications:(id)object named:(NSString *)name;
- (BOOL)stopObservingAllNotificationsNamed:(NSString *)name;

- (TONotificationObservation *)observeNotificationsNamed:(NSString *)name withBlock:(TOObservationBlock)block;
- (TONotificationObservation *)observeOwnNotificationsNamed:(NSString *)name withBlock:(TOObjObservationBlock)block;

- (TONotificationObservation *)observeNotificationsNamed:(NSString *)name onQueue:(NSOperationQueue *)queue withBlock:(TOObservationBlock)block;
- (TONotificationObservation *)observeOwnNotificationsNamed:(NSString *)name onQueue:(NSOperationQueue *)queue withBlock:(TOObjObservationBlock)block;

- (TONotificationObservation *)observeNotificationsNamed:(NSString *)name onGCDQueue:(dispatch_queue_t)queue withBlock:(TOObservationBlock)block;
- (TONotificationObservation *)observeOwnNotificationsNamed:(NSString *)name onGCDQueue:(dispatch_queue_t)queue withBlock:(TOObjObservationBlock)block;

- (BOOL)stopObservingNotificationsNamed:(NSString *)name;
- (BOOL)stopObservingOwnNotificationsNamed:(NSString *)name;

- (void)postNotificationNamed:(NSString *)aName;
- (void)postNotificationNamed:(NSString *)aName userInfo:(TO_nullable NSDictionary *)aUserInfo;;

@end

#if __has_feature(nullability)
NS_ASSUME_NONNULL_END
#endif
#undef TO_nullable
