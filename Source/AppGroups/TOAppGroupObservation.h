//
//  TOAppGroupObservation.h
//  TotalObserver
//
//  Created by Pierre Houston on 2016-02-23.
//  Copyright © 2016 Pierre Houston. All rights reserved.
//

#import "TOObservation.h"

#if __has_feature(nullability)
NS_ASSUME_NONNULL_BEGIN
#define TO_nullable nullable
#else
#define TO_nullable
#endif

/**
 *  A base class for App Group Notification observation objects.
 *
 *  An object of this class is returned from each `TotalObserverAppGroup` `to_observe...` method. This result can be
 *  saved for explcitly calling the `remove` method later (see base class `TOObservation`), but that often isn't
 *  necessary since the `to_stopObserving...` methods can be used instead which look-up the matching observation.
 *
 *  The observation object is passed as a parameter to the observation block, and defines properties for accessing
 *  the name, payload, and a timestamp when the notification was posted.
 */
@interface TOAppGroupObservation : TOObservation

/**
 *  The notification name being observed.
 */
@property (nonatomic, readonly, copy) NSString *name;


/**
 *  Payload object from a posted app group notification. Value undefined except within call to an observation block.
 */
@property (nonatomic, readonly, TO_nullable) id payload;

/**
 *  Group identifier from a posted app group notification. Value undefined except within call to an observation block.
 */
@property (nonatomic, readonly, copy) NSString *groupIdentifier;

/**
 *  Timestamp from a posted app group notification. Value undefined except within call to an observation block.
 */
@property (nonatomic, readonly) NSDate *postedDate;


/**
 *  Register an app group to observe. Currently this is require to be called before creating any observations.
 *  (Future versions of TotalObserver may locate all app group identifiers in the entitlements for your app,
 *  or maybe that's impossible, I haven't checked)
 *
 *  @param groupIdentifier The identifier string for your app group.
 *
 *  @return `YES` if app has been setup in its entitlements as member of the app group, `NO` if the entitilements
 *          cannot be found.
 */
+ (BOOL)registerAppGroup:(NSString *)groupIdentifier;

/**
 *  Deegister an app group to observe. Calling this effectively disables all observations on that app group.
 *  (Currently the observations aren't fully removed, even though the observation block will never get called)
 *
 *  It's not necessary to call this method when the app is shutting down.
 *
 *  @param groupIdentifier The identifier string for your app group.
 */
+ (void)deregisterAppGroup:(NSString *)groupIdentifier;


/**
 *  Post a notification to all apps observing on the given name within the default app group. You may use this
 *  class method instead of a category method `to_postWithinAppGroupNotificationNamed` on the payload object.
 *  But if your payload is `nil` then you must use this method.
 *
 *  Currently, you cannot use CFNotificationCenterPostNotification directly, if you do, the notification will not
 *  end up invoking the observation blocks in the observing objects.
 *
 *  The default app group is the last app group that was registered.
 *
 *  @param name    The notification name to post.
 *  @param payload The payload object to pass within the notification, or `nil` if none.
 *
 *  @return `YES` if no default app group is registered, the payload was written to the shared directory, and the
 *          darwin notification was succesfully posted, `NO` otherwise.
 */
+ (BOOL)postNotificationNamed:(NSString *)name payload:(TO_nullable id)payload;

/**
 *  Post a notification to all apps observing on the given name within the given default app group. You may use
 *  this class method instead of a category method `to_postWithinAppGroupNotificationNamed` on the payload object.
 *  But if your payload is `nil` then you must use this method.
 *
 *  Currently, you cannot use CFNotificationCenterPostNotification directly, if you do, the notification will not
 *  end up invoking the observation blocks in the observing objects.
 *
 *  The default app group is the last app group that was registered.
 *
 *  @param groupIdentifier The identifier string for your app group.
 *  @param name            The notification name to post.
 *  @param payload         The payload object to pass within the notification, or `nil` if none.
 *
 *  @return `YES` if the app group is not registered, the payload was written to the shared directory, and the
 *          darwin notification was succesfully posted, `NO` otherwise.
 */
+ (BOOL)postNotificationForAppGroup:(NSString *)groupIdentifier named:(NSString *)name payload:(TO_nullable id)payload;


/**
 *  Remove an observer with matching parameters. Can use this class method to look-up a previously registered
 *  observation and remove it, although usually more convenient to use the 'to_stopObserving' methods, or save the
 *  observation object and call `remove` on it. (see base class `TOObservation`)
 *
 *  On finding the first matching observation, its `remove` method is called before returning. (see base class
 *  `TOObservation`)
 *
 *  @param observer   The observer object.
 *  @param identifier The app group identifier used when creating the observation, if `nil` then default app group
 *                    will be used, which is the last app group that was registered.
 *  @param name       The notification name used when creating the observation.
 *
 *  @return `YES` if matching observation was found, `NO` if it was not found.
 */
+ (BOOL)removeForObserver:(id)observer groupIdentifier:(TO_nullable NSString *)identifier name:(NSString *)name;

@end

#if __has_feature(nullability)
NS_ASSUME_NONNULL_END
#endif
#undef TO_nullable
