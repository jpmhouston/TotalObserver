//
//  NSObject+TotalObserverKVO.h
//  TotalObserver
//
//  Created by Pierre Houston on 2016-01-07.
//  Copyright © 2016 Pierre Houston. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TOKVOObservation.h"

#if __has_feature(nullability)
NS_ASSUME_NONNULL_BEGIN
#define TO_nullable nullable
#else
#define TO_nullable
#endif

@interface NSObject (TotalObserverKVO)

#pragma mark - Observe a key path

/**
 *  Receiver observes a KVO key path on the given object.
 *
 *  Details about the what triggered the observation can be found within the `changeDict`, `kind`, `changedValue`,
 *  and `oldValue` properties of the observation when the block is called.
 *
 *  The observation will automatically be stopped when either the receiver or the object is deallocated.
 *
 *  If `object` is the same as the receiver, then instead use `to_observeOwnChangesToKeyPath:withBlock:`.
 *
 *  @param object  The object to observe.
 *  @param keyPath The key path string to observe on `object`.
 *  @param block   The block to call when the observation is triggered, is passed the receiver (which can be used
 *                 in place of a weakly captured self), and the observation (same as method result).
 *
 *  @return An observation object. You often don't need to keep this result.
 */
- (TO_nullable TOKVOObservation *)to_observeForChanges:(id)object toKeyPath:(NSString *)keyPath withBlock:(TOObservationBlock)block;

/**
 *  Receiver observes a KVO key path on the given object with options.
 *
 *  Variation on `to_observeForChanges:toKeyPath:withBlock:` that adds a KVO options parameter. See the description for
 *  that method.
 *
 *  @param object  The object to observe.
 *  @param keyPath The key path string to observe on `object`.
 *  @param options The KVO observation options.
 *  @param block   The block to call when the observation is triggered, is passed the receiver (which can be used
 *                 in place of a weakly captured self), and the observation (same as method result).
 *
 *  @return An observation object. You often don't need to keep this result.
 */
- (TO_nullable TOKVOObservation *)to_observeForChanges:(id)object toKeyPath:(NSString *)keyPath options:(int)options withBlock:(TOObservationBlock)block;

/**
 *  Receiver observes a KVO key path on the given object, calling its block on the given operation queue.
 *
 *  Variation on `to_observeForChanges:toKeyPath:withBlock:` that adds an operation queue parameter. See the description
 *  for that method.
 *
 *  @param object  The object to observe.
 *  @param keyPath The key path string to observe on `object`.
 *  @param queue   The operation queue on which to call `block`.
 *  @param block   The block to call when the observation is triggered, is passed the receiver (which can be used
 *                 in place of a weakly captured self), and the observation (same as method result).
 *
 *  @return An observation object. You often don't need to keep this result.
 */
- (TO_nullable TOKVOObservation *)to_observeForChanges:(id)object toKeyPath:(NSString *)keyPath onQueue:(NSOperationQueue *)queue withBlock:(TOObservationBlock)block;

/**
 *  Receiver observes a KVO key path on the given object with options, calling its block on the given operation queue.
 *
 *  Variation on `to_observeForChanges:toKeyPath:withBlock:` that adds operation queue and KVO options parameters.
 *  See the description for that method.
 *
 *  @param object  The object to observe.
 *  @param keyPath The key path string to observe on `object`.
 *  @param options The KVO observation options.
 *  @param queue   The operation queue on which to call `block`.
 *  @param block   The block to call when the observation is triggered, is passed the receiver (which can be used
 *                 in place of a weakly captured self), and the observation (same as method result).
 *
 *  @return An observation object. You often don't need to keep this result.
 */
- (TO_nullable TOKVOObservation *)to_observeForChanges:(id)object toKeyPath:(NSString *)keyPath options:(int)options onQueue:(NSOperationQueue *)queue withBlock:(TOObservationBlock)block;

/**
 *  Receiver observes a KVO key path on the given object, calling its block on the given GCD dispatch queue.
 *
 *  Variation on `to_observeForChanges:toKeyPath:withBlock:` that adds an operation queue parameter. See the description
 *  for that method.
 *
 *  @param object  The object to observe.
 *  @param keyPath The key path string to observe on `object`.
 *  @param queue   The GCD dispatch queue. on which to call `block`.
 *  @param block   The block to call when the observation is triggered, is passed the receiver (which can be used
 *                 in place of a weakly captured self), and the observation (same as method result).
 *
 *  @return An observation object. You often don't need to keep this result.
 */
