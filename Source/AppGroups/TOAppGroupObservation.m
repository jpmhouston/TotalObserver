//
//  TOAppGroupObservation.m
//  TotalObserver
//
//  Created by Pierre Houston on 2016-02-23.
//  Copyright © 2016 Pierre Houston. All rights reserved.
//

#import "TOAppGroupObservation.h"
#import "TOAppGroupObservation+Private.h"
#import "TOObservation+Private.h"
#import "TOAppGroupNotificationManager.h"

#if __has_feature(nullability)
NS_ASSUME_NONNULL_BEGIN
#else
#define nullable
#endif

@interface TOAppGroupObservation () <NSCopying>
@property (nonatomic, readwrite) NSString *name;
@property (nonatomic, readwrite, nullable) id payload;

@property (nonatomic, readwrite, weak, nullable) TOAppGroupObservation *originalObservation;

@property (nonatomic, readwrite) NSString *groupIdentifier;
@property (nonatomic, readwrite) NSDate *postedDate;

@property (nonatomic) BOOL retainStateOnRemoval;
@end

@implementation TOAppGroupObservation

@dynamic reliable;

- (instancetype)initWithObserver:(nullable id)observer groupIdentifier:(nullable NSString *)identifier name:(NSString *)name queue:(nullable NSOperationQueue *)queue orGCDQueue:(nullable dispatch_queue_t)gcdQueue withBlock:(TOObservationBlock)block
{
    if (!(self = [super initWithObserver:observer object:nil queue:queue gcdQueue:gcdQueue block:block]))
        return nil;
    _name = name.copy;
    _groupIdentifier = identifier.copy;
    _retainStateOnRemoval = NO;
    return self;
}

- (instancetype)initForReliableDeliveryWithObserver:(nullable id)observer groupIdentifier:(nullable NSString *)identifier name:(NSString *)name queue:(nullable NSOperationQueue *)queue gcdQueue:(nullable dispatch_queue_t)gcdQueue block:(TOCollatedObservationBlock)block
{
    if (!(self = [super initWithObserver:observer object:nil queue:queue gcdQueue:gcdQueue block:nil]))
        return nil;
    _name = name.copy;
    _groupIdentifier = identifier.copy;
    _collatedBlock = block;
    _retainStateOnRemoval = YES;
    return self;
}

- (instancetype)copyWithZone:(nullable NSZone *)zone
{
    // since not publically confirming to NSCopying, don't expect user code trying to make copies of copies
    NSAssert1(self.originalObservation == nil, @"Attempted copy of copy of %@", self.originalObservation);
    
    TOAppGroupObservation *copy = [[[self class] alloc] initWithObserver:self.observer object:nil queue:self.queue gcdQueue:self.gcdQueue block:nil];
    if (!copy)
        return nil;
    copy.name = self.name;
    copy.groupIdentifier = self.groupIdentifier;
    copy.originalObservation = self;
    return copy;
}

- (BOOL)isReliable
{
    return self.collatedBlock != nil;
}

- (void)remove
{
    if (self.originalObservation != nil) {
        [self.originalObservation remove];
        self.registered = self.originalObservation.registered;
    }
    else {
        [super remove];
    }
}

- (void)removeStoppingReliableCollection
{
    if (self.originalObservation != nil) {
        self.originalObservation.retainStateOnRemoval = NO;
        [self.originalObservation remove];
        self.registered = self.originalObservation.registered;
    }
    else {
        self.retainStateOnRemoval = NO;
        [super remove];
    }
}

- (void)registerInternal
{
    NSAssert1(self.originalObservation == nil, @"Attempted double-register of %@ via one of its copies", self.originalObservation);
    
    NSAssert1(!self.registered, @"Attempted double-register of %@", self);
    NSAssert1(self.name != nil, @"Nil 'name' property when registering observation for %@", self);
    NSAssert1(self.name.length > 0, @"Empty 'name' string when registering observation for %@", self);
    
    TOAppGroupNotificationManager *appGroupNotificationManager = [TOAppGroupNotificationManager sharedManager];
    NSString *groupIdentifier = self.groupIdentifier;
    if (groupIdentifier == nil) {
        groupIdentifier = appGroupNotificationManager.defaultGroupIdentifier;
        if (groupIdentifier == nil) {
            return;
        }
    }
    
    BOOL ok;
    if (self.collatedBlock != nil)
    {
        ok = [appGroupNotificationManager subscribeToReliableNotificationsForGroupIdentifier:groupIdentifier named:self.name withBlock:^(NSString *identifier, NSString *name, NSArray *postDatesAndPayloads) {
            NSMutableArray *observationCopies = [NSMutableArray array];
            id lastPayload = nil;
            NSDate *lateDate = nil;
            for (NSArray *postDateAndPayload in postDatesAndPayloads) {
                TOAppGroupObservation *observationCopy = self.copy;
                observationCopy.payload = (postDateAndPayload.count > 1 ? postDateAndPayload[1] : nil);
                observationCopy.postedDate = postDateAndPayload.firstObject;
                observationCopy.groupIdentifier = groupIdentifier;
                [observationCopies addObject:observationCopy];
            }
            [self invokeOnQueueAfter:^{
                self.payload = lastPayload;
                self.postedDate = lateDate ?: [NSDate date];
                if (self.groupIdentifier == nil || ![self.groupIdentifier isEqualToString:groupIdentifier]) {
                    self.groupIdentifier = groupIdentifier;
                }
            } by:^{
                self.collatedBlock(self.observer, observationCopies);
            }];
        }];
    }
    else
    {
        ok = [appGroupNotificationManager subscribeToNotificationsForGroupIdentifier:groupIdentifier named:self.name withBlock:^(NSString *identifier, NSString *name, id payload, NSDate *postDate) {
            [self invokeOnQueueAfter:^{
                self.payload = payload;
                self.postedDate = postDate;
                if (self.groupIdentifier == nil || ![self.groupIdentifier isEqualToString:groupIdentifier]) {
                    self.groupIdentifier = groupIdentifier;
                }
            }];
        }];
    }
    
    if (!ok) {
        NSLog(@"failed to register observation %@", self);
    }
}

