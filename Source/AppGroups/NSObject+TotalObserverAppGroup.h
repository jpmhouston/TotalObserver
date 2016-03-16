//
//  NSObject+TotalObserverAppGroup.h
//  TotalObserver
//
//  Created by Pierre Houston on 2016-02-23.
//  Copyright © 2016 Pierre Houston. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TOAppGroupObservation.h"

#if __has_feature(nullability)
NS_ASSUME_NONNULL_BEGIN
#define TO_nullable nullable
#else
#define TO_nullable
#endif

@interface NSObject (TotalObserverAppGroup)

#pragma mark - Observe default app group

/**
 *  Receiver observes notifications on a given name within the default app group.
 *
 *  As notifications may be received sometime after they were posts, a timestamp when the notification was posted can be
 *  found within the `postedDate` property of the observation when the block is called.
 *
 *  The observation will automatically be stopped when the receiver is deallocated.
 *
 *  Will fail and return `nil` if a default app group has not first been setup using
 *  `+[TOAppGroupObservation registerAppGroup:]`.
 *
 *  @param name  The notification name to observe.
 *  @param block The block to call when observation is triggered, is passed the receiver (which can be used in place of
 *               a weakly captured self), and the observation (same as method result).
 *
 *  @return An observation object if registration successful, `nil` otherwise. You often don't need to keep this result.
 */
- (TO_nullable TOAppGroupObservation *)to_observeAppGroupNotificationsNamed:(NSString *)name withBlock:(TOObservationBlock)block;

/**
 *  Receiver observes notifications on a given name within the default app group, calling its block on the given
 *  operation queue.
 *
 *  Variation on `to_observeAppGroupNotificationsNamed:withBlock:` that adds an operation queue parameter. See the
 *  description for that method.
 *
 *  @param name  The notification name to observe.
 *  @param queue The operation queue on which to call `block`.
 *  @param block The block to call when observation is triggered, is passed the receiver (which can be used in place of
 *               a weakly captured self), and the observation (same as method result).
 *
 *  @return An observation object if registration successful, `nil` otherwise. You often don't need to keep this result.
 */
- (TO_nullable TOAppGroupObservation *)to_observeAppGroupNotificationsNamed:(NSString *)name onQueue:(NSOperationQueue *)queue withBlock:(TOObservationBlock)block;

/**
 *  Receiver observes notifications on a given name within the default app group, calling its block on the given
 *  GCD dispatch queue.
 *
 *  Variation on `to_observeAppGroupNotificationsNamed:withBlock:` that adds an operation queue parameter. See the
 *  description for that method.
 *
 *  @param name  The notification name to observe.
 *  @param queue The GCD dispatch queue on which to call `block`.
 *  @param block The block to call when observation is triggered, is passed the receiver (which can be used in place of
 *               a weakly captured self), and the observation (same as method result).
 *
 *  @return An observation object if registration successful, `nil` otherwise. You often don't need to keep this result.
 */
- (TO_nullable TOAppGroupObservation *)to_observeAppGroupNotificationsNamed:(NSString *)name onGCDQueue:(dispatch_queue_t)queue withBlock:(TOObservationBlock)block;


/**
 *  Receiver stops observing notifications on a given name within the default app group.
 *
 *  Call on the same object on which you called one of the `to_observe..` methods. Useful if you want to stop observing sometime
 *  before the receiver is deallocated. Alternately, can save the observation object returned from the `to_observe..` method,
 *  and call its `remove` method.
 *
 *  @param name The notification name to stop observing.
 *
 *  @return `YES` if a default app group was registered and was previously observing notification on this name, `NO`
 *          otherwise.
 */
- (BOOL)to_stopObservingAppGroupNotificationsNamed:(NSString *)name;


#pragma mark - Observe specific app group

/**
 *  Receiver observes notifications on a given name within the given app group.
 *
 *  As notifications may be received sometime after they were posts, a timestamp when the notification was posted can be
 *  found within the `postedDate` property of the observation when the block is called.
 *
 *  The observation will automatically be stopped when the receiver is deallocated.
 *
 *  Will fail and return `nil` if the given app group has not first been setup using
 *  `+[TOAppGroupObservation registerAppGroup:]`.
 *
 *  @param groupIdentifier The app group identifier in which to observe.
 *  @param name            The notification name to observe.
 *  @param block           The block to call when observation is triggered, is passed the receiver (which can be used
 *                         in place of a weakly captured self), and the observation (same as method result).
 *
 *  @return An observation object if registration successful, `nil` otherwise. You often don't need to keep this result.
 */
- (TO_nullable TOAppGroupObservation *)to_observeNotificationsForAppGroup:(NSString *)groupIdentifier named:(NSString *)name withBlock:(TOObservationBlock)block;

