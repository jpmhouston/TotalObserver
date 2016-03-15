//
//  NSObject+TotalObserverUIControl.h
//  TotalObserver
//
//  Created by Pierre Houston on 2016-01-07.
//  Copyright © 2016 Pierre Houston. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TOUIControlObservation.h"

#if __has_feature(nullability)
NS_ASSUME_NONNULL_BEGIN
#define TO_nullable nullable
#else
#define TO_nullable
#endif

@interface NSObject (TotalObserverUIControl)

#pragma mark - Observe touch-up-inside events

/**
 *  Receiver observes touch-up-inside events by a given control.
 *
 *  Details about the event that triggered the observation can be found within the `sender` and `event` properties of
 *  the observation when the block is called.
 *
 *  The observation will automatically be stopped when either the receiver or the control is deallocated.
 *
 *  @param control The control to observe.
 *  @param block   The block to call when observation is triggered, is passed the receiver (which can be used in place of
 *                 a weakly captured self), and the observation (same as method result).
 *
 *  @return An observation object. You often don't need to keep this result.
 */
- (TO_nullable TOUIControlObservation *)to_observeControlForPress:(UIControl *)control withBlock:(TOObservationBlock)block;

/**
 *  Receiver observes touch-up-inside events by a given control, calling its block on the given operation queue.
 *
 *  Variation on `to_observeControlForPress:withBlock:` that adds an operation queue parameter. See the description
 *  for that method.
 *
 *  @param control The control to observe.
 *  @param queue   The operation queue on which to call `block`.
 *  @param block   The block to call when observation is triggered, is passed the receiver (which can be used in place of
 *                 a weakly captured self), and the observation (same as method result).
 *
 *  @return An observation object. You often don't need to keep this result.
 */
- (TO_nullable TOUIControlObservation *)to_observeControlForPress:(UIControl *)control onQueue:(NSOperationQueue *)queue withBlock:(TOObservationBlock)block;

/**
 *  Receiver observes touch-up-inside events by a given control, calling its block on the given GCD dispatch queue.
 *
 *  Variation on `to_observeControlForPress:withBlock:` that adds a GCD dispatch queue parameter. See the description
 *  for that method.
 *
 *  @param control The control to observe.
 *  @param queue   The GCD dispatch queue on which to call `block`.
 *  @param block   The block to call when observation is triggered, is passed the receiver (which can be used in place of
 *                 a weakly captured self), and the observation (same as method result).
 *
 *  @return An observation object. You often don't need to keep this result.
 */
- (TO_nullable TOUIControlObservation *)to_observeControlForPress:(UIControl *)control onGCDQueue:(dispatch_queue_t)queue withBlock:(TOObservationBlock)block;


/**
 *  Receiver stops observing touch-up-inside events by a given control.
 *
 *  Call on the same object on which you called one of the `to_observe..` methods above. Use to stop observing sometime
 *  before the receiver or the control is deallocated. Alternately, can save the observation object returned from the
 *  `to_observe..` method, and call its `remove` method.
 *
 *  @param control The control to stop observing
 *
 *  @return `YES` if the receiver was previously observing touch-up-inside events from the given control, `NO` otherwise.
 */
- (BOOL)to_stopObservingControlForPress:(UIControl *)control;


#pragma mark - Observe value-changed events

/**
 *  Receiver observes value-changed inside events by a given control
 *
 *  Details about the event that triggered the observation can be found within the `sender` and `event` properties of
 *  the observation when the block is called.
 *
 *  The observation will automatically be stopped when either the receiver or the control is deallocated.
 *
 *  @param control The control to observe.
 *  @param block   The block to call when observation is triggered, is passed the receiver (which can be used in place of
 *                 a weakly captured self), and the observation (same as method result).
 *
 *  @return An observation object. You often don't need to keep this result.
 */
- (TO_nullable TOUIControlObservation *)to_observeControlForValue:(UIControl *)control withBlock:(TOObservationBlock)block;

/**
 *  Receiver observes value-changed inside events by a given control, calling its block on the given operation queue.
 *
 *  Variation on `to_observeControlForValue:withBlock:` that adds an operation queue parameter. See the description
 *  for that method.
 *
 *  @param control The control to observe.
 *  @param queue   The operation queue on which to call `block`.
 *  @param block   The block to call when observation is triggered, is passed the receiver (which can be used in place of
 *                 a weakly captured self), and the observation (same as method result).
 *
 *  @return An observation object. You often don't need to keep this result.
 */
- (TO_nullable TOUIControlObservation *)to_observeControlForValue:(UIControl *)control onQueue:(NSOperationQueue *)queue withBlock:(TOObservationBlock)block;

