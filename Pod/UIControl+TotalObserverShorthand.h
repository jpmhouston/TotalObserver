//
//  UIControl+TotalObserverShorthand.h
//  TotalObserver
//
//  Created by Pierre Houston on 2015-11-06.
//  Copyright (c) 2015 Pierre Houston. All rights reserved.
//

@interface NSObject (TotalObserverUIControlShorthand)

- (TOControlObservation *)observeControlForPress:(UIControl *)control withBlock:(TOObjObservationBlock)block;
- (TOControlObservation *)observeControlForValue:(UIControl *)control withBlock:(TOObjObservationBlock)block;
- (TOControlObservation *)observeControl:(UIControl *)control forEvents:(UIControlEvents)events withBlock:(TOObjObservationBlock)block;

- (TOControlObservation *)observeControlForPress:(UIControl *)control onQueue:(NSOperationQueue *)queue withBlock:(TOObjObservationBlock)block;
- (TOControlObservation *)observeControlForValue:(UIControl *)control onQueue:(NSOperationQueue *)queue withBlock:(TOObjObservationBlock)block;
- (TOControlObservation *)observeControl:(UIControl *)control forEvents:(UIControlEvents)events onQueue:(NSOperationQueue *)queue withBlock:(TOObjObservationBlock)block;

- (TOControlObservation *)observeControlForPress:(UIControl *)control onGCDQueue:(dispatch_queue_t)queue withBlock:(TOObjObservationBlock)block;
- (TOControlObservation *)observeControlForValue:(UIControl *)control onGCDQueue:(dispatch_queue_t)queue withBlock:(TOObjObservationBlock)block;
- (TOControlObservation *)observeControl:(UIControl *)control forEvents:(UIControlEvents)events onGCDQueue:(dispatch_queue_t)queue withBlock:(TOObjObservationBlock)block;

- (BOOL)stopObservingControlForPress:(UIControl *)control;
- (BOOL)stopObservingControlForValue:(UIControl *)control;
- (BOOL)stopObservingControl:(UIControl *)control forEvents:(UIControlEvents)events;

@end

@interface UIControl (TotalObserverShorthand)

- (TOControlObservation *)observePressWithBlock:(TOObservationBlock)block;
- (TOControlObservation *)observeValueWithBlock:(TOObservationBlock)block;
- (TOControlObservation *)observeEvents:(UIControlEvents)events withBlock:(TOObservationBlock)block;

- (TOControlObservation *)observePressOnQueue:(NSOperationQueue *)queue withBlock:(TOObservationBlock)block;
- (TOControlObservation *)observeValueOnQueue:(NSOperationQueue *)queue withBlock:(TOObservationBlock)block;
- (TOControlObservation *)observeEvents:(UIControlEvents)events onQueue:(NSOperationQueue *)queue withBlock:(TOObservationBlock)block;

- (TOControlObservation *)observePressOnGCDQueue:(dispatch_queue_t)queue withBlock:(TOObservationBlock)block;
- (TOControlObservation *)observeValueOnGCDQueue:(dispatch_queue_t)queue withBlock:(TOObservationBlock)block;
- (TOControlObservation *)observeEvents:(UIControlEvents)events onGCDQueue:(dispatch_queue_t)queue withBlock:(TOObservationBlock)block;

- (BOOL)stopObservingForPress;
- (BOOL)stopObservingForValue;
- (BOOL)stopObservingForEvents:(UIControlEvents)events;

@end
