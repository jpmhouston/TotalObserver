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
 *  A block called when an observation is triggered with potentially multiple results are available at once.
 *
 *  @param obj          The observing object. Often this can be used in place of a weak `self` capture.
 *  @param observations Array of the triggered observation objects. Details about the observation that was
 *                      triggered, plus any payload or associated metadata will be properties of this object.
 *                      Some objects in the array may be a copies of the original instance that represents the
 *                      overall observation. Any of these copies will forward the `remove` method call to the
 *                      original observer instance.
 */
typedef void (^TOCollatedObservationBlock)(id obj, NSArray *observations);


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
@property (nonatomic, readonly) NSString *name;

/**
 *  Whether this is a reliable observation.
 */
@property (nonatomic, readonly, getter=isReliable) BOOL reliable;


/**
 *  Payload object from a posted app group notification. Value undefined except within call to an observation block.
 */
@property (nonatomic, readonly, TO_nullable) id payload;

/**
 *  Group identifier from a posted app group notification. Value undefined except within call to an observation block.
 */
@property (nonatomic, readonly) NSString *groupIdentifier;

/**
 *  Timestamp from a posted app group notification. Value undefined except within call to an observation block.
 */
@property (nonatomic, readonly) NSDate *postedDate;



/**
 *  The block provided when the reliable observation was created, which will be executed when the observation is
 *  triggered. Can be `nil` if the observation was created as reliable, and thus the `objectBlock` property.
 *  (read-only)
 *
 *  When this property is not `nil`, should never reference `objectBlock` as its value will be undefined.
 */
@property (nonatomic, readonly, copy, TO_nullable) TOCollatedObservationBlock collatedBlock;

/**
 *  If this instance is a copy observation passed in the `observations` parameter to a `TOCollatedObservationBlock`
 *  then this is a reference to the original.
 */
@property (nonatomic, readonly, weak, TO_nullable) TOAppGroupObservation *originalObservation;


/**
 *  Remove the receiver observation, and if its is a reliable observation then stop collecting posts. The next
 *  reliable observation will not receive posts made inbetween.
 *
 *  This is compared to calling `remove` on a reliable observation which will leave state behind so that
 *  starting a reliable observation again later will receive all the posts missed during the interval inbetween.
 *
 *  For unreliable observations, this has the same behavior as `remove`.
 */
- (void)removeStoppingReliableCollection;


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
 *  Calling this, or the `remove` method directly, on a reliable observation will leave state behind so that
 *  starting a reliable observation again later will receive all the posts missed during the interval inbetween.
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

/**
 *  Remove an observer with matching parameters. Can use this class method to look-up a previously registered
 *  observation and remove it, although usually more convenient to use the 'to_stopObserving' methods, or save the
 *  observation object and call either `remove` or `removeStoppingReliableCollection` on it. (see base class
 *  `TOObservation`)
 *
 *  Calling this on a reliable observation you can choose whether you want to stop collecting posts, or to leave
 *  state behind so that starting a reliable observation again later will receive all the posts missed during the
 *  interval inbetween. Calling this with `retainState = YES` is equivalent to calling `remove` on the observation
 *  object. Calling this with `retainState = NO` is equivalent to calling `removeStoppingReliableCollection` on
 *  the observation object.
 *
 *  On finding the first matching observation, its `remove` method is called before returning. (see base class
 *  `TOObservation`)
 *
 *  @param observer    The observer object.
 *  @param identifier  The app group identifier used when creating the observation, if `nil` then default app group
 *                     will be used, which is the last app group that was registered.
 *  @param name        The notification name used when creating the observation.
 *  @param retainState Whether to leave state behind and accumulate posts until starting the next reliable
 *                     observation. Unused if this isn't a reliable observation.
 *
 *  @return `YES` if matching observation was found, `NO` if it was not found.
 */
+ (BOOL)removeForObserver:(id)observer groupIdentifier:(TO_nullable NSString *)identifier name:(NSString *)name retainingState:(BOOL)retainState;

@end

#if __has_feature(nullability)
NS_ASSUME_NONNULL_END
#endif
#undef TO_nullable
