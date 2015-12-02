//
//  TOObservation+Private.h
//  TotalObserver
//
//  Created by Pierre Houston on 2015-10-23.
//
//

#import "NSObject+TotalObserver.h"

#if __has_feature(nullability)
NS_ASSUME_NONNULL_BEGIN
#define TO_nullable nullable
#else
#define TO_nullable
#endif

@interface TOObservation (PrivateForCallersToUse)
- (void)register;
@end

@interface TOObservation (PrivateForSubclassesToUse)
- (instancetype)initWithObserver:(TO_nullable id)observer object:(id)object queue:(TO_nullable NSOperationQueue *)queue gcdQueue:(TO_nullable dispatch_queue_t)cgdQeue block:(TOObservationBlock)block;
- (instancetype)initWithObserver:(TO_nullable id)observer object:(id)object queue:(TO_nullable NSOperationQueue *)queue gcdQueue:(TO_nullable dispatch_queue_t)cgdQeue objBlock:(TOObjObservationBlock)block;

- (void)invoke;
- (void)invokeOnQueueAfter:(void(^)(void))setup;

+ (TOObservation *)findObservationForObserver:(TO_nullable id)observer object:(TO_nullable id)object matchingTest:(BOOL(^)(TOObservation *observation))testBlock;

// expected to only be useful for test code
+ (NSSet *)associatedObservationsForObserver:(id)observer;
+ (NSSet *)associatedObservationsForObservee:(id)object;
+ (NSSet *)associatedObservationsForObserver:(TO_nullable id)observer object:(TO_nullable id)object;
@end

@interface TOObservation (PrivateForSubclassesToOverride)
- (void)registerInternal;
- (void)deregisterInternal;
@end

#if __has_feature(nullability)
NS_ASSUME_NONNULL_END
#endif
#undef TO_nullable
