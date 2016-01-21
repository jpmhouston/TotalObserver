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

- (TOUIControlObservation *)to_observePressWithBlock:(TOObservationBlock)block
{
    TOUIControlObservation *observation = [[TOUIControlObservation alloc] initWithObserver:nil control:self events:UIControlEventTouchUpInside onQueue:nil orGCDQueue:nil withBlock:block];
    [observation register];
    return observation;
}

- (TOUIControlObservation *)to_observePressOnQueue:(NSOperationQueue *)queue withBlock:(TOObservationBlock)block
{
    TOUIControlObservation *observation = [[TOUIControlObservation alloc] initWithObserver:nil control:self events:UIControlEventTouchUpInside onQueue:queue orGCDQueue:nil withBlock:block];
    [observation register];
    return observation;
}

- (TOUIControlObservation *)to_observePressOnGCDQueue:(dispatch_queue_t)queue withBlock:(TOObservationBlock)block
{
    TOUIControlObservation *observation = [[TOUIControlObservation alloc] initWithObserver:nil control:self events:UIControlEventTouchUpInside onQueue:nil orGCDQueue:queue withBlock:block];
    [observation register];
    return observation;
}


- (TOUIControlObservation *)to_observeValueWithBlock:(TOObservationBlock)block
{
    TOUIControlObservation *observation = [[TOUIControlObservation alloc] initWithObserver:nil control:self events:UIControlEventValueChanged onQueue:nil orGCDQueue:nil withBlock:block];
    [observation register];
    return observation;
}

- (TOUIControlObservation *)to_observeValueOnQueue:(NSOperationQueue *)queue withBlock:(TOObservationBlock)block
{
    TOUIControlObservation *observation = [[TOUIControlObservation alloc] initWithObserver:nil control:self events:UIControlEventValueChanged onQueue:queue orGCDQueue:nil withBlock:block];
    [observation register];
    return observation;
}

- (TOUIControlObservation *)to_observeValueOnGCDQueue:(dispatch_queue_t)queue withBlock:(TOObservationBlock)block
{
    TOUIControlObservation *observation = [[TOUIControlObservation alloc] initWithObserver:nil control:self events:UIControlEventValueChanged onQueue:nil orGCDQueue:queue withBlock:block];
    [observation register];
    return observation;
}


- (TOUIControlObservation *)to_observeEvents:(UIControlEvents)events withBlock:(TOObservationBlock)block
{
    TOUIControlObservation *observation = [[TOUIControlObservation alloc] initWithObserver:nil control:self events:events onQueue:nil orGCDQueue:nil withBlock:block];
    [observation register];
    return observation;
}

- (TOUIControlObservation *)to_observeEvents:(UIControlEvents)events onQueue:(NSOperationQueue *)queue withBlock:(TOObservationBlock)block
{
    TOUIControlObservation *observation = [[TOUIControlObservation alloc] initWithObserver:nil control:self events:events onQueue:queue orGCDQueue:nil withBlock:block];
    [observation register];
    return observation;
}

- (TOUIControlObservation *)to_observeEvents:(UIControlEvents)events onGCDQueue:(dispatch_queue_t)queue withBlock:(TOObservationBlock)block
{
    TOUIControlObservation *observation = [[TOUIControlObservation alloc] initWithObserver:nil control:self events:events onQueue:nil orGCDQueue:queue withBlock:block];
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
