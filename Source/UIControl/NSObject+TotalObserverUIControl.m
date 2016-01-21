//
//  NSObject+TotalObserverUIControl.m
//  TotalObserver
//
//  Created by Pierre Houston on 2016-01-07.
//  Copyright © 2016 Pierre Houston. All rights reserved.
//

#import "NSObject+TotalObserverUIControl.h"
#import "TOObservation+Private.h"

@implementation NSObject (TotalObserverUIControl)

- (TOUIControlObservation *)to_observeControlForPress:(UIControl *)control withBlock:(TOObjObservationBlock)block
{
    TOUIControlObservation *observation = [[TOUIControlObservation alloc] initWithObserver:self control:control events:UIControlEventTouchUpInside onQueue:nil orGCDQueue:nil withObjBlock:block];
    [observation register];
    return observation;
}

- (TOUIControlObservation *)to_observeControlForPress:(UIControl *)control onQueue:(NSOperationQueue *)queue withBlock:(TOObjObservationBlock)block
{
    TOUIControlObservation *observation = [[TOUIControlObservation alloc] initWithObserver:self control:control events:UIControlEventTouchUpInside onQueue:queue orGCDQueue:nil withObjBlock:block];
    [observation register];
    return observation;
}

- (TOUIControlObservation *)to_observeControlForPress:(UIControl *)control onGCDQueue:(dispatch_queue_t)queue withBlock:(TOObjObservationBlock)block
{
    TOUIControlObservation *observation = [[TOUIControlObservation alloc] initWithObserver:self control:control events:UIControlEventTouchUpInside onQueue:nil orGCDQueue:queue withObjBlock:block];
    [observation register];
    return observation;
}


- (TOUIControlObservation *)to_observeControlForValue:(UIControl *)control withBlock:(TOObjObservationBlock)block
{
    TOUIControlObservation *observation = [[TOUIControlObservation alloc] initWithObserver:self control:control events:UIControlEventValueChanged onQueue:nil orGCDQueue:nil withObjBlock:block];
    [observation register];
    return observation;
}

- (TOUIControlObservation *)to_observeControlForValue:(UIControl *)control onQueue:(NSOperationQueue *)queue withBlock:(TOObjObservationBlock)block
{
    TOUIControlObservation *observation = [[TOUIControlObservation alloc] initWithObserver:self control:control events:UIControlEventValueChanged onQueue:queue orGCDQueue:nil withObjBlock:block];
    [observation register];
    return observation;
}

- (TOUIControlObservation *)to_observeControlForValue:(UIControl *)control onGCDQueue:(dispatch_queue_t)queue withBlock:(TOObjObservationBlock)block
{
    TOUIControlObservation *observation = [[TOUIControlObservation alloc] initWithObserver:self control:control events:UIControlEventValueChanged onQueue:nil orGCDQueue:queue withObjBlock:block];
    [observation register];
    return observation;
}


- (TOUIControlObservation *)to_observeControl:(UIControl *)control forEvents:(UIControlEvents)events withBlock:(TOObjObservationBlock)block
{
    TOUIControlObservation *observation = [[TOUIControlObservation alloc] initWithObserver:self control:control events:events onQueue:nil orGCDQueue:nil withObjBlock:block];
    [observation register];
    return observation;
}

- (TOUIControlObservation *)to_observeControl:(UIControl *)control forEvents:(UIControlEvents)events onQueue:(NSOperationQueue *)queue withBlock:(TOObjObservationBlock)block
{
    TOUIControlObservation *observation = [[TOUIControlObservation alloc] initWithObserver:self control:control events:events onQueue:queue orGCDQueue:nil withObjBlock:block];
    [observation register];
    return observation;
}

- (TOUIControlObservation *)to_observeControl:(UIControl *)control forEvents:(UIControlEvents)events onGCDQueue:(dispatch_queue_t)queue withBlock:(TOObjObservationBlock)block
{
    TOUIControlObservation *observation = [[TOUIControlObservation alloc] initWithObserver:self control:control events:events onQueue:nil orGCDQueue:queue withObjBlock:block];
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
