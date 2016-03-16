//
//  NSObject+TotalObserverKVO.m
//  TotalObserver
//
//  Created by Pierre Houston on 2016-01-07.
//  Copyright © 2016 Pierre Houston. All rights reserved.
//

#import "NSObject+TotalObserverKVO.h"
#import "TOKVOObservation+Private.h"
#import "TOObservation+Private.h"

#if __has_feature(nullability)
NS_ASSUME_NONNULL_BEGIN
#else
#define nullable
#endif

@implementation NSObject (TotalObserverKVO)

- (nullable TOKVOObservation *)to_observeForChanges:(id)object toKeyPath:(NSString *)keyPath options:(int)options withBlock:(TOObservationBlock)block
{
    TOKVOObservation *observation = [[TOKVOObservation alloc] initWithObserver:self object:object keyPaths:@[keyPath] options:options queue:nil gcdQueue:nil block:block];
    [observation register];
    return observation;
}

- (nullable TOKVOObservation *)to_observeForChanges:(id)object toKeyPaths:(NSArray *)keyPaths options:(int)options withBlock:(TOObservationBlock)block
{
    TOKVOObservation *observation = [[TOKVOObservation alloc] initWithObserver:self object:object keyPaths:keyPaths options:options queue:nil gcdQueue:nil block:block];
    [observation register];
    return observation;
}

- (nullable TOKVOObservation *)to_observeForChanges:(id)object toKeyPath:(NSString *)keyPath withBlock:(TOObservationBlock)block
{
    TOKVOObservation *observation = [[TOKVOObservation alloc] initWithObserver:self object:object keyPaths:@[keyPath] options:0 queue:nil gcdQueue:nil block:block];
    [observation register];
    return observation;
}

- (nullable TOKVOObservation *)to_observeForChanges:(id)object toKeyPaths:(NSArray *)keyPaths withBlock:(TOObservationBlock)block
{
    TOKVOObservation *observation = [[TOKVOObservation alloc] initWithObserver:self object:object keyPaths:keyPaths options:0 queue:nil gcdQueue:nil block:block];
    [observation register];
    return observation;
}

- (nullable TOKVOObservation *)to_observeForChanges:(id)object toKeyPath:(NSString *)keyPath options:(int)options onQueue:(NSOperationQueue *)queue withBlock:(TOObservationBlock)block
{
    TOKVOObservation *observation = [[TOKVOObservation alloc] initWithObserver:self object:object keyPaths:@[keyPath] options:options queue:queue gcdQueue:nil block:block];
    [observation register];
    return observation;
}

- (nullable TOKVOObservation *)to_observeForChanges:(id)object toKeyPaths:(NSArray *)keyPaths options:(int)options onQueue:(NSOperationQueue *)queue withBlock:(TOObservationBlock)block
{
    TOKVOObservation *observation = [[TOKVOObservation alloc] initWithObserver:self object:object keyPaths:keyPaths options:options queue:queue gcdQueue:nil block:block];
    [observation register];
    return observation;
}

- (nullable TOKVOObservation *)to_observeForChanges:(id)object toKeyPath:(NSString *)keyPath onQueue:(NSOperationQueue *)queue withBlock:(TOObservationBlock)block
{
    TOKVOObservation *observation = [[TOKVOObservation alloc] initWithObserver:self object:object keyPaths:@[keyPath] options:0 queue:queue gcdQueue:nil block:block];
    [observation register];
    return observation;
}

- (nullable TOKVOObservation *)to_observeForChanges:(id)object toKeyPaths:(NSArray *)keyPaths onQueue:(NSOperationQueue *)queue withBlock:(TOObservationBlock)block
{
    TOKVOObservation *observation = [[TOKVOObservation alloc] initWithObserver:self object:object keyPaths:keyPaths options:0 queue:queue gcdQueue:nil block:block];
    [observation register];
    return observation;
}

- (nullable TOKVOObservation *)to_observeForChanges:(id)object toKeyPath:(NSString *)keyPath options:(int)options onGCDQueue:(dispatch_queue_t)queue withBlock:(TOObservationBlock)block
{
    TOKVOObservation *observation = [[TOKVOObservation alloc] initWithObserver:self object:object keyPaths:@[keyPath] options:options queue:nil gcdQueue:queue block:block];
    [observation register];
    return observation;
}

