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
    return [TOAppGroupObservation removeForObserver:self groupIdentifier:nil name:name];
}

- (BOOL)to_stopObservingNotificationsForAppGroup:(NSString *)groupIdentifier named:(NSString *)name
{
    return [TOAppGroupObservation removeForObserver:self groupIdentifier:groupIdentifier name:name];
}

@end


@implementation NSData (TotalObserverAppGroup)

- (void)to_postWithinAppGroupNotificationNamed:(NSString *)name
{
    [TOAppGroupObservation postNotificationNamed:name payload:self];
}

- (void)to_postWithinNotificationToAppGroup:(NSString *)groupIdentifier named:(NSString *)name
{
    [TOAppGroupObservation postNotificationForAppGroup:groupIdentifier named:name payload:self];
}

@end

@implementation NSString (TotalObserverAppGroup)

- (void)to_postWithinAppGroupNotificationNamed:(NSString *)name
{
    [TOAppGroupObservation postNotificationNamed:name payload:self];
}

- (void)to_postWithinNotificationToAppGroup:(NSString *)groupIdentifier named:(NSString *)name
{
    [TOAppGroupObservation postNotificationForAppGroup:groupIdentifier named:name payload:self];
}

@end

@implementation NSArray (TotalObserverAppGroup)

- (void)to_postWithinAppGroupNotificationNamed:(NSString *)name
{
    [TOAppGroupObservation postNotificationNamed:name payload:self];
}

- (void)to_postWithinNotificationToAppGroup:(NSString *)groupIdentifier named:(NSString *)name
{
    [TOAppGroupObservation postNotificationForAppGroup:groupIdentifier named:name payload:self];
}

@end

@implementation NSDictionary (TotalObserverAppGroup)

- (void)to_postWithinAppGroupNotificationNamed:(NSString *)name
{
    [TOAppGroupObservation postNotificationNamed:name payload:self];
}

- (void)to_postWithinNotificationToAppGroup:(NSString *)groupIdentifier named:(NSString *)name
{
    [TOAppGroupObservation postNotificationForAppGroup:groupIdentifier named:name payload:self];
}

@end

@implementation NSDate (TotalObserverAppGroup)

- (void)to_postWithinAppGroupNotificationNamed:(NSString *)name
{
    [TOAppGroupObservation postNotificationNamed:name payload:self];
}

- (void)to_postWithinNotificationToAppGroup:(NSString *)groupIdentifier named:(NSString *)name
{
    [TOAppGroupObservation postNotificationForAppGroup:groupIdentifier named:name payload:self];
}

@end

@implementation NSNumber (TotalObserverAppGroup)

- (void)to_postWithinAppGroupNotificationNamed:(NSString *)name
{
    [TOAppGroupObservation postNotificationNamed:name payload:self];
}

- (void)to_postWithinNotificationToAppGroup:(NSString *)groupIdentifier named:(NSString *)name
{
    [TOAppGroupObservation postNotificationForAppGroup:groupIdentifier named:name payload:self];
}

@end

#if __has_feature(nullability)
NS_ASSUME_NONNULL_END
#else
#undef nullable
#endif
