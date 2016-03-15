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

- (TO_nullable TONotificationObservation *)observeForNotifications:(id)object named:(NSString *)name withBlock:(TOObservationBlock)block;
- (TO_nullable TONotificationObservation *)observeForNotifications:(id)object named:(NSString *)name onQueue:(NSOperationQueue *)queue withBlock:(TOObservationBlock)block;
- (TO_nullable TONotificationObservation *)observeForNotifications:(id)object named:(NSString *)name onGCDQueue:(dispatch_queue_t)queue withBlock:(TOObservationBlock)block;

- (BOOL)stopObservingForNotifications:(id)object named:(NSString *)name;

- (TO_nullable TONotificationObservation *)observeAllNotificationsNamed:(NSString *)name withBlock:(TOObservationBlock)block;
- (TO_nullable TONotificationObservation *)observeAllNotificationsNamed:(NSString *)name onQueue:(NSOperationQueue *)queue withBlock:(TOObservationBlock)block;
- (TO_nullable TONotificationObservation *)observeAllNotificationsNamed:(NSString *)name onGCDQueue:(dispatch_queue_t)queue withBlock:(TOObservationBlock)block;

- (BOOL)stopObservingAllNotificationsNamed:(NSString *)name;

- (TO_nullable TONotificationObservation *)observeNotificationsNamed:(NSString *)name withBlock:(TOAnonymousObservationBlock)block;
- (TO_nullable TONotificationObservation *)observeNotificationsNamed:(NSString *)name onQueue:(NSOperationQueue *)queue withBlock:(TOAnonymousObservationBlock)block;
- (TO_nullable TONotificationObservation *)observeNotificationsNamed:(NSString *)name onGCDQueue:(dispatch_queue_t)queue withBlock:(TOAnonymousObservationBlock)block;

- (BOOL)stopObservingNotificationsNamed:(NSString *)name;

- (TO_nullable TONotificationObservation *)observeOwnNotificationsNamed:(NSString *)name withBlock:(TOObservationBlock)block;
- (TO_nullable TONotificationObservation *)observeOwnNotificationsNamed:(NSString *)name onQueue:(NSOperationQueue *)queue withBlock:(TOObservationBlock)block;
- (TO_nullable TONotificationObservation *)observeOwnNotificationsNamed:(NSString *)name onGCDQueue:(dispatch_queue_t)queue withBlock:(TOObservationBlock)block;

- (BOOL)stopObservingOwnNotificationsNamed:(NSString *)name;

- (void)postNotificationNamed:(NSString *)aName;
- (void)postNotificationNamed:(NSString *)aName userInfo:(TO_nullable NSDictionary *)aUserInfo;;

@end

#if __has_feature(nullability)
NS_ASSUME_NONNULL_END
#endif
#undef TO_nullable
