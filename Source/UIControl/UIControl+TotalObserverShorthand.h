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
#define TO_nullable nullable
#else
#define TO_nullable
#endif

@interface UIControl (TotalObserverShorthand)

- (TO_nullable TOUIControlObservation *)observePressWithBlock:(TOAnonymousObservationBlock)block;
- (TO_nullable TOUIControlObservation *)observePressOnQueue:(NSOperationQueue *)queue withBlock:(TOAnonymousObservationBlock)block;
- (TO_nullable TOUIControlObservation *)observePressOnGCDQueue:(dispatch_queue_t)queue withBlock:(TOAnonymousObservationBlock)block;

- (BOOL)stopObservingForPress;

- (TO_nullable TOUIControlObservation *)observeValueWithBlock:(TOAnonymousObservationBlock)block;
- (TO_nullable TOUIControlObservation *)observeValueOnQueue:(NSOperationQueue *)queue withBlock:(TOAnonymousObservationBlock)block;
- (TO_nullable TOUIControlObservation *)observeValueOnGCDQueue:(dispatch_queue_t)queue withBlock:(TOAnonymousObservationBlock)block;

- (BOOL)stopObservingForValue;

- (TO_nullable TOUIControlObservation *)observeEvents:(UIControlEvents)events withBlock:(TOAnonymousObservationBlock)block;
- (TO_nullable TOUIControlObservation *)observeEvents:(UIControlEvents)events onQueue:(NSOperationQueue *)queue withBlock:(TOAnonymousObservationBlock)block;
- (TO_nullable TOUIControlObservation *)observeEvents:(UIControlEvents)events onGCDQueue:(dispatch_queue_t)queue withBlock:(TOAnonymousObservationBlock)block;

- (BOOL)stopObservingForEvents:(UIControlEvents)events;

@end

#if __has_feature(nullability)
NS_ASSUME_NONNULL_END
#endif
#undef TO_nullable