- (nullable TOKVOObservation *)to_observeForChanges:(id)object toKeyPaths:(NSArray *)keyPaths options:(int)options onGCDQueue:(dispatch_queue_t)queue withBlock:(TOObservationBlock)block
{
    TOKVOObservation *observation = [[TOKVOObservation alloc] initWithObserver:self object:object keyPaths:keyPaths options:options queue:nil gcdQueue:queue block:block];
    [observation register];
    return observation;
}

- (nullable TOKVOObservation *)to_observeForChanges:(id)object toKeyPath:(NSString *)keyPath onGCDQueue:(dispatch_queue_t)queue withBlock:(TOObservationBlock)block
{
    TOKVOObservation *observation = [[TOKVOObservation alloc] initWithObserver:self object:object keyPaths:@[keyPath] options:0 queue:nil gcdQueue:queue block:block];
    [observation register];
    return observation;
}

- (nullable TOKVOObservation *)to_observeForChanges:(id)object toKeyPaths:(NSArray *)keyPaths onGCDQueue:(dispatch_queue_t)queue withBlock:(TOObservationBlock)block
{
    TOKVOObservation *observation = [[TOKVOObservation alloc] initWithObserver:self object:object keyPaths:keyPaths options:0 queue:nil gcdQueue:queue block:block];
    [observation register];
    return observation;
}


- (nullable TOKVOObservation *)to_observeOwnChangesToKeyPath:(NSString *)keyPath options:(int)options withBlock:(TOObservationBlock)block
{
    TOKVOObservation *observation = [[TOKVOObservation alloc] initWithObserver:self object:self keyPaths:@[keyPath] options:options queue:nil gcdQueue:nil block:block];
    [observation register];
    return observation;
}

- (nullable TOKVOObservation *)to_observeOwnChangesToKeyPaths:(NSArray *)keyPaths options:(int)options withBlock:(TOObservationBlock)block
{
    TOKVOObservation *observation = [[TOKVOObservation alloc] initWithObserver:self object:self keyPaths:keyPaths options:options queue:nil gcdQueue:nil block:block];
    [observation register];
    return observation;
}

- (nullable TOKVOObservation *)to_observeOwnChangesToKeyPath:(NSString *)keyPath withBlock:(TOObservationBlock)block
{
    TOKVOObservation *observation = [[TOKVOObservation alloc] initWithObserver:self object:self keyPaths:@[keyPath] options:0 queue:nil gcdQueue:nil block:block];
    [observation register];
    return observation;
}

- (nullable TOKVOObservation *)to_observeOwnChangesToKeyPaths:(NSArray *)keyPaths withBlock:(TOObservationBlock)block
{
    TOKVOObservation *observation = [[TOKVOObservation alloc] initWithObserver:self object:self keyPaths:keyPaths options:0 queue:nil gcdQueue:nil block:block];
    [observation register];
    return observation;
}

- (nullable TOKVOObservation *)to_observeOwnChangesToKeyPath:(NSString *)keyPath options:(int)options onQueue:(NSOperationQueue *)queue withBlock:(TOObservationBlock)block
{
    TOKVOObservation *observation = [[TOKVOObservation alloc] initWithObserver:self object:self keyPaths:@[keyPath] options:options queue:queue gcdQueue:nil block:block];
    [observation register];
    return observation;
}

- (nullable TOKVOObservation *)to_observeOwnChangesToKeyPaths:(NSArray *)keyPaths options:(int)options onQueue:(NSOperationQueue *)queue withBlock:(TOObservationBlock)block
{
    TOKVOObservation *observation = [[TOKVOObservation alloc] initWithObserver:self object:self keyPaths:keyPaths options:options queue:queue gcdQueue:nil block:block];
    [observation register];
    return observation;
}

- (nullable TOKVOObservation *)to_observeOwnChangesToKeyPath:(NSString *)keyPath onQueue:(NSOperationQueue *)queue withBlock:(TOObservationBlock)block
{
    TOKVOObservation *observation = [[TOKVOObservation alloc] initWithObserver:self object:self keyPaths:@[keyPath] options:0 queue:queue gcdQueue:nil block:block];
    [observation register];
    return observation;
}