/**
 *  Receiver observes notifications on a given name within the default app group, calling its block on the given
 *  operation queue.
 *
 *  Variation on `to_observeNotificationsForAppGroup:named:withBlock:` that adds an operation queue parameter. See the
 *  description for that method.
 *
 *  @param groupIdentifier The app group identifier in which to observe.
 *  @param name            The notification name to observe.
 *  @param queue           The operation queue on which to call `block`.
 *  @param block           The block to call when observation is triggered, is passed the receiver (which can be used
 *                         in place of a weakly captured self), and the observation (same as method result).
 *
 *  @return An observation object if registration successful, `nil` otherwise. You often don't need to keep this result.
 */
- (TO_nullable TOAppGroupObservation *)to_observeNotificationsForAppGroup:(NSString *)groupIdentifier named:(NSString *)name onQueue:(NSOperationQueue *)queue withBlock:(TOObservationBlock)block;

/**
 *  Receiver observes notifications on a given name within the default app group, calling its block on the given
 *  GCD dispatch queue.
 *
 *  Variation on `to_observeNotificationsForAppGroup:named:withBlock:` that adds an operation queue parameter. See the
 *  description for that method.
 *
 *  @param groupIdentifier The app group identifier in which to observe.
 *  @param name            The notification name to observe.
 *  @param queue           The GCD dispatch queue on which to call `block`.
 *  @param block           The block to call when observation is triggered, is passed the receiver (which can be used
 *                         in place of a weakly captured self), and the observation (same as method result).
 *
 *  @return An observation object if registration successful, `nil` otherwise. You often don't need to keep this result.
 */
- (TO_nullable TOAppGroupObservation *)to_observeNotificationsForAppGroup:(NSString *)groupIdentifier named:(NSString *)name onGCDQueue:(dispatch_queue_t)queue withBlock:(TOObservationBlock)block;


/**
 *  Receiver stops observing notifications on a given name within the given app group.
 *
 *  Call on the same object on which you called one of the `to_observe..` methods. Useful if you want to stop observing
 *  sometime before the receiver is deallocated. Alternately, can save the observation object returned from the
 *  `to_observe..` method, and call its `remove` method.
 *
 *  @param groupIdentifier The app group identifier in which `name` was being observed.
 *  @param name            The notification name to stop observing.
 *
 *  @return `YES` if the given app group was registered and was previously observing notification on this name, `NO`
 *          otherwise.
 */
- (BOOL)to_stopObservingNotificationsForAppGroup:(NSString *)groupIdentifier named:(NSString *)name;

@end


#pragma mark - Convenience posting methods

// Posting methods for which the receiver is the payload. These aren't methods on NSObject since not all objects
// are plist compatible.
// TODO: consider supporting NSCoding instead, or also, to permit more kinds of payload objects

@interface NSData (TotalObserverAppGroup)
/**
 *  Post notification to the default app group with given name with the receiver as the payload.
 *
 *  To post without a payload, instead use +[TOAppGroupObservation postNotificationNamed:payload:] or
 *  +[TOAppGroupObservation postNotificationForAppGroup:named:payload:]
 *
 *  @param name The notification name to post.
 *
 *  @return `YES` if a default app group was registered and notification was successfully posted, `NO` there's no
 *          default app group or the receiver was unable to be serialized.
 */
- (BOOL)to_postWithinAppGroupNotificationNamed:(NSString *)name;

/**
 *  Post notification to the given app group with given name with the receiver as the payload.
 *
 *  To post without a payload, instead use +[TOAppGroupObservation postNotificationNamed:payload:] or
 *  +[TOAppGroupObservation postNotificationForAppGroup:named:payload:]
 *
 *  @param groupIdentifier The app group identifier.
 *  @param name            The notification name to post.
 *
 *  @return `YES` if the given app group has been registered and notification was successfully posted, `NO` if the
 *          app group has not been registered or the receiver was unable to be serialized.
 */
- (BOOL)to_postWithinNotificationToAppGroup:(NSString *)groupIdentifier named:(NSString *)name;
@end


@interface NSString (TotalObserverAppGroup)
/**
 *  Post notification to the default app group with given name with the receiver as the payload.
 *
 *  To post without a payload, instead use +[TOAppGroupObservation postNotificationNamed:payload:] or
 *  +[TOAppGroupObservation postNotificationForAppGroup:named:payload:]
 *
 *  @param name The notification name to post.
 *
 *  @return `YES` if a default app group was registered and notification was successfully posted, `NO` there's no
 *          default app group or the receiver was unable to be serialized.
 */
- (BOOL)to_postWithinAppGroupNotificationNamed:(NSString *)name;

/**
 *  Post notification to the given app group with given name with the receiver as the payload.
 *
 *  To post without a payload, instead use +[TOAppGroupObservation postNotificationNamed:payload:] or
 *  +[TOAppGroupObservation postNotificationForAppGroup:named:payload:]
 *
 *  @param groupIdentifier The app group identifier.
 *  @param name            The notification name to post.
 *
 *  @return `YES` if the given app group has been registered and notification was successfully posted, `NO` if the
 *          app group has not been registered or the receiver was unable to be serialized.
 */
- (BOOL)to_postWithinNotificationToAppGroup:(NSString *)groupIdentifier named:(NSString *)name;
@end


