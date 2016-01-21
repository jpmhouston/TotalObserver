//
//  NSObject+TotalObserverUIControl.h
//  TotalObserver
//
//  Created by Pierre Houston on 2016-01-07.
//  Copyright © 2016 Pierre Houston. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TOUIControlObservation.h"

#if __has_feature(nullability)
NS_ASSUME_NONNULL_BEGIN
#endif

@interface NSObject (TotalObserverUIControl)

// receiver is observer, object parameter is observee, automatically removed at time of observer's dealloc
- (TOUIControlObservation *)to_observeControlForPress:(UIControl *)control withBlock:(TOObjObservationBlock)block;
- (TOUIControlObservation *)to_observeControlForValue:(UIControl *)control withBlock:(TOObjObservationBlock)block;
- (TOUIControlObservation *)to_observeControl:(UIControl *)control forEvents:(UIControlEvents)events withBlock:(TOObjObservationBlock)block;

// same but with operation queue parameter
- (TOUIControlObservation *)to_observeControlForPress:(UIControl *)control onQueue:(NSOperationQueue *)queue withBlock:(TOObjObservationBlock)block;
- (TOUIControlObservation *)to_observeControlForValue:(UIControl *)control onQueue:(NSOperationQueue *)queue withBlock:(TOObjObservationBlock)block;
- (TOUIControlObservation *)to_observeControl:(UIControl *)control forEvents:(UIControlEvents)events onQueue:(NSOperationQueue *)queue withBlock:(TOObjObservationBlock)block;

// same but with dispatch queue parameter
- (TOUIControlObservation *)to_observeControlForPress:(UIControl *)control onGCDQueue:(dispatch_queue_t)queue withBlock:(TOObjObservationBlock)block;
- (TOUIControlObservation *)to_observeControlForValue:(UIControl *)control onGCDQueue:(dispatch_queue_t)queue withBlock:(TOObjObservationBlock)block;
- (TOUIControlObservation *)to_observeControl:(UIControl *)control forEvents:(UIControlEvents)events onGCDQueue:(dispatch_queue_t)queue withBlock:(TOObjObservationBlock)block;

- (BOOL)to_stopObservingControlForPress:(UIControl *)control;
- (BOOL)to_stopObservingControlForValue:(UIControl *)control;
- (BOOL)to_stopObservingControl:(UIControl *)control forEvents:(UIControlEvents)events;

@end

#if __has_feature(nullability)
NS_ASSUME_NONNULL_END
#endif
