//
//  TOObservation+Private.h
//  TotalObserver
//
//  Created by Pierre Houston on 2015-10-23.
//  Copyright © 2015 Pierre Houston. All rights reserved.
//

#import "TOObservation.h"

#if __has_feature(nullability)
NS_ASSUME_NONNULL_BEGIN
#define TO_nullable nullable
#else
#define TO_nullable
#endif

@interface TOObservation (PrivateForCallersToUse)
/**
 *  Stores the observation as assocaiate objects in the observer & observee objects, calls the `registerInternal`
 *  method, sets up automatic removal, and sets the `registered` property to `YES`.
 *
 *  This should be called during initialization of the observation object, or at least sometime soon after.
 *  In any event, it must be called automatically since, currently, there's no exposed interface for the caller
 *  to perform delayed registration.
 */
- (void)register;
@end

@interface TOObservation (PrivateForSubclassesToUse)

/**
 *  Normally subclasses don't need to, and shouldn't set.
 */
@property (nonatomic, readwrite) BOOL registered;

/**
 *  Initializes and returns a newly allocated observation object with an observer. A designated initializer, don't
 *  call plain `init`.
 *
 *  Only one of `queue` and `cgdQueue` should be non-`nil`, which takes precidence if both are set is undefined.
 *
 *  @param observer The observer object, this will be passed as the first parameter to `block`. By default, when
 *                  this object is deallocated, the observation to be removed automatically.
 *  @param object   The object being observed, how its used is up to subclasses. By default, when this object is
 *                  deallocated, the observation to be removed automatically.
 *  @param queue    An operation queue on which to call the observer block, or `nil` to use no specific operation queue.
 *  @param cgdQueue A GCD queue on which to call the observer block, or `nil` to use no specific operation queue.
 *  @param block    The observation block to be called when the observation is triggered. Normally `nil` not permitted
 *                  and a subclass should itself enforce this (only ok if the subclass adds another type of block
 *                  property).
 *
 *  @return An initialized TOObservation object.
 */
- (instancetype)initWithObserver:(TO_nullable id)observer object:(TO_nullable id)object queue:(TO_nullable NSOperationQueue *)queue gcdQueue:(TO_nullable dispatch_queue_t)cgdQueue block:(TO_nullable TOObservationBlock)block;

/**
 *  Initializes and returns a newly allocated observation object with no observer. A designated initializer, don't
 *  call plain `init`.
 *
 *  Only one of `queue` and `cgdQueue` should be non-`nil`, which takes precidence if both are set is undefined.
 *
 *  @param object   The object being observed, how its used is up to subclasses. By default, calls to its `dealloc`
 *                  method will be observed and cause the observation to be removed automatically.
 *  @param queue    An operation queue on which to call the observer block, or `nil` to use no specific operation queue.
 *  @param cgdQueue A GCD queue on which to call the observer block, or `nil` to use no specific operation queue.
 *  @param block    The observation block to be called when the observation is triggered. Normally `nil` not permitted
 *                  and a subclass should itself enforce this (only ok if the subclass adds another type of block
 *                  property).
 *
 *  @return An initialized TOObservation object.
 */
- (instancetype)initWithObject:(TO_nullable id)object queue:(TO_nullable NSOperationQueue *)queue gcdQueue:(TO_nullable dispatch_queue_t)cgdQueue block:(TO_nullable TOAnonymousObservationBlock)block;


/**
 *  Cause the observation block to be called synchronously.
 *
 *  Use this from code you know is running on the correct operation queue or GCD queue. Also correct to call
 *  this if both `queue` and `cgdQueue` are `nil`.
 */
- (void)invoke;

/**
 *  Cause the observation block to be called on the correct queue.
 *
 *  If both `queue` and `cgdQueue` are `nil`, then this the `setup` block and then the operation block will be
 *  called synchronously before this method returns.
 *
 *  @param setup A block to be called immediately before the observation block is called. Setting properties on
 *               this object related to the triggred observation should be done within this block to avoid races
 *               between multiple observations occurring in rapid succession.
 */
- (void)invokeOnQueueAfter:(void(^)(void))setup;

/**
 *  Cause the observation block to be called on the correct queue with custom invoking code.
 *
 *  If both `queue` and `cgdQueue` are `nil`, then this the `setup` block and then the `invoke` block will be
 *  called synchronously before this method returns.
 *
 *  @param setup  See `invokeOnQueueAfter:`
 *  @param invoke A block called to perform invocation.
 *
 */
- (void)invokeOnQueueAfter:(void(^)(void))setup by:(void(^)(void))invoke;


/**
 *  Look-up an observation based on the same parameters used in its creation.
 *
 *  @param observer  The observer object, or `nil` if not applicable.
 *  @param object    The object being observed, if applicable.
 *  @param testBlock A block to be called to compare additional properties of the observation, will only be called
 *                   with observations whose observer and observee values match.
 *
 *  @return The first matching observation object.
 */
+ (TOObservation *)findObservationForObserver:(TO_nullable id)observer object:(TO_nullable id)object matchingTest:(BOOL(^)(TOObservation *observation))testBlock;

// expected to only be useful for test code:
+ (NSSet *)associatedObservationsForObserver:(id)observer;
+ (NSSet *)associatedObservationsForObservee:(id)object;
+ (NSSet *)associatedObservationsForObserver:(TO_nullable id)observer object:(TO_nullable id)object;
@end


@interface TOObservation (PrivateForSubclassesToOverride)
/**
 *  Perform the specific mechanism to register the observation and cause `invoke` or `invokeOnQueueAfter` to be
 *  called when the specified event is triggered.
 *
 *  This method is called within the call to `register` that a subclass should itself do during initialization.
 *  It should not wait to perform the registration until this method is called and not within its own init
 *  or factory method because... reasons. (Future versions of the base class may have a mechanism whereby
 *  registration is delayed, for one)
 */
- (void)registerInternal;

/**
 *  Perform the specific mechanism to cancel the observation's registeration. This gets called
 */
- (void)deregisterInternal;
@end

#if __has_feature(nullability)
NS_ASSUME_NONNULL_END
#endif
#undef TO_nullable
