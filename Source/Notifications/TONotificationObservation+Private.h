//
//  TONotificationObservation+Private.h
//  TotalObserver
//
//  Created by Pierre Houston on 2016-03-16.
//  Copyright © 2016 Pierre Houston. All rights reserved.
//

#import "TONotificationObservation.h"

#if __has_feature(nullability)
NS_ASSUME_NONNULL_BEGIN
#define TO_nullable nullable
#else
#define TO_nullable
#endif

@interface TONotificationObservation (Private)

- (instancetype)initWithObserver:(TO_nullable id)observer object:(TO_nullable id)object name:(NSString *)name queue:(TO_nullable NSOperationQueue *)queue gcdQueue:(TO_nullable dispatch_queue_t)gcdQueue block:(TOObservationBlock)block;
- (instancetype)initWithObject:(TO_nullable id)object name:(NSString *)name queue:(TO_nullable NSOperationQueue *)queue gcdQueue:(TO_nullable dispatch_queue_t)gcdQueue block:(TOAnonymousObservationBlock)block;

// TODO: consider making this private too
//+ (BOOL)removeForObserver:(TO_nullable id)observer object:(TO_nullable id)object name:(NSString *)name;

@end

#if __has_feature(nullability)
NS_ASSUME_NONNULL_END
#endif
#undef TO_nullable
