//
//  UIControl+TotalObserver.m
//  TotalObserver
//
//  Created by Pierre Houston on 2016-01-07.
//  Copyright © 2016 Pierre Houston. All rights reserved.
//

#import "UIControl+TotalObserver.h"
#import "TOObservation+Private.h"

@implementation UIControl (TotalObserver)

- (TOUIControlObservation *)to_observePressWithBlock:(TOAnonymousObservationBlock)block
{
    TOUIControlObservation *observation = [[TOUIControlObservation alloc] initWithControl:self events:UIControlEventTouchUpInside queue:nil gcdQueue:nil block:block];
    [observation register];
    return observation;
}

- (TOUIControlObservation *)to_observePressOnQueue:(NSOperationQueue *)queue withBlock:(TOAnonymousObservationBlock)block
{
    TOUIControlObservation *observation = [[TOUIControlObservation alloc] initWithControl:self events:UIControlEventTouchUpInside queue:queue gcdQueue:nil block:block];
    [observation register];
    return observation;
}

- (TOUIControlObservation *)to_observePressOnGCDQueue:(dispatch_queue_t)queue withBlock:(TOAnonymousObservationBlock)block
{
    TOUIControlObservation *observation = [[TOUIControlObservation alloc] initWithControl:self events:UIControlEventTouchUpInside queue:nil gcdQueue:queue block:block];
    [observation register];
    return observation;
}


- (TOUIControlObservation *)to_observeValueWithBlock:(TOAnonymousObservationBlock)block
{
    TOUIControlObservation *observation = [[TOUIControlObservation alloc] initWithControl:self events:UIControlEventValueChanged queue:nil gcdQueue:nil block:block];
    [observation register];
    return observation;
}

- (TOUIControlObservation *)to_observeValueOnQueue:(NSOperationQueue *)queue withBlock:(TOAnonymousObservationBlock)block
{
    TOUIControlObservation *observation = [[TOUIControlObservation alloc] initWithControl:self events:UIControlEventValueChanged queue:queue gcdQueue:nil block:block];
    [observation register];
    return observation;
}

- (TOUIControlObservation *)to_observeValueOnGCDQueue:(dispatch_queue_t)queue withBlock:(TOAnonymousObservationBlock)block
{
    TOUIControlObservation *observation = [[TOUIControlObservation alloc] initWithControl:self events:UIControlEventValueChanged queue:nil gcdQueue:queue block:block];
    [observation register];
    return observation;
}


- (TOUIControlObservation *)to_observeEvents:(UIControlEvents)events withBlock:(TOAnonymousObservationBlock)block
{
    TOUIControlObservation *observation = [[TOUIControlObservation alloc] initWithControl:self events:events queue:nil gcdQueue:nil block:block];
    [observation register];
    return observation;
}

- (TOUIControlObservation *)to_observeEvents:(UIControlEvents)events onQueue:(NSOperationQueue *)queue withBlock:(TOAnonymousObservationBlock)block
{
    TOUIControlObservation *observation = [[TOUIControlObservation alloc] initWithControl:self events:events queue:queue gcdQueue:nil block:block];
    [observation register];
    return observation;
}

- (TOUIControlObservation *)to_observeEvents:(UIControlEvents)events onGCDQueue:(dispatch_queue_t)queue withBlock:(TOAnonymousObservationBlock)block
{
    TOUIControlObservation *observation = [[TOUIControlObservation alloc] initWithControl:self events:events queue:nil gcdQueue:queue block:block];
    [observation register];
    return observation;
}


- (BOOL)to_stopObservingForPress
{
    return [TOUIControlObservation removeForObserver:nil control:self events:UIControlEventTouchUpInside];
}

- (BOOL)to_stopObservingForValue
{
    return [TOUIControlObservation removeForObserver:nil control:self events:UIControlEventValueChanged];
}

- (BOOL)to_stopObservingForEvents:(UIControlEvents)events
{
    return [TOUIControlObservation removeForObserver:nil control:self events:events];
}

@end
