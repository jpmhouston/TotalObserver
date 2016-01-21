//
//  NSObject+TotalObserverNotifications.m
//  TotalObserver
//
//  Created by Pierre Houston on 2016-01-07.
//  Copyright © 2016 Pierre Houston. All rights reserved.
//

#import "NSObject+TotalObserverNotifications.h"
#import "TOObservation+Private.h"

#if __has_feature(nullability)
NS_ASSUME_NONNULL_BEGIN
#else
#define nullable
#endif

@implementation NSObject (TotalObserverNotifications)

- (TONotificationObservation *)to_observeForNotifications:(id)object named:(NSString *)name withBlock:(TOObjObservationBlock)block
{
    TONotificationObservation *observation = [[TONotificationObservation alloc] initWithObserver:self object:object name:name onQueue:nil orGCDQueue:nil withObjBlock:block];
    [observation register];
    return observation;
}

- (TONotificationObservation *)to_observeForNotifications:(id)object named:(NSString *)name onQueue:(NSOperationQueue *)queue withBlock:(TOObjObservationBlock)block
{
    TONotificationObservation *observation = [[TONotificationObservation alloc] initWithObserver:self object:object name:name onQueue:queue orGCDQueue:nil withObjBlock:block];
    [observation register];
    return observation;
}

- (TONotificationObservation *)to_observeForNotifications:(id)object named:(NSString *)name onGCDQueue:(dispatch_queue_t)queue withBlock:(TOObjObservationBlock)block
{
    TONotificationObservation *observation = [[TONotificationObservation alloc] initWithObserver:self object:object name:name onQueue:nil orGCDQueue:queue withObjBlock:block];
    [observation register];
    return observation;
}


- (TONotificationObservation *)to_observeAllNotificationsNamed:(NSString *)name withBlock:(TOObjObservationBlock)block
{
    TONotificationObservation *observation = [[TONotificationObservation alloc] initWithObserver:self object:nil name:name onQueue:nil orGCDQueue:nil withObjBlock:block];
    [observation register];
    return observation;
}

- (TONotificationObservation *)to_observeAllNotificationsNamed:(NSString *)name onQueue:(NSOperationQueue *)queue withBlock:(TOObjObservationBlock)block
{
    TONotificationObservation *observation = [[TONotificationObservation alloc] initWithObserver:self object:nil name:name onQueue:queue orGCDQueue:nil withObjBlock:block];
    [observation register];
    return observation;
}

- (TONotificationObservation *)to_observeAllNotificationsNamed:(NSString *)name onGCDQueue:(dispatch_queue_t)queue withBlock:(TOObjObservationBlock)block
{
    TONotificationObservation *observation = [[TONotificationObservation alloc] initWithObserver:self object:nil name:name onQueue:nil orGCDQueue:queue withObjBlock:block];
    [observation register];
    return observation;
}


- (TONotificationObservation *)to_observeOwnNotificationsNamed:(NSString *)name withBlock:(TOObjObservationBlock)block
{
    TONotificationObservation *observation = [[TONotificationObservation alloc] initWithObserver:self object:self name:name onQueue:nil orGCDQueue:nil withObjBlock:block];
    [observation register];
    return observation;
}

- (TONotificationObservation *)to_observeOwnNotificationsNamed:(NSString *)name onQueue:(NSOperationQueue *)queue withBlock:(TOObjObservationBlock)block
{
    TONotificationObservation *observation = [[TONotificationObservation alloc] initWithObserver:self object:self name:name onQueue:queue orGCDQueue:nil withObjBlock:block];
    [observation register];
    return observation;
}

- (TONotificationObservation *)to_observeOwnNotificationsNamed:(NSString *)name onGCDQueue:(dispatch_queue_t)queue withBlock:(TOObjObservationBlock)block
{
    TONotificationObservation *observation = [[TONotificationObservation alloc] initWithObserver:self object:self name:name onQueue:nil orGCDQueue:queue withObjBlock:block];
    [observation register];
    return observation;
}


- (TONotificationObservation *)to_observeNotificationsNamed:(NSString *)name withBlock:(TOObservationBlock)block
{
    TONotificationObservation *observation = [[TONotificationObservation alloc] initWithObserver:nil object:self name:name onQueue:nil orGCDQueue:nil withBlock:block];
    [observation register];
    return observation;
}

- (TONotificationObservation *)to_observeNotificationsNamed:(NSString *)name onQueue:(NSOperationQueue *)queue withBlock:(TOObservationBlock)block
{
    TONotificationObservation *observation = [[TONotificationObservation alloc] initWithObserver:nil object:self name:name onQueue:queue orGCDQueue:nil withBlock:block];
    [observation register];
    return observation;
}

- (TONotificationObservation *)to_observeNotificationsNamed:(NSString *)name onGCDQueue:(dispatch_queue_t)queue withBlock:(TOObservationBlock)block
{
    TONotificationObservation *observation = [[TONotificationObservation alloc] initWithObserver:nil object:self name:name onQueue:nil orGCDQueue:queue withBlock:block];
    [observation register];
    return observation;
}


- (BOOL)to_stopObservingForNotifications:(id)object named:(NSString *)name
{
    return [TONotificationObservation removeForObserver:self object:object name:name];
}

- (BOOL)to_stopObservingAllNotificationsNamed:(NSString *)name
{
    return [TONotificationObservation removeForObserver:self object:nil name:name];
}

- (BOOL)to_stopObservingOwnNotificationsNamed:(NSString *)name
{
    return [TONotificationObservation removeForObserver:self object:self name:name];
}

- (BOOL)to_stopObservingNotificationsNamed:(NSString *)name
{
    return [TONotificationObservation removeForObserver:nil object:self name:name];
}


- (void)to_postNotificationNamed:(NSString *)name
{
    [[NSNotificationCenter defaultCenter] postNotificationName:name object:self userInfo:nil];
}

- (void)to_postNotificationNamed:(NSString *)name userInfo:(nullable NSDictionary *)userInfo
{
    [[NSNotificationCenter defaultCenter] postNotificationName:name object:self userInfo:userInfo];
}

@end

#if __has_feature(nullability)
NS_ASSUME_NONNULL_END
#else
#undef nullable
#endif
