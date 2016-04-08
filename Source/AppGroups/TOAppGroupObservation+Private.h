//
//  TOAppGroupObservation+Private.h
//  TotalObserver
//
//  Created by Pierre Houston on 2016-03-16.
//  Copyright © 2016 Pierre Houston. All rights reserved.
//

#import "TOAppGroupObservation.h"

#if __has_feature(nullability)
NS_ASSUME_NONNULL_BEGIN
#define TO_nullable nullable
#else
#define TO_nullable
#endif

@interface TOAppGroupObservation (Private)

- (instancetype)initWithObserver:(TO_nullable id)observer groupIdentifier:(TO_nullable NSString *)identifier name:(NSString *)name queue:(TO_nullable NSOperationQueue *)queue gcdQueue:(TO_nullable dispatch_queue_t)gcdQueue block:(TOObservationBlock)block;
- (instancetype)initForReliableDeliveryWithObserver:(TO_nullable id)observer groupIdentifier:(TO_nullable NSString *)identifier name:(NSString *)name queue:(TO_nullable NSOperationQueue *)queue gcdQueue:(TO_nullable dispatch_queue_t)gcdQueue block:(TOCollatedObservationBlock)block;

// TODO: consider making these private too
//+ (BOOL)removeForObserver:(id)observer groupIdentifier:(TO_nullable NSString *)identifier name:(NSString *)name;
//+ (BOOL)removeForObserver:(id)observer groupIdentifier:(TO_nullable NSString *)identifier name:(NSString *)name retainingState:(BOOL)retainState;

@end

#if __has_feature(nullability)
NS_ASSUME_NONNULL_END
#endif
#undef TO_nullable
