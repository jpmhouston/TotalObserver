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
 *  @return `YES` if a default app group was setup and was previously observing notification on this name, `NO` otherwise.
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
 *  Call on the same object on which you called one of the `to_observe..` methods. Useful if you want to stop observing sometime
 *  before the receiver is deallocated. Alternately, can save the observation object returned from the `to_observe..` method,
 *  and call its `remove` method.
 *
 *  @param groupIdentifier The app group identifier in which `name` was being observed.
 *  @param name            The notification name to stop observing.
 *
 *  @return `YES` if a given app group was setup and was previously observing notification on this name, `NO` otherwise.
 */
- (BOOL)to_stopObservingNotificationsForAppGroup:(NSString *)groupIdentifier named:(NSString *)name;

@end


#pragma mark - Convenince posting methods

// receiver is used as the payload
// not methods on NSObject since not all objects are plist compatible, perhaps support NSCoding too? instead?
// alternately use TOAppGroupObservation class methods postNotificationNamed:payload: or postNotificationForAppGroup:named:payload:

@interface NSData (TotalObserverAppGroup)
- (void)to_postWithinAppGroupNotificationNamed:(NSString *)name;
- (void)to_postWithinNotificationToAppGroup:(NSString *)groupIdentifier named:(NSString *)name;
@end

@interface NSString (TotalObserverAppGroup)
- (void)to_postWithinAppGroupNotificationNamed:(NSString *)name;
- (void)to_postWithinNotificationToAppGroup:(NSString *)groupIdentifier named:(NSString *)name;
@end

@interface NSArray (TotalObserverAppGroup)
- (void)to_postWithinAppGroupNotificationNamed:(NSString *)name;
- (void)to_postWithinNotificationToAppGroup:(NSString *)groupIdentifier named:(NSString *)name;
@end

@interface NSDictionary (TotalObserverAppGroup)
- (void)to_postWithinAppGroupNotificationNamed:(NSString *)name;
- (void)to_postWithinNotificationToAppGroup:(NSString *)groupIdentifier named:(NSString *)name;
@end

@interface NSDate (TotalObserverAppGroup)
- (void)to_postWithinAppGroupNotificationNamed:(NSString *)name;
- (void)to_postWithinNotificationToAppGroup:(NSString *)groupIdentifier named:(NSString *)name;
@end

@interface NSNumber (TotalObserverAppGroup)
- (void)to_postWithinAppGroupNotificationNamed:(NSString *)name;
- (void)to_postWithinNotificationToAppGroup:(NSString *)groupIdentifier named:(NSString *)name;
@end

#if __has_feature(nullability)
NS_ASSUME_NONNULL_END
#endif
#undef TO_nullable