- (TO_nullable TOKVOObservation *)to_observeForChanges:(id)object toKeyPath:(NSString *)keyPath onGCDQueue:(dispatch_queue_t)queue withBlock:(TOObservationBlock)block;

/**
 *  Receiver observes a KVO key path on the given object with options, calling its block on the given GCD dispatch queue.
 *
 *  Variation on `to_observeForChanges:toKeyPath:withBlock:` that adds operation queue and KVO options parameters.
 *  See the description for that method.
 *
 *  @param object  The object to observe.
 *  @param keyPath The key path string to observe on `object`.
 *  @param options The KVO observation options.
 *  @param queue   The GCD dispatch queue on which to call `block`.
 *  @param block   The block to call when the observation is triggered, is passed the receiver (which can be used
 *                 in place of a weakly captured self), and the observation (same as method result).
 *
 *  @return An observation object. You often don't need to keep this result.
 */
- (TO_nullable TOKVOObservation *)to_observeForChanges:(id)object toKeyPath:(NSString *)keyPath options:(int)options onGCDQueue:(dispatch_queue_t)queue withBlock:(TOObservationBlock)block;


/**
 *  Receiver stops observing a KVO key path on the given object.
 *
 *  Call on the same object on which you called one of the `to_observe..` methods above. Use to stop observing sometime
 *  before the receiver or the observed object is deallocated. Alternately, can save the observation object returned from the
 *  `to_observe..` method, and call its `remove` method.
 *
 *  @param object  The object to stop observing.
 *  @param keyPath The key path string to stop observing on `object`.
 *
 *  @return `YES` if the receiver was previously observing this KVO key path on `object`, `NO` otherwise.
 */
- (BOOL)to_stopObservingForChanges:(id)object toKeyPath:(NSString *)keyPath;


#pragma mark - Observe multiple key paths

/**
 *  Receiver observes multiple KVO key paths on the given object.
 *
 *  Details about the what triggered the observation can be found within the `changeDict`, `kind`, `changedValue`,
 *  and `oldValue` properties of the observation when the block is called. Also, which specific key path is triggered
 *  can be found within its `keyPath` property.
 *
 *  The observations will automatically be stopped when either the receiver or the object is deallocated.
 *
 *  If `object` is the same as the receiver, then instead use `to_observeOwnChangesToKeyPaths:withBlock:`.
 *
 *  @param object   The object to observe.
 *  @param keyPaths Array of key path strings to observe on `object`.
 *  @param block    The block to call when any of the key path observations are triggered, is passed the receiver
 *                  (which can be used in place of a weakly captured self), and the observation (same as method result).
 *
 *  @return An object representing observations of all key paths combined. You often don't need to keep this result.
 */
- (TO_nullable TOKVOObservation *)to_observeForChanges:(id)object toKeyPaths:(NSArray *)keyPaths withBlock:(TOObservationBlock)block;

/**
 *  Receiver observes multiple KVO key paths on the given object with options.
 *
 *  Variation on `to_observeForChanges:toKeyPaths:withBlock:` that adds a KVO options parameter. See the description for
 *  that method.
 *
 *  @param object   The object to observe.
 *  @param keyPaths Array of key path strings to observe on `object`.
 *  @param options  The KVO observation options.
 *  @param block    The block to call when any of the key path observations are triggered, is passed the receiver
 *                  (which can be used in place of a weakly captured self), and the observation (same as method result).
 *
 *  @return An object representing observations of all key paths combined. You often don't need to keep this result.
 */
- (TO_nullable TOKVOObservation *)to_observeForChanges:(id)object toKeyPaths:(NSArray *)keyPaths options:(int)options withBlock:(TOObservationBlock)block;

