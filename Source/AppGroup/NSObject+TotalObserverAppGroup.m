//
//  NSObject+TotalObserverGroup.m
//  TotalObserver
//
//  Created by Pierre Houston on 2016-02-23.
//  Copyright © 2016 Pierre Houston. All rights reserved.
//

#import "NSObject+TotalObserverAppGroup.h"
#import "TOObservation+Private.h"

#if __has_feature(nullability)
NS_ASSUME_NONNULL_BEGIN
#endif

@implementation NSObject (TotalObserverAppGroup)

- (TOAppGroupObservation *)to_observeAppGroupNotificationsNamed:(NSString *)name withBlock:(TOObjObservationBlock)block
{
    return nil;
}

- (TOAppGroupObservation *)to_observeNotificationsForAppGroup:(NSString *)groupIdentifier named:(NSString *)name withBlock:(TOObjObservationBlock)block
{
    return nil;
}

- (TOAppGroupObservation *)to_observeAppGroupNotificationsNamed:(NSString *)name onQueue:(NSOperationQueue *)queue withBlock:(TOObjObservationBlock)block
{
    return nil;
}

- (TOAppGroupObservation *)to_observeNotificationsForAppGroup:(NSString *)groupIdentifier named:(NSString *)name onQueue:(NSOperationQueue *)queue withBlock:(TOObjObservationBlock)block
{
    return nil;
}

- (TOAppGroupObservation *)to_observeAppGroupNotificationsNamed:(NSString *)name onGCDQueue:(dispatch_queue_t)queue withBlock:(TOObjObservationBlock)block
{
    return nil;
}

- (TOAppGroupObservation *)to_observeNotificationsForAppGroup:(NSString *)groupIdentifier named:(NSString *)name onGCDQueue:(dispatch_queue_t)queue withBlock:(TOObjObservationBlock)block
{
    return nil;
}

- (BOOL)to_stopObservingAppGroupNotificationsNamed:(NSString *)name
{
    return YES;
}

- (BOOL)to_stopObservingNotificationsForAppGroup:(NSString *)groupIdentifier named:(NSString *)name
{
    return YES;
}

- (void)to_postWithinAppGroupNotificationNamed:(NSString *)name
{
    
}

- (void)to_postWithinNotificationToAppGroup:(NSString *)groupIdentifier named:(NSString *)name
{
    
}

@end

#if __has_feature(nullability)
NS_ASSUME_NONNULL_END
#endif