@interface NSArray (TotalObserverAppGroup)
/**
 *  Post notification to the default app group with given name with the receiver as the payload.
 *
 *  To post without a payload, instead use +[TOAppGroupObservation postNotificationNamed:payload:] or
 *  +[TOAppGroupObservation postNotificationForAppGroup:named:payload:]
 *
 *  @param name The notification name to post.
 *
 *  @return `YES` if a default app group was registered and notification was successfully posted, `NO` there's no
 *          default app group or the receiver was unable to be serialized.
 */
- (BOOL)to_postWithinAppGroupNotificationNamed:(NSString *)name;

/**
 *  Post notification to the given app group with given name with the receiver as the payload.
 *
 *  To post without a payload, instead use +[TOAppGroupObservation postNotificationNamed:payload:] or
 *  +[TOAppGroupObservation postNotificationForAppGroup:named:payload:]
 *
 *  @param groupIdentifier The app group identifier.
 *  @param name            The notification name to post.
 *
 *  @return `YES` if the given app group has been registered and notification was successfully posted, `NO` if the
 *          app group has not been registered or the receiver was unable to be serialized.
 */
- (BOOL)to_postWithinNotificationToAppGroup:(NSString *)groupIdentifier named:(NSString *)name;
@end


@interface NSDictionary (TotalObserverAppGroup)
/**
 *  Post notification to the default app group with given name with the receiver as the payload.
 *
 *  To post without a payload, instead use +[TOAppGroupObservation postNotificationNamed:payload:] or
 *  +[TOAppGroupObservation postNotificationForAppGroup:named:payload:]
 *
 *  @param name The notification name to post.
 *
 *  @return `YES` if a default app group was registered and notification was successfully posted, `NO` there's no
 *          default app group or the receiver was unable to be serialized.
 */
- (BOOL)to_postWithinAppGroupNotificationNamed:(NSString *)name;

/**
 *  Post notification to the given app group with given name with the receiver as the payload.
 *
 *  To post without a payload, instead use +[TOAppGroupObservation postNotificationNamed:payload:] or
 *  +[TOAppGroupObservation postNotificationForAppGroup:named:payload:]
 *
 *  @param groupIdentifier The app group identifier.
 *  @param name            The notification name to post.
 *
 *  @return `YES` if the given app group has been registered and notification was successfully posted, `NO` if the
 *          app group has not been registered or the receiver was unable to be serialized.
 */
- (BOOL)to_postWithinNotificationToAppGroup:(NSString *)groupIdentifier named:(NSString *)name;
@end


@interface NSDate (TotalObserverAppGroup)
/**
 *  Post notification to the default app group with given name with the receiver as the payload.
 *
 *  To post without a payload, instead use +[TOAppGroupObservation postNotificationNamed:payload:] or
 *  +[TOAppGroupObservation postNotificationForAppGroup:named:payload:]
 *
 *  @param name The notification name to post.
 *
 *  @return `YES` if a default app group was registered and notification was successfully posted, `NO` there's no
 *          default app group or the receiver was unable to be serialized.
 */
- (BOOL)to_postWithinAppGroupNotificationNamed:(NSString *)name;

/**
 *  Post notification to the given app group with given name with the receiver as the payload.
 *
 *  To post without a payload, instead use +[TOAppGroupObservation postNotificationNamed:payload:] or
 *  +[TOAppGroupObservation postNotificationForAppGroup:named:payload:]
 *
 *  @param groupIdentifier The app group identifier.
 *  @param name            The notification name to post.
 *
 *  @return `YES` if the given app group has been registered and notification was successfully posted, `NO` if the
 *          app group has not been registered or the receiver was unable to be serialized.
 */
- (BOOL)to_postWithinNotificationToAppGroup:(NSString *)groupIdentifier named:(NSString *)name;
@end


@interface NSNumber (TotalObserverAppGroup)
/**
 *  Post notification to the default app group with given name with the receiver as the payload.
 *
 *  To post without a payload, instead use +[TOAppGroupObservation postNotificationNamed:payload:] or
 *  +[TOAppGroupObservation postNotificationForAppGroup:named:payload:]
 *
 *  @param name The notification name to post.
 *
 *  @return `YES` if a default app group was registered and notification was successfully posted, `NO` there's no
 *          default app group or the receiver was unable to be serialized.
 */
- (BOOL)to_postWithinAppGroupNotificationNamed:(NSString *)name;

/**
 *  Post notification to the given app group with given name with the receiver as the payload.
 *
 *  To post without a payload, instead use +[TOAppGroupObservation postNotificationNamed:payload:] or
 *  +[TOAppGroupObservation postNotificationForAppGroup:named:payload:]
 *
 *  @param groupIdentifier The app group identifier.
 *  @param name            The notification name to post.
 *
 *  @return `YES` if the given app group has been registered and notification was successfully posted, `NO` if the
 *          app group has not been registered or the receiver was unable to be serialized.
 */
- (BOOL)to_postWithinNotificationToAppGroup:(NSString *)groupIdentifier named:(NSString *)name;
@end

#if __has_feature(nullability)
NS_ASSUME_NONNULL_END
#endif
#undef TO_nullable