/**
 *  Receiver observes multiple KVO key paths on the given object, calling its block on the given operation queue.
 *
 *  Variation on `to_observeForChanges:toKeyPaths:withBlock:` that adds an operation queue parameter. See the description
 *  for that method.
 *
 *  @param object   The object to observe.
 *  @param keyPaths Array of key path strings to observe on `object`.
 *  @param queue    The operation queue on which to call `block`.
 *  @param block    The block to call when any of the key path observations are triggered, is passed the receiver
 *                  (which can be used in place of a weakly captured self), and the observation (same as method result).
 *
 *  @return An object representing observations of all key paths combined. You often don't need to keep this result.
 */
- (TO_nullable TOKVOObservation *)to_observeForChanges:(id)object toKeyPaths:(NSArray *)keyPaths onQueue:(NSOperationQueue *)queue withBlock:(TOObservationBlock)block;

/**
 *  Receiver observes multiple KVO key paths on the given object with options, calling its block on the given operation queue.
 *
 *  Variation on `to_observeForChanges:toKeyPaths:withBlock:` that adds operation queue and KVO options parameters.
 *  See the description for that method.
 *
 *  @param object   The object to observe.
 *  @param keyPaths Array of key path strings to observe on `object`.
 *  @param options  The KVO observation options.
 *  @param queue    The operation queue on which to call `block`.
 *  @param block    The block to call when any of the key path observations are triggered, is passed the receiver
 *                  (which can be used in place of a weakly captured self), and the observation (same as method result).
 *
 *  @return An object representing observations of all key paths combined. You often don't need to keep this result.
 */
- (TO_nullable TOKVOObservation *)to_observeForChanges:(id)object toKeyPaths:(NSArray *)keyPaths options:(int)options onQueue:(NSOperationQueue *)queue withBlock:(TOObservationBlock)block;

/**
 *  Receiver observes multiple KVO key paths on the given object, calling its block on the given CGD dispatch queue.
 *
 *  Variation on `to_observeForChanges:toKeyPaths:withBlock:` that adds a GCD dispatch queue parameter. See the description
 *  for that method.
 *
 *  @param object   The object to observe.
 *  @param keyPaths Array of key path strings to observe on `object`.
 *  @param queue    The CGD dispatch queue on which to call `block`.
 *  @param block    The block to call when any of the key path observations are triggered, is passed the receiver
 *                  (which can be used in place of a weakly captured self), and the observation (same as method result).
 *
 *  @return An object representing observations of all key paths combined. You often don't need to keep this result.
 */
- (TO_nullable TOKVOObservation *)to_observeForChanges:(id)object toKeyPaths:(NSArray *)keyPaths onGCDQueue:(dispatch_queue_t)queue withBlock:(TOObservationBlock)block;

/**
 *  Receiver observes multiple KVO key paths on the given object with options, calling its block on the given CGD dispatch queue.
 *
 *  Variation on `to_observeForChanges:toKeyPaths:withBlock:` that adds operation queue and GCD dispatch parameters.
 *  See the description for that method.
 *
 *  @param object   The object to observe.
 *  @param keyPaths Array of key path strings to observe on `object`.
 *  @param options  The KVO observation options.
 *  @param queue    The CGD dispatch queue on which to call `block`.
 *  @param block    The block to call when any of the key path observations are triggered, is passed the receiver
 *                  (which can be used in place of a weakly captured self), and the observation (same as method result).
 *
 *  @return An object representing observations of all key paths combined. You often don't need to keep this result.
 */
- (TO_nullable TOKVOObservation *)to_observeForChanges:(id)object toKeyPaths:(NSArray *)keyPaths options:(int)options onGCDQueue:(dispatch_queue_t)queue withBlock:(TOObservationBlock)block;


/**
 *  Receiver stops observing the KVO key paths on the given object.
 *
 *  Call on the same object on which you called one of the `to_observe..` methods above. Use to stop observing sometime
 *  before the receiver or the observed object is deallocated. Alternately, can save the observation object returned from the
 *  `to_observe..` method, and call its `remove` method.
 *
 *  @param object   The object to stop observing.
 *  @param keyPaths The array of KVO key path strings to stop observing on `object`. Must be equal to the array passed to the
 *                  corresponding `to_observe..` method.
 *
 *  @return `YES` if the receiver was previously observing these KVO key paths on `object`, `NO` otherwise.
 */
