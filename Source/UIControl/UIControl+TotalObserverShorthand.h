//
//  UIControl+TotalObserverShorthand.h
//  TotalObserver
//
//  Created by Pierre Houston on 2015-11-06.
//  Copyright (c) 2015 Pierre Houston. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TOUIControlObservation.h"

#if __has_feature(nullability)
NS_ASSUME_NONNULL_BEGIN
#endif

@interface UIControl (TotalObserverShorthand)

- (TOUIControlObservation *)observePressWithBlock:(TOAnonymousObservationBlock)block;
- (TOUIControlObservation *)observeValueWithBlock:(TOAnonymousObservationBlock)block;
- (TOUIControlObservation *)observeEvents:(UIControlEvents)events withBlock:(TOAnonymousObservationBlock)block;

- (TOUIControlObservation *)observePressOnQueue:(NSOperationQueue *)queue withBlock:(TOAnonymousObservationBlock)block;
- (TOUIControlObservation *)observeValueOnQueue:(NSOperationQueue *)queue withBlock:(TOAnonymousObservationBlock)block;
- (TOUIControlObservation *)observeEvents:(UIControlEvents)events onQueue:(NSOperationQueue *)queue withBlock:(TOAnonymousObservationBlock)block;

- (TOUIControlObservation *)observePressOnGCDQueue:(dispatch_queue_t)queue withBlock:(TOAnonymousObservationBlock)block;
- (TOUIControlObservation *)observeValueOnGCDQueue:(dispatch_queue_t)queue withBlock:(TOAnonymousObservationBlock)block;
- (TOUIControlObservation *)observeEvents:(UIControlEvents)events onGCDQueue:(dispatch_queue_t)queue withBlock:(TOAnonymousObservationBlock)block;

- (BOOL)stopObservingForPress;
- (BOOL)stopObservingForValue;
- (BOOL)stopObservingForEvents:(UIControlEvents)events;

@end

#if __has_feature(nullability)
NS_ASSUME_NONNULL_END
#endif
