//
//  NSObject+TotalObserverNotifications.h
//  TotalObserver
//
//  Created by Pierre Houston on 2016-01-07.
//  Copyright © 2016 Pierre Houston. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TONotificationObservation.h"

#if __has_feature(nullability)
NS_ASSUME_NONNULL_BEGIN
#define TO_nullable nullable
#else
#define TO_nullable
#endif

@interface NSObject (TotalObserverNotifications)

#pragma mark - Observe notifications from object

/**
 *  Receiver observes notifications posted with given name by a given object.
 *
 *  Details about the posted notification that triggered the observation can be found within the `notification`,
 *  and `userInfo` properties of the observation when the block is called.
 *
 *  The observation will automatically be stopped when either the receiver or the object is deallocated.
 *
 *  If `object` is the same as the receiver, then instead use `to_observeOwnNotificationsNamed:withBlock:`.
 *
 *  @param object The object to observe.
 *  @param name   The notification name to observe.
 *  @param block  The block to call when observation is triggered, is passed the receiver (which can be used in place of
 *                a weakly captured self), and the observation (same as method result).
 *
 *  @return An observation object. You often don't need to keep this result.
 */
- (TO_nullable TONotificationObservation *)to_observeForNotifications:(id)object named:(NSString *)name withBlock:(TOObservationBlock)block;

/**
 *  Receiver observes notifications posted with given name by a given object, calling its block on the given operation
 *  queue.
 *
 *  Variation on `to_observeForNotifications:named:withBlock:` that adds a operation queue parameter. See the description
 *  for that method.
 *
 *  @param object The object to observe.
 *  @param name   The notification name to observe.
 *  @param queue  The operation queue on which to call `block`.
 *  @param block  The block to call when observation is triggered, is passed the receiver (which can be used in place of
 *                a weakly captured self), and the observation (same as method result).
 *
 *  @return An observation object. You often don't need to keep this result.
 */
- (TO_nullable TONotificationObservation *)to_observeForNotifications:(id)object named:(NSString *)name onQueue:(NSOperationQueue *)queue withBlock:(TOObservationBlock)block;

/**
 *  Receiver observes notifications posted with given name by a given object, calling its block on the given GCD
 *  dispatch queue.
 *
 *  Variation on `to_observeForNotifications:named:withBlock:` that adds a GCD dispatch queue parameter. See the description
 *  for that method.
 *
 *  @param object The object to observe.
 *  @param name   The notification name to observe.
 *  @param queue  The CGD dispatch queue on which to call `block`.
 *  @param block  The block to call when observation is triggered, is passed the receiver (which can be used in place of
 *                a weakly captured self), and the observation (same as method result).
 *
 *  @return An observation object. You often don't need to keep this result.
 */
- (TO_nullable TONotificationObservation *)to_observeForNotifications:(id)object named:(NSString *)name onGCDQueue:(dispatch_queue_t)queue withBlock:(TOObservationBlock)block;


/**
 *  Receiver stops observing notifications posted with given name by a given object.
 *
 *  Call on the same object on which you called one of the `to_observe..` methods above. Use to stop observing sometime
 *  before the receiver or the observed object is deallocated. Alternately, can save the observation object returned from
 *  the `to_observe..` method, and call its `remove` method.
 *
 *  @param object The object to stop observing.
 *  @param name   The notification name to stop observing.
 *
 *  @return `YES` if the receiver was previously observing notifications named `name` by `object`, `NO` otherwise.
 */
- (BOOL)to_stopObservingForNotifications:(id)object named:(NSString *)name;


#pragma mark - Observe notifications from any object

/**
 *  Receiver observes notifications posted with given name by any object.
 *
 *  Details about the posted notification that triggered the observation can be found within the `notification`,
 *  `postedObject`, and `userInfo` properties of the observation when the block is called.
 *
 *  The observation will automatically be stopped when either the receiver is deallocated.
 *
 *  @param name  The notification name to observe.
 *  @param block The block to call when observation is triggered, is passed the receiver (which can be used in place of
 *               a weakly captured self), and the observation (same as method result).
 *
 *  @return An observation object. You often don't need to keep this result.
 */
- (TO_nullable TONotificationObservation *)to_observeAllNotificationsNamed:(NSString *)name withBlock:(TOObservationBlock)block;