- (BOOL)to_stopObservingForChanges:(id)object toKeyPaths:(NSArray *)keyPaths;


#pragma mark - Anonymously observe a key path on the receiver

/**
 *  Observe a KVO key path on the receiver.
 *
 *  Details about the what triggered the observation can be found within the `changeDict`, `kind`, `changedValue`,
 *  and `oldValue` properties of the observation when the block is called.
 *
 *  The observation will automatically be stopped when the receiver is deallocated. The observation is not tied to any
 *  "observer" object.
 *
 *  @param keyPath The key path string to observe on the receiver.
 *  @param block   The block to call when the key path observation is triggered, is passed the observation (same as the
 *                 method result).
 *
 *  @return An observation object. You often don't need to keep this result.
 */
- (TO_nullable TOKVOObservation *)to_observeChangesToKeyPath:(NSString *)keyPath withBlock:(TOAnonymousObservationBlock)block;

/**
 *  Observe a KVO key path on the receiver with options.
 *
 *  Variation on `to_observeChangesToKeyPath:withBlock:` that adds a KVO options parameter. See the description for that
 *  method.
 *
 *  @param keyPath The key path string to observe on the receiver.
 *  @param options The KVO observation options.
 *  @param block   The block to call when the key path observation is triggered, is passed the observation (same as the
 *                 method result).
 *
 *  @return An observation object. You often don't need to keep this result.
 */
- (TO_nullable TOKVOObservation *)to_observeChangesToKeyPath:(NSString *)keyPath options:(int)options withBlock:(TOAnonymousObservationBlock)block;

/**
 *  Observe a KVO key path on the receiver, calling its block on the given operation queue.
 *
 *  Variation on `to_observeChangesToKeyPath:withBlock:` that adds a operation queue parameter. See the description for that
 *  method.
 *
 *  @param keyPath The key path string to observe on the receiver.
 *  @param queue   The operation queue on which to call `block`.
 *  @param block   The block to call when the key path observation is triggered, is passed the observation (same as the
 *                 method result).
 *
 *  @return An observation object. You often don't need to keep this result.
 */
- (TO_nullable TOKVOObservation *)to_observeChangesToKeyPath:(NSString *)keyPath onQueue:(NSOperationQueue *)queue withBlock:(TOAnonymousObservationBlock)block;

/**
 *  Observe a KVO key path on the receiver with options, calling its block on the given operation queue.
 *
 *  Variation on `to_observeChangesToKeyPath:withBlock:` that adds KVO options and operation queue parameters. See the
 *  description for that method.
 *
 *  @param keyPath The key path string to observe on the receiver.
 *  @param options The KVO observation options.
 *  @param queue   The operation queue on which to call `block`.
 *  @param block   The block to call when the key path observation is triggered, is passed the observation (same as the
 *                 method result).
 *
 *  @return An observation object. You often don't need to keep this result.
 */
- (TO_nullable TOKVOObservation *)to_observeChangesToKeyPath:(NSString *)keyPath options:(int)options onQueue:(NSOperationQueue *)queue withBlock:(TOAnonymousObservationBlock)block;

/**
 *  Observe a KVO key path on the receiver, calling its block on the given GCD dispatch queue.
 *
 *  Variation on `to_observeChangesToKeyPath:withBlock:` that adds a GCD dispatch queue parameter. See the description for
 *  that method.
 *
 *  @param keyPath The key path string to observe on the receiver.
 *  @param queue   The GCD dispatch queue on which to call `block`.
 *  @param block   The block to call when the key path observation is triggered, is passed the observation (same as the
 *                 method result).
 *
 *  @return An observation object. You often don't need to keep this result.
 */
- (TO_nullable TOKVOObservation *)to_observeChangesToKeyPath:(NSString *)keyPath onGCDQueue:(dispatch_queue_t)queue withBlock:(TOAnonymousObservationBlock)block;

/**
 *  Observe a KVO key path on the receiver with options, calling its block on the given GCD dispatch queue.
 *
 *  Variation on `to_observeChangesToKeyPath:withBlock:` that adds KVO options and GCD dispatch queue parameters. See the
 *  description for that method.
 *
 *  @param keyPath The key path string to observe on the receiver.
 *  @param options The KVO observation options.
 *  @param queue   The GCD dispatch queue on which to call `block`.
 *  @param block   The block to call when the key path observation is triggered, is passed the observation (same as the
 *                 method result).
 *
 *  @return An observation object. You often don't need to keep this result.
 */
