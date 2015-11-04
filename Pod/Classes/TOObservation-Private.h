//
//  TOObservation-Private.h
//  Pods
//
//  Created by Pierre Houston on 2015-10-23.
//
//

#import "NSObject+TotalObserver.h"

#if __has_feature(nullability)
NS_ASSUME_NONNULL_BEGIN
#else
#define nullable
#endif

@interface TOObservation (PrivateForCallersToUse)
- (void)register;
@end

@interface TOObservation (PrivateForSubclassesToUse)
- (instancetype)initWithObserver:(nullable id)observer object:(id)object queue:(nullable NSOperationQueue *)queue block:(TOObservationBlock)block;
- (instancetype)initWithObserver:(nullable id)observer object:(id)object queue:(nullable NSOperationQueue *)queue objBlock:(TOObjObservationBlock)block;

- (void)invoke;

+ (TOObservation *)findObservationForObserver:(nullable id)observer object:(nullable id)object matchingTest:(BOOL(^)(TOObservation *observation))testBlock;

// expected to only be useful for test code
+ (NSSet *)associatedObservationsForObserver:(id)observer;
+ (NSSet *)associatedObservationsForObservee:(id)object;
+ (NSSet *)associatedObservationsForObserver:(nullable id)observer object:(nullable id)object;
@end

@interface TOObservation (PrivateForSubclassesToOverride)
- (void)registerInternal;
- (void)deregisterInternal;
@end

#if __has_feature(nullability)
NS_ASSUME_NONNULL_END
#else
#undef nullable
#endif
