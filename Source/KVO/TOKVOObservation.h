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

// can use this class method to match a prior observation and remove it, although usually more convenient to
// use the 'stopObserving' methods below, or save the observation object and call 'remove' on it
+ (BOOL)removeForObserver:(TO_nullable id)observer object:(id)object keyPaths:(NSArray *)keyPaths;

// perhaps these belong in a +Private.h header, there's no reason for users of TO normally to be creating these objects themselves
- (instancetype)initWithObserver:(nullable id)observer object:(id)object keyPaths:(NSArray *)keyPaths options:(int)options onQueue:(nullable NSOperationQueue *)queue orGCDQueue:(nullable dispatch_queue_t)gcdQueue withBlock:(TOObservationBlock)block;
- (instancetype)initWithObserver:(nullable id)observer object:(id)object keyPaths:(NSArray *)keyPaths options:(int)options onQueue:(nullable NSOperationQueue *)queue orGCDQueue:(nullable dispatch_queue_t)gcdQueue withObjBlock:(TOObjObservationBlock)block;

@end

#if __has_feature(nullability)
NS_ASSUME_NONNULL_END
#endif
#undef TO_nullable
