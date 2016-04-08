//
//  NSObject+TotalObserverGroup.m
//  TotalObserver
//
//  Created by Pierre Houston on 2016-02-23.
//  Copyright © 2016 Pierre Houston. All rights reserved.
//

#import "NSObject+TotalObserverAppGroup.h"
#import "TOAppGroupObservation+Private.h"
#import "TOObservation+Private.h"

#if __has_feature(nullability)
NS_ASSUME_NONNULL_BEGIN
#else
#define nullable
#endif

@implementation NSObject (TotalObserverAppGroup)

- (nullable TOAppGroupObservation *)to_observeAppGroupNotificationsNamed:(NSString *)name withBlock:(TOObservationBlock)block
{
    TOAppGroupObservation *observation = [[TOAppGroupObservation alloc] initWithObserver:self groupIdentifier:nil name:name queue:nil gcdQueue:nil block:block];
    [observation register];
    return observation;
}

- (nullable TOAppGroupObservation *)to_observeNotificationsForAppGroup:(NSString *)groupIdentifier named:(NSString *)name withBlock:(TOObservationBlock)block
{
    TOAppGroupObservation *observation = [[TOAppGroupObservation alloc] initWithObserver:self groupIdentifier:groupIdentifier name:name queue:nil gcdQueue:nil block:block];
    [observation register];
    return observation;
}

- (nullable TOAppGroupObservation *)to_observeAppGroupNotificationsNamed:(NSString *)name onQueue:(NSOperationQueue *)queue withBlock:(TOObservationBlock)block
{
    TOAppGroupObservation *observation = [[TOAppGroupObservation alloc] initWithObserver:self groupIdentifier:nil name:name queue:queue gcdQueue:nil block:block];
    [observation register];
    return observation;
}


- (nullable TOAppGroupObservation *)to_observeNotificationsForAppGroup:(NSString *)groupIdentifier named:(NSString *)name onQueue:(NSOperationQueue *)queue withBlock:(TOObservationBlock)block
{
    TOAppGroupObservation *observation = [[TOAppGroupObservation alloc] initWithObserver:self groupIdentifier:groupIdentifier name:name queue:queue gcdQueue:nil block:block];
    [observation register];
    return observation;
}

- (nullable TOAppGroupObservation *)to_observeAppGroupNotificationsNamed:(NSString *)name onGCDQueue:(dispatch_queue_t)queue withBlock:(TOObservationBlock)block
{
    TOAppGroupObservation *observation = [[TOAppGroupObservation alloc] initWithObserver:self groupIdentifier:nil name:name queue:nil gcdQueue:queue block:block];
    [observation register];
    return observation;
}

- (nullable TOAppGroupObservation *)to_observeNotificationsForAppGroup:(NSString *)groupIdentifier named:(NSString *)name onGCDQueue:(dispatch_queue_t)queue withBlock:(TOObservationBlock)block
{
    TOAppGroupObservation *observation = [[TOAppGroupObservation alloc] initWithObserver:self groupIdentifier:groupIdentifier name:name queue:nil gcdQueue:queue block:block];
    [observation register];
    return observation;
}


- (BOOL)to_stopObservingAppGroupNotificationsNamed:(NSString *)name
{
    return [TOAppGroupObservation removeForObserver:self groupIdentifier:nil name:name retainingState:NO];
}

- (BOOL)to_stopObservingNotificationsForAppGroup:(NSString *)groupIdentifier named:(NSString *)name
{
    return [TOAppGroupObservation removeForObserver:self groupIdentifier:groupIdentifier name:name retainingState:NO];
}


- (nullable TOAppGroupObservation *)to_observeReliablyAppGroupNotificationsNamed:(NSString *)name withBlock:(TOCollatedObservationBlock)block
{
    TOAppGroupObservation *observation = [[TOAppGroupObservation alloc] initForReliableDeliveryWithObserver:self groupIdentifier:nil name:name queue:nil gcdQueue:nil block:block];
    [observation register];
    return observation;
}

- (nullable TOAppGroupObservation *)to_observeReliablyNotificationsForAppGroup:(NSString *)groupIdentifier named:(NSString *)name withBlock:(TOCollatedObservationBlock)block
{
    TOAppGroupObservation *observation = [[TOAppGroupObservation alloc] initForReliableDeliveryWithObserver:self groupIdentifier:groupIdentifier name:name queue:nil gcdQueue:nil block:block];
    [observation register];
    return observation;
}

- (nullable TOAppGroupObservation *)to_observeReliablyAppGroupNotificationsNamed:(NSString *)name onQueue:(NSOperationQueue *)queue withBlock:(TOCollatedObservationBlock)block
{
    TOAppGroupObservation *observation = [[TOAppGroupObservation alloc] initForReliableDeliveryWithObserver:self groupIdentifier:nil name:name queue:queue gcdQueue:nil block:block];
    [observation register];
    return observation;
}


