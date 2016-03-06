//
//  TONotificationObservation.h
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

@interface TONotificationObservation : TOObservation

@property (nonatomic, readonly, copy) NSString *name;

@property (nonatomic, readonly) NSNotification *notification;
@property (nonatomic, readonly, TO_nullable) id postedObject;
@property (nonatomic, readonly, TO_nullable) NSDictionary *userInfo;

// can use this class method to match a prior observation and remove it, although usually more convenient to
// use the 'stopObserving' methods below, or save the observation object and call 'remove' on it
// don't call with both observer & object nil
+ (BOOL)removeForObserver:(TO_nullable id)observer object:(TO_nullable id)object name:(NSString *)name;

@end

@interface TONotificationObservation (Private)
// perhaps these belong in a +Private.h header, there's no reason for users of TO normally to be creating these objects themselves
- (instancetype)initWithObserver:(TO_nullable id)observer object:(TO_nullable id)object name:(NSString *)name onQueue:(TO_nullable NSOperationQueue *)queue orGCDQueue:(TO_nullable dispatch_queue_t)gcdQueue withBlock:(TOObservationBlock)block;
- (instancetype)initWithObserver:(TO_nullable id)observer object:(TO_nullable id)object name:(NSString *)name onQueue:(TO_nullable NSOperationQueue *)queue orGCDQueue:(TO_nullable dispatch_queue_t)gcdQueue withObjBlock:(TOObjObservationBlock)block;
@end

#if __has_feature(nullability)
NS_ASSUME_NONNULL_END
#endif
#undef TO_nullable
