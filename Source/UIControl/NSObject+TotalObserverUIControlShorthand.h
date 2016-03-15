//
//  NSObject+TotalObserverUIControlShorthand.h
//  TotalObserver
//
//  Created by Pierre Houston on 2016-01-07.
//  Copyright © 2016 Pierre Houston. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TOUIControlObservation.h"

#if __has_feature(nullability)
NS_ASSUME_NONNULL_BEGIN
#define TO_nullable nullable
#else
#define TO_nullable
#endif

@interface NSObject (TotalObserverUIControlShorthand)

- (TO_nullable TOUIControlObservation *)observeControlForPress:(UIControl *)control withBlock:(TOObservationBlock)block;
- (TO_nullable TOUIControlObservation *)observeControlForPress:(UIControl *)control onQueue:(NSOperationQueue *)queue withBlock:(TOObservationBlock)block;
- (TO_nullable TOUIControlObservation *)observeControlForPress:(UIControl *)control onGCDQueue:(dispatch_queue_t)queue withBlock:(TOObservationBlock)block;

- (BOOL)stopObservingControlForPress:(UIControl *)control;

- (TO_nullable TOUIControlObservation *)observeControlForValue:(UIControl *)control withBlock:(TOObservationBlock)block;
- (TO_nullable TOUIControlObservation *)observeControlForValue:(UIControl *)control onQueue:(NSOperationQueue *)queue withBlock:(TOObservationBlock)block;
- (TO_nullable TOUIControlObservation *)observeControlForValue:(UIControl *)control onGCDQueue:(dispatch_queue_t)queue withBlock:(TOObservationBlock)block;

- (BOOL)stopObservingControlForValue:(UIControl *)control;

- (TO_nullable TOUIControlObservation *)observeControl:(UIControl *)control forEvents:(UIControlEvents)events withBlock:(TOObservationBlock)block;
- (TO_nullable TOUIControlObservation *)observeControl:(UIControl *)control forEvents:(UIControlEvents)events onQueue:(NSOperationQueue *)queue withBlock:(TOObservationBlock)block;
- (TO_nullable TOUIControlObservation *)observeControl:(UIControl *)control forEvents:(UIControlEvents)events onGCDQueue:(dispatch_queue_t)queue withBlock:(TOObservationBlock)block;

- (BOOL)stopObservingControl:(UIControl *)control forEvents:(UIControlEvents)events;

@end

#if __has_feature(nullability)
NS_ASSUME_NONNULL_END
#endif
#undef TO_nullable