- (TO_nullable TOKVOObservation *)to_observeChangesToKeyPath:(NSString *)keyPath options:(int)options onGCDQueue:(dispatch_queue_t)queue withBlock:(TOAnonymousObservationBlock)block;


/**
 *  Stop observing a KVO key path on the receiver.
 *
 *  Call on the same observed object on which you called one of the `to_observe..` methods above. Use to stop observing
 *  sometime before the object is deallocated. Alternately, can save the observation object returned from the
 *  `to_observe..` method, and call its `remove` method.
 *
 *  @param keyPath The key path string to stop observing the receiver.
 *
 *  @return `YES` if was previously observing this KVO key path on the receiver, `NO` otherwise.
 */
- (BOOL)to_stopObservingChangesToKeyPath:(NSString *)keyPath;


#pragma mark - Anonymously observe multiple key paths on the receiver

/**
 *  Observe multiple KVO key paths on the receiver.
 *
 *  Details about the what triggered the observation can be found within the `changeDict`, `kind`, `changedValue`,
 *  and `oldValue` properties of the observation when the block is called. Also, which specific key path is triggered
 *  can be found within its `keyPath` property.
 *
 *  The observation will automatically be stopped when the receiver is deallocated. The observation is not tied to any
 *  "observer" object.
 *
 *  @param keyPaths Array of key path strings to observe on `object`.
 *  @param block    The block to call when any of the key path observations are triggered, is passed the observation (same
 *                  as the method result).
 *
 *  @return An observation object. You often don't need to keep this result.
 */
- (TO_nullable TOKVOObservation *)to_observeChangesToKeyPaths:(NSArray *)keyPaths withBlock:(TOAnonymousObservationBlock)block;

/**
 *  Observe multiple KVO key paths on the receiver with options.
 *
 *  Variation on `to_observeChangesToKeyPaths:withBlock:` that adds a KVO options parameter. See the description for
 *  that method.
 *
 *  @param keyPaths Array of key path strings to observe on `object`.
 *  @param options  The KVO observation options.
 *  @param block    The block to call when any of the key path observations are triggered, is passed the observation (same
 *                  as the method result).
 *
 *  @return An object representing observations of all key paths combined. You often don't need to keep this result.
 */
- (TO_nullable TOKVOObservation *)to_observeChangesToKeyPaths:(NSArray *)keyPaths options:(int)options withBlock:(TOAnonymousObservationBlock)block;

/**
 *  Observe multiple KVO key paths on the receiver, calling its block on the given operation queue.
 *
 *  @param keyPaths Array of key path strings to observe on `object`.
 *  @param queue    The operation queue on which to call `block`.
 *  @param block    The block to call when any of the key path observations are triggered, is passed the observation (same
 *                  as the method result).
 *
 *  @return An object representing observations of all key paths combined. You often don't need to keep this result.
 */
- (TO_nullable TOKVOObservation *)to_observeChangesToKeyPaths:(NSArray *)keyPaths onQueue:(NSOperationQueue *)queue withBlock:(TOAnonymousObservationBlock)block;

/**
 *  Observe multiple KVO key paths on the receiver with options, calling its block on the given operation queue.
 *
 *  @param keyPaths Array of key path strings to observe on `object`.
 *  @param options  The KVO observation options.
 *  @param queue    The operation queue on which to call `block`.
 *  @param block    The block to call when any of the key path observations are triggered, is passed the observation (same
 *                  as the method result).
 *
 *  @return An object representing observations of all key paths combined. You often don't need to keep this result.
 */
- (TO_nullable TOKVOObservation *)to_observeChangesToKeyPaths:(NSArray *)keyPaths options:(int)options onQueue:(NSOperationQueue *)queue withBlock:(TOAnonymousObservationBlock)block;