/**
 *  Receiver observes value-changed inside events by a given control, calling its block on the given GCD dispatch queue.
 *
 *  Variation on `to_observeControlForValue:withBlock:` that adds a GCD dispatch queue parameter. See the description
 *  for that method.
 *
 *  @param control The control to observe.
 *  @param queue   The GCD dispatch queue on which to call `block`.
 *  @param block   The block to call when observation is triggered, is passed the receiver (which can be used in place of
 *                 a weakly captured self), and the observation (same as method result).
 *
 *  @return An observation object. You often don't need to keep this result.
 */
- (TO_nullable TOUIControlObservation *)to_observeControlForValue:(UIControl *)control onGCDQueue:(dispatch_queue_t)queue withBlock:(TOObservationBlock)block;


/**
 *  Receiver stops observing value-changed events by a given control.
 *
 *  Call on the same object on which you called one of the `to_observe..` methods above. Use to stop observing sometime
 *  before the receiver or the control is deallocated. Alternately, can save the observation object returned from the
 *  `to_observe..` method, and call its `remove` method.
 *
 *  @param control The control to stop observing
 *
 *  @return `YES` if the receiver was previously observing value-changed events from the given control, `NO` otherwise.
 */
- (BOOL)to_stopObservingControlForValue:(UIControl *)control;


#pragma mark - Observe any events

/**
 *  Receiver observes artbitrary events by a given control.
 *
 *  Details about the event that triggered the observation can be found within the `sender` and `event` properties of
 *  the observation when the block is called.
 *
 *  The observation will automatically be stopped when either the receiver or the control is deallocated.
 *
 *  @param control The control to observe.
 *  @param events  A bitmask of the events to observe.
 *  @param block   The block to call when observation is triggered, is passed the receiver (which can be used in place of
 *                 a weakly captured self), and the observation (same as method result).
 *
 *  @return An observation object. You often don't need to keep this result.
 */
- (TO_nullable TOUIControlObservation *)to_observeControl:(UIControl *)control forEvents:(UIControlEvents)events withBlock:(TOObservationBlock)block;

/**
 *  Receiver observes artbitrary events by a given control, calling its block on the given operation queue.
 *
 *  Variation on `to_observeControl:forEvents:withBlock:` that adds an operation queue parameter. See the description
 *  for that method.
 *
 *  @param control The control to observe.
 *  @param events  A bitmask of the events to observe.
 *  @param queue   The operation queue on which to call `block`.
 *  @param block   The block to call when observation is triggered, is passed the receiver (which can be used in place of
 *                 a weakly captured self), and the observation (same as method result).
 *
 *  @return An observation object. You often don't need to keep this result.
 */
- (TO_nullable TOUIControlObservation *)to_observeControl:(UIControl *)control forEvents:(UIControlEvents)events onQueue:(NSOperationQueue *)queue withBlock:(TOObservationBlock)block;

/**
 *  Receiver observes artbitrary events by a given control, calling its block on the given GCD dispatch queue.
 *
 *  Variation on `to_observeControl:forEvents:withBlock:` that adds a GCD dispatch queue parameter. See the description
 *  for that method.
 *
 *  @param control The control to observe.
 *  @param events  A bitmask of the events to observe.
 *  @param queue   The GCD dispatch queue on which to call `block`.
 *  @param block   The block to call when observation is triggered, is passed the receiver (which can be used in place of
 *                 a weakly captured self), and the observation (same as method result).
 *
 *  @return An observation object. You often don't need to keep this result.
 */
- (TO_nullable TOUIControlObservation *)to_observeControl:(UIControl *)control forEvents:(UIControlEvents)events onGCDQueue:(dispatch_queue_t)queue withBlock:(TOObservationBlock)block;


/**
 *  Receiver stops observing artbitrary events by a given control.
 *
 *  Call on the same object on which you called one of the `to_observe..` methods above. Use to stop observing sometime
 *  before the receiver or the control is deallocated. Alternately, can save the observation object returned from the
 *  `to_observe..` method, and call its `remove` method.
 *
 *  @param control The control to stop observing.
 *  @param events  A bitmask of the events to stop observing. Must be equal to the bitmask passed to the corresponding
 *                 `to_observe..` method.
 *
 *  @return `YES` if the receiver was previously observing the given events from the given control, `NO` otherwise.
 */
- (BOOL)to_stopObservingControl:(UIControl *)control forEvents:(UIControlEvents)events;

@end

#if __has_feature(nullability)
NS_ASSUME_NONNULL_END
#endif
#undef TO_nullable
