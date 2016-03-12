//
//  TOKVOObservation.h
//  TotalObserver
//
//  Created by Pierre Houston on 2016-01-07.
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
 *  A base class for KVO observation objects.
 *
 *  An object of this class is returned from each `TotalObserverKVO` `to_observe...` method. This result can be saved
 *  for explcitly calling the `remove` method later (see base class `TOObservation`), but that often isn't necessary
 *  since the `to_stopObserving...` methods can be used instead which look-up the matching observation.
 *
 *  The observation object is passed as a parameter to the observation block, and defines properties for accessing
 *  the key path, change kind, the change dictionary, or its specific values directly such as old and changed values.
 */
@interface TOKVOObservation : TOObservation

@property (nonatomic, readonly) NSArray *keyPaths;
@property (nonatomic, readonly) NSKeyValueObservingOptions options;

@property (nonatomic, readonly, copy) NSString *keyPath;
@property (nonatomic, readonly) NSDictionary *changeDict;
@property (nonatomic, readonly) NSUInteger kind;
@property (nonatomic, readonly, getter=isPrior) BOOL prior;
@property (nonatomic, readonly, TO_nullable) id changedValue;
@property (nonatomic, readonly, TO_nullable) id oldValue;
@property (nonatomic, readonly, TO_nullable) NSIndexSet *indexes;

/**
 *  Remove an observer with matching parameters. Can use this class method to look-up a previously registered
 *  observation and remove it, although usually more convenient to use the 'to_stopObserving' methods, or save the
 *  observation object and call `remove` on it. (see base class `TOObservation`)
 *
 *  On finding the first matching observation, its `remove` method is called before returning. (see base class
 *  `TOObservation`)
 *
 *  @param observer The observer object, or `nil` if not applicable.
 *  @param object   The object being observed.
 *  @param keyPaths The key path used when creating the observation.
 *
 *  @return `YES` if matching observation was found, `NO` if it was not found.
 */
+ (BOOL)removeForObserver:(TO_nullable id)observer object:(id)object keyPaths:(NSArray *)keyPaths;

@end

@interface TOKVOObservation (Private)
// perhaps these belong in a +Private.h header, there's no reason for users of TO normally to be creating these objects themselves
// and perhaps removeForObserver:.. should also be private
- (instancetype)initWithObserver:(nullable id)observer object:(id)object keyPaths:(NSArray *)keyPaths options:(int)options queue:(nullable NSOperationQueue *)queue gcdQueue:(nullable dispatch_queue_t)gcdQueue block:(TOObservationBlock)block;
- (instancetype)initWithObject:(id)object keyPaths:(NSArray *)keyPaths options:(int)options queue:(nullable NSOperationQueue *)queue gcdQueue:(nullable dispatch_queue_t)gcdQueue block:(TOAnonymousObservationBlock)block;
@end

#if __has_feature(nullability)
NS_ASSUME_NONNULL_END
#endif
#undef TO_nullable