- (void)deregisterInternal
{
    NSAssert1(self.originalObservation == nil, @"Attempted removal of %@ via one of its copies", self.originalObservation);
    
    NSAssert1(self.registered, @"Attempted double-removal of %@", self);
    NSAssert1(self.name != nil, @"Nil 'name' property when deregistering observation for %@", self);
    NSAssert1(self.name.length > 0, @"Empty 'name' string when deregistering observation for %@", self);
    
    TOAppGroupNotificationManager *appGroupNotificationManager = [TOAppGroupNotificationManager sharedManager];
    NSString *groupIdentifier = self.groupIdentifier;
    if (groupIdentifier == nil) {
        groupIdentifier = appGroupNotificationManager.defaultGroupIdentifier;
        if (groupIdentifier == nil) {
            return;
        }
    }
    
    BOOL ok;
    if (self.reliable) {
        ok = [appGroupNotificationManager unsubscribeFromReliableNotificationsForGroupIdentifier:groupIdentifier named:self.name allowingReliableResumption:self.retainStateOnRemoval];
    }
    else {
        ok = [appGroupNotificationManager unsubscribeFromNotificationsForGroupIdentifier:groupIdentifier named:self.name];
    }
    
    if (!ok) {
        NSLog(@"failed to deregister observation %@", self);
    }
}

+ (BOOL)removeForObserver:(id)observer groupIdentifier:(nullable NSString *)identifier name:(NSString *)name
{
    return [self removeForObserver:observer groupIdentifier:identifier name:name updatingRetainStateMode:nil]; // nil to use the default retaining behavior
}

+ (BOOL)removeForObserver:(id)observer groupIdentifier:(nullable NSString *)identifier name:(NSString *)name retainingState:(BOOL)retainState
{
    return [self removeForObserver:observer groupIdentifier:identifier name:name updatingRetainStateMode:&retainState];
}

+ (BOOL)removeForObserver:(id)observer groupIdentifier:(nullable NSString *)identifier name:(NSString *)name updatingRetainStateMode:(nullable BOOL *)inRetainState
{
    TOAppGroupNotificationManager *appGroupNotificationManager = [TOAppGroupNotificationManager sharedManager];
    NSString *groupIdentifier = appGroupNotificationManager.defaultGroupIdentifier;
    if (groupIdentifier == nil) {
        return NO;
    }
    
    TOAppGroupObservation *observation = (TOAppGroupObservation *)[self findObservationForObserver:observer object:nil matchingTest:^BOOL(TOObservation *observation) {
        TOAppGroupObservation *groupObservation = (TOAppGroupObservation *)observation;
        return [observation isKindOfClass:[TOAppGroupObservation class]] && [name isEqualToString:groupObservation.name] && [groupIdentifier isEqualToString:groupObservation.groupIdentifier];
    }];
    if (observation != nil) {
        NSAssert([observation isKindOfClass:[TOAppGroupObservation class]], @"");
        if (inRetainState != nil && observation.reliable) {
            observation.retainStateOnRemoval = *inRetainState;
        }
        [observation remove];
        return YES;
    }
    return NO;
}

+ (BOOL)postNotificationNamed:(NSString *)name payload:(nullable id)payload
{
    TOAppGroupNotificationManager *appGroupNotificationManager = [TOAppGroupNotificationManager sharedManager];
    NSString *groupIdentifier = appGroupNotificationManager.defaultGroupIdentifier;
    if (groupIdentifier == nil) {
        return NO;
    }
    [appGroupNotificationManager postNotificationForGroupIdentifier:groupIdentifier named:name payload:payload];
    return YES;
}

+ (BOOL)postNotificationForAppGroup:(NSString *)groupIdentifier named:(NSString *)name payload:(nullable id)payload
{
    TOAppGroupNotificationManager *appGroupNotificationManager = [TOAppGroupNotificationManager sharedManager];
    return [appGroupNotificationManager postNotificationForGroupIdentifier:groupIdentifier named:name payload:payload];
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
    TOAppGroupNotificationManager *appGroupNotificationManager = [TOAppGroupNotificationManager sharedManager];
    [appGroupNotificationManager removeGroupIdentifier:groupIdentifier];
}

- (NSString *)description
{
    if (self.originalObservation != nil)
        return [NSString stringWithFormat:@"<%@ %p copy %p: obs=%p, n=%@>", NSStringFromClass([self class]), self.originalObservation, self, self.observer, self.name];
    else
        return [NSString stringWithFormat:@"<%@ %p: obs=%p, n=%@>", NSStringFromClass([self class]), self, self.observer, self.name];
}

@end

#if __has_feature(nullability)
NS_ASSUME_NONNULL_END
#else
#undef nullable
#endif
