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

- (TOAppGroupObservation *)observeAppGroupNotificationsNamed:(NSString *)name withBlock:(TOObservationBlock)block;
- (TOAppGroupObservation *)observeNotificationsForAppGroup:(NSString *)groupIdentifier named:(NSString *)name withBlock:(TOObservationBlock)block;

- (TOAppGroupObservation *)observeAppGroupNotificationsNamed:(NSString *)name onQueue:(NSOperationQueue *)queue withBlock:(TOObservationBlock)block;
- (TOAppGroupObservation *)observeNotificationsForAppGroup:(NSString *)groupIdentifier named:(NSString *)name onQueue:(NSOperationQueue *)queue withBlock:(TOObservationBlock)block;

- (TOAppGroupObservation *)observeAppGroupNotificationsNamed:(NSString *)name onGCDQueue:(dispatch_queue_t)queue withBlock:(TOObservationBlock)block;
- (TOAppGroupObservation *)observeNotificationsForAppGroup:(NSString *)groupIdentifier named:(NSString *)name onGCDQueue:(dispatch_queue_t)queue withBlock:(TOObservationBlock)block;

- (BOOL)stopObservingAppGroupNotificationsNamed:(NSString *)name;
- (BOOL)stopObservingNotificationsForAppGroup:(NSString *)groupIdentifier named:(NSString *)name;

@end

@interface NSData (TotalObserverAppGroupShorthand)
- (void)postWithinAppGroupNotificationNamed:(NSString *)name;
- (void)postWithinNotificationToAppGroup:(NSString *)groupIdentifier named:(NSString *)name;
@end

@interface NSString (TotalObserverAppGroupShorthand)
- (void)postWithinAppGroupNotificationNamed:(NSString *)name;
- (void)postWithinNotificationToAppGroup:(NSString *)groupIdentifier named:(NSString *)name;
@end

@interface NSArray (TotalObserverAppGroupShorthand)
- (void)postWithinAppGroupNotificationNamed:(NSString *)name;
- (void)postWithinNotificationToAppGroup:(NSString *)groupIdentifier named:(NSString *)name;
@end

@interface NSDictionary (TotalObserverAppGroupShorthand)
- (void)postWithinAppGroupNotificationNamed:(NSString *)name;
- (void)postWithinNotificationToAppGroup:(NSString *)groupIdentifier named:(NSString *)name;
@end

@interface NSDate (TotalObserverAppGroupShorthand)
- (void)postWithinAppGroupNotificationNamed:(NSString *)name;
- (void)postWithinNotificationToAppGroup:(NSString *)groupIdentifier named:(NSString *)name;
@end

@interface NSNumber (TotalObserverAppGroupShorthand)
- (void)postWithinAppGroupNotificationNamed:(NSString *)name;
- (void)postWithinNotificationToAppGroup:(NSString *)groupIdentifier named:(NSString *)name;
@end

#if __has_feature(nullability)
NS_ASSUME_NONNULL_END
#endif