- (nullable TOKVOObservation *)to_observeOwnChangesToKeyPaths:(NSArray *)keyPaths onQueue:(NSOperationQueue *)queue withBlock:(TOObservationBlock)block
{
    TOKVOObservation *observation = [[TOKVOObservation alloc] initWithObserver:self object:self keyPaths:keyPaths options:0 queue:queue gcdQueue:nil block:block];
    [observation register];
    return observation;
}

- (nullable TOKVOObservation *)to_observeOwnChangesToKeyPath:(NSString *)keyPath options:(int)options onGCDQueue:(dispatch_queue_t)queue withBlock:(TOObservationBlock)block
{
    TOKVOObservation *observation = [[TOKVOObservation alloc] initWithObserver:self object:self keyPaths:@[keyPath] options:options queue:nil gcdQueue:queue block:block];
    [observation register];
    return observation;
}

- (nullable TOKVOObservation *)to_observeOwnChangesToKeyPaths:(NSArray *)keyPaths options:(int)options onGCDQueue:(dispatch_queue_t)queue withBlock:(TOObservationBlock)block
{
    TOKVOObservation *observation = [[TOKVOObservation alloc] initWithObserver:self object:self keyPaths:keyPaths options:options queue:nil gcdQueue:queue block:block];
    [observation register];
    return observation;
}

- (nullable TOKVOObservation *)to_observeOwnChangesToKeyPath:(NSString *)keyPath onGCDQueue:(dispatch_queue_t)queue withBlock:(TOObservationBlock)block
{
    TOKVOObservation *observation = [[TOKVOObservation alloc] initWithObserver:self object:self keyPaths:@[keyPath] options:0 queue:nil gcdQueue:queue block:block];
    [observation register];
    return observation;
}

- (nullable TOKVOObservation *)to_observeOwnChangesToKeyPaths:(NSArray *)keyPaths onGCDQueue:(dispatch_queue_t)queue withBlock:(TOObservationBlock)block
{
    TOKVOObservation *observation = [[TOKVOObservation alloc] initWithObserver:self object:self keyPaths:keyPaths options:0 queue:nil gcdQueue:queue block:block];
    [observation register];
    return observation;
}


- (nullable TOKVOObservation *)to_observeChangesToKeyPath:(NSString *)keyPath options:(int)options withBlock:(TOAnonymousObservationBlock)block
{
    TOKVOObservation *observation = [[TOKVOObservation alloc] initWithObject:self keyPaths:@[keyPath] options:options queue:nil gcdQueue:nil block:block];
    [observation register];
    return observation;
}

- (nullable TOKVOObservation *)to_observeChangesToKeyPaths:(NSArray *)keyPaths options:(int)options withBlock:(TOAnonymousObservationBlock)block
{
    TOKVOObservation *observation = [[TOKVOObservation alloc] initWithObject:self keyPaths:keyPaths options:options queue:nil gcdQueue:nil block:block];
    [observation register];
    return observation;
}

- (nullable TOKVOObservation *)to_observeChangesToKeyPath:(NSString *)keyPath withBlock:(TOAnonymousObservationBlock)block
{
    TOKVOObservation *observation = [[TOKVOObservation alloc] initWithObject:self keyPaths:@[keyPath] options:0 queue:nil gcdQueue:nil block:block];
    [observation register];
    return observation;
}

- (nullable TOKVOObservation *)to_observeChangesToKeyPaths:(NSArray *)keyPaths withBlock:(TOAnonymousObservationBlock)block
{
    TOKVOObservation *observation = [[TOKVOObservation alloc] initWithObject:self keyPaths:keyPaths options:0 queue:nil gcdQueue:nil block:block];
    [observation register];
    return observation;
}

- (nullable TOKVOObservation *)to_observeChangesToKeyPath:(NSString *)keyPath options:(int)options onQueue:(NSOperationQueue *)queue withBlock:(TOAnonymousObservationBlock)block
{
    TOKVOObservation *observation = [[TOKVOObservation alloc] initWithObject:self keyPaths:@[keyPath] options:options queue:queue gcdQueue:nil block:block];
    [observation register];
    return observation;
}

