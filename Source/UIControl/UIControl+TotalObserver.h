//
//  UIControl+TotalObserver.h
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

@interface UIControl (TotalObserver)

// receiver is observee, no observer, automatically removed at time of receiver's dealloc
- (TOUIControlObservation *)to_observePressWithBlock:(TOAnonymousObservationBlock)block;
- (TOUIControlObservation *)to_observeValueWithBlock:(TOAnonymousObservationBlock)block;
- (TOUIControlObservation *)to_observeEvents:(UIControlEvents)events withBlock:(TOAnonymousObservationBlock)block;

// same but with operation queue parameter
- (TOUIControlObservation *)to_observePressOnQueue:(NSOperationQueue *)queue withBlock:(TOAnonymousObservationBlock)block;
- (TOUIControlObservation *)to_observeValueOnQueue:(NSOperationQueue *)queue withBlock:(TOAnonymousObservationBlock)block;
- (TOUIControlObservation *)to_observeEvents:(UIControlEvents)events onQueue:(NSOperationQueue *)queue withBlock:(TOAnonymousObservationBlock)block;

// same but with dispatch queue parameter
- (TOUIControlObservation *)to_observePressOnGCDQueue:(dispatch_queue_t)queue withBlock:(TOAnonymousObservationBlock)block;
- (TOUIControlObservation *)to_observeValueOnGCDQueue:(dispatch_queue_t)queue withBlock:(TOAnonymousObservationBlock)block;
- (TOUIControlObservation *)to_observeEvents:(UIControlEvents)events onGCDQueue:(dispatch_queue_t)queue withBlock:(TOAnonymousObservationBlock)block;

- (BOOL)to_stopObservingForPress;
- (BOOL)to_stopObservingForValue;
- (BOOL)to_stopObservingForEvents:(UIControlEvents)events;

@end

#if __has_feature(nullability)
NS_ASSUME_NONNULL_END
#endif
