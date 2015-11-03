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

+ (nullable TOObservation *)observationForHashKey:(NSString *)key withObserver:(id)observer;
@end

@interface TOObservation (PrivateForSubclassesToOverride)
- (void)registerInternal;
- (void)removeInternal;
- (NSString *)hashKey;
@end

#if __has_feature(nullability)
NS_ASSUME_NONNULL_END
#else
#undef nullable
#endif