- (nullable TOKVOObservation *)to_observeChangesToKeyPaths:(NSArray *)keyPaths options:(int)options onQueue:(NSOperationQueue *)queue withBlock:(TOAnonymousObservationBlock)block
{
    TOKVOObservation *observation = [[TOKVOObservation alloc] initWithObject:self keyPaths:keyPaths options:options queue:queue gcdQueue:nil block:block];
    [observation register];
    return observation;
}

- (nullable TOKVOObservation *)to_observeChangesToKeyPath:(NSString *)keyPath onQueue:(NSOperationQueue *)queue withBlock:(TOAnonymousObservationBlock)block
{
    TOKVOObservation *observation = [[TOKVOObservation alloc] initWithObject:self keyPaths:@[keyPath] options:0 queue:queue gcdQueue:nil block:block];
    [observation register];
    return observation;
}

- (nullable TOKVOObservation *)to_observeChangesToKeyPaths:(NSArray *)keyPaths onQueue:(NSOperationQueue *)queue withBlock:(TOAnonymousObservationBlock)block
{
    TOKVOObservation *observation = [[TOKVOObservation alloc] initWithObject:self keyPaths:keyPaths options:0 queue:queue gcdQueue:nil block:block];
    [observation register];
    return observation;
}

- (nullable TOKVOObservation *)to_observeChangesToKeyPath:(NSString *)keyPath options:(int)options onGCDQueue:(dispatch_queue_t)queue withBlock:(TOAnonymousObservationBlock)block
{
    TOKVOObservation *observation = [[TOKVOObservation alloc] initWithObject:self keyPaths:@[keyPath] options:options queue:nil gcdQueue:queue block:block];
    [observation register];
    return observation;
}

- (nullable TOKVOObservation *)to_observeChangesToKeyPaths:(NSArray *)keyPaths options:(int)options onGCDQueue:(dispatch_queue_t)queue withBlock:(TOAnonymousObservationBlock)block
{
    TOKVOObservation *observation = [[TOKVOObservation alloc] initWithObject:self keyPaths:keyPaths options:options queue:nil gcdQueue:queue block:block];
    [observation register];
    return observation;
}

- (nullable TOKVOObservation *)to_observeChangesToKeyPath:(NSString *)keyPath onGCDQueue:(dispatch_queue_t)queue withBlock:(TOAnonymousObservationBlock)block
{
    TOKVOObservation *observation = [[TOKVOObservation alloc] initWithObject:self keyPaths:@[keyPath] options:0 queue:nil gcdQueue:queue block:block];
    [observation register];
    return observation;
}

- (nullable TOKVOObservation *)to_observeChangesToKeyPaths:(NSArray *)keyPaths onGCDQueue:(dispatch_queue_t)queue withBlock:(TOAnonymousObservationBlock)block
{
    TOKVOObservation *observation = [[TOKVOObservation alloc] initWithObject:self keyPaths:keyPaths options:0 queue:nil gcdQueue:queue block:block];
    [observation register];
    return observation;
}


- (BOOL)to_stopObservingForChanges:(id)object toKeyPath:(NSString *)keyPath
{
    return [TOKVOObservation removeForObserver:self object:object keyPaths:@[keyPath]];
}

- (BOOL)to_stopObservingForChanges:(id)object toKeyPaths:(NSArray *)keyPaths
{
    return [TOKVOObservation removeForObserver:self object:object keyPaths:keyPaths];
}

- (BOOL)to_stopObservingOwnChangesToKeyPath:(NSString *)keyPath
{
    return [TOKVOObservation removeForObserver:self object:self keyPaths:@[keyPath]];
}

- (BOOL)to_stopObservingOwnChangesToKeyPaths:(NSArray *)keyPaths
{
    return [TOKVOObservation removeForObserver:self object:self keyPaths:keyPaths];
}

- (BOOL)to_stopObservingChangesToKeyPath:(NSString *)keyPath
{
    return [TOKVOObservation removeForObserver:nil object:self keyPaths:@[keyPath]];
}

- (BOOL)to_stopObservingChangesToKeyPaths:(NSArray *)keyPaths
{
    return [TOKVOObservation removeForObserver:nil object:self keyPaths:keyPaths];
}

@end

#if __has_feature(nullability)
NS_ASSUME_NONNULL_END
#else
#undef nullable
#endif