/**
 *  Receiver observes notifications posted with given name by any observer, calling its block on the given operation queue.
 *
 *  Variation on `to_observeAllNotificationsNamed:withBlock:` that adds an operation queue parameter. See the description
 *  for that method.
 *
 *  @param name  The notification name to observe.
 *  @param queue The operation queue on which to call `block`.
 *  @param block The block to call when observation is triggered, is passed the receiver (which can be used in place of
 *               a weakly captured self), and the observation (same as method result).
 *
 *  @return An observation object. You often don't need to keep this result.
 */
- (TO_nullable TONotificationObservation *)to_observeAllNotificationsNamed:(NSString *)name onQueue:(NSOperationQueue *)queue withBlock:(TOObservationBlock)block;

/**
 *  Receiver observes notifications posted with given name by any observer, calling its block on the given GCD dispatch
 *  queue.
 *
 *  Variation on `to_observeAllNotificationsNamed:withBlock:` that adds a GCD dispatch queue parameter. See the description
 *  for that method.
 *
 *  @param name  The notification name to observe.
 *  @param queue The CGD dispatch queue on which to call `block`.
 *  @param block The block to call when observation is triggered, is passed the receiver (which can be used in place of
 *               a weakly captured self), and the observation (same as method result).
 *
 *  @return An observation object. You often don't need to keep this result.
 */
- (TO_nullable TONotificationObservation *)to_observeAllNotificationsNamed:(NSString *)name onGCDQueue:(dispatch_queue_t)queue withBlock:(TOObservationBlock)block;


/**
 *  Receiver stops observing notifications posted with given name by a given object.
 *
 *  Call on the same object on which you called one of the `to_observe..` methods above. Use to stop observing sometime
 *  before the receiver is deallocated. Alternately, can save the observation object returned from the `to_observe..`
 *  method, and call its `remove` method.
 *
 *  @param name The notification name to stop observing.
 *
 *  @return `YES` if the receiver was previously observing notifications named `name` by any object, `NO` otherwise.
 */
- (BOOL)to_stopObservingAllNotificationsNamed:(NSString *)name;


#pragma mark - Anonymously observe notifications from object

/**
 *  Observe notifications posted with given name by the receiver.
 *
 *  Details about the posted notification that triggered the observation can be found within the `notification`,
 *  and `userInfo` properties of the observation when the block is called.
 *
 *  The observation will automatically be stopped when either the receiver is deallocated.  The observation is not tied to
 *  any "observer" object.
 *
 *  @param name  The notification name to observe.
 *  @param block The block to call when the key path observation is triggered, is passed the observation (same as the
 *               method result).
 *
 *  @return An observation object. You often don't need to keep this result.
 */
- (TO_nullable TONotificationObservation *)to_observeNotificationsNamed:(NSString *)name withBlock:(TOAnonymousObservationBlock)block;

/**
 *  Observe notifications posted with given name by the receiver, calling its block on the given operation queue.
 *
 *  Variation on `to_observeNotificationsNamed:withBlock:` that adds an operation queue parameter. See the description
 *  for that method.
 *
 *  @param name  The notification name to observe.
 *  @param queue The operation queue on which to call `block`.
 *  @param block The block to call when the key path observation is triggered, is passed the observation (same as the 
 *               method result).
 *
 *  @return An observation object. You often don't need to keep this result.
 */
- (TO_nullable TONotificationObservation *)to_observeNotificationsNamed:(NSString *)name onQueue:(NSOperationQueue *)queue withBlock:(TOAnonymousObservationBlock)block;

/**
 *  Observe notifications posted with given name by the receiver, calling its block on the given GCD dispatch queue.
 *
 *  Variation on `to_observeNotificationsNamed:withBlock:` that adds a GCD dispatch queue parameter. See the description
 *  for that method.
 *
 *  @param name  The notification name to observe.
 *  @param queue The CGD dispatch queue on which to call `block`.
 *  @param block The block to call when the key path observation is triggered, is passed the observation (same as the
 *               method result).
 *
 *  @return An observation object. You often don't need to keep this result.
 */
- (TO_nullable TONotificationObservation *)to_observeNotificationsNamed:(NSString *)name onGCDQueue:(dispatch_queue_t)queue withBlock:(TOAnonymousObservationBlock)block;