/**
 *  Observe multiple KVO key paths on the receiver, calling its block on the given GCD dispatch queue.
 *
 *  @param keyPaths Array of key path strings to observe on `object`.
 *  @param queue    The GCD dispatch queue on which to call `block`.
 *  @param block    The block to call when any of the key path observations are triggered, is passed the observation (same
 *                  as the method result).
 *
 *  @return An object representing observations of all key paths combined. You often don't need to keep this result.
 */
- (TO_nullable TOKVOObservation *)to_observeChangesToKeyPaths:(NSArray *)keyPaths onGCDQueue:(dispatch_queue_t)queue withBlock:(TOAnonymousObservationBlock)block;

/**
 *  Observe multiple KVO key paths on the receiver with options, calling its block on the given GCD dispatch queue.
 *
 *  @param keyPaths Array of key path strings to observe on `object`.
 *  @param options  The KVO observation options.
 *  @param queue    The GCD dispatch queue on which to call `block`.
 *  @param block    The block to call when any of the key path observations are triggered, is passed the observation (same
 *                  as the method result).
 *
 *  @return An object representing observations of all key paths combined. You often don't need to keep this result.
 */
- (TO_nullable TOKVOObservation *)to_observeChangesToKeyPaths:(NSArray *)keyPaths options:(int)options onGCDQueue:(dispatch_queue_t)queue withBlock:(TOAnonymousObservationBlock)block;


/**
 *  Receiver stops observing the KVO key paths on the receiver.
 *
 *  Call on the same observed object on which you called one of the `to_observe..` methods above. Use to stop observing
 *  sometime before the object is deallocated. Alternately, can save the observation object returned from the `to_observe..`
 *  method, and call its `remove` method.
 *
 *  @param keyPaths The array of KVO key path strings to stop observing on `object`. Must be equal to the array passed to the
 *                  corresponding `to_observe..` method.
 *
 *  @return `YES` if was previously observing these KVO key paths on the receiver, `NO` otherwise.
 */
- (BOOL)to_stopObservingChangesToKeyPaths:(NSArray *)keyPaths;


#pragma mark - Have receiver observe a key path on itself

/**
 *  Receiver observes a KVO key path on itself.
 *
 *  Details about the what triggered the observation can be found within the `changeDict`, `kind`, `changedValue`,
 *  and `oldValue` properties of the observation when the block is called.
 *
 *  The observation will automatically be stopped when the receiver is deallocated. The observation is not tied to any
 *  "observer" object.
 *
 *  Use instead of `-[self to_observeChangesToKeyPath:withBlock:]` when you want the receiver passed as parameter to the
 *  block, or when you want to make extra clear that the object is intentionally observing itself.
 *
 *  @param keyPath The key path string to observe on the receiver.
 *  @param block   The block to call when the observation is triggered, is passed the receiver (which can be used in place
 *                 of a weakly captured self), and the observation (same as method result).
 *
 *  @return An observation object. You often don't need to keep this result.
 */
- (TO_nullable TOKVOObservation *)to_observeOwnChangesToKeyPath:(NSString *)keyPath withBlock:(TOObservationBlock)block;

/**
 *  Receiver observes a KVO key path on itself with options.
 *
 *  Variation on `to_observeOwnChangesToKeyPath:withBlock:` that adds a KVO options parameter. See the description for that
 *  method.
 *
 *  @param keyPath The key path string to observe on the receiver.
 *  @param options The KVO observation options.
 *  @param block   The block to call when the observation is triggered, is passed the receiver (which can be used in place
 *                 of a weakly captured self), and the observation (same as method result).
 *
 *  @return An observation object. You often don't need to keep this result.
 */
- (TO_nullable TOKVOObservation *)to_observeOwnChangesToKeyPath:(NSString *)keyPath options:(int)options withBlock:(TOObservationBlock)block;

/**
 *  Receiver observes a KVO key path on itself, calling its block on the given operation queue.
 *
 *  Variation on `to_observeOwnChangesToKeyPath:withBlock:` that adds an operation queue parameter. See the description for
 *  that method.
 *
 *  @param keyPath The key path string to observe on the receiver.
 *  @param queue   The operation queue on which to call `block`.
 *  @param block   The block to call when the observation is triggered, is passed the receiver (which can be used in place
 *                 of a weakly captured self), and the observation (same as method result).
 *
 *  @return An observation object. You often don't need to keep this result.
 */
