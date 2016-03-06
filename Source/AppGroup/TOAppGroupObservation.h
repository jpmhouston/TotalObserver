//
//  TOAppGroupObservation.h
//  TotalObserver
//
//  Created by Pierre Houston on 2016-02-23.
//  Copyright © 2016 Pierre Houston. All rights reserved.
//

#import "TOObservation.h"

#if __has_feature(nullability)
NS_ASSUME_NONNULL_BEGIN
#define TO_nullable nullable
#else
#define TO_nullable
#endif

@interface TOAppGroupObservation : TOObservation

@property (nonatomic, readonly, copy) NSString *name;
@property (nonatomic, readonly, TO_nullable) id<NSCoding> payload;

@property (nonatomic, readonly, copy) NSString *groupIdentifier;
@property (nonatomic, readonly) NSDate *postedDate;

// can use this class method to match a prior observation and remove it, although usually more convenient to
// use the 'stopObserving' methods, or save the observation object and call 'remove' on it
+ (BOOL)removeForObserver:(TO_nullable id)observer groupIdentifier:(NSString *)identifier name:(NSString *)name;

// one-time registration of app group identifier, return NO if app not setup as member of the app group
+ (BOOL)registerAppGroup:(NSString *)groupIdentifier;
+ (void)deregisterAppGroup:(NSString *)groupIdentifier;

// posting methods
+ (BOOL)postNotificationNamed:(NSString *)name payload:(TO_nullable id<NSCoding>)payload;
+ (BOOL)postNotificationForAppGroup:(NSString *)groupIdentifier named:(NSString *)name payload:(TO_nullable id<NSCoding>)payload;

@end

@interface TOAppGroupObservation (Private)
// perhaps these belong in a +Private.h header, there's no reason for users of TO normally to be creating these objects themselves
- (instancetype)initWithObserver:(TO_nullable id)observer groupIdentifier:(TO_nullable NSString *)identifier name:(NSString *)name payload:(TO_nullable id<NSCoding>)payload onQueue:(TO_nullable NSOperationQueue *)queue orGCDQueue:(TO_nullable dispatch_queue_t)gcdQueue withBlock:(TOObservationBlock)block;
- (instancetype)initWithObserver:(TO_nullable id)observer groupIdentifier:(TO_nullable NSString *)identifier name:(NSString *)name payload:(TO_nullable id<NSCoding>)payload onQueue:(TO_nullable NSOperationQueue *)queue orGCDQueue:(TO_nullable dispatch_queue_t)gcdQueue withObjBlock:(TOObjObservationBlock)block;
@end

#if __has_feature(nullability)
NS_ASSUME_NONNULL_END
#endif
#undef TO_nullable
