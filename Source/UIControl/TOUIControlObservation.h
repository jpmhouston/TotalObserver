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

/**
 *  The control being observed. A synonym for the `object` property.
 */
@property (nonatomic, readonly) UIControl *control;

/**
 *  A bitmask of the events being observed.
 */
@property (nonatomic, readonly) UIControlEvents events;


/**
 *  Value of sender argument passed to internal action methods when observation triggered. Value undefined except
 *  within call to an observation block.
 *
 *  Usually equal to `control`. (TBD: Perhaps always equal to `control`? If so, can probably remove this property)
 */
@property (nonatomic, readonly) id sender;

/**
 *  Value of event that triggered an observation. Value undefined except within call to an observation block.
 */
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

#if __has_feature(nullability)
NS_ASSUME_NONNULL_END
#endif
#undef TO_nullable
