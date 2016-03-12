//
//  NSObject+TotalObserverNotifications.h
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

@interface NSObject (TotalObserverNotifications)

// receiver is observer, object parameter is observee, automatically removed at time of observer's dealloc
- (TONotificationObservation *)to_observeForNotifications:(id)object named:(NSString *)name withBlock:(TOObservationBlock)block;
- (TONotificationObservation *)to_observeAllNotificationsNamed:(NSString *)name withBlock:(TOObservationBlock)block;

// same but with operation queue parameter
- (TONotificationObservation *)to_observeForNotifications:(id)object named:(NSString *)name onQueue:(NSOperationQueue *)queue withBlock:(TOObservationBlock)block;
- (TONotificationObservation *)to_observeAllNotificationsNamed:(NSString *)name onQueue:(NSOperationQueue *)queue withBlock:(TOObservationBlock)block;

// same but with dispatch queue parameter
- (TONotificationObservation *)to_observeForNotifications:(id)object named:(NSString *)name onGCDQueue:(dispatch_queue_t)queue withBlock:(TOObservationBlock)block;
- (TONotificationObservation *)to_observeAllNotificationsNamed:(NSString *)name onGCDQueue:(dispatch_queue_t)queue withBlock:(TOObservationBlock)block;

- (BOOL)to_stopObservingForNotifications:(id)object named:(NSString *)name;
- (BOOL)to_stopObservingAllNotificationsNamed:(NSString *)name;

// receiver is observee, no observer, automatically removed at time of receiver's dealloc
- (TONotificationObservation *)to_observeNotificationsNamed:(NSString *)name withBlock:(TOAnonymousObservationBlock)block;
- (TONotificationObservation *)to_observeOwnNotificationsNamed:(NSString *)name withBlock:(TOObservationBlock)block;

// same but with operation queue parameter
- (TONotificationObservation *)to_observeNotificationsNamed:(NSString *)name onQueue:(NSOperationQueue *)queue withBlock:(TOAnonymousObservationBlock)block;
- (TONotificationObservation *)to_observeOwnNotificationsNamed:(NSString *)name onQueue:(NSOperationQueue *)queue withBlock:(TOObservationBlock)block;

// same but with dispatch queue parameter
- (TONotificationObservation *)to_observeNotificationsNamed:(NSString *)name onGCDQueue:(dispatch_queue_t)queue withBlock:(TOAnonymousObservationBlock)block;
- (TONotificationObservation *)to_observeOwnNotificationsNamed:(NSString *)name onGCDQueue:(dispatch_queue_t)queue withBlock:(TOObservationBlock)block;

- (BOOL)to_stopObservingNotificationsNamed:(NSString *)name;
- (BOOL)to_stopObservingOwnNotificationsNamed:(NSString *)name;

// convenience posting methods, receiver is used as the object
- (void)to_postNotificationNamed:(NSString *)name;
- (void)to_postNotificationNamed:(NSString *)name userInfo:(TO_nullable NSDictionary *)userInfo;

@end

#if __has_feature(nullability)
NS_ASSUME_NONNULL_END
#endif
#undef TO_nullable
