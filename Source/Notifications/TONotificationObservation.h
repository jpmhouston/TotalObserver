//
//  TONotificationObservation.h
//  TotalObserver
//
//  Created by Pierre Houston on 2016-01-07.
//  Copyright © 2016 Pierre Houston. All rights reserved.
//
//  TODO:
//  - consider renaming `postedObject` property to `payload` for more consistency with the terminology of other
//    observation subclasses and also some of our documentation

#import "TOObservation.h"

#if __has_feature(nullability)
NS_ASSUME_NONNULL_BEGIN
#define TO_nullable nullable
#else
#define TO_nullable
#endif

/**
 *  A base class for NSNotification observation objects.
 *
 *  An object of this class is returned from each `TotalObserverNotifications` `to_observe...` method. This result
 *  can be saved for explcitly calling the `remove` method later (see base class `TOObservation`), but that often
 *  isn't necessary since the `to_stopObserving...` methods can be used instead which look-up the matching observation.
 *
 *  The observation object is passed as a parameter to the observation block, and defines properties for accessing
 *  the name, notification object, or its specific values directly, the posted object and user info dictionary.
 */
@interface TONotificationObservation : TOObservation

/**
 *  The notification name being observed.
 */
@property (nonatomic, readonly, copy) NSString *name;


/**
 *  A notification that triggered an observation. Value undefined except within call to an observation block.
 */
@property (nonatomic, readonly) NSNotification *notification;

/**
 *  The object that posted the notification. Value undefined except within call to an observation block.
 */
@property (nonatomic, readonly, TO_nullable) id postedObject;

/**
 *  The user info dictionary within a posted notification. Value undefined except within call to an observation
 *  block. A shortcut for `notification.userInfo`.
 */
@property (nonatomic, readonly, TO_nullable) NSDictionary *userInfo;


/**
 *  Remove an observer with matching parameters. Can use this class method to look-up a previously registered
 *  observation and remove it, although usually more convenient to use the 'to_stopObserving' methods, or save the
 *  observation object and call `remove` on it. (see base class `TOObservation`)
 *
 *  Must not call with both `observer` and `object` equal to `nil`.
 *
 *  On finding the first matching observation, its `remove` method is called before returning. (see base class
 *  `TOObservation`)
 *
 *  @param observer The observer object, or `nil` if not applicable.
 *  @param object   The object being observed, or `nil` if not applicable.
 *  @param name     The notification name used when creating the observation.
 *
 *  @return `YES` if matching observation was found, `NO` if it was not found.
 */
+ (BOOL)removeForObserver:(TO_nullable id)observer object:(TO_nullable id)object name:(NSString *)name;

@end

#if __has_feature(nullability)
NS_ASSUME_NONNULL_END
#endif
#undef TO_nullable