- (TO_nullable TOKVOObservation *)to_observeOwnChangesToKeyPath:(NSString *)keyPath onQueue:(NSOperationQueue *)queue withBlock:(TOObservationBlock)block;

/**
 *  Receiver observes a KVO key path on itself with options, calling its block on the given operation queue.
 *
 *  @param keyPath The key path string to observe on the receiver.
 *  @param options The KVO observation options.
 *  @param queue   The operation queue on which to call `block`.
 *  @param block   The block to call when the observation is triggered, is passed the receiver (which can be used in place
 *                 of a weakly captured self), and the observation (same as method result).
 *
 *  @return An observation object. You often don't need to keep this result.
 */
- (TO_nullable TOKVOObservation *)to_observeOwnChangesToKeyPath:(NSString *)keyPath options:(int)options onQueue:(NSOperationQueue *)queue withBlock:(TOObservationBlock)block;

/**
 *  Receiver observes a KVO key path on itself, calling its block on the given GCD dispatch queue.
 *
 *  Variation on `to_observeOwnChangesToKeyPath:withBlock:` that adds a GCD dispatch queue parameter. See the description
 *  for that method.
 *
 *  @param keyPath The key path string to observe on the receiver.
 *  @param queue   The GCD dispatch queue on which to call `block`.
 *  @param block   The block to call when the observation is triggered, is passed the receiver (which can be used in place
 *                 of a weakly captured self), and the observation (same as method result).
 *
 *  @return An observation object. You often don't need to keep this result.
 */
- (TO_nullable TOKVOObservation *)to_observeOwnChangesToKeyPath:(NSString *)keyPath onGCDQueue:(dispatch_queue_t)queue withBlock:(TOObservationBlock)block;

/**
 *  Receiver observes a KVO key path on itself with options, calling its block on the given GCD dispatch queue.
 *
 *  @param keyPath The key path string to observe on the receiver.
 *  @param options The KVO observation options.
 *  @param queue   The GCD dispatch queue on which to call `block`.
 *  @param block   The block to call when the observation is triggered, is passed the receiver (which can be used in place
 *                 of a weakly captured self), and the observation (same as method result).
 *
 *  @return An observation object. You often don't need to keep this result.
 */
- (TO_nullable TOKVOObservation *)to_observeOwnChangesToKeyPath:(NSString *)keyPath options:(int)options onGCDQueue:(dispatch_queue_t)queue withBlock:(TOObservationBlock)block;


/**
 *  Receiver stops observing a KVO key path on itself.
 *
 *  Call on the same observed object on which you called one of the `to_observe..` methods above. Use to stop observing
 *  sometime before the object is deallocated. Alternately, can save the observation object returned from the
 *  `to_observe..` method, and call its `remove` method.
 *
 *  @param keyPath The key path string to stop observing the receiver.
 *
 *  @return `YES` if the receiver was previously observing this KVO key path on itself, `NO` otherwise.
 */
- (BOOL)to_stopObservingOwnChangesToKeyPath:(NSString *)keyPath;


#pragma mark - Have receiver observe multiple key paths on itself

/**
 *  Receiver observes multiple KVO key paths on itself.
 *
 *  Details about the what triggered the observation can be found within the `changeDict`, `kind`, `changedValue`,
 *  and `oldValue` properties of the observation when the block is called. Also, which specific key path is triggered
 *  can be found within its `keyPath` property.
 *
 *  The observation will automatically be stopped when the receiver is deallocated. The observation is not tied to any
 *  "observer" object.
 *
 *  Use instead of `-[self to_observeChangesToKeyPaths:withBlock:]` when you want the receiver passed as parameter to the
 *  block, or when you want to make extra clear that the object is intentionally observing itself.
 *
 *  @param keyPaths Array of key path strings to observe on `object`.
 *  @param block    The block to call when any of the key path observations are triggered, is passed the receiver
 *                  (which can be used in place of a weakly captured self), and the observation (same as method result).
 *
 *  @return An observation object. You often don't need to keep this result.
 */
- (TO_nullable TOKVOObservation *)to_observeOwnChangesToKeyPaths:(NSArray *)keyPaths withBlock:(TOObservationBlock)block;

