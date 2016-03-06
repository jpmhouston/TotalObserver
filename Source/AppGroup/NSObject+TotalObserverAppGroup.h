//
//  NSObject+TotalObserverAppGroup.h
//  TotalObserver
//
//  Created by Pierre Houston on 2016-02-23.
//  Copyright © 2016 Pierre Houston. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TOAppGroupObservation.h"

#if __has_feature(nullability)
NS_ASSUME_NONNULL_BEGIN
#endif

@interface NSObject (TotalObserverAppGroup)

// when methods with no identifier used, the last identifier registered using
// +[TOAppGroupObservation registerAppGroup:] is used

// observe methods will return nil if app not setup as a member of the app group

// receiver is observer (not optional/nullable) automatically removed at time of dealloc
- (TOAppGroupObservation *)to_observeAppGroupNotificationsNamed:(NSString *)name withBlock:(TOObjObservationBlock)block;
- (TOAppGroupObservation *)to_observeNotificationsForAppGroup:(NSString *)groupIdentifier named:(NSString *)name withBlock:(TOObjObservationBlock)block;

// same but with operation queue parameter
- (TOAppGroupObservation *)to_observeAppGroupNotificationsNamed:(NSString *)name onQueue:(NSOperationQueue *)queue withBlock:(TOObjObservationBlock)block;
- (TOAppGroupObservation *)to_observeNotificationsForAppGroup:(NSString *)groupIdentifier named:(NSString *)name onQueue:(NSOperationQueue *)queue withBlock:(TOObjObservationBlock)block;

// same but with dispatch queue parameter
- (TOAppGroupObservation *)to_observeAppGroupNotificationsNamed:(NSString *)name onGCDQueue:(dispatch_queue_t)queue withBlock:(TOObjObservationBlock)block;
- (TOAppGroupObservation *)to_observeNotificationsForAppGroup:(NSString *)groupIdentifier named:(NSString *)name onGCDQueue:(dispatch_queue_t)queue withBlock:(TOObjObservationBlock)block;

- (BOOL)to_stopObservingAppGroupNotificationsNamed:(NSString *)name;
- (BOOL)to_stopObservingNotificationsForAppGroup:(NSString *)groupIdentifier named:(NSString *)name;

// convenience posting methods, receiver is used as the payload
- (void)to_postWithinAppGroupNotificationNamed:(NSString *)name;
- (void)to_postWithinNotificationToAppGroup:(NSString *)groupIdentifier named:(NSString *)name;

@end

#if __has_feature(nullability)
NS_ASSUME_NONNULL_END
#endif