/**
 *  Stops observing notifications posted with given name by the receiver.
 *
 *  Call on the same object on which you called one of the `to_observe..` methods above. Use to stop observing sometime
 *  before the receiver is deallocated. Alternately, can save the observation object returned from the `to_observe..`
 *  method, and call its `remove` method.
 *
 *  @param name The notification name to stop observing.
 *
 *  @return `YES` if was previously observing notifications named `name` by the receiver, `NO` otherwise.
 */
- (BOOL)to_stopObservingNotificationsNamed:(NSString *)name;


#pragma mark - Have receiver observe notifications from itself

/**
 *  Receiver observes notifications it posts with given name.
 *
 *  Details about the posted notification that triggered the observation can be found within the `notification`,
 *  and `userInfo` properties of the observation when the block is called.
 *
 *  The observation will automatically be stopped when either the receiver is deallocated.
 *
 *  Use instead of `-[self to_observeNotificationsNamed:withBlock:]` when you want the receiver passed as parameter to
 *  the block, or when you want to make extra clear that the object is intentionally observing itself.
 *
 *  @param name  The notification name to observe.
 *  @param block The block to call when observation is triggered, is passed the receiver (which can be used in place of
 *               a weakly captured self), and the observation (same as method result).
 *
 *  @return An observation object. You often don't need to keep this result.
 */
- (TO_nullable TONotificationObservation *)to_observeOwnNotificationsNamed:(NSString *)name withBlock:(TOObservationBlock)block;

/**
 *  Receiver observes notifications it posts with given name, calling its block on the given operation queue.
 *
 *  Variation on `to_observeOwnNotificationsNamed:withBlock:` that adds an operation queue parameter. See the description
 *  for that method.
 *
 *  @param name  The notification name to observe.
 *  @param queue The operation queue on which to call `block`.
 *  @param block The block to call when observation is triggered, is passed the receiver (which can be used in place of
 *               a weakly captured self), and the observation (same as method result).
 *
 *  @return An observation object. You often don't need to keep this result.
 */
- (TO_nullable TONotificationObservation *)to_observeOwnNotificationsNamed:(NSString *)name onQueue:(NSOperationQueue *)queue withBlock:(TOObservationBlock)block;

/**
 *  Receiver observes notifications it posts with given name, calling its block on the given GCD dispatch queue.
 *
 *  Variation on `to_observeOwnNotificationsNamed:withBlock:` that adds a GCD dispatch queue parameter. See the description
 *  for that method.
 *
 *  @param name  The notification name to observe.
 *  @param queue The CGD dispatch queue on which to call `block`.
 *  @param block The block to call when observation is triggered, is passed the receiver (which can be used in place of
 *               a weakly captured self), and the observation (same as method result).
 *
 *  @return An observation object. You often don't need to keep this result.
 */
- (TO_nullable TONotificationObservation *)to_observeOwnNotificationsNamed:(NSString *)name onGCDQueue:(dispatch_queue_t)queue withBlock:(TOObservationBlock)block;


/**
 *  Receiver stops observing notifications it posts with given name.
 *
 *  Call on the same object on which you called one of the `to_observe..` methods above. Use to stop observing sometime
 *  before the receiver is deallocated. Alternately, can save the observation object returned from the `to_observe..`
 *  method, and call its `remove` method.
 *
 *  @param name The notification name to stop observing.
 *
 *  @return `YES` if was receiver previously observing notifications named `name` by itself, `NO` otherwise.
 */
- (BOOL)to_stopObservingOwnNotificationsNamed:(NSString *)name;


#pragma mark - Convenince posting methods

/**
 *  Post notification with a given name by the receiver.
 *
 *  @param name The notification name to post.
 */
- (void)to_postNotificationNamed:(NSString *)name;

/**
 *  Post notification with a given name by the receiver, with the given user info dictionary.
 *
 *  @param name     The notification name to post.
 *  @param userInfo The user info dictionary to include.
 */
- (void)to_postNotificationNamed:(NSString *)name userInfo:(TO_nullable NSDictionary *)userInfo;

@end

#if __has_feature(nullability)
NS_ASSUME_NONNULL_END
#endif
#undef TO_nullable
