//
//  TOUIControlObservation.h
//  TotalObserver
//
//  Created by Pierre Houston on 2016-01-07.
//  Copyright © 2016 Pierre Houston. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TOObservation.h"

#if __has_feature(nullability)
NS_ASSUME_NONNULL_BEGIN
#define TO_nullable nullable
#else
#define TO_nullable
#endif

/**
 *  A base class for UIControlEvent observation objects.
 *
 *  An object of this class is returned from each `TotalObserverUIControl` `to_observe...` method. This result can
 *  be saved for explcitly calling the `remove` method later (see base class `TOObservation`), but that often isn't
 *  necessary since the `to_stopObserving...` methods can be used instead which look-up the matching observation.
 *
 *  The observation object is passed as a parameter to the observation block, and defines properties for accessing
 *  the control, sender, and event object.
 */
@interface TOUIControlObservation : TOObservation

@property (nonatomic, readonly) UIControl *control;
@property (nonatomic, readonly) UIControlEvents events;
@property (nonatomic, readonly) id sender;
@property (nonatomic, readonly) UIEvent *event;

/**
 *  Remove an observer with matching parameters. Can use this class method to look-up a previously registered
 *  observation and remove it, although usually more convenient to use the 'to_stopObserving' methods, or save the
 *  observation object and call `remove` on it. (see base class `TOObservation`)
 *
 *  On finding the first matching observation, its `remove` method is called before returning. (see base class
 *  `TOObservation`)
 *
 *  @param observer The observer object, or `nil` if not applicable.
 *  @param control  The control being observed.
 *  @param events   The event options used when creating the observation.
 *
 *  @return `YES` if matching observation was found, `NO` if it was not found.
 */
+ (BOOL)removeForObserver:(TO_nullable id)observer control:(UIControl *)control events:(UIControlEvents)events;

@end

@interface TOUIControlObservation (Private)
// perhaps these belong in a +Private.h header, there's no reason for users of TO normally to be creating these objects themselves
// and perhaps removeForObserver:.. should also be private
- (instancetype)initWithObserver:(nullable id)observer control:(UIControl *)control events:(UIControlEvents)events queue:(nullable NSOperationQueue *)queue gcdQueue:(nullable dispatch_queue_t)gcdQueue block:(TOObservationBlock)block;
- (instancetype)initWithControl:(UIControl *)control events:(UIControlEvents)events queue:(nullable NSOperationQueue *)queue gcdQueue:(nullable dispatch_queue_t)gcdQueue block:(TOAnonymousObservationBlock)block;
@end

#if __has_feature(nullability)
NS_ASSUME_NONNULL_END
#endif
#undef TO_nullable
