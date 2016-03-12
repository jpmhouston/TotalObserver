//
//  TOObservation.h
//  TotalObserver
//
//  Created by Pierre Houston on 2015-10-15.
//  Copyright (c) 2015 Pierre Houston. All rights reserved.
//
//  TODO:
//  - consider adding a "refcon" property to the observation, something the caller can set to anything it wants
//    and then have access to within the observation block. or perhaps that's too old-school?

#import <Foundation/Foundation.h>

#if __has_feature(nullability)
NS_ASSUME_NONNULL_BEGIN
#define TO_nullable nullable
#else
#define TO_nullable
#endif

@class TOObservation;

/**
 *  A block called when an observation is triggered, if that observation has a observing object.
 *
 *  @param obj The observing object. Often this can be used in place of a weak `self` capture.
 *  @param observation The triggered observation object. Details about the observation that was triggered,
 *                     plus any payload or associated metadata will be properties of this object.
 */
typedef void (^TOObservationBlock)(id obj, TOObservation *observation);

/**
 *  A block called when an observation is triggered, if that observation has *no* observing object.
 *
 *  @param observation The triggered observation object. Details about what triggered the observation and
 *                     any payload or associated metadata will be properties of this object.
 */
typedef void (^TOAnonymousObservationBlock)(TOObservation *);


#pragma mark -

/**
 *  A base class for observation objects.
 *
 *  A subclass of this is returned from each `to_observe...` method. This result can be saved for explcitly calling
 *  the `remove` method later, but that often isn't necessary since the `to_stopObserving...` methods can be used
 *  instead which look-up the matching observation.
 *
 *  The observation object is more often used when it's passed as a parameter to the observation block, subclasses
 *  define properties which provide details about what observation was triggered, plus any payload or associated
 *  metadata.
 */
@interface TOObservation : NSObject

/**
 *  The object doing the observing which was provided when the observation was created, when applicable.
 *  Can be nil if observation setup with an anonymous block. (read-only)
 *
 *  If `removeAutomatically` property is not `NO` and `observer` is not `nil`, then when that object is deallocated,
 *  this observation will automatically be removed and released.
 */
@property (nonatomic, readonly, weak, TO_nullable) id observer;

/**
 *  Object being observed, a.k.a. the observee which was provided when the observation was created, when applicable.
 *  Can be nil if specific observation method lacks an observation object. (read-only)
 *
 *  If `removeAutomatically` property is not `NO` and `object` is not `nil`, then when that object is deallocated,
 *  this observation will automatically be removed and released.
 *
 *  Never is both this and `observer` allowed to be nil.
 */
@property (nonatomic, readonly, weak, TO_nullable) id object;

/**
 *  The `NSOperationQueue` that was provided when the observation was created, on which the block will be executed
 *  when observation is triggered. Can be `nil` if a GCD queue is to be used instead. (read-only)
 *
 *  If both this and `gcdQueue` are `nil`, then the queue and thread the block is executed on is undefined.
 */
@property (nonatomic, readonly, TO_nullable) NSOperationQueue *queue;

/**
 *  The GCD queue that was provided when the observation was created, on which the block will be executed when the
 *  observation is triggered. Can be `nil` if an observation queue is to be used instead. (read-only)
 *
 *  If both this and `queue` are nil, then the queue and thread the block is executed on is undefined.
 */
@property (nonatomic, readonly, TO_nullable) dispatch_queue_t gcdQueue;

/**
 *  The block provided when the observation was created, which will be executed when the observation is triggered.
 *  Can be `nil` if the observation was created with no observer, and thus the other form of block. (read-only)
 *
 *  What events trigger an observation is left up to subclasses.
 *
 *  Between this and `block`, one will always be nil, the other not.
 */
@property (nonatomic, readonly, copy, TO_nullable) TOObservationBlock objectBlock;

/**
 *  The anonymous block provided when the observation was created, which will be executed when the observation is
 *  triggered. Can be `nil` if an observation was created with an observer object, and thus the other form of block.
 *  (read-only)
 *
 *  What events trigger an observation is left up to subclasses.
 *
 *  Between this and `objectBlock`, one will always be nil, the other not.
 */
@property (nonatomic, readonly, copy, TO_nullable) TOAnonymousObservationBlock anonymousBlock;

/**
 *  Whether the observation is still active. (read-only)
 *
 *  Will be `YES` after the observation has been created and before `remove` has been called, `NO` after `remove`
 *  has been called either manually or automatically.
 */
@property (nonatomic, readonly) BOOL registered;

/**
 *  Whether the observation should be removed automatically upon either the observer or observee being deallocated.
 *  Set to `NO` to prevent automatic removal. (default is `YES`)
 *
 *  If not being removed automatically, then the caller is taking responsibility for calling the `remove` method
 *  when objects are deallocated and the observation becomes invalid. The impact of not doing so may or may not
 *  be harmful depending on the particular observation subclass, but will at least result in the observation object
 *  not being released.
 *
 *  NB: there's no opportunity for the caller to set this property before `dealloc` methods are swizzled on observer
 *  and observee objects. If hoping to set this property  to `NO` to avoid swizzling being used on your objects,
 *  there's no way at the moment.
 */
@property (nonatomic) BOOL removeAutomatically;

/**
 *  Explicitly remove, or deregister, the observation.
 *
 *  After calling this method, the observation will never trigger and execute its block property. Also, the internal
 *  strong reference to the observation will be cleared and if no other strong reference to it exists, it will be
 *  deallocated.
 */
- (void)remove;

@end

#if __has_feature(nullability)
NS_ASSUME_NONNULL_END
#endif
#undef TO_nullable
