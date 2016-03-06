//
//  TOAppGroupObservation.m
//  TotalObserver
//
//  Created by Pierre Houston on 2016-02-23.
//  Copyright © 2016 Pierre Houston. All rights reserved.
//

#import "TOAppGroupObservation.h"
#import "TOObservation+Private.h"
#import "TOAppGroupNotificationManager.h"

#if __has_feature(nullability)
NS_ASSUME_NONNULL_BEGIN
#else
#define nullable
#endif

@interface TOAppGroupObservation ()
@property (nonatomic, readwrite, copy) NSString *name;
@property (nonatomic, readwrite) id<NSCoding> payload;

@property (nonatomic, readwrite, copy) NSString *groupIdentifier;
@property (nonatomic, readwrite) NSDate *postedDate;
@end

@implementation TOAppGroupObservation

- (instancetype)initWithObserver:(nullable id)observer groupIdentifier:(nullable NSString *)identifier name:(NSString *)name payload:(nullable id<NSCoding>)payload onQueue:(nullable NSOperationQueue *)queue orGCDQueue:(nullable dispatch_queue_t)gcdQueue withBlock:(TOObservationBlock)block
{
    if (!(self = [super initWithObserver:observer object:nil queue:queue gcdQueue:gcdQueue block:block]))
        return nil;
    _name = name;
    _groupIdentifier = identifier;
    return self;
}

- (instancetype)initWithObserver:(nullable id)observer groupIdentifier:(nullable NSString *)identifier name:(NSString *)name payload:(nullable id<NSCoding>)payload onQueue:(nullable NSOperationQueue *)queue orGCDQueue:(nullable dispatch_queue_t)gcdQueue withObjBlock:(TOObjObservationBlock)block
{
    if (!(self = [super initWithObserver:observer object:nil queue:queue gcdQueue:gcdQueue objBlock:block]))
        return nil;
    _name = name;
    _groupIdentifier = identifier;
    return self;
}

- (void)registerInternal
{
    NSAssert1(!self.registered, @"Attempted double-register of %@", self);
    NSAssert1(self.name != nil, @"Nil 'name' property when registering observation for %@", self);
    NSAssert1(self.name.length > 0, @"Empty 'name' string when registering observation for %@", self);
    // !!!
}

- (void)deregisterInternal
{
    NSAssert1(self.registered, @"Attempted double-removal of %@", self);
    NSAssert1(self.name != nil, @"Nil 'name' property when deregistering observation for %@", self);
    NSAssert1(self.name.length > 0, @"Empty 'name' string when deregistering observation for %@", self);
    // !!!
}

+ (BOOL)removeForObserver:(nullable id)observer groupIdentifier:(NSString *)identifier name:(NSString *)name
{
    TOObservation *observation = [self findObservationForObserver:observer object:nil matchingTest:^BOOL(TOObservation *observation) {
        return [((TOAppGroupObservation *)observation).name isEqualToString:name];
    }];
    if (observation != nil) {
        [observation remove];
        return YES;
    }
    return NO;
}

+ (BOOL)postNotificationNamed:(NSString *)name payload:(nullable id<NSCoding>)payload
{
    TOAppGroupNotificationManager *appGroupNotificationManager = [TOAppGroupNotificationManager sharedManager];
    NSString *groupIdentifier = [appGroupNotificationManager defaultGroupIdentifier];
    if (groupIdentifier == nil) {
        return NO;
    }
    [appGroupNotificationManager postNotificationForGroupIdentifier:groupIdentifier named:name payload:payload];
    return YES;
}

+ (BOOL)postNotificationForAppGroup:(NSString *)groupIdentifier named:(NSString *)name payload:(nullable id<NSCoding>)payload
{
    TOAppGroupNotificationManager *appGroupNotificationManager = [TOAppGroupNotificationManager sharedManager];
    [appGroupNotificationManager postNotificationForGroupIdentifier:groupIdentifier named:name payload:payload];
    return YES;
}

+ (BOOL)registerAppGroup:(NSString *)groupIdentifier
{
    TOAppGroupNotificationManager *appGroupNotificationManager = [TOAppGroupNotificationManager sharedManager];
    if (![appGroupNotificationManager isValidGroupIdentifier:groupIdentifier]) {
        return NO;
    }
    [appGroupNotificationManager addGroupIdentifier:groupIdentifier];
    return YES;
}

+ (void)deregisterAppGroup:(NSString *)groupIdentifier
{
    [[TOAppGroupNotificationManager sharedManager] removeGroupIdentifier:groupIdentifier];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"<%@ %p: obs=%p, n=%@>", NSStringFromClass([self class]), self, self.observer, self.name];
}

@end

#if __has_feature(nullability)
NS_ASSUME_NONNULL_END
#else
#undef nullable
#endif
