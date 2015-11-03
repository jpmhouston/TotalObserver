//
//  UIControl+TotalObserver.h
//  Pods
//
//  Created by Pierre Houston on 2015-10-30.
//
//

#import <UIKit/UIKit.h>
#import <TotalObserver/TOObservation.h>

#if __has_feature(nullability)
NS_ASSUME_NONNULL_BEGIN
#else
#define nullable
#endif

@interface TOControlObservation : TOObservation
@property (nonatomic, readonly) UIControl *control;
@property (nonatomic, readonly) UIControlEvents events;

+ (BOOL)removeForObserver:(id)observer control:(UIControl *)control events:(UIControlEvents)events;
@end


@interface NSObject (TotalObserverUIControl)

// receiver is observer, object parameter is observee
- (TOObservation *)to_observeControlForPress:(UIControl *)control withBlock:(TOObjObservationBlock)block;

- (TOObservation *)to_observeControlForValue:(UIControl *)control withBlock:(TOObjObservationBlock)block;

- (TOObservation *)to_observeControl:(UIControl *)control forEvents:(UIControlEvents)events withBlock:(TOObjObservationBlock)block;

// same but with queue parameter
- (TOObservation *)to_observeControlForPress:(UIControl *)control onQueue:(NSOperationQueue *)queue withBlock:(TOObjObservationBlock)block;

- (TOObservation *)to_observeControlForValue:(UIControl *)control onQueue:(NSOperationQueue *)queue withBlock:(TOObjObservationBlock)block;

- (TOObservation *)to_observeControl:(UIControl *)control forEvents:(UIControlEvents)events onQueue:(NSOperationQueue *)queue withBlock:(TOObjObservationBlock)block;

@end

@interface UIControl (TotalObserver)

// receiver is observee, no observer specified (not removed automatically, so must call [observer remove] explicitly)
- (TOObservation *)to_observePressWithBlock:(TOObservationBlock)block;

- (TOObservation *)to_observeValueWithBlock:(TOObservationBlock)block;

- (TOObservation *)to_observeEvents:(UIControlEvents)events withBlock:(TOObservationBlock)block;

// same but with queue parameter
- (TOObservation *)to_observePressOnQueue:(NSOperationQueue *)queue withBlock:(TOObservationBlock)block;

- (TOObservation *)to_observeValueOnQueue:(NSOperationQueue *)queue withBlock:(TOObservationBlock)block;

- (TOObservation *)to_observeEvents:(UIControlEvents)events onQueue:(NSOperationQueue *)queue withBlock:(TOObservationBlock)block;

@end

#if __has_feature(nullability)
NS_ASSUME_NONNULL_END
#else
#undef nullable
#endif
