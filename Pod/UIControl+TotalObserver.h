//
//  UIControl+TotalObserver.h
//  TotalObserver
//
//  Created by Pierre Houston on 2015-10-30.
//  Copyright (c) 2015 Pierre Houston. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TOObservation.h"

#if __has_feature(nullability)
NS_ASSUME_NONNULL_BEGIN
#define TO_nullable nullable
#else
#define TO_nullable
#endif

@interface TOControlObservation : TOObservation
@property (nonatomic, readonly) UIControl *control;
@property (nonatomic, readonly) UIControlEvents events;
@property (nonatomic, readonly) id sender;
@property (nonatomic, readonly) UIEvent *event;

// can use this class method to match a prior observation and remove it, although usually more convenient to
// use the 'stopObserving' methods below, or save the observation object and call 'remove' on it
+ (BOOL)removeForObserver:(TO_nullable id)observer control:(UIControl *)control events:(UIControlEvents)events;
@end


@interface NSObject (TotalObserverUIControl)

// receiver is observer, object parameter is observee, automatically removed at time of observer's dealloc
- (TOControlObservation *)to_observeControlForPress:(UIControl *)control withBlock:(TOObjObservationBlock)block;
- (TOControlObservation *)to_observeControlForValue:(UIControl *)control withBlock:(TOObjObservationBlock)block;
- (TOControlObservation *)to_observeControl:(UIControl *)control forEvents:(UIControlEvents)events withBlock:(TOObjObservationBlock)block;

// same but with queue parameter
- (TOControlObservation *)to_observeControlForPress:(UIControl *)control onQueue:(NSOperationQueue *)queue withBlock:(TOObjObservationBlock)block;
- (TOControlObservation *)to_observeControlForValue:(UIControl *)control onQueue:(NSOperationQueue *)queue withBlock:(TOObjObservationBlock)block;
- (TOControlObservation *)to_observeControl:(UIControl *)control forEvents:(UIControlEvents)events onQueue:(NSOperationQueue *)queue withBlock:(TOObjObservationBlock)block;

- (BOOL)to_stopObservingControlForPress:(UIControl *)control;
- (BOOL)to_stopObservingControlForValue:(UIControl *)control;
- (BOOL)to_stopObservingControl:(UIControl *)control forEvents:(UIControlEvents)events;

@end

@interface UIControl (TotalObserver)

// receiver is observee, no observer, automatically removed at time of receiver's dealloc
- (TOControlObservation *)to_observePressWithBlock:(TOObservationBlock)block;
- (TOControlObservation *)to_observeValueWithBlock:(TOObservationBlock)block;
- (TOControlObservation *)to_observeEvents:(UIControlEvents)events withBlock:(TOObservationBlock)block;

// same but with queue parameter
- (TOControlObservation *)to_observePressOnQueue:(NSOperationQueue *)queue withBlock:(TOObservationBlock)block;
- (TOControlObservation *)to_observeValueOnQueue:(NSOperationQueue *)queue withBlock:(TOObservationBlock)block;
- (TOControlObservation *)to_observeEvents:(UIControlEvents)events onQueue:(NSOperationQueue *)queue withBlock:(TOObservationBlock)block;

- (BOOL)to_stopObservingForPress;
- (BOOL)to_stopObservingForValue;
- (BOOL)to_stopObservingForEvents:(UIControlEvents)events;

@end

#if __has_feature(nullability)
NS_ASSUME_NONNULL_END
#endif
#undef TO_nullable