- (nullable TOAppGroupObservation *)to_observeReliablyNotificationsForAppGroup:(NSString *)groupIdentifier named:(NSString *)name onQueue:(NSOperationQueue *)queue withBlock:(TOCollatedObservationBlock)block
{
    TOAppGroupObservation *observation = [[TOAppGroupObservation alloc] initForReliableDeliveryWithObserver:self groupIdentifier:groupIdentifier name:name queue:queue gcdQueue:nil block:block];
    [observation register];
    return observation;
}

- (nullable TOAppGroupObservation *)to_observeReliablyAppGroupNotificationsNamed:(NSString *)name onGCDQueue:(dispatch_queue_t)queue withBlock:(TOCollatedObservationBlock)block
{
    TOAppGroupObservation *observation = [[TOAppGroupObservation alloc] initForReliableDeliveryWithObserver:self groupIdentifier:nil name:name queue:nil gcdQueue:queue block:block];
    [observation register];
    return observation;
}

- (nullable TOAppGroupObservation *)to_observeReliablyNotificationsForAppGroup:(NSString *)groupIdentifier named:(NSString *)name onGCDQueue:(dispatch_queue_t)queue withBlock:(TOCollatedObservationBlock)block
{
    TOAppGroupObservation *observation = [[TOAppGroupObservation alloc] initForReliableDeliveryWithObserver:self groupIdentifier:groupIdentifier name:name queue:nil gcdQueue:queue block:block];
    [observation register];
    return observation;
}


- (BOOL)to_pauseObservingReliablyAppGroupNotificationsNamed:(NSString *)name
{
    return [TOAppGroupObservation removeForObserver:self groupIdentifier:nil name:name retainingState:YES];
}

- (BOOL)to_pauseObservingReliablyNotificationsForAppGroup:(NSString *)groupIdentifier named:(NSString *)name
{
    return [TOAppGroupObservation removeForObserver:self groupIdentifier:groupIdentifier name:name retainingState:YES];
}

@end


@implementation NSData (TotalObserverAppGroup)

- (BOOL)to_postWithinAppGroupNotificationNamed:(NSString *)name
{
    return [TOAppGroupObservation postNotificationNamed:name payload:self];
}

- (BOOL)to_postWithinNotificationToAppGroup:(NSString *)groupIdentifier named:(NSString *)name
{
    return [TOAppGroupObservation postNotificationForAppGroup:groupIdentifier named:name payload:self];
}

@end

@implementation NSString (TotalObserverAppGroup)

- (BOOL)to_postWithinAppGroupNotificationNamed:(NSString *)name
{
    return [TOAppGroupObservation postNotificationNamed:name payload:self];
}

- (BOOL)to_postWithinNotificationToAppGroup:(NSString *)groupIdentifier named:(NSString *)name
{
    return [TOAppGroupObservation postNotificationForAppGroup:groupIdentifier named:name payload:self];
}

@end

@implementation NSArray (TotalObserverAppGroup)

- (BOOL)to_postWithinAppGroupNotificationNamed:(NSString *)name
{
    return [TOAppGroupObservation postNotificationNamed:name payload:self];
}

- (BOOL)to_postWithinNotificationToAppGroup:(NSString *)groupIdentifier named:(NSString *)name
{
    return [TOAppGroupObservation postNotificationForAppGroup:groupIdentifier named:name payload:self];
}

@end

@implementation NSDictionary (TotalObserverAppGroup)

- (BOOL)to_postWithinAppGroupNotificationNamed:(NSString *)name
{
    return [TOAppGroupObservation postNotificationNamed:name payload:self];
}

- (BOOL)to_postWithinNotificationToAppGroup:(NSString *)groupIdentifier named:(NSString *)name
{
    return [TOAppGroupObservation postNotificationForAppGroup:groupIdentifier named:name payload:self];
}

@end

@implementation NSDate (TotalObserverAppGroup)

- (BOOL)to_postWithinAppGroupNotificationNamed:(NSString *)name
{
    return [TOAppGroupObservation postNotificationNamed:name payload:self];
}

- (BOOL)to_postWithinNotificationToAppGroup:(NSString *)groupIdentifier named:(NSString *)name
{
    return [TOAppGroupObservation postNotificationForAppGroup:groupIdentifier named:name payload:self];
}

@end

@implementation NSNumber (TotalObserverAppGroup)

- (BOOL)to_postWithinAppGroupNotificationNamed:(NSString *)name
{
    return [TOAppGroupObservation postNotificationNamed:name payload:self];
}

- (BOOL)to_postWithinNotificationToAppGroup:(NSString *)groupIdentifier named:(NSString *)name
{
    return [TOAppGroupObservation postNotificationForAppGroup:groupIdentifier named:name payload:self];
}

@end

#if __has_feature(nullability)
NS_ASSUME_NONNULL_END
#else
#undef nullable
#endif