/**
 *  Receiver observes multiple KVO key paths on itself with options.
 *
 *  @param keyPaths Array of key path strings to observe on `object`.
 *  @param options  The KVO observation options.
 *  @param block    The block to call when any of the key path observations are triggered, is passed the receiver
 *                  (which can be used in place of a weakly captured self), and the observation (same as method result).
 *
 *  @return An observation object. You often don't need to keep this result.
 */
- (TO_nullable TOKVOObservation *)to_observeOwnChangesToKeyPaths:(NSArray *)keyPaths options:(int)options withBlock:(TOObservationBlock)block;

/**
 *  Receiver observes multiple KVO key paths on itself, calling its block on the given operation queue.
 *
 *  @param keyPaths Array of key path strings to observe on `object`.
 *  @param queue    The operation queue on which to call `block`.
 *  @param block    The block to call when any of the key path observations are triggered, is passed the receiver
 *                  (which can be used in place of a weakly captured self), and the observation (same as method result).
 *
 *  @return An observation object. You often don't need to keep this result.
 */
- (TO_nullable TOKVOObservation *)to_observeOwnChangesToKeyPaths:(NSArray *)keyPaths onQueue:(NSOperationQueue *)queue withBlock:(TOObservationBlock)block;

/**
 *  Receiver observes multiple KVO key paths on itself with options, calling its block on the given operation queue.
 *
 *  @param keyPaths Array of key path strings to observe on `object`.
 *  @param options  The KVO observation options.
 *  @param queue    The operation queue on which to call `block`.
 *  @param block    The block to call when any of the key path observations are triggered, is passed the receiver
 *                  (which can be used in place of a weakly captured self), and the observation (same as method result).
 *
 *  @return An observation object. You often don't need to keep this result.
 */
- (TO_nullable TOKVOObservation *)to_observeOwnChangesToKeyPaths:(NSArray *)keyPaths options:(int)options onQueue:(NSOperationQueue *)queue withBlock:(TOObservationBlock)block;

/**
 *  Receiver observes multiple KVO key paths on itself, calling its block on the given GCD dispatch queue.
 *
 *  @param keyPaths Array of key path strings to observe on `object`.
 *  @param queue    The GCD dispatch queue on which to call `block`.
 *  @param block    The block to call when any of the key path observations are triggered, is passed the receiver
 *                  (which can be used in place of a weakly captured self), and the observation (same as method result).
 *
 *  @return An observation object. You often don't need to keep this result.
 */
- (TO_nullable TOKVOObservation *)to_observeOwnChangesToKeyPaths:(NSArray *)keyPaths onGCDQueue:(dispatch_queue_t)queue withBlock:(TOObservationBlock)block;

/**
 *  Receiver observes multiple KVO key paths on itself with options, calling its block on the given GCD dispatch queue.
 *
 *  @param keyPaths Array of key path strings to observe on `object`.
 *  @param options  The KVO observation options.
 *  @param queue    The GCD dispatch queue on which to call `block`.
 *  @param block    The block to call when any of the key path observations are triggered, is passed the receiver
 *                  (which can be used in place of a weakly captured self), and the observation (same as method result).
 *
 *  @return An observation object. You often don't need to keep this result.
 */
- (TO_nullable TOKVOObservation *)to_observeOwnChangesToKeyPaths:(NSArray *)keyPaths options:(int)options onGCDQueue:(dispatch_queue_t)queue withBlock:(TOObservationBlock)block;


/**
 *  Receiver stops observing multiple KVO key paths on itself.
 *
 *  Call on the same observed object on which you called one of the `to_observe..` methods above. Use to stop observing
 *  sometime before the object is deallocated. Alternately, can save the observation object returned from the
 *  `to_observe..` method, and call its `remove` method.
 *
 *  @param keyPaths The array of KVO key path strings to stop observing the receiver. Must be equal to the array passed to the
 *                  corresponding `to_observe..` method.
 *
 *  @return `YES` if the receiver was previously observing these KVO key paths on itself, `NO` otherwise.
 */
- (BOOL)to_stopObservingOwnChangesToKeyPaths:(NSArray *)keyPaths;

@end

#if __has_feature(nullability)
NS_ASSUME_NONNULL_END
#endif
#undef TO_nullable
