//
//  NSObject+TotalObserverUIControl.m
//  TotalObserver
//
//  Created by Pierre Houston on 2016-01-07.
//  Copyright © 2016 Pierre Houston. All rights reserved.
//

#import "NSObject+TotalObserverUIControl.h"
#import "TOUIControlObservation+Private.h"
#import "TOObservation+Private.h"

#if __has_feature(nullability)
NS_ASSUME_NONNULL_BEGIN
#else
#define nullable
#endif

@implementation NSObject (TotalObserverUIControl)

- (nullable TOUIControlObservation *)to_observeControlForPress:(UIControl *)control withBlock:(TOObservationBlock)block
{
    TOUIControlObservation *observation = [[TOUIControlObservation alloc] initWithObserver:self control:control events:UIControlEventTouchUpInside queue:nil gcdQueue:nil block:block];
    [observation register];
    return observation;
}

- (nullable TOUIControlObservation *)to_observeControlForPress:(UIControl *)control onQueue:(NSOperationQueue *)queue withBlock:(TOObservationBlock)block
{
    TOUIControlObservation *observation = [[TOUIControlObservation alloc] initWithObserver:self control:control events:UIControlEventTouchUpInside queue:queue gcdQueue:nil block:block];
    [observation register];
    return observation;
}

- (nullable TOUIControlObservation *)to_observeControlForPress:(UIControl *)control onGCDQueue:(dispatch_queue_t)queue withBlock:(TOObservationBlock)block
{
    TOUIControlObservation *observation = [[TOUIControlObservation alloc] initWithObserver:self control:control events:UIControlEventTouchUpInside queue:nil gcdQueue:queue block:block];
    [observation register];
    return observation;
}


- (nullable TOUIControlObservation *)to_observeControlForValue:(UIControl *)control withBlock:(TOObservationBlock)block
{
    TOUIControlObservation *observation = [[TOUIControlObservation alloc] initWithObserver:self control:control events:UIControlEventValueChanged queue:nil gcdQueue:nil block:block];
    [observation register];
    return observation;
}

- (nullable TOUIControlObservation *)to_observeControlForValue:(UIControl *)control onQueue:(NSOperationQueue *)queue withBlock:(TOObservationBlock)block
{
    TOUIControlObservation *observation = [[TOUIControlObservation alloc] initWithObserver:self control:control events:UIControlEventValueChanged queue:queue gcdQueue:nil block:block];
    [observation register];
    return observation;
}

- (nullable TOUIControlObservation *)to_observeControlForValue:(UIControl *)control onGCDQueue:(dispatch_queue_t)queue withBlock:(TOObservationBlock)block
{
    TOUIControlObservation *observation = [[TOUIControlObservation alloc] initWithObserver:self control:control events:UIControlEventValueChanged queue:nil gcdQueue:queue block:block];
    [observation register];
    return observation;
}


- (nullable TOUIControlObservation *)to_observeControl:(UIControl *)control forEvents:(UIControlEvents)events withBlock:(TOObservationBlock)block
{
    TOUIControlObservation *observation = [[TOUIControlObservation alloc] initWithObserver:self control:control events:events queue:nil gcdQueue:nil block:block];
    [observation register];
    return observation;
}

- (nullable TOUIControlObservation *)to_observeControl:(UIControl *)control forEvents:(UIControlEvents)events onQueue:(NSOperationQueue *)queue withBlock:(TOObservationBlock)block
{
    TOUIControlObservation *observation = [[TOUIControlObservation alloc] initWithObserver:self control:control events:events queue:queue gcdQueue:nil block:block];
    [observation register];
    return observation;
}

- (nullable TOUIControlObservation *)to_observeControl:(UIControl *)control forEvents:(UIControlEvents)events onGCDQueue:(dispatch_queue_t)queue withBlock:(TOObservationBlock)block
{
    TOUIControlObservation *observation = [[TOUIControlObservation alloc] initWithObserver:self control:control events:events queue:nil gcdQueue:queue block:block];
    [observation register];
    return observation;
}


- (BOOL)to_stopObservingControlForPress:(UIControl *)control
{
    return [TOUIControlObservation removeForObserver:self control:control events:UIControlEventTouchUpInside];
}

- (BOOL)to_stopObservingControlForValue:(UIControl *)control
{
    return [TOUIControlObservation removeForObserver:self control:control events:UIControlEventValueChanged];
}

- (BOOL)to_stopObservingControl:(UIControl *)control forEvents:(UIControlEvents)events
{
    return [TOUIControlObservation removeForObserver:self control:control events:events];
}

@end

#if __has_feature(nullability)
NS_ASSUME_NONNULL_END
#else
#undef nullable
#endif
